---
name: init-spec-md
description: "Generate SPEC-IT-{HASH}.md files for existing UI code. Enables progressive context loading for legacy codebases. Use when starting to track an existing project."
allowed-tools: Read, Write, Glob, Grep, Bash, Task
argument-hint: "[path] [--dry-run] [--force]"
---

# init-spec-md: SPEC-IT File Generator for Existing Code

Generate `SPEC-IT-{HASH}.md` metadata files for existing UI code to enable **progressive context loading**.

---

## CRITICAL: Context Management Rules

**반드시 [shared/context-rules.md](../shared/context-rules.md) 규칙을 준수하세요.**

### 핵심 규칙

| 규칙 | 제한 | 위반 시 |
|------|------|---------|
| 배치 처리 | 10개 파일씩 | 메모리 초과 방지 |
| 에이전트 반환 | 요약만 | 내용 포함 금지 |
| 파일 읽기 | 필요한 것만 | 전체 스캔 금지 |

---

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

```bash
# 인자 파싱
targetPath = $1 || "."
dryRun = "--dry-run" in $ARGUMENTS
force = "--force" in $ARGUMENTS

Output: "대상 경로: {targetPath}, dry-run: {dryRun}, force: {force}"
```

### Step 2: Scan Target Directory

```bash
# Glob으로 파일 스캔
Glob("{targetPath}/**/page.tsx")      → pages[]
Glob("{targetPath}/**/layout.tsx")   → layouts[]
Glob("{targetPath}/**/*[A-Z]*.tsx")  → components[] (export default 포함)
Glob("{targetPath}/**/*Module.ts")   → modules[]
Glob("{targetPath}/**/*Service.ts")  → services[]

# 제외 패턴
exclude = ["node_modules/**", ".next/**", "dist/**"]

# 기존 SPEC-IT 파일 확인 (--force 아니면 스킵)
IF NOT force:
  existingSpecs = Glob("{targetPath}/**/SPEC-IT-*.md")
  # 해당 폴더의 파일은 스킵
```

### Step 3: 배치 처리로 SPEC-IT 생성

```
# 10개씩 배치로 처리 (컨텍스트 관리)
allFiles = pages + layouts + components + modules + services

FOR batch in chunks(allFiles, 10):
  Task(
    subagent_type: "general-purpose",
    model: "haiku",
    prompt: "
      역할: spec-md-generator

      입력 파일 목록:
      {batch}

      작업:
      1. 각 파일 분석 (Props, JSDoc, export 등)
      2. SPEC-IT-{HASH}.md 생성
      3. HASH = MD5(파일경로).substring(0,8).toUpperCase()

      출력: 각 파일과 같은 폴더에 SPEC-IT-{HASH}.md

      OUTPUT RULES:
      1. 파일에만 저장
      2. 반환 시 '생성됨: {경로}' 형식만
      3. 파일 내용 반환 금지
    "
  )
```

### Step 4: Registry 업데이트

```
Task(
  subagent_type: "general-purpose",
  model: "haiku",
  prompt: "
    역할: spec-md-maintainer

    작업:
    1. .spec-it-registry.json 읽기 (없으면 생성)
    2. 새로 생성된 SPEC-IT 파일들 등록
    3. parent-child 관계 설정
    4. 통계 업데이트

    OUTPUT RULES: (요약만 반환)
  "
)
```

### Step 5: 결과 보고

```
Output: "
═══════════════════════════════════════════════════════
  init-spec-md 완료
═══════════════════════════════════════════════════════

  생성됨: {created}개
    - Components: {components}개
    - Pages: {pages}개
    - Modules: {modules}개

  스킵됨: {skipped}개 (이미 존재)

  Registry: .spec-it-registry.json 업데이트됨

═══════════════════════════════════════════════════════
"
```

---

## Dry-Run Mode

`--dry-run` 사용 시:
- 파일 생성 없이 미리보기만
- 어떤 파일이 생성될지 목록 출력
- Registry 변경 없음

## Templates

Uses templates from the main spec-it skill:

- [SPEC_IT_COMPONENT_TEMPLATE.md](../spec-it/assets/templates/SPEC_IT_COMPONENT_TEMPLATE.md)
- [SPEC_IT_PAGE_TEMPLATE.md](../spec-it/assets/templates/SPEC_IT_PAGE_TEMPLATE.md)

## Related Skills

- `/frontend-skills:spec-it` - Manual specification generation
- `/frontend-skills:spec-it-complex` - Hybrid mode
- `/frontend-skills:spec-it-automation` - Full auto mode
