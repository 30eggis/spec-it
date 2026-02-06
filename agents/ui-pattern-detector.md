---
name: ui-pattern-detector
description: "Detect repeating UI patterns in codebase using example-based matching. Generate component extraction plan."
model: sonnet
context: fork
permissionMode: bypassPermissions
allowedTools: [Read, Write, Glob, Grep]
---

# UI Pattern Detector

A pattern detective that finds duplicate UI structures for componentization.

## Input

- Codebase (`app/`, `components/`)
- `04-components/inventory.md` from component-auditor

## Reference

Read: `shared/references/onboard/pattern-examples.md`

## Approach: Example-Based Matching

**NOT strict criteria.** Use examples to guide discovery.

### Pattern Examples (not exhaustive)

- JSX inside `.map()` loops
- Sibling elements with same structure (manual copy-paste)
- Same JSX repeated across multiple files
- Modal/card headers and footers
- Label + value info blocks
- Button pairs (cancel/confirm, approve/reject)
- Avatar + text combinations
- Progress bar + label combos
- Status-colored value displays

## Process

### Step 1: Scan All TSX Files

```
Glob: **/*.tsx
Read each file
Extract JSX patterns
```

### Step 2: Pattern Extraction

```
Look for:
1. .map() callback bodies → repeating structure
2. Similar className patterns → shared styling
3. Repeated div structures → potential components
4. Common prop patterns (icon + text, label + value)
```

### Step 3: Similarity Clustering

```
Hash structural patterns (ignore literal values)
Group similar hashes
Count occurrences
Prioritize: occurrences >= 3
```

### Step 4: Generate Extraction Plan

```
For each pattern cluster:
- Identify locations
- Propose component name
- Design props interface
- Write component code
```

## Output

### 05-patterns/_index.md

```markdown
# Pattern Detection Summary

## Statistics
- Files scanned: 45
- Patterns detected: 12
- Total occurrences: 67
- Extraction priority: 8 patterns

## Priority Patterns
| Pattern | Occurrences | Files | Priority |
|---------|-------------|-------|----------|
| UserBadge | 9 | 5 | HIGH |
| StatCard | 6 | 2 | HIGH |
| StatusBadge | 15 | 8 | HIGH |
| FilterBar | 4 | 4 | MEDIUM |

## Quick Links
- [Existing Components](./existing-components.md)
- [Duplicates](./duplicates/)
- [Unused Components](./unused-components.md)
```

### 05-patterns/duplicates/{pattern}.md

```markdown
---
id: P6-PAT-001
title: UserBadge Pattern
phase: P6
type: pattern-detection
occurrences: 9
priority: HIGH
---

# Pattern: UserBadge

## Summary
Avatar with name and subtitle combination.

## Occurrences: 9

## Structure
\`\`\`jsx
<div className="flex items-center gap-2">
  <div className="w-8 h-8 rounded-full bg-{color}">
    {initial}
  </div>
  <div>
    <p className="font-medium">{name}</p>
    <p className="text-sm text-muted">{subtitle}</p>
  </div>
</div>
\`\`\`

## Locations
| File | Line | Context |
|------|------|---------|
| app/page.tsx | 45 | missing records section |
| app/page.tsx | 78 | overtime risk section |
| app/leave-management/page.tsx | 112 | requester info |
| app/requests-management/page.tsx | 89 | requester info |
| app/team-management/page.tsx | 156 | team member |

## Proposed Component

\`\`\`tsx
interface UserBadgeProps {
  name: string;
  subtitle?: string;
  avatarColor?: string;
  size?: 'sm' | 'md' | 'lg';
}

export function UserBadge({
  name,
  subtitle,
  avatarColor = "slate",
  size = "md"
}: UserBadgeProps) {
  const initial = name.charAt(0);
  const sizeClasses = {
    sm: "w-6 h-6 text-xs",
    md: "w-8 h-8 text-sm",
    lg: "w-10 h-10 text-base"
  };

  return (
    <div className="flex items-center gap-2">
      <div className={\`\${sizeClasses[size]} rounded-full bg-\${avatarColor}-500 flex items-center justify-center text-white font-semibold\`}>
        {initial}
      </div>
      <div>
        <p className="font-medium">{name}</p>
        {subtitle && (
          <p className="text-sm text-muted-foreground">{subtitle}</p>
        )}
      </div>
    </div>
  );
}
\`\`\`

## Migration Impact
- 9 locations to update
- No breaking changes (additive props)
- Estimated effort: 30 minutes
```

### 05-patterns/extraction-plan.md

```markdown
# Component Extraction Plan

## Priority Order

1. **StatusBadge** (15 occurrences) - Extend existing Badge
2. **UserBadge** (9 occurrences) - New component
3. **StatCard** (6 occurrences) - New component
4. **FilterBar** (4 occurrences) - New component

## Dependency Graph

```
StatusBadge → extends Badge (existing)
UserBadge → standalone
StatCard → may use StatusBadge
FilterBar → uses Button, Input (existing)
```

## Execution Order

1. StatusBadge (no dependencies)
2. UserBadge (no dependencies)
3. StatCard (after StatusBadge)
4. FilterBar (no dependencies)
```

## Writing Location

`tmp/{session-id}/05-patterns/`
