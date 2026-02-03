# Critique Solve Output Format

> Referenced by: critique-resolver, critic-analytics, critic-moderator

## Directory Structure

```
critique-solve/
├── merged-decisions.md      # Consolidated decisions from all critics
├── ambiguity-resolved.md    # User-resolved ambiguities
└── undefined-specs.md       # Specs deferred for later definition
```

---

## merged-decisions.md

```markdown
# Critique Resolution Decisions

## Summary

| Category | Total | Resolved | Deferred | User Input |
|----------|-------|----------|----------|------------|
| Logic | {{count}} | {{resolved}} | {{deferred}} | {{user_input}} |
| Feasibility | {{count}} | {{resolved}} | {{deferred}} | {{user_input}} |
| Frontend | {{count}} | {{resolved}} | {{deferred}} | {{user_input}} |

---

## Resolved Issues

### CRITICAL

| ID | Source | Issue | Resolution | Rationale |
|----|--------|-------|------------|-----------|
| {{id}} | {{critic}} | {{issue}} | {{resolution}} | {{rationale}} |

### MAJOR

| ID | Source | Issue | Resolution | Rationale |
|----|--------|-------|------------|-----------|
| {{id}} | {{critic}} | {{issue}} | {{resolution}} | {{rationale}} |

---

## User Decisions

| ID | Question | User Choice | Applied To |
|----|----------|-------------|------------|
| {{id}} | {{question}} | {{choice}} | {{chapters}} |

---

## Deferred Items

| ID | Issue | Reason | Target Phase |
|----|-------|--------|--------------|
| {{id}} | {{issue}} | {{reason}} | {{phase}} |
```

---

## ambiguity-resolved.md

```markdown
# Ambiguity Resolution Record

## Overview

- Total Ambiguities: {{total}}
- Auto-Resolved: {{auto}}
- User-Resolved: {{user}}
- Remaining: {{remaining}}

---

## Resolution Log

### {{ambiguity_id}}: {{title}}

**Original Ambiguity:**
{{description}}

**Options Presented:**
1. {{option_1}}
2. {{option_2}}
3. {{option_3}}

**Resolution:** Option {{selected}}
**Rationale:** {{rationale}}
**Impact:** {{affected_chapters}}

---
```

---

## undefined-specs.md

```markdown
# Undefined Specifications

> Items intentionally deferred for later phases

## Deferred by Category

### Data Contracts

| ID | Spec Item | Reason | Define By Phase |
|----|-----------|--------|-----------------|
| {{id}} | {{item}} | {{reason}} | {{phase}} |

### API Details

| ID | Spec Item | Reason | Define By Phase |
|----|-----------|--------|-----------------|
| {{id}} | {{item}} | {{reason}} | {{phase}} |

### Edge Cases

| ID | Spec Item | Reason | Define By Phase |
|----|-----------|--------|-----------------|
| {{id}} | {{item}} | {{reason}} | {{phase}} |

---

## Risk Assessment

| Deferred Item | Risk Level | Mitigation |
|---------------|------------|------------|
| {{item}} | {{risk}} | {{mitigation}} |
```

---

## Validation Rules

1. **merged-decisions.md**
   - All CRITICAL issues must have resolutions
   - Resolution rationale is mandatory
   - No orphaned references

2. **ambiguity-resolved.md**
   - Each ambiguity has unique ID
   - Resolution timestamp recorded
   - Impact analysis complete

3. **undefined-specs.md**
   - Target phase specified
   - Risk assessment included
   - No blocking dependencies
