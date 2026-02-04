# Phase 3-4: Component Analysis & Catalog Reference

## 3.1 Pattern Detection

Analyze all `extracted/*/source.tsx` for:

**Structural patterns:**
- Same className combination appearing 3+ times
- Same DOM structure (tag + children pattern)

**Semantic candidates:**
- Layout: Header, Footer, Sidebar, PageLayout
- Data display: Card, Table, List, Grid
- Form elements: Button, Input, Select, Checkbox
- Overlays: Modal, Dropdown, Toast, Tooltip

## 3.2 Scoring System

| Criterion | Points |
|-----------|--------|
| Found in 3+ pages | +3 |
| 2+ instances same page | +2 |
| Clear semantic role (header, nav, etc.) | +2 |
| Independent styling | +1 |
| Props extractable | +1 |

**Threshold: Score >= 5 → Extract as component**

## 3.3 Component Template

```typescript
// components/ui/{ComponentName}.tsx
import { cn } from '@/lib/utils';

interface {ComponentName}Props {
  // Extracted props
  className?: string;
}

export function {ComponentName}({ className, ...props }: {ComponentName}Props) {
  return (
    <div className={cn(
      "token-based-classes",
      className
    )}>
      {/* Original structure */}
    </div>
  );
}
```

## 3.4 Component Catalog Format

```markdown
# Component Catalog

## Layout Components

### Header
- **File:** components/layout/Header.tsx
- **Used In:** P001, P002, P003...
- **Props:**
  | Prop | Type | Required | Description |
  |------|------|----------|-------------|
  | user | User | Yes | Current user |
  | onMenuClick | () => void | No | Mobile menu toggle |

### Sidebar
- **File:** components/layout/Sidebar.tsx
- **Used In:** P001, P002...
- **Props:** ...

## UI Components

### StatCard
- **File:** components/ui/StatCard.tsx
- **Used In:** P001, P005
- **Variants:** default, compact, with-chart
- **Props:**
  | Prop | Type | Required |
  |------|------|----------|
  | title | string | Yes |
  | value | string \| number | Yes |
  | change | string | No |
  | icon | ReactNode | No |

## Replacement Map

| Original Pattern | Replace With |
|-----------------|--------------|
| `<header className="...">` | `<Header user={user} />` |
| `<div className="rounded-lg border...">` (stat pattern) | `<StatCard {...props} />` |
| `<nav className="...">` (sidebar) | `<Sidebar items={navItems} />` |
```

## 3.5 Component Categories

**layout/** - Page structure
- Header.tsx
- Sidebar.tsx
- Footer.tsx
- PageLayout.tsx

**ui/** - Reusable UI elements
- Button.tsx
- Card.tsx
- StatCard.tsx
- DataTable.tsx
- FilterBar.tsx
- Badge.tsx
- Avatar.tsx

**icons/** - Extracted SVG icons
- {IconName}.tsx (React component wrapper)
