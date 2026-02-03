# Dev Plan Format

> Referenced by: dev-planner, spec-assembler, spec-it-execute

## Directory Structure

```
dev-plan/
├── development-map.md           # Master development roadmap
├── api-map.md                   # Predicted API endpoints
├── {persona-id}/
│   └── Phase-{n}/
│       └── Task-{n}.md          # Individual task specs
└── shared/
    └── Phase-0/                 # Shared infrastructure tasks
        └── Task-{n}.md
```

---

## development-map.md

```markdown
# Development Map: {{project_name}}

## Overview

| Metric | Value |
|--------|-------|
| Total Phases | {{phase_count}} |
| Total Tasks | {{task_count}} |
| Estimated Complexity | {{complexity}} |
| Personas | {{personas}} |

---

## Phase Summary

| Phase | Focus | Tasks | Dependencies | Deliverables |
|-------|-------|-------|--------------|--------------|
| Phase-0 | Shared Infrastructure | {{count}} | - | {{deliverables}} |
| Phase-1 | {{persona}} Core | {{count}} | Phase-0 | {{deliverables}} |
| Phase-2 | {{persona}} Core | {{count}} | Phase-0 | {{deliverables}} |

---

## Dependency Graph

```
Phase-0 (Shared)
    ├── Phase-1 ({{persona_1}})
    │   ├── Task-1 → Task-2 → Task-3
    │   └── Task-4 (parallel)
    └── Phase-2 ({{persona_2}})
        └── Task-1 → Task-2
```

---

## Phase Details

### Phase-0: Shared Infrastructure

**Objective:** {{objective}}

| Task | Title | Priority | Estimate | Status |
|------|-------|----------|----------|--------|
| T-0-1 | {{title}} | P0 | {{est}} | pending |

**Deliverables:**
- [ ] {{deliverable_1}}
- [ ] {{deliverable_2}}

---

### Phase-1: {{persona_id}} Implementation

**Objective:** {{objective}}
**Screens:** {{screen_count}}
**Components:** {{component_count}}

| Task | Title | Screen | Components | Priority |
|------|-------|--------|------------|----------|
| T-1-1 | {{title}} | {{screen}} | {{components}} | P0 |

---

## Critical Path

| Order | Task | Blocks | Risk |
|-------|------|--------|------|
| 1 | T-0-1 | T-1-1, T-2-1 | {{risk}} |
| 2 | T-1-1 | T-1-2 | {{risk}} |

---

## Resource Allocation

| Phase | Frontend | Backend | Design | QA |
|-------|----------|---------|--------|-------|
| Phase-0 | {{fe}} | {{be}} | {{design}} | {{qa}} |
| Phase-1 | {{fe}} | {{be}} | {{design}} | {{qa}} |

---

## Risk Register

| ID | Risk | Impact | Probability | Mitigation |
|----|------|--------|-------------|------------|
| R-1 | {{risk}} | High | Medium | {{mitigation}} |
```

---

## Task Template (Task-{n}.md)

```markdown
# Task: {{task_id}}

## Metadata

| Field | Value |
|-------|-------|
| Phase | {{phase}} |
| Persona | {{persona}} |
| Priority | {{priority}} |
| Status | pending |
| Blocked By | {{dependencies}} |

---

## Objective

{{objective_description}}

---

## Scope

### Screens
| Screen ID | Title | File |
|-----------|-------|------|
| {{screen_id}} | {{title}} | {{wireframe_path}} |

### Components
| Component | Action | File |
|-----------|--------|------|
| {{component}} | Create/Modify | {{spec_path}} |

### API Endpoints
| Method | Endpoint | Purpose |
|--------|----------|---------|
| {{method}} | {{endpoint}} | {{purpose}} |

---

## Implementation Steps

### 1. Setup
- [ ] {{step_1}}
- [ ] {{step_2}}

### 2. Component Development
- [ ] {{step_1}}
- [ ] {{step_2}}

### 3. Integration
- [ ] {{step_1}}
- [ ] {{step_2}}

### 4. Testing
- [ ] Unit tests
- [ ] Integration tests
- [ ] E2E coverage

---

## Acceptance Criteria

- [ ] {{criterion_1}}
- [ ] {{criterion_2}}
- [ ] {{criterion_3}}

---

## Test Scenarios

**Reference:** `test-scenarios/{{persona}}/{{feature}}/`

| Scenario | Type | Status |
|----------|------|--------|
| {{scenario}} | {{type}} | pending |

---

## Technical Notes

### Design Tokens
```yaml
{{design_tokens}}
```

### State Management
{{state_notes}}

### Error Handling
{{error_notes}}

---

## References

- Wireframe: `{{wireframe_path}}`
- Component Spec: `{{component_path}}`
- Test Scenarios: `{{test_path}}`
- API Map: `dev-plan/api-map.md#{{api_section}}`
```

---

## Validation Rules

1. Every task must have:
   - Clear objective
   - Defined scope (screens/components)
   - Acceptance criteria
   - Test scenario references

2. Dependencies must form a DAG (no cycles)

3. Phase-0 must complete before persona phases

4. All wireframe/component references must exist
