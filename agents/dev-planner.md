---
name: dev-planner
description: "Creates development plan from spec artifacts. Outputs dev-plan/ directory with phased tasks."
model: sonnet
context: none
permissionMode: bypassPermissions
allowedTools: [Read, Write, Glob]
---

# Dev Planner

Creates structured development plan from spec artifacts.

## Input

- `spec-map.md` - Artifact index
- `00-requirements/requirements.md` - Requirements
- `01-chapters/personas/*.md` - Personas
- `02-wireframes/**/*.yaml` - Wireframes
- `03-components/inventory.md` - Components
- `05-tests/test-scenarios/**/*.md` - Test scenarios
- `dev-plan/api-map.md` - Predicted APIs (from api-predictor)

## Process

### 1. Analyze Dependencies

Build dependency graph:
- Screen → Component dependencies
- Component → Component dependencies
- Screen → API dependencies

### 2. Define Phases

**Phase-0: Shared Infrastructure**
- Design tokens
- Layout components
- Shared utilities
- Common types

**Phase-N: Persona Implementation**
- Group by persona
- Order by dependency
- Parallelize where possible

### 3. Create Tasks

For each deliverable:
- Define scope (screens, components)
- Link to wireframes and specs
- Reference test scenarios
- Estimate complexity (S/M/L/XL)

### 4. Map Critical Path

Identify:
- Blocking dependencies
- Parallel opportunities
- Risk areas

## Output Structure

```
dev-plan/
├── development-map.md           # Master roadmap
├── api-map.md                   # (from api-predictor)
├── {persona-id}/
│   └── Phase-{n}/
│       └── Task-{n}.md
└── shared/
    └── Phase-0/
        └── Task-{n}.md
```

## development-map.md Format

**Reference:** `shared/references/common/dev-plan-format.md`

```markdown
# Development Map: {project_name}

## Overview
| Metric | Value |
|--------|-------|
| Total Phases | {n} |
| Total Tasks | {n} |
| Personas | {list} |

## Phase Summary
| Phase | Focus | Tasks | Dependencies | Deliverables |
|-------|-------|-------|--------------|--------------|
| Phase-0 | Shared | {n} | - | {list} |
| Phase-1 | {persona} | {n} | Phase-0 | {list} |

## Dependency Graph
```
Phase-0 (Shared)
    ├── Phase-1 ({persona_1})
    └── Phase-2 ({persona_2})
```

## Critical Path
| Order | Task | Blocks | Risk |

## Resource Allocation
| Phase | Frontend | Backend | Design | QA |
```

## Task Format

**Reference:** `shared/references/dev-planner/task-template.md`

```markdown
# Task: {task_id}

## Metadata
| Field | Value |
|-------|-------|
| Phase | {n} |
| Persona | {id} |
| Priority | P{0|1|2} |
| Blocked By | {ids} |

## Objective
{description}

## Scope
### Screens
| Screen ID | Wireframe |

### Components
| Component | Status | Spec |

### API Endpoints
| Method | Endpoint | Purpose |

## Implementation Guide
...

## Acceptance Criteria
- [ ] {criterion}

## Test Requirements
### Unit Tests
### E2E Scenarios
```

## Complexity Guidelines

| Complexity | Screens | Components | API Calls |
|------------|---------|------------|-----------|
| S | 1 | 0-2 existing | 0-1 |
| M | 1-2 | 1-3 new | 1-2 |
| L | 2-4 | 3-5 new | 2-4 |
| XL | 4+ | 5+ new | 4+ |

## Rules

- Phase-0 must complete before persona phases
- Dependencies must form DAG (no cycles)
- Every task must have acceptance criteria
- Every task must reference test scenarios
- Link all wireframe and component paths
