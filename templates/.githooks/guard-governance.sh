#!/bin/sh
# Claude Code PreToolUse 훅 — 문서 거버넌스 가드
# ① 구조 위반 "신설"만 차단(exit 2 = 차단, stderr가 Claude에게 사유로 전달)
# ② 무인·자동 승인 모드의 보호 경로 "편집"은 감사 기록 — 사후 보고 짝: notify-unattended-edit.sh(PostToolUse)
#    (훅의 확인 강제〔permissionDecision:"ask"〕도 무인 모드에선 자동 승인됨을 실측 — 확인 대신 감사·보고로 방어)
# 유인 모드의 편집 확인은 settings.json permissions.ask 가 담당(계층 분리).
. "$(dirname "$0")/protected-paths.sh"   # is_protected_path() — 보호 경로 단일 출처
INPUT=$(cat 2>/dev/null)
FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
MODE=$(printf '%s' "$INPUT" | jq -r '.permission_mode // "unknown"' 2>/dev/null)
[ -z "$FILE" ] && exit 0

# 리포 밖 경로는 이 가드의 대상이 아니다
ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
case "$FILE" in
  "$ROOT"/*) REL=${FILE#"$ROOT"/} ;;
  *) exit 0 ;;
esac

if [ -e "$FILE" ]; then
  # ── 킷 골격 스냅샷: 생성 이후 "편집" 금지 (신규 생성은 허용 — 생성 시점 배치)
  case "$REL" in
    .claude-starter-kit/templates/*)
      echo "차단: 킷 골격 스냅샷은 생성 이후 편집하지 않는다($REL) — 이 폴더는 리포가 어느 판으로 생성됐는지를 남기는 기록이며 전파 대상이 아니다. 값·규약 변경은 참조층(허브·docs·rules·skills)과 실물에서 하고, 판을 올려야 하면 킷 재실행으로 폴더를 통째 교체한다" >&2
      exit 2 ;;
  esac
  # ── 편집: 무인·자동 승인 모드에서 보호 경로면 감사 기록 후 통과
  case "$MODE" in
    auto|dontAsk|bypassPermissions)
      if is_protected_path "$REL"; then
        printf '%s\t%s\t%s\n' "$(date -Iseconds)" "$MODE" "$REL" >> "$ROOT/.claude/unattended-edits.log"
      fi ;;
  esac
  exit 0
fi

# ── 신설 검사
# ⓐ 화이트리스트(루트·등록된 서브) 외 CLAUDE.md 신설 차단
case "$REL" in
  CLAUDE.md|{{SUB_CLAUDE_MD}}|.claude-starter-kit/templates/CLAUDE.md) ;;
  CLAUDE.md/*|*/CLAUDE.md)
    echo "차단: 화이트리스트 외 CLAUDE.md 신설($REL) — 서브 CLAUDE.md 신설은 PR로 제안한다 (문서 거버넌스, 하위 /init 금지)" >&2
    exit 2 ;;
esac

# ⓑ 서브 프로젝트 doc/·docs/ 하위 md 신설 차단
#    허용: 루트 docs/
case "$REL" in
  docs/*|.claude-starter-kit/templates/docs/*) ;;
  *doc/*.md|*docs/*.md)
    if printf '%s' "$REL" | grep -qE '(^|/)docs?/.*\.md$'; then
      echo "차단: 컨벤션 체계 밖 문서 신설($REL) — 규약·가이드 문서는 리포 루트 docs/ 아래(컨벤션은 docs/conventions/ + INDEX.md 등록)에 둔다 (문서 거버넌스)" >&2
      exit 2
    fi ;;
esac

exit 0
