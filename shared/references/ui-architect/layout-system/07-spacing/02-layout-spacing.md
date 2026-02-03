# Layout Spacing

레이아웃 간격 정의.

## Context-based Spacing

| Context | Key | Value | Usage |
|---------|-----|-------|-------|
| Page Padding (Desktop) | 8 | 32px | Main content area |
| Page Padding (Tablet) | 6 | 24px | Main content area |
| Page Padding (Mobile) | 4 | 16px | Main content area |
| Card Padding | 6 | 24px | Card internal spacing |
| Section Gap | 8 | 32px | Between major sections |
| Component Gap | 4 | 16px | Between related components |
| Input Padding (V) | 3 | 12px | Vertical padding |
| Input Padding (H) | 4 | 16px | Horizontal padding |
| Button Padding (V) | 3 | 12px | Vertical padding |
| Button Padding (H) | 6 | 24px | Horizontal padding |

## Responsive Patterns

```tsx
// Page container
<div className="px-4 sm:px-6 lg:px-8">
  Content
</div>

// Card
<div className="p-4 sm:p-6">
  Card content
</div>

// Section gap
<div className="space-y-6 lg:space-y-8">
  <section>...</section>
  <section>...</section>
</div>
```

## YAML Reference

```yaml
designDirection:
  layoutSpacing:
    page:
      desktop: "32px"  # px-8
      tablet: "24px"   # px-6
      mobile: "16px"   # px-4
    card:
      padding: "24px"  # p-6
    section:
      gap: "32px"      # gap-8
    component:
      gap: "16px"      # gap-4
    input:
      paddingY: "12px" # py-3
      paddingX: "16px" # px-4
    button:
      paddingY: "12px" # py-3
      paddingX: "24px" # px-6
```

## Grid Gaps

| Context | Mobile | Tablet | Desktop |
|---------|--------|--------|---------|
| Card Grid | gap-4 | gap-4 | gap-6 |
| Form Fields | gap-4 | gap-4 | gap-4 |
| Stats Grid | gap-4 | gap-4 | gap-6 |

```tsx
// Card grid
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 lg:gap-6">
  {cards}
</div>
```
