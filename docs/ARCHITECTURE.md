# Architecture

## Overview

### Trigger → Orchestration → Execution

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              USER INTENT                                     │
│  "자동으로 스펙 만들어줘" or "/spec-it-automation"                            │
└─────────────────────────────────┬───────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SKILL (Entry Point)                                  │
│  spec-it-automation/SKILL.md                                                 │
│  • Semantic match OR explicit /slash-command                                │
│  • Contains orchestration logic                                              │
│  • Coordinates agents via Task tool                                          │
└─────────────────────────────────┬───────────────────────────────────────────┘
                                  │
        ┌─────────────────────────┼─────────────────────────┐
        │                         │                         │
        ▼                         ▼                         ▼
┌───────────────┐       ┌───────────────┐       ┌───────────────┐
│   AGENT       │       │   AGENT       │       │   AGENT       │
│ (context:fork)│       │ (context:fork)│       │ (context:fork)│
│               │       │               │       │               │
│ Isolated      │       │ Parallel      │       │ Sequential    │
│ execution     │       │ execution     │       │ execution     │
└───────────────┘       └───────────────┘       └───────────────┘
```

### Key Principles

| Layer | Role | Trigger Method |
|-------|------|----------------|
| **Skill** | User-facing entry point | User message (semantic/explicit) |
| **Orchestrator** | Control flow, coordination | Skill contains orchestration logic |
| **Agent** | Isolated worker execution | Explicit `Task` tool call only |

> **Important**: Skills are triggered by **user messages only**. Agent output does NOT trigger skills.

---

## spec-it-automation: Full Workflow

```
╔═══════════════════════════════════════════════════════════════════════════════╗
║                           SPEC-IT-AUTOMATION WORKFLOW                          ║
║                              (Full Auto Mode)                                  ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║                                                                               ║
║  ┌─────────────────────────────────────────────────────────────────────────┐  ║
║  │ PHASE 0: INITIALIZATION                                                 │  ║
║  │                                                                         │  ║
║  │   User Input ──▶ [UI Mode Selection] ──▶ session-init.sh               │  ║
║  │                   • YAML/JSON Wireframe                                 │  ║
║  │                   • Google Stitch                                       │  ║
║  │                                                                         │  ║
║  │   IF --resume: Load _meta.json → GOTO saved checkpoint                 │  ║
║  └─────────────────────────────────────────────────────────────────────────┘  ║
║                                      │                                        ║
║                                      ▼                                        ║
║  ┌─────────────────────────────────────────────────────────────────────────┐  ║
║  │ PHASE 1: DESIGN BRAINSTORMING (Auto)                          [0-16%]  │  ║
║  │                                                                         │  ║
║  │   ┌──────────────────────┐                                             │  ║
║  │   │  design-interviewer  │ ──▶ 00-requirements/requirements.md         │  ║
║  │   │       (Opus)         │                                             │  ║
║  │   └──────────────────────┘                                             │  ║
║  │              │                                                          │  ║
║  │              ▼                                                          │  ║
║  │   ┌──────────────────────┐                                             │  ║
║  │   │  divergent-thinker   │ ──▶ 01-chapters/alternatives/*.md           │  ║
║  │   │      (Sonnet)        │                                             │  ║
║  │   └──────────────────────┘                                             │  ║
║  │              │                                                          │  ║
║  │              ▼                                                          │  ║
║  │   ┌────────────────┬────────────────┬────────────────┐                 │  ║
║  │   │  critic-logic  │critic-feasibil.│ critic-frontend│  ◀── PARALLEL  │  ║
║  │   │   (Sonnet)     │   (Sonnet)     │    (Sonnet)    │                 │  ║
║  │   └───────┬────────┴───────┬────────┴───────┬────────┘                 │  ║
║  │           └────────────────┼────────────────┘                          │  ║
║  │                            ▼                                            │  ║
║  │               ┌──────────────────────┐                                 │  ║
║  │               │   critic-moderator   │ ──▶ critique-final.md           │  ║
║  │               │       (Opus)         │     (Synthesize & Resolve)      │  ║
║  │               └──────────────────────┘                                 │  ║
║  │                            │                                            │  ║
║  │                            ▼                                            │  ║
║  │               ┌──────────────────────┐                                 │  ║
║  │               │   chapter-planner    │ ──▶ chapter-plan-final.md       │  ║
║  │               │       (Opus)         │                                 │  ║
║  │               └──────────────────────┘                                 │  ║
║  └─────────────────────────────────────────────────────────────────────────┘  ║
║                                      │                                        ║
║                                      ▼                                        ║
║  ┌─────────────────────────────────────────────────────────────────────────┐  ║
║  │ PHASE 2: UI + COMPONENTS (Auto)                               [17-33%] │  ║
║  │                                                                         │  ║
║  │   phase-dispatcher.sh ──▶ DISPATCH:stitch OR DISPATCH:yaml             │  ║
║  │                                                                         │  ║
║  │   ┌─────────────────────────┐    ┌─────────────────────────┐           │  ║
║  │   │    IF STITCH MODE       │    │    IF YAML MODE         │           │  ║
║  │   │                         │    │                         │           │  ║
║  │   │  1. ui-architect        │    │  ui-architect           │           │  ║
║  │   │     → wireframes/       │    │    (Sonnet)             │           │  ║
║  │   │                         │    │                         │           │  ║
║  │   │  2. /stitch-convert     │    │  screen-list.md         │           │  ║
║  │   │     (Skill)             │    │       │                 │           │  ║
║  │   │     → MCP 도구 호출     │    │       ▼                 │           │  ║
║  │   │     → html/ 생성        │    │  ┌─────┬─────┬─────┐   │           │  ║
║  │   │                         │    │  │ W-1 │ W-2 │ W-3 │...│ PARALLEL  │  ║
║  │   │                         │    │  └─────┴─────┴─────┘   │ (batch 4) │  ║
║  │   │  Output:                │    │                         │           │  ║
║  │   │  - wireframes/          │    │  Output:                │           │  ║
║  │   │  - html/                │    │  - wireframes/*.yaml    │           │  ║
║  │   │  - assets/              │    │                         │           │  ║
║  │   └─────────────────────────┘    └─────────────────────────┘           │  ║
║  │                                                                         │  ║
║  │              ┌──────────────────────┬──────────────────────┐           │  ║
║  │              │  component-auditor   │  component-builder   │ PARALLEL  │  ║
║  │              │      (Haiku)         │     (Sonnet)         │           │  ║
║  │              │                      │                      │           │  ║
║  │              │  inventory.md        │  new/spec-*.md       │           │  ║
║  │              │  gap-analysis.md     │                      │           │  ║
║  │              └──────────────────────┴──────────────────────┘           │  ║
║  │                                      │                                  │  ║
║  │                                      ▼                                  │  ║
║  │              ┌──────────────────────┐                                  │  ║
║  │              │  component-migrator  │ ──▶ migrations/migration-plan.md │  ║
║  │              │      (Sonnet)        │                                  │  ║
║  │              └──────────────────────┘                                  │  ║
║  └─────────────────────────────────────────────────────────────────────────┘  ║
║                                      │                                        ║
║                                      ▼                                        ║
║  ┌─────────────────────────────────────────────────────────────────────────┐  ║
║  │ PHASE 3: CRITICAL REVIEW (Auto)                               [34-50%] │  ║
║  │                                                                         │  ║
║  │   ┌──────────────────────┬──────────────────────┐                      │  ║
║  │   │   critical-reviewer  │  ambiguity-detector  │  ◀── PARALLEL       │  ║
║  │   │       (Opus)         │       (Opus)         │                      │  ║
║  │   │                      │                      │                      │  ║
║  │   │  - scenarios/        │  - ambiguities.md    │                      │  ║
║  │   │  - ia-review.md      │                      │                      │  ║
║  │   │  - exceptions/       │                      │                      │  ║
║  │   └──────────────────────┴──────────────────────┘                      │  ║
║  │                            │                                            │  ║
║  │                            ▼                                            │  ║
║  │   ┌─────────────────────────────────────────────────────────────────┐  │  ║
║  │   │  phase-dispatcher.sh → DISPATCH:user-question?                  │  │  ║
║  │   │                                                                 │  │  ║
║  │   │  IF "Must Resolve" ambiguities exist:                          │  │  ║
║  │   │     AskUserQuestion: "Resolve these ambiguities"                │  │  ║
║  │   │  ELSE: Auto-proceed                                            │  │  ║
║  │   └─────────────────────────────────────────────────────────────────┘  │  ║
║  └─────────────────────────────────────────────────────────────────────────┘  ║
║                                      │                                        ║
║                                      ▼                                        ║
║  ┌─────────────────────────────────────────────────────────────────────────┐  ║
║  │ PHASE 4: TEST SPECIFICATION (Auto)                            [51-66%] │  ║
║  │                                                                         │  ║
║  │   ┌──────────────────────┬──────────────────────┐                      │  ║
║  │   │  persona-architect   │   test-spec-writer   │  ◀── PARALLEL       │  ║
║  │   │      (Sonnet)        │      (Sonnet)        │                      │  ║
║  │   │                      │                      │                      │  ║
║  │   │  05-tests/personas/  │  - scenarios/        │                      │  ║
║  │   │                      │  - components/       │                      │  ║
║  │   │                      │  - coverage-map.md   │                      │  ║
║  │   └──────────────────────┴──────────────────────┘                      │  ║
║  └─────────────────────────────────────────────────────────────────────────┘  ║
║                                      │                                        ║
║                                      ▼                                        ║
║  ┌─────────────────────────────────────────────────────────────────────────┐  ║
║  │ PHASE 5: FINAL ASSEMBLY (Auto)                                [67-83%] │  ║
║  │                                                                         │  ║
║  │               ┌──────────────────────┐                                 │  ║
║  │               │    spec-assembler    │                                 │  ║
║  │               │       (Haiku)        │                                 │  ║
║  │               │                      │                                 │  ║
║  │               │  Output:             │                                 │  ║
║  │               │  - final-spec.md     │                                 │  ║
║  │               │  - dev-tasks.md      │                                 │  ║
║  │               │  - SPEC-SUMMARY.md   │                                 │  ║
║  │               └──────────────────────┘                                 │  ║
║  └─────────────────────────────────────────────────────────────────────────┘  ║
║                                      │                                        ║
║                                      ▼                                        ║
║  ┌─────────────────────────────────────────────────────────────────────────┐  ║
║  │ PHASE 6: FINAL APPROVAL                                       [84-100%]│  ║
║  │                                                                         │  ║
║  │   "Spec complete. Handle tmp folder?"                                  │  ║
║  │   Options: [Archive] [Keep] [Delete]                                   │  ║
║  │                                                                         │  ║
║  │   ✅ COMPLETE                                                          │  ║
║  └─────────────────────────────────────────────────────────────────────────┘  ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
```

---

## Agent Execution Patterns

### Sequential vs Parallel

```
Sequential (dependency chain)          Parallel (independent tasks)
─────────────────────────────          ─────────────────────────────

    ┌───────────┐                      ┌───────────┬───────────┬───────────┐
    │  Agent A  │                      │  Agent A  │  Agent B  │  Agent C  │
    └─────┬─────┘                      └─────┬─────┴─────┬─────┴─────┬─────┘
          │                                  │           │           │
          ▼                                  └───────────┼───────────┘
    ┌───────────┐                                        │
    │  Agent B  │  ◀── B needs A's output                ▼
    └─────┬─────┘                               ┌───────────────┐
          │                                     │   Synthesize  │
          ▼                                     └───────────────┘
    ┌───────────┐
    │  Agent C  │
    └───────────┘
```

### Multi-Critic Debate Pattern

```
    ┌────────────────┬────────────────┬────────────────┐
    │  critic-logic  │critic-feasibil.│ critic-frontend│  ◀── PARALLEL
    │    (Sonnet)    │    (Sonnet)    │    (Sonnet)    │      3 perspectives
    └───────┬────────┴───────┬────────┴───────┬────────┘
            │                │                │
            │   critique-    │   critique-    │   critique-
            │   logic.md     │   feasib.md    │   frontend.md
            │                │                │
            └────────────────┼────────────────┘
                             │
                             ▼
                  ┌──────────────────────┐
                  │   critic-moderator   │  ◀── SEQUENTIAL
                  │       (Opus)         │      Synthesize + Resolve
                  │                      │
                  │   critique-final.md  │
                  └──────────────────────┘
```

---

## Model Routing Strategy

```
┌─────────────────────────────────────────────────────────────────────┐
│                        MODEL SELECTION                               │
├─────────────┬───────────┬───────────────────────────────────────────┤
│ Complexity  │   Model   │  Use Cases                                │
├─────────────┼───────────┼───────────────────────────────────────────┤
│    LOW      │   Haiku   │  File scans, status checks, assembly      │
│             │           │  • component-auditor                       │
│             │           │  • spec-assembler                          │
│             │           │  • spec-md-generator                       │
├─────────────┼───────────┼───────────────────────────────────────────┤
│   MEDIUM    │  Sonnet   │  Standard implementation, UI design       │
│             │           │  • ui-architect                            │
│             │           │  • critic-logic/feasibility/frontend       │
│             │           │  • component-builder                       │
│             │           │  • test-spec-writer                        │
├─────────────┼───────────┼───────────────────────────────────────────┤
│    HIGH     │   Opus    │  Complex reasoning, decision-making       │
│             │           │  • design-interviewer                      │
│             │           │  • critic-moderator                        │
│             │           │  • critical-reviewer                       │
│             │           │  • spec-executor                           │
└─────────────┴───────────┴───────────────────────────────────────────┘
```

---

## Output Directory Structure

### Session State (per session)
```
.spec-it/{sessionId}/
├── plan/
│   ├── _meta.json             ◀── Checkpoint state (phase, step, canResume)
│   └── _status.json           ◀── Runtime stats (agents, files, duration)
├── execute/
│   ├── _meta.json             ◀── Execute mode state
│   └── _status.json           ◀── Execute runtime stats
├── runtime-log.md             ◀── Shared runtime log
└── logs/                      ◀── Agent execution logs (silent mode)
```

### Document Artifacts (shared)
```
tmp/
├── 00-requirements/
│   └── requirements.md
│
├── 01-chapters/
│   ├── alternatives/          ◀── Divergent thinking output
│   ├── decisions/
│   ├── critique-logic.md
│   ├── critique-feasibility.md
│   ├── critique-frontend.md
│   ├── critique-final.md      ◀── Moderator synthesis
│   └── chapter-plan-final.md
│
├── 02-wireframes/
│   ├── screen-list.md
│   ├── layouts/
│   ├── wireframes/            ◀── YAML/JSON wireframes
│   ├── html/                  ◀── Stitch HTML export
│   └── assets/                ◀── Stitch assets
│
├── 03-components/
│   ├── inventory.md
│   ├── gap-analysis.md
│   ├── new/                   ◀── New component specs
│   └── migrations/            ◀── Migration plans
│
├── 04-review/
│   ├── scenarios/
│   ├── ia-review.md
│   ├── exceptions/
│   ├── ambiguities.md
│   └── ambiguities-resolved.md
│
├── 05-tests/
│   ├── personas/
│   ├── scenarios/
│   ├── components/
│   └── coverage-map.md
│
└── 06-final/
    ├── final-spec.md          ◀── Complete specification
    ├── dev-tasks.md           ◀── Implementation task list
    └── SPEC-SUMMARY.md        ◀── Executive summary
```
