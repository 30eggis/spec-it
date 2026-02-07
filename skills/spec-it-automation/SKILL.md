---
name: spec-it-automation
description: "Full-auto spec generator with minimal approvals for large projects."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--session <sessionId>] [--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-automation: Full Auto Mode

Transform PRD/vibe-coding into frontend specifications with **maximum automation** and **minimal user intervention**.

**Approval Timing:** Final only
**P5 Resolution:** critic-moderator (auto consensus)
**P11 Resolution:** review-moderator (auto consensus)
**Auto-Execute:** Yes (proceeds to spec-it-execute)

## Rules

See [shared/references/common/output-rules.md](../../shared/references/common/output-rules.md) and [shared/references/common/context-rules.md](../../shared/references/common/context-rules.md).
See [shared/references/common/rules/50-question-policy.md](../../shared/references/common/rules/50-question-policy.md) (Question Policy: Auto).
See [shared/references/common/rules/06-output-quality.md](../../shared/references/common/rules/06-output-quality.md) (Output Quality Standards - MANDATORY).

### File Writing Rules

**Main orchestrator - NO Bash file writes:**
- ❌ `cat > file <<` (heredoc)
- ❌ `echo ... > file`

**Use instead:**
- ✅ status-update.sh for status files
- ✅ Write tool for general files
- ✅ Task(subagent) for large files

## Workflow Overview (P1-P15 + Execute)

```
[P1-P15: Full Auto]
Requirements → Personas → Divergent → Critics → Auto-Resolution → Chapter Plan
    → UI Architecture → Components → Context Synthesis → Critical Review (Auto)
    → Tests → Assembly → Dev Plan → Docs Hub
      ↓
★ Final Approval (only user interaction for spec)
      ↓
[Auto: spec-it-execute (Phase 0-9)]
      ↓
★ Implementation Complete
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
_meta.mode = "automation"
```

### Step 0.1: Session Init

```
IF --session {sessionId} in args:
  # Reuse session created by router
  sessionDir = .spec-it/{sessionId}/plan
  Read: {sessionDir}/_meta.json
  # Update _meta.json with mode-specific values
  Update _meta.json:
    mode = "automation"
    uiMode = "automation"
    designStyle = from args or Step 0.0
    designTrendsPath = from args or Step 0.0
    dashboardEnabled = from args or Step 0.0
ELSE:
  # Direct invocation — create new session
  result = Bash: session-init.sh "" automation "$(pwd)"
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
| [docs/01-phases.md](docs/01-phases.md) | P1-P15 phase details + Final Approval & Auto-Execute |
| [docs/02-output-structure.md](docs/02-output-structure.md) | Output tree + Mode differences + Agents summary |

## Resume

`/spec-it-automation --resume {sessionId}`
