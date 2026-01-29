---
name: spec-it
description: "Frontend specification generator (Manual mode). Transforms vibe-coding/PRD into production-ready detailed specifications with chapter-by-chapter approval. Use for: (1) Frontend specification writing, (2) Converting vibe-coding/PRD to dev specs, (3) UI/component design documents, (4) Scenario test specifications"
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, AskUserQuestion
---

# spec-it: Frontend Specification Generator (Manual Mode)

Transform vibe-coding/PRD into **production-ready frontend specifications** with **chapter-by-chapter user approval**.

## Mode Characteristics

- **Full control**: Every chapter requires user approval
- **No auto-validation**: Validation agents not used
- **User questions**: Frequent (per chapter)
- **Best for**: Small projects, learning the process, maximum control

## Commands Overview

| Command | Mode | Description |
|---------|------|-------------|
| `/frontend-skills:spec-it` | **Manual** | All chapters require user approval |
| `/frontend-skills:spec-it-complex` | Hybrid | Auto-validation + major milestone approval |
| `/frontend-skills:spec-it-automation` | Full Auto | Multi-agent validation, single final approval |
| `/frontend-skills:init-spec-md` | Utility | Create SPEC-IT files for existing code |

## Core Features

1. **Design Brainstorming**: Superpowers-style chunk-based Q&A for requirement refinement
2. **UI Architecture**: ASCII art wireframes and screen structure design
3. **Component Discovery**: Existing component scanning + gap analysis + migration
4. **Critical Review**: Rigorous scenario/IA/exception handling review
5. **Test Specification**: Persona-based scenario test specification generation
6. **SPEC-IT-{HASH}.md**: Metadata system for progressive context loading

## Workflow (Manual Mode)

```
[CH-00] → User Approval → [CH-01] → User Approval → ... → [CH-N] → User Approval
                ↓
         "Is this chapter content correct?"
         [Yes] [No] [Questions]
```

### Phase 0: Input Analysis
```
Agent: design-interviewer (opus)
Output: tmp/{session-id}/00-requirements/requirements.md
```

### Phase 1: Design Brainstorming

Chapter structure framework:
```
CH-00: Project Scope & Constraints
CH-01: User & Persona Definition
CH-02: Information Architecture
CH-03: Screen Inventory
CH-04: Feature Definition (N sub-chapters)
CH-05: Component Requirements
CH-06: State & Data Flow
CH-07: Non-Functional Requirements
```

For each chapter:
1. `design-interviewer` conducts Q&A
2. Present chapter summary to user
3. **USER APPROVAL**: "Is this content correct? [Yes] [No] [Questions]"
4. Proceed to next chapter

Output: `tmp/{session-id}/01-chapters/decisions/`

### Phase 2: UI Architecture
```
Agent: ui-architect (sonnet)
Output:
- tmp/{session-id}/02-screens/screen-list.md
- tmp/{session-id}/02-screens/wireframes/*.md
```

### Phase 3: Component Discovery & Migration
```
Agents:
- component-auditor (haiku) → inventory.md, gap-analysis.md
- component-builder (sonnet) → new/*.md
- component-migrator (sonnet) → migrations/*.md

Output: tmp/{session-id}/03-components/
```

### Phase 4: Critical Review
```
Agents:
- critical-reviewer (opus) → scenarios/, ia-review.md, exceptions/
- ambiguity-detector (opus) → ambiguities.md

Output: tmp/{session-id}/04-review/
```

### Phase 5: Persona & Scenario Test Spec
```
Agents:
- persona-architect (sonnet) → personas/
- test-spec-writer (sonnet) → scenarios/, components/, coverage-map.md

Output: tmp/{session-id}/05-tests/
```

### Phase 6: Final Assembly
```
Agent: spec-assembler (haiku)
Output: tmp/{session-id}/06-final/
```

Ask user about tmp folder handling:
- **Archive**: `tmp/` → `archive/spec-it-YYYY-MM-DD/`
- **Delete**: Remove `tmp/` completely
- **Keep**: Keep `tmp/` as is

## Agents (15 total)

### Core Agents
| Agent | Model | Role |
|-------|-------|------|
| `design-interviewer` | opus | Brainstorming Q&A |
| `divergent-thinker` | sonnet | Divergent thinking, alternatives |
| `chapter-critic` | opus | Critical validation (3 rounds) |
| `chapter-planner` | opus | Chapter structure finalization |
| `ui-architect` | sonnet | Wireframe design |

### Component Agents
| Agent | Model | Role |
|-------|-------|------|
| `component-auditor` | haiku | Component scanning |
| `component-builder` | sonnet | Component specification |
| `component-migrator` | sonnet | Component migration |

### Review Agents
| Agent | Model | Role |
|-------|-------|------|
| `critical-reviewer` | opus | Scenario/IA/Exception review |
| `ambiguity-detector` | opus | Ambiguity detection |

### Test Agents
| Agent | Model | Role |
|-------|-------|------|
| `persona-architect` | sonnet | Persona definition |
| `test-spec-writer` | sonnet | Test specification |

### Utility Agents
| Agent | Model | Role |
|-------|-------|------|
| `spec-assembler` | haiku | Final assembly |
| `spec-md-generator` | haiku | SPEC-IT file creation |
| `spec-md-maintainer` | haiku | SPEC-IT file maintenance |

## Tech Stack

- **Framework**: Next.js (App Router)
- **UI Library**: React + shadcn/ui
- **Styling**: Tailwind CSS
- **Best Practices**: Vercel React Best Practices compliance

## Output Structure

```
tmp/{session-id}/
├── _meta.json
├── 00-requirements/
│   └── requirements.md
├── 01-chapters/
│   ├── chapter-plan-final.md
│   └── decisions/
│       ├── decision-CH00-scope.md
│       ├── decision-CH01-persona.md
│       └── ...
├── 02-screens/
│   ├── screen-list.md
│   └── wireframes/
│       ├── wireframe-login.md
│       └── ...
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

## SPEC-IT-{HASH}.md System

All UI-related files include accompanying `SPEC-IT-{HASH}.md` files for progressive context loading.

- **Progressive Context Loading**: Agents load only required context
- **Bidirectional Navigation**: Parent ↔ Child document links
- **Registry Management**: All HASHes managed in `.spec-it-registry.json`

## Resources

### Templates (16 files)
Located in [assets/templates/](assets/templates/):

| Template | Phase | Purpose |
|----------|-------|---------|
| CHAPTER_PLAN_TEMPLATE.md | 1 | Chapter structure |
| SCREEN_LIST_TEMPLATE.md | 2 | Screen list |
| UI_WIREFRAME_TEMPLATE.md | 2 | ASCII wireframe |
| SCREEN_SPEC_TEMPLATE.md | 2 | Screen spec |
| COMPONENT_INVENTORY_TEMPLATE.md | 3 | Component inventory |
| COMPONENT_SPEC_TEMPLATE.md | 3 | New component spec |
| MIGRATION_REPORT_TEMPLATE.md | 3 | Migration report |
| SCENARIO_TEMPLATE.md | 4 | Scenario review |
| IA_REVIEW_TEMPLATE.md | 4 | IA review |
| EXCEPTION_TEMPLATE.md | 4 | Exception review |
| AMBIGUITY_TEMPLATE.md | 4 | Ambiguity report |
| PERSONA_TEMPLATE.md | 5 | Persona definition |
| TEST_SPEC_TEMPLATE.md | 5 | Test specification |
| COVERAGE_MAP_TEMPLATE.md | 5 | Coverage map |
| SPEC_IT_COMPONENT_TEMPLATE.md | - | SPEC-IT for components |
| SPEC_IT_PAGE_TEMPLATE.md | - | SPEC-IT for pages |

### References (3 files)
Located in [references/](references/):

- [ascii-wireframe-guide.md](references/ascii-wireframe-guide.md) - ASCII wireframe patterns
- [shadcn-component-list.md](references/shadcn-component-list.md) - shadcn/ui components
- [test-patterns.md](references/test-patterns.md) - Test pattern guide

## Hooks

Cross-platform notification hooks for permission requests:

| Hook | Event | Description |
|------|-------|-------------|
| `notify-permission.sh` | PermissionRequest | Desktop notification when Claude needs approval |
| `notify-attention.sh` | Notification | Alert when user input is needed |

**Supported Platforms**: macOS (osascript), Windows (PowerShell), Linux (notify-send)

## Related Skills

- `vercel-react-best-practices` - React patterns
- `vercel-composition-patterns` - Component composition
- `web-design-guidelines` - Accessibility, UX
- `prompt-inspector` - API binding automation

## Execution Instructions

### Getting Started

1. **Prepare Input**: Have your PRD or vibe-coding description ready
2. **Run Command**: `/frontend-skills:spec-it`
3. **Answer Questions**: Respond to each chapter's Q&A
4. **Approve Chapters**: Confirm each chapter before proceeding
5. **Review Output**: Check final specification in `tmp/{session-id}/06-final/`

### Question Style

The design-interviewer asks one question at a time:

```markdown
**Q: Who is the primary target user for this service?**

A) 20-30s professionals - Prioritize fast task completion
B) 40-50s middle-aged - Value stability and trust
C) Teenagers - Value fun and social features
D) Other (please specify)
```

### Chapter Approval Format

```markdown
## Chapter Summary: {chapter_name}

### Confirmed Items
- Item 1
- Item 2

### Next Chapter Preview
{upcoming content}

Is this content correct? [Yes] [No] [Questions]
```
