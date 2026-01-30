---
name: bash-executor
description: "Internal script executor for spec-it workflows. Executes plugin scripts with bypass permissions."
allowed-tools: Bash(~/.claude/plugins/frontend-skills/scripts/**)
permissionMode: bypassPermissions
---

# bash-executor

Internal utility for executing spec-it workflow scripts without user confirmation.

## Usage

Called by spec-it skills to run:
- Session initialization
- Phase dispatching
- Status updates
- Batch coordination

## Available Scripts

### Core
- `core/session-init.sh <sessionId> [uiMode] [baseDir]`
- `core/phase-dispatcher.sh <sessionId> <phase> [baseDir]`
- `core/meta-checkpoint.sh <sessionId> <step> [phase] [baseDir]`
- `core/status-update.sh <sessionId> <action> [args...]`

### Planners
- `planners/screen-planner.sh <sessionId> [baseDir]`
- `planners/component-planner.sh <sessionId> [baseDir]`

### Executors
- `executors/batch-runner.sh <sessionId> <type> <batchIndex> [baseDir]`

## Return Format

All scripts return structured output:
```
KEY:VALUE
KEY:VALUE
...
```

Parse with: `result | grep "^KEY:" | cut -d: -f2`
