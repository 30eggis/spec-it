# Mobile Bottom Navigation

Bottom navigation bar for mobile (<768px) with primary actions.

## Items (4 max)

| Item | Icon | Label | Condition |
|------|------|-------|-----------|
| Dashboard | home | Home | Always |
| Requests | file-text | Requests | Always |
| Approvals | check-circle | Approve | user.isManager |
| Profile | user | Me | Always |

## Structure (YAML)

```yaml
components:
  - type: nav
    zone: bottomnav
    props:
      position: fixed
      bottom: 0
      left: 0
      right: 0
      zIndex: 40
      className: "lg:hidden"
    styles:
      height: 56px
      background: white
      borderTop: "1px solid var(--gray-100)"
      boxShadow: "0 -2px 8px rgba(0,0,0,0.06)"
    children:
      - type: div
        props:
          display: flex
          alignItems: center
          justifyContent: space-around
          height: "100%"
          padding: "0 8px"
        children:
          - type: bottom-nav-item
            props:
              href: "/dashboard"
              icon: "home"
              label: "Home"
            testId: bottomnav-home

          - type: bottom-nav-item
            props:
              href: "/requests"
              icon: "file-text"
              label: "Requests"
            testId: bottomnav-requests

          - type: bottom-nav-item
            props:
              href: "/approvals/pending"
              icon: "check-circle"
              label: "Approvals"
              badge: true
            condition: "user.isManager"
            testId: bottomnav-approvals

          - type: bottom-nav-item
            props:
              href: "/profile"
              icon: "user"
              label: "Profile"
            testId: bottomnav-profile
```

## Component Code

```tsx
// components/layout/mobile-bottom-nav.tsx
export function MobileBottomNav({ className }: { className?: string }) {
  const pathname = usePathname();
  const { user } = useAuth();

  const items = [
    { href: "/dashboard", icon: Home, label: "Home" },
    { href: "/requests", icon: FileText, label: "Requests" },
    ...(user.isManager ? [
      { href: "/approvals/pending", icon: CheckCircle, label: "Approvals", badge: true }
    ] : []),
    { href: "/profile", icon: User, label: "Profile" },
  ];

  return (
    <nav className={cn(
      "fixed bottom-0 left-0 right-0 z-40",
      "h-14 bg-white border-t border-gray-100",
      "shadow-[0_-2px_8px_rgba(0,0,0,0.06)]",
      className
    )}>
      <div className="flex items-center justify-around h-full px-2">
        {items.map((item) => (
          <Link
            key={item.href}
            href={item.href}
            className={cn(
              "relative flex flex-col items-center justify-center",
              "flex-1 h-full",
              "transition-colors duration-200",
              pathname === item.href
                ? "text-blue-600"
                : "text-gray-500 hover:text-gray-700"
            )}
            data-testid={`bottomnav-${item.label.toLowerCase()}`}
          >
            <item.icon className="w-6 h-6" />
            <span className="text-xs mt-1">{item.label}</span>
            {item.badge && pendingCount > 0 && (
              <span className="absolute top-1 right-2 w-2 h-2 bg-red-500 rounded-full" />
            )}
          </Link>
        ))}
      </div>
    </nav>
  );
}
```

## Design Tokens

| Property | Value |
|----------|-------|
| Height | 56px |
| Background | white |
| Border | Top 1px gray-100 |
| Shadow | 0 -2px 8px rgba(0,0,0,0.06) |
| Active Color | blue-600 |
| Inactive Color | gray-500 |
