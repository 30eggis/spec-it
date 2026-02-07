---
name: spec-it-stepbystep
description: "Step-by-step spec generator with phase approvals for small projects and learning."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--session <sessionId>] [--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-stepbystep: Step-by-Step Mode

Transform PRD/vibe-coding into frontend specifications with **phase-by-phase approval**.

**Approval Timing:** Every major phase
**P5 Resolution:** critique-resolver (user input)
**P11 Resolution:** review-resolver (user input)
**Auto-Execute:** No

## Rules

See [shared/references/common/output-rules.md](../../shared/references/common/output-rules.md) and [shared/references/common/context-rules.md](../../shared/references/common/context-rules.md).
See [shared/references/common/rules/50-question-policy.md](../../shared/references/common/rules/50-question-policy.md) (Question Policy: Confirm).
See [shared/references/common/rules/06-output-quality.md](../../shared/references/common/rules/06-output-quality.md) (Output Quality Standards - MANDATORY).

### Output Templates (MANDATORY)

All outputs MUST use templates from `shared/templates/common/`.

### File Writing Rules

**Main orchestrator - NO Bash file writes:**
- ❌ `cat > file <<` (heredoc)
- ❌ `echo ... > file`

**Use instead:**
- ✅ status-update.sh for status files
- ✅ Write tool for general files
- ✅ Task(subagent) for large files

## Workflow Overview (P1-P15)

```
P1: design-interviewer → requirements.md
      ↓ ★ Approval
P2: persona-architect → personas/
      ↓ ★ Approval
P3: divergent-thinker → alternatives/
      ↓ ★ Approval
P4: critic-logic + critic-feasibility + critic-frontend (parallel)
    → critic-analytics → critique-synthesis.md
      ↓
P5: critique-resolver (user input) → critique-solve/
      ↓ ★ Approval
P6: chapter-planner → chapter-plan-final.md
      ↓ ★ Approval (RE-EXECUTION POINT)
P7: ui-architect → wireframes/
      ↓ ★ Approval
P8: component-auditor → inventory.md
      ↓
P9: component-builder + component-migrator (parallel)
      ↓ ★ Approval
P10: context-synthesizer → spec-map.md
      ↓
P11: critical-review skill → review-decisions.md
      ↓ [IF re-execution needed → P6]
      ↓ ★ Approval
P12: test-spec-writer → test-scenarios/
      ↓ ★ Approval
P13: spec-assembler → final links
      ↓
P14: api-predictor + dev-planner → dev-plan/
      ↓
P15: docs-hub-curator → README-DOC/index.md
      ↓
★ Final Approval
```

---

## Phase 0: Init

### Step 0.PREREQ: Initialize Submodules

```bash
if [ ! -f "docs/refs/agent-skills/README.md" ]; then
  git submodule update --init --recursive docs/refs/agent-skills 2>/dev/null || echo "Warning: Could not init submodule"
fi
```

### Step 0.0: Setup Intake

```
DESIGN_TRENDS_PATH = $HOME/.claude/plugins/marketplaces/spec-it/skills/design-trends-2026

questions = []
IF designStyle missing: questions += design style question
IF dashboard missing: questions += dashboard question
IF questions not empty: AskUserQuestion(questions)

_meta.designStyle = selectedStyle
_meta.designTrendsPath = DESIGN_TRENDS_PATH
_meta.dashboardEnabled = dashboard
_meta.mode = "stepbystep"
```

### Step 0.1: Session Init

```
IF --session {sessionId} in args:
  # Reuse session created by router
  sessionDir = .spec-it/{sessionId}/plan
  Read: {sessionDir}/_meta.json
  # Update _meta.json with mode-specific values
  Update _meta.json:
    mode = "stepbystep"
    uiMode = "stepbystep"
    designStyle = from args or Step 0.0
    designTrendsPath = from args or Step 0.0
    dashboardEnabled = from args or Step 0.0
ELSE:
  # Direct invocation — create new session
  result = Bash: session-init.sh "" stepbystep "$(pwd)"
  sessionId = extract SESSION_ID
  sessionDir = extract SESSION_DIR

IF dashboard enabled:
  Output: "⏺ Dashboard: file://.../web-dashboard/index.html"
```

### Step 0.R: Resume

```
IF --resume in args:
  Read: .spec-it/{sessionId}/plan/_meta.json
  IF reexecuteFromP6: GOTO P6
  ELSE: GOTO _meta.currentStep
```

---

## Doc Index

| Doc | Description |
|-----|-------------|
| [docs/01-phases.md](docs/01-phases.md) | P1-P15 phase details + Final Approval |
| [docs/02-output-structure.md](docs/02-output-structure.md) | Output directory tree |

## Resume

`/spec-it-stepbystep --resume {sessionId}`
