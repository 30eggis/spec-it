---
name: critical-review
description: "P11 review orchestration skill. Runs parallel reviewers and handles resolution based on mode."
allowed-tools: Read, Write, Bash, Task, AskUserQuestion
argument-hint: "[--mode <stepbystep|complex|automation>]"
permissionMode: bypassPermissions
---

# Critical Review

Orchestrates P11 critical review phase with parallel reviewers and mode-specific resolution.

## Purpose

Comprehensive review of:
- **Scenarios** - Flow completeness and consistency
- **Information Architecture** - Navigation and structure
- **Exception Handling** - Error states and recovery

## Rules

See [shared/references/critical-review/review-criteria.md](../../shared/references/critical-review/review-criteria.md).
See [shared/references/critical-review/ambiguity-format.md](../../shared/references/critical-review/ambiguity-format.md).

## Input

- `spec-map.md` - Artifact index
- `02-wireframes/**/*.yaml` - Wireframes
- `03-components/**/*.yaml` - Component specs
- `05-tests/test-scenarios/**/*.md` - Test scenarios
- Mode: stepbystep | complex | automation

## Workflow

```
[P11 Start]
      ↓
[Parallel Review]
  ├── scenario-reviewer (opus)
  ├── ia-reviewer (opus)
  └── exception-reviewer (opus)
      ↓
[WAIT for all 3]
      ↓
[review-analytics (sonnet)]
  → ambiguities.md
      ↓
[Check must_resolve count]
      ↓
[Branch by mode]
  ├── step/comp + must_resolve > 0 → review-resolver (user input)
  ├── auto + must_resolve > 0 → review-moderator (auto consensus)
  └── must_resolve = 0 → Proceed to P12
      ↓
[Check re-execution]
      ↓
[IF re-execution needed → Return to P6]
[ELSE → Proceed to P12]
```

---

## Phase 11.1: Parallel Review

```
Bash: status-update.sh {sessionDir} agent-start "scenario-reviewer,ia-reviewer,exception-reviewer"

Task(scenario-reviewer, opus, parallel):
  Input: spec-map.md, wireframes, test-scenarios
  Output: 04-review/scenario-review.md

Task(ia-reviewer, opus, parallel):
  Input: domain-map.md, screen-lists, wireframes
  Output: 04-review/ia-review.md

Task(exception-reviewer, opus, parallel):
  Input: wireframes, component specs, sad-cases
  Output: 04-review/exception-review.md

WAIT for all 3

Bash: status-update.sh {sessionDir} agent-complete "scenario-reviewer,ia-reviewer,exception-reviewer" "" 11.1
```

---

## Phase 11.2: Analytics Aggregation

```
Bash: status-update.sh {sessionDir} agent-start review-analytics

Task(review-analytics, sonnet):
  Input:
    - 04-review/scenario-review.md
    - 04-review/ia-review.md
    - 04-review/exception-review.md
  Output: 04-review/ambiguities.md

Bash: status-update.sh {sessionDir} agent-complete review-analytics "" 11.2
```

---

## Phase 11.3: Resolution Branch

```
Read: 04-review/ambiguities.md
Extract: must_resolve_count from Summary table

IF must_resolve_count > 0:
  IF mode == "stepbystep" OR mode == "complex":
    # User resolution
    Bash: status-update.sh {sessionDir} agent-start review-resolver

    Task(review-resolver, sonnet):
      Input: 04-review/ambiguities.md
      Output: 04-review/review-decisions.md

    Bash: status-update.sh {sessionDir} agent-complete review-resolver "" 11.3

  ELIF mode == "automation":
    # Auto consensus
    Bash: status-update.sh {sessionDir} agent-start review-moderator

    Task(review-moderator, opus):
      Input:
        - 04-review/ambiguities.md
        - 04-review/scenario-review.md
        - 04-review/ia-review.md
        - 04-review/exception-review.md
      Output: 04-review/review-decisions.md

    Bash: status-update.sh {sessionDir} agent-complete review-moderator "" 11.3

ELSE:
  # No resolution needed
  Write: 04-review/review-decisions.md
    content: "# Review Decisions\n\n## Summary\n\nNo ambiguities requiring resolution."
```

---

## Phase 11.4: Re-execution Check

```
Read: 04-review/review-decisions.md
Check: Re-execution Trigger section

IF reexecution_required == true:
  Output: "⚠️ Critical review identified structural changes."
  Output: "Returning to P6 (chapter-planner) for re-planning."

  Update: _meta.json
    currentStep: "6.1"
    reexecutionSource: "P11"
    reexecutionReasons: {reasons}

  # Return to P6
  GOTO: chapter-planner phase

ELSE:
  Output: "✓ Critical review complete. Proceeding to P12."
  Bash: status-update.sh {sessionDir} phase-complete 11 12 "12.1"
```

---

## Output Structure

```
04-review/
├── scenario-review.md       # From scenario-reviewer
├── ia-review.md            # From ia-reviewer
├── exception-review.md     # From exception-reviewer
├── ambiguities.md          # From review-analytics
└── review-decisions.md     # From review-resolver or review-moderator
```

---

## Mode Differences

| Aspect | stepbystep | complex | automation |
|--------|------------|---------|------------|
| Resolution | review-resolver | review-resolver | review-moderator |
| User Input | Required | Required | None (auto) |
| Hard Stops | Ask user | Ask user | Flag only |

---

## Re-execution Conditions

Conditions that trigger return to P6:

1. **Chapter scope change** - Significant scope modification
2. **New requirement** - Previously unidentified requirement
3. **Persona change** - Persona definition modified
4. **Architecture change** - Navigation structure overhauled

---

## Integration Points

### Input From
- P10 (context-synthesizer): spec-map.md
- P7 (ui-architect): wireframes
- P9 (component-builder): component specs
- P12-prep (test-spec-writer): initial scenarios

### Output To
- P12 (test-spec-writer): Validated foundation
- P6 (chapter-planner): If re-execution needed

---

## Resume Support

State saved at each sub-phase:
- 11.1: Parallel reviews complete
- 11.2: Analytics complete
- 11.3: Resolution complete
- 11.4: Re-execution check complete
