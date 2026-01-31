# Breakpoint Strategy

T&A 시스템 브레이크포인트 전략.

## Custom Breakpoints

| Breakpoint | Width | Layout Behavior |
|------------|-------|-----------------|
| **Mobile** | < 768px | Single column, bottom nav, overlay sidebar |
| **Tablet** | 768-1024px | 2-column grid, collapsible sidebar (icons-only) |
| **Desktop** | > 1024px | 3-4 column grid, persistent sidebar (full) |

## Component Breakpoints

### Sidebar

```tsx
<aside className={cn(
  "w-60",              // Desktop: full width (240px)
  "md:w-16",           // Tablet: icons only (64px)
  "max-md:-translate-x-full" // Mobile: hidden
)} />
```

### Grid

```tsx
<div className={cn(
  "grid",
  "grid-cols-1",       // Mobile: 1 column
  "md:grid-cols-2",    // Tablet: 2 columns
  "lg:grid-cols-3",    // Desktop: 3 columns
  "xl:grid-cols-4"     // Large: 4 columns
)} />
```

### Header

```tsx
<header>
  {/* Search: hidden on mobile */}
  <div className="hidden md:block">
    <SearchInput />
  </div>

  {/* Hamburger: visible on mobile only */}
  <button className="lg:hidden">
    <MenuIcon />
  </button>
</header>
```

### Bottom Navigation

```tsx
{/* Visible only on mobile */}
<nav className="lg:hidden fixed bottom-0">
  <BottomNav />
</nav>
```

## YAML Reference

```yaml
responsive:
  strategy:
    mobile:
      maxWidth: "767px"
      grid: 1
      sidebar: "hidden"
      bottomNav: "visible"
    tablet:
      range: "768px - 1023px"
      grid: 2
      sidebar: "collapsed (64px)"
      bottomNav: "hidden"
    desktop:
      minWidth: "1024px"
      grid: "3-4"
      sidebar: "expanded (240px)"
      bottomNav: "hidden"

  components:
    sidebar:
      desktop: "w-60"
      tablet: "w-16"
      mobile: "-translate-x-full"
    search:
      desktop: "visible"
      tablet: "visible"
      mobile: "hidden"
    hamburger:
      desktop: "hidden"
      tablet: "hidden"
      mobile: "visible"
```

## Testing Checklist

- [ ] Mobile (375px): Single column, bottom nav, hamburger menu
- [ ] Tablet Portrait (768px): 2 columns, collapsed sidebar
- [ ] Tablet Landscape (1024px): 3 columns, expanded sidebar
- [ ] Desktop (1280px): 4 columns, full layout
- [ ] Large (1536px): Maximum container width
