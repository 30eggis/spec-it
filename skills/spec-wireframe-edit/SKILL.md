---
name: spec-wireframe-edit
description: "Modify wireframes with impact analysis. Analyzes affected components, screens, and specs before applying changes. Use for wireframe modification requests."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion, Glob, Grep
argument-hint: "<sessionId> <wireframe-name> [--change <description>]"
permissionMode: bypassPermissions
---

# spec-wireframe-edit: Wireframe Modification

Modify wireframes with comprehensive impact analysis.

## References

- [Output Formats](references/output-formats.md) - Impact JSON, preview, plan formats
- [YAML UI Frame](../shared/references/yaml-ui-frame/) - YAML wireframe structure

---

## Workflow

```
[Request] → [Locate] → [Analyze Impact] → [Preview] → [Approve] → [Apply]
```

---

## Phase 0: Init

```
1. Session Detection
   IF sessionId provided: use it
   ELSE: find most recent in tmp/

2. Locate Wireframe
   Glob: tmp/{sessionId}/02-screens/wireframes/*{name}*.yaml
   IF multiple: AskUserQuestion to select
   IF none: show available wireframes

3. Parse Change
   IF --change provided: use it
   ELSE: display wireframe, ask for changes
```

---

## Phase 1: Analysis

```
Task(spec-butterfly, opus):
  Output: _analysis/wireframe-impact.json

  Analyzes:
    - Components affected
    - Other screens using same components
    - Test specs to update
    - Risk level

```

---

## Phase 2: Preview & Approval

```
Task(wireframe-editor, sonnet):
  Output:
    - _analysis/wireframe-preview.md (before/after)
    - _analysis/wireframe-plan.md

AskUserQuestion: "Apply changes?"
  Options: ["Yes, apply", "Modify", "Cancel"]
```

---

## Phase 3: Apply

```
1. Update Wireframe
   Write: {wireframePath} with modified YAML content
   Checkpoint: meta-checkpoint.sh

2. Flag Affected Files
   FOR each component/test impact:
     Write: {path}/_needs-review.md
```

---

## Phase 4: Completion

```
Output: "✓ Wireframe updated: {path}"

IF flaggedFiles > 0:
  Output: "⚠️ {N} files flagged for review"
  Output: "Run /spec-change --verify to check consistency"
```

---

## Output Structure

```
tmp/{sessionId}/
├── _analysis/
│   ├── wireframe-impact.json
│   ├── wireframe-preview.md
│   └── wireframe-plan.md
├── 02-screens/wireframes/
│   └── {wireframe}.yaml        # Updated YAML wireframe
└── {various}/
    └── _needs-review.md        # Flagged files
```

See [Output Formats](references/output-formats.md) for detailed structures.

---

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| spec-butterfly | opus | Impact analysis |
| wireframe-editor | sonnet | Generate modified YAML wireframe |

---

## Arguments

| Arg | Required | Description |
|-----|----------|-------------|
| sessionId | No | Auto-detected if omitted |
| wireframe-name | No | Prompted if omitted |
| --change | No | Change description (prompted if omitted) |

---

## Examples

```bash
# Interactive
/spec-wireframe-edit

# Specify wireframe
/spec-wireframe-edit 20260130-123456 dashboard

# Full specification
/spec-wireframe-edit 20260130-123456 login --change "Add forgot password link"
```

---

## When to Use

| Change Type | Use |
|-------------|-----|
| Wireframe layout/elements | `/spec-wireframe-edit` |
| New requirements | `/spec-change` |
| Component logic | `/spec-change` |
