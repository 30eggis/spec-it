---
description: "Frontend specification generation (Hybrid) - Auto-validation + major milestone approval"
aliases: [sic, spec-complex]
---

# spec-it-complex (Hybrid Mode)

Generates frontend development specifications. Auto-validation with user approval only at major milestones.

## Input

{{ARGUMENTS}}

## Workflow

### Phase 0: Input Analysis

```
Task(
  subagent_type="frontend-skills:design-interviewer",
  model="opus",
  prompt="INPUT ANALYSIS - {{ARGUMENTS}}"
)
```

### Phase 1: Design Brainstorming with Validation

**Hybrid Mode Features:**
- Multi-agent validation (divergent-thinker, chapter-critic, chapter-planner)
- Approval only at major milestones (~4 times)

#### Step 1: Chapter Draft
```
Task(
  subagent_type="frontend-skills:design-interviewer",
  model="opus",
  prompt="Draft chapters based on requirements"
)
```

#### Step 2: Divergent Thinking
```
Task(
  subagent_type="frontend-skills:divergent-thinker",
  model="sonnet",
  prompt="Provide alternatives through divergent thinking"
)
```

#### Step 3: Critical Thinking (3 rounds)
```
Task(
  subagent_type="frontend-skills:chapter-critic",
  model="opus",
  prompt="Round 1: Logical consistency verification"
)
Task(
  subagent_type="frontend-skills:chapter-critic",
  model="opus",
  prompt="Round 2: Feasibility verification"
)
Task(
  subagent_type="frontend-skills:chapter-critic",
  model="opus",
  prompt="Round 3: Frontend-specific verification"
)
```

#### Step 4: Planning
```
Task(
  subagent_type="frontend-skills:chapter-planner",
  model="opus",
  prompt="Finalize chapter structure"
)
```

#### Milestone 1: Chapter Structure Approval
"Proceed with N chapters?" [Yes] [Modify]

### Phase 2: UI Architecture (Auto)

```
Task(
  subagent_type="frontend-skills:ui-architect",
  model="sonnet",
  prompt="Generate screen structure and ASCII wireframes"
)
```

#### Milestone 2: Basic Structure Approval
"Basic structure is finalized. Is this correct?"

### Phase 3-4: Component & Review (Auto)

#### Milestone 3: Feature Definition Approval
"Feature definitions are complete. Is this correct?"

### Phase 5-6: Test Spec & Assembly (Auto)

#### Milestone 4: Final Approval

## Approval Points Summary

| Milestone | Timing | Question |
|-----------|--------|----------|
| 1 | Phase 1 Complete | Chapter structure approval |
| 2 | Phase 2 Complete | Basic structure approval |
| 3 | Phase 4 Complete | Feature definition approval |
| 4 | Phase 6 Complete | Final approval |

## Output Location

```
tmp/{session-id}/
├── _meta.json
├── 00-requirements/
├── 01-chapters/
│   ├── alternatives.md
│   ├── critique-*.md
│   └── chapter-plan-final.md
├── 02-screens/
├── 03-components/
├── 04-review/
├── 05-tests/
└── 06-final/
```
