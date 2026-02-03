# Task Template Reference

> Referenced by: dev-planner (exclusive)

## Purpose

Detailed template for generating individual task specifications in the dev-plan.

---

## Task File: Task-{n}.md

```markdown
# Task: {{task_id}}

## Metadata

| Field | Value |
|-------|-------|
| ID | {{task_id}} |
| Phase | {{phase_number}} |
| Persona | {{persona_id}} or "shared" |
| Title | {{brief_title}} |
| Priority | P{{0|1|2}} |
| Status | pending |
| Blocked By | {{dependency_ids}} |
| Blocks | {{dependent_ids}} |
| Estimated Complexity | {{S|M|L|XL}} |

---

## Objective

{{Clear, actionable objective statement. What will be true when this task is complete?}}

---

## Context

### Related Requirements
| Req ID | Description |
|--------|-------------|
| {{req_id}} | {{brief}} |

### User Stories Addressed
| Story ID | As a... | I want... |
|----------|---------|-----------|
| {{story_id}} | {{persona}} | {{goal}} |

---

## Scope

### Screens to Implement

| Screen ID | Title | Wireframe | Priority |
|-----------|-------|-----------|----------|
| {{screen_id}} | {{title}} | `{{wireframe_path}}` | P{{n}} |

### Components Required

| Component | Status | Spec File | Notes |
|-----------|--------|-----------|-------|
| {{name}} | new | `{{spec_path}}` | {{notes}} |
| {{name}} | existing | - | From {{source}} |
| {{name}} | migrate | `{{migration_path}}` | From {{source}} |

### API Endpoints

| Method | Endpoint | Purpose | API Map Ref |
|--------|----------|---------|-------------|
| {{method}} | `{{endpoint}}` | {{purpose}} | §{{section}} |

---

## Implementation Guide

### 1. Prerequisites

Before starting:
- [ ] Verify blocked-by tasks complete
- [ ] Review wireframe: `{{wireframe_path}}`
- [ ] Review component specs: `{{component_paths}}`
- [ ] Check API contracts in `api-map.md`

### 2. File Structure

```
src/
├── app/
│   └── {{route}}/
│       ├── page.tsx          # {{screen_id}}
│       └── components/
│           └── {{local_components}}
├── components/
│   └── {{shared_components}}
└── lib/
    └── {{utilities}}
```

### 3. Component Development

#### {{component_name}}

**Spec Reference:** `{{spec_path}}`

**Key Props:**
```typescript
interface {{ComponentName}}Props {
  {{prop}}: {{type}};  // {{description}}
}
```

**States to Handle:**
- Default: {{description}}
- Loading: {{description}}
- Error: {{description}}
- Empty: {{description}}

**Variants:**
{{#each variants}}
- `{{name}}`: {{description}}
{{/each}}

### 4. Screen Assembly

**Layout:** {{layout_type}} from `layout-system.yaml`

**Grid Structure:**
```
{{grid_areas}}
```

**Data Requirements:**
| Data | Source | Loading Strategy |
|------|--------|------------------|
| {{data}} | {{source}} | {{strategy}} |

### 5. State Management

**Local State:**
```typescript
// {{state_description}}
const [{{state}}, set{{State}}] = useState<{{Type}}>({{initial}});
```

**Server State:**
```typescript
// Using {{library}}
{{query_example}}
```

### 6. API Integration

**Endpoint:** `{{method}} {{endpoint}}`

**Request:**
```typescript
{{request_type}}
```

**Response:**
```typescript
{{response_type}}
```

**Error Handling:**
| Status | User Message | Recovery Action |
|--------|--------------|-----------------|
| 400 | {{message}} | {{action}} |
| 401 | {{message}} | {{action}} |
| 500 | {{message}} | {{action}} |

---

## Acceptance Criteria

### Functional
- [ ] {{criterion}} (testable, measurable)
- [ ] {{criterion}}
- [ ] {{criterion}}

### Non-Functional
- [ ] Page loads in <{{n}}ms
- [ ] Responsive at {{breakpoints}}
- [ ] Accessibility: {{wcag_level}}

### Integration
- [ ] API calls succeed with mock/real backend
- [ ] State syncs correctly
- [ ] Navigation works as specified

---

## Test Requirements

### Unit Tests

| Component | Test File | Coverage Target |
|-----------|-----------|-----------------|
| {{component}} | `{{test_path}}` | {{pct}}% |

**Key Test Cases:**
- [ ] {{test_case_1}}
- [ ] {{test_case_2}}

### Integration Tests

| Flow | Test File | Priority |
|------|-----------|----------|
| {{flow}} | `{{test_path}}` | P{{n}} |

### E2E Scenarios

**Reference:** `test-scenarios/{{persona}}/{{feature}}/`

| Scenario ID | Type | Automated |
|-------------|------|-----------|
| {{id}} | {{happy|sad}} | {{yes|no}} |

---

## Design Tokens

**Reference:** `shared/design-tokens.yaml`

```yaml
# Key tokens for this task
colors:
  primary: {{token}}
  background: {{token}}
spacing:
  container: {{token}}
typography:
  heading: {{token}}
```

---

## Technical Notes

### Dependencies
```json
{
  "{{package}}": "{{version}}"
}
```

### Known Constraints
- {{constraint_1}}
- {{constraint_2}}

### Performance Considerations
- {{consideration_1}}
- {{consideration_2}}

---

## References

| Type | Path |
|------|------|
| Wireframe | `{{path}}` |
| Component Spec | `{{path}}` |
| Test Scenarios | `{{path}}` |
| API Map | `dev-plan/api-map.md#{{section}}` |
| Requirements | `00-requirements/requirements.md#{{section}}` |

---

## Completion Checklist

- [ ] All screens implemented
- [ ] All components built/integrated
- [ ] API integration complete
- [ ] Unit tests passing ({{target}}% coverage)
- [ ] Integration tests passing
- [ ] E2E scenarios validated
- [ ] Accessibility audit passed
- [ ] Code review approved
- [ ] Documentation updated
```

---

## Complexity Guidelines

| Complexity | Screens | Components | API Calls | Typical Duration |
|------------|---------|------------|-----------|------------------|
| S | 1 | 0-2 existing | 0-1 | - |
| M | 1-2 | 1-3 new | 1-2 | - |
| L | 2-4 | 3-5 new | 2-4 | - |
| XL | 4+ | 5+ new | 4+ | - |

---

## Validation Rules

1. Every task must have:
   - Clear objective (single sentence)
   - At least one acceptance criterion
   - All screen/component references valid
   - Test requirements defined

2. Dependencies must:
   - Form valid DAG
   - Not create cycles
   - Be in correct phase order

3. API endpoints must:
   - Match api-map.md
   - Include error handling
   - Specify request/response types
