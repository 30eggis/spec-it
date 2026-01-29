# Claude Frontend Skills

A collection of useful skills for frontend development and documentation.

## Installation

```bash
/plugin marketplace add 30eggis/claude-frontend-skills
```

Or install directly:

```bash
/plugin install frontend-skills@30eggis/claude-frontend-skills
```

## Skills Overview

| Skill | Description |
|-------|-------------|
| `spec-it` | Frontend specification generator (Manual mode) |
| `spec-it-complex` | Frontend specification generator (Hybrid mode) |
| `spec-it-automation` | Frontend specification generator (Full Auto mode) |
| `init-spec-md` | SPEC-IT file generator for existing code |
| `prompt-inspector` | Visual API binding tool for React/Next.js |
| `hack-2-prd` | Code analysis to PRD/SPEC/PHASE/TASKS generation |
| `prd-mirror` | PRD vs implementation comparison |

---

## spec-it (Frontend Specification Generator)

Transform vibe-coding/PRD into **production-ready frontend specifications** with multi-agent collaboration.

### Three Modes

| Command | Mode | User Approval | Best For |
|---------|------|---------------|----------|
| `/frontend-skills:spec-it` | Manual | Every chapter | Small projects, learning |
| `/frontend-skills:spec-it-complex` | Hybrid | 4 milestones | Medium projects |
| `/frontend-skills:spec-it-automation` | Full Auto | Final only | Large projects |

### Core Features

1. **Design Brainstorming**: Superpowers-style Q&A for requirement refinement
2. **UI Architecture**: ASCII art wireframes and screen structure design
3. **Component Discovery**: Existing component scanning + gap analysis + migration
4. **Critical Review**: Rigorous scenario/IA/exception handling review
5. **Test Specification**: Persona-based scenario test specification generation
6. **SPEC-IT-{HASH}.md**: Metadata system for progressive context loading

### Workflow Phases

| Phase | Output |
|-------|--------|
| 0. Input Analysis | `00-requirements/requirements.md` |
| 1. Design Brainstorming | `01-chapters/decisions/*.md` |
| 2. UI Architecture | `02-screens/wireframes/*.md` |
| 3. Component Discovery | `03-components/inventory.md, gap-analysis.md` |
| 4. Critical Review | `04-review/scenarios/, ambiguities.md` |
| 5. Test Specification | `05-tests/personas/, coverage-map.md` |
| 6. Final Assembly | `06-final/final-spec.md, dev-tasks.md` |

### Trigger Examples

- "프론트엔드 스펙 작성해줘" / "Write frontend spec"
- "PRD를 개발 스펙으로 변환해줘" / "Convert PRD to dev spec"
- "UI 컴포넌트 설계 문서 만들어줘" / "Create UI component design doc"

---

## init-spec-md

Generate `SPEC-IT-{HASH}.md` metadata files for existing UI code to enable **progressive context loading**.

### Usage

```bash
/frontend-skills:init-spec-md                    # Full project scan
/frontend-skills:init-spec-md src/components     # Specific path only
/frontend-skills:init-spec-md --dry-run          # Preview (no file creation)
/frontend-skills:init-spec-md --force            # Overwrite existing files
```

### Purpose

- **Progressive Context Loading**: Agents load only required context
- **Bidirectional Navigation**: Parent ↔ Child document links
- **Registry Management**: All HASHes managed in `.spec-it-registry.json`

---

## prompt-inspector

Visual API binding tool for connecting UI elements to REST APIs in React/Next.js projects.

### Features

- **Visual Element Selection** - Click on any UI element to select
- **API Discovery** - Automatically find APIs (axios, fetch, Express, Next.js routes)
- **Binding Configuration** - Set trigger, success/error handlers
- **Multiple Error Cases** - Support for business error codes
- **Export to Markdown** - Generate specs for Claude to implement

### Quick Setup

```bash
# Auto-install (detects Next.js App/Pages Router)
python scripts/setup.py /path/to/your-project

# Discover APIs in your project
python scripts/discover_apis.py /path/to/your-project
```

### Trigger Examples

- "UI에 API 연결해줘" / "Connect API to UI"
- "prompt-inspector 설정해줘" / "Setup prompt-inspector"
- "API 바인딩 명세 만들어줘" / "Create API binding spec"

### Output Example

```markdown
# Route: /users

## 1. POST /api/users
- Selector: `button.submit-btn`
- Trigger: onClick
- OnSuccess: toast ("User created")
- OnError #1: [ERR_DUPLICATE] toast ("Already exists")
- OnError #2: toast ("Unknown error")
```

---

## hack-2-prd

Analyze services/projects and systematically generate documentation:

- **PRD** (Product Requirements Document)
- **SPEC** (Feature Specifications)
- **PHASE** (Implementation Phases)
- **TASKS** (Task Lists)

### Trigger Examples

- "PRD 작성해줘" / "Write a PRD"
- "문서화 해줘" / "Document this"
- "이 코드를 문서화해줘" / "Document this codebase"
- "웹사이트 분석해서 문서 만들어줘" / "Analyze this website and create docs"

### Supported Input Sources

| Source | Description |
|--------|-------------|
| Website URL | Analyze via Chrome Extension data |
| Codebase | Analyze local project structure |
| Mobile App | Analyze from screenshots/descriptions |

### Output Structure

```
docs/
├── PRD.md
├── specs/
│   ├── SPEC-01.md
│   ├── SPEC-02.md
│   └── ...
├── phases/
│   ├── PHASE-01.md
│   └── ...
└── tasks/
    ├── TASKS-PHASE-01.md
    └── ...
```

---

## prd-mirror

Compare original PRD against actual implementation to verify spec compliance.

### Workflow

```
[Original PRD] + [Codebase]
       ↓
[Generate reverse-engineered PRD via hack-2-prd]
       ↓
[Compare REQ items]
       ↓
[Generate report: Over-spec / Missing / Matched]
```

### Trigger Examples

- "PRD 대비 구현 상태 확인해줘" / "Check implementation against PRD"
- "오버스펙 기능 찾아줘" / "Find over-spec features"

---

## Agents

The spec-it skills use 15 specialized agents for multi-agent collaboration:

### Core Agents
| Agent | Model | Role |
|-------|-------|------|
| `design-interviewer` | opus | Brainstorming Q&A facilitator |
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

---

## Tech Stack

- **Framework**: Next.js (App Router)
- **UI Library**: React + shadcn/ui
- **Styling**: Tailwind CSS
- **Best Practices**: Vercel React Best Practices compliance

## License

MIT
