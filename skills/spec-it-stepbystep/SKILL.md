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

## Workflow Overview (P1-P14)

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

## P1: Requirements Gathering

```
Bash: status-update.sh {sessionDir} agent-start design-interviewer

Task(design-interviewer, opus):
  Output: 00-requirements/requirements.md

Bash: status-update.sh {sessionDir} agent-complete design-interviewer "" 1.1
Bash: meta-checkpoint.sh {sessionDir} 1.1

AskUserQuestion: "Requirements captured. Review and approve?"
Options: [Approve, Revise, Questions]
IF Revise/Questions: Loop
```

---

## P2: Persona Definition

```
Bash: status-update.sh {sessionDir} agent-start persona-architect

Task(persona-architect, sonnet):
  Input: 00-requirements/requirements.md
  Output: 01-chapters/personas/*.md

Bash: status-update.sh {sessionDir} agent-complete persona-architect "" 2.1
Bash: meta-checkpoint.sh {sessionDir} 2.1

AskUserQuestion: "Personas defined. Review and approve?"
Options: [Approve, Revise]
```

---

## P3: Divergent Thinking

```
Bash: status-update.sh {sessionDir} agent-start divergent-thinker

Task(divergent-thinker, sonnet):
  Input: requirements.md, personas/
  Output: 01-chapters/alternatives/*.md, _index.md

Bash: status-update.sh {sessionDir} agent-complete divergent-thinker "" 3.1
Bash: meta-checkpoint.sh {sessionDir} 3.1

AskUserQuestion: "Alternatives explored. Review and approve?"
Options: [Approve, Explore More]
```

---

## P4: Multi-Critic Review (Parallel)

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

## P5: Critique Resolution (User Input)

```
Read: 01-chapters/critique-synthesis.md
Extract: must_resolve_count

IF must_resolve_count > 0:
  Bash: status-update.sh {sessionDir} agent-start critique-resolver

  # Use critique-resolver skill for user input
  Skill(critique-resolver):
    Input: critique-synthesis.md
    Output: critique-solve/*.md

  Bash: status-update.sh {sessionDir} agent-complete critique-resolver "" 5.1

ELSE:
  Write: critique-solve/merged-decisions.md (empty - no issues)

Bash: meta-checkpoint.sh {sessionDir} 5.1

AskUserQuestion: "Critique resolved. Proceed to chapter planning?"
Options: [Proceed, Review Decisions]
```

---

## P6: Chapter Plan (RE-EXECUTION POINT)

```
Bash: status-update.sh {sessionDir} agent-start chapter-planner

Task(chapter-planner, opus):
  Input: requirements.md, personas/, alternatives/, critique-solve/
  Output: 01-chapters/chapter-plan-final.md

Bash: status-update.sh {sessionDir} agent-complete chapter-planner "" 6.1
Bash: meta-checkpoint.sh {sessionDir} 6.1

# Clear re-execution flag if set
_meta.reexecuteFromP6 = false

AskUserQuestion: "{N} chapters planned. Approve structure?"
Options: [Approve, Modify]
```

---

## P7: UI Architecture

### Step 7.1: Layout System + Domain Map

```
Bash: status-update.sh {sessionDir} agent-start ui-architect

Task(ui-architect, sonnet):
  Read: yaml-ui-frame references, design trends
  Output:
    - 02-wireframes/layouts/layout-system.yaml
    - 02-wireframes/layouts/components.yaml
    - 02-wireframes/domain-map.md
```

### Step 7.2: Screen Lists + Shared Docs

```
FOR each domain (parallel):
  Task(ui-architect, sonnet): Output shared/{domain}.md

FOR each domain/user-type (parallel):
  Task(ui-architect, sonnet): Output screen-list.md

Bash: screen-planner.sh {sessionId}
```

### Step 7.3: Wireframes

```
FOR each batch (parallel):
  Task(ui-architect, sonnet):
    Output: wireframes/{screen-id}.yaml

Bash: status-update.sh {sessionDir} agent-complete ui-architect "" 7.1
Bash: meta-checkpoint.sh {sessionDir} 7.1

AskUserQuestion: "Wireframes complete. Review and approve?"
Options: [Approve, Revise]
```

---

## P8: Component Audit

```
Bash: status-update.sh {sessionDir} agent-start component-auditor

Task(component-auditor, haiku):
  Output: 03-components/inventory.md, gap-analysis.md

Bash: status-update.sh {sessionDir} agent-complete component-auditor "" 8.1
Bash: meta-checkpoint.sh {sessionDir} 8.1
```

---

## P9: Component Specs (Parallel)

```
Bash: component-planner.sh {sessionId}
Bash: status-update.sh {sessionDir} agent-start "component-builder,component-migrator"

Task(component-builder, sonnet, parallel):
  Output: 03-components/new/{component}.yaml

Task(component-migrator, sonnet, parallel):
  Output: 03-components/migrations/migration-plan.md

Bash: status-update.sh {sessionDir} agent-complete "component-builder,component-migrator" "" 9.1
Bash: meta-checkpoint.sh {sessionDir} 9.1

AskUserQuestion: "Components specified. Approve?"
Options: [Approve, Revise]
```

---

## P10: Context Synthesis

```
Bash: status-update.sh {sessionDir} agent-start context-synthesizer

Task(context-synthesizer, sonnet):
  Input: All artifacts from P1-P9
  Output: spec-map.md

Bash: status-update.sh {sessionDir} agent-complete context-synthesizer "" 10.1
Bash: meta-checkpoint.sh {sessionDir} 10.1
```

---

## P11: Critical Review

```
# Use critical-review skill (orchestrates internal agents)
Skill(critical-review, --mode stepbystep):
  Internal flow:
    1. scenario-reviewer (opus, parallel)
    2. ia-reviewer (opus, parallel)
    3. exception-reviewer (opus, parallel)
    4. WAIT
    5. review-analytics (sonnet) → ambiguities.md
    6. IF must_resolve > 0: review-resolver (user input)
    7. Output: review-decisions.md

Read: 04-review/review-decisions.md
Check: Re-execution Trigger

IF reexecution_required:
  Output: "⚠️ Returning to P6 for re-planning."
  _meta.reexecuteFromP6 = true
  GOTO P6

Bash: meta-checkpoint.sh {sessionDir} 11.1

AskUserQuestion: "Critical review complete. Proceed to test specs?"
Options: [Proceed, Review]
```

---

## P12: Test Specification

```
Bash: status-update.sh {sessionDir} agent-start test-spec-writer

Task(test-spec-writer, sonnet):
  Input: personas/, spec-map.md, review-decisions.md
  Output:
    - test-scenarios/_index.md
    - test-scenarios/{persona-id}/**
    - test-scenarios/cross-persona/**

Bash: status-update.sh {sessionDir} agent-complete test-spec-writer "" 12.1
Bash: meta-checkpoint.sh {sessionDir} 12.1

AskUserQuestion: "Test scenarios complete. Approve?"
Options: [Approve, Revise]
```

---

## P13: Final Assembly

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

## P14: Development Planning

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
```

---

## Final Approval

```
Read: 06-final/SPEC-SUMMARY.md

AskUserQuestion: "Spec complete. What next?"
Options: [
  {label: "Run /spec-it-execute", description: "Start implementation"},
  {label: "Archive", description: "Move to archive/"},
  {label: "Keep", description: "Keep in tmp/"}
]

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
│   ├── merged-decisions.md
│   ├── ambiguity-resolved.md
│   └── undefined-specs.md
├── 02-wireframes/
├── 03-components/
├── 04-review/
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

## Resume

```
/spec-it-stepbystep --resume {sessionId}
```
