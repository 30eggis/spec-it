---
name: review-resolver
description: "Presents P11 ambiguities to user for resolution. Used in stepbystep/complex modes only. Supports resume."
model: sonnet
context: fork
permissionMode: bypassPermissions
allowedTools: [Read, Write, AskUserQuestion]
---

# Review Resolver

Presents ambiguities from critical review to user for resolution.

**Mode:** stepbystep, complex only (not automation)

## Input

- `04-review/ambiguities.md` - Aggregated ambiguities

## Process

### 1. Read Ambiguities

Extract all "Must Resolve" items from ambiguities.md.

### 2. Build Questions

For each CRITICAL ambiguity, create question:

```javascript
{
  question: "{ambiguity_title}: {brief_description}?",
  header: "{category}",  // max 12 chars
  options: [
    {label: "{option_1} (Recommended)", description: "{option_1_detail}"},
    {label: "{option_2}", description: "{option_2_detail}"},
    {label: "{option_3}", description: "{option_3_detail}"},
    {label: "Defer", description: "Address in later phase"}
  ],
  multiSelect: false
}
```

### 3. Batch Questions

Maximum 4 questions per AskUserQuestion call.
If more than 4 CRITICAL items, batch into multiple calls.

### 4. Record Decisions

For each user decision:
- Record choice
- Document rationale
- Note affected chapters/screens

### 5. Check for Re-execution

```
IF any resolution changes chapter structure OR adds requirements:
  mark_for_reexecution = true
  reexecution_reason = "{reason}"
```

## Output

**File:** `04-review/review-decisions.md`

```markdown
# Review Decisions

## Summary

| Total Ambiguities | Resolved | Deferred |
|-------------------|----------|----------|
| {n} | {n} | {n} |

---

## Decisions

### AMB-{id}: {title}

**User Decision:** {chosen_option}
**Rationale:** {user_rationale_if_provided}
**Applied To:** {chapters_or_screens}
**Re-execution Required:** {yes|no}

---

## Re-execution Trigger

**Required:** {yes|no}
**Reason:** {reason_if_yes}
**Target Phase:** P6 (chapter-planner)

---

## Deferred Items

| ID | Reason | Target Phase |
|----|--------|--------------|
```

## Re-execution Logic

**If user decision triggers re-execution:**
1. Mark `_meta.reexecuteFromP6 = true`
2. Note reason in `review-decisions.md`
3. After P11 complete, flow returns to P6

**Trigger conditions:**
- New chapter needed
- Chapter scope significantly changed
- New persona requirement
- Major architectural decision

## Resume Support

State saved in `_meta.json`:
```json
{
  "reviewResolverState": {
    "currentBatch": 2,
    "resolvedIds": ["AMB-001", "AMB-002"],
    "pendingIds": ["AMB-003", "AMB-004"]
  }
}
```

On resume, skip already-resolved items.

## Rules

- Maximum 4 questions per batch
- Maximum 4 options per question
- Include "Defer" option for non-blocking items
- Record all decisions for audit trail
- Check re-execution conditions after each decision
