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

## Skills

### prompt-inspector

Visual API binding tool for connecting UI elements to REST APIs in React/Next.js projects.

#### Features

- **Visual Element Selection** - Click on any UI element to select
- **API Discovery** - Automatically find APIs (axios, fetch, Express, Next.js routes)
- **Binding Configuration** - Set trigger, success/error handlers
- **Multiple Error Cases** - Support for business error codes
- **Export to Markdown** - Generate specs for Claude to implement

#### Quick Setup

```bash
# Auto-install (detects Next.js App/Pages Router)
python scripts/setup.py /path/to/your-project

# Discover APIs in your project
python scripts/discover_apis.py /path/to/your-project
```

#### Trigger Examples

- "UI에 API 연결해줘" / "Connect API to UI"
- "prompt-inspector 설정해줘" / "Setup prompt-inspector"
- "API 바인딩 명세 만들어줘" / "Create API binding spec"

#### Workflow

```
1. Setup     → Auto-inject component into layout
2. Discover  → Find all APIs in project
3. Bind      → Select elements, configure in browser
4. Export    → Copy markdown, give to Claude
5. Implement → Claude generates the code
```

#### Output Example

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

### spec-it

Frontend specification generator that transforms vibe-coding/PRD into **production-ready detailed specifications**.

#### Features

- **Design Brainstorming** - Superpowers-style chunk-based Q&A for requirement refinement
- **UI Architecture** - ASCII art wireframes and screen structure design
- **Component Discovery** - Existing component scanning + gap analysis + migration planning
- **Critical Review** - Rigorous scenario/IA/exception handling review
- **Test Specification** - Persona-based scenario test specification generation
- **SPEC-IT-{HASH}.md** - Metadata system for progressive context loading

#### Skills (4 modes)

| Skill | Mode | User Approval | Best For |
|-------|------|---------------|----------|
| `/frontend-skills:spec-it` | Manual | Every chapter | Small projects, learning, maximum control |
| `/frontend-skills:spec-it-complex` | Hybrid | 4 milestones | Medium projects, balanced automation |
| `/frontend-skills:spec-it-automation` | Full Auto | Final only | Large projects, fast generation |
| `/frontend-skills:init-spec-md` | Utility | - | Generate SPEC-IT files for existing code |

#### Agents (15 total)

| Category | Agents |
|----------|--------|
| Core | `design-interviewer` (opus), `divergent-thinker` (sonnet), `chapter-critic` (opus), `chapter-planner` (opus), `ui-architect` (sonnet) |
| Component | `component-auditor` (haiku), `component-builder` (sonnet), `component-migrator` (sonnet) |
| Review | `critical-reviewer` (opus), `ambiguity-detector` (opus) |
| Test | `persona-architect` (sonnet), `test-spec-writer` (sonnet) |
| Utility | `spec-assembler` (haiku), `spec-md-generator` (haiku), `spec-md-maintainer` (haiku) |

#### Workflow

```
Input Analysis → Design Brainstorming → UI Architecture →
Component Discovery → Critical Review → Test Spec → Final Assembly
```

#### Output Structure

```
tmp/{session-id}/
├── 00-requirements/
├── 01-chapters/
├── 02-screens/
├── 03-components/
├── 04-review/
├── 05-tests/
└── 06-final/
```

#### Resources

- **Templates**: 16 templates for various specification documents
- **References**: ASCII wireframe guide, shadcn component list, test patterns
- **Hooks**: Cross-platform notification hooks (macOS/Windows/Linux)

#### Trigger Examples

- "프론트엔드 스펙 작성해줘" / "Write frontend spec"
- "이 PRD를 개발 명세로 변환해줘" / "Convert this PRD to dev spec"
- "UI 컴포넌트 설계 문서 만들어줘" / "Create UI component design doc"

---

### hack-2-prd

Analyze services/projects and systematically generate documentation:

- **PRD** (Product Requirements Document)
- **SPEC** (Feature Specifications)
- **PHASE** (Implementation Phases)
- **TASKS** (Task Lists)

#### Trigger Examples

- "PRD 작성해줘" / "Write a PRD"
- "문서화 해줘" / "Document this"
- "이 코드를 문서화해줘" / "Document this codebase"
- "웹사이트 분석해서 문서 만들어줘" / "Analyze this website and create docs"

#### Supported Input Sources

| Source | Description |
|--------|-------------|
| Website URL | Analyze via Chrome Extension data |
| Codebase | Analyze local project structure |
| Mobile App | Analyze from screenshots/descriptions |

#### Output Structure

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

## License

MIT
