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

#### Commands

| Command | Mode | Description |
|---------|------|-------------|
| `/frontend-skills:spec-it` | Manual | All chapters require user approval |
| `/frontend-skills:spec-it-complex` | Hybrid | Auto-validation + major milestone approval |
| `/frontend-skills:spec-it-automation` | Full Auto | Multi-agent validation, single final approval |
| `/frontend-skills:init-spec-md` | Utility | Create SPEC-IT files for existing code |

#### Agents (15 total)

**Core Agents**
- `design-interviewer` (opus) - Brainstorming Q&A facilitator
- `divergent-thinker` (sonnet) - Divergent thinking for alternatives
- `chapter-critic` (opus) - Critical validation
- `chapter-planner` (opus) - Chapter structure finalization
- `ui-architect` (sonnet) - Wireframe design

**Component Agents**
- `component-auditor` (haiku) - Component scanning and inventory
- `component-builder` (sonnet) - Component specification
- `component-migrator` (sonnet) - Component migration planning

**Review Agents**
- `critical-reviewer` (opus) - Scenario/IA/exception review
- `ambiguity-detector` (opus) - Ambiguity detection

**Test Agents**
- `persona-architect` (sonnet) - Persona definition
- `test-spec-writer` (sonnet) - Test specification

**Utility Agents**
- `spec-assembler` (haiku) - Final assembly
- `spec-md-generator` (haiku) - SPEC-IT creation
- `spec-md-maintainer` (haiku) - SPEC-IT maintenance

#### Workflow

```
Phase 0: Input Analysis
    ↓
Phase 1: Design Brainstorming (Interactive + Validation)
    ↓
Phase 2: UI Architecture (ASCII Wireframes)
    ↓
Phase 3: Component Discovery & Migration
    ↓
Phase 4: Critical Review
    ↓
Phase 5: Persona & Scenario Test Spec
    ↓
Phase 6: Final Assembly
```

#### Output Structure

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

#### Trigger Examples

- "프론트엔드 스펙 작성해줘" / "Write frontend spec"
- "이 PRD를 개발 명세로 변환해줘" / "Convert this PRD to dev spec"
- "UI 컴포넌트 설계 문서 만들어줘" / "Create UI component design doc"
- "시나리오 테스트 명세 생성해줘" / "Generate scenario test spec"

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
