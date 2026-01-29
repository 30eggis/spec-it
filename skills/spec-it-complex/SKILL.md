---
name: spec-it-complex
description: "Frontend specification generator (Hybrid mode). Auto validation + major milestone approvals. Use for medium-sized projects requiring balance between automation and control."
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
---

# spec-it-complex: Frontend Specification Generator (Hybrid Mode)

Transform vibe-coding/PRD into production-ready frontend specifications with **automatic validation** and **major milestone approvals**.

## Mode Characteristics

- **Auto-validation**: Divergent thinking + 3-round critical review
- **User approval**: At 4 major milestones only
- **User questions**: Moderate (4-5 times)

## Workflow

```
[Draft Chapters]
      ↓
[Divergent Thinker] → alternatives.md
      ↓
[Chapter Critic x3] → critiques/*.md
      ↓
[Chapter Planner] → chapter-plan.md
      ↓
★ USER APPROVAL 1: "Proceed with N chapters?" [Yes/Modify]
      ↓
[CH-00~02: Auto] → Basic structure
      ↓
★ USER APPROVAL 2: "Basic structure confirmed?"
      ↓
[CH-03~04: Auto] → Feature chapters
      ↓
★ USER APPROVAL 3: "Feature definitions confirmed?"
      ↓
[CH-05~07: Auto] → Remaining chapters
      ↓
[Critical Review - Parallel]
├── [IA Review]
├── [Scenario Review]
├── [Exception Review]
└── [Ambiguity Detection] → User questions if found
      ↓
[Test Spec Generation]
      ↓
★ USER APPROVAL 4: Final approval
```

## Agents Used

### Phase 1: Design Brainstorming
- `design-interviewer` (opus) - Requirements gathering
- `divergent-thinker` (sonnet) - Alternative exploration
- `chapter-critic` (opus) - 3-round validation
- `chapter-planner` (opus) - Final structure

### Phase 2: UI Architecture
- `ui-architect` (sonnet) - Wireframe design

### Phase 3: Component Discovery
- `component-auditor` (haiku) - Scan existing components
- `component-builder` (sonnet) - New component specs
- `component-migrator` (sonnet) - Migration plans

### Phase 4: Critical Review
- `critical-reviewer` (opus) - Scenario/IA/Exception review
- `ambiguity-detector` (opus) - Find unclear requirements

### Phase 5: Test Specification
- `persona-architect` (sonnet) - Persona definition
- `test-spec-writer` (sonnet) - Test specs

### Phase 6: Final Assembly
- `spec-assembler` (haiku) - Combine outputs

## Shared Resources

All resources are shared with the main spec-it skill:

- **Templates**: [../spec-it/assets/templates/](../spec-it/assets/templates/)
- **References**: [../spec-it/references/](../spec-it/references/)
- **Output folder**: `../spec-it/tmp/{session-id}/`

## Tech Stack

- **Framework**: Next.js (App Router)
- **UI Library**: React + shadcn/ui
- **Styling**: Tailwind CSS
- **Best Practices**: Vercel React Best Practices

## Execution Instructions

### Step 1: Input Analysis

Read and analyze the provided PRD or vibe-coding input.

```
Delegate to: design-interviewer
Output: tmp/{session-id}/00-requirements/requirements.md
```

### Step 2: Chapter Planning with Validation

1. Generate draft chapters
2. Run divergent thinking validation:
   ```
   Delegate to: divergent-thinker
   Output: tmp/{session-id}/01-chapters/alternatives.md
   ```
3. Run 3-round critical review:
   ```
   Delegate to: chapter-critic (3 times)
   Output: tmp/{session-id}/01-chapters/critique-*.md
   ```
4. Finalize chapter structure:
   ```
   Delegate to: chapter-planner
   Output: tmp/{session-id}/01-chapters/chapter-plan-final.md
   ```

### Step 3: USER APPROVAL (Milestone 1)

Present chapter plan and ask:
> "Total N chapters planned. Proceed? [Yes] [Modify]"

### Step 4: Generate Chapters (Auto)

Process chapters in batches:
- Batch 1 (CH-00~02): Basic structure → **USER APPROVAL 2**
- Batch 2 (CH-03~04): Features → **USER APPROVAL 3**
- Batch 3 (CH-05+): Remaining

### Step 5: Critical Review (Parallel)

```
Run in parallel:
- critical-reviewer → scenarios/, ia-review.md, exceptions/
- ambiguity-detector → ambiguities.md
```

If ambiguities found, ask user for clarification.

### Step 6: Test Specification

```
Delegate to: persona-architect → personas/
Delegate to: test-spec-writer → tests/, coverage-map.md
```

### Step 7: Final Assembly

```
Delegate to: spec-assembler
Output: tmp/{session-id}/06-final/
```

### Step 8: USER APPROVAL (Final)

Present final specification and ask about tmp folder:
> "Specification complete. How to handle working files?"
> [Archive] [Delete] [Keep]

## Output Structure

```
tmp/{session-id}/
├── _meta.json
├── 00-requirements/
├── 01-chapters/
│   ├── alternatives.md
│   ├── critique-*.md
│   ├── chapter-plan-final.md
│   └── decisions/
├── 02-screens/
├── 03-components/
├── 04-review/
├── 05-tests/
└── 06-final/
```

## Related Skills

- `/frontend-skills:spec-it` - Manual mode (all chapter approvals)
- `/frontend-skills:spec-it-automation` - Full auto mode
- `/frontend-skills:init-spec-md` - Generate SPEC-IT files for existing code
