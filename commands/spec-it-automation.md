---
description: "Frontend specification generation (Full Auto) - Multi-agent validation, minimal user intervention"
aliases: [sia, spec-auto]
---

# spec-it-automation (Full Auto Mode)

Generates frontend development specifications fully automatically. Only asks questions when ambiguity is found, single final approval.

## Input

{{ARGUMENTS}}

## Workflow

### Phase 0-1: Analysis & Brainstorming (Parallel Validation)

```
// Parallel execution
Task(subagent_type="frontend-skills:design-interviewer", ...)
Task(subagent_type="frontend-skills:divergent-thinker", ...)
```

```
// Sequential execution (dependencies)
Task(subagent_type="frontend-skills:chapter-critic", prompt="Round 1-3")
Task(subagent_type="frontend-skills:chapter-planner", ...)
```

### Phase 2-3: UI & Components (Parallel)

```
// Parallel execution
Task(subagent_type="frontend-skills:ui-architect", ...)
Task(subagent_type="frontend-skills:component-auditor", ...)
```

### Phase 4: Critical Review (Parallel)

```
// 4 parallel executions
Task(subagent_type="frontend-skills:critical-reviewer", prompt="IA Review")
Task(subagent_type="frontend-skills:critical-reviewer", prompt="Scenario Review")
Task(subagent_type="frontend-skills:critical-reviewer", prompt="Exception Review")
Task(subagent_type="frontend-skills:ambiguity-detector", ...)
```

### Questions on Ambiguity Detection

When ambiguity-detector finds unclear parts, user is asked:

```
Ambiguous items found:

1. AMB-001: Password Policy
   - A) 8+ characters, alphanumeric
   - B) 10+ characters, alphanumeric + special chars

2. AMB-002: Session Duration
   - A) 30 minutes
   - B) 24 hours
   - C) Remember me option

Please select.
```

### Phase 5: Test Specification (Parallel)

```
// Parallel execution
Task(subagent_type="frontend-skills:persona-architect", ...)
Task(subagent_type="frontend-skills:test-spec-writer", prompt="Component Tests")
Task(subagent_type="frontend-skills:test-spec-writer", prompt="Scenario Tests")
```

### Phase 6: Final Assembly

```
Task(subagent_type="frontend-skills:spec-assembler", ...)
```

### Final Approval

```
Specification generation complete.

Summary:
- Chapters: 8
- Screens: 12
- Components: 5 new, 23 existing
- Test Scenarios: 45
- Coverage: 95%

Confirm? [Approve] [Review Details]
```

## Parallel Processing Diagram

```
[Draft Chapters]
      ↓
[Divergent] → [Critic x3] → [Planner]
      ↓ (parallel)
┌─────┴─────┬─────────────┐
▼           ▼             ▼
[CH-00~02]  [CH-03~04]    [CH-05~07]
      ↓           ↓             ↓
      └─────┬─────┴─────────────┘
            ▼
    [Critical Review - Parallel]
    ┌───────┼───────┬───────┐
    ▼       ▼       ▼       ▼
  [IA]  [Scenario] [Exc]  [Ambiguity]
            ↓
    [Ambiguity?] → User question (only if needed)
            ↓
    [Test Spec - Parallel]
            ↓
    [Assembly]
            ↓
    ★ Final Approval
```

## Output Location

```
tmp/{session-id}/
├── _meta.json (status: automation)
├── 00-requirements/
├── 01-chapters/
├── 02-screens/
├── 03-components/
├── 04-review/
├── 05-tests/
└── 06-final/
    ├── final-spec.md
    └── dev-tasks.md
```

## Rules

- Minimize user intervention
- Only ask questions when ambiguity is found
- All validations performed automatically by agents
- Single final approval
