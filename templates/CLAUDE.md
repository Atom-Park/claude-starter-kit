# {{REPO}}

> {{REPO_DESC}}
> 이 문서는 리포의 **유일한 진입 허브**다. 모든 자산은 여기서부터 링크로 도달한다. ({{ORG}})

<!-- 생성 안내(배치 후 이 주석은 지운다)
- 수정 경계가 없는 리포는 이 절을 통째로 지운다.
-->
## 수정 경계 (최우선)

{{BOUNDARY_DECL}}
- 경계 밖 수정이 필요해 보이면 실행 전 확인 요청 (위반 지시 게이트).

## 구조

{{REPO_OVERVIEW}}

<!-- 생성 안내(배치 후 이 주석은 지운다)
- 위 개요 아래에 주요 디렉토리와 역할을 불릿으로 적고, 작업 주 무대를 표시한다.
-->

## 기동·검증 명령

- 패키지 매니저: **{{PKG_MGR}}** — {{VERIFY_CMDS}}
- 커밋 훅: 활성 — `.githooks/pre-commit` (자동수정 후 통과, [docs/conventions/git.md](docs/conventions/git.md))

## 문서 지도 (전 자산 링크 — 허브)

- 도메인 개념: [docs/concepts/](docs/concepts/)
- **컨벤션 인덱스**: [docs/conventions/INDEX.md](docs/conventions/INDEX.md) ← 모든 컨벤션은 여기 등록돼 있다
- 채택 설계: [docs/designs/](docs/designs/) — 채택분만 승격
- **constitution**: [docs/constitution.md](docs/constitution.md) — 게이트(훅·PR 리뷰)로 강제
- **커밋/PR**: [docs/conventions/git.md](docs/conventions/git.md)
- 팀원 개인 셋팅: [MEMBER-BOOTSTRAP.md](MEMBER-BOOTSTRAP.md) · 개인 참조 자산: [docs/personal/](docs/personal/README.md)(git 미추적)
{{SUB_HUB_LINK}}
- **스킬**: [.claude/skills/](.claude/skills/) — 절차는 스킬이 담당한다(호출 시에만 로드). 기본 `change-propagation`(규칙·값 변경 전파) · `commit-and-pr`(커밋·PR 실행). 새 절차는 문서에 산문으로 늘리지 말고 스킬로 만든다
- `.claude-starter-kit/`는 **킷 층**(생성 규약 사본·`templates/` 생성 이력 스냅샷·지도표) — **평시에 열지 않는다.** 여는 시점은 둘뿐이다: 리포 생성 시(관리자), 그리고 셋팅을 바꿀 때 `change-propagation` 스킬이 **지도표**를 읽을 때. `templates/`는 봉인돼 편집이 차단된다.

## 작업 규약

1. **위반 지시 게이트** — 아래 지시는 실행 전 확인을 요청한다:
   수정 경계 밖 수정 · constitution 상충 · 커밋된 규칙 우회/삭제 · `--no-verify` · 자격증명 커밋
2. **개인 자산 참조** — 개인 참고 자료는 [docs/personal/](docs/personal/README.md)(git 미추적)에 둔다. 파일 목록은 세션 시작 시 자동 주입되며(SessionStart 훅), 정밀 참조는 `"docs/personal/<파일> 을 참조해서 <작업>"`으로 명시한다. 팀 공유 문서는 처음부터 `docs/`에 두고 PR로 커밋.
3. **이 파일 보호** — 개인 도구의 자동 덮어쓰기 금지, 자동 갱신형 도구는 `CLAUDE.local.md`로 격리. 훼손이 검출되면 즉시 원복한다
4. **공통 참조 문서 수정 게이트** — 커밋된 클로드 공통 참조 문서(이 파일 · `docs/constitution.md` · `docs/conventions/*` · `.claude-starter-kit/*` · `.claude/rules/*` · `.claude/skills/*` · `.claude/settings.json` · `.github/pull_request_template.md` · `.githooks/*` · `MEMBER-BOOTSTRAP.md` · {{SUB_CLAUDE_MD}})를 수정할 때는 **수정 전에 "공통 참조 문서 수정"임을 알리고, 대상 파일·변경 요지를 제시해 수정 의사를 재차 확인**받는다. 직전 지시가 해당 문서를 명시 지목한 경우에는 고지만 하고 진행한다. 확인 후의 수정은 **`change-propagation` 스킬 절차로** 수행한다.
5. **스킬 호출 원칙** — 커밋된 스킬(`.claude/skills/`)이 있는 작업은 사실 위치·신값을 이미 알고 있어도 매번 명시적으로 호출한다. "이미 안다"는 판단으로 건너뛰지 않는다 — 스킬의 핵심은 위치 찾기가 아니라 범위 확인 질문·순서 강제·잔존 검증이다.
{{REPO_WORK_RULES}}

## 하지 말 것

- 컨벤션 문서를 [docs/conventions/INDEX.md](docs/conventions/INDEX.md) 등록 없이 추가하기 — 가드·pre-commit이 차단한다(고립 문서 금지)
- **상시 참조 문서를 `.claude-starter-kit/`(킷 층)에 두기** — 평시 참조 문서는 전부 `docs/` 아래에 둔다
- **조직 공통 원칙의 사본 문서를 리포에 만들기** — 원칙은 생성 시점에 허브·자동 주입 규칙으로 이미 배치돼 있다. 사본을 두면 전파 대상이 늘고 곧 어긋난다
- 리포에 커밋되는 문서에 **리포 밖 경로**를 적기 — 절대경로도, 상위로 벗어나는 상대경로도 금지한다(팀원 로컬엔 없는 경로라 문서가 깨진다). 경로는 리포 루트 기준으로 쓰고, 다른 리포는 리포 이름으로 지칭하며, 개인이 보관하는 자산은 언급하지 않는다
- 팀원이 커밋 자산(CLAUDE.md·컨벤션·constitution·훅)을 직접 수정하기 — 개선 제안은 **`change-propagation` 스킬 절차로 작성해 PR로**(결정: 관리자)
{{REPO_DONTS}}

## 팀 온보딩

- 팀원 합류: **"MEMBER-BOOTSTRAP.md 를 읽고 개인 셋팅을 진행해라"** → [MEMBER-BOOTSTRAP.md](MEMBER-BOOTSTRAP.md)
