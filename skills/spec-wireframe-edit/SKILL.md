---
name: spec-wireframe-edit
description: "Modify wireframes with impact analysis. Analyzes affected components, screens, and specs before applying changes. Use for wireframe modification requests."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion, Glob, Grep
argument-hint: "<sessionId> <wireframe-name> [--change <description>]"
permissionMode: bypassPermissions
---

# spec-wireframe-edit: Wireframe Modification

Modify wireframes with comprehensive impact analysis.

## Workflow

```
[Request] → [Locate Wireframe] → [Butterfly Analysis] → [Preview] → [Approve] → [Apply]
```

---

## Phase 0: Init

### Step 0.1: Session Detection

```
IF args contains sessionId:
  SET sessionId = args.sessionId
  Read: tmp/{sessionId}/_meta.json
ELSE:
  # Find most recent session
  Bash: ls -t tmp/ | head -1
  SET sessionId = result

IF no session found:
  Output: "ERROR: No session found. Run /spec-it first."
  STOP
```

### Step 0.2: Locate Wireframe

```
IF args contains wireframe-name:
  SET wireframeName = args.wireframe-name

  # Search for matching wireframe
  Glob: tmp/{sessionId}/02-screens/wireframes/*{wireframeName}*.md

  IF multiple matches:
    AskUserQuestion: "Which wireframe?"
    Options: [list of matches]
  ELSE IF no matches:
    Output: "ERROR: Wireframe not found: {wireframeName}"
    Output: "Available wireframes:"
    Glob: tmp/{sessionId}/02-screens/wireframes/*.md
    STOP
ELSE:
  # List all wireframes for selection
  Glob: tmp/{sessionId}/02-screens/wireframes/*.md
  AskUserQuestion: "Which wireframe would you like to edit?"
  Options: [list of wireframes]

SET wireframePath = selected wireframe
```

### Step 0.3: Parse Change Request

```
IF args contains --change:
  SET changeDescription = args.change
ELSE:
  Read: {wireframePath}
  Output: [Display current wireframe]

  AskUserQuestion: "What changes would you like to make?"
  SET changeDescription = user response
```

---

## Phase 1: Analysis (bypassPermissions)

### Step 1.1: Current State Analysis

```
Read: {wireframePath}

EXTRACT:
  - Components used (from ASCII patterns)
  - Layout structure
  - Interactive elements
  - Data bindings
```

### Step 1.2: Impact Analysis

```
Task(spec-butterfly, opus):
  Input:
    - wireframePath
    - changeDescription
    - sessionId
  Output: tmp/{sessionId}/_analysis/wireframe-impact.json

  Impact analysis includes:
    - Components affected
    - Other screens referencing same components
    - Test specs that verify this wireframe
    - Consistency with design system

  wireframe-impact.json:
    {
      "directImpact": {
        "wireframe": "{wireframePath}",
        "changeType": "add|remove|modify|restructure",
        "affectedSections": [...]
      },
      "componentImpact": [
        {
          "component": "Button",
          "change": "variant change",
          "otherUsages": ["screen-a.md", "screen-b.md"]
        }
      ],
      "testImpact": [
        {
          "test": "05-tests/scenarios/login-test.md",
          "reason": "Tests button interaction"
        }
      ],
      "riskLevel": "low|medium|high"
    }
```

### Step 1.3: Check Stitch Mode

```
Read: tmp/{sessionId}/_meta.json

IF uiMode == "stitch":
  SET hasHtml = true
  CHECK: tmp/{sessionId}/02-screens/html/{wireframeName}.html exists
ELSE:
  SET hasHtml = false
```

---

## Phase 2: Plan & Preview

### Step 2.1: Generate Wireframe Preview

```
Task(wireframe-editor, sonnet):
  Input:
    - Current wireframe content
    - changeDescription
    - wireframe-impact.json
  Output:
    - tmp/{sessionId}/_analysis/wireframe-preview.md (before/after)
    - tmp/{sessionId}/_analysis/wireframe-plan.md

  wireframe-preview.md:
    ## Before
    ```
    [Current ASCII wireframe]
    ```

    ## After
    ```
    [Modified ASCII wireframe]
    ```

    ## Changes Made
    1. {change 1}
    2. {change 2}

  wireframe-plan.md:
    ## Change Plan

    ### Primary Change
    - File: {wireframePath}
    - Action: {description}

    ### Secondary Changes (if any)
    - File: {component-spec}
    - Reason: {why this needs update}

    ### Test Updates (if any)
    - File: {test-spec}
    - Reason: {why this needs review}
```

### Step 2.2: User Approval

```
Read: tmp/{sessionId}/_analysis/wireframe-preview.md
Output: [Display before/after comparison]

Read: tmp/{sessionId}/_analysis/wireframe-plan.md
Output: [Display change plan]

AskUserQuestion: "Apply these wireframe changes?"
Options: ["Yes, apply", "Modify", "Cancel"]

IF "Modify":
  AskUserQuestion: "What modifications?"
  GOTO Step 2.1 with modifications

IF "Cancel":
  Output: "Changes cancelled."
  STOP
```

---

## Phase 3: Apply Changes (noAskUser)

### Step 3.1: Update Wireframe

```
Read: tmp/{sessionId}/_analysis/wireframe-preview.md
EXTRACT: "After" section content

Write: {wireframePath}
  Content: modified wireframe

Bash: $SCRIPTS/core/meta-checkpoint.sh {sessionId} wireframe-edit
```

### Step 3.2: Update HTML (if Stitch mode)

```
IF hasHtml:
  Output: "Stitch mode detected. Regenerating HTML..."

  Task(stitch-regenerate, sonnet):
    Input:
      - Modified wireframe
      - Original HTML path
    Action:
      - Call Stitch MCP to regenerate screen
      - Update tmp/{sessionId}/02-screens/html/{wireframeName}.html
    Output: "HTML regenerated"
```

### Step 3.3: Flag Affected Documents

```
Read: tmp/{sessionId}/_analysis/wireframe-impact.json

FOR each affected in componentImpact:
  IF requires component spec update:
    Write: tmp/{sessionId}/03-components/{component}/_needs-review.md
      Content: |
        # Review Required

        Wireframe change in: {wireframePath}
        Change: {changeDescription}

        Please review and update component spec if needed.

FOR each affected in testImpact:
  Write: tmp/{sessionId}/05-tests/scenarios/{test}/_needs-review.md
    Content: |
      # Review Required

      Wireframe change in: {wireframePath}
      This test may need updates.
```

---

## Phase 4: Completion

### Step 4.1: Summary

```
Output: "✓ Wireframe updated successfully!"
Output: ""
Output: "Modified: {wireframePath}"

IF hasHtml:
  Output: "HTML updated: tmp/{sessionId}/02-screens/html/{wireframeName}.html"

IF flaggedFiles > 0:
  Output: ""
  Output: "⚠️  {N} files flagged for review:"
  FOR each flagged file:
    Output: "  - {path}"
  Output: ""
  Output: "Run /spec-change --verify {sessionId} to check consistency."
```

---

## Output Structure

```
tmp/{sessionId}/_analysis/
├── wireframe-impact.json    # Impact analysis results
├── wireframe-preview.md     # Before/after comparison
└── wireframe-plan.md        # Change execution plan

tmp/{sessionId}/02-screens/wireframes/
└── {wireframe}.md           # Updated wireframe

tmp/{sessionId}/02-screens/html/ (if Stitch mode)
└── {wireframe}.html         # Regenerated HTML

tmp/{sessionId}/{various}/
└── _needs-review.md         # Flagged files for review
```

---

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| spec-butterfly | opus | Impact analysis (shared with spec-change) |
| wireframe-editor | sonnet | Generate modified wireframe |
| stitch-regenerate | sonnet | Regenerate HTML via Stitch MCP |

---

## Arguments

| Arg | Required | Description |
|-----|----------|-------------|
| sessionId | Yes* | Session directory (*auto-detected) |
| wireframe-name | No | Name of wireframe to edit (prompted if omitted) |
| --change | No | Change description (prompted if omitted) |

---

## Examples

```bash
# Interactive mode (prompts for wireframe and changes)
/spec-wireframe-edit

# Specify wireframe
/spec-wireframe-edit 20260130-123456 dashboard

# Full specification
/spec-wireframe-edit 20260130-123456 login --change "Add forgot password link below login button"

# Complex change
/spec-wireframe-edit 20260130-123456 checkout --change "Restructure the payment section to show card form inline instead of in a modal"
```

---

## Integration with spec-change

For changes that go beyond wireframe modifications (e.g., adding new requirements), use spec-change instead:

```bash
# Wireframe-only change → spec-wireframe-edit
/spec-wireframe-edit dashboard --change "Move sidebar to right side"

# Requirement change → spec-change
/spec-change 20260130-123456 "Add a new dashboard widget for notifications"
```
