---
name: spec-it-automation
description: "Frontend spec generator (Full Auto mode). Maximum automation with minimal approval. Best for large projects."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
---

# spec-it-automation: Full Auto Mode

Transform PRD/vibe-coding into frontend specifications with **maximum automation** and **minimal user intervention**.

## Rules

See [shared/output-rules.md](../shared/output-rules.md) and [shared/context-rules.md](../shared/context-rules.md).

## Workflow

```
[Auto: Requirements → Divergent → Multi-Critic → Chapter Plan]
      ↓
[Auto: UI Architecture + Component Discovery]
      ↓
[Auto: Critical Review]
      ↓
[IF ambiguity: User Question]
      ↓
[Auto: Test Spec → Assembly]
      ↓
★ Final Approval (only user interaction)
```

---

## Phase 0: Init

### Step 0.0: UI Mode Selection

```
AskUserQuestion: "Select UI design mode"
Options: ["ASCII Wireframe (Recommended)", "Google Stitch"]

IF Stitch:
  Task(stitch-controller): Install and auth
  IF failed: Fallback to ASCII
```

### Step 0.1: Session Init

```
Bash: scripts/core/session-init.sh {sessionId} {uiMode}
→ Auto-launches dashboard
```

### Step 0.R: Resume

```
IF --resume in args:
  Read: tmp/{sessionId}/_meta.json
  GOTO: _meta.currentStep
```

---

## Phase 1: Design Brainstorming (Auto)

### Step 1.1: Requirements

```
Bash: scripts/core/status-update.sh {sessionId} agent-start design-interviewer

Task(design-interviewer, opus):
  Output: 00-requirements/requirements.md

Bash: scripts/core/status-update.sh {sessionId} agent-complete design-interviewer
Bash: scripts/core/meta-checkpoint.sh {sessionId} 1.1
```

### Step 1.2: Divergent Thinking

```
Task(divergent-thinker, sonnet):
  Output: 01-chapters/alternatives/*.md, _index.md
```

### Step 1.3: Multi-Critic Debate (Parallel)

```
Task(critic-logic, sonnet, parallel):
  Output: 01-chapters/critique-logic.md

Task(critic-feasibility, sonnet, parallel):
  Output: 01-chapters/critique-feasibility.md

Task(critic-frontend, sonnet, parallel):
  Output: 01-chapters/critique-frontend.md

WAIT for all 3

Task(critic-moderator, opus):
  - Synthesize 3 critiques
  - Resolve conflicts
  - Output: 01-chapters/critique-final.md
```

### Step 1.4: Chapter Plan

```
Task(chapter-planner, opus):
  Output: 01-chapters/chapter-plan-final.md

Bash: scripts/core/status-update.sh {sessionId} progress 16 1.4 1
```

---

## Phase 2: UI + Components (Auto)

### Step 2.1: UI Architecture

```
Bash: scripts/core/phase-dispatcher.sh {sessionId} ui
→ Returns: DISPATCH:stitch-controller OR DISPATCH:ascii-wireframe
```

### IF STITCH Mode

```
Task(stitch-controller, sonnet):
  1. ASCII wireframes via ui-architect
  2. Create Stitch project
  3. Convert to Hi-Fi
  4. Export HTML/CSS
  Output: 02-screens/wireframes/, html/, assets/, qa-report.md
```

### IF ASCII Mode

```
Task(ui-architect, sonnet):
  Output: screen-list.md, layouts/layout-system.md

Bash: scripts/planners/screen-planner.sh {sessionId}

FOR each batch (4 screens):
  Bash: scripts/executors/batch-runner.sh {sessionId} wireframe {i}

  Task(ui-architect, sonnet, parallel x4):
    Output: wireframes/wireframe-{screen}.md
```

### Step 2.2: Component Discovery + Build

```
Task(component-auditor, haiku, parallel):
  Output: 03-components/inventory.md, gap-analysis.md

WAIT

Bash: scripts/planners/component-planner.sh {sessionId}

Task(component-builder, sonnet, parallel):
  Output: 03-components/new/spec-{component}.md

Task(component-migrator, sonnet, parallel):
  Output: 03-components/migrations/migration-plan.md

Bash: scripts/core/status-update.sh {sessionId} progress 33 2.2 2
```

---

## Phase 3: Critical Review (Auto)

### Step 3.1: Parallel Review

```
Task(critical-reviewer, opus, parallel):
  Output: 04-review/scenarios/, ia-review.md, exceptions/

Task(ambiguity-detector, opus, parallel):
  Output: 04-review/ambiguities.md

WAIT for both
```

### Step 3.2: Ambiguity Resolution

```
Bash: scripts/core/phase-dispatcher.sh {sessionId} ambiguity

IF DISPATCH:user-question:
  Read: 04-review/ambiguities.md
  Extract "Must Resolve" items

  AskUserQuestion: "Resolve these ambiguities"
  (dynamic options based on ambiguities)

  Write: 04-review/ambiguities-resolved.md

ELSE:
  Auto-proceed

Bash: scripts/core/status-update.sh {sessionId} progress 50 3.2 3
```

---

## Phase 4: Test Specification (Auto)

```
Task(persona-architect, sonnet, parallel):
  Output: 05-tests/personas/

Task(test-spec-writer, sonnet, parallel):
  Output: 05-tests/scenarios/, components/, coverage-map.md

WAIT for both

Bash: scripts/core/status-update.sh {sessionId} progress 66 4.1 4
```

---

## Phase 5: Final Assembly (Auto)

```
Task(spec-assembler, haiku):
  Output:
  - 06-final/final-spec.md
  - 06-final/dev-tasks.md
  - 06-final/SPEC-SUMMARY.md

Bash: scripts/core/status-update.sh {sessionId} progress 83 5.1 5
```

---

## Phase 6: Final Approval

```
Read: 06-final/SPEC-SUMMARY.md

AskUserQuestion: "Spec complete. Handle tmp folder?"
Options: [Archive, Keep, Delete]

IF Archive: mv tmp/{sessionId} archive/
IF Delete: rm -rf tmp/{sessionId}

Bash: scripts/core/status-update.sh {sessionId} complete
```

---

## Output Structure

```
tmp/{sessionId}/
├── _meta.json, _status.json
├── 00-requirements/
├── 01-chapters/
│   ├── alternatives/
│   ├── critique-logic.md, critique-feasibility.md, critique-frontend.md
│   ├── critique-final.md
│   └── chapter-plan-final.md
├── 02-screens/
│   ├── screen-list.md, layouts/
│   ├── wireframes/ (ASCII)
│   └── html/, assets/ (Stitch)
├── 03-components/inventory.md, gap-analysis.md, new/, migrations/
├── 04-review/scenarios/, exceptions/, ambiguities.md
├── 05-tests/personas/, scenarios/, coverage-map.md
└── 06-final/final-spec.md, dev-tasks.md, SPEC-SUMMARY.md
```

---

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| design-interviewer | opus | Requirements |
| divergent-thinker | sonnet | Alternatives |
| critic-logic | sonnet | Logic validation |
| critic-feasibility | sonnet | Feasibility check |
| critic-frontend | sonnet | Frontend review |
| critic-moderator | opus | Synthesize critiques |
| chapter-planner | opus | Plan chapters |
| ui-architect | sonnet | Wireframes |
| stitch-controller | sonnet | Stitch workflow |
| component-auditor | haiku | Scan components |
| component-builder | sonnet | Build specs |
| component-migrator | sonnet | Migration plan |
| critical-reviewer | opus | Scenario review |
| ambiguity-detector | opus | Find ambiguities |
| persona-architect | sonnet | Personas |
| test-spec-writer | sonnet | Test specs |
| spec-assembler | haiku | Final assembly |

---

## Progress Tracking

| Phase | Steps | Progress |
|-------|-------|----------|
| 1 | 1.1-1.4 | 0-16% |
| 2 | 2.1-2.2 | 17-33% |
| 3 | 3.1-3.2 | 34-50% |
| 4 | 4.1 | 51-66% |
| 5 | 5.1 | 67-83% |
| 6 | 6.1 | 84-100% |

---

## Resume

```
/frontend-skills:spec-it-automation --resume {sessionId}
```
