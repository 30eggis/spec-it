---
description: "Frontend specification generation (Manual mode) - Chapter-by-chapter user approval"
aliases: [si, spec]
---

# spec-it (Manual Mode)

Generates frontend development specifications. Requires user approval at every chapter.

## Input

{{ARGUMENTS}}

## Session Initialization

```
Session ID: {project-name}-{YYYYMMDD}-{HHMMSS}
Output Location: skills/spec-it/tmp/{session-id}/
```

## Workflow

### Phase 0: Input Analysis

Analyzes user input to extract requirements.

```
Task(
  subagent_type="frontend-skills:design-interviewer",
  model="opus",
  prompt="INPUT ANALYSIS

User Input: {{ARGUMENTS}}

1. Determine input type (vibe-coding / PRD / other)
2. Extract core requirements
3. Identify technical constraints
4. Generate initial requirements document

Output: tmp/{session-id}/00-requirements/requirements.md"
)
```

### Phase 1: Design Brainstorming

Establishes chapter structure and gets user approval for each chapter.

**Manual Mode Features:**
- User approval requested at every chapter
- "Is this chapter content correct?" [Yes] [No] [Questions]
- No validation agents (direct user conversation)

```
Task(
  subagent_type="frontend-skills:design-interviewer",
  model="opus",
  prompt="CHAPTER BRAINSTORMING

For each chapter:
1. Ask questions in 200-300 character chunks
2. Prefer multiple-choice questions
3. Proceed to next question after user response
4. Present summary and request approval at chapter completion

Output: tmp/{session-id}/01-chapters/decisions/*.md"
)
```

### Phase 2-6: Sequential Execution

Gets user approval after each Phase completion before proceeding to the next.

## Output Location

```
tmp/{session-id}/
├── _meta.json
├── 00-requirements/
├── 01-chapters/
├── 02-screens/
├── 03-components/
├── 04-review/
├── 05-tests/
└── 06-final/
```

## Post-Completion Handling

Ask user upon session completion:
- **Archive**: `tmp/{session-id}/` → `archive/{session-id}/`
- **Delete**: Completely delete `tmp/{session-id}/`
- **Keep**: Retain `tmp/{session-id}/`

## Rules

- One question at a time (200-300 character chunks)
- Prefer multiple-choice questions when possible
- Follow YAGNI principle - remove unnecessary features
- Document all decisions immediately
