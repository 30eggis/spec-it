# Test Scenario Format

> Referenced by: test-spec-writer, persona-architect

## Directory Structure

```
test-scenarios/
├── _index.md                    # Master index
├── {persona-id}/
│   ├── overview.md              # Persona test overview
│   ├── {feature}/
│   │   ├── happy-cases.md       # Success paths
│   │   └── sad-cases.md         # Failure paths
│   └── coverage-matrix.md       # Coverage tracking
└── cross-persona/               # REQUIRED
    ├── _index.md                # Cross-persona index
    ├── {flow-id}.md             # Multi-persona flows
    └── interaction-matrix.md    # Persona interaction map
```

---

## _index.md (Master Index)

```markdown
# Test Scenarios Index

## Overview

| Metric | Value |
|--------|-------|
| Total Scenarios | {{total}} |
| Personas Covered | {{persona_count}} |
| Cross-Persona Flows | {{cross_count}} |
| Coverage Target | {{target}}% |

---

## By Persona

| Persona ID | Name | Scenarios | Coverage |
|------------|------|-----------|----------|
| {{id}} | {{name}} | {{count}} | {{pct}}% |

---

## Cross-Persona Flows

| Flow ID | Description | Personas | Priority |
|---------|-------------|----------|----------|
| {{id}} | {{desc}} | {{personas}} | {{priority}} |

---

## Quick Links

### Persona Scenarios
{{#each personas}}
- [{{name}}](./{{id}}/overview.md)
{{/each}}

### Cross-Persona
- [Cross-Persona Index](./cross-persona/_index.md)
- [Interaction Matrix](./cross-persona/interaction-matrix.md)
```

---

## Persona Overview (overview.md)

```markdown
# {{persona_name}} Test Overview

## Persona Summary

| Attribute | Value |
|-----------|-------|
| ID | {{persona_id}} |
| Role | {{role}} |
| Primary Goals | {{goals}} |
| Tech Proficiency | {{tech_level}} |

---

## Feature Coverage

| Feature | Happy | Sad | Edge | Status |
|---------|-------|-----|------|--------|
| {{feature}} | {{happy}} | {{sad}} | {{edge}} | {{status}} |

---

## Priority Scenarios

### P0 - Critical Path
{{#each p0_scenarios}}
- [ ] {{id}}: {{title}}
{{/each}}

### P1 - Important
{{#each p1_scenarios}}
- [ ] {{id}}: {{title}}
{{/each}}

---

## Test Data Requirements

| Data Type | Sample | Constraints |
|-----------|--------|-------------|
| {{type}} | {{sample}} | {{constraints}} |
```

---

## Happy Cases (happy-cases.md)

```markdown
# {{feature}} - Happy Path Scenarios

## Scenario: {{scenario_id}}

### {{title}}

**Preconditions:**
{{#each preconditions}}
- {{condition}}
{{/each}}

**Steps:**
| Step | Action | Expected Result |
|------|--------|-----------------|
| 1 | {{action}} | {{expected}} |
| 2 | {{action}} | {{expected}} |

**Postconditions:**
{{#each postconditions}}
- {{condition}}
{{/each}}

**Test Data:**
```json
{{test_data}}
```

**Related Wireframe:** `{{wireframe_path}}`
**Component Under Test:** `{{component}}`

---
```

---

## Sad Cases (sad-cases.md)

```markdown
# {{feature}} - Sad Path Scenarios

## Scenario: {{scenario_id}}

### {{title}}

**Error Type:** {{error_type}}
**Severity:** {{severity}}

**Preconditions:**
{{#each preconditions}}
- {{condition}}
{{/each}}

**Trigger:**
{{trigger_description}}

**Expected Behavior:**
| Aspect | Expected |
|--------|----------|
| Error Message | {{message}} |
| UI State | {{ui_state}} |
| Recovery Action | {{recovery}} |

**Edge Cases:**
{{#each edge_cases}}
- {{case}}
{{/each}}

---
```

---

## Coverage Matrix (coverage-matrix.md)

```markdown
# {{persona_id}} Coverage Matrix

## Feature × Scenario Type

| Feature | Happy | Sad | Edge | Accessibility | Total |
|---------|-------|-----|------|---------------|-------|
| {{feature}} | {{happy}} | {{sad}} | {{edge}} | {{a11y}} | {{total}} |

## Screen × Test Coverage

| Screen ID | Unit | Integration | E2E | Status |
|-----------|------|-------------|-----|--------|
| {{screen}} | {{unit}} | {{integration}} | {{e2e}} | {{status}} |

## Uncovered Areas

| Area | Reason | Priority |
|------|--------|----------|
| {{area}} | {{reason}} | {{priority}} |
```

---

## Cross-Persona Flow ({flow-id}.md)

```markdown
# Cross-Persona Flow: {{flow_id}}

## Flow Overview

**Description:** {{description}}
**Business Value:** {{value}}

## Participating Personas

| Order | Persona | Role in Flow | Handoff Point |
|-------|---------|--------------|---------------|
| 1 | {{persona_1}} | {{role_1}} | {{handoff_1}} |
| 2 | {{persona_2}} | {{role_2}} | {{handoff_2}} |

---

## Flow Diagram

```
[{{persona_1}}] --{{action}}--> [System] --{{notification}}--> [{{persona_2}}]
                                    |
                              [State Change]
```

---

## Step-by-Step Scenario

### Phase 1: {{persona_1}} Action

| Step | Actor | Action | System Response |
|------|-------|--------|-----------------|
| 1.1 | {{persona}} | {{action}} | {{response}} |

### Phase 2: {{persona_2}} Action

| Step | Actor | Action | System Response |
|------|-------|--------|-----------------|
| 2.1 | {{persona}} | {{action}} | {{response}} |

---

## Integration Points

| Point | From | To | Data Exchanged |
|-------|------|----|----------------|
| {{point}} | {{from}} | {{to}} | {{data}} |

---

## Failure Scenarios

| Failure Point | Impact | Recovery |
|---------------|--------|----------|
| {{point}} | {{impact}} | {{recovery}} |
```

---

## Interaction Matrix (interaction-matrix.md)

```markdown
# Persona Interaction Matrix

## Direct Interactions

|  | {{persona_1}} | {{persona_2}} | {{persona_3}} |
|--|---------------|---------------|---------------|
| {{persona_1}} | - | {{interaction}} | {{interaction}} |
| {{persona_2}} | {{interaction}} | - | {{interaction}} |

## Interaction Types

- **Approval**: One persona approves another's action
- **Notification**: System notifies based on action
- **Handoff**: Work item passes between personas
- **Escalation**: Issue escalates to higher authority

## Flow Dependencies

| Flow | Depends On | Blocks |
|------|------------|--------|
| {{flow}} | {{depends}} | {{blocks}} |
```

---

## Validation Rules

1. Every persona must have at least one cross-persona flow
2. All flows must have defined handoff points
3. Coverage matrix must show 80%+ for P0 features
4. Sad cases must cover all error types from wireframes
