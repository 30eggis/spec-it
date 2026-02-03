# Skill/Agent 문서 참조 맵

각 Skill이 참조하는 문서와, 호출하는 Agent/Skill이 참조하는 문서까지 전체 체인을 포함합니다.

---

## 1. spec-it-stepbystep

```mermaid
flowchart TB
    subgraph SKILL["🎯 spec-it-stepbystep"]
        S1[Step-by-Step Mode]
    end

    subgraph SKILL_DOCS["📄 Skill 직접 참조"]
        SD1[shared/output-rules.md]
        SD2[shared/context-rules.md]
        SD3[shared/rules/50-question-policy.md]
        SD4[shared/rules/06-output-quality.md]
        SD5[shared/templates/_INDEX.md]
    end

    subgraph AGENT_DI["🤖 design-interviewer"]
        A1[Agent: Q&A Conductor]
    end

    subgraph AGENT_UI["🤖 ui-architect"]
        A2[Agent: Wireframe Generator]
    end
    subgraph UI_DOCS["📄 ui-architect 참조"]
        UD1[yaml-ui-frame/01-basic-structure.md]
        UD2[yaml-ui-frame/02-grid-definition.md]
        UD3[yaml-ui-frame/03-components.md]
        UD4[yaml-ui-frame/07-design-direction.md]
        UD5[design-trends-2026/references/trends-summary.md]
        UD6[design-trends-2026/references/component-patterns.md]
        UD7[design-trends-2026/templates/navigation-templates.md]
        UD8[assets/templates/LAYOUT_TEMPLATE.yaml]
        UD9[shared/design-tokens.yaml]
    end

    subgraph AGENT_CA["🤖 component-auditor"]
        A3[Agent: Component Scanner]
    end

    subgraph AGENT_CB["🤖 component-builder"]
        A4[Agent: Component Spec Writer]
    end
    subgraph CB_DOCS["📄 component-builder 참조"]
        CBD1[assets/templates/COMPONENT_SPEC_TEMPLATE.yaml]
        CBD2[shared/design-tokens.yaml]
    end

    subgraph AGENT_CM["🤖 component-migrator"]
        A5[Agent: Migration Planner]
    end

    subgraph AGENT_CR["🤖 critical-reviewer"]
        A6[Agent: Spec Reviewer]
    end

    subgraph AGENT_AD["🤖 ambiguity-detector"]
        A7[Agent: Ambiguity Finder]
    end

    subgraph AGENT_PA["🤖 persona-architect"]
        A8[Agent: Persona Creator]
    end

    subgraph AGENT_TS["🤖 test-spec-writer"]
        A9[Agent: Test Spec Writer]
    end

    subgraph AGENT_SA["🤖 spec-assembler"]
        A10[Agent: Final Assembler]
    end

    S1 --> SD1 & SD2 & SD3 & SD4 & SD5
    S1 --> A1 & A2 & A3 & A4 & A5 & A6 & A7 & A8 & A9 & A10

    A2 --> UD1 & UD2 & UD3 & UD4 & UD5 & UD6 & UD7 & UD8 & UD9
    A4 --> CBD1 & CBD2
```

---

## 2. spec-it-complex

```mermaid
flowchart TB
    subgraph SKILL["🎯 spec-it-complex"]
        S1[Hybrid 4-Milestone Mode]
    end

    subgraph SKILL_DOCS["📄 Skill 직접 참조"]
        SD1[shared/output-rules.md]
        SD2[shared/context-rules.md]
        SD3[shared/rules/50-question-policy.md]
        SD4[shared/templates/_INDEX.md]
    end

    subgraph AGENTS["🤖 Agents"]
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

    subgraph UI_DOCS["📄 ui-architect 참조"]
        UD1[yaml-ui-frame/01-basic-structure.md]
        UD2[yaml-ui-frame/02-grid-definition.md]
        UD3[yaml-ui-frame/03-components.md]
        UD4[yaml-ui-frame/07-design-direction.md]
        UD5[design-trends-2026/references/trends-summary.md]
        UD6[design-trends-2026/references/component-patterns.md]
    end

    subgraph CB_DOCS["📄 component-builder 참조"]
        CBD1[assets/templates/COMPONENT_SPEC_TEMPLATE.yaml]
        CBD2[shared/design-tokens.yaml]
    end

    S1 --> SD1 & SD2 & SD3 & SD4
    S1 --> A1 & A2 & A3 & A4 & A5 & A6 & A7 & A8 & A9 & A10 & A11 & A12

    A4 --> UD1 & UD2 & UD3 & UD4 & UD5 & UD6
    A6 --> CBD1 & CBD2
```

---

## 3. spec-it-automation

```mermaid
flowchart TB
    subgraph SKILL["🎯 spec-it-automation"]
        S1[Full Auto Mode]
    end

    subgraph SKILL_DOCS["📄 Skill 직접 참조"]
        SD1[shared/output-rules.md]
        SD2[shared/context-rules.md]
        SD3[shared/templates/_INDEX.md]
    end

    subgraph CRITIC_AGENTS["🤖 Critic Agents"]
        CA1[critic-logic]
        CA2[critic-feasibility]
        CA3[critic-frontend]
        CA4[critic-moderator]
    end

    subgraph CORE_AGENTS["🤖 Core Agents"]
        A1[design-interviewer]
        A2[divergent-thinker]
        A3[chapter-planner]
        A4[ui-architect]
        A5[component-auditor]
        A6[component-builder]
        A7[critical-reviewer]
        A8[ambiguity-detector]
        A9[persona-architect]
        A10[test-spec-writer]
        A11[spec-assembler]
    end

    subgraph UI_DOCS["📄 ui-architect 참조"]
        UD1[yaml-ui-frame/*.md]
        UD2[design-trends-2026/references/*.md]
    end

    S1 --> SD1 & SD2 & SD3
    S1 --> CA1 & CA2 & CA3 & CA4
    S1 --> A1 & A2 & A3 & A4 & A5 & A6 & A7 & A8 & A9 & A10 & A11

    A4 --> UD1 & UD2
```

---

## 4. spec-it-fast-launch

```mermaid
flowchart TB
    subgraph SKILL["🎯 spec-it-fast-launch"]
        S1[Rapid Wireframe Mode]
    end

    subgraph SKILL_DOCS["📄 Skill 직접 참조"]
        SD1[shared/output-rules.md]
        SD2[shared/rules/50-question-policy.md]
        SD3[shared/rules/06-output-quality.md]
    end

    subgraph AGENTS["🤖 Agents"]
        A1[ui-architect]
        A2[spec-assembler]
    end

    subgraph UI_DOCS["📄 ui-architect 참조"]
        UD1[yaml-ui-frame/*.md]
        UD2[design-trends-2026/references/trends-summary.md]
        UD3[design-trends-2026/references/component-patterns.md]
    end

    subgraph INVOKE_SKILL["⚡ Auto Invokes Skill"]
        IS1[spec-it-execute]
    end

    subgraph EXEC_DOCS["📄 spec-it-execute 참조"]
        ED1[spec-it-execute/docs/00-overview.md]
        ED2[spec-it-execute/docs/01-rules.md]
        ED3[spec-it-execute/docs/02-phase-0-2-init-load-plan.md]
        ED4[spec-it-execute/docs/03-phase-3-execute.md]
        ED5[spec-it-execute/docs/14-agents.md]
    end

    S1 --> SD1 & SD2 & SD3
    S1 --> A1 & A2
    A1 --> UD1 & UD2 & UD3
    A2 --> IS1
    IS1 --> ED1 & ED2 & ED3 & ED4 & ED5
```

---

## 5. spec-change

```mermaid
flowchart TB
    subgraph SKILL["🎯 spec-change"]
        S1[Spec Modification Router]
    end

    subgraph SKILL_DOCS["📄 Skill 직접 참조"]
        SD1[spec-change/references/output-formats.md]
        SD2[shared/output-rules.md]
        SD3[shared/context-rules.md]
    end

    subgraph BATCH1["🤖 Batch 1 Agents (Parallel)"]
        B1A1[spec-doppelganger]
        B1A2[spec-conflict]
        B1A3[spec-clarity]
        B1A4[spec-consistency]
    end

    subgraph BATCH2["🤖 Batch 2 Agents (Parallel)"]
        B2A1[spec-coverage]
        B2A2[spec-butterfly]
    end

    subgraph FINAL_AGENTS["🤖 Final Agents"]
        FA1[change-planner]
        FA2[rtm-updater]
    end

    subgraph OUTPUT["📤 Output"]
        O1[_analysis/doppelganger.json]
        O2[_analysis/conflict.json]
        O3[_analysis/clarity.json]
        O4[_analysis/consistency.json]
        O5[_analysis/coverage.json]
        O6[_analysis/butterfly.json]
        O7[_analysis/change-plan.md]
        O8[_traceability/rtm.json]
    end

    S1 --> SD1 & SD2 & SD3
    S1 --> B1A1 & B1A2 & B1A3 & B1A4
    S1 --> B2A1 & B2A2
    S1 --> FA1 & FA2

    B1A1 --> O1
    B1A2 --> O2
    B1A3 --> O3
    B1A4 --> O4
    B2A1 --> O5
    B2A2 --> O6
    FA1 --> O7
    FA2 --> O8
```

---

## 6. hack-2-spec

```mermaid
flowchart TB
    subgraph SKILL["🎯 hack-2-spec"]
        S1[Reverse Engineering]
    end

    subgraph SKILL_DOCS["📄 Skill 직접 참조"]
        SD1[shared/rules/06-output-quality.md]
        SD2[shared/templates/_INDEX.md]
        SD3[hack-2-spec/docs/01-output-structure.md]
        SD4[hack-2-spec/docs/00-design-context.md]
        SD5[shared/design-token-parser.md]
        SD6[shared/rules/05-vercel-skills.md]
    end

    subgraph TEMPLATES["📄 Output Templates"]
        T1[templates/00-REQUIREMENTS_TEMPLATE.md]
        T2[templates/01-CHAPTER_PLAN_TEMPLATE.md]
        T3[templates/02-SCREEN_LIST_TEMPLATE.md]
        T4[templates/02-DOMAIN_MAP_TEMPLATE.md]
        T5[templates/02-WIREFRAME_YAML_TEMPLATE.yaml]
        T6[templates/03-COMPONENT_INVENTORY_TEMPLATE.md]
        T7[templates/04-REVIEW_SUMMARY_TEMPLATE.md]
        T8[templates/05-TEST_SPECIFICATIONS_TEMPLATE.md]
        T9[templates/06-FINAL_SPEC_TEMPLATE.md]
        T10[templates/06-DEV_TASKS_TEMPLATE.md]
        T11[templates/PHASE_TEMPLATE.md]
    end

    subgraph INTEGRATION["⚡ Integration Skills"]
        IS1[spec-it-mock]
        IS2[spec-mirror]
    end

    S1 --> SD1 & SD2 & SD3 & SD4 & SD5 & SD6
    SD2 --> T1 & T2 & T3 & T4 & T5 & T6 & T7 & T8 & T9 & T10 & T11
    IS1 --> S1
    IS2 --> S1
```

---

## 7. spec-it-api-mcp

```mermaid
flowchart TB
    subgraph SKILL["🎯 spec-it-api-mcp"]
        S1[OpenAPI to MCP]
    end

    subgraph SKILL_DOCS["📄 Skill 직접 참조"]
        SD1[spec-it-api-mcp/references/output-schemas.md]
        SD2[spec-it-api-mcp/references/integration-examples.md]
    end

    subgraph AGENTS["🤖 Agents"]
        A1[api-parser]
        A2[mcp-generator]
    end

    subgraph PARSER_OUT["📤 api-parser Output"]
        PO1[endpoints.json]
        PO2[schemas.json]
        PO3[metadata.json]
    end

    subgraph GEN_OUT["📤 mcp-generator Output"]
        GO1[server.ts]
        GO2[handlers/*.ts]
        GO3[handlers/_meta.ts]
        GO4[mocks/*.ts]
    end

    S1 --> SD1 & SD2
    S1 --> A1 & A2
    A1 --> PO1 & PO2 & PO3
    A2 --> GO1 & GO2 & GO3 & GO4
```

---

## 8. spec-mirror

```mermaid
flowchart TB
    subgraph SKILL["🎯 spec-mirror"]
        S1[Implementation Verification]
    end

    subgraph SKILL_DOCS["📄 Skill 직접 참조"]
        SD1[spec-mirror/assets/templates/MIRROR_REPORT_TEMPLATE.md]
        SD2[shared/rules/05-vercel-skills.md]
    end

    subgraph INVOKE_SKILL["⚡ Uses Skill"]
        IS1[hack-2-spec]
    end

    subgraph HACK_DOCS["📄 hack-2-spec 참조"]
        HD1[shared/rules/06-output-quality.md]
        HD2[shared/templates/_INDEX.md]
        HD3[hack-2-spec/docs/01-output-structure.md]
        HD4[shared/design-token-parser.md]
    end

    S1 --> SD1 & SD2
    S1 --> IS1
    IS1 --> HD1 & HD2 & HD3 & HD4
```

---

## 9. spec-wireframe-edit

```mermaid
flowchart TB
    subgraph SKILL["🎯 spec-wireframe-edit"]
        S1[Wireframe Modification]
    end

    subgraph SKILL_DOCS["📄 Skill 직접 참조"]
        SD1[spec-wireframe-edit/references/output-formats.md]
    end

    subgraph REF_DOCS["📄 YAML UI Frame Reference"]
        RD1[yaml-ui-frame/01-basic-structure.md]
        RD2[yaml-ui-frame/02-grid-definition.md]
        RD3[yaml-ui-frame/03-components.md]
        RD4[yaml-ui-frame/07-design-direction.md]
    end

    subgraph AGENTS["🤖 Agents"]
        A1[spec-butterfly]
        A2[wireframe-editor]
    end

    S1 --> SD1
    S1 --> RD1 & RD2 & RD3 & RD4
    S1 --> A1 & A2
    A2 --> RD1 & RD2 & RD3 & RD4
```

---

## 10. init-spec-md

```mermaid
flowchart TB
    subgraph SKILL["🎯 init-spec-md"]
        S1[SPEC-IT Registry Generator]
    end

    subgraph SKILL_DOCS["📄 Skill 직접 참조"]
        SD1[shared/context-rules.md]
        SD2[spec-it/assets/templates/SPEC_IT_COMPONENT_TEMPLATE.md]
        SD3[spec-it/assets/templates/SPEC_IT_PAGE_TEMPLATE.md]
    end

    subgraph AGENTS["🤖 Agents"]
        A1[spec-md-generator]
        A2[spec-md-maintainer]
    end

    subgraph AGENT_DOCS["📄 Agent 참조"]
        AD1[SPEC_IT_COMPONENT_TEMPLATE.md]
        AD2[SPEC_IT_PAGE_TEMPLATE.md]
    end

    S1 --> SD1 & SD2 & SD3
    S1 --> A1 & A2
    A1 --> AD1 & AD2
    A2 --> AD1 & AD2
```

---

## 11. stitch-convert

```mermaid
flowchart TB
    subgraph SKILL["🎯 stitch-convert"]
        S1[YAML to HTML]
    end

    subgraph SKILL_DOCS["📄 Skill 직접 참조"]
        SD1[shared/rules/05-vercel-skills.md]
    end

    subgraph MCP_TOOLS["🔧 MCP Tools (Not Agents)"]
        M1[mcp__stitch__create_project]
        M2[mcp__stitch__set_workspace_project]
        M3[mcp__stitch__generate_screen_from_text]
        M4[mcp__stitch__design_qa]
        M5[mcp__stitch__export_design_system]
    end

    S1 --> SD1
    S1 --> M1 & M2 & M3 & M4 & M5
```

---

## 12. design-trends-2026

```mermaid
flowchart TB
    subgraph SKILL["🎯 design-trends-2026"]
        S1[Design Reference Pack]
    end

    subgraph DOCS["📄 Documents"]
        D1[references/trends-summary.md]
        D2[references/component-patterns.md]
        D3[references/motion-presets.md]
        D4[references/color-systems.md]
        D5[templates/card-templates.md]
        D6[templates/dashboard-templates.md]
        D7[templates/form-templates.md]
        D8[templates/navigation-templates.md]
        D9[integration/agent-prompts.md]
    end

    subgraph USED_BY["⬅️ Referenced By"]
        UB1[spec-it-stepbystep]
        UB2[spec-it-complex]
        UB3[spec-it-automation]
        UB4[spec-it-fast-launch]
    end

    S1 --> D1 & D2 & D3 & D4 & D5 & D6 & D7 & D8 & D9
    UB1 & UB2 & UB3 & UB4 --> S1
```

---

## 13. spec-it-mock

```mermaid
flowchart TB
    subgraph SKILL["🎯 spec-it-mock"]
        S1[Clone & Reproduce Mode]
    end

    subgraph SKILL_DOCS["📄 Skill 직접 참조"]
        SD1[shared/design-token-parser.md]
        SD2[spec-it-mock/docs/01-design-system-load.md]
        SD3[spec-it-mock/docs/02-hack-2-spec-integration.md]
        SD4[spec-it-mock/docs/03-spec-it-execution.md]
        SD5[shared/rules/05-vercel-skills.md]
    end

    subgraph INVOKE_SKILL1["⚡ Step 1: hack-2-spec"]
        IS1[hack-2-spec]
    end
    subgraph HACK_CHAIN["📄 hack-2-spec 참조 체인"]
        HC1[shared/rules/06-output-quality.md]
        HC2[shared/templates/_INDEX.md]
        HC3[hack-2-spec/docs/*.md]
    end

    subgraph INVOKE_SKILL2["⚡ Step 2: spec-it-*"]
        IS2[spec-it-stepbystep]
        IS3[spec-it-complex]
        IS4[spec-it-automation]
        IS5[spec-it-fast-launch]
    end
    subgraph SPECIT_CHAIN["📄 spec-it-* 참조 체인"]
        SC1[shared/output-rules.md]
        SC2[shared/templates/*]
        SC3[yaml-ui-frame/*.md]
        SC4[design-trends-2026/*]
    end

    S1 --> SD1 & SD2 & SD3 & SD4 & SD5
    S1 --> IS1
    IS1 --> HC1 & HC2 & HC3
    S1 --> IS2 & IS3 & IS4 & IS5
    IS2 & IS3 & IS4 & IS5 --> SC1 & SC2 & SC3 & SC4
```

---

# 전체 Skill 호출 그래프

```mermaid
flowchart TB
    subgraph ROUTER["Main Router"]
        SPEC_IT[spec-it]
    end

    subgraph MODES["Generation Modes"]
        SBS[spec-it-stepbystep]
        CX[spec-it-complex]
        AUTO[spec-it-automation]
        FAST[spec-it-fast-launch]
    end

    subgraph EXECUTION["Execution"]
        EXEC[spec-it-execute]
    end

    subgraph ANALYSIS["Analysis & Change"]
        CHANGE[spec-change]
        MIRROR[spec-mirror]
        MOCK[spec-it-mock]
    end

    subgraph REVERSE["Reverse Engineering"]
        HACK[hack-2-spec]
    end

    subgraph UTILS["Utilities"]
        STITCH[stitch-convert]
        API[spec-it-api-mcp]
        WF[spec-wireframe-edit]
        INIT[init-spec-md]
    end

    subgraph REFERENCE["Reference Only"]
        DESIGN[design-trends-2026]
    end

    SPEC_IT --> SBS & CX & AUTO & FAST

    FAST --> EXEC
    SBS -.-> EXEC
    CX -.-> EXEC
    AUTO -.-> EXEC

    MOCK --> HACK
    MOCK --> SBS & CX & AUTO & FAST

    MIRROR --> HACK

    SBS & CX & AUTO & FAST -.-> DESIGN
```

---

# 미호출 Agent 리스트

다음 에이전트들은 **어떤 Skill에서도 직접 호출되지 않습니다**:

| Agent | 설명 | 비고 |
|-------|------|------|
| `code-reviewer` | PR/코드 리뷰 전문가 | 외부에서 직접 호출 전용 |
| `spec-critic` | Work plan 비평가 | 미사용/미구현 |
| `security-reviewer` | 보안 감사 (OWASP) | 미사용/미구현 |
| `screen-vision` | 스크린샷 시각 분석 | 미사용/미구현 |
| `spec-executor` | 복잡한 멀티파일 실행 | spec-it-execute와 혼동 주의 |

---

# 공유 문서 참조 빈도

| 문서 | 참조하는 Skill 수 |
|------|-----------------|
| `shared/rules/06-output-quality.md` | 5+ (거의 모든 생성 Skill) |
| `shared/templates/_INDEX.md` | 4+ (hack-2-spec, spec-it-*) |
| `shared/output-rules.md` | 4+ (모든 spec-it 모드) |
| `shared/rules/05-vercel-skills.md` | 4+ (레이아웃 관련 Skill) |
| `yaml-ui-frame/*.md` | 3+ (ui-architect 사용 Skill) |
| `design-trends-2026/*` | 4 (모든 spec-it 모드) |

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| 1.0 | 2026-02-03 | Claude | 초안 작성 |
| 2.0 | 2026-02-03 | Claude | Agent/Skill 참조 문서 전체 체인 포함 |
