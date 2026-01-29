---
description: "Create SPEC-IT-{HASH}.md files for existing UI code - Enable progressive context loading"
aliases: [init-spec, spec-init]
---

# init-spec-md

Creates SPEC-IT-{HASH}.md files for existing projects to enable progressive context loading.

## Usage

```bash
/frontend-skills:init-spec-md                    # Scan entire project
/frontend-skills:init-spec-md src/components     # Scan specific path only
/frontend-skills:init-spec-md --dry-run          # Preview (no actual creation)
/frontend-skills:init-spec-md --force            # Overwrite existing files
```

## Input

{{ARGUMENTS}}

## Workflow

### Step 1: Project Scan

```
Task(
  subagent_type="frontend-skills:spec-md-generator",
  model="haiku",
  prompt="PROJECT SCAN

Target path: {{ARGUMENTS}} or project root

1. Search **/*.tsx, **/*.ts files
2. Classify file types:
   - page.tsx, layout.tsx → Page
   - component file (export default function) → Component
   - module file → Module

3. Check existing SPEC-IT-*.md files (skip targets)
4. Load .spec-it-registry.json"
)
```

### Step 2: File Analysis (Parallel)

```
// Process multiple files in parallel
Task(
  subagent_type="frontend-skills:spec-md-generator",
  model="haiku",
  prompt="ANALYZE FILE: {file_path}

1. Read file → Extract functionality
2. Parse Props interface
3. Utilize JSDoc comments
4. Generate ASCII wireframe (for components)
5. Extract feature keywords (for pages/modules)"
)
```

### Step 3: Create SPEC-IT-{HASH}.md

```
Task(
  subagent_type="frontend-skills:spec-md-generator",
  model="haiku",
  prompt="CREATE SPEC-IT FILE

Use template based on file type:
- Component: SPEC_IT_COMPONENT_TEMPLATE.md
- Page/Module: SPEC_IT_PAGE_TEMPLATE.md

Generate unique HASH and create file"
)
```

### Step 4: Setup Bidirectional Links

```
Task(
  subagent_type="frontend-skills:spec-md-maintainer",
  model="haiku",
  prompt="SETUP BIDIRECTIONAL LINKS

1. Find parent folder's SPEC-IT file
2. Add child link to parent file
3. Add parent link to child file
4. Add sibling links (if needed)"
)
```

### Step 5: Update Registry

```
Update .spec-it-registry.json:
- Register new HASHes
- Set parent-child relationships
- Update statistics
```

### Step 6: Output Report

```
=== init-spec-md Complete ===

Files created: 45
- Components: 30
- Pages: 10
- Modules: 5

Files skipped: 12 (already exist)

New HASHes registered: 45
Bidirectional links: 128

.spec-it-registry.json updated
```

## Options

| Option | Description |
|--------|-------------|
| (no path) | Scan entire project |
| `{path}` | Scan specific path only |
| `--dry-run` | Preview without actual creation |
| `--force` | Overwrite existing SPEC-IT files |
| `--verbose` | Detailed log output |

## SPEC-IT-{HASH}.md Format

### For Components

```markdown
# SPEC-IT-{HASH}

## Component: {ComponentName}

### Description
{description}

### Props
| Prop | Type | Required | Description |

### Wireframe (ASCII)
{ascii_wireframe}

### Related Documents
- **Parent**: [SPEC-IT-{PARENT_HASH}](...)
```

### For Pages/Modules

```markdown
# SPEC-IT-{HASH}

## Page: {PageName}

### Feature Keywords
`keyword1` `keyword2` `keyword3`

### Screen Features
- Feature 1
- Feature 2

### Subfolder IA
/{path}
├── components/ → [SPEC-IT-{HASH}](...)
└── hooks/ → [SPEC-IT-{HASH}](...)

### Related Documents
- **Parent**: [SPEC-IT-{PARENT_HASH}](...)
```

## Registry File

`.spec-it-registry.json`:

```json
{
  "version": "1.0.0",
  "lastUpdated": "2026-01-29T15:00:00.000Z",
  "hashes": {
    "{HASH}": {
      "path": "src/components/Button/SPEC-IT-{HASH}.md",
      "type": "component",
      "parent": "{PARENT_HASH}",
      "file": "Button.tsx"
    }
  },
  "stats": {
    "totalFiles": 45,
    "components": 30,
    "pages": 10,
    "modules": 5
  }
}
```
