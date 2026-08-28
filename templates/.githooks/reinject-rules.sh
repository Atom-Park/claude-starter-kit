#!/bin/sh
# UserPromptSubmit 훅 — 규약 재주입
#
# 왜: CLAUDE.md 와 .claude/rules/* 는 세션 시작에 "한 번" 주입된다. 대화가 길어지면 그 자리를
# 직전 대화의 관성이 밀어내고, 규약이 조용히 누락된다. 훅이 지키는 규칙은 매 호출마다 다시
# 실행돼 끝까지 지켜지고, 문서만으로 있는 규칙만 뚫린다. 그래서 "매번 실행되는 자리"에서
# 원본을 다시 읽어 준다.
#
# 트리거는 시간이 아니라 컨텍스트 증가량이다 — 컨텍스트는 시간으로 자라지 않으므로 시간 기준은
# 사용자가 쉬는 동안 토큰만 버린다. transcript 파일 크기가 도구 출력까지 포함해 실제 압박을 잰다.
#
# 사본을 만들지 않는다 — 원본을 그대로 낸다. 요약을 훅에 적어 넣으면 그게 곧 사본이고,
# 규약이 바뀔 때 한쪽만 고쳐져 어긋난다(CLAUDE.md 「하지 말 것」).

set -eu

ROOT="${CLAUDE_PROJECT_DIR:-.}"

# 임계값 — 환경변수로 덮을 수 있다.
BYTES=${REINJECT_BYTES:-500000}      # transcript 증가 500KB 마다
MIN_TURNS=${REINJECT_MIN_TURNS:-3}   # 도구 폭주 구간에서 매 지시마다 뜨지 않게
MAX_TURNS=${REINJECT_MAX_TURNS:-15}  # 바이트가 안 차도 대화가 길면 한 번

INPUT=$(cat 2>/dev/null || true)

# 훅 입력(JSON)에서 값 추출 — jq 없이도 동작해야 한다(팀원 환경 가정 최소화).
field() {
  printf '%s' "$INPUT" | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" | head -1
}

SESSION=$(field session_id)
TRANSCRIPT=$(field transcript_path)
[ -n "$SESSION" ] || SESSION="unknown"

STATE_DIR="${TMPDIR:-/tmp}/claude-reinject-$(id -u)"
mkdir -p "$STATE_DIR" 2>/dev/null || true
STATE="$STATE_DIR/$SESSION"

size=0
[ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ] && size=$(wc -c < "$TRANSCRIPT" 2>/dev/null || echo 0)

turns=0
last_size=0
if [ -f "$STATE" ]; then
  read -r turns last_size < "$STATE" 2>/dev/null || true
  [ -n "$turns" ] || turns=0
  [ -n "$last_size" ] || last_size=0
fi
turns=$((turns + 1))

grown=$((size - last_size))
[ "$grown" -ge 0 ] || grown=0

# 첫 지시들은 SessionStart 주입이 방금 끝난 참이라 건너뛴다.
if [ "$turns" -lt "$MIN_TURNS" ]; then
  printf '%s %s\n' "$turns" "$last_size" > "$STATE"
  exit 0
fi

if [ "$grown" -lt "$BYTES" ] && [ "$turns" -lt "$MAX_TURNS" ]; then
  printf '%s %s\n' "$turns" "$last_size" > "$STATE"
  exit 0
fi

printf '0 %s\n' "$size" > "$STATE"

# ── 재주입 ── 원본을 그대로 낸다.
echo "[규약 재주입] 세션이 길어져 아래가 컨텍스트에서 밀렸을 수 있다. 이것이 정본이다."
echo
[ -f "$ROOT/CLAUDE.md" ] && cat "$ROOT/CLAUDE.md"
for f in "$ROOT"/.claude/rules/*.md; do
  [ -f "$f" ] || continue
  echo
  echo "--- .claude/rules/$(basename "$f")"
  cat "$f"
done
