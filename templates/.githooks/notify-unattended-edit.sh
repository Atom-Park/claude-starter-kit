#!/bin/sh
# Claude Code PostToolUse 훅 — 무인·자동 승인 모드의 보호 경로 수정 사후 보고 의무
# 수정은 이미 실행된 뒤다(PostToolUse) — exit 2의 stderr가 Claude에게 피드백으로 전달된다. 짝: guard-governance.sh(감사 기록).
. "$(dirname "$0")/protected-paths.sh"   # is_protected_path() — 보호 경로 단일 출처
. "$(dirname "$0")/hook-json.sh"         # hook_field() — jq→폴백. jq 부재로 조용히 죽지 않는다
INPUT=$(cat 2>/dev/null)
FILE=$(hook_field "$INPUT" '.tool_input.file_path' 'file_path')
MODE=$(hook_field "$INPUT" '.permission_mode' 'permission_mode')
[ -n "$MODE" ] || MODE=unknown
[ -z "$FILE" ] && exit 0
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
case "$FILE" in
  "$ROOT"/*) REL=${FILE#"$ROOT"/} ;;
  *) exit 0 ;;
esac
case "$MODE" in auto|dontAsk|bypassPermissions) ;; *) exit 0 ;; esac
if is_protected_path "$REL"; then
  echo "알림: 무인·자동 승인 모드($MODE)에서 보호 경로($REL)가 수정됐다 — 이 수정을 최종 보고에 명시하고, 커밋 전 사용자 확인을 받아라. 감사 기록: .claude/unattended-edits.log" >&2
  exit 2
fi
exit 0
