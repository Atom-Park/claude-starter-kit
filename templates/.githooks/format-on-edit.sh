#!/bin/sh
# Claude Code PostToolUse 훅 — 소스 편집 시 자동수정 포맷/린트 (스택 기준 치환)
# stdin: 훅 JSON. 실패해도 편집을 막지 않는다 (항상 exit 0).
FILE=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
case "$FILE" in
  {{FE_SRC_CASE}})
    ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
    {{FORMAT_CMD}}
    ;;
esac
exit 0
