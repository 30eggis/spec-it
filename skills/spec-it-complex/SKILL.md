---
name: spec-it-complex
description: "Frontend spec generator (Hybrid mode). Auto-validation with 4 milestone approvals. Best for medium projects."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it-complex: Hybrid Mode

Transform PRD/vibe-coding into frontend specifications with **auto-validation** and **4 milestone approvals**.

## Rules

See [shared/output-rules.md](../shared/output-rules.md) and [shared/context-rules.md](../shared/context-rules.md).

## Workflow

```
[Requirements] → [Divergent] → [3-Round Critique] → [Chapter Plan]
      ↓
★ MILESTONE 1: "Proceed with N chapters?"
      ↓
[CH-00~02: Auto] → ★ MILESTONE 2: "Basic structure OK?"
      ↓
[CH-03~04: Auto] → ★ MILESTONE 3: "Features OK?"
      ↓
[CH-05~07: Auto] → [Review] → [Tests] → [Assembly]
      ↓
★ MILESTONE 4: Final approval
```

---

## Phase 0: Init

### Step 0.0: UI Mode Selection

```
AskUserQuestion: "Select UI design mode"
Options: ["ASCII Wireframe (Recommended)", "Google Stitch"]

IF Stitch:
  Bash: ./scripts/verify-stitch-mcp.sh
  IF exit != 0:
    Bash: ./scripts/setup-stitch-mcp.sh
    IF exit == 2: RESTART_REQUIRED (MCP needs Claude restart)
    IF exit == 1: Fallback to ASCII
```

### Step 0.1: Session Init

```
Bash: ../../scripts/core/session-init.sh {sessionId} {uiMode}
→ Auto-launches dashboard
```

### Step 0.R: Resume

```
IF --resume in args:
  Read: tmp/{sessionId}/_meta.json
  GOTO: _meta.currentStep
```

---

## Phase 1: Design Brainstorming

### Step 1.1: Requirements Analysis

```
Task(design-interviewer, opus):
  Output: 00-requirements/requirements.md

Bash: ../../scripts/core/meta-checkpoint.sh {sessionId} 1.1
```

### Step 1.2: Divergent Thinking + Critique

```
Task(divergent-thinker, sonnet):
  Output: 01-chapters/alternatives/*.md

FOR round in [1, 2, 3]:
  Task(chapter-critic, opus):
    Output: 01-chapters/critique-round{round}.md

Task(chapter-planner, opus):
  Output: 01-chapters/chapter-plan-final.md

Bash: ../../scripts/core/meta-checkpoint.sh {sessionId} 1.2
```

---

## ★ MILESTONE 1: Chapter Plan Approval

```
Read: 01-chapters/chapter-plan-final.md

AskUserQuestion: "{N} chapters planned. Proceed?"
Options: [Yes, Modify]

IF Modify: Revise plan
```

---

## Phase 2: Chapters + UI Architecture

### Step 2.1: Batch 1 (CH-00~02)

```
Task(chapter-writer, sonnet, parallel):
  Output: 01-chapters/decisions/CH-00.md, CH-01.md

Bash: ../../scripts/core/phase-dispatcher.sh {sessionId} ui
→ DISPATCH:stitch-convert OR DISPATCH:ascii-wireframe
```

### IF STITCH Mode

```
# Step 1: Generate ASCII wireframes first
Task(ui-architect, sonnet):
  Output: screen-list.md, layouts/, wireframes/

# Step 2: Convert to HTML via Stitch MCP (runs in main session)
/stitch-convert {sessionId}
Output: 02-screens/html/, assets/
```

### IF ASCII Mode

```
Task(ui-architect, sonnet):
  Output: 02-screens/screen-list.md, layouts/layout-system.md

Bash: ../../scripts/planners/screen-planner.sh {sessionId}

FOR each batch:
  Task(ui-architect, sonnet, parallel):
    Output: 02-screens/wireframes/wireframe-{screen}.md
```

---

## ★ MILESTONE 2: Basic Structure Approval

```
AskUserQuestion: "Basic structure (CH-00~02) complete. Continue?"
Options: [Yes, Review]
```

---

## Phase 3: Features + Components

### Step 3.1: Batch 2 (CH-03~04)

```
Task(chapter-writer, sonnet, parallel):
  Output: 01-chapters/decisions/CH-03.md, CH-04.md

Task(component-auditor, haiku):
  Output: 03-components/inventory.md, gap-analysis.md

Bash: ../../scripts/planners/component-planner.sh {sessionId}

Task(component-builder, sonnet, parallel):
  Output: 03-components/new/spec-{component}.md

Task(component-migrator, sonnet):
  Output: 03-components/migrations/migration-plan.md
```

---

## ★ MILESTONE 3: Feature Approval

```
AskUserQuestion: "Features (CH-03~04) complete. Continue?"
Options: [Yes, Review]
```

---

## Phase 4: Remaining + Review

### Step 4.1: Batch 3 (CH-05~07) + Review

```
Task(chapter-writer, sonnet, parallel):
  Output: CH-05.md, CH-06.md, CH-07.md

Task(critical-reviewer, opus, parallel):
  Output: 04-review/scenarios/, ia-review.md, exceptions/

Task(ambiguity-detector, opus, parallel):
  Output: 04-review/ambiguities.md

Bash: ../../scripts/core/phase-dispatcher.sh {sessionId} ambiguity
→ IF must-resolve: AskUserQuestion
```

---

## Phase 5: Test Specification

```
Task(persona-architect, sonnet, parallel):
  Output: 05-tests/personas/

Task(test-spec-writer, sonnet, parallel):
  Output: 05-tests/scenarios/, components/, coverage-map.md
```

---

## Phase 6: Final Assembly

```
Task(spec-assembler, haiku):
  Output: 06-final/final-spec.md, dev-tasks.md, SPEC-SUMMARY.md
```

---

## ★ MILESTONE 4: Final Approval

```
AskUserQuestion: "Spec complete. Handle tmp folder?"
Options: [Archive, Keep, Delete]

Bash: ../../scripts/core/status-update.sh {sessionId} complete
```

---

## Output Structure

```
tmp/{sessionId}/
├── _meta.json, _status.json
├── 00-requirements/
├── 01-chapters/
│   ├── alternatives/, decisions/
│   ├── critique-round1~3.md
│   └── chapter-plan-final.md
├── 02-screens/wireframes/, layouts/, [html/]
├── 03-components/new/, migrations/
├── 04-review/scenarios/, exceptions/
├── 05-tests/personas/, scenarios/
└── 06-final/
```

---

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| design-interviewer | opus | Requirements |
| divergent-thinker | sonnet | Alternatives |
| chapter-critic | opus | 3-round critique |
| chapter-planner | opus | Plan chapters |
| chapter-writer | sonnet | Write chapters |
| ui-architect | sonnet | Wireframes |
| component-auditor | haiku | Component scan |
| component-builder | sonnet | Component spec |
| component-migrator | sonnet | Migration |
| critical-reviewer | opus | Review |
| ambiguity-detector | opus | Ambiguities |
| persona-architect | sonnet | Personas |
| test-spec-writer | sonnet | Tests |
| spec-assembler | haiku | Assembly |

| Skill | Purpose |
|-------|---------|
| stitch-convert | ASCII → Stitch MCP → HTML export |

---

## Resume

```
/frontend-skills:spec-it-complex --resume {sessionId}
```
