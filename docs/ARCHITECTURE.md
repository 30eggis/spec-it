# Architecture & Reference

## Overview

### Unified Flow (P1-P14)

All three spec-it modes (stepbystep, complex, automation) use the same unified P1-P14 flow:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              USER INTENT                                     │
│  "자동으로 스펙 만들어줘" or "/spec-it-automation"                            │
└─────────────────────────────────┬───────────────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         SKILL (Entry Point)                                  │
│  spec-it-{mode}/SKILL.md                                                    │
│  • Semantic match OR explicit /slash-command                                │
│  • Contains orchestration logic for P1-P14                                  │
│  • Coordinates agents via Task tool                                          │
└─────────────────────────────────┬───────────────────────────────────────────┘
                                  │
        ┌─────────────────────────┼─────────────────────────────────┐
        │                         │                                 │
        ▼                         ▼                                 ▼
┌───────────────┐       ┌───────────────┐               ┌───────────────┐
│   AGENT       │       │   SKILL       │               │   AGENT       │
│ (Task tool)   │       │ (Sub-skill)   │               │ (Task tool)   │
└───────────────┘       └───────────────┘               └───────────────┘
```

### Key Principles

| Layer | Role | Trigger Method |
|-------|------|----------------|
| **Skill** | User-facing entry point | User message (semantic/explicit) |
| **Orchestrator** | Control flow, P1-P14 phases | Skill contains orchestration logic |
| **Agent** | Isolated worker execution | Explicit `Task` tool call only |

---

## P1-P14 Phase Flow

```
╔═══════════════════════════════════════════════════════════════════════════════╗
║                           UNIFIED SPEC-IT WORKFLOW                            ║
║                              (P1-P14 Phases)                                  ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║                                                                               ║
║  P1: Requirements Gathering ──────────────────────────────────────────────── ║
║  │   └─ design-interviewer (opus) → requirements.md                          ║
║  │                                                                            ║
║  P2: Persona Definition ──────────────────────────────────────────────────── ║
║  │   └─ persona-architect (sonnet) → personas/*.md                           ║
║  │                                                                            ║
║  P3: Divergent Thinking ──────────────────────────────────────────────────── ║
║  │   └─ divergent-thinker (sonnet) → alternatives/*.md                       ║
║  │                                                                            ║
║  P4: Multi-Critic Review ─────────────────────────────────────────────────── ║
║  │   ┌─ critic-logic (sonnet) ────────┐                                      ║
║  │   ├─ critic-feasibility (sonnet) ──┼── PARALLEL                           ║
║  │   └─ critic-frontend (sonnet) ─────┘                                      ║
║  │              │                                                             ║
║  │              ▼                                                             ║
║  │   └─ critic-analytics (sonnet) → critique-synthesis.md                    ║
║  │                                                                            ║
║  P5: Critique Resolution ─────────────────────────────────────────────────── ║
║  │   ├─ [step/comp] critique-resolver (user input)                           ║
║  │   └─ [auto] critic-moderator (auto consensus)                             ║
║  │   → critique-solve/*.md                                                   ║
║  │                                                                            ║
║  P6: Chapter Plan (RE-EXECUTION POINT) ───────────────────────────────────── ║
║  │   └─ chapter-planner (opus) → chapter-plan-final.md                       ║
║  │                                                                            ║
║  P7: UI Architecture ─────────────────────────────────────────────────────── ║
║  │   └─ ui-architect (sonnet) → wireframes/**/*.yaml                         ║
║  │                                                                            ║
║  P8: Component Audit ─────────────────────────────────────────────────────── ║
║  │   └─ component-auditor (haiku) → inventory.md, gap-analysis.md            ║
║  │                                                                            ║
║  P9: Component Specs ─────────────────────────────────────────────────────── ║
║  │   ├─ component-builder (sonnet) ──┬── PARALLEL                            ║
║  │   └─ component-migrator (sonnet) ─┘                                       ║
║  │   → components/new/*.yaml, migrations/                                    ║
║  │                                                                            ║
║  P10: Context Synthesis ──────────────────────────────────────────────────── ║
║  │   └─ context-synthesizer (sonnet) → spec-map.md                           ║
║  │                                                                            ║
║  P11: Critical Review (Skill) ────────────────────────────────────────────── ║
║  │   ┌─ scenario-reviewer (opus) ─────┐                                      ║
║  │   ├─ ia-reviewer (opus) ───────────┼── PARALLEL                           ║
║  │   └─ exception-reviewer (opus) ────┘                                      ║
║  │              │                                                             ║
║  │              ▼                                                             ║
║  │   └─ review-analytics (sonnet) → ambiguities.md                           ║
║  │   ├─ [step/comp] review-resolver (user input)                             ║
║  │   └─ [auto] review-moderator (auto consensus)                             ║
║  │   → review-decisions.md                                                   ║
║  │   [IF re-execution needed → GOTO P6]                                      ║
║  │                                                                            ║
║  P12: Test Specification ─────────────────────────────────────────────────── ║
║  │   └─ test-spec-writer (sonnet) → test-scenarios/**                        ║
║  │                                                                            ║
║  P13: Final Assembly ─────────────────────────────────────────────────────── ║
║  │   └─ spec-assembler (haiku) → final-spec.md, SPEC-SUMMARY.md              ║
║  │                                                                            ║
║  P14: Development Planning ───────────────────────────────────────────────── ║
║      ├─ api-predictor (skill) → api-map.md                                   ║
║      └─ dev-planner (sonnet) → dev-plan/**                                   ║
║                                                                               ║
║  ★ Final Approval                                                            ║
║  [automation only] → spec-it-execute                                         ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
```

---

## Mode Differences

| Aspect | stepbystep | complex | automation |
|--------|------------|---------|------------|
| P5 Resolution | critique-resolver | critique-resolver | **critic-moderator** |
| P11 Resolution | review-resolver | review-resolver | **review-moderator** |
| Approval Timing | Every phase | 4 milestones | Final only |
| Auto Execute | No | No | **Yes** |

---

## Agents Reference (43 Agents)

### Design & Planning (4)

| Agent | Model | Role |
|-------|-------|------|
| `design-interviewer` | Opus | Brainstorming Q&A facilitator (P1) |
| `divergent-thinker` | Sonnet | Alternative exploration, creative thinking (P3) |
| `chapter-planner` | Opus | Synthesize critiques, finalize chapter structure (P6) |
| `ui-architect` | Sonnet | YAML wireframe design, bold aesthetic choices (P7) |

### Persona & Testing (2)

| Agent | Model | Role |
|-------|-------|------|
| `persona-architect` | Sonnet | Define user personas (P2) |
| `test-spec-writer` | Sonnet | TDD-first test specs, cross-persona flows (P12) |

### Multi-Critic System (5)

```
┌─────────────┬─────────────┬─────────────┐
│critic-logic │critic-feasi.│critic-front.│  ← Parallel (P4)
└──────┬──────┴──────┬──────┴──────┬──────┘
       └─────────────┼─────────────┘
                     ▼
             critic-analytics              ← Aggregate metrics (P4)
                     │
        ┌────────────┴────────────┐
        ▼                         ▼
 critique-resolver         critic-moderator
 (step/comp mode)          (auto mode)     ← Resolution (P5)
```

| Agent | Model | Focus Area |
|-------|-------|------------|
| `critic-logic` | Sonnet | Logic consistency, overlaps, gaps, dependency order |
| `critic-feasibility` | Sonnet | Independent definition, clear criteria, testable deliverables |
| `critic-frontend` | Sonnet | UI/UX, component reusability, responsive/a11y |
| `critic-analytics` | Sonnet | **NEW** Aggregate critics, generate priority/risk metrics |
| `critic-moderator` | Opus | Auto consensus, conflict resolution (automation only) |

### Critical Review System (6)

```
┌────────────────┬────────────────┬────────────────┐
│scenario-review.│  ia-reviewer   │exception-rev.  │  ← Parallel (P11)
└───────┬────────┴───────┬────────┴───────┬────────┘
        └────────────────┼────────────────┘
                         ▼
               review-analytics              ← Aggregate (P11)
                         │
        ┌────────────────┴────────────────┐
        ▼                                  ▼
  review-resolver                   review-moderator
  (step/comp mode)                  (auto mode)     ← Resolution (P11)
```

| Agent | Model | Role |
|-------|-------|------|
| `scenario-reviewer` | Opus | **NEW** Scenario completeness, flow consistency |
| `ia-reviewer` | Opus | **NEW** Information architecture, navigation structure |
| `exception-reviewer` | Opus | **NEW** Error handling, boundary conditions |
| `review-analytics` | Sonnet | **NEW** Aggregate reviews → ambiguities.md |
| `review-resolver` | Sonnet | **NEW** User resolution input (step/comp only) |
| `review-moderator` | Opus | **NEW** Auto consensus (automation only) |

### Component Agents (3)

| Agent | Model | Role |
|-------|-------|------|
| `component-auditor` | Haiku | Scan existing components, create inventory (P8) |
| `component-builder` | Sonnet | Write new component specs (P9) |
| `component-migrator` | Sonnet | Plan component migrations (P9) |

### Context & Planning (2)

| Agent | Model | Role |
|-------|-------|------|
| `context-synthesizer` | Sonnet | **NEW** Aggregate artifacts → spec-map.md (P10) |
| `dev-planner` | Sonnet | **NEW** Development planning → dev-plan/ (P14) |

### Spec Quality Agents (8)

| Agent | Model | Role |
|-------|-------|------|
| `spec-clarity` | Sonnet | Assess requirement quality (QuARS methodology) |
| `spec-consistency` | Haiku | Check terminology and pattern consistency |
| `spec-coverage` | Sonnet | Identify gaps, missing scenarios, edge cases |
| `spec-conflict` | Sonnet | Detect contradictions between requirements |
| `spec-doppelganger` | Sonnet | Detect duplicate requirements |
| `spec-butterfly` | Opus | Analyze change impact (forward + backward traceability) |
| `critical-reviewer` | Opus | Scenario/IA/exception comprehensive review |
| `ambiguity-detector` | Opus | Detect ambiguities, generate clarification questions |

### Execution Agents (5)

| Agent | Model | Role |
|-------|-------|------|
| `spec-executor` | Opus | Multi-file implementation |
| `code-reviewer` | Opus | 2-stage review (spec compliance → code quality) |
| `security-reviewer` | Opus | OWASP Top 10 security audit |
| `screen-vision` | Sonnet | Screenshot/mockup visual analysis |
| `wireframe-editor` | Sonnet | Modify YAML wireframes |

### API & MCP Agents (2)

| Agent | Model | Role |
|-------|-------|------|
| `api-parser` | Sonnet | Parse OpenAPI/Swagger specs |
| `mcp-generator` | Sonnet | Generate MCP server code |

### Utility Agents (6)

| Agent | Model | Role |
|-------|-------|------|
| `spec-assembler` | Haiku | Final document assembly (P13) |
| `spec-md-generator` | Haiku | Generate SPEC-IT-{HASH}.md files |
| `spec-md-maintainer` | Haiku | Maintain SPEC-IT files on modify/move/delete |
| `rtm-updater` | Haiku | Update Requirements Traceability Matrix |
| `change-planner` | Opus | Generate comprehensive change plans |
| `spec-dev-plan-critic` | Opus | Validate execution plans |

---

## Skills Reference (23 Skills)

### Core Workflow Skills (6)

| Skill | Description |
|-------|-------------|
| `/spec-it` | Mode router - selects automation, complex, or step-by-step |
| `/spec-it-automation` | Full-auto P1-P14 with auto consensus and auto-execute |
| `/spec-it-complex` | P1-P14 with 4 milestone approvals |
| `/spec-it-stepbystep` | P1-P14 with per-phase approvals |
| `/spec-it-fast-launch` | Fast wireframe generator for rapid prototyping |
| `/spec-it-execute` | Autopilot executor - turns spec-it output into working code |

### New Skills (3)

| Skill | Description |
|-------|-------------|
| `/critique-resolver` | **NEW** User resolution interface for P5 critique issues |
| `/critical-review` | **NEW** P11 review orchestration (parallel reviewers + resolution) |
| `/api-predictor` | **NEW** Predict API endpoints from spec artifacts (P14) |

### Analysis & Maintenance Skills (4)

| Skill | Description |
|-------|-------------|
| `/spec-change` | Spec change router with validation |
| `/spec-mirror` | Compare original Spec against actual implementation |
| `/hack-2-spec` | Reverse-engineer Spec from existing codebase |
| `/init-spec-md` | Generate SPEC-IT metadata for existing codebases |

### Loader Skills (3)

| Skill | Description |
|-------|-------------|
| `/spec-component-loader` | Progressive component spec loader |
| `/spec-scenario-loader` | Progressive scenario loader |
| `/spec-test-loader` | Progressive test plan loader |

### UI & Design Skills (4)

| Skill | Description |
|-------|-------------|
| `/spec-wireframe-edit` | Wireframe editor with impact analysis |
| `/design-trends-2026` | 2026 design trends reference pack |
| `/prompt-inspector` | Visual API binding for UI elements |

### Utility Skills (3)

| Skill | Description |
|-------|-------------|
| `/spec-it-api-mcp` | Generate local MCP server from OpenAPI/Swagger |
| `/spec-it-mock` | Clone & reproduce mode for existing products |
| `/bash-executor` | Internal script executor (bypass permissions) |

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
│   MEDIUM    │  Sonnet   │  persona-architect, divergent-thinker     │
│             │           │  critic-logic, critic-feasibility         │
│             │           │  critic-frontend, critic-analytics (NEW)  │
│             │           │  ui-architect, component-builder          │
│             │           │  component-migrator, test-spec-writer     │
│             │           │  context-synthesizer (NEW)                │
│             │           │  review-analytics (NEW)                   │
│             │           │  review-resolver (NEW)                    │
│             │           │  dev-planner (NEW)                        │
├─────────────┼───────────┼───────────────────────────────────────────┤
│    HIGH     │   Opus    │  design-interviewer, chapter-planner      │
│             │           │  critic-moderator                         │
│             │           │  scenario-reviewer (NEW)                  │
│             │           │  ia-reviewer (NEW)                        │
│             │           │  exception-reviewer (NEW)                 │
│             │           │  review-moderator (NEW)                   │
│             │           │  spec-executor, code-reviewer             │
│             │           │  security-reviewer, change-planner        │
└─────────────┴───────────┴───────────────────────────────────────────┘
```

---

## Output Directory Structure

### Session State
```
.spec-it/{sessionId}/
├── plan/
│   ├── _meta.json             ◀── Checkpoint state (phase, step, reexecuteFromP6)
│   └── _status.json           ◀── Runtime stats
├── execute/
│   ├── _meta.json
│   └── _status.json
└── logs/
```

### Document Artifacts
```
tmp/
├── 00-requirements/
│   └── requirements.md
│
├── 01-chapters/
│   ├── personas/              ◀── P2 output
│   ├── alternatives/          ◀── P3 output
│   ├── critique-logic.md      ◀── P4 output
│   ├── critique-feasibility.md
│   ├── critique-frontend.md
│   ├── critique-synthesis.md  ◀── P4 critic-analytics output
│   └── chapter-plan-final.md  ◀── P6 output
│
├── critique-solve/            ◀── P5 output (NEW)
│   ├── merged-decisions.md
│   ├── ambiguity-resolved.md
│   └── undefined-specs.md
│
├── 02-wireframes/             ◀── P7 output
│   ├── layouts/
│   ├── domain-map.md
│   ├── shared/{domain}.md
│   └── {user-type}/{domain}/wireframes/*.yaml
│
├── 03-components/             ◀── P8-P9 output
│   ├── inventory.md
│   ├── gap-analysis.md
│   ├── new/*.yaml
│   └── migrations/
│
├── 04-review/                 ◀── P11 output (NEW structure)
│   ├── scenario-review.md
│   ├── ia-review.md
│   ├── exception-review.md
│   ├── ambiguities.md
│   └── review-decisions.md
│
├── 05-tests/
│   └── test-scenarios/        ◀── P12 output (NEW structure)
│       ├── _index.md
│       ├── {persona-id}/
│       │   ├── overview.md
│       │   ├── {feature}/happy-cases.md
│       │   ├── {feature}/sad-cases.md
│       │   └── coverage-matrix.md
│       └── cross-persona/     ◀── REQUIRED
│           ├── _index.md
│           ├── {flow-id}.md
│           └── interaction-matrix.md
│
├── 06-final/                  ◀── P13 output
│   ├── final-spec.md
│   └── SPEC-SUMMARY.md
│
├── spec-map.md                ◀── P10 output (NEW)
│
└── dev-plan/                  ◀── P14 output (NEW)
    ├── development-map.md
    ├── api-map.md
    ├── {persona-id}/
    │   └── Phase-{n}/
    │       └── Task-{n}.md
    └── shared/
        └── Phase-0/
```

---

## Shared References Structure

```
shared/                        ◀── Root level (peer to skills/, agents/)
├── references/
│   ├── common/               ◀── 2+ agents reference
│   │   ├── critique-solve-format.md
│   │   ├── spec-map-format.md
│   │   ├── test-scenario-format.md
│   │   └── dev-plan-format.md
│   ├── critic-analytics/
│   │   └── synthesis-format.md
│   ├── critique-resolver/
│   │   └── question-templates.md
│   ├── critical-review/
│   │   ├── ambiguity-format.md
│   │   └── review-criteria.md
│   ├── dev-planner/
│   │   └── task-template.md
│   ├── api-predictor/
│   │   ├── api-format.md
│   │   └── design-principles.md
│   └── context-synthesizer/
│       └── spec-map-guide.md
├── templates/
│   ├── common/
│   └── {agent-name}/
└── examples/
    ├── common/
    └── {agent-name}/
```

---

## Re-execution Flow

When P11 critical review identifies structural issues:

```
P11 review-decisions.md
        │
        ├── reexecution_required: true
        │   reason: "Chapter scope change" | "New requirement" | "Persona change"
        │
        ▼
_meta.reexecuteFromP6 = true
        │
        ▼
   GOTO P6 (chapter-planner)
        │
        ▼
Continue P7 → P14
```

Re-execution conditions:
1. **Chapter scope change** - Significant scope modification
2. **New requirement** - Previously unidentified requirement
3. **Persona change** - Persona definition modified
4. **Architecture change** - Navigation structure overhauled

---

## spec-it-execute Phase Flow (Phase 0-9)

Plan mode (P1-P14) 완료 후, Execute mode로 코드 구현을 수행합니다.

```
╔═══════════════════════════════════════════════════════════════════════════════╗
║                         SPEC-IT-EXECUTE WORKFLOW                              ║
║                            (Phase 0-9)                                        ║
╠═══════════════════════════════════════════════════════════════════════════════╣
║                                                                               ║
║  Phase 0: Initialize ────────────────────────────────────────────────────────║
║  │   └─ bash-executor → .spec-it/{sessionId}/execute-state.json              ║
║  │                                                                            ║
║  Phase 1: Load ──────────────────────────────────────────────────────────────║
║  │   └─ spec-map.md, wireframes, components, scenarios 로딩                  ║
║  │   → task-registry.json (immutable)                                        ║
║  │                                                                            ║
║  Phase 2: Plan ──────────────────────────────────────────────────────────────║
║  │   └─ spec-dev-plan-critic (opus) → execution-plan.md                      ║
║  │                                                                            ║
║  Phase 3: Execute ◀──────────────────────────────────────────────────────────║
║  │   └─ dev-pilot (skill)                          ▲                         ║
║  │       ├─ dev-executor-low (haiku)               │                         ║
║  │       ├─ dev-executor (sonnet)                  │ 회귀                    ║
║  │       ├─ dev-executor-high (opus)               │ 포인트                  ║
║  │       └─ dev-architect (opus)                   │                         ║
║  │   → src/**/* (구현 코드)                        │                         ║
║  │                                                 │                         ║
║  Phase 4: Bringup (Hard Gate) ───────────────────│─────────────────────────║
║  │   └─ dev-build-fixer (sonnet)                  │                         ║
║  │   → lint/typecheck/build 검증                  │                         ║
║  │   ✗ FAIL → fix-tasks.json ─────────────────────┘                         ║
║  │                                                                            ║
║  Phase 5: Spec-Mirror (Hard Gate) ───────────────│─────────────────────────║
║  │   └─ spec-mirror (skill)                       │                         ║
║  │   → MIRROR_REPORT.md                           │                         ║
║  │   ✗ FAIL → mirror-report-tasks.json ───────────┘                         ║
║  │                                                                            ║
║  Phase 6: Unit Tests (Hard Gate) ────────────────│─────────────────────────║
║  │   └─ ultraqa (skill, unit mode)                │                         ║
║  │       ├─ qa-tester (sonnet)                    │                         ║
║  │       └─ qa-tester-high (opus)                 │                         ║
║  │   → *.test.ts, coverage/                       │                         ║
║  │   ✗ FAIL → test-fix-tasks.json ────────────────┘                         ║
║  │                                                                            ║
║  Phase 7: E2E Tests (Hard Gate) ─────────────────│─────────────────────────║
║  │   └─ ultraqa (skill, e2e mode)                 │                         ║
║  │       └─ qa-tester-high (opus)                 │                         ║
║  │   → *.spec.ts (Playwright)                     │                         ║
║  │   ✗ FAIL → e2e-fix-tasks.json ─────────────────┘                         ║
║  │                                                                            ║
║  Phase 8: Validate (Hard Gate) ──────────────────│─────────────────────────║
║  │   ├─ code-reviewer (opus) + Vercel Best Practices                        ║
║  │   └─ security-reviewer (opus)                  │                         ║
║  │   → code-review-report.md, security-report.md  │                         ║
║  │   ✗ FAIL → review-fix-tasks.json ──────────────┘                         ║
║  │                                                                            ║
║  Phase 9: Complete ──────────────────────────────────────────────────────────║
║      └─ final-summary.md, screenshots/                                       ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
```

### Execute Phase 회귀 흐름

모든 Hard Gate 실패 → Phase 3 (Execute)로 회귀:

```
Phase 4 FAIL → fix-tasks.json → Phase 3 → 4
Phase 5 FAIL → mirror-report-tasks.json → Phase 3 → 4 → 5
Phase 6 FAIL → test-fix-tasks.json → Phase 3 → 4 → 5 → 6
Phase 7 FAIL → e2e-fix-tasks.json → Phase 3 → 4 → 5 → 6 → 7
Phase 8 FAIL → review-fix-tasks.json → Phase 3 → 4 → 5 → 6 → 7 → 8
```

### Execute Agents Reference

| Phase | Agent | Model | Role |
|-------|-------|-------|------|
| 2 | `spec-dev-plan-critic` | Opus | Execution plan validation |
| 3 | `dev-executor-low` | Haiku | Simple single-file tasks |
| 3 | `dev-executor` | Sonnet | Standard feature implementation |
| 3 | `dev-executor-high` | Opus | Complex multi-file architecture |
| 3 | `dev-architect` | Opus | Spec compliance verification |
| 4 | `dev-build-fixer` | Sonnet | Build/type error resolution |
| 6 | `qa-tester` | Sonnet | Unit test execution (tmux) |
| 6/7 | `qa-tester-high` | Opus | Comprehensive/E2E tests |
| 8 | `code-reviewer` | Opus | 2-stage review + Vercel BP |
| 8 | `security-reviewer` | Opus | Security audit |

### Execute Skills Reference

| Skill | Phase | Role |
|-------|-------|------|
| `dev-pilot` | 3 | Parallel autopilot (up to 5 workers) |
| `spec-mirror` | 5 | Spec compliance verification |
| `ultraqa` | 6, 7 | Test cycle orchestration |
| `bash-executor` | 0, 4 | Script execution |

### Fix Mode (회귀 시)

```bash
/spec-it:dev-pilot {sessionId} --mode=fix --tasks={*-tasks.json}
```

공통 *-tasks.json 스키마:
```json
{
  "source": "{실패 리포트}",
  "sourcePhase": 4 | 5 | 6 | 7 | 8,
  "iteration": 1,
  "tasks": [
    {
      "id": "fix-001",
      "type": "build-error | missing | test-fail | security | code-quality",
      "priority": "CRITICAL | HIGH | MEDIUM | LOW",
      "files": ["src/..."],
      "errorDetail": "..."
    }
  ]
}
```
