# Responsive Grid

반응형 그리드 시스템 정의.

## Columns

| Breakpoint | Columns | Gap |
|------------|---------|-----|
| Mobile (<640px) | 1 | 16px (gap-4) |
| Tablet (640-1024px) | 2 | 16px (gap-4) |
| Desktop (1024-1280px) | 3 | 24px (gap-6) |
| Large (>1280px) | 4 | 24px (gap-6) |

## Implementation

```tsx
// Tailwind utility classes
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 lg:gap-6">
  {/* Grid items */}
</div>
```

## YAML Definition

```yaml
grid:
  type: responsive
  columns:
    default: 1
    sm: 2
    lg: 3
    xl: 4
  gap:
    default: 4  # 16px
    lg: 6       # 24px
```

## Common Patterns

### Full Width Card
```yaml
- type: card
  props:
    className: "col-span-full"
```

### 2-Column Span
```yaml
- type: card
  props:
    className: "col-span-1 lg:col-span-2"
```

### Auto-fit Grid
```yaml
grid:
  type: auto-fit
  minWidth: 300px
  gap: 6
```

```tsx
<div className="grid grid-cols-[repeat(auto-fit,minmax(300px,1fr))] gap-6">
  {/* Auto-sizing cards */}
</div>
```
