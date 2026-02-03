---
name: spec-it-mock
description: |
  Clone existing services/apps by analyzing source and generating identical spec-it output.
  Combines hack-2-spec analysis with design system matching for accurate reproduction.
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion, Skill
argument-hint: "[target] [design-system]"
permissionMode: bypassPermissions
---

# spec-it-mock: Clone & Reproduce Mode

Analyze existing services and generate spec-it specifications that reproduce the same result.

## Quick Start

```
/spec-it-mock
```

## Reference Documents (load only when needed)

| When you need to... | Read this |
|---------------------|-----------|
| Parse design tokens (Figma/Style Dictionary/DTCG) | `skills/shared/design-token-parser.md` |
| Understand design system loading details | `docs/01-design-system-load.md` |
| Configure hack-2-spec integration | `docs/02-hack-2-spec-integration.md` |
| Handle spec-it mode execution | `docs/03-spec-it-execution.md` |
| Apply Tailwind layout rules | `skills/shared/rules/05-vercel-skills.md` |

## Workflow

```
[Phase 0: Questions] → [Phase 1: Init] → [Phase 2: Design System] → [Phase 3: hack-2-spec] → [Phase 4: spec-it]
```

---

## Phase 0: Unified Intake

Ask all 3 questions at once:

```
AskUserQuestion(
  questions: [
    {
      question: "Mock 대상 경로를 입력하세요 (로컬 경로 또는 URL)",
      header: "Target",
      options: [
        {label: "Local Path", description: "예: /path/to/project"},
        {label: "URL", description: "예: https://example.com"}
      ]
    },
    {
      question: "디자인 시스템 경로를 입력하세요",
      header: "Design System",
      options: [
        {label: "Built-in (2026 Trends)", description: "기본 디자인 트렌드 사용"},
        {label: "Custom Path", description: "직접 경로 지정"}
      ]
    },
    {
      question: "spec-it 실행 모드를 선택하세요",
      header: "Mode",
      options: [
        {label: "Step-by-Step (Recommended)", description: "챕터별 승인"},
        {label: "Complex/Hybrid", description: "4개 마일스톤"},
        {label: "Full Automation", description: "최소 승인, 자동 실행"},
        {label: "Fast Launch", description: "빠른 프로토타입"}
      ]
    }
  ]
)
```

---

## Phase 1: Initialize

### Step 1.0: Vercel Skills Submodule

```bash
if [ ! -f "docs/refs/agent-skills/README.md" ]; then
  git submodule update --init --recursive docs/refs/agent-skills
fi
```

### Step 1.1: Session Setup

```bash
SESSION_ID=$(date +%Y%m%d-%H%M%S)
mkdir -p ".spec-it/${SESSION_ID}/plan"
```

### Step 1.2: Dashboard Announcement

```
Dashboard: file://${PWD}/.spec-it/dashboard/index.html?session=${SESSION_ID}
```

---

## Phase 2: Load Design System

**Key Steps:**
1. Detect token format (Tokens Studio / Style Dictionary / DTCG)
2. Parse and flatten token tree
3. Resolve aliases
4. Build reverse lookup (CSS value → token path)
5. Write `design-context.yaml`

> **If token parsing fails or format is unknown:** Read `skills/shared/design-token-parser.md`

---

## Phase 3: hack-2-spec with Design Context

```
Skill(hack-2-spec, {
  --source: targetPath,
  --designContext: "${SESSION_DIR}/plan/design-context.yaml"
})
```

**Result:** Wireframes with `_ref:color.semantic.bg.brand.primary` style token references.

> **If token matching issues occur:** Read `docs/02-hack-2-spec-integration.md`

---

## Phase 4: spec-it Execution

```
Skill(${selectedMode}, {
  --resume: ${SESSION_ID},
  --design-trends: "${SESSION_DIR}/plan/design-context.yaml"
})
```

> **If mode execution fails or needs error handling:** Read `docs/03-spec-it-execution.md`

---

## Critical Rules

- Design tokens are parsed dynamically (no fixed schema)
- Token references use full paths: `_ref:color.semantic.bg.brand.primary`
- All phases tracked in web dashboard
