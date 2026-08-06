# 플러그인·MCP — 팀 표준 목록

> **이 표가 정본이다.** 설치 절차는 [MEMBER-BOOTSTRAP.md](../../MEMBER-BOOTSTRAP.md) STEP ②.
> 목록 변경은 **PR로 제안**한다 — 개인이 더 설치하는 것은 자유이고, 이 표는 팀이 공통으로 권하는 것만 담는다.

{{PLUGIN_TABLE}}

## 설치·운영 규칙

- **무엇을 깔지는 본인이 정한다.** 하는 일에 맞춰 고르거나 전부 설치해도 되고, 나중에 추가해도 된다 — **역할로 조합을 지정하지 않는다.**
- 플러그인은 `/plugin` 으로 설치한다. **MCP를 동봉한 플러그인은 `claude mcp add` 를 따로 하지 않는다** — 설치 직후 `claude mcp list` 로 실측 확인한다.
- 프로젝트 공유 MCP가 필요하면 `-s project` (관리자 승인 — `.mcp.json` 이 커밋된다).
- 개인 권한·설정은 `.claude/settings.local.json`(gitignore 영역)에 둔다. 커밋 자산을 고치지 않는다.

<!-- 생성 안내(배치 후 이 주석은 지운다):
  - `{{PLUGIN_TABLE}}` 은 Q3·Q6 답으로 채운다. 열은 `| 플러그인 | 무엇을 주나 | 언제 도움이 되나 |`.
  - **각 플러그인이 실제로 무엇을 추가하는지 실측해 적는다** — 슬래시 명령·스킬·MCP 도구는 플러그인마다 다르다.
    `claude plugin details <name>` 으로 구성 요소와 토큰 비용을 확인할 수 있다.
  - 이 문서는 **`docs/conventions/INDEX.md` 에 같은 커밋으로 등재**한다(고립 문서 금지 — pre-commit ⓒ 가 검사).
-->
