#!/bin/sh
# Claude Code SessionStart 훅 — 킷 세션 부트스트랩 (식별·자가 점검·예외 기반 문답 지시)
# startup·clear에서만 발화(resume·compact·fork 침묵). 항상 exit 0 — stdout이 세션 컨텍스트로 주입된다.
# ※ SessionStart 훅 입력에는 permission_mode가 없다(실측: session_id·cwd·hook_event_name·source·transcript_path뿐)
#    — 모드 인지 방어는 PreToolUse(guard-governance)·PostToolUse(notify-unattended-edit) 층이 담당한다.
INPUT=$(cat 2>/dev/null)
SRC=$(printf '%s' "$INPUT" | jq -r '.source // empty' 2>/dev/null)
case "$SRC" in startup|clear) ;; *) exit 0 ;; esac
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0

WARN=0
echo "[킷 세션 부트스트랩] 이 세션은 스타터킷(.claude-starter-kit) 거버넌스 적용 세션이다."

HOOKSPATH=$(git config core.hooksPath 2>/dev/null)
if [ "$HOOKSPATH" = ".githooks" ]; then
  echo "- core.hooksPath: .githooks (정상)"
else
  echo "- core.hooksPath: ${HOOKSPATH:-미설정} ⚠ (커밋 게이트 비활성)"
  WARN=1
fi

BRANCH=$(git -C "$ROOT" branch --show-current 2>/dev/null)
echo "- 브랜치: ${BRANCH:-감지 불가}"

echo ""
echo "[Claude 첫 턴 행동 지시]"
if [ "$WARN" -eq 1 ]; then
  echo "- ⚠ 항목이 있다: 본 작업 착수 전에 해당 항목만 사용자에게 확인·요청한다."
  [ "$HOOKSPATH" != ".githooks" ] && echo "  - hooksPath 미설정 → 'git config core.hooksPath .githooks' 실행을 제안하고 승인받아 즉시 교정한다."
else
  echo "- 점검 전부 정상: 첫 응답 서두에 킷 세션임을 한 줄로 알리고 바로 본 작업을 진행한다."
fi
echo "- 권한 모드는 이 훅에 제공되지 않는다 — 보호 경로 작업 예정이면 사용자에게 default 모드(상태바) 여부를 확인한다. 무인·자동 승인 모드 세션이라면 보호 경로를 수정하지 않는다(doc-governance) — 수정 시 감사 기록·사후 보고 훅이 발화한다."
exit 0
