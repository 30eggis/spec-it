---
name: spec-it-complex
description: "Hybrid spec generator with 4 milestone approvals for medium projects."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
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

## Workflow Overview (P1-P14)

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
[P12-P14: Auto] Tests → Assembly → Dev Plan
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

## Phase 1-6: Requirements to Chapter Plan (Auto)

### P1: Requirements

```
Bash: status-update.sh {sessionDir} agent-start design-interviewer

Task(design-interviewer, opus):
  Output: 00-requirements/requirements.md

Bash: status-update.sh {sessionDir} agent-complete design-interviewer "" 1.1
```

### P2: Personas

```
Bash: status-update.sh {sessionDir} agent-start persona-architect

Task(persona-architect, sonnet):
  Output: 01-chapters/personas/*.md

Bash: status-update.sh {sessionDir} agent-complete persona-architect "" 2.1
```

### P3: Divergent Thinking

```
Bash: status-update.sh {sessionDir} agent-start divergent-thinker

Task(divergent-thinker, sonnet):
  Output: 01-chapters/alternatives/*.md

Bash: status-update.sh {sessionDir} agent-complete divergent-thinker "" 3.1
```

### P4: Multi-Critic (Parallel)

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
  Output: 01-chapters/critique-synthesis.md

Bash: status-update.sh {sessionDir} agent-complete critic-analytics "" 4.1
```

### P5: Critique Resolution (User Input)

```
Read: 01-chapters/critique-synthesis.md
Extract: must_resolve_count

IF must_resolve_count > 0:
  Bash: status-update.sh {sessionDir} agent-start critique-resolver

  Skill(critique-resolver):
    Input: critique-synthesis.md
    Output: critique-solve/*.md

  Bash: status-update.sh {sessionDir} agent-complete critique-resolver "" 5.1
ELSE:
  Write: critique-solve/merged-decisions.md (no issues)
```

### P6: Chapter Plan

```
Bash: status-update.sh {sessionDir} agent-start chapter-planner

Task(chapter-planner, opus):
  Output: 01-chapters/chapter-plan-final.md

Bash: status-update.sh {sessionDir} agent-complete chapter-planner "" 6.1
_meta.reexecuteFromP6 = false

Bash: validate-output.sh "$(pwd)/tmp"
```

---

## ★ MILESTONE 1: Chapter Plan Approval

```
Read: 01-chapters/chapter-plan-final.md

AskUserQuestion: "{N} chapters planned. Proceed with UI architecture?"
Options: [
  {label: "Proceed (Recommended)", description: "Continue to wireframes"},
  {label: "Modify Plan", description: "Revise chapter structure"},
  {label: "Review Details", description: "See full chapter breakdown"}
]

IF Modify: Revise and re-run P6
```

---

## Phase 7-9: UI & Components (Auto)

### P7: UI Architecture

```
Bash: status-update.sh {sessionDir} agent-start ui-architect

Task(ui-architect, sonnet):
  Output:
    - 02-wireframes/layouts/layout-system.yaml
    - 02-wireframes/layouts/components.yaml
    - 02-wireframes/domain-map.md

FOR each domain (parallel): shared/{domain}.md
FOR each domain/user-type (parallel): screen-list.md

Bash: screen-planner.sh {sessionId}

FOR each batch (parallel):
  Task(ui-architect, sonnet): wireframes/{screen-id}.yaml

Bash: status-update.sh {sessionDir} agent-complete ui-architect "" 7.1
```

### P8: Component Audit

```
Bash: status-update.sh {sessionDir} agent-start component-auditor

Task(component-auditor, haiku):
  Output: 03-components/inventory.md, gap-analysis.md

Bash: status-update.sh {sessionDir} agent-complete component-auditor "" 8.1
```

### P9: Component Specs (Parallel)

```
Bash: component-planner.sh {sessionId}
Bash: status-update.sh {sessionDir} agent-start "component-builder,component-migrator"

Task(component-builder, sonnet, parallel):
  Output: 03-components/new/{component}.yaml

Task(component-migrator, sonnet, parallel):
  Output: 03-components/migrations/migration-plan.md

Bash: status-update.sh {sessionDir} agent-complete "component-builder,component-migrator" "" 9.1
Bash: validate-output.sh "$(pwd)/tmp"
```

---

## ★ MILESTONE 2: UI & Components Approval

```
AskUserQuestion: "UI architecture and components complete. Proceed to review?"
Options: [
  {label: "Proceed (Recommended)", description: "Continue to critical review"},
  {label: "Review Wireframes", description: "Check screen designs"},
  {label: "Review Components", description: "Check component specs"}
]
```

---

## Phase 10-11: Review (Auto)

### P10: Context Synthesis

```
Bash: status-update.sh {sessionDir} agent-start context-synthesizer

Task(context-synthesizer, sonnet):
  Output: spec-map.md

Bash: status-update.sh {sessionDir} agent-complete context-synthesizer "" 10.1
```

### P11: Critical Review

```
Skill(critical-review, --mode complex):
  Internal flow:
    1. scenario-reviewer + ia-reviewer + exception-reviewer (parallel)
    2. review-analytics → ambiguities.md
    3. IF must_resolve > 0: review-resolver (user input)
    4. Output: review-decisions.md

Read: 04-review/review-decisions.md
Check: Re-execution Trigger

IF reexecution_required:
  Output: "⚠️ Returning to P6 for re-planning."
  _meta.reexecuteFromP6 = true
  GOTO P6

Bash: validate-output.sh "$(pwd)/tmp"
```

---

## ★ MILESTONE 3: Review Approval

```
AskUserQuestion: "Critical review complete. Proceed to test specs?"
Options: [
  {label: "Proceed (Recommended)", description: "Continue to test specification"},
  {label: "Review Findings", description: "Check review results"},
  {label: "Re-run Review", description: "Run critical review again"}
]
```

---

## Phase 12-14: Tests & Planning (Auto)

### P12: Test Specification

```
Bash: status-update.sh {sessionDir} agent-start test-spec-writer

Task(test-spec-writer, sonnet):
  Output:
    - test-scenarios/_index.md
    - test-scenarios/{persona-id}/**
    - test-scenarios/cross-persona/**

Bash: status-update.sh {sessionDir} agent-complete test-spec-writer "" 12.1
```

### P13: Final Assembly

```
Bash: status-update.sh {sessionDir} agent-start spec-assembler

Task(spec-assembler, haiku):
  Output:
    - 06-final/final-spec.md
    - 06-final/SPEC-SUMMARY.md

Bash: status-update.sh {sessionDir} agent-complete spec-assembler "" 13.1
```

### P14: Development Planning

```
Skill(api-predictor):
  Output: dev-plan/api-map.md

Bash: status-update.sh {sessionDir} agent-start dev-planner

Task(dev-planner, sonnet):
  Output:
    - dev-plan/development-map.md
    - dev-plan/{persona-id}/Phase-{n}/Task-{n}.md
    - dev-plan/shared/Phase-0/Task-{n}.md

Bash: status-update.sh {sessionDir} agent-complete dev-planner "" 14.1
Bash: validate-output.sh "$(pwd)/tmp"
```

---

## ★ MILESTONE 4: Final Approval

```
Read: 06-final/SPEC-SUMMARY.md

AskUserQuestion: "Spec complete. What would you like to do?"
Options: [
  {label: "Run /spec-it-execute", description: "Start implementation"},
  {label: "Archive", description: "Move to archive/"},
  {label: "Keep", description: "Keep in tmp/"},
  {label: "Review Summary", description: "See full summary"}
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
│   ├── scenario-review.md
│   ├── ia-review.md
│   ├── exception-review.md
│   ├── ambiguities.md
│   └── review-decisions.md
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

## Agents Summary

| Phase | Agent | Model |
|-------|-------|-------|
| P1 | design-interviewer | opus |
| P2 | persona-architect | sonnet |
| P3 | divergent-thinker | sonnet |
| P4 | critic-logic, critic-feasibility, critic-frontend | sonnet |
| P4 | critic-analytics | sonnet |
| P5 | critique-resolver | sonnet |
| P6 | chapter-planner | opus |
| P7 | ui-architect | sonnet |
| P8 | component-auditor | haiku |
| P9 | component-builder, component-migrator | sonnet |
| P10 | context-synthesizer | sonnet |
| P11 | scenario-reviewer, ia-reviewer, exception-reviewer | opus |
| P11 | review-analytics, review-resolver | sonnet |
| P12 | test-spec-writer | sonnet |
| P13 | spec-assembler | haiku |
| P14 | dev-planner | sonnet |

---

## Resume

```
/spec-it-complex --resume {sessionId}
```
