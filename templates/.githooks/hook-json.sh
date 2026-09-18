#!/bin/sh
# Claude Code 훅 입력(JSON) 파서 — 단일 출처. 다섯 훅이 source 한다.
#
# jq 가 있으면 jq 로, 없으면 grep/sed 폴백으로 **동작을 계속한다.**
# 훅이 값 하나를 못 읽었다고 조용히 통과하면 「검사 대상이 아니다」와 구별되지 않는다.
# 부재 사실은 HOOK_JSON_PARSER 에 남고 session-bootstrap 이 ⚠ 로 알린다.

# 값: jq | fallback.
case "${HOOK_JSON_PARSER_FORCE:-}" in
  jq|fallback) HOOK_JSON_PARSER=$HOOK_JSON_PARSER_FORCE ;;
  *)
    if command -v jq >/dev/null 2>&1; then
      HOOK_JSON_PARSER=jq
    else
      HOOK_JSON_PARSER=fallback
    fi ;;
esac

# hook_field <JSON> <jq 필터> <폴백 키>
#   문자열 값 하나를 낸다. 없으면 빈 문자열.
#
#   폴백은 **첫 매치**를 취하고 중첩 위치를 보지 않는다 — 훅 입력에서 이 키들(file_path·
#   permission_mode·source·session_id·transcript_path)은 한 번만 나오므로 jq 필터의 경로
#   부분(`.tool_input.`)은 폴백에서 무시된다.
#
#   한계: 값 안의 이스케이프(`\"`·`\\`)를 풀지 않는다. 경로형 필드는 아래 hook_path() 가
#   `\\` 만 되돌리므로 Windows 경로는 안전하지만, 값에 `\"` 가 섞이면 여전히 잘못 읽는다.
#   이 한계 때문에 jq 설치를 권장으로 둔다(MEMBER-BOOTSTRAP STEP ①).
#
#   **항상 종료코드 0 이다** — `set -e` 를 쓰는 훅이 값이 없다는 이유로 죽지 않게 한다.
#   「없음」은 오류가 아니라 빈 문자열로 표현한다.
hook_field() {
  if [ "$HOOK_JSON_PARSER" = jq ]; then
    printf '%s' "$1" | jq -r "$2 // empty" 2>/dev/null || true
    return 0
  fi

  printf '%s' "$1" |
    grep -o "\"$3\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" |
    head -1 |
    sed 's/^[^:]*:[[:space:]]*"//; s/"$//' || true
  return 0
}

# normalize_hook_path <경로>
#   Windows drive/UNC 절대경로만 정슬래시로 통일한다. POSIX 에서는 역슬래시가
#   합법적인 파일명 문자이므로, POSIX 경로의 역슬래시는 그대로 둔다.
normalize_hook_path() {
  value=$1
  case "$value" in
    [A-Za-z]:[\\/]*)
      drive=$(printf '%s' "$value" | cut -c 1 | tr '[:lower:]' '[:upper:]')
      rest=${value#??}
      rest=$(printf '%s' "$rest" | tr '\\' '/')
      printf '%s:%s' "$drive" "$rest" ;;
    \\\\*)
      printf '%s' "$value" | tr '\\' '/' ;;
    *)
      printf '%s' "$value" ;;
  esac
}

# hook_path <JSON> <jq 필터> <폴백 키>
#   hook_field 로 읽은 경로를 JSON 문자열 값으로 복원한 뒤 플랫폼 비교용으로
#   정규화한다. jq 는 JSON 이스케이프를 이미 해제하므로 폴백에서만 처리한다.
hook_path() {
  value=$(hook_field "$1" "$2" "$3")
  if [ "$HOOK_JSON_PARSER" = fallback ]; then
    value=$(printf '%s' "$value" | sed 's/\\\\/\\/g')
  fi
  normalize_hook_path "$value"
  return 0
}
