# Claude Frontend Skills

Frontend specification generation and implementation toolkit for Claude Code.

## Installation
```bash
/plugin marketplace add 30eggis/claude-frontend-skills
```
```bash
/plugin install frontend-skills@claude-frontend-skills
```

---

## Quick Start

### spec-it: Generate Frontend Specifications

```bash
# Interactive mode selection
/spec-it

# Direct mode
/spec-it-automation      # Full Auto (recommended for large projects)
/spec-it-complex         # Hybrid (4 milestone approvals)
/spec-it-stepbystep      # Step-by-Step (learning/small projects)
```

| Mode | Command | Approvals | Best For |
|------|---------|-----------|----------|
| Full Auto | `/spec-it-automation` | Final only | Large projects |
| Hybrid | `/spec-it-complex` | 4 milestones | Medium projects |
| Step-by-Step | `/spec-it-stepbystep` | Every chapter | Small/learning |

### spec-it-execute: Implement Specifications

```bash
/spec-it-execute ./tmp/20260130-123456
```

Transforms generated specs into working code with autonomous execution.

---

## All Skills

### Spec Generation Skills

| Skill | Description | Command |
|-------|-------------|---------|
| **spec-it** | Specification generator (router) | `/spec-it` |
| **spec-it-automation** | Full auto spec generation | `/spec-it-automation` |
| **spec-it-complex** | Hybrid mode (4 milestones) | `/spec-it-complex` |
| **spec-it-stepbystep** | Step-by-step mode | `/spec-it-stepbystep` |
| **spec-it-execute** | Spec to code executor | `/spec-it-execute <folder>` |
| **stitch-convert** | YAML/JSON → HTML via Stitch MCP | `/stitch-convert <session>` |

### Spec Modification Skills

| Skill | Description | Command |
|-------|-------------|---------|
| **spec-change** | Modify specs with validation | `/spec-change <session> <request>` |
| **spec-wireframe-edit** | Edit wireframes with impact analysis | `/spec-wireframe-edit <session>` |

### Utility Skills

| Skill | Description | Command |
|-------|-------------|---------|
| **spec-it-api-mcp** | API doc → MCP server | `/spec-it-api-mcp <api-doc>` |
| **init-spec-md** | SPEC-IT files for existing code | `/init-spec-md` |
| **hack-2-prd** | Reverse-engineer PRD from code | `/hack-2-prd` |
| **prd-mirror** | Compare PRD vs implementation | `/prd-mirror` |
| **prompt-inspector** | Visual API binding tool | `/prompt-inspector` |

---

## Spec Modification Skills

A separate set of skills for **modifying existing specifications** with comprehensive validation and impact analysis.

> These skills are designed for **post-creation spec management**, not initial spec generation.

### Why Separate Skills?

| Concern | spec-it (Generation) | Spec Modification Skills |
|---------|---------------------|--------------------------|
| Purpose | Create new specs from scratch | Modify existing specs safely |
| Focus | Completeness | Change validation |
| Workflow | Linear phases | Parallel analysis + approval |
| Key Risk | Missing requirements | Breaking existing specs |

---

### spec-change: Spec Modification Router

**Purpose**: Safely modify specifications with pre-flight validation checks.

```bash
/spec-change <sessionId> "Add 2FA feature to authentication section"
/spec-change <sessionId> --target 01-chapters/CH-02.md "Change login to OAuth"
```

**Validation Pipeline** (runs in parallel):

| Analyzer | Model | What it checks |
|----------|-------|----------------|
| `spec-doppelganger` | sonnet | Duplicate/similar features already exist? |
| `spec-conflict` | sonnet | Contradicts existing requirements? |
| `spec-clarity` | sonnet | Is the change well-defined? (QuARS methodology) |
| `spec-consistency` | haiku | Uses consistent terminology? |
| `spec-coverage` | sonnet | Missing edge cases or error handling? |
| `spec-butterfly` | opus | What other docs are affected? (RTM) |

**Workflow**:
```
[Request] → [Parallel Analysis] → [Change Plan] → [User Approval] → [Apply]
```

---

### spec-wireframe-edit: Wireframe Modification

**Purpose**: Modify wireframes with impact analysis on components and tests.

```bash
/spec-wireframe-edit <sessionId> login
/spec-wireframe-edit <sessionId> dashboard --change "Add notification bell to header"
```

**Workflow**:
```
[Locate Wireframe] → [Butterfly Analysis] → [Before/After Preview] → [Approve] → [Apply]
```

**Features**:
- Structured YAML/JSON wireframe modification with visual diff
- Auto-regenerates HTML if Stitch mode is active
- Flags affected components and tests for review

---

### Spec Modification Agents

| Agent | Model | Role |
|-------|-------|------|
| `spec-doppelganger` | sonnet | Semantic duplicate detection |
| `spec-conflict` | sonnet | Contradiction finder |
| `spec-clarity` | sonnet | Quality assessment (completeness, ambiguity) |
| `spec-consistency` | haiku | Terminology consistency |
| `spec-coverage` | sonnet | Gap analysis (edge cases, errors) |
| `spec-butterfly` | opus | Bidirectional impact analysis |
| `change-planner` | opus | Generate change plan with diffs |
| `rtm-updater` | haiku | Requirements Traceability Matrix |
| `wireframe-editor` | sonnet | YAML/JSON wireframe modifier |

---

## Resume Interrupted Sessions

All spec-it modes support resume:

```bash
/spec-it-automation --resume 20260130-123456
```

Session state is saved in `.spec-it/{sessionId}/plan/_meta.json`.

---

## Output Structure

```
.spec-it/{sessionId}/
├── plan/
│   ├── _meta.json          # Checkpoint state (plan mode)
│   └── _status.json        # Runtime stats (plan mode)
├── execute/
│   ├── _meta.json          # Checkpoint state (execute mode)
│   └── _status.json        # Runtime stats (execute mode)
└── runtime-log.md          # Session-wide activity log

tmp/                        # Document artifacts (archive)
├── 00-requirements/        # Requirements
├── 01-chapters/            # Design decisions
├── 02-wireframes/          # Wireframes, HTML
├── 03-components/          # Component specs
├── 04-review/              # Reviews, ambiguities
├── 05-tests/               # Test specs
└── 06-final/
    ├── final-spec.md       # Complete specification
    ├── dev-tasks.md        # Implementation tasks
    └── SPEC-SUMMARY.md     # Executive summary
```

---

## Real-time Dashboard

Monitor progress in a separate terminal:

```bash
# Install
bash ~/.claude/plugins/frontend-skills/skills/shared/dashboard/install.sh

# Run
spec-it-dashboard
```

See [docs/DASHBOARD.md](docs/DASHBOARD.md) for details.

---

## Documentation

| Document | Description |
|----------|-------------|
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Workflow diagrams, execution patterns |
| [AGENTS.md](docs/AGENTS.md) | All 23+ agents and their roles |
| [DASHBOARD.md](docs/DASHBOARD.md) | Real-time dashboard usage |

---

## Tech Stack

- **Framework**: Next.js (App Router)
- **UI Library**: React + shadcn/ui
- **Styling**: Tailwind CSS

---

## License

MIT
