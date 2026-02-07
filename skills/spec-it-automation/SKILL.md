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

## Workflow Overview (P1-P14 + Execute)

```
[P1-P14: Full Auto]
Requirements → Personas → Divergent → Critics → Auto-Resolution → Chapter Plan
    → UI Architecture → Components → Context Synthesis → Critical Review (Auto)
    → Tests → Assembly → Dev Plan
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

## P1: Requirements (Auto)

```
Bash: status-update.sh {sessionDir} agent-start design-interviewer

Task(design-interviewer, opus):
  Output: 00-requirements/requirements.md

Bash: status-update.sh {sessionDir} agent-complete design-interviewer "" 1.1
Bash: meta-checkpoint.sh {sessionDir} 1.1
```

---

## P2: Personas (Auto)

```
Bash: status-update.sh {sessionDir} agent-start persona-architect

Task(persona-architect, sonnet):
  Input: 00-requirements/requirements.md
  Output: 01-chapters/personas/*.md

Bash: status-update.sh {sessionDir} agent-complete persona-architect "" 2.1
Bash: meta-checkpoint.sh {sessionDir} 2.1
```

---

## P3: Divergent Thinking (Auto)

```
Bash: status-update.sh {sessionDir} agent-start divergent-thinker

Task(divergent-thinker, sonnet):
  Input: requirements.md, personas/
  Output: 01-chapters/alternatives/*.md, _index.md

Bash: status-update.sh {sessionDir} agent-complete divergent-thinker "" 3.1
Bash: meta-checkpoint.sh {sessionDir} 3.1
```

---

## P4: Multi-Critic (Parallel, Auto)

```
Bash: status-update.sh {sessionDir} agent-start "critic-logic,critic-feasibility,critic-frontend"

Task(critic-logic, sonnet, parallel):
  Output: 01-chapters/critique-logic.md

Task(critic-feasibility, sonnet, parallel):
  Output: 01-chapters/critique-feasibility.md

Task(critic-frontend, sonnet, parallel):
  Output: 01-chapters/critique-frontend.md

WAIT for all 3

Bash: status-update.sh {sessionDir} agent-complete "critic-logic,critic-feasibility,critic-frontend"
Bash: status-update.sh {sessionDir} agent-start critic-analytics

Task(critic-analytics, sonnet):
  Input: critique-logic.md, critique-feasibility.md, critique-frontend.md
  Output: 01-chapters/critique-synthesis.md

Bash: status-update.sh {sessionDir} agent-complete critic-analytics "" 4.1
Bash: meta-checkpoint.sh {sessionDir} 4.1
```

---

## P5: Critique Resolution (Auto Consensus)

```
Read: 01-chapters/critique-synthesis.md
Extract: must_resolve_count

IF must_resolve_count > 0:
  Bash: status-update.sh {sessionDir} agent-start critic-moderator

  Task(critic-moderator, opus):
    Input:
      - critique-synthesis.md
      - critique-logic.md
      - critique-feasibility.md
      - critique-frontend.md
    Output: critique-solve/merged-decisions.md

  Bash: status-update.sh {sessionDir} agent-complete critic-moderator "" 5.1

ELSE:
  Write: critique-solve/merged-decisions.md (no issues)

Bash: meta-checkpoint.sh {sessionDir} 5.1
```

---

## P6: Chapter Plan (Auto, RE-EXECUTION POINT)

```
Bash: status-update.sh {sessionDir} agent-start chapter-planner

Task(chapter-planner, opus):
  Input: requirements.md, personas/, alternatives/, critique-solve/
  Output: 01-chapters/chapter-plan-final.md

Bash: status-update.sh {sessionDir} agent-complete chapter-planner "" 6.1
_meta.reexecuteFromP6 = false

Bash: meta-checkpoint.sh {sessionDir} 6.1
Bash: validate-output.sh "$(pwd)/tmp"
```

---

## P7: UI Architecture (Auto)

### Step 7.1: Layout + Domain Map

```
Bash: status-update.sh {sessionDir} agent-start ui-architect

Task(ui-architect, sonnet):
  Read: yaml-ui-frame references, design trends
  Output:
    - 02-wireframes/layouts/layout-system.yaml
    - 02-wireframes/layouts/components.yaml
    - 02-wireframes/domain-map.md
```

### Step 7.2: Screen Lists + Shared (Parallel)

```
FOR each domain (parallel, max 4):
  Task(ui-architect, sonnet): Output shared/{domain}.md

FOR each domain/user-type (parallel, max 4):
  Task(ui-architect, sonnet): Output screen-list.md

Bash: screen-planner.sh {sessionId}
```

### Step 7.3: Wireframes (Parallel Batch)

```
FOR each batch (4 groups):
  Bash: batch-runner.sh {sessionId} wireframe {i}

  Task(ui-architect, sonnet, parallel x4):
    Output: wireframes/{screen-id}.yaml

Bash: status-update.sh {sessionDir} agent-complete ui-architect "" 7.1
Bash: meta-checkpoint.sh {sessionDir} 7.1
```

---

## P8: Component Audit (Auto)

```
Bash: status-update.sh {sessionDir} agent-start component-auditor

Task(component-auditor, haiku):
  Output: 03-components/inventory.md, gap-analysis.md

Bash: status-update.sh {sessionDir} agent-complete component-auditor "" 8.1
Bash: meta-checkpoint.sh {sessionDir} 8.1
```

---

## P9: Component Specs (Parallel, Auto)

```
Bash: component-planner.sh {sessionId}
Bash: status-update.sh {sessionDir} agent-start "component-builder,component-migrator"

Task(component-builder, sonnet, parallel):
  Output: 03-components/new/{component}.yaml

Task(component-migrator, sonnet, parallel):
  Output: 03-components/migrations/migration-plan.md

WAIT

Bash: status-update.sh {sessionDir} agent-complete "component-builder,component-migrator" "" 9.1
Bash: meta-checkpoint.sh {sessionDir} 9.1
Bash: validate-output.sh "$(pwd)/tmp"
```

---

## P10: Context Synthesis (Auto)

```
Bash: status-update.sh {sessionDir} agent-start context-synthesizer

Task(context-synthesizer, sonnet):
  Input: All artifacts from P1-P9
  Output: spec-map.md

Bash: status-update.sh {sessionDir} agent-complete context-synthesizer "" 10.1
Bash: meta-checkpoint.sh {sessionDir} 10.1
```

---

## P11: Critical Review (Auto Consensus)

```
Bash: status-update.sh {sessionDir} agent-start "scenario-reviewer,ia-reviewer,exception-reviewer"

Task(scenario-reviewer, opus, parallel):
  Output: 04-review/scenario-review.md

Task(ia-reviewer, opus, parallel):
  Output: 04-review/ia-review.md

Task(exception-reviewer, opus, parallel):
  Output: 04-review/exception-review.md

WAIT for all 3

Bash: status-update.sh {sessionDir} agent-complete "scenario-reviewer,ia-reviewer,exception-reviewer"
Bash: status-update.sh {sessionDir} agent-start review-analytics

Task(review-analytics, sonnet):
  Output: 04-review/ambiguities.md

Bash: status-update.sh {sessionDir} agent-complete review-analytics

# Auto consensus for resolution
Read: 04-review/ambiguities.md
Extract: must_resolve_count

IF must_resolve_count > 0:
  Bash: status-update.sh {sessionDir} agent-start review-moderator

  Task(review-moderator, opus):
    Input: ambiguities.md, all review files
    Output: 04-review/review-decisions.md

  Bash: status-update.sh {sessionDir} agent-complete review-moderator "" 11.1
ELSE:
  Write: 04-review/review-decisions.md (no ambiguities)

# Check re-execution
Read: 04-review/review-decisions.md
IF reexecution_required:
  Output: "⚠️ Auto re-execution: Returning to P6"
  _meta.reexecuteFromP6 = true
  GOTO P6

Bash: meta-checkpoint.sh {sessionDir} 11.1
Bash: validate-output.sh "$(pwd)/tmp"
```

---

## P12: Test Specification (Auto)

```
Bash: status-update.sh {sessionDir} agent-start test-spec-writer

Task(test-spec-writer, sonnet):
  Input: personas/, spec-map.md, review-decisions.md
  Output:
    - test-scenarios/_index.md
    - test-scenarios/{persona-id}/**
    - test-scenarios/cross-persona/** (REQUIRED)

Bash: status-update.sh {sessionDir} agent-complete test-spec-writer "" 12.1
Bash: meta-checkpoint.sh {sessionDir} 12.1
```

---

## P13: Final Assembly (Auto)

```
Bash: status-update.sh {sessionDir} agent-start spec-assembler

Task(spec-assembler, haiku):
  Input: spec-map.md, test-scenarios/
  Output:
    - 06-final/final-spec.md
    - 06-final/SPEC-SUMMARY.md

Bash: status-update.sh {sessionDir} agent-complete spec-assembler "" 13.1
Bash: meta-checkpoint.sh {sessionDir} 13.1
```

---

## P14: Development Planning (Auto)

### Step 14.1: API Prediction

```
Skill(api-predictor):
  Input: spec-map.md, wireframes, components
  Output: dev-plan/api-map.md
```

### Step 14.2: Dev Plan

```
Bash: status-update.sh {sessionDir} agent-start dev-planner

Task(dev-planner, sonnet):
  Input: spec-map.md, api-map.md, test-scenarios/
  Output:
    - dev-plan/development-map.md
    - dev-plan/{persona-id}/Phase-{n}/Task-{n}.md
    - dev-plan/shared/Phase-0/Task-{n}.md

Bash: status-update.sh {sessionDir} agent-complete dev-planner "" 14.1
Bash: meta-checkpoint.sh {sessionDir} 14.1
Bash: validate-output.sh "$(pwd)/tmp"
```

---

## Final Approval & Auto-Execute

```
Read: 06-final/SPEC-SUMMARY.md

AskUserQuestion: "Spec complete. Ready to start implementation?"
Options: [
  {label: "Proceed to Execute (Recommended)", description: "Auto-start implementation"},
  {label: "Review First", description: "Review spec, then manually run /spec-it-execute"},
  {label: "Spec Only", description: "Don't execute, keep spec files"}
]

IF "Proceed to Execute" OR "Proceed":
  Output: "Starting implementation with spec-it-execute..."

  Skill(spec-it-execute, "tmp --design-style {_meta.designStyle} --dashboard {_meta.dashboardEnabled}")

ELIF "Review First":
  Output: "Spec saved. Run /spec-it-execute tmp when ready."

ELSE ("Spec Only"):
  AskUserQuestion: "Handle tmp folder?"
  Options: [Archive, Keep, Delete]
  IF Archive: mv tmp archive/specs-{sessionId}
  IF Delete: rm -rf tmp

Bash: status-update.sh {sessionDir} complete
```

---

## Output Structure

```
tmp/
├── 00-requirements/requirements.md
├── 01-chapters/
│   ├── personas/
│   ├── alternatives/
│   ├── critique-*.md
│   ├── critique-synthesis.md
│   └── chapter-plan-final.md
├── critique-solve/
│   └── merged-decisions.md (auto-resolved)
├── 02-wireframes/
├── 03-components/
├── 04-review/
│   ├── scenario-review.md
│   ├── ia-review.md
│   ├── exception-review.md
│   ├── ambiguities.md
│   └── review-decisions.md (auto-resolved)
├── 05-tests/test-scenarios/
│   ├── {persona-id}/
│   └── cross-persona/
├── 06-final/
├── spec-map.md
└── dev-plan/
    ├── development-map.md
    ├── api-map.md
    └── {persona-id}/Phase-{n}/
```

---

## Mode Differences Summary

| Aspect | stepbystep | complex | automation |
|--------|------------|---------|------------|
| P5 Resolution | critique-resolver | critique-resolver | **critic-moderator** |
| P11 Resolution | review-resolver | review-resolver | **review-moderator** |
| Approval Points | Every phase | 4 milestones | Final only |
| Auto Execute | No | No | **Yes** |

---

## Agents Summary

| Phase | Agent | Model | Mode |
|-------|-------|-------|------|
| P1 | design-interviewer | opus | Auto |
| P2 | persona-architect | sonnet | Auto |
| P3 | divergent-thinker | sonnet | Auto |
| P4 | critic-logic, critic-feasibility, critic-frontend | sonnet | Parallel |
| P4 | critic-analytics | sonnet | Auto |
| P5 | **critic-moderator** | opus | Auto consensus |
| P6 | chapter-planner | opus | Auto |
| P7 | ui-architect | sonnet | Parallel batch |
| P8 | component-auditor | haiku | Auto |
| P9 | component-builder, component-migrator | sonnet | Parallel |
| P10 | context-synthesizer | sonnet | Auto |
| P11 | scenario-reviewer, ia-reviewer, exception-reviewer | opus | Parallel |
| P11 | review-analytics | sonnet | Auto |
| P11 | **review-moderator** | opus | Auto consensus |
| P12 | test-spec-writer | sonnet | Auto |
| P13 | spec-assembler | haiku | Auto |
| P14 | dev-planner | sonnet | Auto |

---

## Resume

```
/spec-it-automation --resume {sessionId}
```
