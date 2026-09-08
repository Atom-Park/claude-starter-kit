#!/bin/sh
# Claude Code 훅 입력(JSON) 파서 — 단일 출처. 다섯 훅이 source 한다.
#
# jq 가 있으면 jq 로, 없으면 grep/sed 폴백으로 **동작을 계속한다.**
# 훅이 값 하나를 못 읽었다고 조용히 통과하면 「검사 대상이 아니다」와 구별되지 않는다.
# 부재 사실은 HOOK_JSON_PARSER 에 남고 session-bootstrap 이 ⚠ 로 알린다.

# 값: jq | fallback.
if command -v jq >/dev/null 2>&1; then
  HOOK_JSON_PARSER=jq
else
  HOOK_JSON_PARSER=fallback
fi

# hook_field <JSON> <jq 필터> <폴백 키>
#   문자열 값 하나를 낸다. 없으면 빈 문자열.
#
#   폴백은 **첫 매치**를 취하고 중첩 위치를 보지 않는다 — 훅 입력에서 이 키들(file_path·
#   permission_mode·source·session_id·transcript_path)은 한 번만 나오므로 jq 필터의 경로
#   부분(`.tool_input.`)은 폴백에서 무시된다.
#
#   한계: 값 안의 이스케이프(`\"`·`\\`)를 풀지 않는다. 리눅스·WSL 경로에는 나타나지 않지만,
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
