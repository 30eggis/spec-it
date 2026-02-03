---
name: spec-change
description: "Spec change router with validation for conflicts, clarity, coverage, and impact."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion, Glob, Grep
argument-hint: "<sessionId> <action> [--target <path>] [--skip-checks]"
permissionMode: bypassPermissions
---

# spec-change: Spec Modification Router

Validates and applies spec changes with comprehensive pre-flight checks.

## References

- [Output Formats](references/output-formats.md) - Analysis results, change plan, RTM formats
- [shared/references/common/output-rules.md](../../shared/references/common/output-rules.md) - Agent output rules
- [shared/references/common/context-rules.md](../../shared/references/common/context-rules.md) - Context management

---

## Workflow

```
[Request] → [Parallel Analysis] → [Plan Review] → [User Approval] → [Apply]
                   │
    ┌──────────────┼──────────────┐
    │              │              │
Doppelganger  Conflict   Clarity/Coverage
    │              │              │
    └──────────────┼──────────────┘
                   │
            Butterfly Effect
                   │
           [Change Plan] → [Approve?] → [Apply]
```

---

## Phase 0: Init

```
1. Context Validation
   Read: .claude/settings.local.json
   REQUIRE: context != "none" (minimum: fork)

2. Session Detection
   IF sessionId provided: use it
   ELSE: find most recent in tmp/

3. Parse Request
   EXTRACT: action (add/remove/modify), target, content
```

---

## Phase 1: Parallel Analysis

### Batch 1 (4 parallel)

| Agent | Model | Output |
|-------|-------|--------|
| spec-doppelganger | sonnet | `_analysis/doppelganger.json` |
| spec-conflict | sonnet | `_analysis/conflict.json` |
| spec-clarity | sonnet | `_analysis/clarity.json` |
| spec-consistency | haiku | `_analysis/consistency.json` |

### Batch 2 (2 parallel)

| Agent | Model | Output |
|-------|-------|--------|
| spec-coverage | sonnet | `_analysis/coverage.json` |
| spec-butterfly | opus | `_analysis/butterfly.json` |

### Aggregate

```
Read: _analysis/*.json
Create: _analysis/summary.md
```

---

## Phase 2: Plan Review

```
Task(change-planner, opus):
  Input: summary.md, butterfly.json
  Output: _analysis/change-plan.md

AskUserQuestion: "Apply these changes?"
  Options: ["Yes, apply all", "Modify plan", "Cancel"]
```

---

## Phase 3: Apply Changes

```
FOR each change in plan:
  Edit: {target_file}
  Checkpoint: meta-checkpoint.sh

Task(rtm-updater, haiku):
  Output: _traceability/rtm.json

Output: "✓ Changes applied. Run /spec-change --verify to validate."
```

---

## Output Structure

```
.spec-it/{sessionId}/plan/
├── _analysis/
│   ├── doppelganger.json, conflict.json, clarity.json
│   ├── consistency.json, coverage.json, butterfly.json
│   ├── summary.md
│   └── change-plan.md
└── _traceability/
    └── rtm.json
```

See [Output Formats](references/output-formats.md) for detailed structures.

---

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| spec-doppelganger | sonnet | Duplicate detection |
| spec-conflict | sonnet | Contradiction detection |
| spec-clarity | sonnet | Quality assessment |
| spec-consistency | haiku | Term consistency |
| spec-coverage | sonnet | Gap analysis |
| spec-butterfly | opus | Impact analysis |
| change-planner | opus | Generate change plan |
| rtm-updater | haiku | Update traceability |

---

## Arguments

| Arg | Required | Description |
|-----|----------|-------------|
| sessionId | No | Auto-detected if omitted |
| --target | No | Specific document path |
| --skip-checks | No | Skip validation (not recommended) |
| --verify | No | Verify previous changes |

---

## Examples

```bash
# Add requirement
/spec-change 20260130-123456 "Add 2FA to authentication"

# Modify with target
/spec-change 20260130-123456 --target 01-chapters/CH-02.md "Change to OAuth"

# Verify changes
/spec-change --verify 20260130-123456
```
