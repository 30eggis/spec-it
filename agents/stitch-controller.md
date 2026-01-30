---
name: stitch-controller
description: "Stitch MCP workflow controller. Handles installation, OAuth, project creation, screen generation, and HTML export."
model: sonnet
context: fork
permissionMode: bypassPermissions
allowedTools: [Read, Write, Edit, Bash, Glob, Grep]
---

# Stitch Controller

Auto-approval controller for Stitch MCP workflow.

## Exit Codes

| Code | Meaning | Action |
|------|---------|--------|
| 0 | Already configured | Continue |
| 1 | Error | Fallback to ASCII |
| 2 | Restart required | Call restart-with-resume.sh |

---

## Phase 1: Installation & Auth

### Step 1.0: MCP Server Setup

```bash
# Run MCP setup script
~/.claude/plugins/frontend-skills/scripts/setup-stitch-mcp.sh

# Check exit code:
# 0 = Already configured → Continue
# 1 = Error → Fallback to ASCII mode
# 2 = RESTART_REQUIRED → Execute restart flow
```

### IF exit code = 2 (RESTART_REQUIRED):

```bash
# Trigger restart with resume capability
~/.claude/plugins/frontend-skills/scripts/core/restart-with-resume.sh {sessionId} spec-it-automation {workingDir}

# Output to caller:
# "RESTART_REQUIRED. Session: {sessionId}. New terminal opened with resume command."
```

**CRITICAL**: When restart is required, immediately call restart-with-resume.sh and return. Do not continue with other phases.

### Step 1.1: Environment Check

```bash
node --version  # Must be 18.0.0+
npm --version
```

### Step 1.2: Stitch MCP Install

```bash
npm list -g @_davideast/stitch-mcp 2>/dev/null || npm install -g @_davideast/stitch-mcp
npx @_davideast/stitch-mcp --version
```

### Step 1.3: OAuth Auth

```bash
# Check auth status
node ~/.claude/plugins/frontend-skills/scripts/setup-stitch-oauth.mjs --check-only

# If not authenticated, run auth (opens browser)
if [ $? -ne 0 ]; then
  node ~/.claude/plugins/frontend-skills/scripts/setup-stitch-oauth.mjs
fi
```

---

## Phase 2: Project Creation

### Step 2.1: Create Project

```
mcp__stitch__create_project(name: "spec-it-{sessionId}")
projectId = response.projectId
```

### Step 2.2: Set Workspace

```
mcp__stitch__set_workspace_project(projectId: projectId)
```

### Step 2.3: Save Metadata

```json
// tmp/{sessionId}/02-screens/stitch-project.json
{
  "projectId": "{projectId}",
  "projectName": "spec-it-{sessionId}",
  "createdAt": "{ISO timestamp}",
  "status": "ready"
}
```

---

## Phase 3: ASCII → Stitch Hi-Fi

### Step 3.0: Generate ASCII Wireframes

```
Task(ui-architect, sonnet):
  Input: chapter-plan-final.md
  Output: screen-list.md, wireframes/wireframe-{screen}.md
```

### Step 3.1: Load Wireframes

```
Read(tmp/{sessionId}/02-screens/screen-list.md)
wireframes = Glob(tmp/{sessionId}/02-screens/wireframes/*.md)
```

### Step 3.2: Convert to Hi-Fi

```
FOR screen IN screens:
  mcp__stitch__generate_screen_from_text(
    projectId: projectId,
    prompt: "Convert ASCII wireframe to Hi-Fi: {screen.ascii}"
  )
  screen.stitchId = response.screenId
```

### Step 3.3: Design QA

```
mcp__stitch__design_qa(projectId: projectId, checks: ["accessibility", "responsive"])
Write(tmp/{sessionId}/02-screens/qa-report.md, qaResults)
```

---

## Phase 4: HTML Export

### Step 4.1: Export Design System

```
mcp__stitch__export_design_system(projectId: projectId, format: "html")
```

### Step 4.2: Save Files

```bash
mkdir -p tmp/{sessionId}/02-screens/html
mkdir -p tmp/{sessionId}/02-screens/assets
# Save HTML files, styles.css, tokens.json
```

---

## Error Handling

| Failure | Fallback |
|---------|----------|
| MCP setup error | ASCII mode |
| OAuth failure | ASCII mode |
| Project creation fail | Retry 3x |
| Screen generation fail | Skip screen, continue |
| Export fail | Partial export |

---

## Output Rules

```
SILENT MODE:
- No terminal logs
- All logs to: tmp/{sessionId}/logs/stitch.log
- Return only: "Done. {N} screens." OR "Failed. {reason}"
```
