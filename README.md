# 클로드 스타터킷

리포 하나에 **Claude 협업 표준 구조**를 찍어내는 Claude Code 플러그인이다. 관리자가 `/kit-generate` 한 줄을 실행하면 작업 규칙·컨벤션·커밋 검증 장치·팀원 온보딩 절차가 한 번에 생성되고, 팀원은 그 리포를 clone 하는 것만으로 같은 규칙 위에서 작업하게 된다.

> **Language**: this plugin generates Korean-language documentation. The generated hub, conventions, and onboarding docs are written in Korean; only tooling surfaces (branch names, PR titles, identifiers) are English.

## 무엇을 푸나

팀원마다·리포마다 AI 활용 방식이 제각각이 되는 문제를 **조직 단위 규약으로 통일**한다. 규칙을 문서로만 두지 않고 **장치가 강제하는 3층**(정본 → AI 자동 주입 → 강제)으로 배치해, 누가 어떤 방식으로 쓰든 같은 품질 기준과 산출물 형식이 나오게 한다.

**적용 단위는 리포 1개**다. 하나의 제품이 여러 리포로 나뉘면 리포마다 따로 적용한다 — 강제 장치가 리포에 커밋되는 자산이고, 수정 경계·검증 명령이 리포 고유값이기 때문이다.

## 설치 (관리자만)

```bash
claude plugin marketplace add Atom-Park/claude-starter-kit
claude plugin install claude-starter-kit@atom-park
```

**팀원은 설치하지 않는다.** 팀원에게 필요한 것(허브·규칙·절차 스킬·훅)은 전부 생성 시점에 리포로 들어가 커밋되므로, clone 만으로 동작한다. 설치가 필요한 쪽은 새 리포를 셋팅하는 사람뿐이다.

## 쓰는 법

### 1. 리포 셋팅 생성 (관리자 · 리포당 1회)

대상 리포 루트에서 Claude Code를 열고:

```
/kit-generate
```

Claude가 리포의 목적·스택·구조·원칙을 **질문**한다. 답하면 골격을 치환 복사하고 문맥 의존 문서를 생성해 셋팅을 완성한다. 결과물을 커밋해 배포하면 끝이다.

### 2. 개인 셋팅 (팀원 · clone 후 1회)

```
MEMBER-BOOTSTRAP.md 를 읽고 개인 셋팅을 진행해라
```

의존성·플러그인·개인 설정이 구성된다.

### 3. 개발 (전원 · 상시)

생성된 셋팅(허브 `CLAUDE.md`·컨벤션·자동 주입 규칙·절차 스킬·검증 장치)으로 개발한다. **이 저장소를 다시 볼 일은 없다** — 필요한 것은 전부 생성 시점에 리포에 배치돼 있다.

### 4. 셋팅 변경 (누구나 · 필요할 때)

```
change-propagation 스킬로 <구값>을 <신값>으로 일괄 반영해라
```

스킬이 **변경 지도표**로 위치를 찾아 흩어진 문서·설정을 함께 고치고 잔존을 검증한다.

## 생성되는 것

| 층 | 산출물 |
|---|---|
| 허브·헌법 | `CLAUDE.md`(유일한 진입점) · `docs/constitution.md` |
| 컨벤션(정본) | `docs/conventions/` — `INDEX.md`·`git.md`·`code-style.md`·`plugins.md` + 스택마다 1부 |
| 자동 주입 | `.claude/rules/` — 문서 거버넌스(매 세션) + 스택별 규칙(`paths` 범위) |
| 절차층 | `.claude/skills/` — `change-propagation`·`commit-and-pr` |
| 강제 장치 | `.claude/settings.json`(보호 경로 ask·deny·훅 등록) · `.githooks/` 7종 · PR 템플릿 |
| 온보딩 | `MEMBER-BOOTSTRAP.md` · `docs/concepts/glossary.md` · `docs/personal/` |
| 킷 층 | `.claude-starter-kit/propagation-map-<리포>.md` **1파일** |

리포에 남는 킷 흔적은 **변경 지도표 하나뿐**이다. 생성 규약과 골격은 이 플러그인이 갖고 리포로 복사되지 않는다.

## 생명주기 — 한 번 찍어내고 물러난다

```
[생성]  관리자 · 리포당 1회   /kit-generate → 질문 → 셋팅 구성      플러그인 사용
[공유]  팀원 · clone 후 1회   부트스트랩으로 개인 셋팅               플러그인 불필요
[개발]  전원 · 상시           생성된 셋팅으로 작업                   플러그인 불필요
[변경]  누구나                스킬이 지도표를 읽어 반영              지도표만
```

킷은 *계속 참조하는 문서*가 아니다. 개발 중에 킷을 다시 읽어야 한다면 **배치가 덜 된 것**이다.

## 저장소 구성

| | 무엇 |
|---|---|
| `.claude-plugin/` | 플러그인 매니페스트·마켓플레이스 정의. `plugin.json` 의 `version` 이 **판의 단일 출처** |
| `commands/kit-generate.md` | `/kit-generate` 진입점 |
| `claude_starter_kit.md` | **생성 규약** — 질문 흐름·요구사항·스택 표준표(§4-S)·자체 검증 |
| `templates/` | **표준 문서 골격** — 위 표의 산출물 원문(치환자 포함). 치환표는 `templates/README.md` |

골격의 **대부분이 고정값**이다. 특히 강제 장치는 치환자가 한둘뿐이라, 팀원이 어느 리포로 옮겨도 같은 게이트를 만난다.

## 개정과 갱신

- **값·규약 변경**은 각 리포에서 `change-propagation` 스킬로 처리한다. 이 저장소를 고칠 일이 아니다.
- **구조 개정**(층 신설·폐지, 장치 변경)은 이 저장소를 고치고 **`plugin.json` 의 버전을 올린 뒤**, 관리자가 리포마다 반영한다.
- **생성 규약 재실행은 기존 리포의 업그레이드 수단이 아니다** — 멱등이라 이미 있는 산출물을 건너뛴다. 새 리포를 만들 때만 쓴다.
- 리포 간 드리프트는 지도표 머리말의 **생성 흔적**(`> 생성: claude-starter-kit v<버전> (<날짜>)`) 비교로 감지한다.

플러그인 갱신은 `install` 이 아니라 `update` 다 — `install` 은 이미 설치돼 있으면 **버전이 달라도 건너뛴다**.

```bash
claude plugin marketplace update atom-park
claude plugin update claude-starter-kit@atom-park
```

## 골격을 고칠 때

`templates/` 의 문서는 **생성기에게 하는 지시와 산출물 내용이 섞이기 쉽다.** 생성기에게 하는 말은 반드시 다음 형식으로만 쓴다 — 그래야 배치 후 삭제 규칙에 걸린다.

```markdown
<!-- 생성 안내(배치 후 이 주석은 지운다)
- 여기에 생성기에게 하는 지시를 적는다.
-->
```

본문이나 인용문에 섞어 두면 배포본에 그대로 남아, 팀원이 읽는 문서에 "이 절을 제거하라"가 나간다. HTML 주석을 못 쓰는 형식(`.editorconfig`·JSON 등)은 파일에 지시를 적지 말고 **치환표에 적는다**.

지킬 것 셋:

- 치환자를 추가·변경하면 `templates/README.md` 치환표에 함께 등재한다. **양방향으로 일치**해야 한다(미정의 0·고아 0).
- **골격을 생성물에서 본떠 쓰지 않는다.** 생성물이 지어낸 표현이 골격에 굳는다 — 도구 원문과 업계 표준에서 쓴다.
- 장치 동작을 서술할 때는 `templates/.githooks/` 원문과 대조한다. 문서가 설명하는 게이트와 실제 훅이 어긋나는 일이 잦다.
