---
name: spec-it
description: "Spec-it router that selects automation, complex, or step-by-step mode."
allowed-tools: AskUserQuestion, Skill
argument-hint: "[mode] [--resume <sessionId>]"
permissionMode: bypassPermissions
---

# spec-it: Mode Router

Intelligent router that guides users to the appropriate spec-it mode based on their needs.

## Trigger Keywords

This skill activates on semantic matches for:
- "frontend spec", "UI spec", "design spec"
- "PRD to spec", "requirements to design"
- "wireframe", "component spec", "test spec"
- "spec-it" (explicit)

---

## Workflow

### Step 0: Initialize Dependencies (Auto)

**CRITICAL:** Before routing, ensure Vercel agent-skills submodule is available.

```bash
# Auto-initialize submodule for Tailwind/design reference
if [ ! -f "docs/refs/agent-skills/README.md" ]; then
  git submodule update --init --recursive docs/refs/agent-skills 2>/dev/null || echo "Warning: Could not init submodule"
fi
```

**Reference:** `skills/shared/rules/05-vercel-skills.md` for Tailwind layout rules.

---

### Step 1: Check for Direct Mode Specification

```
IF args contains "stepbystep" OR "step-by-step" OR "manual":
  Skill(spec-it-stepbystep, args)
  STOP

IF args contains "complex" OR "hybrid" OR "milestone":
  Skill(spec-it-complex, args)
  STOP

IF args contains "auto" OR "automation" OR "full-auto":
  Skill(spec-it-automation, args)
  STOP

IF args contains "fast" OR "quick" OR "rapid":
  Skill(spec-it-fast-launch, args)
  STOP

IF args contains "--resume":
  # Resume needs to know which mode - check session _meta.json
  # New structure: .spec-it/{sessionId}/(plan|execute)/_meta.json
  Read: .spec-it/{sessionId}/plan/_meta.json OR .spec-it/{sessionId}/execute/_meta.json
  route to appropriate skill based on mode stored in meta
  STOP
```

### Step 2: Unified Setup Intake (Ask Once)

```
# Gather any pre-specified preferences from args or user request
# (If already provided, do NOT ask again.)
mode = parse args/user request if present
designStyle = parse args/user request if present
designTrends = parse args/user request if present
dashboard = parse args/user request if present  # on/off

questions = []

IF mode missing:
  questions += {
    question: "Which spec-it mode would you like to use?",
    header: "Mode",
    options: [
      {label: "Step-by-Step (Recommended)", description: "Chapter approvals, maximum control"},
      {label: "Complex/Hybrid", description: "4 milestones, auto-validation"},
      {label: "Full Automation → Execute", description: "Minimal approval, auto-exec"},
      {label: "Fast → Execute", description: "Skip brainstorm/tests, rapid wireframes"}
    ]
  }

IF designStyle missing:
  questions += {
    question: "어떤 디자인 스타일을 적용하시겠습니까? (2026 Design Trends 기반)",
    header: "Design Style",
    options: [
      {label: "Minimal (Recommended)", description: "밝은 테마, 미니멀 카드"},
      {label: "Immersive", description: "다크 테마, 그라데이션, 네온 포인트"},
      {label: "Organic", description: "Glassmorphism, 부드러운 곡선"},
      {label: "Custom", description: "직접 트렌드 선택"},
      {label: "Custom File", description: "직접 스타일 파일 경로 지정"}
    ]
  }

IF dashboard missing:
  questions += {
    question: "웹 대시보드를 사용할까요?",
    header: "Dashboard",
    options: [
      {label: "Enable", description: "Web dashboard 사용"},
      {label: "Skip", description: "대시보드 없이 진행"}
    ]
  }

IF questions not empty:
  AskUserQuestion(questions)

IF designStyle == "Custom":
  AskUserQuestion(
    questions: [{
      question: "적용할 디자인 트렌드를 선택하세요",
      header: "Trends",
      multiSelect: true,
      options: [
        {label: "Dark Mode+", description: "어두운 테마 + 적응형 색상"},
        {label: "Light Skeuomorphism", description: "부드러운 그림자, Neumorphic"},
        {label: "Glassmorphism", description: "반투명 배경 + blur"},
        {label: "Micro-Animations", description: "의미있는 모션"},
        {label: "3D Visuals", description: "3D 아이콘, WebGL"},
        {label: "Gamification", description: "Progress rings, 배지"}
      ]
    }]
  )

IF designStyle == "Custom File":
  AskUserQuestion(
    questions: [{
      question: "디자인 트렌드 파일 경로를 입력하세요",
      header: "Custom File",
      options: []
    }]
  )
```

### Step 3: Route to Selected Mode

```
CASE selection:
  "Step-by-Step" → Skill(spec-it-stepbystep, "--design-style {designStyle} --design-trends {designTrends} --dashboard {dashboard}")
  "Complex/Hybrid" → Skill(spec-it-complex, "--design-style {designStyle} --design-trends {designTrends} --dashboard {dashboard}")
  "Full Automation → Execute" → Skill(spec-it-automation, "--design-style {designStyle} --design-trends {designTrends} --dashboard {dashboard}")
  "Fast → Execute" → Skill(spec-it-fast-launch, "--design-style {designStyle} --design-trends {designTrends} --dashboard {dashboard}")
```

---

## Mode Comparison

| Feature | Step-by-Step | Complex | Automation | Fast |
|---------|--------------|---------|------------|------|
| Approvals | Every chapter | 4 milestones | Final only | Final only |
| Question Policy | Confirm | Hybrid | Auto | Auto |
| Control | Maximum | Balanced | Minimal | Minimal |
| Speed | Slowest | Medium | Fast | **Fastest** |
| Learning | Best | Good | Limited | None |
| Project Size | Small | Medium | Large | Prototype |
| Auto-Execute | No | No | **Yes** | **Yes** |
| Components | Full | Full | Full | Skipped |
| Tests | Full | Full | Full | Skipped |

---

## Direct Invocation

For experienced users who know which mode they want:

```bash
# Step-by-Step mode
/spec-it-stepbystep

# Complex/Hybrid mode
/spec-it-complex

# Full Automation mode (auto-executes)
/spec-it-automation

# Fast mode (auto-executes)
/spec-it-fast-launch

# Resume any mode
/spec-it-stepbystep --resume 20260130-123456
/spec-it-complex --resume 20260130-123456
/spec-it-automation --resume 20260130-123456
/spec-it-fast-launch --resume 20260130-123456
```

---

## Rules

See [shared/rules/06-output-quality.md](../shared/rules/06-output-quality.md) (Output Quality Standards - MANDATORY).

### Output Templates (MANDATORY)

All modes MUST use templates from `skills/shared/templates/`:

| Output File | Template |
|------------|----------|
| requirements.md | `00-REQUIREMENTS_TEMPLATE.md` |
| chapter-plan-final.md | `01-CHAPTER_PLAN_TEMPLATE.md` |
| screen-list.md | `02-SCREEN_LIST_TEMPLATE.md` |
| domain-map.md | `02-DOMAIN_MAP_TEMPLATE.md` |
| {screen-id}.yaml | `02-WIREFRAME_YAML_TEMPLATE.yaml` |
| component-inventory.md | `03-COMPONENT_INVENTORY_TEMPLATE.md` |
| review-summary.md | `04-REVIEW_SUMMARY_TEMPLATE.md` |
| test-specifications.md | `05-TEST_SPECIFICATIONS_TEMPLATE.md` |
| final-spec.md | `06-FINAL_SPEC_TEMPLATE.md` |
| dev-tasks.md | `06-DEV_TASKS_TEMPLATE.md` |
| SPEC-SUMMARY.md | `06-SPEC_SUMMARY_TEMPLATE.md` |
| PHASE-*.md | `PHASE_TEMPLATE.md` |

---

## Output

All modes produce the same output structure:

```
.spec-it/{sessionId}/plan/
├── _meta.json, _status.json

tmp/
├── 00-requirements/
├── 01-chapters/
├── 02-wireframes/
│   ├── layouts/
│   ├── domain-map.md
│   ├── shared/<domain>.md
│   ├── <user-type>/<domain>/screen-list.md
│   ├── <user-type>/<domain>/wireframes/
│   └── [html/, assets/]  # If Stitch mode
├── 03-components/
├── 04-review/
├── 05-tests/
└── 06-final/
    ├── final-spec.md
    ├── dev-tasks.md
    └── SPEC-SUMMARY.md
```
