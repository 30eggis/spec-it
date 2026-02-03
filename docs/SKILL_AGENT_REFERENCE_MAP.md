# Skill/Agent 문서 참조 맵

각 Skill이 참조하는 문서와, 호출하는 Agent/Skill이 참조하는 문서까지 전체 체인을 포함합니다.

---

## 1. spec-it-stepbystep

- 📄 **직접 참조**
  - `shared/output-rules.md`
  - `shared/context-rules.md`
  - `shared/rules/50-question-policy.md`
  - `shared/rules/06-output-quality.md`
  - `shared/templates/_INDEX.md`
- 🤖 **design-interviewer**
  - *(프롬프트 기반 Q&A, 별도 문서 참조 없음)*
- 🤖 **ui-architect**
  - 📄 `yaml-ui-frame/01-basic-structure.md`
  - 📄 `yaml-ui-frame/02-grid-definition.md`
  - 📄 `yaml-ui-frame/03-components.md`
  - 📄 `yaml-ui-frame/07-design-direction.md`
  - 📄 `design-trends-2026/references/trends-summary.md`
  - 📄 `design-trends-2026/references/component-patterns.md`
  - 📄 `design-trends-2026/templates/navigation-templates.md`
  - 📄 `assets/templates/LAYOUT_TEMPLATE.yaml`
  - 📄 `shared/design-tokens.yaml`
- 🤖 **component-auditor**
  - *(코드베이스 스캔, 별도 문서 참조 없음)*
- 🤖 **component-builder**
  - 📄 `assets/templates/COMPONENT_SPEC_TEMPLATE.yaml`
  - 📄 `shared/design-tokens.yaml`
- 🤖 **component-migrator**
  - *(inventory 기반 분석, 별도 문서 참조 없음)*
- 🤖 **critical-reviewer**
  - *(생성된 spec 검토, 별도 문서 참조 없음)*
- 🤖 **ambiguity-detector**
  - *(생성된 spec 분석, 별도 문서 참조 없음)*
- 🤖 **persona-architect**
  - *(사용자 정의 기반, 별도 문서 참조 없음)*
- 🤖 **test-spec-writer**
  - *(spec 기반 테스트 생성, 별도 문서 참조 없음)*
- 🤖 **spec-assembler**
  - *(모든 산출물 취합, 별도 문서 참조 없음)*

---

## 2. spec-it-complex

- 📄 **직접 참조**
  - `shared/output-rules.md`
  - `shared/context-rules.md`
  - `shared/rules/50-question-policy.md`
  - `shared/templates/_INDEX.md`
- 🤖 **design-interviewer**
  - *(프롬프트 기반 Q&A)*
- 🤖 **divergent-thinker**
  - *(대안 탐색, 별도 문서 참조 없음)*
- 🤖 **chapter-planner**
  - *(챕터 구조 설계, 별도 문서 참조 없음)*
- 🤖 **ui-architect**
  - 📄 `yaml-ui-frame/01-basic-structure.md`
  - 📄 `yaml-ui-frame/02-grid-definition.md`
  - 📄 `yaml-ui-frame/03-components.md`
  - 📄 `yaml-ui-frame/07-design-direction.md`
  - 📄 `design-trends-2026/references/trends-summary.md`
  - 📄 `design-trends-2026/references/component-patterns.md`
- 🤖 **component-auditor**
- 🤖 **component-builder**
  - 📄 `assets/templates/COMPONENT_SPEC_TEMPLATE.yaml`
  - 📄 `shared/design-tokens.yaml`
- 🤖 **component-migrator**
- 🤖 **critical-reviewer**
- 🤖 **ambiguity-detector**
- 🤖 **persona-architect**
- 🤖 **test-spec-writer**
- 🤖 **spec-assembler**

---

## 3. spec-it-automation

- 📄 **직접 참조**
  - `shared/output-rules.md`
  - `shared/context-rules.md`
  - `shared/templates/_INDEX.md`
- 🤖 **Critic Agents (Parallel)**
  - 🤖 **critic-logic** - 논리 일관성 검증
  - 🤖 **critic-feasibility** - 구현 가능성 검증
  - 🤖 **critic-frontend** - 프론트엔드 관점 검증
  - 🤖 **critic-moderator** - 비평 종합 및 조율
- 🤖 **design-interviewer**
- 🤖 **divergent-thinker**
- 🤖 **chapter-planner**
- 🤖 **ui-architect**
  - 📄 `yaml-ui-frame/*.md`
  - 📄 `design-trends-2026/references/*.md`
- 🤖 **component-auditor**
- 🤖 **component-builder**
  - 📄 `assets/templates/COMPONENT_SPEC_TEMPLATE.yaml`
  - 📄 `shared/design-tokens.yaml`
- 🤖 **critical-reviewer**
- 🤖 **ambiguity-detector**
- 🤖 **persona-architect**
- 🤖 **test-spec-writer**
- 🤖 **spec-assembler**

---

## 4. spec-it-fast-launch

- 📄 **직접 참조**
  - `shared/output-rules.md`
  - `shared/rules/50-question-policy.md`
  - `shared/rules/06-output-quality.md`
- 🤖 **ui-architect**
  - 📄 `yaml-ui-frame/*.md`
  - 📄 `design-trends-2026/references/trends-summary.md`
  - 📄 `design-trends-2026/references/component-patterns.md`
- 🤖 **spec-assembler**
- ⚡ **Auto Invokes: spec-it-execute**
  - 📄 `spec-it-execute/docs/00-overview.md`
  - 📄 `spec-it-execute/docs/01-rules.md`
  - 📄 `spec-it-execute/docs/02-phase-0-2-init-load-plan.md`
  - 📄 `spec-it-execute/docs/03-phase-3-execute.md`
  - 📄 `spec-it-execute/docs/04-phase-4-qa.md`
  - 📄 `spec-it-execute/docs/05-phase-5-mirror.md`
  - 📄 `spec-it-execute/docs/06-phase-6-unit-tests.md`
  - 📄 `spec-it-execute/docs/07-phase-7-e2e.md`
  - 📄 `spec-it-execute/docs/08-phase-8-validate.md`
  - 📄 `spec-it-execute/docs/09-phase-9-complete.md`
  - 📄 `spec-it-execute/docs/14-agents.md`

---

## 5. spec-change

- 📄 **직접 참조**
  - `spec-change/references/output-formats.md`
  - `shared/output-rules.md`
  - `shared/context-rules.md`
- 🤖 **Batch 1 Agents (Parallel)**
  - 🤖 **spec-doppelganger** → `_analysis/doppelganger.json`
  - 🤖 **spec-conflict** → `_analysis/conflict.json`
  - 🤖 **spec-clarity** → `_analysis/clarity.json`
  - 🤖 **spec-consistency** → `_analysis/consistency.json`
- 🤖 **Batch 2 Agents (Parallel)**
  - 🤖 **spec-coverage** → `_analysis/coverage.json`
  - 🤖 **spec-butterfly** → `_analysis/butterfly.json`
- 🤖 **Final Agents**
  - 🤖 **change-planner** → `_analysis/change-plan.md`
  - 🤖 **rtm-updater** → `_traceability/rtm.json`

---

## 6. hack-2-spec

- 📄 **직접 참조**
  - `shared/rules/06-output-quality.md`
  - `shared/templates/_INDEX.md`
  - `hack-2-spec/docs/01-output-structure.md`
  - `hack-2-spec/docs/00-design-context.md`
  - `shared/design-token-parser.md`
  - `shared/rules/05-vercel-skills.md`
- 📄 **Output Templates (via _INDEX.md)**
  - `templates/00-REQUIREMENTS_TEMPLATE.md`
  - `templates/01-CHAPTER_PLAN_TEMPLATE.md`
  - `templates/02-SCREEN_LIST_TEMPLATE.md`
  - `templates/02-DOMAIN_MAP_TEMPLATE.md`
  - `templates/02-WIREFRAME_YAML_TEMPLATE.yaml`
  - `templates/03-COMPONENT_INVENTORY_TEMPLATE.md`
  - `templates/04-REVIEW_SUMMARY_TEMPLATE.md`
  - `templates/05-TEST_SPECIFICATIONS_TEMPLATE.md`
  - `templates/06-FINAL_SPEC_TEMPLATE.md`
  - `templates/06-DEV_TASKS_TEMPLATE.md`
  - `templates/PHASE_TEMPLATE.md`
- ⬅️ **Referenced By**
  - `spec-it-mock`
  - `spec-mirror`

---

## 7. spec-mirror

- 📄 **직접 참조**
  - `spec-mirror/assets/templates/MIRROR_REPORT_TEMPLATE.md`
  - `shared/rules/05-vercel-skills.md`
- ⚡ **Uses Skill: hack-2-spec**
  - 📄 `shared/rules/06-output-quality.md`
  - 📄 `shared/templates/_INDEX.md`
  - 📄 `hack-2-spec/docs/01-output-structure.md`
  - 📄 `shared/design-token-parser.md`

---

## 8. spec-it-api-mcp

- 📄 **직접 참조**
  - `spec-it-api-mcp/references/output-schemas.md`
  - `spec-it-api-mcp/references/integration-examples.md`
- 🤖 **api-parser**
  - 📤 `endpoints.json`
  - 📤 `schemas.json`
  - 📤 `metadata.json`
- 🤖 **mcp-generator**
  - 📤 `server.ts`
  - 📤 `handlers/*.ts`
  - 📤 `handlers/_meta.ts`
  - 📤 `mocks/*.ts`

---

## 9. spec-wireframe-edit

- 📄 **직접 참조**
  - `spec-wireframe-edit/references/output-formats.md`
- 📄 **YAML UI Frame Reference**
  - `yaml-ui-frame/01-basic-structure.md`
  - `yaml-ui-frame/02-grid-definition.md`
  - `yaml-ui-frame/03-components.md`
  - `yaml-ui-frame/07-design-direction.md`
- 🤖 **spec-butterfly**
  - *(변경 영향 분석)*
- 🤖 **wireframe-editor**
  - 📄 `yaml-ui-frame/*.md` *(동일 참조)*

---

## 10. init-spec-md

- 📄 **직접 참조**
  - `shared/context-rules.md`
  - `spec-it/assets/templates/SPEC_IT_COMPONENT_TEMPLATE.md`
  - `spec-it/assets/templates/SPEC_IT_PAGE_TEMPLATE.md`
- 🤖 **spec-md-generator**
  - 📄 `SPEC_IT_COMPONENT_TEMPLATE.md`
  - 📄 `SPEC_IT_PAGE_TEMPLATE.md`
- 🤖 **spec-md-maintainer**
  - 📄 `SPEC_IT_COMPONENT_TEMPLATE.md`
  - 📄 `SPEC_IT_PAGE_TEMPLATE.md`

---

## 11. stitch-convert

- 📄 **직접 참조**
  - `shared/rules/05-vercel-skills.md`
- 🔧 **MCP Tools (Not Agents)**
  - `mcp__stitch__create_project`
  - `mcp__stitch__set_workspace_project`
  - `mcp__stitch__generate_screen_from_text`
  - `mcp__stitch__design_qa`
  - `mcp__stitch__export_design_system`

---

## 12. design-trends-2026

- 📄 **제공 문서**
  - `references/trends-summary.md`
  - `references/component-patterns.md`
  - `references/motion-presets.md`
  - `references/color-systems.md`
  - `templates/card-templates.md`
  - `templates/dashboard-templates.md`
  - `templates/form-templates.md`
  - `templates/navigation-templates.md`
  - `integration/agent-prompts.md`
- ⬅️ **Referenced By**
  - `spec-it-stepbystep`
  - `spec-it-complex`
  - `spec-it-automation`
  - `spec-it-fast-launch`

---

## 13. spec-it-mock

- 📄 **직접 참조**
  - `shared/design-token-parser.md`
  - `spec-it-mock/docs/01-design-system-load.md`
  - `spec-it-mock/docs/02-hack-2-spec-integration.md`
  - `spec-it-mock/docs/03-spec-it-execution.md`
  - `shared/rules/05-vercel-skills.md`
- ⚡ **Step 1: hack-2-spec**
  - 📄 `shared/rules/06-output-quality.md`
  - 📄 `shared/templates/_INDEX.md`
  - 📄 `hack-2-spec/docs/*.md`
- ⚡ **Step 2: spec-it-* (선택)**
  - `spec-it-stepbystep`
    - 📄 `shared/output-rules.md`
    - 📄 `shared/templates/*`
    - 📄 `yaml-ui-frame/*.md`
    - 📄 `design-trends-2026/*`
  - `spec-it-complex`
  - `spec-it-automation`
  - `spec-it-fast-launch`

---

## 14. Loader Skills

### spec-scenario-loader
- 📄 **로드 대상**: `05-tests/scenarios/*`
- 🎯 **목적**: 점진적 시나리오 로딩

### spec-component-loader
- 📄 **로드 대상**: `03-components/*`
- 🎯 **목적**: 컴포넌트 스펙 선택적 로딩

### spec-test-loader
- 📄 **로드 대상**: `05-tests/*`
- 🎯 **목적**: 테스트 계획서 점진적 로딩

---

# 전체 Skill 호출 그래프

```
spec-it (Router)
├── spec-it-stepbystep ─┬─→ design-trends-2026
├── spec-it-complex ────┤
├── spec-it-automation ─┤
└── spec-it-fast-launch ┴─→ spec-it-execute

spec-it-mock
├──→ hack-2-spec
└──→ spec-it-* (stepbystep/complex/automation/fast-launch)

spec-mirror
└──→ hack-2-spec

spec-change
└──→ (8 analysis agents)

spec-wireframe-edit
└──→ spec-butterfly, wireframe-editor

spec-it-api-mcp
└──→ api-parser, mcp-generator

init-spec-md
└──→ spec-md-generator, spec-md-maintainer

stitch-convert
└──→ Stitch MCP Tools
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
| `shared/rules/06-output-quality.md` | 5+ |
| `shared/templates/_INDEX.md` | 4+ |
| `shared/output-rules.md` | 4+ |
| `shared/rules/05-vercel-skills.md` | 4+ |
| `yaml-ui-frame/*.md` | 3+ |
| `design-trends-2026/*` | 4 |

---

## 변경 이력

| 버전 | 날짜 | 작성자 | 변경 내용 |
|------|------|--------|----------|
| 1.0 | 2026-02-03 | Claude | 초안 작성 (Mermaid) |
| 2.0 | 2026-02-03 | Claude | Agent/Skill 참조 문서 전체 체인 포함 |
| 3.0 | 2026-02-03 | Claude | 들여쓰기 목록 형식으로 변경 (가독성 개선) |
