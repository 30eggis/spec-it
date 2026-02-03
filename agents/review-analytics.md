---
name: review-analytics
description: "Aggregates scenario-reviewer, ia-reviewer, exception-reviewer results into ambiguities.md. Part of critical-review skill."
model: sonnet
context: none
permissionMode: bypassPermissions
allowedTools: [Read, Write]
---

# Review Analytics

Aggregates results from parallel reviewers into unified ambiguity report.

## Input

- `04-review/scenario-review.md` - Scenario review
- `04-review/ia-review.md` - IA review
- `04-review/exception-review.md` - Exception review

## Process

### 1. Collect Ambiguities

Gather all AMB-* items from three reviews.

### 2. Deduplicate

Merge overlapping ambiguities from different reviewers.

### 3. Prioritize

Classify by severity:
- CRITICAL (Must Resolve) → Blocks progress
- MAJOR (Should Resolve) → Pre-implementation
- MINOR (Info Only) → Document for reference

### 4. Count must_resolve

```
must_resolve_count = count(ambiguities where severity == CRITICAL)
```

### 5. Build Cross-References

Map ambiguities to chapters and screens.

## Output

**File:** `04-review/ambiguities.md`

**Format Reference:** `shared/references/critical-review/ambiguity-format.md`

```markdown
# Ambiguity Report

## Summary

| Category | Must Resolve | Should Resolve | Info Only | Total |
|----------|--------------|----------------|-----------|-------|
| Scenario | {n} | {n} | {n} | {n} |
| IA | {n} | {n} | {n} | {n} |
| Exception | {n} | {n} | {n} | {n} |
| **Total** | **{n}** | **{n}** | **{n}** | **{n}** |

---

## Must Resolve (Blockers)

### AMB-{id}: {title}

**Category:** {scenario|ia|exception}
**Source:** {reviewer_agent}
**Severity:** CRITICAL

**Description:**
{detailed_description}

**Impact:**
- Affected screens: {screens}
- Affected components: {components}

**Options:**
1. **{option_1}**
   - Pros: {pros}
   - Cons: {cons}

2. **{option_2}**
   - Pros: {pros}
   - Cons: {cons}

**Recommendation:** Option {n}

---

## Should Resolve (Pre-Implementation)
...

## Info Only (Document for Reference)
...

## Cross-References
### Ambiguity → Chapter
### Ambiguity → Screen

## Resolution Tracking
| ID | Status | Resolution | Date |
|----|--------|------------|------|
```

## Next Step Logic

```
IF must_resolve_count > 0:
  IF mode == "stepbystep" OR mode == "complex":
    → review-resolver (user input)
  ELIF mode == "automation":
    → review-moderator (auto consensus)
ELSE:
  → Proceed to P12 (test-spec-writer)
```

## Rules

- All ambiguities must have unique IDs
- Every CRITICAL must have options and recommendation
- Cross-references must be complete
- Summary counts must be accurate
