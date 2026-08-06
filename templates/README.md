# templates/ — 강제 장치·골격 원문 (치환 복사 전용)

> **성격**: 실측 검증이 끝난 강제 장치·골격(훅·settings·규칙·**스킬 절차**·PR 템플릿·허브/부트스트랩)과 **`docs/` 구조 골격**의 **원문**이다.
> **이 폴더의 트리가 곧 리포 구조다** — 산문으로 구조를 설명하는 대신 파일이 놓인 자리로 규정한다(초안 §0-1 복사 원칙). 리포 생성(초안 §4-P)·업그레이드(초안 재실행) 시
> 이 폴더를 리포에 **미러 복사**하고 치환자만 값으로 바꾼다 — **임의 재작성 금지**(초안 §0-1).
> 문맥 의존 문서(컨벤션·constitution·지도표)는 여기 없다 — 초안 §2 답변을 반영해 §4가 직접 생성한다.

## 배치 규칙

1. 이 폴더의 파일을 **리포 루트 기준 같은 경로**로 복사한다(README 제외). 예: `templates/.githooks/pre-commit` → `<리포>/.githooks/pre-commit`
2. 복사 후 치환자(`{{...}}`)를 아래 치환표대로 값 치환한다. 해당 없음(예: 서브 CLAUDE.md 없음)이면 그 항목·패턴 대안을 제거한다.
3. 셸 스크립트는 실행 권한을 부여한다: `chmod +x .githooks/*`
3-1. **`docs/` 구조 — 고정과 적응**
   - **고정(이름·위치를 바꾸지 않는다)**: `docs/concepts/` · `docs/conventions/` · `docs/designs/` · `docs/personal/` · `docs/constitution.md`. 특히 **`docs/conventions/INDEX.md`는 `.githooks/pre-commit` ⓒ와 `guard-governance.sh`가 경로를 그대로 검사**하므로 이름을 바꾸면 게이트가 조용히 헛돈다.
   - **적응 허용**: 스택이 둘 이상이면 `docs/conventions/` 아래를 하위 폴더로 분화해도 된다(예: `backend/`·`frontend/`). 등재는 `INDEX.md` 한 곳에 모은다.
3-2. 골격 안의 `<!-- 생성 안내 ... -->` 주석은 내용을 채운 뒤 **지운다**. **생성기에게 하는 지시는 반드시 이 형식으로만 쓴다** — 본문·인용문에 섞어 두면 삭제 규칙에 걸리지 않아 배포본에 남고, 팀원이 읽는 문서에 "이 절을 제거하라"가 그대로 나간다.
4. `.gitignore`에 `.claude/unattended-edits.log` 를 등재한다(감사 로그 — 커밋 금지).
5. 훅 활성화: `git config core.hooksPath .githooks` (git pre-commit) · `.claude/settings.json`의 hooks 등록(Claude 훅)은 **다음 세션부터 효력**.
6. 리포의 `.claude-starter-kit/` 에 **변경 지도표 하나만** 만든다(형식·시드는 생성 규약 §4-G). 머리말에 생성 흔적을 한 줄 적는다 — `> 생성: claude-starter-kit v<플러그인 버전> (<날짜>)`.

## 파일 목록

| 템플릿 | 배치 경로 | 성격 |
|---|---|---|
| `.githooks/pre-commit` | 동일 | 커밋 게이트 — 거버넌스 3검사(불변) + 린트 게이트(치환) |
| `.githooks/protected-paths.sh` | 동일 | **보호 경로 단일 출처** — `is_protected_path()`, 아래 두 훅이 source |
| `.githooks/guard-governance.sh` | 동일 | PreToolUse — 신설 차단(exit 2) + 무인 모드 보호 경로 감사 기록 |
| `.githooks/session-bootstrap.sh` | 동일 | SessionStart(startup·clear) — 킷 세션 식별·자가 점검 주입 |
| `.githooks/notify-unattended-edit.sh` | 동일 | PostToolUse — 무인 모드 보호 경로 수정 사후 보고 의무 |
| `.githooks/format-on-edit.sh` | 동일 | PostToolUse — 소스 편집 자동 포맷(스택 치환) |
| `.githooks/list-personal-assets.sh` | 동일 | SessionStart — docs/personal 목록 주입(불변) |
| `.claude/settings.json` | 동일 | defaultMode·보호 경로 ask(Edit 폼)·deny·훅 등록 골격 |
| `.claude/rules/doc-governance.md` | 동일 | 무조건 로드 규칙(문서 거버넌스 집행 요약) |
| `.claude/skills/change-propagation/SKILL.md` | 동일 | 절차층 — 규칙·값 변경 전파 6단계(호출 시 로드) |
| `.claude/skills/commit-and-pr/SKILL.md` | 동일 | 절차층 — 커밋·PR 실행 절차(호출 시 로드) |
| `.github/pull_request_template.md` | 동일 | PR 본문 골격 |
| `.editorconfig` | 리포 루트 | 에디터 공통 — 스택 블록만 치환 |
| `.gitignore` | 리포 루트 | 개인층 경로 고정 7행 + 스택 블록 치환 |
| `docs/constitution.md` | 동일 | 헌법 골격 — 머리말·게이트 문구 고정, 원칙만 치환 |
| `docs/conventions/INDEX.md` | 동일 | **컨벤션 단일 인덱스 — 이름·위치 고정**(게이트가 이 경로를 검사) |
| `docs/personal/README.md` | 동일 | 개인 자산 폴더 안내(이 폴더에서 유일한 커밋 파일) |
| `docs/concepts/glossary.md` | 동일 | 용어 사전 — 공통 구조·장치 용어 고정, 리포 고유 행만 치환 |
| `docs/designs/.gitkeep` | 동일 | 폴더 존재 보장 |
| `CLAUDE.md` | 리포 루트 | 허브 골격 — 구조부만, 내용부는 생성 결합 |
| `MEMBER-BOOTSTRAP.md` | 리포 루트 | 팀원 개인 셋팅 골격 |

## 치환표

| 치환자 | 의미 | 예 |
|---|---|---|
| `{{REPO}}` | 리포명 (Q7) | — |
| `{{REPO_DESC}}` | **한 줄** 설명 (Q7) — 표지용. 여러 줄이면 `{{REPO_OVERVIEW}}`에 쓴다 | — |
| `{{REPO_OVERVIEW}}` | 구조 절 머리의 개요 (§2-B '허브 개요 골자') — 리포가 무엇이고 무엇이 작업 무대인지. 없으면 행 제거 | — |
| `{{ORG}}` | 조직/팀 이름 (Q1) | — |
| `{{SUB_CLAUDE_MD}}` | 등록된 서브 CLAUDE.md 경로 — 없으면 항목·패턴 대안 제거, 복수면 나열 | `ui/CLAUDE.md` |
| `{{SUB_HUB_LINK}}` | 서브 허브 링크 줄 — 등록된 서브 CLAUDE.md가 있으면 `- **서브 허브**: [경로](경로) — <담당·성격>` 1줄, 없으면 **행 자체를 제거**. 운영 원칙 ⑥(허브에서 링크)의 집행 자리다 | — |
| `{{SUB_CLAUDE_MD_REGEX}}` | 위 경로의 정규식 이스케이프형 | `ui/CLAUDE\.md` |
| `{{PKG_MGR}}` | 패키지 매니저 명령 (스택 선택) | `pnpm` |
| `{{STAGED_SRC_REGEX}}` | pre-commit 린트 대상 파일 정규식 | `^src/.*\.(ts|tsx)$` |
| `{{LINT_FIX_BLOCK}}` | 자동수정 린트 실행 블록 (스택 선택 — **도구명을 밝히는 echo부터** 자동수정·불가 시 차단까지 한 블록). `{{FORMAT_CMD}}`와 같은 제약: **패키지 루트에서 실행**하고, 스테이징 경로는 리포 루트 기준이므로 접두를 제거해 넘긴다 | — |
| `{{FE_SRC_CASE}}` | format-on-edit 대상 case 패턴 | `*/src/*.ts\|*/src/*.tsx` |
| `{{FORMAT_CMD}}` | 편집 자동수정 명령 (스택 선택) — **린터 바이너리가 해석되는 패키지 루트에서 실행**해야 한다(`(cd "$ROOT/<패키지>" && …)`). 모노레포 루트에서 바로 부르면 조용히 무동작한다 | — |
| `{{VERIFY_CMDS}}` | PR 검증 명령 나열 | `lint · build` |
| `{{BOUNDARY_CHECK}}` | 수정 경계 **한 줄 점검 문구** — PR 체크박스·스킬 보고 항목용(예: `수정 경계 준수 — <경계 밖 영역> 변경 없음`). 경계 없으면 항목 제거 | — |
| `{{BOUNDARY_DECL}}` | 수정 경계 **선언문** — 허브용, 여러 줄 가능(수정 대상/무접촉 영역을 나눠 적는다). 경계 없으면 절 자체를 제거 | — |
| `{{DEP_INSTALL}}` | 의존성 설치 명령 나열 (스택 선택) | — |
| `{{PLUGIN_TABLE}}` | 플러그인 용도별 표 (Q3·Q6). **이 표가 플러그인 목록의 정본**이다 — 별도 문서를 만들지 않는다. 표 아래에 "이 표가 정본 — 변경은 PR로" 한 줄과 설치 방법을 함께 적는다 | 이름 / 무엇을 주나 / 언제 도움이 되나 |
| `{{MAP_TABLE}}` | 이 리포의 지도표 파일명 (스킬) | `propagation-map-<리포>.md` |
| `{{REPO_PITFALLS}}` | 전파 시 이 리포에서 놓치기 쉬운 것 — 없으면 줄 제거, 실행하며 축적 | — |
| `{{ISSUE_SOURCE}}` | 이슈번호 소스 — 없으면 스킬의 0단계 절 제거 | `노션 PM Task DB "<DB명>"` |
| `{{ISSUE_SNAPSHOT}}` | 이슈 목록 스냅샷 문서의 경로·성격 — 관리자가 Q9로 자료를 준 경우에만 존재한다. 없으면 `{{ISSUE_SOURCE}}`와 함께 0단계 절을 통째로 제거 | `` `docs/conventions/issues.md`(정적 스냅샷) `` |
| `{{TYPE_SCOPE}}` | git.md의 type·scope 표 지시 문구 | `type 표(8종)·scope 표` |
| `{{PR_SECTIONS}}` | PR 템플릿이 요구하는 절 나열 | `관련 이슈 · 주요 변경사항` |
| `{{MERGE_COND}}` | 머지 조건 | `검증 통과 + 승인 1` |
| `{{CONSTITUTION_PRINCIPLES}}` | constitution 원칙 3~5개 번호 목록 (Q8) | `1. 모든 산출물 문서는 한국어로 작성한다.` |
| `{{REPO_WORK_RULES}}` | 리포 고유 작업 규약 — 골격 5항 다음부터 이어 붙인다(6·7…). 없으면 행 제거. **판을 올려 재생성할 때 리포 고유 규약이 유실되지 않게 하는 자리** | — |
| `{{REPO_DONTS}}` | 리포 고유 '하지 말 것' 불릿 — 없으면 행 제거. 위와 같은 이유로 유지한다 | — |
| `{{REPO_GLOSSARY_ROWS}}` | 리포 고유 용어 표 행 — 모듈·패키지·경계 등 (생성 시 작성, 없으면 행 제거) | — |
| `{{CONVENTION_ROWS}}` | INDEX.md 표 행 — 생성한 컨벤션 문서마다 1행 | `\| [git.md](git.md) \| 전역 \| 커밋·게이트·브랜치·PR \|` |
| `{{EDITORCONFIG_STACK_BLOCK}}` | 스택 확장자 대상 들여쓰기·개행 규칙 (스택 선택 — **글롭에 `md`를 넣지 않는다**: 골격 하단 `[*.md]` 절과 겹친다) | `[*.{ts,tsx,json}]` 블록 |
| `{{GITIGNORE_STACK_BLOCK}}` | 스택 빌드 산출물·의존성 경로 (스택 선택) | `node_modules/`·`dist/` |

- Q10(타 에이전트 병용) "있음"이면: `CLAUDE.md` 첫 줄에 `@AGENTS.md` 가져오기를 추가하고 공유 지침을 `AGENTS.md`로 분리한다(초안 §4).
