# Claude Frontend Skills

Frontend specification generation and implementation toolkit for Claude Code.

## Installation
```bash
/plugin marketplace add 30eggis/claude-frontend-skills
```
```bash
/plugin install frontend-skills@30eggis/claude-frontend-skills
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

| Skill | Description | Command |
|-------|-------------|---------|
| **spec-it** | Specification generator (router) | `/spec-it` |
| **spec-it-automation** | Full auto spec generation | `/spec-it-automation` |
| **spec-it-complex** | Hybrid mode (4 milestones) | `/spec-it-complex` |
| **spec-it-stepbystep** | Step-by-step mode | `/spec-it-stepbystep` |
| **spec-it-execute** | Spec to code executor | `/spec-it-execute <folder>` |
| **stitch-convert** | ASCII → HTML via Stitch MCP | `/stitch-convert <session>` |
| **init-spec-md** | SPEC-IT files for existing code | `/init-spec-md` |
| **hack-2-prd** | Reverse-engineer PRD from code | `/hack-2-prd` |
| **prd-mirror** | Compare PRD vs implementation | `/prd-mirror` |
| **prompt-inspector** | Visual API binding tool | `/prompt-inspector` |

---

## Resume Interrupted Sessions

All spec-it modes support resume:

```bash
/spec-it-automation --resume 20260130-123456
```

Session state is saved in `tmp/{sessionId}/_meta.json`.

---

## Output Structure

```
tmp/{sessionId}/
├── _meta.json              # Checkpoint state
├── _status.json            # Runtime stats
├── 00-requirements/        # Requirements
├── 01-chapters/            # Design decisions
├── 02-screens/             # Wireframes, HTML
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
