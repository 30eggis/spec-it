---
name: init-spec-md
description: "Generate SPEC-IT-{HASH}.md files for existing UI code. Enables progressive context loading for legacy codebases. Use when starting to track an existing project."
disable-model-invocation: true
allowed-tools: Read, Write, Glob, Grep, Bash
argument-hint: "[path] [--dry-run] [--force]"
---

# init-spec-md: SPEC-IT File Generator for Existing Code

Generate `SPEC-IT-{HASH}.md` metadata files for existing UI code to enable **progressive context loading**.

## Purpose

- **Progressive Context Loading**: Agents load only required context
- **Bidirectional Navigation**: Parent ↔ Child document links
- **Registry Management**: All HASHes managed in `.spec-it-registry.json`

## Usage

```bash
/frontend-skills:init-spec-md                    # Full project scan
/frontend-skills:init-spec-md src/components     # Specific path only
/frontend-skills:init-spec-md --dry-run          # Preview (no file creation)
/frontend-skills:init-spec-md --force            # Overwrite existing files
```

## Arguments

| Argument | Description |
|----------|-------------|
| `[path]` | Target directory (default: project root) |
| `--dry-run` | Preview mode, show what would be created |
| `--force` | Overwrite existing SPEC-IT files |

## Agents Used

- `spec-md-generator` (haiku) - Create SPEC-IT files
- `spec-md-maintainer` (haiku) - Update registry and links

## Workflow

```
┌─────────────────────────────────────────────────────────────────────┐
│  init-spec-md Workflow                                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Step 1: Project Scan                                               │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │  [Glob] **/*.tsx, **/*.ts                                  │    │
│  │  - Detect page.tsx, layout.tsx files                       │    │
│  │  - Detect component files (export default function)        │    │
│  │  - Detect module files                                     │    │
│  └────────────────────────────────────────────────────────────┘    │
│                              │                                      │
│                              ▼                                      │
│  Step 2: Check Existing SPEC-IT Files                              │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │  - Skip folders with existing SPEC-IT-*.md                 │    │
│  │  - Load .spec-it-registry.json                             │    │
│  │  - Check HASH collisions                                   │    │
│  └────────────────────────────────────────────────────────────┘    │
│                              │                                      │
│                              ▼                                      │
│  Step 3: Analyze Files (Parallel)                                  │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │  [spec-md-generator agent]                                 │    │
│  │  - Read file → Extract features                            │    │
│  │  - Parse Props interface                                   │    │
│  │  - Use JSDoc comments                                      │    │
│  │  - Generate ASCII wireframe (for components)               │    │
│  └────────────────────────────────────────────────────────────┘    │
│                              │                                      │
│                              ▼                                      │
│  Step 4: Generate SPEC-IT-{HASH}.md                                │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │  - Generate unique HASH                                    │    │
│  │  - Create file from template                               │    │
│  │  - Set up bidirectional links                              │    │
│  └────────────────────────────────────────────────────────────┘    │
│                              │                                      │
│                              ▼                                      │
│  Step 5: Update Registry                                           │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │  - Update .spec-it-registry.json                           │    │
│  │  - Set parent-child relationships                          │    │
│  │  - Update statistics                                       │    │
│  └────────────────────────────────────────────────────────────┘    │
│                              │                                      │
│                              ▼                                      │
│  Step 6: Output Report                                             │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │  Created: 45 files                                         │    │
│  │  - Components: 30                                          │    │
│  │  - Pages: 10                                               │    │
│  │  - Modules: 5                                              │    │
│  │  Skipped: 12 (already exist)                               │    │
│  └────────────────────────────────────────────────────────────┘    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

## HASH Generation Rules

```
Format: 8-character alphanumeric (e.g., A1B2C3D4)

Rules:
- Guaranteed unique within project
- Generated from file path hash
- All HASHes managed in .spec-it-registry.json

Examples:
- SPEC-IT-A1B2C3D4.md (Button component)
- SPEC-IT-E5F6G7H8.md (LoginPage)
- SPEC-IT-I9J0K1L2.md (AuthModule)
```

## Output Format

### Component (component.tsx)

```markdown
# SPEC-IT-A1B2C3D4

## Component: Button

### Description
Primary action button with loading state support.
- Click event handling
- Loading state display
- Disabled state support

### Props
| Prop | Type | Required | Description |
|------|------|----------|-------------|
| variant | 'primary' \| 'secondary' | N | Button style |
| loading | boolean | N | Loading state |
| disabled | boolean | N | Disabled |
| onClick | () => void | Y | Click handler |

### Wireframe (ASCII)
┌─────────────────────────┐
│  [Icon]  Button Text    │  ← Normal
└─────────────────────────┘

┌─────────────────────────┐
│  [Spinner] Loading...   │  ← Loading
└─────────────────────────┘

### Related Documents
- **Parent**: [SPEC-IT-E5F6G7H8](../SPEC-IT-E5F6G7H8.md)
- **Same Level**: [SPEC-IT-X1Y2Z3W4](./Input/SPEC-IT-X1Y2Z3W4.md)
```

### Page/Module (page.tsx, module.tsx)

```markdown
# SPEC-IT-E5F6G7H8

## Page: LoginPage

### Keywords
`auth` `login` `social-login` `password-reset` `signup-link`

### Features
- Email/password login
- Google/Kakao social login
- Password reset link
- Navigate to signup

### Folder IA
/login
├── components/
│   ├── LoginForm/          → [SPEC-IT-M1N2O3P4](./components/LoginForm/SPEC-IT-M1N2O3P4.md)
│   ├── SocialLoginButtons/ → [SPEC-IT-Q1R2S3T4](./components/SocialLoginButtons/SPEC-IT-Q1R2S3T4.md)
│   └── PasswordResetLink/  → [SPEC-IT-U1V2W3X4](./components/PasswordResetLink/SPEC-IT-U1V2W3X4.md)
├── hooks/
│   └── useLogin/           → [SPEC-IT-Y1Z2A3B4](./hooks/useLogin/SPEC-IT-Y1Z2A3B4.md)
└── utils/
    └── validation/         → [SPEC-IT-C1D2E3F4](./utils/validation/SPEC-IT-C1D2E3F4.md)

### Related Documents
- **Parent**: [SPEC-IT-ROOT001](../../SPEC-IT-ROOT001.md)
- **Related Page**: [SPEC-IT-G1H2I3J4](../signup/SPEC-IT-G1H2I3J4.md)
```

## Registry File Format

**`.spec-it-registry.json`** - Located at project root

```json
{
  "version": "1.0.0",
  "lastUpdated": "2026-01-29T15:00:00.000Z",
  "hashes": {
    "ROOT001": {
      "path": "src/SPEC-IT-ROOT001.md",
      "type": "root",
      "children": ["CMN00001", "E5F6G7H8"]
    },
    "A1B2C3D4": {
      "path": "src/components/common/Button/SPEC-IT-A1B2C3D4.md",
      "type": "component",
      "parent": "CMN00001",
      "file": "Button.tsx"
    }
  },
  "stats": {
    "totalFiles": 45,
    "components": 30,
    "pages": 10,
    "modules": 5
  }
}
```

## Execution Instructions

### Step 1: Parse Arguments

```
$ARGUMENTS parsing:
- $0: path (default: ".")
- Check for --dry-run flag
- Check for --force flag
```

### Step 2: Scan Target Directory

```
Use Glob to find:
- **/page.tsx, **/layout.tsx → Page type
- **/*[A-Z]*.tsx with "export default" → Component type
- **/*Module.ts, **/*Service.ts → Module type

Exclude:
- node_modules/
- .next/
- dist/
- Files with existing SPEC-IT-*.md in same folder (unless --force)
```

### Step 3: Generate SPEC-IT Files

For each detected file:

```
Delegate to: spec-md-generator
Input: File path, type, existing registry
Output: SPEC-IT-{HASH}.md in same folder
```

### Step 4: Update Registry

```
Delegate to: spec-md-maintainer
Actions:
- Add new entries to registry
- Set parent-child relationships
- Update statistics
```

### Step 5: Report Results

```
Output format:
═══════════════════════════════════════════════════════
  init-spec-md Complete
═══════════════════════════════════════════════════════

  Created: 45 files
    - Components: 30
    - Pages: 10
    - Modules: 5

  Skipped: 12 files (already exist)

  Registry: .spec-it-registry.json updated

═══════════════════════════════════════════════════════
```

## Templates

Uses templates from the main spec-it skill:

- [SPEC_IT_COMPONENT_TEMPLATE.md](../spec-it/assets/templates/SPEC_IT_COMPONENT_TEMPLATE.md)
- [SPEC_IT_PAGE_TEMPLATE.md](../spec-it/assets/templates/SPEC_IT_PAGE_TEMPLATE.md)

## Related Skills

- `/frontend-skills:spec-it` - Manual specification generation
- `/frontend-skills:spec-it-complex` - Hybrid mode
- `/frontend-skills:spec-it-automation` - Full auto mode
