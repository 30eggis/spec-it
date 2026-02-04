# Design Trends 2026 - spec-it Integration Guide

이 문서는 `design-trends-2026` skill을 spec-it 시리즈(stepbystep, complex, automation)와 spec-it-execute에 통합하는 방법을 정의합니다.

---

## 1. 통합 개요

```
┌─────────────────────────────────────────────────────────────────────┐
│                     SPEC GENERATION PHASE                           │
│  (spec-it-stepbystep / spec-it-complex / spec-it-automation)        │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Phase 0: Design Style Selection                                    │
│    └─ AskUserQuestion: "Select design style"                        │
│       Options: [Minimal, Immersive, Organic, Custom]                │
│                                                                     │
│  Phase 2: UI Architecture                                           │
│    └─ ui-architect agent                                            │
│       └─ MUST READ: design-trends-2026/references/                  │
│          - trends-summary.md                                        │
│          - component-patterns.md                                    │
│       └─ OUTPUT: Design Direction section in each wireframe         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     EXECUTION PHASE                                  │
│  (spec-it-execute)                                                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Phase 3: EXECUTE                                                    │
│    └─ spec-executor agent                                           │
│       └─ MUST READ: design-trends-2026/templates/                   │
│          - dashboard-templates.md                                   │
│          - card-templates.md                                        │
│          - form-templates.md                                        │
│          - navigation-templates.md                                  │
│       └─ Apply Tailwind/CSS patterns from templates                 │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. Phase 0 추가: Design Style Selection

### 모든 spec-it 변형에 추가

Phase 0.0 (UI Mode Selection) 이후에 추가:

```
### Step 0.0b: Design Style Selection

AskUserQuestion(
  questions: [{
    question: "어떤 디자인 스타일을 적용하시겠습니까?",
    header: "Design Style",
    options: [
      {
        label: "Minimal (Recommended)",
        description: "깔끔하고 전문적인 SaaS 스타일. 밝은 테마, 미니멀 카드"
      },
      {
        label: "Immersive",
        description: "Dark mode, 그라데이션 카드, 풍부한 시각 효과"
      },
      {
        label: "Organic",
        description: "부드러운 곡선, Glassmorphism, 3D 요소"
      },
      {
        label: "Custom",
        description: "직접 스타일 조합 선택"
      }
    ]
  }]
)

IF "Custom":
  AskUserQuestion(
    questions: [{
      question: "적용할 트렌드를 선택하세요 (복수 선택 가능)",
      header: "Trends",
      multiSelect: true,
      options: [
        {label: "Light Skeuomorphism", description: "부드러운 그림자, 입체감"},
        {label: "Glassmorphism", description: "반투명 배경, blur 효과"},
        {label: "Dark Mode+", description: "다크 테마 + 그라데이션"},
        {label: "Micro-Animations", description: "의미있는 모션 효과"},
        {label: "3D Visuals", description: "3D 아이콘, WebGL 요소"},
        {label: "Data Visualization", description: "인터랙티브 차트"}
      ]
    }]
  )

# Save to _meta.json
_meta.designStyle = selectedStyle
_meta.designTrends = selectedTrends (if Custom)
Update(_meta.json)
```

---

## 3. ui-architect Agent 프롬프트 수정

### 기존 프롬프트에 추가할 내용

```
Task(
  subagent_type: "general-purpose",
  model: "sonnet",
  prompt: "
    Role: ui-architect

    === DESIGN TRENDS REFERENCE (REQUIRED) ===

    Before creating wireframes, you MUST read these files:

    1. Read: $SKILLS_PATH/design-trends-2026/references/trends-summary.md
       → Understand all 12 design trends

    2. Read: $SKILLS_PATH/design-trends-2026/references/component-patterns.md
       → Get component implementation patterns

    3. Read: $SKILLS_PATH/design-trends-2026/references/color-systems.md
       → Get color palette guidelines

    Selected Design Style: {_meta.designStyle}
    Selected Trends: {_meta.designTrends}

    === DESIGN DIRECTION REQUIREMENTS ===

    Each wireframe MUST include a 'Design Direction' section with:

    ## Design Direction

    ### Applied Trends
    - Primary: {trend name} - {how it applies to this screen}
    - Secondary: {trend name} - {specific elements}

    ### Component Patterns
    Reference: design-trends-2026/references/component-patterns.md

    | Component | Pattern | Template Reference |
    |-----------|---------|-------------------|
    | Sidebar   | sidebar-gradient | navigation-templates.md#type-c |
    | KPI Cards | gradient-kpi-card | card-templates.md#type-a |
    | Table     | clean-table-avatars | dashboard-templates.md#pattern-a |

    ### Color Tokens
    Based on: design-trends-2026/references/color-systems.md

    Primary: #3B82F6 (Blue)
    Status Colors:
    - Success: #10B981
    - Warning: #F59E0B
    - Error: #EF4444

    ### Motion Guidelines
    Reference: design-trends-2026/references/motion-presets.md

    - Page Transition: fadeSlideUp (200ms)
    - Card Hover: hover-lift
    - Button Press: scale 0.98

    === OUTPUT ===

    Output: {spec-folder}/02-wireframes/<user-type>/<domain>/wireframes/{screen-id}.yaml
    Output: {spec-folder}/02-wireframes/layouts/layout-{name}.yaml

    OUTPUT RULES: (standard)
  "
)
```

---

## 4. spec-executor Agent 프롬프트 수정

### Phase 3: EXECUTE에서 사용

```
Task(
  subagent_type: "general-purpose",
  model: model,  # opus or sonnet based on complexity
  prompt: "
    Role: spec-executor

    Task: {task.name}
    Files: {task.files}
    Spec Reference: {task.spec_ref}

    === DESIGN IMPLEMENTATION REFERENCE (REQUIRED) ===

    Before implementing UI components, you MUST read:

    1. Read: $SKILLS_PATH/design-trends-2026/templates/dashboard-templates.md
       → Full dashboard layout patterns with Tailwind

    2. Read: $SKILLS_PATH/design-trends-2026/templates/card-templates.md
       → Card component implementations

    3. Read: $SKILLS_PATH/design-trends-2026/templates/form-templates.md
       → Form and input patterns

    4. Read: $SKILLS_PATH/design-trends-2026/templates/navigation-templates.md
       → Sidebar and navigation patterns

    5. Read: $SKILLS_PATH/design-trends-2026/references/motion-presets.md
       → Animation configurations

    === DESIGN DIRECTION FROM WIREFRAME ===

    Read the 'Design Direction' section from the wireframe spec:
    {wireframe_path}

    Extract:
    - Applied Trends
    - Component Patterns (with template references)
    - Color Tokens
    - Motion Guidelines

    === IMPLEMENTATION RULES ===

    1. Match the template exactly from design-trends-2026/templates/
    2. Use Tailwind classes from the templates
    3. Apply motion presets using Framer Motion
    4. Follow color tokens defined in wireframe
    5. Include dark mode support if specified

    Example Implementation Flow:
    ```
    IF component == 'Sidebar':
      Read: design-trends-2026/templates/navigation-templates.md
      Find: Pattern matching wireframe's 'sidebar-gradient'
      Copy: Tailwind classes and structure
      Adapt: Labels, icons, routes for this project
    ```

    === OUTPUT ===

    Output: Implementation files as specified in task
    Log: .spec-it/execute/{sessionId}/logs/task-{task.id}.md

    OUTPUT RULES:
    1. Write implementation to specified files
    2. Include comments referencing template source
    3. Return: 'Done. Task {id}: {status}. Files: {count}'
  "
)
```

---

## 5. Style Presets 정의

### _meta.json에 저장되는 스타일 프리셋

```json
{
  "designStyle": "minimal",
  "designPresets": {
    "minimal": {
      "theme": "light",
      "cardStyle": "clean-border",
      "sidebarStyle": "light-sections",
      "buttonStyle": "solid-rounded",
      "tableStyle": "clean-avatars",
      "trends": ["minimalism", "accessibility-core", "micro-animations"]
    },
    "immersive": {
      "theme": "dark",
      "cardStyle": "gradient-kpi",
      "sidebarStyle": "dark-icon-only",
      "buttonStyle": "gradient-glow",
      "tableStyle": "dark-hover",
      "trends": ["dark-mode-plus", "data-visualization", "gamification"]
    },
    "organic": {
      "theme": "light",
      "cardStyle": "organic-glass",
      "sidebarStyle": "glass-nav",
      "buttonStyle": "neo-soft",
      "tableStyle": "organic-rows",
      "trends": ["organic-shapes", "light-skeuomorphism", "3d-visuals"]
    }
  }
}
```

---

## 6. Template Reference 매핑

### Component → Template 매핑 테이블

| Wireframe Component | Minimal Template | Immersive Template | Organic Template |
|---------------------|-----------------|-------------------|-----------------|
| **Sidebar** | sidebar-full (light) | sidebar-icon (dark) | sidebar-glass |
| **Header** | header-welcome | header-status | header-tabs |
| **KPI Card** | stat-icon-card | gradient-kpi-card | organic-card |
| **Data Table** | doctor-table | transaction-list (dark) | user-row-card |
| **Form Input** | form-input (default) | search-input-dark | neo-input |
| **Button Primary** | button.primary | button.primaryOrange | neo-button |
| **Status Badge** | status-badge | status-dot (glow) | availability-badges |
| **Chart** | multi-line-chart | area-chart-dark | donut-chart-stats |
| **Message List** | message-preview-card | - | message-preview-card |
| **Profile Card** | employee-card | - | pricing-3d-card |

---

## 7. 워크플로우 다이어그램

### spec-it → execute 전체 흐름

```
┌────────────────────────────────────────────────────────────────────┐
│ spec-it-* (stepbystep / complex / automation)                       │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  [Phase 0.0b] Design Style Selection                               │
│       │                                                            │
│       ▼                                                            │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ _meta.json                                                  │   │
│  │ {                                                           │   │
│  │   "designStyle": "immersive",                               │   │
│  │   "designTrends": ["dark-mode-plus", "micro-animations"]    │   │
│  │ }                                                           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│       │                                                            │
│       ▼                                                            │
│  [Phase 2] ui-architect                                            │
│       │                                                            │
│       ├─── Read: design-trends-2026/references/*                   │
│       │                                                            │
│       ▼                                                            │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ 02-wireframes/<user-type>/<domain>/wireframes/*.yaml         │   │
│  │                                                             │   │
│  │ ## Design Direction                                         │   │
│  │ ### Applied Trends                                          │   │
│  │ - Primary: Dark Mode+ (gradient cards, dark bg)             │   │
│  │ - Secondary: Micro-Animations (button feedback)             │   │
│  │                                                             │   │
│  │ ### Component Patterns                                      │   │
│  │ | Component | Pattern | Template |                          │   │
│  │ | Sidebar | sidebar-icon | nav-templates#type-b |           │   │
│  │ | KPI Card | gradient-kpi | card-templates#type-a |         │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────────┐
│ spec-it-execute                                                     │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  [Phase 3] spec-executor                                           │
│       │                                                            │
│       ├─── Read: _meta.json → designStyle                          │
│       │                                                            │
│       ├─── Read: wireframe → Design Direction section              │
│       │                                                            │
│       ├─── Read: design-trends-2026/templates/*                    │
│       │    (Based on Component Patterns table)                     │
│       │                                                            │
│       ▼                                                            │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │ Implementation                                              │   │
│  │                                                             │   │
│  │ // components/layout/sidebar.tsx                            │   │
│  │ // Template: design-trends-2026/navigation-templates#type-b │   │
│  │ export function Sidebar() {                                 │   │
│  │   return (                                                  │   │
│  │     <aside className="w-[72px] h-screen bg-[#1e2a4a]        │   │
│  │                       flex flex-col items-center py-4">     │   │
│  │       ...                                                   │   │
│  │     </aside>                                                │   │
│  │   );                                                        │   │
│  │ }                                                           │   │
│  └─────────────────────────────────────────────────────────────┘   │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

---

## 8. 환경 변수

### $SKILLS_PATH 설정

```bash
# In session-init.sh or at the start of spec-it
export SKILLS_PATH="$HOME/.claude/plugins/marketplaces/spec-it/skills"

# Or in Task prompt
$SKILLS_PATH = $HOME/.claude/plugins/marketplaces/spec-it/skills
```

---

## 9. 유효성 검사

### Wireframe 검증 (Phase 2 완료 후)

```
Task(
  subagent_type: "general-purpose",
  model: "haiku",
  prompt: "
    Validate all wireframes in {spec-folder}/02-wireframes/**/wireframes/

    Check each file for:
    1. Has '## Design Direction' section
    2. Has 'Applied Trends' subsection
    3. Has 'Component Patterns' table with Template Reference column
    4. Template references are valid paths in design-trends-2026/

    Output: {spec-folder}/02-wireframes/_design-validation.md

    Format:
    | File | Has Design Direction | Valid References | Status |
    |------|---------------------|------------------|--------|
  "
)
```

---

## 10. 관련 파일 목록

### design-trends-2026 skill 파일

```
skills/design-trends-2026/
├── SKILL.md
├── integration/
│   └── spec-it-integration.md (이 파일)
├── references/
│   ├── trends-summary.md
│   ├── component-patterns.md
│   ├── motion-presets.md
│   └── color-systems.md
└── templates/
    ├── dashboard-templates.md
    ├── card-templates.md
    ├── form-templates.md
    └── navigation-templates.md
```

### 수정이 필요한 spec-it 파일

```
skills/spec-it-stepbystep/SKILL.md  → Phase 0.0b 추가, ui-architect 프롬프트 수정
skills/spec-it-complex/SKILL.md    → Phase 0.0b 추가, ui-architect 프롬프트 수정
skills/spec-it-automation/SKILL.md → Phase 0.0b 추가, ui-architect 프롬프트 수정
skills/spec-it-execute/SKILL.md    → spec-executor 프롬프트 수정
```
