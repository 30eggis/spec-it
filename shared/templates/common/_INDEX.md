# Spec-it Output Templates

Standard templates for consistent spec-it output quality across all modes.

## Template List

### 00 - Requirements
| Template | Path | Description |
|----------|------|-------------|
| Requirements | `00-REQUIREMENTS_TEMPLATE.md` | PRD/Requirements document structure |

### 01 - Personas & Chapters
| Template | Path | Description |
|----------|------|-------------|
| Persona | `01-PERSONA_TEMPLATE.md` | User persona definitions |
| Chapter Plan | `01-CHAPTER_PLAN_TEMPLATE.md` | Chapter structure and milestone planning |
| Critique | `01-CRITIQUE_TEMPLATE.md` | Critic review results (feasibility, frontend, logic) |
| Critique Synthesis | `01-CRITIQUE_SYNTHESIS_TEMPLATE.md` | Multi-critic synthesis with conflict resolution |
| Blocker Solution | `01-BLOCKER_SOLUTION_TEMPLATE.md` | Blocker issue resolution documentation |

### 02 - Wireframes & Layouts
| Template | Path | Description |
|----------|------|-------------|
| Screen List | `02-SCREEN_LIST_TEMPLATE.md` | Screen inventory by user mode |
| Domain Map | `02-DOMAIN_MAP_TEMPLATE.md` | Domain-based screen organization |
| Wireframe YAML | `02-WIREFRAME_YAML_TEMPLATE.yaml` | Individual screen wireframe structure |
| Layout System | `02-LAYOUT_SYSTEM_TEMPLATE.yaml` | Design system with tokens, breakpoints, layouts |
| Components YAML | `02-COMPONENTS_YAML_TEMPLATE.yaml` | Component layout specifications in YAML |

### 03 - Components
| Template | Path | Description |
|----------|------|-------------|
| Component Inventory | `03-COMPONENT_INVENTORY_TEMPLATE.md` | Component catalog with props |
| Full Inventory | `03-FULL_INVENTORY_TEMPLATE.md` | Detailed component inventory with usage |
| Gap Analysis | `03-GAP_ANALYSIS_TEMPLATE.md` | Component gap analysis |
| Component Spec | `03-COMPONENT_SPEC_TEMPLATE.md` | New component specifications |
| Migration Plan | `03-MIGRATION_PLAN_TEMPLATE.md` | Component migration planning |

### 04 - Review
| Template | Path | Description |
|----------|------|-------------|
| Review Summary | `04-REVIEW_SUMMARY_TEMPLATE.md` | Spec review and critique results |
| Ambiguities | `04-AMBIGUITIES_TEMPLATE.md` | Specification ambiguity analysis |
| Ambiguity Decisions | `04-AMBIGUITY_DECISIONS_TEMPLATE.md` | Ambiguity resolution decisions |
| IA Review | `04-IA_REVIEW_TEMPLATE.md` | Information Architecture review |
| Scenario Review | `04-SCENARIO_TEMPLATE.md` | User scenario reviews |
| Exception Handling | `04-EXCEPTION_TEMPLATE.md` | Exception handling specifications |

### 05 - Tests
| Template | Path | Description |
|----------|------|-------------|
| Test Personas Overview | `05-TEST_PERSONAS_OVERVIEW_TEMPLATE.md` | Persona overview for test design |
| Test Personas Role | `05-TEST_PERSONAS_ROLE_TEMPLATE.md` | Role-specific detailed personas |
| Test Specifications | `05-TEST_SPECIFICATIONS_TEMPLATE.md` | Unit/Integration/E2E test specs |
| Coverage Map | `05-COVERAGE_MAP_TEMPLATE.md` | Test coverage mapping |
| E2E Test | `05-E2E_TEST_TEMPLATE.md` | E2E test scenario template |
| Component Test | `05-COMPONENT_TEST_TEMPLATE.md` | Component unit/integration tests |

### 06 - Final Output
| Template | Path | Description |
|----------|------|-------------|
| Final Spec | `06-FINAL_SPEC_TEMPLATE.md` | Consolidated final specification |
| Dev Tasks | `06-DEV_TASKS_TEMPLATE.md` | Development task breakdown |
| Spec Summary | `06-SPEC_SUMMARY_TEMPLATE.md` | Quick reference summary |

### Phase & Tasks
| Template | Path | Description |
|----------|------|-------------|
| Phase | `PHASE_TEMPLATE.md` | Phase scope and deliverables |
| Tasks | `TASKS_TEMPLATE.md` | Sprint task breakdown |

### Folder Index (Progressive Loading)
| Template | Path | Description |
|----------|------|-------------|
| _index.md | `_INDEX_TEMPLATE.md` | 폴더별 필수 목차. File Map + When to Read로 점진적 로딩 지원 |

---

## Output Structure

```
{output-folder}/
├── 00-requirements/
│   └── requirements.md              # From 00-REQUIREMENTS_TEMPLATE.md
├── 01-persona/
│   └── personas.md                  # From 01-PERSONA_TEMPLATE.md
├── 01-chapters/
│   ├── chapter-plan-final.md        # From 01-CHAPTER_PLAN_TEMPLATE.md
│   ├── critique-round1-*.md         # From 01-CRITIQUE_TEMPLATE.md
│   ├── critique-synthesis.md        # From 01-CRITIQUE_SYNTHESIS_TEMPLATE.md
│   └── critique-solve/
│       └── blocker-*.md             # From 01-BLOCKER_SOLUTION_TEMPLATE.md
├── 02-wireframes/
│   ├── domain-map.md                # From 02-DOMAIN_MAP_TEMPLATE.md
│   ├── screen-list.md               # From 02-SCREEN_LIST_TEMPLATE.md
│   ├── layouts/
│   │   ├── layout-system.yaml       # From 02-LAYOUT_SYSTEM_TEMPLATE.yaml
│   │   └── components.yaml          # From 02-COMPONENTS_YAML_TEMPLATE.yaml
│   └── {domain}/{user-type}/
│       ├── screen-list.md
│       └── wireframes/
│           └── {screen-id}.yaml     # From 02-WIREFRAME_YAML_TEMPLATE.yaml
├── 03-components/
│   ├── inventory.md                 # From 03-FULL_INVENTORY_TEMPLATE.md
│   ├── component-inventory.md       # From 03-COMPONENT_INVENTORY_TEMPLATE.md
│   ├── gap-analysis.md              # From 03-GAP_ANALYSIS_TEMPLATE.md
│   ├── new/
│   │   └── spec-*.md                # From 03-COMPONENT_SPEC_TEMPLATE.md
│   └── migrations/
│       └── migration-plan.md        # From 03-MIGRATION_PLAN_TEMPLATE.md
├── 04-review/
│   ├── review-summary.md            # From 04-REVIEW_SUMMARY_TEMPLATE.md
│   ├── ambiguities.md               # From 04-AMBIGUITIES_TEMPLATE.md
│   ├── ambiguity-decisions.md       # From 04-AMBIGUITY_DECISIONS_TEMPLATE.md
│   ├── ia-review.md                 # From 04-IA_REVIEW_TEMPLATE.md
│   ├── scenarios/
│   │   └── *-scenario.md            # From 04-SCENARIO_TEMPLATE.md
│   └── exceptions/
│       └── *.md                     # From 04-EXCEPTION_TEMPLATE.md
├── 05-tests/
│   ├── README.md
│   ├── test-specifications.md       # From 05-TEST_SPECIFICATIONS_TEMPLATE.md
│   ├── coverage-map.md              # From 05-COVERAGE_MAP_TEMPLATE.md
│   ├── components/
│   │   └── *.spec.md                # From 05-COMPONENT_TEST_TEMPLATE.md
│   ├── personas/
│   │   ├── 00-personas-overview.md  # From 05-TEST_PERSONAS_OVERVIEW_TEMPLATE.md
│   │   └── {NN}-{role}-personas.md  # From 05-TEST_PERSONAS_ROLE_TEMPLATE.md
│   └── scenarios/
│       └── e2e-*.spec.md            # From 05-E2E_TEST_TEMPLATE.md
├── 06-final/
│   ├── final-spec.md                # From 06-FINAL_SPEC_TEMPLATE.md
│   ├── dev-tasks.md                 # From 06-DEV_TASKS_TEMPLATE.md
│   ├── SPEC-SUMMARY.md              # From 06-SPEC_SUMMARY_TEMPLATE.md
│   └── _INDEX.md
├── phases/
│   └── PHASE-*.md                   # From PHASE_TEMPLATE.md
├── tasks/
│   └── TASKS-PHASE-*.md             # From TASKS_TEMPLATE.md
└── resume-info.md
```

---

## Usage

All spec-it modes (stepbystep, complex, automation, fast-launch) and hack-2-spec must use these templates to ensure consistent output quality.

### Template Selection by Mode

| Mode | Templates Used |
|------|---------------|
| stepbystep | All templates (full approval cycle) |
| complex | All templates (milestone approval) |
| automation | All templates (auto-generated) |
| fast-launch | Core templates only (02, 06) |
| hack-2-spec | All templates (reverse-engineering) |

### Key Quality Standards

1. **Document Information Table**: Every document starts with metadata table
2. **Section Numbering**: Hierarchical numbering (1.1, 1.2, 2.1...)
3. **Requirement IDs**: REQ-{Domain}-{Seq} format
4. **Component IDs**: COMP-{Seq} format
5. **Screen IDs**: SCR-{Mode}-{Seq} format
6. **Test IDs**: {Type}-{Category}-{Seq} format
7. **Task IDs**: TASK-P{Phase}-{Seq} format
8. **Issue IDs**: {Category}-{Seq} format (e.g., AMB-001, IA-001, EC-001)
9. **Critique IDs**: C-{Seq} format for blocker issues

### Placeholder Syntax

Templates use Handlebars-style placeholders:
- `{{variable}}` - Simple value
- `{{#each items}}...{{/each}}` - Iteration
- `{{#if condition}}...{{/if}}` - Conditional
- `{{@index}}` - Loop index (0-based)

---

## Template Statistics

| Category | Count |
|----------|-------|
| 00-Requirements | 1 |
| 01-Personas & Chapters | 5 |
| 02-Wireframes & Layouts | 5 |
| 03-Components | 5 |
| 04-Review | 6 |
| 05-Tests | 6 |
| 06-Final | 3 |
| Phase & Tasks | 2 |
| Folder Index | 1 |
| **Total** | **34** |
