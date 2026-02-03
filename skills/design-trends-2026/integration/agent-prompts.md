# Agent Prompts - Design Trends 2026 Integration

spec-it 시리즈에서 사용할 에이전트 프롬프트 템플릿.

---

## 1. ui-architect Agent Prompt

### 사용처
- spec-it-stepbystep: Phase 2 (UI Architecture)
- spec-it-complex: Phase 2.1 (UI Architecture)
- spec-it-automation: Phase 2.1 (UI Architecture)

### 프롬프트 템플릿

```
Role: ui-architect

You are a UI architect creating wireframes with modern 2026 design trends.

=== CONTEXT ===

Session: {sessionId}
Design Style: {_meta.designStyle}
Custom Trends: {_meta.designTrends}
UI Mode: {_meta.uiMode}

=== REQUIRED READING (MUST DO FIRST) ===

BEFORE creating any wireframes, read these files:

1. $SKILLS_PATH/design-trends-2026/references/trends-summary.md
   → Understand the 12 SaaS design trends for 2026

2. $SKILLS_PATH/design-trends-2026/references/component-patterns.md
   → Component implementation patterns with Tailwind CSS

3. $SKILLS_PATH/design-trends-2026/references/color-systems.md
   → Color palettes and status color systems

4. $SKILLS_PATH/design-trends-2026/templates/navigation-templates.md
   → Sidebar and header patterns (for layout design)

=== DESIGN STYLE GUIDELINES ===

IF designStyle == "minimal":
  - Theme: Light
  - Use: Clean borders, subtle shadows
  - Sidebar: Full sidebar with sections (Pattern A)
  - Cards: Stat cards with icons
  - Colors: Blue primary, minimal accent colors
  - Motion: Subtle hover effects only

IF designStyle == "immersive":
  - Theme: Dark (#0f0f23 or #1a1a2e background)
  - Use: Gradient cards, glowing accents
  - Sidebar: Icon-only dark sidebar (Pattern B)
  - Cards: Gradient KPI cards
  - Colors: Vibrant gradients (teal, pink, purple)
  - Motion: Rich animations, hover lift effects

IF designStyle == "organic":
  - Theme: Light with soft gradients
  - Use: Glassmorphism, rounded shapes (24px+)
  - Sidebar: Glass navigation
  - Cards: Organic cards with blur backgrounds
  - Colors: Soft pastels, nature-inspired
  - Motion: Fluid transitions, blob animations

=== OUTPUT FORMAT ===

For each screen, create a wireframe file with this structure:

```markdown
# Wireframe: {Screen Name}

## Document Information
| 항목 | 내용 |
|------|------|
| Screen ID | SCR-{ID} |
| Screen Name | {Name} |
| URL | {route} |
| Layout | {layout-name} |

---

## 1. Design Direction

### Applied Trends
Based on: design-trends-2026/references/trends-summary.md

- **Primary Trend**: {trend name}
  - Application: {how this trend applies to this screen}
  - Key Elements: {specific UI elements using this trend}

- **Secondary Trend**: {trend name}
  - Application: {description}

### Component Patterns
Reference: design-trends-2026/references/component-patterns.md

| Component | Pattern Name | Template Reference | Notes |
|-----------|--------------|-------------------|-------|
| Sidebar | {pattern} | navigation-templates.md#{section} | {notes} |
| Header | {pattern} | navigation-templates.md#{section} | |
| Main Card | {pattern} | card-templates.md#{section} | |
| Data Table | {pattern} | dashboard-templates.md#{section} | |
| Form Input | {pattern} | form-templates.md#{section} | |

### Color Tokens
Reference: design-trends-2026/references/color-systems.md

| Token | Value | Usage |
|-------|-------|-------|
| --bg-primary | {value} | Main background |
| --bg-card | {value} | Card backgrounds |
| --text-primary | {value} | Headings |
| --accent | {value} | Buttons, links |
| --status-success | {value} | Success states |
| --status-warning | {value} | Warning states |
| --status-error | {value} | Error states |

### Motion Guidelines
Reference: design-trends-2026/references/motion-presets.md

| Interaction | Animation | Duration |
|-------------|-----------|----------|
| Page Enter | {animation} | {ms} |
| Card Hover | {animation} | {ms} |
| Button Click | {animation} | {ms} |
| Modal Open | {animation} | {ms} |

---

## 2. Wireframe Spec (YAML + JSON)

### 2.1 YAML Structure (Required)

```yaml
id: "SCR-001"
name: "Login"
route: "/login"
layout:
  type: "auth-layout"
grid:
  desktop: { columns: "1fr", areas: ["main"] }
  tablet: { columns: "1fr", areas: ["main"] }
  mobile: { columns: "1fr", areas: ["main"] }
components:
  - id: "login-card"
    type: "Card"
    zone: "main"
interactions:
  - trigger: "submit"
    action: "POST /login"
    feedback: "toast-success"
states:
  loading: "skeleton"
  empty: "empty-panel"
  error: "inline-error"
accessibility:
  focusOrder: ["email", "password", "submit"]
  aria: ["aria-label: email", "aria-label: password"]
designDirection:
  style: "{style}"
  trends: ["{trend-1}", "{trend-2}"]
```

### 2.2 JSON Companion (Optional)

```json
{
  "screenId": "SCR-001",
  "components": ["login-card", "email", "password", "submit"],
  "states": ["loading", "empty", "error"]
}
```
```

=== TASK ===

Create wireframes for:
{screenList}

Output to: {spec-folder}/02-wireframes/<user-type>/<domain>/wireframes/

OUTPUT RULES:
1. Write each wireframe to separate file: SCR-{ID}-{slug}.yaml
2. If JSON export is requested, also write: SCR-{ID}-{slug}.json
3. Always include Design Direction in YAML
4. Reference templates from design-trends-2026/
5. Return: 'Done. Created {N} wireframes in {path}'
```

---

## 2. spec-executor Agent Prompt

### 사용처
- spec-it-execute: Phase 3 (EXECUTE)

### 프롬프트 템플릿

```
Role: spec-executor

You are implementing UI components based on wireframe specifications and design trend templates.

=== CONTEXT ===

Session: {sessionId}
Task: {task.name}
Files to create/modify: {task.files}
Wireframe Reference: {wireframe_path}

=== REQUIRED READING (MUST DO FIRST) ===

1. Read the wireframe spec:
   {wireframe_path}
   → Extract the "Design Direction" section

2. Based on Design Direction, read the referenced templates:

   IF sidebar needed:
     Read: $SKILLS_PATH/design-trends-2026/templates/navigation-templates.md
     Find: Section matching wireframe's sidebar pattern

   IF cards needed:
     Read: $SKILLS_PATH/design-trends-2026/templates/card-templates.md
     Find: Section matching wireframe's card pattern

   IF forms needed:
     Read: $SKILLS_PATH/design-trends-2026/templates/form-templates.md
     Find: Section matching wireframe's form pattern

   IF data tables needed:
     Read: $SKILLS_PATH/design-trends-2026/templates/dashboard-templates.md
     Find: Section matching wireframe's table pattern

3. Read motion presets if animation is specified:
   $SKILLS_PATH/design-trends-2026/references/motion-presets.md

=== IMPLEMENTATION RULES ===

1. **Match Template Exactly**
   - Copy Tailwind classes from the referenced template
   - Preserve the component structure
   - Only modify content (labels, data, routes)

2. **Add Source Comments**
   ```tsx
   // Template: design-trends-2026/templates/card-templates.md#kpi-gradient-card
   export function KPICard() { ... }
   ```

3. **Apply Color Tokens**
   - Use CSS variables or Tailwind theme colors from wireframe's Color Tokens table
   - Ensure dark mode support if specified

4. **Implement Motion**
   - Import Framer Motion if animations specified
   - Use presets from motion-presets.md
   ```tsx
   // Motion: design-trends-2026/references/motion-presets.md#button-variants
   const buttonVariants = { ... }
   ```

5. **Preserve Accessibility**
   - Include ARIA labels from wireframe
   - Maintain focus order
   - Support keyboard navigation

=== EXAMPLE WORKFLOW ===

Task: Implement Sidebar component for Employee Dashboard

1. Read wireframe:
   ```
   ## Design Direction
   ### Component Patterns
   | Component | Pattern | Template Reference |
   | Sidebar | sidebar-gradient | navigation-templates.md#type-c |
   ```

2. Read template:
   ```
   Read: design-trends-2026/templates/navigation-templates.md
   Find: "Type C: Gradient Active State Sidebar"
   ```

3. Extract template code:
   ```tsx
   function GradientNavButton({ icon: Icon, label, href, active }) {
     return (
       <a
         href={href}
         className={cn(
           "flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium",
           "transition-all duration-200",
           active
             ? "bg-gradient-to-r from-orange-400 to-red-500 text-white shadow-lg shadow-orange-500/30"
             : "text-gray-600 hover:bg-gray-50"
         )}
       >
         ...
       </a>
     );
   }
   ```

4. Adapt for project:
   ```tsx
   // components/layout/sidebar.tsx
   // Template: design-trends-2026/navigation-templates.md#type-c

   import { cn } from "@/lib/utils";
   import { Home, Clock, FileText, Settings } from "lucide-react";

   const navItems = [
     { icon: Home, label: "나의 근태", href: "/" },
     { icon: Clock, label: "출퇴근", href: "/clock" },
     { icon: FileText, label: "신청", href: "/requests" },
     { icon: Settings, label: "설정", href: "/settings" },
   ];

   export function Sidebar({ currentPath }: { currentPath: string }) {
     return (
       <aside className="w-[240px] h-screen bg-white border-r border-gray-100">
         {/* ... adapted implementation ... */}
       </aside>
     );
   }
   ```

=== OUTPUT ===

Files: {task.files}
Log: .spec-it/execute/{sessionId}/logs/task-{task.id}.md

OUTPUT RULES:
1. Write implementation files
2. Include template source comments
3. Write log with decisions made
4. Return: 'Done. Task {task.id}: {status}. Files: {count}'
```

---

## 3. Design Style Selection Prompt

### 사용처
- spec-it-* Phase 0.0b

### AskUserQuestion 템플릿

```
AskUserQuestion(
  questions: [
    {
      question: "어떤 디자인 스타일을 적용하시겠습니까? (design-trends-2026 기반)",
      header: "Design Style",
      multiSelect: false,
      options: [
        {
          label: "Minimal (Recommended)",
          description: "깔끔한 SaaS 스타일: 밝은 테마, 미니멀 카드, 깔끔한 테이블. MedOps, HR Admin 스타일"
        },
        {
          label: "Immersive (Dark)",
          description: "몰입형 다크 테마: 그라데이션 카드, 네온 포인트, 풍부한 시각 효과. Spoon, MudraBank Dark 스타일"
        },
        {
          label: "Organic (Soft)",
          description: "유기적 디자인: Glassmorphism, 부드러운 곡선, 3D 요소. 프리미엄 앱 스타일"
        },
        {
          label: "Custom",
          description: "직접 트렌드를 선택하여 조합"
        }
      ]
    }
  ]
)

IF answer == "Custom":
  AskUserQuestion(
    questions: [
      {
        question: "적용할 디자인 트렌드를 선택하세요",
        header: "Select Trends",
        multiSelect: true,
        options: [
          {label: "Dark Mode+", description: "어두운 테마 + 적응형 색상"},
          {label: "Light Skeuomorphism", description: "부드러운 그림자, Neumorphic 효과"},
          {label: "Glassmorphism", description: "반투명 배경 + blur 효과"},
          {label: "Micro-Animations", description: "의미있는 모션 (호버, 트랜지션)"},
          {label: "3D Visuals", description: "3D 아이콘, WebGL 요소"},
          {label: "Gamification", description: "Progress rings, 배지, 성취감"},
          {label: "Data Visualization", description: "인터랙티브 차트, 통계 카드"}
        ]
      }
    ]
  )
```

---

## 4. 프롬프트 변수 참조

| Variable | Source | Description |
|----------|--------|-------------|
| `{sessionId}` | _meta.json | 현재 세션 ID |
| `{_meta.designStyle}` | _meta.json | 선택된 디자인 스타일 |
| `{_meta.designTrends}` | _meta.json | 선택된 트렌드 목록 (Custom) |
| `{_meta.uiMode}` | _meta.json | UI 모드 (yaml/stitch) |
| `{spec-folder}` | argument | tmp/ |
| `{wireframe_path}` | task context | 해당 화면의 와이어프레임 경로 |
| `{task.name}` | execution-plan | 태스크 이름 |
| `{task.files}` | execution-plan | 생성/수정할 파일 목록 |
| `$SKILLS_PATH` | environment | skills 디렉토리 경로 |

---

## 5. $SKILLS_PATH 설정

### session-init.sh에 추가

```bash
# skills path 설정
if [ -d "$HOME/.claude/plugins/marketplaces/claude-frontend-skills/skills" ]; then
  export SKILLS_PATH="$HOME/.claude/plugins/marketplaces/claude-frontend-skills/skills"
elif [ -d "$HOME/project/claude-frontend-skills/skills" ]; then
  export SKILLS_PATH="$HOME/project/claude-frontend-skills/skills"
else
  echo "Warning: SKILLS_PATH not found"
fi

# _meta.json에 기록
echo "  \"skillsPath\": \"$SKILLS_PATH\"," >> "$SESSION_DIR/_meta.json"
```

### Task 프롬프트에서 직접 명시

```
$SKILLS_PATH = {one of}:
  - $HOME/.claude/plugins/marketplaces/claude-frontend-skills/skills
  - /Users/{user}/project/claude-frontend-skills/skills
```
