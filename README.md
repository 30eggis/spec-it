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
