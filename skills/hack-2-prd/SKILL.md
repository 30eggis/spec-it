---
name: hack-2-prd
description: |
  Analyze services/projects and systematically generate PRD (Product Requirements Document), SPEC, PHASE, and TASKS documents.
  Supports website URLs (via Chrome Extension), local codebases, and mobile apps (screenshot-based).
  Use when documenting existing products or reverse-engineering requirements from implementations.
permissionMode: bypassPermissions
---

# Hack 2 PRD

Analyze services/projects and generate 4-stage documentation (PRD → SPEC → PHASE → TASKS).

## Workflow

```
[Identify Input Source] → [Analyze Source] → [Ask Language Preference] → [Write PRD] → [Write SPEC] → [Write PHASE] → [Write TASKS]
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

Store the user's language preference and apply it to all generated documents (PRD, SPEC, PHASE, TASKS).

## Step 3: Write PRD

Use `assets/templates/PRD_TEMPLATE.md` template.

**Required Information:**
- Project name, document purpose
- Background and problem definition
- Goals and non-goals
- Target users and needs
- Success criteria (measurable metrics)
- Scope (in/out)
- Functional requirements (REQ-001, REQ-002...)
- Non-functional requirements (performance, security, accessibility, etc.)
- User scenarios

**Output:** `docs/PRD.md`

## Step 4: Write SPEC

Use `assets/templates/SPEC_TEMPLATE.md` template.

Generate SPEC documents for each major feature/requirement from PRD:

**SPEC Document Structure:**
- Create SPEC-01, SPEC-02... per feature
- Each SPEC references related REQ-###
- Include user flows, UI requirements, acceptance criteria

**Output:** `docs/specs/SPEC-01.md`, `docs/specs/SPEC-02.md`...

## Step 5: Write PHASE

Use `assets/templates/PHASE_TEMPLATE.md` template.

Divide implementation into logical stages:

**Phase Structure Principles:**
- PHASE-01: MVP / Core features
- PHASE-02: Extended features
- PHASE-03: Enhancement / Optimization

Map SPECs to each Phase.

**Output:** `docs/phases/PHASE-01.md`, `docs/phases/PHASE-02.md`...

## Step 6: Write TASKS

Use `assets/templates/TASKS_TEMPLATE.md` template.

Generate specific task lists for each Phase:

**Task Writing Rules:**
- Identifier: TASK-{Phase}.{Seq} (e.g., TASK-1.01)
- Each Task must reference a SPEC
- No implementation technology/code mentions (write at behavior level)
- Specify dependencies and priorities

**Output:** `docs/tasks/TASKS-PHASE-01.md`, `docs/tasks/TASKS-PHASE-02.md`...

## Output Structure

```
docs/
├── PRD.md
├── specs/
│   ├── SPEC-01.md
│   ├── SPEC-02.md
│   └── ...
├── phases/
│   ├── PHASE-01.md
│   ├── PHASE-02.md
│   └── ...
└── tasks/
    ├── TASKS-PHASE-01.md
    ├── TASKS-PHASE-02.md
    └── ...
```

## User Confirmation Points

After completing each document, confirm with user:
1. PRD complete → "Please review the PRD. Any modifications needed?"
2. SPEC complete → "Are the SPECs for each feature accurate?"
3. PHASE complete → "Is the Phase structure appropriate?"
4. TASKS complete → "Please review the task list."

## Templates

This skill uses templates from `assets/templates/` directory:
- `PRD_TEMPLATE.md` - Product Requirements Document
- `SPEC_TEMPLATE.md` - Feature Specification
- `PHASE_TEMPLATE.md` - Phase Document
- `TASKS_TEMPLATE.md` - Task Document

Replace `{{placeholder}}` in templates with actual content when generating documents.
