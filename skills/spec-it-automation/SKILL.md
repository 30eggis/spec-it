---
name: spec-it-automation
description: "Frontend specification generator (Full Auto mode). Multi-agent parallel validation with single final approval. Use for large projects requiring fast, comprehensive specification generation."
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
---

# spec-it-automation: Frontend Specification Generator (Full Auto Mode)

Transform vibe-coding/PRD into production-ready frontend specifications with **maximum automation** and **minimal user intervention**.

## Mode Characteristics

- **Parallel processing**: Chapters processed concurrently
- **Multi-agent validation**: Automatic quality gates
- **User approval**: Only when ambiguities found + final approval
- **User questions**: Minimal (1-2 times)

## Workflow

```
[Draft Chapters]
      ↓
[Divergent Thinker] → [Chapter Critic x3] → [Chapter Planner]
      ↓ (Parallel)
┌─────┴─────┬─────────────┬─────────────┐
▼           ▼             ▼             ▼
[CH-00~02]  [CH-03~04]    [CH-05~06]    [CH-07]
      ↓           ↓             ↓           ↓
      └─────┬─────┴─────────────┴───────────┘
            ▼
    [Critical Review - Parallel]
    ┌───────┼───────┬───────┐
    ▼       ▼       ▼       ▼
  [IA]  [Scenario] [Exception] [Ambiguity]
            ↓
    [Ambiguity Detected?]
            │
    ┌───────┴───────┐
    ▼               ▼
  [None]      ★ USER QUESTION: ambiguous items only
    │               │
    └───────┬───────┘
            ▼
    [Test Spec Generation - Parallel]
            ▼
    [Final Assembly]
            ▼
    ★ FINAL APPROVAL: "Specification complete. Confirm?"
```

## Agents Used

### Phase 1: Design Brainstorming (Sequential)
- `design-interviewer` (opus) - Initial analysis
- `divergent-thinker` (sonnet) - Alternative exploration
- `chapter-critic` (opus) - 3-round validation
- `chapter-planner` (opus) - Final structure

### Phase 2: UI Architecture (Parallel with Phase 3 start)
- `ui-architect` (sonnet) - Wireframe design

### Phase 3: Component Discovery (Parallel)
- `component-auditor` (haiku) - Scan components
- `component-builder` (sonnet) - New specs
- `component-migrator` (sonnet) - Migration

### Phase 4: Critical Review (All Parallel)
- `critical-reviewer` (opus) - Reviews
- `ambiguity-detector` (opus) - Find gaps

### Phase 5: Test Specification (Parallel)
- `persona-architect` (sonnet) - Personas
- `test-spec-writer` (sonnet) - Test specs

### Phase 6: Final Assembly
- `spec-assembler` (haiku) - Combine all

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

### Step 1: Input Analysis + Chapter Planning

Run sequentially (dependencies):

```
1. design-interviewer → requirements.md
2. divergent-thinker → alternatives.md
3. chapter-critic (x3) → critique-*.md
4. chapter-planner → chapter-plan-final.md
```

### Step 2: Parallel Chapter Generation

Start parallel processing after 2+ chapter decisions confirmed:

```
Launch parallel agents via Task tool:
- Agent 1: CH-00, CH-01, CH-02 (Basic structure)
- Agent 2: CH-03, CH-04 (Features)
- Agent 3: CH-05, CH-06 (Additional)
- Agent 4: CH-07+ (Non-functional)
```

Each agent uses:
- `design-interviewer` for chapter content
- `ui-architect` for wireframes
- `component-auditor` → `component-builder` for components

### Step 3: Parallel Critical Review

```
Launch all review agents in parallel:
Task 1: critical-reviewer → scenarios/, ia-review.md, exceptions/
Task 2: ambiguity-detector → ambiguities.md
```

### Step 4: Ambiguity Resolution (Conditional)

**If ambiguities.md contains "Must Resolve" items:**
```
Present to user:
"The following items need clarification:
1. [AMB-001] Password policy: A) 8+ chars B) 10+ chars with special
2. [AMB-002] Session timeout: A) 30min B) 24h C) Remember me option

Please select options for each."
```

**If no critical ambiguities:**
Continue automatically.

### Step 5: Parallel Test Specification

```
Launch in parallel:
Task 1: persona-architect → personas/
Task 2: test-spec-writer → tests/scenarios/, tests/components/

After both complete:
Generate coverage-map.md
```

### Step 6: Final Assembly

```
Delegate to: spec-assembler
Output:
- final-spec.md
- dev-tasks.md
```

### Step 7: Final Approval

```
Present to user:
"Specification generation complete.

Summary:
- Chapters: N
- Screens: N
- Components: N (new: N)
- Test cases: N
- Coverage: N%

How would you like to handle working files?
[Archive to archive/] [Delete] [Keep in tmp/]"
```

## Parallel Orchestration Pattern

Use the Task tool with `run_in_background: true` for parallel execution:

```
// Example: Parallel chapter generation
Task 1: {subagent_type: "general-purpose", prompt: "Generate CH-00~02...", run_in_background: true}
Task 2: {subagent_type: "general-purpose", prompt: "Generate CH-03~04...", run_in_background: true}
Task 3: {subagent_type: "general-purpose", prompt: "Generate CH-05~06...", run_in_background: true}

// Wait for all to complete, then proceed
```

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
│   ├── screen-list.md
│   └── wireframes/
├── 03-components/
│   ├── inventory.md
│   ├── gap-analysis.md
│   ├── new/
│   └── migrations/
├── 04-review/
│   ├── scenarios/
│   ├── ia-review.md
│   ├── exceptions/
│   └── ambiguities.md
├── 05-tests/
│   ├── personas/
│   ├── scenarios/
│   ├── components/
│   └── coverage-map.md
└── 06-final/
    ├── final-spec.md
    └── dev-tasks.md
```

## Performance Optimization

### Parallel Execution Points

| Phase | Parallel Tasks | Est. Speedup |
|-------|---------------|--------------|
| Chapter Generation | 4 agents | ~3x |
| Critical Review | 2 agents | ~2x |
| Test Specification | 2 agents | ~2x |

### Model Selection Strategy

| Complexity | Model | Use Case |
|------------|-------|----------|
| High | opus | Critical thinking, ambiguity detection |
| Medium | sonnet | Design, specification writing |
| Low | haiku | Scanning, assembly, maintenance |

## Related Skills

- `/frontend-skills:spec-it` - Manual mode (all chapter approvals)
- `/frontend-skills:spec-it-complex` - Hybrid mode (milestone approvals)
- `/frontend-skills:init-spec-md` - Generate SPEC-IT files for existing code
