---
name: stitch-convert
description: "Convert ASCII wireframes to HTML via Stitch MCP. Reads wireframes and exports hi-fi HTML designs."
argument-hint: "<session-id> [--files file1.md,file2.md]"
allowed-tools: Read, Write, Edit, Bash, Glob, mcp__stitch__create_project, mcp__stitch__set_workspace_project, mcp__stitch__generate_screen_from_text, mcp__stitch__design_qa, mcp__stitch__export_design_system
permissionMode: bypassPermissions
---

# stitch-convert

Convert ASCII wireframes to high-fidelity HTML using Stitch MCP.

## Prerequisites

Before using this skill, ensure Stitch MCP is configured:

```bash
./scripts/verify-stitch-mcp.sh
```

If not configured:
```bash
./scripts/setup-stitch-mcp.sh
# Exit code 2 = Claude Code restart required
```

---

## Input

| Argument | Required | Description |
|----------|----------|-------------|
| session-id | Yes | Session directory (e.g., `20260130-123456`) |
| --files | No | Comma-separated wireframe files. If omitted, auto-detect from `02-screens/wireframes/` |

## Examples

```bash
# Auto-detect all wireframes
/stitch-convert 20260130-123456

# Specific files only
/stitch-convert 20260130-123456 --files wireframe-login.md,wireframe-dashboard.md
```

---

## Workflow

### Step 1: Verify Setup

```bash
./scripts/verify-stitch-mcp.sh
```

- Exit 0: Continue
- Exit 1: Run `./scripts/setup-stitch-mcp.sh`, may need restart
- Exit 2: Inform user to restart Claude Code

If MCP tools are not available, output error and stop.

### Step 2: Load Wireframes

```
IF --files provided:
  wireframes = parse comma-separated list
ELSE:
  wireframes = Glob(tmp/{session-id}/02-screens/wireframes/*.md)
```

If no wireframes found, output error and stop.

### Step 3: Create Stitch Project

```
mcp__stitch__create_project(name: "spec-it-{session-id}")
→ Save projectId

mcp__stitch__set_workspace_project(projectId: projectId)
```

Save metadata to `tmp/{session-id}/02-screens/stitch-project.json`:
```json
{
  "projectId": "{projectId}",
  "projectName": "spec-it-{session-id}",
  "createdAt": "{ISO timestamp}",
  "status": "converting",
  "screens": []
}
```

### Step 4: Convert Each Wireframe

For each wireframe file:

1. **Read** wireframe content
2. **Call** Stitch MCP:
   ```
   mcp__stitch__generate_screen_from_text(
     projectId: projectId,
     prompt: "Convert this ASCII wireframe to a high-fidelity UI design. Maintain layout structure and component hierarchy:\n\n{wireframe_content}"
   )
   ```
3. **Save** screenId to stitch-project.json
4. **Log** progress: `"Converted: {filename} ({n}/{total})"`

**Error handling**: If conversion fails after 2 retries, skip and continue. Log failure.

### Step 5: Export HTML

```
mcp__stitch__export_design_system(
  projectId: projectId,
  format: "html"
)
```

### Step 6: Save Files

Create directories:
```bash
mkdir -p tmp/{session-id}/02-screens/html
mkdir -p tmp/{session-id}/02-screens/assets
```

Save exported content:
- `02-screens/html/{screen-name}.html` - One per screen
- `02-screens/assets/styles.css` - Design system styles
- `02-screens/assets/tokens.json` - Design tokens (if available)

### Step 7: Generate Index

Create `02-screens/html/index.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>spec-it-{session-id} - Screen Gallery</title>
  <link rel="stylesheet" href="../assets/styles.css">
  <style>
    body { font-family: system-ui, sans-serif; padding: 2rem; }
    h1 { margin-bottom: 1rem; }
    ul { list-style: none; padding: 0; }
    li { margin: 0.5rem 0; }
    a { color: #0066cc; text-decoration: none; }
    a:hover { text-decoration: underline; }
  </style>
</head>
<body>
  <h1>Screen Gallery</h1>
  <ul>
    <!-- Generated links -->
  </ul>
</body>
</html>
```

### Step 8: Update Metadata

Update `stitch-project.json`:
```json
{
  "status": "exported",
  "exportedAt": "{ISO timestamp}",
  "screens": [
    {"name": "login", "stitchId": "...", "htmlFile": "html/login.html"},
    ...
  ],
  "htmlFiles": ["html/login.html", ...],
  "cssFile": "assets/styles.css"
}
```

---

## Output

### Success
```
Done. {N} screens exported to 02-screens/html/
Index: tmp/{session-id}/02-screens/html/index.html
```

### Partial Success
```
Partial. {N}/{M} screens exported.
Failed: {list of failed screens}
See: tmp/{session-id}/02-screens/stitch-project.json
```

### Failure
```
Failed: {reason}
- MCP not configured: Run ./scripts/setup-stitch-mcp.sh
- No wireframes found: Generate wireframes first with ui-architect
- OAuth required: Run node ./scripts/setup-stitch-oauth.mjs
```

---

## Error Handling

| Error | Action |
|-------|--------|
| MCP tools unavailable | Output setup instructions, stop |
| OAuth expired | Prompt to run setup-stitch-oauth.mjs |
| No wireframes | Output error, suggest running ui-architect first |
| Single screen fails | Skip, log, continue with others |
| Export fails | Attempt partial export, report missing |
| Project creation fails | Retry 3x, then fail |

---

## Files Created

```
tmp/{session-id}/02-screens/
├── stitch-project.json      # Project metadata
├── html/
│   ├── index.html           # Gallery index
│   ├── login.html           # Screen HTML files
│   ├── dashboard.html
│   └── ...
└── assets/
    ├── styles.css           # Design system CSS
    └── tokens.json          # Design tokens (optional)
```
