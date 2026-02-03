---
name: hack-2-spec
description: |
  Analyze services/projects and generate Spec, PHASE, and TASKS documents.
  Supports website URLs, local codebases, and mobile apps.
  Output format compatible with spec-it.
argument-hint: "[--source <path|url>] [--output <dir>] [--designContext <path>]"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Task, AskUserQuestion
permissionMode: bypassPermissions
---

# Hack 2 Spec

Analyze services/projects and generate spec-it compatible documentation.

## Reference Documents (load only when needed)

| When you need to... | Read this |
|---------------------|-----------|
| **Output quality standards** | `skills/shared/rules/06-output-quality.md` |
| **Template index** | `skills/shared/templates/_INDEX.md` |
| Understand output folder structure | `docs/01-output-structure.md` |
| Use `--designContext` parameter | `docs/00-design-context.md` |
| Parse token formats (Figma/Style Dictionary) | `skills/shared/design-token-parser.md` |
| Apply Tailwind layout analysis rules | `skills/shared/rules/05-vercel-skills.md` |

### Output Templates (MANDATORY)

| Output File | Template |
|------------|----------|
| requirements.md | `skills/shared/templates/00-REQUIREMENTS_TEMPLATE.md` |
| chapter-plan-final.md | `skills/shared/templates/01-CHAPTER_PLAN_TEMPLATE.md` |
| screen-list.md | `skills/shared/templates/02-SCREEN_LIST_TEMPLATE.md` |
| domain-map.md | `skills/shared/templates/02-DOMAIN_MAP_TEMPLATE.md` |
| {screen-id}.yaml | `skills/shared/templates/02-WIREFRAME_YAML_TEMPLATE.yaml` |
| component-inventory.md | `skills/shared/templates/03-COMPONENT_INVENTORY_TEMPLATE.md` |
| review-summary.md | `skills/shared/templates/04-REVIEW_SUMMARY_TEMPLATE.md` |
| test-specifications.md | `skills/shared/templates/05-TEST_SPECIFICATIONS_TEMPLATE.md` |
| final-spec.md | `skills/shared/templates/06-FINAL_SPEC_TEMPLATE.md` |
| dev-tasks.md | `skills/shared/templates/06-DEV_TASKS_TEMPLATE.md` |
| SPEC-SUMMARY.md | `skills/shared/templates/06-SPEC_SUMMARY_TEMPLATE.md` |
| PHASE-*.md | `skills/shared/templates/PHASE_TEMPLATE.md` |

## Workflow

```
[Step 0: Init] → [Step 1: Identify Source] → [Step 2: Language] → [Step 3: Write Spec] → [Step 4: PHASE] → [Step 5: TASKS]
```

---

## Step 0: Initialize Dependencies

```bash
# Vercel skills submodule
if [ ! -f "docs/refs/agent-skills/README.md" ]; then
  git submodule update --init --recursive docs/refs/agent-skills
fi
```

**Layout Rules (MUST FOLLOW):**
- `grid-cols-3` → 3 columns, NOT 2
- Same-row elements stay in same grid area row
- Map responsive prefixes (`lg:`, `md:`, `sm:`) separately

> **If layout analysis produces incorrect grid structure:** Read `skills/shared/rules/05-vercel-skills.md`

---

## Step 0.5: Load Design Context (Optional)

If `--designContext` provided, load design tokens for wireframe generation.

**Key Points:**
- Supports any token format (Tokens Studio, Style Dictionary, DTCG)
- Token refs use full paths: `_ref:color.semantic.bg.brand.primary`
- Auto-matches CSS values to nearest token

> **If token format is unrecognized or matching fails:** Read `docs/00-design-context.md`

---

## Step 1: Identify Input Source

| Source Type | Requirements | Proceed When |
|-------------|--------------|--------------|
| **Website** | URL, Chrome Extension data | Data collected |
| **Code** | Project path | Build succeeds |
| **Mobile App** | Screenshots, description | Info gathered |

---

## Step 2: Ask Language Preference

```
Which language for output documents?
- English
- Korean (한국어)
- Other
```

---

## Step 3: Generate spec-it Output

**CRITICAL:** Use templates from `skills/shared/templates/` to ensure consistent output quality.

Output structure **must match spec-it exactly**.

### Output Structure

```
{output-folder}/
├── 00-requirements/
│   └── requirements.md          # Template: 00-REQUIREMENTS_TEMPLATE.md
├── 01-chapters/
│   ├── chapter-plan-final.md    # Template: 01-CHAPTER_PLAN_TEMPLATE.md
│   ├── critique-round1-*.md
│   └── critique-synthesis.md
├── 02-wireframes/
│   ├── layouts/layout-system.yaml
│   ├── domain-map.md            # Template: 02-DOMAIN_MAP_TEMPLATE.md
│   ├── screen-list.md           # Template: 02-SCREEN_LIST_TEMPLATE.md
│   └── <domain>/<user-type>/
│       ├── screen-list.md
│       └── wireframes/{screen-id}.yaml  # Template: 02-WIREFRAME_YAML_TEMPLATE.yaml
├── 03-components/
│   ├── inventory.md
│   ├── component-inventory.md   # Template: 03-COMPONENT_INVENTORY_TEMPLATE.md
│   └── specs/{ComponentName}.yaml
├── 04-review/
│   ├── review-summary.md        # Template: 04-REVIEW_SUMMARY_TEMPLATE.md
│   ├── scenarios/critical-path.md
│   └── exceptions/
├── 05-tests/
│   ├── test-specifications.md   # Template: 05-TEST_SPECIFICATIONS_TEMPLATE.md
│   └── coverage-map.md
├── 06-final/
│   ├── final-spec.md            # Template: 06-FINAL_SPEC_TEMPLATE.md
│   ├── dev-tasks.md             # Template: 06-DEV_TASKS_TEMPLATE.md
│   └── SPEC-SUMMARY.md          # Template: 06-SPEC_SUMMARY_TEMPLATE.md
├── phases/
│   └── PHASE-*.md               # Template: PHASE_TEMPLATE.md
└── tasks/
    └── TASKS-PHASE-*.md         # Template: 06-DEV_TASKS_TEMPLATE.md
```

### Wireframe Token Usage (if designContext enabled)

```yaml
layout:
  background: "_ref:color.semantic.bg.brand.primary"
  padding: "_ref:spacing.24"
  border_radius: "_ref:radius.m"
```

> **For output structure details:** Read `docs/01-output-structure.md`

---

## Step 4: Generate final-spec.md

Consolidate all requirements into `06-final/final-spec.md`:

- Requirements in REQ-### format
- Screen specifications
- Component specifications
- Critical user paths

---

## Step 5: Generate dev-tasks.md

Create `06-final/dev-tasks.md` with development tasks:

- Task identifier: TASK-{Domain}.{Seq}
- Reference to screen/component spec
- Dependencies and priorities
- Acceptance criteria

---

## Integration with spec-it-mock

```
Skill(hack-2-spec, {
  --source: "/path/to/target",
  --output: ".spec-it/{sessionId}/plan/tmp",
  --designContext: ".spec-it/{sessionId}/plan/design-context.yaml"
})
```

**Result:** Wireframes with design token references for identical visual output.

---

## Integration with spec-mirror

```
Skill(hack-2-spec --source codebase --output docs/_mirror/)
```
