---
name: hack-2-spec
description: |
  Analyze services/projects and generate Spec documents.
  Supports website URLs, local codebases, and mobile apps.
  Output format compatible with spec-it.
argument-hint: "[--source <path|url>] [--output <dir>] [--designContext <path>]"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion
permissionMode: bypassPermissions
---

# Hack 2 Spec

Analyze services/projects and generate spec-it compatible documentation.

## Output Structure (MANDATORY)

**Output folder:** `{output}/hack-2-spec/`

```
{output}/hack-2-spec/
├── requirements/
│   └── requirements.md              # 요구사항 정의서
├── chapters/
│   └── chapter-plan.md              # 챕터 계획
├── wireframes/
│   ├── layouts/layout-system.yaml   # 레이아웃 시스템
│   ├── domain-map.md                # 도메인 → 사용자 유형 매핑
│   ├── screen-list.md               # 전체 화면 목록 (점진적 로딩용)
│   └── <user-type>/<domain>/
│       └── wireframes/
│           └── {screen-id}.yaml     # 개별 화면 와이어프레임
├── persona/
│   └── personas.md                  # 사용자 페르소나 정의
└── components/
    ├── inventory.md                 # 컴포넌트 인벤토리
    └── specs/
        └── {ComponentName}.yaml     # 개별 컴포넌트 스펙
```

---

## Reference Documents

| When you need to... | Read this |
|---------------------|-----------|
| **Output quality standards** | `shared/references/common/rules/06-output-quality.md` |
| **Template index** | `shared/templates/common/_INDEX.md` |
| Parse token formats | `shared/references/common/design-token-parser.md` |
| Tailwind layout rules | `shared/references/common/rules/05-vercel-skills.md` |

---

## Workflow

```
[Step 1: Source] → [Step 2: Language] → [Step 2.5: Design Context] → [Step 3: Analyze] → [Step 4-8: Generate] → [Step 9: Verify]
```

---

## Step 1: Identify Input Source

| Source Type | Requirements | Proceed When |
|-------------|--------------|--------------|
| **Website** | URL, Chrome MCP | a11y tree collected |
| **Code** | Project path | Files readable |
| **Mobile App** | Screenshots | Images analyzed |

---

## Step 2: Ask Language Preference

```
Which language for output documents?
- English
- Korean (한국어)
- Other
```

---

## Step 2.5: Ask Design Context (IMPORTANT)

디자인 시스템 문서가 있으면 HTML/코드 해석이 훨씬 정확해집니다.

```
Do you have a design system document to reference?
- Yes, I have design tokens (Figma, Style Dictionary, etc.)
- Yes, I have a design guideline document
- No, analyze without design context
```

### If Design Context Provided

| Format | How to Use |
|--------|-----------|
| **Figma Tokens** | Export as JSON, provide path |
| **Style Dictionary** | Provide tokens.json path |
| **Design Guideline** | Provide .md or .pdf path |
| **Tailwind Config** | Provide tailwind.config.js path |
| **Custom CSS Variables** | Provide CSS file path |

**When design context is available:**
1. Load and parse design tokens
2. Map CSS values to design tokens during analysis
3. Use token references in wireframe output: `_ref:color.primary.500`
4. Match component styles to design system variants

**Example with design context:**
```yaml
# Without design context
styles:
  background: "bg-blue-600"
  padding: "p-6"

# With design context (more accurate)
styles:
  background: "_ref:color.semantic.bg.brand.primary"
  padding: "_ref:spacing.24"
```

> **For token parsing details:** Read `shared/references/common/design-token-parser.md`

---

## Step 3: Analyze Source

### 3.1 For Website/HTML Mockups (Chrome MCP)

```
FOR each HTML file:
  1. navigate_page(url)
  2. take_snapshot() → collect a11y tree
  3. Extract:
     - Screen title, route
     - Layout structure (sidebar, header, main)
     - All components (buttons, inputs, tables, cards, charts)
     - Interactions (clicks, filters, forms)
     - Status indicators (badges, tags, progress)
  4. Save analysis to JSON
```

### 3.2 For Codebase

```
1. Glob for pages/routes
2. Read component files
3. Extract props, states, events
4. Map dependencies
```

### 3.3 Apply Design Context (if provided)

```
IF design context provided:
  1. Load design tokens from provided path
  2. Build token-to-CSS mapping
  3. During component extraction:
     - Match colors to color tokens
     - Match spacing to spacing tokens
     - Match typography to font tokens
     - Match borders/shadows to effect tokens
  4. Store token references for wireframe generation
```

**Layout Rules:**
- `grid-cols-3` → 3 columns, NOT 2
- Same-row elements stay in same grid area row
- Map responsive prefixes (`lg:`, `md:`, `sm:`) separately

---

## Step 4: Generate requirements/

**File:** `requirements/requirements.md`
**Template:** `shared/templates/common/00-REQUIREMENTS_TEMPLATE.md`

**Must Include:**
- [ ] Project overview, vision, objectives
- [ ] User types and roles
- [ ] User stories by role (ID format: US-{ROLE}-###)
- [ ] Functional requirements by domain (ID format: REQ-{DOMAIN}-###)
- [ ] Non-functional requirements
- [ ] MVP scope (P0/P1/P2)

---

## Step 5: Generate persona/

**File:** `persona/personas.md`
**Template:** `shared/templates/common/01-PERSONA_TEMPLATE.md`

**Must Include:**
- [ ] User type definitions (Role, Local Term, Description)
- [ ] Access levels per user type
- [ ] Key tasks per user type
- [ ] User type comparison matrix

---

## Step 6: Generate chapters/

**File:** `chapters/chapter-plan.md`
**Template:** `shared/templates/common/01-CHAPTER_PLAN_TEMPLATE.md`

**Must Include:**
- [ ] Chapter overview table
- [ ] Each chapter: scope, deliverables, dependencies
- [ ] Implementation order diagram
- [ ] Risk assessment

---

## Step 7: Generate wireframes/

### 7.1 Layout System

**File:** `wireframes/layouts/layout-system.yaml`
**Template:** `shared/templates/common/02-LAYOUT_SYSTEM_TEMPLATE.yaml`

### 7.2 Domain Map

**File:** `wireframes/domain-map.md`
**Template:** `shared/templates/common/02-DOMAIN_MAP_TEMPLATE.md`

**Must Include:**
- [ ] Domain list with screen counts
- [ ] User type definitions
- [ ] Domain details with screens
- [ ] User type → screen mapping
- [ ] Navigation flows
- [ ] URL routing structure

### 7.3 Screen List (전체 화면 목록)

**File:** `wireframes/screen-list.md`
**Template:** `shared/templates/common/02-SCREEN_LIST_TEMPLATE.md`

**Must Include:**
- [ ] All screens by user type
- [ ] Screen ID, name, route, description
- [ ] Key components per screen
- [ ] Common components section
- [ ] Screen flow diagram

### 7.4 Individual Screen Wireframes (CRITICAL)

**Location:** `wireframes/<user-type>/<domain>/wireframes/{screen-id}.yaml`
**Template:** `shared/templates/common/02-WIREFRAME_YAML_TEMPLATE.yaml`

**MUST generate one YAML file for EACH screen.**

```yaml
# Example: wireframes/hr-admin/dashboard/wireframes/SCR-HR-001.yaml
id: "SCR-HR-001"
name: "HR Dashboard"
route: "/dashboard"
type: "page"
priority: "P0"
accessLevel: "hr-admin"

layout:
  type: "dashboard-with-sidebar"
  # ... layout details

grid:
  desktop:
    columns: "..."
    areas: |
      "..."

components:
  - id: "stat-cards"
    type: "StatCardGrid"
    # ... component details

interactions:
  # ... interaction details

states:
  # ... state definitions
```

**Use Task agents for parallel generation:**
```
Task(subagent_type="general-purpose", prompt="Generate wireframe YAML for SCR-HR-001...")
Task(subagent_type="general-purpose", prompt="Generate wireframe YAML for SCR-HR-002...")
# ... parallel execution
```

---

## Step 8: Generate components/

### 8.1 Component Inventory

**File:** `components/inventory.md`
**Template:** `shared/templates/common/03-COMPONENT_INVENTORY_TEMPLATE.md`

**Must Include:**
- [ ] Components by category (Layout, Data Display, Input, Action, Feedback, Widget)
- [ ] Component ID, name, description, used-in
- [ ] Shared component library structure

### 8.2 Individual Component Specs (CRITICAL)

**Location:** `components/specs/{ComponentName}.yaml`
**Template:** `shared/templates/common/02-COMPONENTS_YAML_TEMPLATE.yaml`

**MUST generate one YAML file for EACH significant component.**

Significant components (generate specs for these):
- Layout: AppShell, Sidebar, Header
- Data Display: StatCard, DataTable, StatusBadge, ProgressBar, Charts
- Input: FilterBar, DateRangePicker, Select, Toggle
- Feedback: Toast, Modal, Alert
- Widget: TimeClock, WeeklySummary, LeaveBalance, etc.

```yaml
# Example: components/specs/DataTable.yaml
id: "CMP-DATA-002"
name: "DataTable"
category: "data-display"
description: "데이터 테이블 (정렬, 선택, 페이지네이션)"

props:
  - name: "columns"
    type: "Column[]"
    required: true
    description: "테이블 컬럼 정의"
  - name: "data"
    type: "any[]"
    required: true
  # ...

variants:
  - name: "default"
    description: "기본 테이블"
  - name: "selectable"
    description: "행 선택 가능"

states:
  - name: "loading"
    description: "데이터 로딩 중"
  - name: "empty"
    description: "데이터 없음"
  - name: "error"
    description: "에러 상태"

styles:
  container: "overflow-x-auto"
  header: "bg-slate-50 sticky top-0"
  # ...
```

---

## Step 9: Verify Output (MANDATORY)

Before completing, verify ALL required files exist:

```
CHECK: {output}/hack-2-spec/
├── requirements/
│   └── requirements.md              ✓ (must exist, 200+ lines)
├── chapters/
│   └── chapter-plan.md              ✓ (must exist)
├── wireframes/
│   ├── layouts/layout-system.yaml   ✓ (must exist)
│   ├── domain-map.md                ✓ (must exist)
│   ├── screen-list.md               ✓ (must exist)
│   └── <user-type>/<domain>/wireframes/
│       └── {screen-id}.yaml         ✓ (one per screen!)
├── persona/
│   └── personas.md                  ✓ (must exist)
└── components/
    ├── inventory.md                 ✓ (must exist)
    └── specs/
        └── {ComponentName}.yaml     ✓ (one per significant component!)
```

**Verification Command:**
```bash
find {output}/hack-2-spec -type f \( -name "*.md" -o -name "*.yaml" \) | wc -l
# Expected: At least (1 + 1 + 3 + N_screens + 1 + 1 + M_components) files
```

---

## Output Checklist

| Category | File | Required |
|----------|------|----------|
| Requirements | `requirements/requirements.md` | ✓ MUST |
| Chapters | `chapters/chapter-plan.md` | ✓ MUST |
| Wireframes | `wireframes/layouts/layout-system.yaml` | ✓ MUST |
| Wireframes | `wireframes/domain-map.md` | ✓ MUST |
| Wireframes | `wireframes/screen-list.md` | ✓ MUST |
| Wireframes | `wireframes/<user-type>/<domain>/wireframes/*.yaml` | ✓ MUST (1 per screen) |
| Persona | `persona/personas.md` | ✓ MUST |
| Components | `components/inventory.md` | ✓ MUST |
| Components | `components/specs/*.yaml` | ✓ MUST (1 per component) |

---

## Final Response Format

```
Done. Generated hack-2-spec output:

📁 {output}/hack-2-spec/
├── requirements/requirements.md (XXX lines)
├── chapters/chapter-plan.md (XXX lines)
├── wireframes/
│   ├── layouts/layout-system.yaml (XXX lines)
│   ├── domain-map.md (XXX lines)
│   ├── screen-list.md (XXX lines)
│   └── [N] screen wireframes generated
├── persona/personas.md (XXX lines)
└── components/
    ├── inventory.md (XXX lines)
    └── [M] component specs generated

Total: XX files, XXXX lines
```
