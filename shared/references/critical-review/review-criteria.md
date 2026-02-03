# Critical Review Criteria

> Referenced by: critical-review skill (all review agents)

## Purpose

Defines the evaluation criteria for each reviewer in the critical-review skill (P11).

---

## Scenario Reviewer Criteria

### Focus Areas

1. **Completeness**
   - All user stories have scenarios
   - Happy and sad paths defined
   - Edge cases identified

2. **Consistency**
   - Scenarios align with wireframes
   - Data flows match component states
   - Terminology consistent

3. **Testability**
   - Clear preconditions
   - Observable outcomes
   - Measurable success criteria

### Checklist

| ID | Check | Pass Criteria |
|----|-------|---------------|
| SC-01 | Every persona has scenarios | 100% coverage |
| SC-02 | Happy path complete | All primary flows |
| SC-03 | Sad path defined | All error states |
| SC-04 | Test data specified | Sample data exists |
| SC-05 | Wireframe alignment | IDs match |

### Red Flags

- Scenario references non-existent screen
- Missing error handling for form submission
- No timeout/loading states defined
- Conflicting success criteria

---

## IA (Information Architecture) Reviewer Criteria

### Focus Areas

1. **Navigation Structure**
   - Clear hierarchy
   - Consistent depth
   - Logical grouping

2. **Content Organization**
   - No orphaned pages
   - Clear parent-child relationships
   - Sensible URL structure

3. **Cross-Persona Access**
   - Role-based visibility
   - Shared vs. exclusive content
   - Permission boundaries

### Checklist

| ID | Check | Pass Criteria |
|----|-------|---------------|
| IA-01 | Navigation depth | Max 3 levels |
| IA-02 | Orphan check | 0 orphaned screens |
| IA-03 | Role mapping | All screens have owner |
| IA-04 | URL consistency | Pattern followed |
| IA-05 | Breadcrumb logic | Valid at all levels |

### Red Flags

- Screen accessible but not in navigation
- Same screen under multiple parents
- Deep nesting (>3 levels)
- Missing back/home navigation
- Inconsistent naming conventions

---

## Exception Reviewer Criteria

### Focus Areas

1. **Error Handling**
   - All form validations defined
   - API error responses handled
   - Network failure states

2. **Boundary Conditions**
   - Empty states defined
   - Maximum limits specified
   - Edge case behaviors

3. **Recovery Paths**
   - User can recover from errors
   - Data preservation on failure
   - Clear error messages

### Checklist

| ID | Check | Pass Criteria |
|----|-------|---------------|
| EX-01 | Form validation | All fields covered |
| EX-02 | API errors | 4xx, 5xx handled |
| EX-03 | Empty states | All lists covered |
| EX-04 | Loading states | All async ops |
| EX-05 | Recovery actions | Clear next steps |

### Red Flags

- Form without validation rules
- API call without error handling
- List without empty state
- Submit without loading indicator
- Error message without recovery action

---

## Cross-Reviewer Synthesis

### Conflict Detection

When reviewers disagree:

| Scenario Says | IA Says | Exception Says | Resolution |
|---------------|---------|----------------|------------|
| Flow exists | Screen missing | - | Add screen |
| - | Path exists | Error undefined | Add error handling |
| Edge case | - | Boundary unclear | Define boundary |

### Priority Matrix

| Issue Type | Scenario Impact | IA Impact | Exception Impact | Priority |
|------------|-----------------|-----------|------------------|----------|
| Missing screen | High | High | Medium | P0 |
| Unclear navigation | Low | High | Low | P1 |
| Missing error state | Medium | Low | High | P1 |
| Edge case undefined | High | Low | High | P1 |

---

## Scoring Guide

### Per-Reviewer Score

```
Score = (passed_checks / total_checks) * 100

Verdict:
- 90-100%: PASS
- 70-89%: WARN
- <70%: FAIL
```

### Overall Assessment

```
Final = min(scenario_verdict, ia_verdict, exception_verdict)

If any FAIL → Overall FAIL
If any WARN, no FAIL → Overall WARN
All PASS → Overall PASS
```

---

## Output Format

### Individual Review

```markdown
# {{Reviewer}} Review

## Score: {{score}}%
## Verdict: {{PASS|WARN|FAIL}}

### Passed Checks
- [x] {{check_description}}

### Failed Checks
- [ ] {{check_description}}
  - **Finding:** {{finding}}
  - **Impact:** {{impact}}
  - **Recommendation:** {{recommendation}}

### Ambiguities Found
- AMB-{{id}}: {{description}}
```

### Synthesized Review

```markdown
# Critical Review Summary

## Verdicts

| Reviewer | Score | Verdict |
|----------|-------|---------|
| Scenario | {{score}}% | {{verdict}} |
| IA | {{score}}% | {{verdict}} |
| Exception | {{score}}% | {{verdict}} |
| **Overall** | - | **{{verdict}}** |

## Must Resolve ({{count}})
{{list}}

## Action Required
{{next_steps}}
```

---

## Validation Rules

1. All three reviewers must complete
2. Every failed check needs recommendation
3. Ambiguities must have unique IDs
4. Cross-references must be validated
