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

IF args contains "fast" OR "quick" OR "rapid":
  Skill(spec-it-fast-launch, args)
  STOP

IF args contains "--resume":
  # Resume needs to know which mode - check session _meta.json
  # New structure: .spec-it/{sessionId}/(plan|execute)/_meta.json
  Read: .spec-it/{sessionId}/plan/_meta.json OR .spec-it/{sessionId}/execute/_meta.json
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

  3. "Full Automation → Execute"
     - Minimal approval (only final review)
     - Auto-proceeds to implementation (spec-it-execute)
     - Best for: Large projects, experienced users

  4. "Fast → Execute (Recommended for prototyping)"
     - Skip brainstorming, components, tests
     - Quick wireframes with design trends
     - Auto-proceeds to implementation
     - Best for: Rapid prototyping, design validation
```

### Step 3: Route to Selected Mode

```
CASE selection:
  "Step-by-Step" → Skill(spec-it-stepbystep)
  "Complex/Hybrid" → Skill(spec-it-complex)
  "Full Automation → Execute" → Skill(spec-it-automation)  # Auto-executes after spec
  "Fast → Execute" → Skill(spec-it-fast-launch)           # Auto-executes after spec
```

---

## Mode Comparison

| Feature | Step-by-Step | Complex | Automation | Fast |
|---------|--------------|---------|------------|------|
| Approvals | Every chapter | 4 milestones | Final only | Final only |
| Control | Maximum | Balanced | Minimal | Minimal |
| Speed | Slowest | Medium | Fast | **Fastest** |
| Learning | Best | Good | Limited | None |
| Project Size | Small | Medium | Large | Prototype |
| Auto-Execute | No | No | **Yes** | **Yes** |
| Components | Full | Full | Full | Skipped |
| Tests | Full | Full | Full | Skipped |

---

## Direct Invocation

For experienced users who know which mode they want:

```bash
# Step-by-Step mode
/spec-it-stepbystep

# Complex/Hybrid mode
/spec-it-complex

# Full Automation mode (auto-executes)
/spec-it-automation

# Fast mode (auto-executes)
/spec-it-fast-launch

# Resume any mode
/spec-it-stepbystep --resume 20260130-123456
/spec-it-complex --resume 20260130-123456
/spec-it-automation --resume 20260130-123456
/spec-it-fast-launch --resume 20260130-123456
```

---

## Output

All modes produce the same output structure:

```
.spec-it/{sessionId}/plan/
├── _meta.json, _status.json

tmp/
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
