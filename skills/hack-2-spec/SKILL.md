---
name: hack-2-spec
description: |
  Analyze services/projects and systematically generate Spec (Specification Document), PHASE, and TASKS documents.
  Supports website URLs (via Chrome Extension), local codebases, and mobile apps (screenshot-based).
  Use when documenting existing products or reverse-engineering requirements from implementations.
  Output format compatible with spec-it for seamless integration.
permissionMode: bypassPermissions
---

# Hack 2 Spec

Analyze services/projects and generate spec-it compatible documentation.

## Workflow

```
[Identify Input Source] → [Analyze Source] → [Ask Language Preference] → [Write Spec] → [Write PHASE] → [Write TASKS]
```

## Step 1: Identify Input Source

Confirm the documentation target with the user:

| Source Type | Requirements | Proceed When |
|-------------|--------------|--------------|
| **Website** | URL, Chrome Extension data availability | Data collection complete |
| **Code** | Project path, build capability | Build succeeds |
| **Mobile App** | Screenshots, app description, feature list | Sufficient info gathered |

### Analysis Methods by Source

**Website Analysis:**
- Review page structure, feature list, UI flow collected via Chrome Extension
- Ask user about core features and business logic

**Code Analysis:**
1. Understand project structure (package.json, README, etc.)
2. Run build test
3. On build failure: Resolve issues or report to user
4. On build success: Proceed with code analysis

**Mobile App Analysis:**
- Extract features based on provided screenshots and descriptions
- Reference app store descriptions, user reviews (if available)

## Step 2: Ask Language Preference

Before generating documents, ask the user which language to use for the output documents.

**Prompt to user:**
```
Which language would you like the documents to be written in?
- English
- Korean (한국어)
- Other (please specify)
```

Store the user's language preference and apply it to all generated documents.

## Step 3: Write Spec (spec-it Format)

Generate specification in spec-it compatible format.

### Output Structure (spec-it Compatible)

```
{output-folder}/
├── 01-persona/
│   └── personas.md
├── 02-screens/
│   ├── screen-list.md
│   └── wireframes/
│       ├── screen-{name}.md
│       └── ...
├── 03-components/
│   ├── component-inventory.md
│   └── specs/
│       ├── {ComponentName}.md
│       └── ...
├── 04-review/
│   └── scenarios/
│       ├── critical-path.md
│       └── screen-{name}.md
├── 05-tests/
│   ├── coverage-map.md
│   └── components/
│       └── {ComponentName}.test.md
└── 06-final/
    ├── final-spec.md
    └── dev-tasks.md
```

### Required Information for Spec

**01-persona/**
- User personas with goals, pain points, behaviors
- Device preferences, usage patterns

**02-screens/**
- Screen list with routes and purposes
- YAML/JSON wireframes for each screen
- Component mapping per screen

**03-components/**
- Component inventory with categories
- Individual component specs (props, states, interactions)

**04-review/**
- Critical path scenarios
- Screen-specific user scenarios

**05-tests/**
- Coverage map linking components to tests
- Test specifications per component

**06-final/**
- Consolidated final spec
- Development task breakdown

## Step 4: Write PHASE

Use `assets/templates/PHASE_TEMPLATE.md` template.

Divide implementation into logical stages:

**Phase Structure Principles:**
- PHASE-01: MVP / Core features
- PHASE-02: Extended features
- PHASE-03: Enhancement / Optimization

**Output:** `docs/phases/PHASE-01.md`, `docs/phases/PHASE-02.md`...

## Step 5: Write TASKS

Use `assets/templates/TASKS_TEMPLATE.md` template.

Generate specific task lists for each Phase:

**Task Writing Rules:**
- Identifier: TASK-{Phase}.{Seq} (e.g., TASK-1.01)
- Each Task must reference a component or screen spec
- No implementation technology/code mentions (write at behavior level)
- Specify dependencies and priorities

**Output:** `docs/tasks/TASKS-PHASE-01.md`, `docs/tasks/TASKS-PHASE-02.md`...

## User Confirmation Points

After completing each document, confirm with user:
1. Spec complete → "Please review the Spec. Any modifications needed?"
2. PHASE complete → "Is the Phase structure appropriate?"
3. TASKS complete → "Please review the task list."

## Integration with spec-mirror

When called from spec-mirror for reverse-engineering:

```
# spec-mirror가 호출하는 패턴
Skill(hack-2-spec --source codebase --output docs/_mirror/)

# 결과물
docs/_mirror/
├── 03-components/specs/  → 구현된 컴포넌트 스펙
├── 02-screens/           → 구현된 화면 스펙
└── 06-final/final-spec.md → 통합 스펙 (REQ-### 형식)
```

## Templates

This skill uses templates from `assets/templates/` directory:
- `SPEC_TEMPLATE.md` - Feature Specification
- `PHASE_TEMPLATE.md` - Phase Document
- `TASKS_TEMPLATE.md` - Task Document

Replace `{{placeholder}}` in templates with actual content when generating documents.
