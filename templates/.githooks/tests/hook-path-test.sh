#!/bin/sh
# hook-json.sh 의 경로 정규화 회귀 테스트 — 스택 무관·플랫폼 무관.
#
# 왜 있나: Windows 의 Claude Code 는 `tool_input.file_path` 를 역슬래시 절대경로로 준다.
# 훅은 저장소 소속 판정을 `"$ROOT"/*` 접두 비교로 하므로, 정규화가 빠지면 보호 경로
# 차단·감사 기록·사후 보고가 **조용히** 통과한다(오류도 로그도 남지 않는다).
# 그 침묵을 리눅스·WSL 에서도 잡아내는 것이 이 테스트의 목적이다.
#
# 범위는 순수 함수(hook_path·normalize_hook_path)까지다 — 훅 전체 시나리오는 저장소
# ROOT 가 Windows 형태여야 재현되는데, POSIX 호스트에서는 그 상태를 만들 수 없다.
# 여기서는 호스트 jq 설치 여부와 무관하게 jq·폴백 두 경로를 모두 결정적으로 검증한다.
#
# 실행: sh .githooks/tests/hook-path-test.sh   (실패 시 종료코드 1)

set -u

TEST_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
HOOK_DIR=$(CDPATH= cd -- "$TEST_DIR/.." && pwd)
FAILURES=0
PASSES=0

pass() { PASSES=$((PASSES + 1)); printf 'ok - %s\n' "$1"; }
fail() { FAILURES=$((FAILURES + 1)); printf 'not ok - %s\n  %s\n' "$1" "$2" >&2; }
assert_equal() {
  if [ "$2" = "$3" ]; then pass "$1"; else fail "$1" "expected=<$2> actual=<$3>"; fi
}

TMP_BASE=$(mktemp -d "${TMPDIR:-/tmp}/hook-path-test.XXXXXX") || exit 1
trap 'rm -rf "$TMP_BASE"' EXIT HUP INT TERM
mkdir -p "$TMP_BASE/bin"

# 호스트에 jq 가 없어도 jq 분기를 검증해야 한다 — 이 스텁은 실제 jq 처럼
# JSON 이스케이프를 풀어 값 하나를 낸다(폴백은 풀지 않는다는 차이가 핵심이다).
cat > "$TMP_BASE/bin/jq" <<'EOF'
#!/bin/sh
filter=$2
case "$filter" in
  .tool_input.file_path*) key=file_path ;;
  .transcript_path*) key=transcript_path ;;
  *) exit 1 ;;
esac
printf '%s' "$(cat)" |
  grep -o "\"$key\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" |
  head -1 |
  sed 's/^[^:]*:[[:space:]]*"//; s/"$//; s/\\\\/\\/g'
EOF
chmod +x "$TMP_BASE/bin/jq"
PATH="$TMP_BASE/bin:$PATH"
export PATH

# 파서 모드를 명시해 hook_path 를 부른다 — 서브셸이라 호출자 환경을 더럽히지 않는다.
path_from_json() {
  (
    HOOK_JSON_PARSER_FORCE=$1; export HOOK_JSON_PARSER_FORCE
    # shellcheck source=../hook-json.sh
    . "$HOOK_DIR/hook-json.sh"
    hook_path "$2" '.tool_input.file_path' 'file_path'
  ) 2>/dev/null
}
selected_parser() {
  (
    HOOK_JSON_PARSER_FORCE=$1; export HOOK_JSON_PARSER_FORCE
    . "$HOOK_DIR/hook-json.sh"
    printf '%s' "$HOOK_JSON_PARSER"
  )
}

for mode in jq fallback; do
  assert_equal "$mode 파서를 강제 선택할 수 있다" "$mode" "$(selected_parser "$mode")"

  # 드라이브 경로 — 구분자 통일 + 드라이브 문자 대문자화.
  # 케이싱까지 맞춰야 `f:` 와 `F:` 가 ROOT 접두 비교에서 갈리지 않는다.
  assert_equal "$mode 드라이브 경로와 드라이브 케이싱을 정규화한다" 'F:/Repo/File.ts' \
    "$(path_from_json "$mode" '{"tool_input":{"file_path":"f:\\Repo\\File.ts"}}')"

  # UNC 는 선행 `//` 가 의미를 갖는다 — 축약하면 다른 경로가 된다.
  assert_equal "$mode UNC 선행 슬래시를 보존한다" '//server/share/file.ts' \
    "$(path_from_json "$mode" '{"tool_input":{"file_path":"\\\\server\\share\\file.ts"}}')"

  # POSIX 에서 역슬래시는 합법적인 파일명 문자다 — 건드리면 없는 경로를 만든다.
  assert_equal "$mode POSIX 역슬래시 파일명을 바꾸지 않는다" '/tmp/a\b.md' \
    "$(path_from_json "$mode" '{"tool_input":{"file_path":"/tmp/a\\b.md"}}')"

  # 이미 정슬래시인 Windows 경로·평범한 POSIX 경로는 의미가 바뀌면 안 된다.
  assert_equal "$mode 정슬래시 드라이브 경로를 그대로 둔다" 'F:/Repo/File.ts' \
    "$(path_from_json "$mode" '{"tool_input":{"file_path":"F:/Repo/File.ts"}}')"
  assert_equal "$mode POSIX 절대경로를 그대로 둔다" '/home/u/repo/CLAUDE.md' \
    "$(path_from_json "$mode" '{"tool_input":{"file_path":"/home/u/repo/CLAUDE.md"}}')"

  # 값이 없으면 빈 문자열 — 훅은 이걸 「검사 대상 아님」으로 읽고 통과한다.
  assert_equal "$mode 빈 경로를 빈 문자열로 낸다" '' \
    "$(path_from_json "$mode" '{}')"

  # 공백이 섞여도 잘리지 않아야 한다.
  assert_equal "$mode 공백 포함 Windows 경로를 정규화한다" 'F:/Repo With Space/File.ts' \
    "$(path_from_json "$mode" '{"tool_input":{"file_path":"f:\\Repo With Space\\File.ts"}}')"

  # 폴백은 JSON 의 `\\` 를 풀지 않는다 — 그대로 치환하면 `F://Repo//...` 가 된다.
  # 이 단정이 jq·폴백 양쪽에서 같은 값을 요구해 그 차이를 덮는다.
  assert_equal "$mode 이중 역슬래시가 중복 슬래시를 만들지 않는다" 'F:/Repo/Sub/File.ts' \
    "$(path_from_json "$mode" '{"tool_input":{"file_path":"F:\\Repo\\Sub\\File.ts"}}')"
done

if [ "$FAILURES" -ne 0 ]; then
  printf '# %s passed, %s failed\n' "$PASSES" "$FAILURES" >&2
  exit 1
fi
printf '# %s passed, 0 failed\n' "$PASSES"
