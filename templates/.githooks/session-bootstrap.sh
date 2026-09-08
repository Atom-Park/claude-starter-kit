#!/bin/sh
# Claude Code SessionStart 훅 — 킷 세션 부트스트랩 (식별·자가 점검·예외 기반 문답 지시)
# startup·clear에서만 발화(resume·compact·fork 침묵). 항상 exit 0 — stdout이 세션 컨텍스트로 주입된다.
# ※ SessionStart 훅 입력에는 permission_mode가 없다(실측: session_id·cwd·hook_event_name·source·transcript_path뿐)
#    — 모드 인지 방어는 PreToolUse(guard-governance)·PostToolUse(notify-unattended-edit) 층이 담당한다.
. "$(dirname "$0")/hook-json.sh"   # hook_field()·HOOK_JSON_PARSER — jq 부재로 조용히 죽지 않는다
INPUT=$(cat 2>/dev/null)
SRC=$(hook_field "$INPUT" '.source' 'source')
case "$SRC" in startup|clear) ;; *) exit 0 ;; esac
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0

WARN=0
echo "[킷 세션 부트스트랩] 이 세션에는 리포 거버넌스가 적용된다 — 허브 CLAUDE.md · .claude/rules · .githooks."

HOOKSPATH=$(git config core.hooksPath 2>/dev/null)
if [ "$HOOKSPATH" = ".githooks" ]; then
  echo "- core.hooksPath: .githooks (정상)"
else
  echo "- core.hooksPath: ${HOOKSPATH:-미설정} ⚠ (커밋 게이트 비활성)"
  WARN=1
fi

# jq 부재는 조용히 넘기지 않는다 — 훅은 폴백 파서로 계속 돌지만 값에 따옴표·역슬래시가 섞이면
# 잘못 읽는다. 훅 층 전체에서 이 사실이 사람 눈에 닿는 유일한 자리다.
if [ "$HOOK_JSON_PARSER" != jq ]; then
  echo "- jq: 미설치 ⚠ (훅은 폴백 파서로 동작 — 값 파싱이 취약하다)"
  WARN=1
else
  echo "- jq: 설치됨 (정상)"
fi

BRANCH=$(git -C "$ROOT" branch --show-current 2>/dev/null)
echo "- 브랜치: ${BRANCH:-감지 불가}"

echo ""
echo "[Claude 첫 턴 행동 지시]"
if [ "$WARN" -eq 1 ]; then
  echo "- ⚠ 항목이 있다: 본 작업 착수 전에 해당 항목만 사용자에게 확인·요청한다."
  [ "$HOOKSPATH" != ".githooks" ] && echo "  - hooksPath 미설정 → 'git config core.hooksPath .githooks' 실행을 제안하고 승인받아 즉시 교정한다."
  [ "$HOOK_JSON_PARSER" != jq ] && echo "  - jq 미설치 → 설치를 제안한다(선택 사항 — 훅은 폴백으로 동작한다). 훅 안에서는 TTY 가 없어 비밀번호를 받지 못하므로 사용자가 Claude Code 밖 터미널에서 실행해야 한다."
else
  echo "- 점검 전부 정상: 첫 응답 서두에 킷 세션임을 한 줄로 알리고 바로 본 작업을 진행한다."
fi
echo "- 권한 모드는 이 훅에 제공되지 않는다 — 보호 경로 작업 예정이면 사용자에게 default 모드(상태바) 여부를 확인한다. 무인·자동 승인 모드 세션이라면 보호 경로를 수정하지 않는다(doc-governance) — 수정 시 감사 기록·사후 보고 훅이 발화한다."
exit 0
