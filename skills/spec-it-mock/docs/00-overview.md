# spec-it-mock Overview

Clone existing services/apps by analyzing source and generating identical spec-it output.

## What This Skill Does

1. **Load Design System** - Parse design tokens (any format)
2. **Analyze Target** - Use hack-2-spec with design context
3. **Generate Spec** - Wireframes with token references
4. **Execute** - Run selected spec-it mode

## Workflow

```
[3 Questions] → [Dashboard] → [Design System] → [hack-2-spec] → [spec-it Mode]
```

## Output Structure

```
.spec-it/${SESSION_ID}/
├── plan/
│   ├── _meta.json
│   ├── _status.json
│   ├── design-context.yaml      ← Parsed tokens
│   └── tmp/
│       ├── 02-wireframes/       ← With _ref:* tokens
│       └── ...
└── execute/
    └── ...                      ← Generated code
```
