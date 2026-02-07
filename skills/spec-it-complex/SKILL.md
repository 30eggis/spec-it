---
name: spec-it-complex
description: "Hybrid spec generator with 4 milestone approvals for medium projects."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--session <sessionId>] [--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-complex: Hybrid Mode

Transform PRD/vibe-coding into frontend specifications with **auto-validation** and **4 milestone approvals**.

**Approval Timing:** 4 milestones
**P5 Resolution:** critique-resolver (user input)
**P11 Resolution:** review-resolver (user input)
**Auto-Execute:** No

## Rules

See [shared/references/common/output-rules.md](../../shared/references/common/output-rules.md) and [shared/references/common/context-rules.md](../../shared/references/common/context-rules.md).
See [shared/references/common/rules/50-question-policy.md](../../shared/references/common/rules/50-question-policy.md) (Question Policy: Hybrid).
See [shared/references/common/rules/06-output-quality.md](../../shared/references/common/rules/06-output-quality.md) (Output Quality Standards - MANDATORY).

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
[P1-P6: Auto] Requirements → Personas → Divergent → Critics → Resolution → Chapter Plan
      ↓
★ MILESTONE 1: "Chapter plan approved?"
      ↓
[P7-P9: Auto] UI Architecture → Components
      ↓
★ MILESTONE 2: "UI & Components approved?"
      ↓
[P10-P11: Auto] Context Synthesis → Critical Review
      ↓ [IF re-execution needed → P6]
★ MILESTONE 3: "Review complete?"
      ↓
[P12-P15: Auto] Tests → Assembly → Dev Plan → Docs Hub
      ↓
★ MILESTONE 4: Final approval
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
_meta.mode = "complex"
```

### Step 0.1: Session Init

```
IF --session {sessionId} in args:
  # Reuse session created by router
  sessionDir = .spec-it/{sessionId}/plan
  Read: {sessionDir}/_meta.json
  # Update _meta.json with mode-specific values
  Update _meta.json:
    mode = "complex"
    uiMode = "complex"
    designStyle = from args or Step 0.0
    designTrendsPath = from args or Step 0.0
    dashboardEnabled = from args or Step 0.0
ELSE:
  # Direct invocation — create new session
  result = Bash: session-init.sh "" complex "$(pwd)"
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
| [docs/01-phases.md](docs/01-phases.md) | P1-P15 phase details + Milestone approvals |
| [docs/02-output-structure.md](docs/02-output-structure.md) | Output directory tree + Agents summary |

## Resume

`/spec-it-complex --resume {sessionId}`
