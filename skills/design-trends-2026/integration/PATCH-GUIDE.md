# PATCH GUIDE: design-trends-2026 Integration

각 spec-it SKILL.md에 적용할 패치 내용.

---

## 1. 모든 spec-it-* 공통 패치

### Phase 0에 추가 (Step 0.0 이후)

```markdown
### Step 0.0b: Design Style Selection

\`\`\`
# Load design trends skill reference
designTrendsPath = $HOME/.claude/plugins/marketplaces/claude-frontend-skills/skills/design-trends-2026

AskUserQuestion(
  questions: [{
    question: "어떤 디자인 스타일을 적용하시겠습니까?",
    header: "Design Style",
    options: [
      {label: "Minimal (Recommended)", description: "깔끔한 SaaS: 밝은 테마, 깔끔한 카드/테이블"},
      {label: "Immersive", description: "다크 테마: 그라데이션, 네온 포인트"},
      {label: "Organic", description: "유기적: Glassmorphism, 부드러운 곡선"},
      {label: "Custom", description: "직접 트렌드 선택"}
    ]
  }]
)

IF "Custom":
  AskUserQuestion(
    questions: [{
      question: "적용할 트렌드를 선택하세요",
      header: "Trends",
      multiSelect: true,
      options: [
        {label: "Dark Mode+", description: "어두운 테마"},
        {label: "Light Skeuomorphism", description: "부드러운 그림자"},
        {label: "Glassmorphism", description: "반투명 blur"},
        {label: "Micro-Animations", description: "의미있는 모션"},
        {label: "3D Visuals", description: "3D 아이콘"},
        {label: "Gamification", description: "Progress, 배지"}
      ]
    }]
  )

# Save to _meta.json
_meta.designStyle = selectedStyle
_meta.designTrends = selectedTrends
_meta.designTrendsPath = designTrendsPath
Update(_meta.json)
\`\`\`
```

---

## 2. ui-architect Task 패치

### 기존 ui-architect Task를 아래로 교체

```markdown
Task(ui-architect, sonnet):
  prompt: "
    Role: ui-architect

    === DESIGN REFERENCE (MUST READ FIRST) ===

    1. Read: {_meta.designTrendsPath}/references/trends-summary.md
    2. Read: {_meta.designTrendsPath}/references/component-patterns.md
    3. Read: {_meta.designTrendsPath}/templates/navigation-templates.md

    Design Style: {_meta.designStyle}
    Applied Trends: {_meta.designTrends}

    === WIREFRAME REQUIREMENTS ===

    Each wireframe MUST include:

    ## Design Direction

    ### Applied Trends
    - Primary: {trend} - {application}
    - Secondary: {trend} - {application}

    ### Component Patterns
    | Component | Pattern | Template Reference |
    |-----------|---------|-------------------|
    | Sidebar | {name} | navigation-templates.md#{section} |
    | KPI Card | {name} | card-templates.md#{section} |

    ### Color Tokens
    | Token | Value | Usage |
    |-------|-------|-------|

    ### Motion Guidelines
    | Interaction | Animation | Duration |
    |-------------|-----------|----------|

    === OUTPUT ===
    Output: {spec-folder}/02-wireframes/<user-type>/<domain>/wireframes/
    Output: {spec-folder}/02-wireframes/layouts/

    OUTPUT RULES: (standard)
  "
```

---

## 3. spec-it-execute 패치

### Phase 3 Step 3.1 spec-executor Task 교체

```markdown
Task(
  subagent_type: "general-purpose",
  model: model,
  prompt: "
    Role: spec-executor

    Task: {task.name}
    Files: {task.files}

    === DESIGN REFERENCE (MUST READ) ===

    1. Read wireframe: {task.wireframe_path}
       → Extract 'Design Direction' section

    2. Read templates based on Component Patterns:
       - {_meta.designTrendsPath}/templates/dashboard-templates.md
       - {_meta.designTrendsPath}/templates/card-templates.md
       - {_meta.designTrendsPath}/templates/form-templates.md
       - {_meta.designTrendsPath}/templates/navigation-templates.md

    3. Read motion presets:
       - {_meta.designTrendsPath}/references/motion-presets.md

    === IMPLEMENTATION RULES ===

    1. Copy Tailwind classes from templates exactly
    2. Add source comments: // Template: {path}#{section}
    3. Apply Color Tokens from wireframe
    4. Implement Motion Guidelines with Framer Motion

    === OUTPUT ===
    Files: {task.files}
    Log: .spec-it/execute/{sessionId}/logs/task-{task.id}.md

    OUTPUT RULES: (standard)
  "
)
```

---

## 4. 파일별 패치 위치

### spec-it-stepbystep/SKILL.md

| Section | Line (approx) | Patch |
|---------|---------------|-------|
| Phase 0 | After Step 0.0 | Add Step 0.0b |
| Phase 2 | ui-architect Task | Replace with new prompt |

### spec-it-complex/SKILL.md

| Section | Line (approx) | Patch |
|---------|---------------|-------|
| Phase 0 | After Step 0.0 | Add Step 0.0b |
| Phase 2.1 | ui-architect Task | Replace with new prompt |

### spec-it-automation/SKILL.md

| Section | Line (approx) | Patch |
|---------|---------------|-------|
| Phase 0 | After Step 0.0 | Add Step 0.0b |
| Phase 2.1 | ui-architect Task | Replace with new prompt |

### spec-it-execute/SKILL.md

| Section | Line (approx) | Patch |
|---------|---------------|-------|
| Phase 1.3 | After UI Reference Analysis | Add design style loading |
| Phase 3.1 | spec-executor Task | Replace with new prompt |

---

## 5. _meta.json 스키마 추가

```json
{
  "sessionId": "...",
  "uiMode": "yaml",

  // NEW: Design Trends
  "designStyle": "minimal | immersive | organic | custom",
  "designTrends": ["dark-mode-plus", "micro-animations"],
  "designTrendsPath": "/path/to/skills/design-trends-2026",

  "currentStep": "..."
}
```

---

## 6. 빠른 적용 체크리스트

- [ ] Step 0.0b 추가 (모든 spec-it-*)
- [ ] _meta.json에 designStyle, designTrends 필드 추가
- [ ] ui-architect prompt에 Design Reference 섹션 추가
- [ ] ui-architect output에 Design Direction 섹션 요구
- [ ] spec-executor prompt에 Template Reading 섹션 추가
- [ ] spec-executor에 Template source comment 요구

---

## 7. 테스트 방법

```bash
# 1. spec-it 실행
/spec-it-stepbystep

# 2. Design Style 선택 확인
#    → "Immersive" 선택

# 3. 생성된 wireframe 확인
cat tmp/02-wireframes/**/wireframes/*.yaml | grep -A 20 "Design Direction"

# 4. Design Direction 섹션 존재 여부 확인
#    - Applied Trends
#    - Component Patterns (with Template Reference)
#    - Color Tokens
#    - Motion Guidelines

# 5. spec-it-execute 실행 후 구현 확인
grep -r "// Template:" src/components/
```
