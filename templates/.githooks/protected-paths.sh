#!/bin/sh
# 보호 경로 — 단일 출처. guard-governance.sh(PreToolUse)·notify-unattended-edit.sh(PostToolUse)가 공유한다.
#
# 목록을 바꿀 때 같은 변경 단위로 함께 고칠 곳 (이 파일 포함 3곳):
#   ① 이 파일  ② .claude/settings.json 의 permissions.ask (Edit 폼 — 형식이 달라 공유 불가)
#   ③ .claude/rules/doc-governance.md 의 공통 참조 문서 목록 (사람·Claude가 읽는 요약)
#
# 왜 함수인가: case 패턴을 변수로 넘기면 값 안의 `|` 가 대체 구분자로 해석되지 않아
# 통째로 한 개의 리터럴 패턴이 된다(실측). 목록 공유는 함수로만 가능하다.
is_protected_path() {
  case "$1" in
    CLAUDE.md|{{SUB_CLAUDE_MD}}|docs/constitution.md|docs/conventions/*|.claude-starter-kit/*|.claude/rules/*|.claude/skills/*|.claude/settings.json|.githooks/*|.github/pull_request_template.md|MEMBER-BOOTSTRAP.md)
      return 0 ;;
  esac
  return 1
}
