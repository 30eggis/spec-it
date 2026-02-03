# dashboard-with-sidebar Layout

Main application layout with persistent sidebar, header, and content area.

## Usage

All authenticated screens except login.

## Grid Definition

```yaml
grid:
  areas:
    desktop: |
      "header header"
      "sidebar main"
    tablet: |
      "header"
      "main"
    mobile: |
      "header"
      "main"
      "bottomnav"
  columns:
    desktop: "240px 1fr"  # 64px when collapsed
    tablet: "1fr"
    mobile: "1fr"
  rows:
    desktop: "64px 1fr"
    tablet: "64px 1fr"
    mobile: "64px 1fr 56px"
```

## Zones

| Zone | Desktop | Tablet | Mobile |
|------|---------|--------|--------|
| header | Fixed top, full width | Fixed top, full width | Fixed top, full width |
| sidebar | 240px/64px, fixed left | 64px icons-only or overlay | Hidden (hamburger overlay) |
| main | Flex 1, padding 24px | Flex 1, padding 16px | Flex 1, padding 12px |
| bottomnav | Hidden | Hidden | Fixed bottom, 56px |

## Component

```tsx
// layouts/dashboard-with-sidebar.tsx
export function DashboardLayout({ children }: { children: React.ReactNode }) {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [sidebarCollapsed, setSidebarCollapsed] = useState(false);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <Header onMenuClick={() => setSidebarOpen(true)} />

      <div className="flex">
        {/* Sidebar */}
        <Sidebar
          open={sidebarOpen}
          collapsed={sidebarCollapsed}
          onClose={() => setSidebarOpen(false)}
          onToggleCollapse={() => setSidebarCollapsed(!sidebarCollapsed)}
        />

        {/* Main Content */}
        <main className={cn(
          "flex-1 transition-all duration-300",
          "pt-16", // Header offset
          "px-4 py-6 sm:px-6 lg:px-8",
          sidebarCollapsed ? "lg:ml-16" : "lg:ml-60"
        )}>
          {children}
        </main>
      </div>

      {/* Mobile Bottom Nav */}
      <MobileBottomNav className="lg:hidden" />
    </div>
  );
}
```

## Dimensions

| Element | Value |
|---------|-------|
| Sidebar Width (expanded) | 240px |
| Sidebar Width (collapsed) | 64px |
| Header Height | 64px (sticky) |
| Main Padding (desktop) | 24px |
| Main Padding (tablet) | 16px |
| Main Padding (mobile) | 12px |
| Bottom Nav Height | 56px |
