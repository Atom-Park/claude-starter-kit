# 문서 거버넌스 — 매 세션 자동 주입 (집행 요약)

> 정본: `CLAUDE.md`(작업 규약·하지 말 것) — 근거·상세는 정본 참조. **킷 층(`.claude-starter-kit/`)은 평시 참조 대상이 아니다.**

- **새 CLAUDE.md 파일을 만들지 않는다** — 허용 위치는 루트 `CLAUDE.md`·{{SUB_CLAUDE_MD}} 뿐. 신설·개정은 PR로 제안한다.
- **하위 폴더에서 `/init`을 실행하지 않는다.**
- **규약·컨벤션 문서는 `docs/conventions/` + `docs/conventions/INDEX.md` 등록으로만** 만든다 — 그 외 위치(서브 프로젝트 `doc/`·`docs/` 등)에 규약 문서 신설 금지.
- **공통 참조 문서**(CLAUDE.md·`docs/constitution.md`·`docs/conventions/*`·`.claude-starter-kit/*`·`.claude/rules/*`·`.claude/skills/*`·`.claude/settings.json`·`.githooks/*`·PR 템플릿·MEMBER-BOOTSTRAP·{{SUB_CLAUDE_MD}}) **수정 전 고지·재확인** — 수정은 `change-propagation` 스킬 절차(정본↔배치본 동기·전수 grep〔숨김 경로 포함〕·지도표 갱신)로.
- **`.claude-starter-kit/templates/**`는 편집하지 않는다** — 리포가 어느 판으로 생성됐는지의 스냅샷이라 전파 대상이 아니다(권한 deny + 가드 차단). 판 갱신은 관리자가 리포마다 직접 반영한다.
- **무인·자동 승인 모드(auto 등) 세션에서는 보호 경로 문서를 수정하지 않는다** — 수정이 필요하면 인터랙티브 default 세션에서 수행한다.
- **세션은 리포 루트에서 연다**(프로젝트 설정·훅·rules가 시작 디렉토리 기준으로 로드됨). 병렬 작업은 `claude --worktree <이름>`.
- 산출물 문서는 **한국어**(constitution ①).
