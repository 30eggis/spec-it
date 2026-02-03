# Ambiguity Detection Format

> Referenced by: critical-review skill (scenario-reviewer, ia-reviewer, exception-reviewer, review-analytics)

## Purpose

Standard format for documenting ambiguities discovered during critical review phase (P11).

---

## Output: ambiguities.md

```markdown
# Ambiguity Report

## Summary

| Category | Must Resolve | Should Resolve | Info Only | Total |
|----------|--------------|----------------|-----------|-------|
| Scenario | {{count}} | {{count}} | {{count}} | {{total}} |
| IA | {{count}} | {{count}} | {{count}} | {{total}} |
| Exception | {{count}} | {{count}} | {{count}} | {{total}} |
| **Total** | **{{sum}}** | **{{sum}}** | **{{sum}}** | **{{grand}}** |

---

## Must Resolve (Blockers)

These ambiguities block progress and require user decision.

### AMB-{{id}}: {{title}}

**Category:** {{scenario|ia|exception}}
**Source:** {{reviewer_agent}}
**Severity:** CRITICAL

**Description:**
{{detailed_description}}

**Impact:**
- Affected screens: {{screens}}
- Affected components: {{components}}
- Blocked tasks: {{tasks}}

**Options:**
1. **{{option_1}}**
   - Pros: {{pros}}
   - Cons: {{cons}}
   - Impact: {{impact}}

2. **{{option_2}}**
   - Pros: {{pros}}
   - Cons: {{cons}}
   - Impact: {{impact}}

3. **{{option_3}}**
   - Pros: {{pros}}
   - Cons: {{cons}}
   - Impact: {{impact}}

**Recommendation:** Option {{n}} because {{rationale}}

**If unresolved:** {{consequence}}

---

## Should Resolve (Pre-Implementation)

These should be resolved before development but don't block spec completion.

### AMB-{{id}}: {{title}}

**Category:** {{category}}
**Severity:** MAJOR

**Description:**
{{description}}

**Default Behavior:** {{default}}
**Alternative:** {{alternative}}

**Recommended Resolution:** {{resolution}}

---

## Info Only (Document for Reference)

Minor ambiguities documented for awareness.

### AMB-{{id}}: {{title}}

**Category:** {{category}}
**Severity:** MINOR

**Note:** {{note}}
**Assumed Behavior:** {{assumption}}

---

## Cross-References

### Ambiguity → Chapter

| Ambiguity | Affects Chapters |
|-----------|------------------|
| AMB-001 | CH-02, CH-05 |

### Ambiguity → Screen

| Ambiguity | Affects Screens |
|-----------|-----------------|
| AMB-001 | {{screen_ids}} |

---

## Resolution Tracking

| ID | Status | Resolved By | Resolution | Date |
|----|--------|-------------|------------|------|
| AMB-001 | pending | - | - | - |
```

---

## Category Definitions

### Scenario Ambiguities

Issues with user flows and scenarios:

- **Missing steps**: Flow has gaps
- **Unclear trigger**: What initiates the scenario?
- **Multiple paths**: Which path is default?
- **Edge case undefined**: Boundary behavior unclear

### IA (Information Architecture) Ambiguities

Issues with structure and navigation:

- **Unclear hierarchy**: Where does item belong?
- **Duplicate paths**: Multiple ways to same content
- **Missing connection**: Orphaned content
- **Role confusion**: Which persona sees what?

### Exception Ambiguities

Issues with error handling:

- **Error state undefined**: What happens on failure?
- **Recovery unclear**: How to recover?
- **Boundary undefined**: What are the limits?
- **Conflict resolution**: Who wins in conflicts?

---

## Severity Definitions

| Severity | Definition | Action |
|----------|------------|--------|
| CRITICAL | Blocks understanding of core functionality | Must resolve before P6 |
| MAJOR | Affects implementation decisions | Should resolve pre-dev |
| MINOR | Nice to clarify | Document assumption |

---

## Validation Rules

1. Every CRITICAL ambiguity must have:
   - At least 2 options
   - Impact analysis
   - Recommendation

2. All ambiguities must be categorized

3. Cross-references must be complete

4. No duplicate ambiguities across categories
