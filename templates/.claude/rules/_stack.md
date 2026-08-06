---
paths:
{{STACK_PATHS_YAML}}
---

# {{STACK_LABEL}} 스택 규칙 — 집행 요약 ({{STACK_PATHS}} 작업 시 자동 주입)

> 정본: `docs/conventions/{{STACK_SLUG}}.md` — 근거·상세·버전 표는 정본 참조.

- 검증 명령은 {{STACK_VERIFY_CMDS}} — **실행해 결과를 확인한 뒤에만** 통과를 주장한다(constitution ②).
- 린트 **{{LINTER}}** · 포맷 **{{FORMATTER}}**. 편집 직후 PostToolUse 훅이 자동수정을 돌리고, 커밋 시 pre-commit이 비수정 모드로 재검사해 남은 위반을 차단한다.
- **스택 버전은 `docs/conventions/{{STACK_SLUG}}.md` 의 "검증된 조합" 표가 단일 출처다.** 임의 업그레이드·추가 설치를 하지 않는다.
- 테스트는 **{{TEST_FRAMEWORK}}** — {{TEST_LAYOUT}}. 새 공개 모듈에는 테스트를 함께 둔다.
- 소스 배치: {{STACK_LAYOUT_SUMMARY}}. 트리를 늘리면 pre-commit 린트 패턴과 이 파일의 `paths` 를 같은 커밋에서 함께 고친다.
- 코드 주석은 한국어, 식별자·파일명은 영문(`docs/conventions/code-style.md`).

<!-- 생성 안내(배치 후 이 주석은 지운다):
  - 배치 경로 `.claude/rules/<스택 슬러그>.md` — 슬러그는 `docs/conventions/<같은 슬러그>.md` 와 일치시킨다.
  - `paths` 는 **YAML 리스트**, 값은 리포 루트 기준 glob. 소스가 여러 트리인 스택(Java 의 main/test 등)은 **행을 여러 개** 쓴다.
  - 이 파일은 **집행 요약**이다 — 근거·버전 표·설정 상세를 여기에 복제하지 않는다. 정본 링크로 보낸다.
-->
