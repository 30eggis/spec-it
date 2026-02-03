# Architecture & Reference

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
        ┌─────────────────────────┼─────────────────────────────────┐
        │                         │                                 │
        ▼                         ▼                                 ▼
┌───────────────┐       ┌───────────────┐               ┌───────────────┐
│   AGENT       │       │   AGENT       │               │   AGENT       │
│ (context:fork)│       │ (context:fork)│               │ (context:fork)│
│               │       │               │               │               │
│ Isolated      │       │ Parallel      │               │ Sequential    │
│ execution     │       │ execution     │               │ execution     │
└───────────────┘       └───────────────┘               └───────────────┘
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

## Agents Reference (34 Agents)

### Design & Planning

| Agent | Model | Role |
|-------|-------|------|
| `design-interviewer` | Opus | Brainstorming Q&A facilitator, superpowers-style conversation |
| `divergent-thinker` | Sonnet | Alternative exploration, creative thinking, missing perspectives |
| `chapter-planner` | Opus | Synthesize critiques, finalize chapter structure |
| `ui-architect` | Sonnet | YAML wireframe design, bold aesthetic choices |

---

### Multi-Agent Debate (Critic System)

Three critics review in parallel, then a moderator synthesizes:

```
┌─────────────┬─────────────┬─────────────┐
│critic-logic │critic-feasi.│critic-front.│  ← Parallel
└──────┬──────┴──────┬──────┴──────┬──────┘
       └─────────────┼─────────────┘
                     ▼
             critic-moderator              ← Synthesize
```

| Agent | Model | Focus Area |
|-------|-------|------------|
| `critic-logic` | Sonnet | Logic consistency, overlaps, gaps, dependency order |
| `critic-feasibility` | Sonnet | Independent definition, clear criteria, testable deliverables |
| `critic-frontend` | Sonnet | UI/UX, component reusability, responsive/a11y |
| `critic-moderator` | Opus | Consensus, conflict resolution, final verdict |

---

### Component Agents

| Agent | Model | Role |
|-------|-------|------|
| `component-auditor` | Haiku | Scan existing components, create inventory |
| `component-builder` | Sonnet | Write new component specs with bold design choices |
| `component-migrator` | Sonnet | Plan component migrations to common folder |

---

### Review Agents

| Agent | Model | Role |
|-------|-------|------|
| `critical-reviewer` | Opus | Scenario/IA/exception comprehensive review |
| `ambiguity-detector` | Opus | Detect ambiguities, generate clarification questions |
| `spec-critic` | Opus | Validate execution plans (4 pillars: clarity, verifiability, completeness, big picture) |

---

### Spec Quality Agents

| Agent | Model | Role |
|-------|-------|------|
| `spec-clarity` | Sonnet | Assess requirement quality (QuARS methodology) |
| `spec-consistency` | Haiku | Check terminology and pattern consistency |
| `spec-coverage` | Sonnet | Identify gaps, missing scenarios, edge cases |
| `spec-conflict` | Sonnet | Detect contradictions between requirements |
| `spec-doppelganger` | Sonnet | Detect duplicate requirements via semantic similarity |
| `spec-butterfly` | Opus | Analyze change impact (forward + backward traceability) |

---

### Test Agents

| Agent | Model | Role |
|-------|-------|------|
| `persona-architect` | Sonnet | Define user personas for test scenarios |
| `test-spec-writer` | Sonnet | TDD-first test specs, 80%+ coverage required |

---

### Execution Agents

| Agent | Model | Role |
|-------|-------|------|
| `spec-executor` | Opus | Multi-file implementation, HTML reference support |
| `code-reviewer` | Opus | 2-stage review (spec compliance → code quality) |
| `security-reviewer` | Opus | OWASP Top 10 security audit |
| `screen-vision` | Sonnet | Screenshot/mockup visual analysis |
| `wireframe-editor` | Sonnet | Modify YAML wireframes, generate before/after previews |

---

### API & MCP Agents

| Agent | Model | Role |
|-------|-------|------|
| `api-parser` | Sonnet | Parse OpenAPI/Swagger specs to structured JSON |
| `mcp-generator` | Sonnet | Generate MCP server code from parsed API endpoints |

---

### Utility Agents

| Agent | Model | Role |
|-------|-------|------|
| `spec-assembler` | Haiku | Final document assembly with priority organization |
| `spec-md-generator` | Haiku | Generate SPEC-IT-{HASH}.md files |
| `spec-md-maintainer` | Haiku | Maintain SPEC-IT files on modify/move/delete |
| `rtm-updater` | Haiku | Update Requirements Traceability Matrix |
| `change-planner` | Opus | Generate comprehensive change plans from analysis |

---

## Skills Reference (20 Skills)

### Core Workflow Skills

| Skill | Description |
|-------|-------------|
| `/spec-it` | Mode router - selects automation, complex, or step-by-step |
| `/spec-it-automation` | Full-auto spec generator with minimal approvals (large projects) |
| `/spec-it-complex` | Hybrid spec generator with milestone approvals (medium projects) |
| `/spec-it-stepbystep` | Step-by-step spec generator with chapter approvals (small projects) |
| `/spec-it-fast-launch` | Fast wireframe generator with design trends for rapid prototyping |
| `/spec-it-execute` | Autopilot executor - turns spec-it output into working code (9 phases) |

---

### Analysis & Maintenance Skills

| Skill | Description |
|-------|-------------|
| `/spec-change` | Spec change router with validation (conflicts, clarity, coverage, impact) |
| `/spec-mirror` | Compare original Spec against actual implementation |
| `/hack-2-spec` | Reverse-engineer Spec from existing codebase/website/mobile app |
| `/init-spec-md` | Generate SPEC-IT-{HASH}.md metadata for existing codebases |

---

### Loader Skills (Context Efficiency)

| Skill | Description |
|-------|-------------|
| `/spec-component-loader` | Progressive component spec loader with category/dependency filters |
| `/spec-scenario-loader` | Progressive scenario loader (persona/screen/critical path) |
| `/spec-test-loader` | Progressive test plan loader (category/priority/component) |

---

### UI & Design Skills

| Skill | Description |
|-------|-------------|
| `/spec-wireframe-edit` | Wireframe editor with impact analysis and optional Stitch HTML regen |
| `/stitch-convert` | Convert YAML/JSON wireframes to HTML via Stitch MCP |
| `/design-trends-2026` | 2026 design trends reference pack with templates and motion presets |
| `/prompt-inspector` | Visual API binding for React/Next.js UI elements and REST endpoints |

---

### API & Utility Skills

| Skill | Description |
|-------|-------------|
| `/spec-it-api-mcp` | Generate local MCP server from OpenAPI/Swagger |
| `/spec-it-mock` | Clone & reproduce mode for existing products |
| `/bash-executor` | Internal script executor for spec-it workflows (bypass permissions) |

---

## Model Routing Strategy

```
┌─────────────────────────────────────────────────────────────────────┐
│                        MODEL SELECTION                               │
├─────────────┬───────────┬───────────────────────────────────────────┤
│ Complexity  │   Model   │  Agents                                   │
├─────────────┼───────────┼───────────────────────────────────────────┤
│    LOW      │   Haiku   │  component-auditor, spec-assembler        │
│             │           │  spec-md-generator, spec-md-maintainer    │
│             │           │  spec-consistency, rtm-updater            │
├─────────────┼───────────┼───────────────────────────────────────────┤
│   MEDIUM    │  Sonnet   │  ui-architect, divergent-thinker          │
│             │           │  critic-logic, critic-feasibility         │
│             │           │  critic-frontend, component-builder       │
│             │           │  component-migrator, test-spec-writer     │
│             │           │  persona-architect, screen-vision         │
│             │           │  wireframe-editor, api-parser             │
│             │           │  mcp-generator, spec-clarity              │
│             │           │  spec-coverage, spec-conflict             │
│             │           │  spec-doppelganger                        │
├─────────────┼───────────┼───────────────────────────────────────────┤
│    HIGH     │   Opus    │  design-interviewer, chapter-planner      │
│             │           │  critic-moderator, critical-reviewer      │
│             │           │  ambiguity-detector, spec-critic          │
│             │           │  spec-executor, code-reviewer             │
│             │           │  security-reviewer, spec-butterfly        │
│             │           │  change-planner                           │
└─────────────┴───────────┴───────────────────────────────────────────┘
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
│   ├── layouts/
│   ├── <domain>/shared.md
│   ├── <domain>/<user-type>/screen-list.md
│   ├── <domain>/<user-type>/wireframes/  ◀── YAML/JSON wireframes
│   ├── html/                             ◀── Stitch HTML export
│   └── assets/                           ◀── Stitch assets
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
