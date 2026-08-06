# {{STACK_LABEL}} 스택 컨벤션 — {{STACK_TITLE}}

> 대상: {{STACK_PATHS}}. Claude 자동 주입용 집행 요약은 `.claude/rules/{{STACK_SLUG}}.md`.
> **아래 "검증된 조합" 표가 이 리포 {{STACK_LABEL}} 스택 버전의 단일 출처다.**

## 검증된 조합 (실측 — {{GEN_DATE}})

| 항목 | 값 | 확인 방법 |
|---|---|---|
{{STACK_VERSION_ROWS}}

† = 협의·미확정. 확정되면 이 표를 먼저 고치고 `change-propagation` 스킬로 전파한다.

## 도구 체인

| 목적 | 명령 |
|---|---|
{{STACK_COMMAND_ROWS}}

- 검증 명령은 **완료를 주장하기 전에 실행**한다(constitution ②). 실행하지 않고 통과를 적지 않는다.
- 런타임·언어 버전은 {{STACK_VERSION_PIN}} 으로 고정한다.

## 린터·포매터

- 린트 **{{LINTER}}** · 포맷 **{{FORMATTER}}** · 줄 길이 **{{LINE_LENGTH}}**.
- 줄 길이는 **린터와 포매터에 같은 값**을 넣는다 — 다르면 두 도구가 서로의 결과를 되돌린다.
- 편집 직후 PostToolUse 훅 `.githooks/format-on-edit.sh` 가 자동수정을 실행하고, 커밋 시 `.githooks/pre-commit` 이 **한 번 더 자동수정을 적용해 재스테이징**하고, **자동수정 불가 위반만** 차단한다.
- **종료코드 기준**: {{LINT_EXIT_NOTE}}

## 타입 검사

{{TYPE_CHECK_BLOCK}}

## 테스트

- 프레임워크 **{{TEST_FRAMEWORK}}**.
- **배치 규약**: {{TEST_LAYOUT}} — 이 스택 생태계의 관례를 따른다. 다른 스택의 관례를 가져오지 않는다.
- 최소 골격: 헬스체크 1건. 새 공개 모듈에는 테스트를 함께 둔다.
- 실행: `{{TEST_CMD}}`

## 소스 구조

{{STACK_LAYOUT_BLOCK}}

- 소스 트리를 늘리면 pre-commit 린트 대상 패턴과 `.claude/rules/{{STACK_SLUG}}.md` 의 `paths` 를 **같은 커밋에서 함께** 고친다(지도표 등재 항목).

<!-- 생성 안내(배치 후 이 주석은 지운다):
  - 배치 경로 `docs/conventions/<스택 슬러그>.md` — 슬러그는 `.claude/rules/<같은 슬러그>.md` 와 **반드시 일치**시킨다(짝으로 전파된다).
  - 도구·줄 길이·테스트 프레임워크·소스 배치는 **§4-S 표준표를 그대로** 쓴다. 관리자가 바꾼 항목만 다르게 채우고 지도표에 등재한다.
  - "검증된 조합" 값은 **실측한다** — 매니페스트·lock 파일을 읽거나 `--version` 을 실행해 채운다. 추정값을 적지 않는다.
  - **게이트 서술은 `.githooks/pre-commit` 원문과 대조해 쓴다** — 골격 문구를 그대로 옮기지 말고, 훅이 실제로 하는 일(자동수정 후 통과 / 재검사 / 차단 조건)을 읽어 맞춘다.
  - 린터의 종료코드 기준을 실측해 `{{LINT_EXIT_NOTE}}` 를 채운다. 경고 등급으로 통과하는 도구면 승격 옵션과 그 이유를 적는다(§0-6 실측 예 ②).
  - `{{TYPE_CHECK_BLOCK}}`: 컴파일러가 타입을 검사하는 스택(TypeScript·Java·Go 등)은 그 사실과 검사 명령을 적고, 별도 도구가 필요한 스택(Python 등)은 도구·설정·실행 명령을 적는다. 해당 없으면 이 절을 통째로 지운다.
  - `{{STACK_LAYOUT_BLOCK}}`: **소스가 한 트리라고 가정하지 않는다.** 그 스택의 표준 디렉토리 배치를 그대로 적는다(예: Maven Standard Directory Layout은 main/test가 갈린다).
-->
