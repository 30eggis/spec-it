# Skill/Agent Reference Map

Complete reference chain for each Skill including all agents called and documents referenced.

---

## 1. spec-it-stepbystep (P1-P14)

- 📄 **Direct References**
  - `shared/output-rules.md`
  - `shared/context-rules.md`
  - `shared/rules/50-question-policy.md` (Confirm)
  - `shared/rules/06-output-quality.md`
  - `shared/templates/_INDEX.md`

### Phase Agents

| Phase | Agent | Model | References |
|-------|-------|-------|------------|
| P1 | `design-interviewer` | Opus | *(Q&A-based)* |
| P2 | `persona-architect` | Sonnet | *(requirements-based)* |
| P3 | `divergent-thinker` | Sonnet | *(creative exploration)* |
| P4 | `critic-logic` | Sonnet | *(chapter analysis)* |
| P4 | `critic-feasibility` | Sonnet | *(chapter analysis)* |
| P4 | `critic-frontend` | Sonnet | *(chapter analysis)* |
| P4 | `critic-analytics` | Sonnet | `shared/references/critic-analytics/synthesis-format.md` |
| P5 | `critique-resolver` (skill) | - | `shared/references/critique-resolver/question-templates.md` |
| P6 | `chapter-planner` | Opus | *(critique synthesis)* |
| P7 | `ui-architect` | Sonnet | `yaml-ui-frame/*.md`, `design-trends-2026/*` |
| P8 | `component-auditor` | Haiku | *(codebase scan)* |
| P9 | `component-builder` | Sonnet | `assets/templates/COMPONENT_SPEC_TEMPLATE.yaml` |
| P9 | `component-migrator` | Sonnet | *(inventory-based)* |
| P10 | `context-synthesizer` | Sonnet | `shared/references/context-synthesizer/spec-map-guide.md` |
| P11 | `critical-review` (skill) | - | See below |
| P12 | `test-spec-writer` | Sonnet | `shared/references/common/test-scenario-format.md` |
| P13 | `spec-assembler` | Haiku | *(artifact aggregation)* |
| P14 | `api-predictor` (skill) | - | See below |
| P14 | `dev-planner` | Sonnet | `shared/references/dev-planner/task-template.md` |

---

## 2. spec-it-complex (P1-P14, 4 Milestones)

- 📄 **Direct References**
  - `shared/output-rules.md`
  - `shared/context-rules.md`
  - `shared/rules/50-question-policy.md` (Hybrid)
  - `shared/rules/06-output-quality.md`

### Same agents as stepbystep with milestone grouping:
- Milestone 1: P1-P6
- Milestone 2: P7-P9
- Milestone 3: P10-P11
- Milestone 4: P12-P14

---

## 3. spec-it-automation (P1-P14, Auto)

- 📄 **Direct References**
  - `shared/output-rules.md`
  - `shared/context-rules.md`
  - `shared/rules/50-question-policy.md` (Auto)

### Mode-Specific Agents

| Phase | Agent (Auto Mode) | Model |
|-------|-------------------|-------|
| P5 | `critic-moderator` | Opus |
| P11 | `review-moderator` | Opus |

All other agents same as stepbystep.

---

## 4. critique-resolver (NEW Skill)

- 📄 **Direct References**
  - `shared/references/critique-resolver/question-templates.md`
  - `shared/references/common/critique-solve-format.md`

### Internal Process (No Agents)
- Reads `critique-synthesis.md`
- Presents AskUserQuestion batches
- Outputs `critique-solve/*.md`

---

## 5. critical-review (NEW Skill)

- 📄 **Direct References**
  - `shared/references/critical-review/review-criteria.md`
  - `shared/references/critical-review/ambiguity-format.md`

### Internal Agents

| Agent | Model | Output |
|-------|-------|--------|
| `scenario-reviewer` | Opus | `04-review/scenario-review.md` |
| `ia-reviewer` | Opus | `04-review/ia-review.md` |
| `exception-reviewer` | Opus | `04-review/exception-review.md` |
| `review-analytics` | Sonnet | `04-review/ambiguities.md` |
| `review-resolver` | Sonnet | `04-review/review-decisions.md` (step/comp) |
| `review-moderator` | Opus | `04-review/review-decisions.md` (auto) |

---

## 6. api-predictor (NEW Skill)

- 📄 **Direct References**
  - `shared/references/api-predictor/design-principles.md`
  - `shared/references/api-predictor/api-format.md`

### Internal Process (No Agents)
- Reads `spec-map.md`, wireframes, components
- Outputs `dev-plan/api-map.md`

---

## 7. spec-change

- 📄 **Direct References**
  - `spec-change/references/output-formats.md`
  - `shared/output-rules.md`

### Analysis Agents (Parallel)

| Agent | Model | Output |
|-------|-------|--------|
| `spec-doppelganger` | Sonnet | `_analysis/doppelganger.json` |
| `spec-conflict` | Sonnet | `_analysis/conflict.json` |
| `spec-clarity` | Sonnet | `_analysis/clarity.json` |
| `spec-consistency` | Haiku | `_analysis/consistency.json` |
| `spec-coverage` | Sonnet | `_analysis/coverage.json` |
| `spec-butterfly` | Opus | `_analysis/butterfly.json` |
| `change-planner` | Opus | `_analysis/change-plan.md` |
| `rtm-updater` | Haiku | `_traceability/rtm.json` |

---

## 8. hack-2-spec

- 📄 **Direct References**
  - `shared/rules/06-output-quality.md`
  - `shared/templates/_INDEX.md`
  - `hack-2-spec/docs/01-output-structure.md`
  - `hack-2-spec/docs/00-design-context.md`
  - `shared/design-token-parser.md`
  - `shared/rules/05-vercel-skills.md`

### Referenced By
- `spec-it-mock`
- `spec-mirror`

---

## 9. spec-mirror

- 📄 **Direct References**
  - `spec-mirror/assets/templates/MIRROR_REPORT_TEMPLATE.md`
  - `shared/rules/05-vercel-skills.md`
- ⚡ **Uses Skill: hack-2-spec**

---

## 10. spec-it-api-mcp

- 📄 **Direct References**
  - `spec-it-api-mcp/references/output-schemas.md`
  - `spec-it-api-mcp/references/integration-examples.md`

### Agents

| Agent | Model | Output |
|-------|-------|--------|
| `api-parser` | Sonnet | `endpoints.json`, `schemas.json`, `metadata.json` |
| `mcp-generator` | Sonnet | `server.ts`, `handlers/*.ts`, `mocks/*.ts` |

---

## 11. spec-wireframe-edit

- 📄 **Direct References**
  - `spec-wireframe-edit/references/output-formats.md`
  - `yaml-ui-frame/*.md`

### Agents

| Agent | Model | Role |
|-------|-------|------|
| `spec-butterfly` | Opus | Change impact analysis |
| `wireframe-editor` | Sonnet | YAML modification |

---

## 12. init-spec-md

- 📄 **Direct References**
  - `shared/context-rules.md`
  - `spec-it/assets/templates/SPEC_IT_COMPONENT_TEMPLATE.md`
  - `spec-it/assets/templates/SPEC_IT_PAGE_TEMPLATE.md`

### Agents

| Agent | Model |
|-------|-------|
| `spec-md-generator` | Haiku |
| `spec-md-maintainer` | Haiku |

---

## 13. stitch-convert

- 📄 **Direct References**
  - `shared/rules/05-vercel-skills.md`
- 🔧 **MCP Tools (Not Agents)**
  - `mcp__stitch__create_project`
  - `mcp__stitch__generate_screen_from_text`
  - `mcp__stitch__export_design_system`

---

## 14. design-trends-2026

- 📄 **Provides Documents**
  - `references/trends-summary.md`
  - `references/component-patterns.md`
  - `references/motion-presets.md`
  - `references/color-systems.md`
  - `templates/card-templates.md`
  - `templates/dashboard-templates.md`
  - `templates/form-templates.md`
  - `templates/navigation-templates.md`

### Referenced By
- `spec-it-stepbystep`
- `spec-it-complex`
- `spec-it-automation`
- `spec-it-fast-launch`

---

## 15. Loader Skills

### spec-scenario-loader
- 📂 **Loads**: `05-tests/test-scenarios/*`

### spec-component-loader
- 📂 **Loads**: `03-components/*`

### spec-test-loader
- 📂 **Loads**: `05-tests/*`

---

## Complete Call Graph

```
spec-it (Router)
├── spec-it-stepbystep ──┬─→ design-trends-2026
├── spec-it-complex ─────┤    └─→ critique-resolver (P5)
├── spec-it-automation ──┤    └─→ critical-review (P11)
└── spec-it-fast-launch ─┴─→ spec-it-execute
                              └─→ api-predictor (P14)

spec-it-automation (differs)
├── P5 → critic-moderator (instead of critique-resolver)
└── P11 → review-moderator (instead of review-resolver)

spec-it-mock
├──→ hack-2-spec
└──→ spec-it-* (any mode)

spec-mirror
└──→ hack-2-spec

spec-change
└──→ (8 analysis agents)

critical-review (NEW)
├──→ scenario-reviewer (parallel)
├──→ ia-reviewer (parallel)
├──→ exception-reviewer (parallel)
├──→ review-analytics
└──→ review-resolver OR review-moderator

critique-resolver (NEW)
└──→ (no agents, AskUserQuestion-based)

api-predictor (NEW)
└──→ (no agents, spec analysis-based)
```

---

## New Agent Summary

| Agent | Model | Phase | Role |
|-------|-------|-------|------|
| `critic-analytics` | Sonnet | P4 | Aggregate 3 critics → metrics |
| `context-synthesizer` | Sonnet | P10 | Aggregate artifacts → spec-map.md |
| `scenario-reviewer` | Opus | P11 | Scenario completeness review |
| `ia-reviewer` | Opus | P11 | Information architecture review |
| `exception-reviewer` | Opus | P11 | Exception handling review |
| `review-analytics` | Sonnet | P11 | Aggregate reviews → ambiguities.md |
| `review-resolver` | Sonnet | P11 | User resolution (step/comp) |
| `review-moderator` | Opus | P11 | Auto consensus (auto) |
| `dev-planner` | Sonnet | P14 | Development planning |

---

## New Skill Summary

| Skill | Phase | Role |
|-------|-------|------|
| `critique-resolver` | P5 | User resolution for critiques (step/comp only) |
| `critical-review` | P11 | Review orchestration with parallel reviewers |
| `api-predictor` | P14 | Predict API endpoints from specs |

---

## Shared Reference Summary

### Root Level: `shared/`

| Path | Referenced By |
|------|---------------|
| `references/common/critique-solve-format.md` | critique-resolver, critic-analytics |
| `references/common/spec-map-format.md` | context-synthesizer, spec-assembler |
| `references/common/test-scenario-format.md` | test-spec-writer |
| `references/common/dev-plan-format.md` | dev-planner |
| `references/critic-analytics/synthesis-format.md` | critic-analytics |
| `references/critique-resolver/question-templates.md` | critique-resolver |
| `references/critical-review/review-criteria.md` | scenario-reviewer, ia-reviewer, exception-reviewer |
| `references/critical-review/ambiguity-format.md` | review-analytics |
| `references/dev-planner/task-template.md` | dev-planner |
| `references/api-predictor/design-principles.md` | api-predictor |
| `references/api-predictor/api-format.md` | api-predictor |
| `references/context-synthesizer/spec-map-guide.md` | context-synthesizer |

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-02-03 | Claude | Initial (Mermaid) |
| 2.0 | 2026-02-03 | Claude | Full reference chains |
| 3.0 | 2026-02-03 | Claude | Indented list format |
| 4.0 | 2026-02-03 | Claude | P1-P14 unified flow, new agents/skills |
