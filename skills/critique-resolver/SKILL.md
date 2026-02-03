---
name: critique-resolver
description: "User resolution interface for P5 critique issues. Step-by-step and complex modes only."
allowed-tools: Read, Write, AskUserQuestion
argument-hint: "[--resume]"
permissionMode: bypassPermissions
---

# Critique Resolver

Presents critique synthesis to user for resolution decisions.

**Availability:** stepbystep, complex modes only (not automation)

## Purpose

After critic-analytics produces `critique-synthesis.md`, this skill:
1. Extracts "Must Resolve" issues
2. Presents them to user via tabbed questions
3. Records decisions
4. Triggers P6 re-execution if needed

## Rules

See [shared/references/critique-resolver/question-templates.md](../../shared/references/critique-resolver/question-templates.md).
See [shared/references/common/critique-solve-format.md](../../shared/references/common/critique-solve-format.md).

## Input

- `01-chapters/critique-synthesis.md` - Aggregated critique with metrics

## Workflow

```
[Read critique-synthesis.md]
      ↓
[Extract Must Resolve items]
      ↓
[Build question batches (max 4 per batch)]
      ↓
[Present to user via AskUserQuestion]
      ↓
[Record decisions]
      ↓
[Check re-execution conditions]
      ↓
[Output critique-solve/*.md]
```

---

## Step 1: Read Synthesis

```
Read: 01-chapters/critique-synthesis.md

Extract:
- must_resolve_count = count of Priority Matrix > Must Resolve items
- must_resolve_items = list of {id, source, issue, options, recommendation}
```

## Step 2: Build Questions

For each must_resolve_item:

```javascript
{
  question: "{issue_title}?",
  header: "{source}",  // Logic, Feasibility, Frontend (max 12 chars)
  options: [
    {label: "{recommendation} (Recommended)", description: "{rationale}"},
    {label: "{option_2}", description: "{description}"},
    {label: "{option_3}", description: "{description}"},
    {label: "Defer to later", description: "Address post-implementation"}
  ],
  multiSelect: false
}
```

## Step 3: Present Questions

```
WHILE pending_questions not empty:
  batch = pending_questions.take(4)  # Max 4 per AskUserQuestion

  responses = AskUserQuestion(questions: batch)

  FOR each response:
    Record decision in decisions[]
    Remove from pending_questions

  # Checkpoint for resume
  Update _meta.critiqueResolverState = {
    resolved: decisions,
    pending: pending_questions
  }
```

## Step 4: Check Re-execution

```
reexecution_needed = false
reexecution_reasons = []

FOR each decision:
  IF decision changes chapter scope:
    reexecution_needed = true
    reexecution_reasons.push("Chapter scope changed: {detail}")

  IF decision adds new requirement:
    reexecution_needed = true
    reexecution_reasons.push("New requirement: {detail}")

  IF decision changes persona definition:
    reexecution_needed = true
    reexecution_reasons.push("Persona changed: {detail}")
```

## Step 5: Output

### critique-solve/merged-decisions.md

```markdown
# Critique Resolution Decisions

## Summary

| Category | Total | Resolved | Deferred |
|----------|-------|----------|----------|
| Logic | {n} | {n} | {n} |
| Feasibility | {n} | {n} | {n} |
| Frontend | {n} | {n} | {n} |

---

## Resolved Issues

### {severity}

| ID | Source | Issue | Resolution | Rationale |
|----|--------|-------|------------|-----------|
| {id} | {critic} | {issue} | {user_choice} | {rationale} |

---

## User Decisions Log

| ID | Question | User Choice | Applied To |
|----|----------|-------------|------------|
| {id} | {question} | {choice} | {chapters} |
```

### critique-solve/ambiguity-resolved.md

```markdown
# Ambiguity Resolution Record

## Overview

- Total Ambiguities: {total}
- Resolved: {resolved}
- Deferred: {deferred}

---

## Resolution Log

### {id}: {title}

**Original Issue:** {description}
**User Decision:** {choice}
**Impact:** {affected_items}
```

### critique-solve/undefined-specs.md

```markdown
# Undefined Specifications

## Deferred Items

| ID | Spec Item | Reason | Define By Phase |
|----|-----------|--------|-----------------|
| {id} | {item} | User deferred | P{n} |
```

---

## Re-execution Trigger

```
IF reexecution_needed:
  Write to _meta.json:
    reexecuteFromP6: true
    reexecutionReasons: [reasons]

  Output: "⚠️ Re-execution required. Returning to P6 (chapter-planner)."
ELSE:
  Output: "✓ All critiques resolved. Proceeding to P6."
```

---

## Resume Support

```
IF --resume:
  Read: _meta.json

  IF critiqueResolverState exists:
    Load resolved decisions
    Continue from pending questions
```

---

## Output Files

| File | Content |
|------|---------|
| `critique-solve/merged-decisions.md` | All resolution decisions |
| `critique-solve/ambiguity-resolved.md` | Ambiguity resolution log |
| `critique-solve/undefined-specs.md` | Deferred specifications |
