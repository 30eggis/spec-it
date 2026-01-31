# Breakpoint Values

반응형 브레이크포인트 값.

## Tailwind Default Breakpoints

| Breakpoint | Width | Usage |
|------------|-------|-------|
| sm | 640px | Small devices (landscape phones) |
| md | 768px | Medium devices (tablets) |
| lg | 1024px | Large devices (desktops) |
| xl | 1280px | Extra large devices |
| 2xl | 1536px | 2X large devices |

## CSS Media Queries

```css
/* Small devices */
@media (min-width: 640px) { /* sm: */ }

/* Medium devices */
@media (min-width: 768px) { /* md: */ }

/* Large devices */
@media (min-width: 1024px) { /* lg: */ }

/* Extra large devices */
@media (min-width: 1280px) { /* xl: */ }

/* 2X large devices */
@media (min-width: 1536px) { /* 2xl: */ }
```

## YAML Reference

```yaml
designDirection:
  responsive:
    breakpoints:
      sm: "640px"
      md: "768px"
      lg: "1024px"
      xl: "1280px"
      2xl: "1536px"
```

## Mobile-First Approach

Always start with mobile styles, then add breakpoint modifiers:

```tsx
// Wrong: desktop-first
<div className="w-1/4 sm:w-full" />

// Correct: mobile-first
<div className="w-full sm:w-1/4" />
```

## Container Widths

| Breakpoint | Max Width |
|------------|-----------|
| sm | 640px |
| md | 768px |
| lg | 1024px |
| xl | 1280px |
| 2xl | 1536px |

```tsx
<div className="container mx-auto px-4">
  Content with auto container width
</div>
```
