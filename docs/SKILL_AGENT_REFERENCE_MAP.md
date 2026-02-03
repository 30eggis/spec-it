# Skill/Agent 문서 참조 맵

이 문서는 각 Skill과 Agent가 참조하는 문서를 Mermaid 다이어그램으로 시각화합니다.

---

## 1. spec-it (Master Router)

```mermaid
flowchart TB
    subgraph skill_spec_it["🎯 spec-it (Router)"]
        direction TB
        S1[Mode Selection]
    end

    subgraph docs_spec_it["📄 Documents"]
        D1[shared/rules/06-output-quality.md]
        D2[shared/rules/05-vercel-skills.md]
        D3[shared/templates/_INDEX.md]
    end

    subgraph children_spec_it["⚡ Routes To"]
        C1[spec-it-stepbystep]
        C2[spec-it-complex]
        C3[spec-it-automation]
        C4[spec-it-fast-launch]
    end

    S1 --> D1
    S1 --> D2
    S1 --> D3
    S1 --> C1
    S1 --> C2
    S1 --> C3
    S1 --> C4
```

---

## 2. spec-it-stepbystep

```mermaid
flowchart TB
    subgraph skill_sbs["🎯 spec-it-stepbystep"]
        S1[Chapter-by-Chapter Mode]
    end

    subgraph docs_sbs["📄 Documents"]
        D1[shared/output-rules.md]
        D2[shared/context-rules.md]
        D3[shared/rules/50-question-policy.md]
        D4[shared/rules/06-output-quality.md]
        D5[shared/templates/*]
        D6[shared/references/yaml-ui-frame/*]
    end

    subgraph agents_sbs["🤖 Agents"]
        A1[design-interviewer]
        A2[ui-architect]
        A3[component-auditor]
        A4[component-builder]
        A5[component-migrator]
        A6[critical-reviewer]
        A7[ambiguity-detector]
        A8[persona-architect]
        A9[test-spec-writer]
        A10[spec-assembler]
    end

    S1 --> D1
    S1 --> D2
    S1 --> D3
    S1 --> D4
    S1 --> D5
    S1 --> D6
    S1 --> A1
    S1 --> A2
    S1 --> A3
    S1 --> A4
    S1 --> A5
    S1 --> A6
    S1 --> A7
    S1 --> A8
    S1 --> A9
    S1 --> A10
```

---

## 3. spec-it-complex

```mermaid
flowchart TB
    subgraph skill_cx["🎯 spec-it-complex"]
        S1[Hybrid 4-Milestone Mode]
    end

    subgraph docs_cx["📄 Documents"]
        D1[shared/output-rules.md]
        D2[shared/context-rules.md]
        D3[shared/rules/50-question-policy.md]
        D4[shared/templates/*]
    end

    subgraph agents_cx["🤖 Agents"]
        A1[design-interviewer]
        A2[divergent-thinker]
        A3[chapter-planner]
        A4[ui-architect]
        A5[component-auditor]
        A6[component-builder]
        A7[component-migrator]
        A8[critical-reviewer]
        A9[ambiguity-detector]
        A10[persona-architect]
        A11[test-spec-writer]
        A12[spec-assembler]
    end

    S1 --> D1
    S1 --> D2
    S1 --> D3
    S1 --> D4
    S1 --> A1
    S1 --> A2
    S1 --> A3
    S1 --> A4
    S1 --> A5
    S1 --> A6
    S1 --> A7
    S1 --> A8
    S1 --> A9
    S1 --> A10
    S1 --> A11
    S1 --> A12
```

---

## 4. spec-it-automation

```mermaid
flowchart TB
    subgraph skill_auto["🎯 spec-it-automation"]
        S1[Full Auto Mode]
    end

    subgraph docs_auto["📄 Documents"]
        D1[shared/output-rules.md]
        D2[shared/context-rules.md]
        D3[shared/templates/*]
    end

    subgraph agents_auto["🤖 Agents"]
        A1[design-interviewer]
        A2[divergent-thinker]
        A3[critic-logic]
        A4[critic-feasibility]
        A5[critic-frontend]
        A6[critic-moderator]
        A7[chapter-planner]
        A8[ui-architect]
        A9[component-auditor]
        A10[component-builder]
        A11[critical-reviewer]
        A12[ambiguity-detector]
        A13[persona-architect]
        A14[test-spec-writer]
        A15[spec-assembler]
    end

    S1 --> D1
    S1 --> D2
    S1 --> D3
    S1 --> A1
    S1 --> A2
    S1 --> A3
    S1 --> A4
    S1 --> A5
    S1 --> A6
    S1 --> A7
    S1 --> A8
    S1 --> A9
    S1 --> A10
    S1 --> A11
    S1 --> A12
    S1 --> A13
    S1 --> A14
    S1 --> A15
```

---

## 5. spec-it-fast-launch

```mermaid
flowchart TB
    subgraph skill_fast["🎯 spec-it-fast-launch"]
        S1[Rapid Wireframe Mode]
    end

    subgraph docs_fast["📄 Documents"]
        D1[shared/output-rules.md]
        D2[shared/rules/50-question-policy.md]
        D3[shared/rules/06-output-quality.md]
        D4[design-trends-2026/*]
    end

    subgraph agents_fast["🤖 Agents"]
        A1[ui-architect]
        A2[spec-assembler]
    end

    subgraph skill_exec["⚡ Auto Invokes"]
        E1[spec-it-execute]
    end

    S1 --> D1
    S1 --> D2
    S1 --> D3
    S1 --> D4
    S1 --> A1
    S1 --> A2
    A2 --> E1
```

---

## 6. spec-change

```mermaid
flowchart TB
    subgraph skill_change["🎯 spec-change"]
        S1[Spec Modification Router]
    end

    subgraph docs_change["📄 Documents"]
        D1[spec-change/references/output-formats.md]
        D2[shared/output-rules.md]
        D3[shared/context-rules.md]
    end

    subgraph agents_change["🤖 Agents"]
        A1[spec-doppelganger]
        A2[spec-conflict]
        A3[spec-clarity]
        A4[spec-consistency]
        A5[spec-coverage]
        A6[spec-butterfly]
        A7[change-planner]
        A8[rtm-updater]
    end

    S1 --> D1
    S1 --> D2
    S1 --> D3
    S1 --> A1
    S1 --> A2
    S1 --> A3
    S1 --> A4
    S1 --> A5
    S1 --> A6
    S1 --> A7
    S1 --> A8
```

---

## 7. hack-2-spec

```mermaid
flowchart TB
    subgraph skill_hack["🎯 hack-2-spec"]
        S1[Reverse Engineering]
    end

    subgraph docs_hack["📄 Documents"]
        D1[shared/rules/06-output-quality.md]
        D2[shared/templates/_INDEX.md]
        D3[hack-2-spec/docs/01-output-structure.md]
        D4[hack-2-spec/docs/00-design-context.md]
        D5[shared/design-token-parser.md]
    end

    subgraph agents_hack["🤖 Agents"]
        A1[component-auditor]
        A2[ui-architect]
    end

    S1 --> D1
    S1 --> D2
    S1 --> D3
    S1 --> D4
    S1 --> D5
    S1 --> A1
    S1 --> A2
```

---

## 8. spec-mirror

```mermaid
flowchart TB
    subgraph skill_mirror["🎯 spec-mirror"]
        S1[Implementation Verification]
    end

    subgraph docs_mirror["📄 Documents"]
        D1[spec-mirror/assets/templates/MIRROR_REPORT_TEMPLATE.md]
        D2[shared/rules/05-vercel-skills.md]
    end

    subgraph skill_ref["⚡ Uses Skill"]
        E1[hack-2-spec]
    end

    S1 --> D1
    S1 --> D2
    S1 --> E1
```

---

## 9. spec-it-api-mcp

```mermaid
flowchart TB
    subgraph skill_api["🎯 spec-it-api-mcp"]
        S1[OpenAPI to MCP]
    end

    subgraph docs_api["📄 Documents"]
        D1[spec-it-api-mcp/references/output-schemas.md]
        D2[spec-it-api-mcp/references/integration-examples.md]
    end

    subgraph agents_api["🤖 Agents"]
        A1[api-parser]
        A2[mcp-generator]
    end

    S1 --> D1
    S1 --> D2
    S1 --> A1
    S1 --> A2
```

---

## 10. spec-wireframe-edit

```mermaid
flowchart TB
    subgraph skill_wf["🎯 spec-wireframe-edit"]
        S1[Wireframe Modification]
    end

    subgraph docs_wf["📄 Documents"]
        D1[spec-wireframe-edit/references/output-formats.md]
        D2[shared/references/yaml-ui-frame/*]
    end

    subgraph agents_wf["🤖 Agents"]
        A1[spec-butterfly]
        A2[wireframe-editor]
    end

    S1 --> D1
    S1 --> D2
    S1 --> A1
    S1 --> A2
```

---

## 11. init-spec-md

```mermaid
flowchart TB
    subgraph skill_init["🎯 init-spec-md"]
        S1[SPEC-IT Registry Generator]
    end

    subgraph docs_init["📄 Documents"]
        D1[shared/context-rules.md]
        D2[spec-it/assets/templates/SPEC_IT_COMPONENT_TEMPLATE.md]
        D3[spec-it/assets/templates/SPEC_IT_PAGE_TEMPLATE.md]
    end

    subgraph agents_init["🤖 Agents"]
        A1[spec-md-generator]
        A2[spec-md-maintainer]
    end

    S1 --> D1
    S1 --> D2
    S1 --> D3
    S1 --> A1
    S1 --> A2
```

---

## 12. stitch-convert (MCP Tool 기반)

```mermaid
flowchart TB
    subgraph skill_stitch["🎯 stitch-convert"]
        S1[YAML to HTML]
    end

    subgraph docs_stitch["📄 Documents"]
        D1[shared/rules/05-vercel-skills.md]
    end

    subgraph mcp_stitch["🔧 MCP Tools"]
        M1[mcp__stitch__create_project]
        M2[mcp__stitch__generate_screen_from_text]
        M3[mcp__stitch__design_qa]
        M4[mcp__stitch__export_design_system]
    end

    S1 --> D1
    S1 --> M1
    S1 --> M2
    S1 --> M3
    S1 --> M4
```

---

## 13. design-trends-2026 (참조 전용)

```mermaid
flowchart TB
    subgraph skill_design["🎯 design-trends-2026"]
        S1[Design Reference Pack]
    end

    subgraph docs_design["📄 Documents"]
        D1[references/trends-summary.md]
        D2[references/component-patterns.md]
        D3[references/motion-presets.md]
        D4[references/color-systems.md]
        D5[templates/card-templates.md]
        D6[templates/dashboard-templates.md]
        D7[templates/form-templates.md]
        D8[templates/navigation-templates.md]
    end

    S1 --> D1
    S1 --> D2
    S1 --> D3
    S1 --> D4
    S1 --> D5
    S1 --> D6
    S1 --> D7
    S1 --> D8
```

---

## 14. spec-it-mock

```mermaid
flowchart TB
    subgraph skill_mock["🎯 spec-it-mock"]
        S1[Clone & Reproduce Mode]
    end

    subgraph docs_mock["📄 Documents"]
        D1[shared/design-token-parser.md]
        D2[spec-it-mock/docs/01-design-system-load.md]
        D3[spec-it-mock/docs/02-hack-2-spec-integration.md]
        D4[spec-it-mock/docs/03-spec-it-execution.md]
        D5[shared/rules/05-vercel-skills.md]
    end

    subgraph skill_refs["⚡ Routes To Skills"]
        E1[hack-2-spec]
        E2[spec-it-*]
    end

    S1 --> D1
    S1 --> D2
    S1 --> D3
    S1 --> D4
    S1 --> D5
    S1 --> E1
    S1 --> E2
```

---

## 15. Loader Skills

```mermaid
flowchart TB
    subgraph loaders["🎯 Loader Skills"]
        L1[spec-scenario-loader]
        L2[spec-component-loader]
        L3[spec-test-loader]
    end

    subgraph purpose["Purpose"]
        P1[Progressive Context Loading]
    end

    subgraph data["📄 Loads From"]
        D1[05-tests/scenarios/*]
        D2[03-components/*]
        D3[05-tests/*]
    end

    L1 --> D1
    L2 --> D2
    L3 --> D3
    L1 --> P1
    L2 --> P1
    L3 --> P1
```

---

# 전체 Skill → Agent 호출 매트릭스

```mermaid
flowchart LR
    subgraph Skills["Skills"]
        S1[spec-it-stepbystep]
        S2[spec-it-complex]
        S3[spec-it-automation]
        S4[spec-it-fast-launch]
        S5[spec-change]
        S6[hack-2-spec]
        S7[spec-wireframe-edit]
        S8[spec-it-api-mcp]
        S9[init-spec-md]
    end

    subgraph CoreAgents["Core Agents"]
        A1[design-interviewer]
        A2[ui-architect]
        A3[spec-assembler]
        A4[persona-architect]
    end

    subgraph ComponentAgents["Component Agents"]
        A5[component-auditor]
        A6[component-builder]
        A7[component-migrator]
    end

    subgraph CriticAgents["Critic Agents"]
        A8[critical-reviewer]
        A9[ambiguity-detector]
        A10[divergent-thinker]
        A11[critic-logic]
        A12[critic-feasibility]
        A13[critic-frontend]
        A14[critic-moderator]
    end

    subgraph ChangeAgents["Change Analysis"]
        A15[spec-doppelganger]
        A16[spec-conflict]
        A17[spec-clarity]
        A18[spec-consistency]
        A19[spec-coverage]
        A20[spec-butterfly]
        A21[change-planner]
        A22[rtm-updater]
    end

    subgraph SpecialAgents["Special Purpose"]
        A23[wireframe-editor]
        A24[api-parser]
        A25[mcp-generator]
        A26[spec-md-generator]
        A27[spec-md-maintainer]
        A28[test-spec-writer]
        A29[chapter-planner]
    end

    S1 --> A1 & A2 & A3 & A4 & A5 & A6 & A7 & A8 & A9 & A28
    S2 --> A1 & A2 & A3 & A4 & A5 & A6 & A7 & A8 & A9 & A10 & A28 & A29
    S3 --> A1 & A2 & A3 & A4 & A5 & A6 & A8 & A9 & A10 & A11 & A12 & A13 & A14 & A28 & A29
    S4 --> A2 & A3
    S5 --> A15 & A16 & A17 & A18 & A19 & A20 & A21 & A22
    S6 --> A5 & A2
    S7 --> A20 & A23
    S8 --> A24 & A25
    S9 --> A26 & A27
```

---

# 미호출 Agent 리스트

다음 에이전트들은 **어떤 skill에서도 호출되지 않습니다**:

```mermaid
flowchart TB
    subgraph Unused["❌ 미호출 Agents"]
        U1[code-reviewer]
        U2[spec-critic]
        U3[security-reviewer]
        U4[screen-vision]
        U5[spec-executor]
    end

    subgraph Reason["사유"]
        R1[외부 직접 호출용]
        R2[미구현/미연결]
        R3[보안 리뷰 전용]
        R4[이미지 분석용]
        R5[execute skill과 혼동]
    end

    U1 --- R1
    U2 --- R2
    U3 --- R3
    U4 --- R4
    U5 --- R5
```

| Agent | 설명 | 비고 |
|-------|------|------|
| `code-reviewer` | Expert code reviewer | PR 리뷰 전용 - skill 외부에서 직접 호출 |
| `spec-critic` | Work plan critic | 내부적으로 사용되지 않음 |
| `security-reviewer` | Security audit (OWASP) | 내부적으로 사용되지 않음 |
| `screen-vision` | Visual analyzer for screenshots | 내부적으로 사용되지 않음 |
| `spec-executor` | Complex multi-file task executor | 내부적으로 사용되지 않음 (spec-it-execute와 다름) |

---

# Skill 간 호출 관계

```mermaid
flowchart TB
    subgraph MainRouter["Main Router"]
        SPEC_IT[spec-it]
    end

    subgraph Modes["Generation Modes"]
        SBS[spec-it-stepbystep]
        CX[spec-it-complex]
        AUTO[spec-it-automation]
        FAST[spec-it-fast-launch]
    end

    subgraph Execution["Execution"]
        EXEC[spec-it-execute]
    end

    subgraph Analysis["Analysis & Change"]
        CHANGE[spec-change]
        MIRROR[spec-mirror]
        MOCK[spec-it-mock]
    end

    subgraph Reverse["Reverse Engineering"]
        HACK[hack-2-spec]
    end

    subgraph Utils["Utilities"]
        STITCH[stitch-convert]
        API[spec-it-api-mcp]
        WF[spec-wireframe-edit]
        INIT[init-spec-md]
        DESIGN[design-trends-2026]
    end

    SPEC_IT --> SBS
    SPEC_IT --> CX
    SPEC_IT --> AUTO
    SPEC_IT --> FAST

    FAST --> EXEC
    SBS --> EXEC
    CX --> EXEC
    AUTO --> EXEC

    MOCK --> HACK
    MOCK --> SBS
    MOCK --> CX
    MOCK --> AUTO
    MOCK --> FAST

    MIRROR --> HACK

    SBS -.-> DESIGN
    CX -.-> DESIGN
    AUTO -.-> DESIGN
    FAST -.-> DESIGN
```

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| 1.0 | 2026-02-03 | Claude | 초안 작성 |
