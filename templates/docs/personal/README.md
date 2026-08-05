# docs/personal — 개인 자산 폴더 (개인층 ③)

> **이 폴더의 내용물은 git에 올라가지 않는다** (이 README만 커밋됨).
> 개인이 개발할 때 참조할 자료를 자유롭게 두는 공간이다 — 참고 문서·화면 설계 사본·API 메모·프롬프트 재료·실험 노트 등.

## 사용법

1. 자료를 이 폴더에 둔다 (하위 폴더 자유 — 예: `docs/personal/화면설계/`, `docs/personal/메모/`)
2. Claude 작업 시 **명시적으로 참조**시킨다:
   - `"docs/personal/화면설계/로그인.md 를 참조해서 로그인 화면을 수정해줘"`
   - `"docs/personal/api-메모.md 의 계약 기준으로 구현을 정합해줘"`

## 자동 참조 — 두 단계

**1) 파일 목록 자동 주입 (설정 불필요 — 전원 기본 동작)**
세션 시작 시 SessionStart 훅(`.githooks/list-personal-assets.sh`)이 이 폴더의 파일 목록을 컨텍스트에 자동 주입한다.
**파일을 넣기만 하면** Claude가 관련 작업 시 알아서 열어본다 — 단, 목록에는 파일명만 들어가므로 **파일명을 설명적으로** 짓는다 (예: `메모1.md` ✘ → `로그인화면_요구사항.md` ✔).

**2) 설명 인덱스 (선택) — CLAUDE.local.md**
파일명만으로 부족하면, 리포 루트 `CLAUDE.local.md`(gitignore 영역 — 자동 로드됨)에 **한 줄 설명 인덱스**를 유지해 자동 참조 정확도를 높인다.

    # 개인 컨텍스트 (자동 로드)

    ## docs/personal 자산 인덱스
    - docs/personal/화면설계/로그인.md — 로그인 화면 요구사항 정리
    - docs/personal/api-메모.md — 그룹 관리 API 계약 메모

- 본문 자체를 매 세션 통째로 로드하고 싶은 **소수 핵심 파일만** `@docs/personal/<파일>` import 구문을 사용한다 (컨텍스트 비용 주의).
- 인덱스를 만들지 않아도 오류는 없다 — 개인별 선택 사항. 훅·설정 변경은 다음 세션부터 반영된다.

## 규칙

- **커밋 금지 영역** — gitignore가 내용물을 자동 제외한다 (`docs/personal/*`, README 제외). 실수로 `git add -f` 하지 않는다.
- 팀 공유가 필요한 문서는 이 폴더가 아니라 처음부터 `docs/`(concepts·conventions·designs)에 두고 PR로 커밋한다.
- 자격증명·비밀값은 여기에도 두지 않는 것을 권장 (로컬 유출 방지 — constitution 취지).
- 관련 규약: [../../CLAUDE.md](../../CLAUDE.md) 작업 규약
