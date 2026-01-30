---
name: spec-change
description: "Spec modification router with comprehensive validation. Detects duplicates, conflicts, quality issues, and impact before applying changes. Use for any spec add/remove/modify requests."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion, Glob, Grep
argument-hint: "<sessionId> <action> [--target <path>] [--skip-checks]"
permissionMode: bypassPermissions
---

# spec-change: Spec Modification Router

Validates and applies spec changes with comprehensive pre-flight checks.

## Rules

See [shared/output-rules.md](../shared/output-rules.md) and [shared/context-rules.md](../shared/context-rules.md).

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
              [Plan Output]
                   │
         AskUser: "Approve?"
                   │
           [Apply Changes]
```

---

## Phase 0: Init

### Step 0.1: Context Validation

```
Read: .claude/settings.local.json OR .claude/settings.json
EXTRACT: context setting

IF context == "none":
  Output: "ERROR: context:none detected. spec-change requires context:fork minimum."
  Output: "Run: claude config set context fork"
  STOP

IF context == "fork":
  Output: "✓ Context mode: fork"
  CONTINUE
```

### Step 0.2: Session Detection

```
IF args contains sessionId:
  SET sessionId = args.sessionId
  Read: tmp/{sessionId}/_meta.json
ELSE:
  # Find most recent session
  Bash: ls -t tmp/ | head -1
  SET sessionId = result

IF no session found:
  Output: "ERROR: No session found. Run /spec-it first to create a session."
  STOP
```

### Step 0.3: Parse Request

```
EXTRACT from user request:
  - action: "add" | "remove" | "modify"
  - target: document path or section
  - content: new requirement/change description

IF action unclear:
  AskUserQuestion: "What would you like to do?"
  Options: ["Add requirement", "Remove requirement", "Modify existing"]
```

---

## Phase 1: Parallel Analysis (bypassPermissions)

### Step 1.1: Launch All Analyzers

All analyzers run in parallel (max 4 concurrent per batch):

```
# Batch 1: Detection checks
Task(spec-doppelganger, sonnet, parallel):
  Input: {action, target, content, sessionId}
  Output: tmp/{sessionId}/_analysis/doppelganger.json

Task(spec-conflict, sonnet, parallel):
  Input: {action, target, content, sessionId}
  Output: tmp/{sessionId}/_analysis/conflict.json

Task(spec-clarity, sonnet, parallel):
  Input: {content}
  Output: tmp/{sessionId}/_analysis/clarity.json

Task(spec-consistency, haiku, parallel):
  Input: {content, sessionId}
  Output: tmp/{sessionId}/_analysis/consistency.json

WAIT for batch 1

# Batch 2: Analysis checks
Task(spec-coverage, sonnet, parallel):
  Input: {action, target, content, sessionId}
  Output: tmp/{sessionId}/_analysis/coverage.json

Task(spec-butterfly, opus, parallel):
  Input: {action, target, sessionId}
  Output: tmp/{sessionId}/_analysis/butterfly.json

WAIT for batch 2
```

### Step 1.2: Aggregate Results

```
Read: tmp/{sessionId}/_analysis/*.json

CREATE: tmp/{sessionId}/_analysis/summary.md

Contents:
  ## Analysis Summary

  | Check | Status | Issues |
  |-------|--------|--------|
  | Duplicates | {pass/warn/fail} | {count} |
  | Conflicts | {pass/warn/fail} | {count} |
  | Clarity | {score}/10 | {issues} |
  | Consistency | {pass/warn/fail} | {count} |
  | Coverage | {pass/warn/fail} | {gaps} |

  ## Affected Documents
  {list from butterfly.json}

  ## Recommended Actions
  {based on analysis}
```

---

## Phase 2: Plan Review

### Step 2.1: Generate Change Plan

```
Task(change-planner, opus):
  Input: summary.md, butterfly.json, original request
  Output: tmp/{sessionId}/_analysis/change-plan.md

  Contents:
    ## Change Request Summary
    - Action: {add/remove/modify}
    - Target: {path/section}
    - Description: {what changes}

    ## Validation Results
    | Check | Result | Details |
    |-------|--------|---------|
    | ... | ... | ... |

    ## Proposed Changes
    ### File 1: {path}
    ```diff
    - old line
    + new line
    ```

    ### File 2: {path}
    ...

    ## Impact Analysis
    - Direct: {N} files
    - Indirect: {N} files
    - Tests affected: {N}

    ## Risks
    - {risk 1}
    - {risk 2}
```

### Step 2.2: User Approval

```
Read: tmp/{sessionId}/_analysis/change-plan.md
Output: [Display change plan to user]

AskUserQuestion: "Review complete. Apply these changes?"
Options: ["Yes, apply all", "Modify plan", "Cancel"]

IF "Modify plan":
  AskUserQuestion: "What would you like to modify?"
  # Incorporate feedback
  GOTO Step 2.1 with modifications

IF "Cancel":
  Output: "Changes cancelled. Analysis saved in tmp/{sessionId}/_analysis/"
  STOP
```

---

## Phase 3: Apply Changes (noAskUser, noPermissionCheck)

### Step 3.1: Execute Changes

```
# After user approval, execute without further prompts
Read: tmp/{sessionId}/_analysis/change-plan.md

FOR each change in plan:
  Edit: {target_file}
    old_string: {original}
    new_string: {modified}

  # Checkpoint after each file
  Bash: $SCRIPTS/core/meta-checkpoint.sh {sessionId} spec-change
```

### Step 3.2: Update Traceability

```
# Update RTM (Requirements Traceability Matrix)
Task(rtm-updater, haiku):
  Input: change-plan.md, sessionId
  Output: tmp/{sessionId}/_traceability/rtm.json

  Updates:
    - requirement → design links
    - design → test links
    - change history
```

### Step 3.3: Completion

```
Output: "✓ Changes applied successfully."
Output: "Modified files: {list}"
Output: "Traceability updated: tmp/{sessionId}/_traceability/rtm.json"
Output: ""
Output: "Run /spec-change --verify {sessionId} to validate changes."
```

---

## Output Structure

```
tmp/{sessionId}/_analysis/
├── doppelganger.json    # Duplicate detection results
├── conflict.json        # Conflict detection results
├── clarity.json         # Quality assessment
├── consistency.json     # Term/pattern consistency
├── coverage.json        # Gap analysis
├── butterfly.json       # Impact analysis
├── summary.md           # Aggregated summary
└── change-plan.md       # Final change plan

tmp/{sessionId}/_traceability/
└── rtm.json             # Requirements Traceability Matrix
```

---

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| spec-doppelganger | sonnet | Duplicate detection via semantic similarity |
| spec-conflict | sonnet | Contradiction detection between requirements |
| spec-clarity | sonnet | Quality/completeness assessment |
| spec-consistency | haiku | Term and pattern consistency check |
| spec-coverage | sonnet | Gap analysis for missing scenarios |
| spec-butterfly | opus | Impact analysis (forward + backward trace) |
| change-planner | opus | Generate comprehensive change plan |
| rtm-updater | haiku | Update traceability matrix |

---

## Arguments

| Arg | Required | Description |
|-----|----------|-------------|
| sessionId | Yes* | Session directory (*auto-detected if omitted) |
| action | No | add/remove/modify (auto-detected from request) |
| --target | No | Specific document path to modify |
| --skip-checks | No | Skip validation checks (not recommended) |
| --verify | No | Verify previous changes applied correctly |

---

## Examples

```bash
# Add a new requirement
/spec-change 20260130-123456 "문서의 인증 부분에 2FA 기능을 추가해줘"

# Remove a feature
/spec-change 20260130-123456 "알림 기능을 제거해줘"

# Modify existing
/spec-change 20260130-123456 --target 01-chapters/decisions/CH-03.md "로그인 방식을 OAuth로 변경해줘"

# Skip checks (use with caution)
/spec-change 20260130-123456 --skip-checks "간단한 오타 수정"

# Verify changes
/spec-change --verify 20260130-123456
```
