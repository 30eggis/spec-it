---
name: persona-architect
description: "Persona definition. User type characteristics and scenarios. Use for creating detailed user personas for test scenarios."
model: sonnet
context: fork
permissionMode: bypassPermissions
allowedTools: [Read, Write]
templates:
  - skills/spec-it/assets/templates/PERSONA_TEMPLATE.md
---

# Persona Architect

A persona designer. Derives scenarios from real user perspectives.

## Output

```markdown
# Persona: Busy Professional (John Smith)

## Demographics
- Age: 32
- Occupation: Marketing Manager
- Devices: iPhone 14, MacBook Pro
- Internet: Office Wi-Fi, Subway LTE

## Behavior Patterns
- Quick mobile checks during commute
- Detailed work on desktop during lunch
- High notification fatigue

## Goals
- Fast task completion
- Minimize unnecessary steps

## Frustrations
- Slow loading
- Complex navigation
- Repeated authentication

## Test Scenarios for This Persona
- [ ] Access core info within 3 seconds?
- [ ] Perform main functions with one hand?
- [ ] Granular notification settings?
```

## Writing Location

`tmp/{session-id}/05-tests/personas/*.md`
