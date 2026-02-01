# Real-time Dashboard

Monitor spec-it progress in a separate terminal.

## Installation

```bash
# Run install script
bash ~/.claude/plugins/frontend-skills/skills/shared/dashboard/install.sh

# Or create alias manually
alias spec-it-dashboard='~/.claude/plugins/frontend-skills/skills/shared/dashboard/spec-it-dashboard.sh'
```

## Usage

```bash
# Auto-detect active session
spec-it-dashboard

# Specific session
spec-it-dashboard ./tmp/20260130-123456

# Simple watch mode
watch -n 2 ~/.claude/plugins/frontend-skills/skills/shared/dashboard/spec-it-status.sh
```

## Dashboard Display

```
╔══════════════════════════════════════════════════════════════════╗
║  SPEC-IT DASHBOARD                    Runtime: 00:05:32  ║
╠══════════════════════════════════════════════════════════════════╣
║  Session: 20260130-123456
║
║  Phase: 2/6 - UI Architecture
║  Step:  2.1
║  [████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░]  33%
║
╠══════════════════════════════════════════════════════════════════╣
║  AGENTS
║
║  ● ui-architect              [running  ]  00:02:15
║  ✓ component-auditor         [completed]  00:01:30
║  ○ component-builder         [pending  ]
║
╠══════════════════════════════════════════════════════════════════╣
║  STATS
║
║  Files: 12 created
║  Lines: 1847 written
║
║  Recent:
║    + wireframe-login.yaml
║    + wireframe-dashboard.yaml
╚══════════════════════════════════════════════════════════════════╝
```

## Status Icons

| Icon | Meaning |
|------|---------|
| ● | Running |
| ✓ | Completed |
| ○ | Pending |
| ✗ | Error |

## Troubleshooting

### Dashboard not finding session

The dashboard searches for `_status.json` or `_meta.json` in:
1. Provided path argument
2. `./tmp/*/` (current directory)
3. Project's tmp directory

If auto-detection fails, specify the full session path:

```bash
spec-it-dashboard /path/to/project/tmp/20260130-123456
```

### Dashboard logs

Check logs at `/tmp/spec-it-dashboard-*.log` if the dashboard fails to open.
