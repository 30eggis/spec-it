# Phase 4: spec-it Mode Execution

## Step 4.1: Map Mode to Skill

| User Selection | Skill |
|----------------|-------|
| Step-by-Step | `spec-it-stepbystep` |
| Complex/Hybrid | `spec-it-complex` |
| Full Automation | `spec-it-automation` |
| Fast Launch | `spec-it-fast-launch` |

## Step 4.2: Invoke Selected Mode

```
Skill(${skillName}, {
  --resume: ${SESSION_ID},
  --design-style: "Custom File",
  --design-trends: "${SESSION_DIR}/plan/design-context.yaml",
  --dashboard: "Enable",
  --skip-requirements: true,
  --skip-wireframes: true
})
```

## Step 4.3: Auto-Execute Modes

For "Full Automation" and "Fast Launch":
- Automatically proceeds to `spec-it-execute`

For "Step-by-Step" and "Complex/Hybrid":
- User approvals at defined checkpoints

## Error Handling

| Error | Action |
|-------|--------|
| Target URL unreachable | Prompt for Chrome Extension data |
| Design system not found | Offer Built-in (2026 Trends) |
| hack-2-spec fails | Show error, allow intervention |
| spec-it mode fails | Resume from checkpoint |
