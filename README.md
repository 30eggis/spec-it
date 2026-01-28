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
