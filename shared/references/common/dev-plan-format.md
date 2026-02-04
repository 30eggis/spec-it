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

---

## CRITICAL: Full Scope Requirements (함축 금지)

### Rule 1: ALL Chapters Must Be Included
```yaml
requirement: MANDATORY
check: chapters_in_devplan == chapters_in_spec

# Example verification
chapter_plan_final: CH-00, CH-01, CH-02, ..., CH-11 (12 chapters)
development_map: Must include tasks for ALL 12 chapters

❌ VIOLATION: "P0 MVP scope: CH-00 to CH-06"
✅ CORRECT: "Full scope: CH-00 to CH-11"
```

### Rule 2: ALL Screens Must Be Covered
```yaml
requirement: MANDATORY
check: screens_in_tasks == screens_in_spec

# Example verification
screen_list: 25 screens + 9 modals
development_map: Must have tasks covering ALL 34 UI elements

❌ VIOLATION: "14 screens for MVP release"
✅ CORRECT: "All 25 screens + 9 modals"
```

### Rule 3: NO Priority-Based Exclusion
```yaml
priority_usage:
  P0: Execute first (highest priority)
  P1: Execute second
  P2: Execute last

priority_NOT_for:
  - Excluding features from plan
  - Deferring to "future releases"
  - Creating "MVP only" scope

❌ VIOLATION: "P1/P2 features deferred to Phase 2 release"
✅ CORRECT: "P1 tasks follow P0, P2 tasks follow P1"
```

### Rule 4: Completeness Checklist

Before finalizing development-map.md:

```markdown
## Scope Verification

| Check | Expected | Actual | Status |
|-------|----------|--------|--------|
| Total Chapters | {N from spec} | {N in plan} | ✓/✗ |
| Total Screens | {N from spec} | {N in plan} | ✓/✗ |
| Total Modals | {N from spec} | {N in plan} | ✓/✗ |
| P0 Chapters | {list} | {list} | ✓/✗ |
| P1 Chapters | {list} | {list} | ✓/✗ |
| P2 Chapters | {list} | {list} | ✓/✗ |
| MVP-only language | None | None | ✓/✗ |
| Deferred language | None | None | ✓/✗ |
```

### Rule 5: Rejected Patterns

The following patterns will cause plan REJECTION:

```
❌ "This plan prioritizes P0 MVP scope"
❌ "P1 features will be addressed in future releases"
❌ "MVP-critical features only"
❌ "Deferred to Phase 2"
❌ "Out of scope for initial delivery"
❌ "Nice-to-have features excluded"
```

### Rule 6: Language Consistency

If spec uses specific language (e.g., Korean):
```
❌ WRONG: English labels when spec is Korean
❌ WRONG: English mock data when spec uses Korean names
✅ CORRECT: Match spec language exactly
```
