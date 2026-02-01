# 02-wireframes Architecture

## Purpose
Define a screen-list architecture that scales by domain and user type, and enables reliable parallel execution.

## Directory Structure
```
02-wireframes/
  layouts/
    layout-system.yaml
    components.yaml
  <domain>/
    shared.md
    <user-type>/
      screen-list.md
      wireframes/{screen-id}.yaml
```

## Screen List Rules (Authoring)
- Location: `02-wireframes/<domain>/<user-type>/screen-list.md`
- Shared screens: `02-wireframes/<domain>/shared.md` only
- User type slugs: `buyer`, `seller`, `admin`, `operator`
- Screen ID format: `<domain>-<user>-<flow>-<seq>` (example: `product-buyer-detail-01`)
- One file per domain + user type (no mixed user types)
- Required fields per screen: `id`, `title`, `flow`, `priority`, `notes`, `depends_on` (optional)

## Shared Rules
- `shared.md` stores domain-level design direction and shared UI components
- Cross-user flows and shared states live in `shared.md`
- If a screen is shared across user types, define it only in `shared.md`

## Execute Parallelization (Implementation)
- Parallel unit: `domain/user-type` folder
- Order: `shared.md` first, then each user-type in parallel
- `depends_on` ordering is enforced only inside the same `screen-list.md`
- Cross-domain dependencies are not allowed; promote to `shared.md` if needed

## ui-arch Parallel Rendering (Wireframe)
- Input: each `screen-list.md` plus the domain `shared.md`
- Output: same folder as the screen list
- File naming: `{screen-id}.yaml`
- Common UI must reuse `shared.md` components
