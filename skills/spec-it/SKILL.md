---
name: spec-it
description: "Frontend specification generator. Transforms PRD/requirements into comprehensive frontend specs with wireframes, component specs, and test plans."
allowed-tools: AskUserQuestion, Skill
argument-hint: "[mode] [--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it: Mode Router

Intelligent router that guides users to the appropriate spec-it mode based on their needs.

## Trigger Keywords

This skill activates on semantic matches for:
- "frontend spec", "UI spec", "design spec"
- "PRD to spec", "requirements to design"
- "wireframe", "component spec", "test spec"
- "spec-it" (explicit)

---

## Workflow

### Step 1: Check for Direct Mode Specification

```
IF args contains "stepbystep" OR "step-by-step" OR "manual":
  Skill(spec-it-stepbystep, args)
  STOP

IF args contains "complex" OR "hybrid" OR "milestone":
  Skill(spec-it-complex, args)
  STOP

IF args contains "auto" OR "automation" OR "full-auto":
  Skill(spec-it-automation, args)
  STOP

IF args contains "--resume":
  # Resume needs to know which mode - check session _meta.json
  Read: tmp/{sessionId}/_meta.json
  route to appropriate skill based on mode stored in meta
  STOP
```

### Step 2: Ask User for Mode Selection

```
AskUserQuestion: "Which spec-it mode would you like to use?"

Options:
  1. "Step-by-Step (Recommended for learning)"
     - Chapter-by-chapter approval
     - Maximum control
     - Best for: Small projects, first-time users

  2. "Complex/Hybrid"
     - 4 milestone approvals
     - Auto-validation between milestones
     - Best for: Medium projects

  3. "Full Automation"
     - Minimal approval (only final review)
     - Maximum speed
     - Best for: Large projects, experienced users
```

### Step 3: Route to Selected Mode

```
CASE selection:
  "Step-by-Step" → Skill(spec-it-stepbystep)
  "Complex/Hybrid" → Skill(spec-it-complex)
  "Full Automation" → Skill(spec-it-automation)
```

---

## Mode Comparison

| Feature | Step-by-Step | Complex | Automation |
|---------|--------------|---------|------------|
| Approvals | Every chapter | 4 milestones | Final only |
| Control | Maximum | Balanced | Minimal |
| Speed | Slowest | Medium | Fastest |
| Learning | Best | Good | Limited |
| Project Size | Small | Medium | Large |

---

## Direct Invocation

For experienced users who know which mode they want:

```bash
# Step-by-Step mode
/spec-it-stepbystep

# Complex/Hybrid mode
/spec-it-complex

# Full Automation mode
/spec-it-automation

# Resume any mode
/spec-it-stepbystep --resume 20260130-123456
/spec-it-complex --resume 20260130-123456
/spec-it-automation --resume 20260130-123456
```

---

## Output

All modes produce the same output structure:

```
tmp/{sessionId}/
├── _meta.json, _status.json
├── 00-requirements/
├── 01-chapters/
├── 02-screens/
│   ├── wireframes/
│   └── [html/, assets/]  # If Stitch mode
├── 03-components/
├── 04-review/
├── 05-tests/
└── 06-final/
    ├── final-spec.md
    ├── dev-tasks.md
    └── SPEC-SUMMARY.md
```
