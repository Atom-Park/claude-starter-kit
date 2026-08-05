#!/bin/sh
# Claude Code SessionStart 훅 — docs/personal 자산 목록을 세션 컨텍스트로 자동 주입
# 폴더가 비어 있으면 아무것도 출력하지 않는다 (항상 exit 0).
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
FILES=$(find "$ROOT/docs/personal" -type f ! -name 'README.md' 2>/dev/null | sed "s|^$ROOT/||" | sort)
if [ -n "$FILES" ]; then
  echo "[개인 자산 폴더 docs/personal 현재 파일 목록 — 관련 작업 시 우선 참조할 것]"
  printf '%s\n' "$FILES"
fi
exit 0
