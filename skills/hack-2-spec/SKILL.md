---
name: hack-2-spec
description: |
  Analyze services/projects and generate Spec documents.
  Supports website URLs and local codebases.
  Output format compatible with spec-it.
argument-hint: "[--source <path|url>] [--output <dir>] [--designContext <path>]"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion
permissionMode: bypassPermissions
---

# Hack 2 Spec

Analyze services/projects and generate spec-it compatible documentation.

## Output Structure

**Output folder:** `{output}/hack-2-spec/`

```
{output}/hack-2-spec/
├── requirements/requirements.md         # 요구사항 정의서
├── chapters/chapter-plan.md             # 챕터 계획
├── wireframes/
│   ├── layouts/layout-system.yaml       # 레이아웃 시스템
│   ├── domain-map.md                    # 도메인 → 사용자 유형 매핑
│   ├── screen-list.md                   # 전체 화면 목록
│   └── <user-type>/<domain>/wireframes/{screen-id}.yaml
├── persona/personas.md                  # 사용자 페르소나
└── components/
    ├── inventory.md                     # 컴포넌트 인벤토리
    └── specs/{ComponentName}.yaml       # 개별 컴포넌트 스펙
```

---

## Reference Documents

| When you need to... | Read this |
|---------------------|-----------|
| **Progressive generation details** | `shared/references/hack-2-spec/progressive-generation.md` |
| **CSS extraction script** | `shared/references/hack-2-spec/css-extraction.md` |
| **Layout extraction rules** | `shared/references/common/rules/07-layout-extraction-rules.md` |
| **Output quality standards** | `shared/references/common/rules/06-output-quality.md` |
| **Template index** | `shared/templates/common/_INDEX.md` |
| Parse token formats | `shared/references/common/design-token-parser.md` |

---

## Workflow Overview

```
[Step 1: Source] → [Step 2: Language] → [Step 2.5: Design Context] → [Step 3: Progressive Analyze & Generate] → [Step 4: Finalize] → [Step 5: Verify]
```

### Progressive Generation (Core Concept)

> **상세 내용**: `shared/references/hack-2-spec/progressive-generation.md`

**매 화면을 읽을 때마다 병렬로 3가지 파일을 즉시 생성:**

| Question | Output | Method |
|----------|--------|--------|
| Q1: 어떤 서비스? | `requirements.md` | APPEND |
| Q2: 누구를 위한? | `personas.md` | APPEND |
| Q3: 어떻게 생김? | `{screen-id}.yaml` | CREATE |

**Benefits:**
- Context 압축 대비 - 즉시 저장
- 리프레쉬 대비 - 부분 완료 상태에서 재개 가능
- 병렬 처리 - 3개 Task agent 동시 실행

---

## Step 1: Identify Input Source

| Source Type | Requirements | Proceed When |
|-------------|--------------|--------------|
| **Website** | URL, Chrome MCP | a11y tree collected |
| **Code** | Project path | Files readable |

**Fallback**: Website fails → Code Analysis → Error (ask user)

---

## Step 2: Ask Language Preference

```
Which language for output documents?
- English
- Korean (한국어)
- Other
```

---

## Step 2.5: Ask Design Context

```
Do you have a design system document to reference?
- Yes, I have design tokens (Figma, Style Dictionary, etc.)
- Yes, I have a design guideline document
- No, analyze without design context
```

---

## Step 3: Progressive Analyze & Generate

> **CSS 추출 스크립트**: `shared/references/hack-2-spec/css-extraction.md`
> **레이아웃 규칙**: `shared/references/common/rules/07-layout-extraction-rules.md`

### 3.1 For Website (Chrome MCP)

```
FOR each screen:
  1. navigate_page(url)
  2. take_snapshot() → a11y tree
  3. evaluate_script() → CSS layout (CRITICAL!)
  4. Merge a11y + CSS → screen_data
  5. [Parallel] Generate Q1, Q2, Q3
```

### 3.2 For Codebase (Fallback)

```
FOR each page file:
  1. Read file content
  2. Parse JSX/HTML structure
  3. Extract layout patterns
  4. [Parallel] Generate Q1, Q2, Q3
```

### 3.3 Parallel Generation (Per Screen)

> **상세 형식**: `shared/references/hack-2-spec/progressive-generation.md`

**즉시 3개 Task agent 병렬 실행:**

```python
Task(prompt="Q1: Requirements → APPEND requirements.md")
Task(prompt="Q2: Persona → APPEND personas.md")
Task(prompt="Q3: Wireframe → CREATE {screen-id}.yaml")
```

**Templates:**
- Q1: `shared/templates/common/00-REQUIREMENTS_TEMPLATE.md`
- Q2: `shared/templates/common/01-PERSONA_TEMPLATE.md`
- Q3: `shared/templates/common/02-WIREFRAME_YAML_TEMPLATE.yaml`

---

## Step 4: Finalize (After All Screens)

### 4.1 Consolidate Appended Files

```
1. 중복 제거
2. ID 정규화 (순차 번호 부여)
3. 우선순위 정렬 (P0 > P1 > P2)
4. 프로젝트 개요 추가
```

### 4.2 Generate Summary Files

| File | Template |
|------|----------|
| `chapters/chapter-plan.md` | `01-CHAPTER_PLAN_TEMPLATE.md` |
| `wireframes/layouts/layout-system.yaml` | `02-LAYOUT_SYSTEM_TEMPLATE.yaml` |
| `wireframes/domain-map.md` | `02-DOMAIN_MAP_TEMPLATE.md` |
| `wireframes/screen-list.md` | `02-SCREEN_LIST_TEMPLATE.md` |
| `components/inventory.md` | `03-COMPONENT_INVENTORY_TEMPLATE.md` |
| `components/specs/*.yaml` | `02-COMPONENTS_YAML_TEMPLATE.yaml` |

---

## Step 5: Verify Output (MANDATORY)

```
CHECK: {output}/hack-2-spec/
├── requirements/requirements.md         ✓ (Step 3 append → Step 4 consolidate)
├── chapters/chapter-plan.md             ✓ (Step 4)
├── wireframes/
│   ├── layouts/layout-system.yaml       ✓ (Step 4)
│   ├── domain-map.md                    ✓ (Step 4)
│   ├── screen-list.md                   ✓ (Step 4)
│   └── **/wireframes/{screen-id}.yaml   ✓ (Step 3 - 즉시!)
├── persona/personas.md                  ✓ (Step 3 append → Step 4 consolidate)
└── components/
    ├── inventory.md                     ✓ (Step 4)
    └── specs/*.yaml                     ✓ (Step 4)
```

---

## Output Checklist

| Category | File | Step | Required |
|----------|------|------|----------|
| **즉시 생성 (Step 3)** ||||
| Wireframes | `wireframes/**/wireframes/*.yaml` | 3 | ✓ MUST (1 per screen) |
| Requirements | `requirements/requirements.md` | 3 (append) | ✓ MUST |
| Persona | `persona/personas.md` | 3 (append) | ✓ MUST |
| **후처리 (Step 4)** ||||
| Chapters | `chapters/chapter-plan.md` | 4 | ✓ MUST |
| Wireframes | `wireframes/layouts/*.yaml` | 4 | ✓ MUST |
| Wireframes | `wireframes/domain-map.md` | 4 | ✓ MUST |
| Wireframes | `wireframes/screen-list.md` | 4 | ✓ MUST |
| Components | `components/inventory.md` | 4 | ✓ MUST |
| Components | `components/specs/*.yaml` | 4 | ✓ MUST (1 per component) |

---

## Final Response Format

```
Done. Generated hack-2-spec output:

📁 {output}/hack-2-spec/

Step 3 (즉시 생성):
├── wireframes/**/wireframes/ [N screens]
├── requirements/requirements.md (appended)
└── persona/personas.md (appended)

Step 4 (후처리):
├── chapters/chapter-plan.md
├── wireframes/{layouts, domain-map, screen-list}
└── components/{inventory, specs/}

Total: XX files (N screens + M components + 7 summary files)
```
