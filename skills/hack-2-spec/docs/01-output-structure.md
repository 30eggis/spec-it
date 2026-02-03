# hack-2-spec Output Structure

Output structure must match spec-it exactly for seamless integration.

## Standard Output Structure

```
{output-folder}/
├── 00-requirements/
│   └── requirements.md          # Extracted requirements (REQ-### format)
│
├── 01-chapters/
│   └── decisions/
│       └── decision-summary.md  # Key decisions from analysis
│
├── 02-wireframes/
│   ├── layouts/
│   │   ├── layout-system.yaml   # Grid, breakpoints, spacing
│   │   └── components.yaml      # Shared component definitions
│   ├── domain-map.md            # Domain → User type mapping
│   └── <domain>/
│       ├── shared.md            # Domain-specific shared elements
│       └── <user-type>/
│           ├── screen-list.md   # Screen inventory
│           └── wireframes/
│               └── {screen-id}.yaml  # YAML wireframes
│
├── 03-components/
│   ├── inventory.md             # Component inventory
│   └── specs/
│       └── {ComponentName}.yaml # Component specifications
│
├── 04-review/
│   └── scenarios/
│       └── critical-path.md     # Critical user paths
│
├── 05-tests/
│   └── coverage-map.md          # Test coverage mapping
│
└── 06-final/
    ├── final-spec.md            # Consolidated specification
    ├── dev-tasks.md             # Development tasks
    └── SPEC-SUMMARY.md          # Executive summary
```

## Template References

Use templates from `skills/spec-it-stepbystep/assets/templates/`:

| Output File | Template |
|-------------|----------|
| requirements.md | (freeform - REQ-### format) |
| layout-system.yaml | `LAYOUT_TEMPLATE.yaml` |
| screen-list.md | `SCREEN_LIST_TEMPLATE.md` |
| wireframes/*.yaml | `UI_WIREFRAME_TEMPLATE.yaml` |
| inventory.md | `COMPONENT_INVENTORY_TEMPLATE.md` |
| specs/*.yaml | `COMPONENT_SPEC_TEMPLATE.yaml` |
| scenarios/*.md | `SCENARIO_TEMPLATE.md` |
| coverage-map.md | `COVERAGE_MAP_TEMPLATE.md` |

## Requirements Format (REQ-###)

```markdown
## REQ-DASH-001: Dashboard Overview
- REQ-DASH-001-01: Display real-time attendance stats
- REQ-DASH-001-02: Filter by date range
- REQ-DASH-001-03: Filter by organization

## REQ-USER-001: User Management
- REQ-USER-001-01: List all users
- REQ-USER-001-02: Search users by name
```

## Wireframe YAML Format

Must use `_ref:*` token references if designContext is enabled:

```yaml
meta:
  screen_id: "SCR-HR-001"
  title: "HR Dashboard"
  route: "/hr/dashboard"

grid:
  desktop:
    areas: |
      "header header header"
      "stats stats stats"
      "card1 card2 card3"
    columns: "1fr 1fr 1fr"
    gap: "_ref:spacing.24"

sections:
  - id: "header"
    layout:
      background: "_ref:color.semantic.bg.neutral.primary"
      padding: "_ref:spacing.24"
```

## Integration with spec-it

When hack-2-spec output is used with spec-it:

```
hack-2-spec output → .spec-it/{sessionId}/plan/tmp/
                            ↓
                     spec-it --resume {sessionId}
                            ↓
                     Continues from existing wireframes
```
