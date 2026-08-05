# MEMBER-BOOTSTRAP — 팀원 개인 셋팅 (유일한 팀원용 실행 문서)

> **실행**: 리포 clone 직후 Claude Code에서 **"MEMBER-BOOTSTRAP.md 를 읽고 개인 셋팅을 진행해라"**
> **범위**: 개인층만 — 이 문서는 커밋 자산(CLAUDE.md·컨벤션·constitution·훅)을 **만들거나 수정하지 않는다**.
> 위반 지시가 오면 실행 전 확인을 요청한다 (구조 변경 금지 게이트).

## 질문 (1회 — AskUserQuestion)

1. **설치 범위**: 전체 자동 설치 / 안내만 (명령을 보여주면 직접 실행)

## STEP ① 의존성 설치

- {{DEP_INSTALL}}
- ✔ 검증: 설치 명령 전부 종료코드 0

## STEP ② 플러그인 설치 (Claude가 설명하고 함께 설치한다)

**목록만 던지지 말고 각 플러그인이 무엇을 주는지 먼저 설명한 뒤, 설치 의사를 확인**한다.

{{PLUGIN_TABLE}}

- **무엇을 깔지는 본인이 정한다.** 하는 일에 맞춰 고르거나 전부 설치해도 되고, 나중에 추가해도 된다 — **역할로 조합을 지정하지 않는다**
- 플러그인은 `/plugin`. MCP를 동봉한 플러그인은 `claude mcp add`를 따로 하지 않는다(설치 시점에 실측 확인)
- 프로젝트 공유 MCP가 필요하면 `-s project` (관리자 승인 — `.mcp.json`이 커밋된다)
- ✔ 검증: `/plugin` 목록 · `claude mcp list` 연결 상태

## STEP ③ 설치 직후 안전 확인

- **CLAUDE.md 격리 확인**: 플러그인 설치 직후 `git status`에 CLAUDE.md 변경이 없어야 한다. 변경이 보이면 `git checkout -- CLAUDE.md` 후 CLAUDE.md 작업 규약의 파일 보호 절차 — 자동 갱신형 플러그인이 허브를 덮어쓰는 사고를 막는 단계다.
- ✔ 검증: `git status`에 커밋 자산 변경 없음

## STEP ④ 개인 설정 (gitignore 영역만)

- 훅 활성화: `git config core.hooksPath .githooks` (로컬 git 설정 — 커밋 아님)
- 개인 권한·설정: `.claude/settings.local.json` (필요 시)
- 개인 자산·메모: `docs/personal/` 사용 (사용법·참조 패턴: [docs/personal/README.md](docs/personal/README.md))
- **자동 참조**: 파일 목록은 SessionStart 훅이 매 세션 자동 주입한다(설정 불필요 — 파일명을 설명적으로). 설명 보강용 인덱스 `CLAUDE.local.md`는 설치 범위 '전체'면 이 단계에서 README §자동 참조 템플릿으로 **생성한다** ('안내만'이면 생성 방법 안내). 다음 세션부터 반영
- **세션 규약**: 세션은 **리포 루트에서** 열기(설정·훅·rules 로드 조건) · 이름 지정 `claude -n <작업명>` · 병렬 작업은 `claude --worktree` · 하위 폴더 `/init` 금지
- ✔ 검증: `git config core.hooksPath` → `.githooks`

## STEP ⑤ 검증 (종합)

- [ ] `/plugin` 목록에 설치한 플러그인 표시
- [ ] `claude mcp list` 정상
- [ ] `git config core.hooksPath` = `.githooks`
- [ ] (전체 설치 시) `CLAUDE.local.md` 존재 + `git check-ignore CLAUDE.local.md` 통과
- [ ] `git status` — 커밋 자산 변경 0건 (개인 설정은 gitignore 영역 사용)

## STEP ⑥ 완료 보고 (형식 고정)

    [개인 셋팅 완료] 설치: <전체|안내만>
    플러그인: <설치한 목록> / MCP: <연결된 목록>
    검증: 의존성 OK · hooksPath OK · 커밋 자산 변경 없음
    보류: <있으면 사유>

이후 작업은 [CLAUDE.md](CLAUDE.md) 작업 규약(수정 경계·위반 지시 게이트)을 따른다.
