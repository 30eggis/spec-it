---
name: spec-it
description: "Frontend spec generator (Manual mode). Chapter-by-chapter user approval. Best for small projects or learning."
allowed-tools: Read, Write, Edit, Bash, Task, AskUserQuestion
argument-hint: "[--resume <sessionId>]"
---

# spec-it: Manual Mode

Transform PRD/vibe-coding into frontend specifications with **chapter-by-chapter approval**.

## Rules

See [shared/output-rules.md](../shared/output-rules.md) and [shared/context-rules.md](../shared/context-rules.md).

## Workflow

```
[CH-00] → Approval → [CH-01] → Approval → ... → [CH-07] → Final
```

---

## Phase 0: Init

### Step 0.0: UI Mode Selection

```
AskUserQuestion: "Select UI design mode"
Options: ["ASCII Wireframe (Recommended)", "Google Stitch"]

IF Stitch:
  Task(stitch-controller): Install and auth Stitch MCP
  IF failed: Fallback to ASCII
```

### Step 0.1: Session Init

```
Bash: scripts/core/session-init.sh {sessionId} {uiMode}
→ Creates folders, _meta.json, _status.json
→ Auto-launches dashboard in separate terminal
```

### Step 0.R: Resume

```
IF --resume in args:
  Read: tmp/{sessionId}/_meta.json
  GOTO: _meta.currentStep
```

---

## Phase 1: Design Brainstorming

### Chapters (CH-00 to CH-07)

```
CH-00: Project Scope & Constraints
CH-01: User & Persona Definition
CH-02: Information Architecture
CH-03: Screen Inventory
CH-04: Feature Definition
CH-05: Component Requirements
CH-06: State & Data Flow
CH-07: Non-Functional Requirements
```

### For Each Chapter

```
1. Task(design-interviewer, opus):
   - Conduct Q&A for chapter
   - Output: 01-chapters/decisions/decision-{chapter}.md

2. Show chapter summary to user

3. AskUserQuestion: "Is this correct?"
   Options: [Yes, No, Questions]

4. Bash: scripts/core/meta-checkpoint.sh {sessionId} {chapter}

5. IF No/Questions: Revise and re-ask
```

---

## Phase 2: UI Architecture

### Step 2.1: Dispatch

```
Bash: scripts/core/phase-dispatcher.sh {sessionId} ui
→ Returns: DISPATCH:stitch-controller OR DISPATCH:ascii-wireframe
```

### IF STITCH Mode

```
Task(stitch-controller, sonnet):
  1. Generate ASCII wireframes
  2. Create Stitch project
  3. Convert ASCII to Hi-Fi
  4. Export HTML/CSS
  Output: 02-screens/wireframes/, 02-screens/html/
```

### IF ASCII Mode

```
1. Task(ui-architect, sonnet):
   - Generate layout-system.md and screen-list.md

2. Bash: scripts/planners/screen-planner.sh {sessionId}
   → Creates screens.json

3. FOR each batch (4 screens):
   Bash: scripts/executors/batch-runner.sh {sessionId} wireframe {batchIndex}

   Task(ui-architect, sonnet, parallel):
     - Generate wireframe-{screen}.md
     - Include full layout (Header, Sidebar, etc.)
```

### Step 2.2: Component Discovery

```
Task(component-auditor, haiku):
  Output: 03-components/inventory.md, gap-analysis.md

AskUserQuestion: "UI Architecture complete. Continue?"
```

---

## Phase 3: Component Specification

```
Bash: scripts/planners/component-planner.sh {sessionId}

Task(component-builder, sonnet, parallel):
  Output: 03-components/new/spec-{component}.md

Task(component-migrator, sonnet):
  Output: 03-components/migrations/migration-plan.md

AskUserQuestion: "Components complete. Continue?"
```

---

## Phase 4: Critical Review

```
Task(critical-reviewer, opus):
  Output: 04-review/scenarios/, ia-review.md, exceptions/

Task(ambiguity-detector, opus):
  Output: 04-review/ambiguities.md

Bash: scripts/core/phase-dispatcher.sh {sessionId} ambiguity
→ IF must-resolve: AskUserQuestion for resolution
```

---

## Phase 5: Test Specification

```
Task(persona-architect, sonnet):
  Output: 05-tests/personas/

Task(test-spec-writer, sonnet):
  Output: 05-tests/scenarios/, components/, coverage-map.md

AskUserQuestion: "Tests complete. Continue?"
```

---

## Phase 6: Final Assembly

```
Task(spec-assembler, haiku):
  Output: 06-final/final-spec.md, dev-tasks.md, SPEC-SUMMARY.md

AskUserQuestion: "Spec complete. Handle tmp folder?"
Options: [Archive, Keep, Delete]

Bash: scripts/core/status-update.sh {sessionId} complete
```

---

## Output Structure

```
tmp/{sessionId}/
├── _meta.json, _status.json
├── 00-requirements/
├── 01-chapters/decisions/, alternatives/
├── 02-screens/wireframes/, layouts/, [html/, assets/]
├── 03-components/new/, migrations/
├── 04-review/scenarios/, exceptions/
├── 05-tests/personas/, scenarios/
└── 06-final/
```

---

## Agents

| Agent | Model | Purpose |
|-------|-------|---------|
| design-interviewer | opus | Chapter Q&A |
| ui-architect | sonnet | Wireframes |
| stitch-controller | sonnet | Stitch workflow |
| component-auditor | haiku | Component scan |
| component-builder | sonnet | Component spec |
| component-migrator | sonnet | Migration plan |
| critical-reviewer | opus | Scenario/IA review |
| ambiguity-detector | opus | Find ambiguities |
| persona-architect | sonnet | Persona definition |
| test-spec-writer | sonnet | Test specs |
| spec-assembler | haiku | Final assembly |

---

## Resume

```
/frontend-skills:spec-it --resume {sessionId}
```

State saved in `_meta.json` after each step.
