# Header Component

Global header with logo, search, notifications, and user menu.

## Variants

| Variant | Elements |
|---------|----------|
| Desktop | Logo + Search Input + Notifications + User Avatar |
| Tablet | Logo + Search (dropdown) + Notifications + User |
| Mobile | Hamburger + Logo + Notifications + User |

## Structure (YAML)

```yaml
components:
  - type: header
    zone: header
    props:
      position: fixed
      height: 64px
    styles:
      background: "rgba(255,255,255,0.9)"
      backdropFilter: "blur(12px)"
      borderBottom: "1px solid var(--gray-100)"
      boxShadow: "var(--shadow-sm)"
    children:
      - type: container
        props:
          display: flex
          alignItems: center
          justifyContent: space-between
          height: "100%"
        children:
          # Left: Hamburger (mobile) + Logo
          - type: div
            props:
              display: flex
              alignItems: center
              gap: 4
            children:
              - type: button
                props:
                  variant: ghost
                  className: "lg:hidden"
                testId: header-menu-btn
                children:
                  - type: icon
                    props: { name: "menu" }
              - type: logo
                testId: header-logo

          # Center: Search (desktop)
          - type: search-input
            props:
              className: "hidden md:block flex-1 max-w-lg mx-8"
            testId: header-search

          # Right: Notifications + User
          - type: div
            props:
              display: flex
              alignItems: center
              gap: 2
            children:
              - type: notification-button
                testId: header-notifications
              - type: user-menu
                testId: header-user-menu
```

## Component Code

```tsx
// components/layout/header.tsx
export function Header({ onMenuClick }: { onMenuClick: () => void }) {
  return (
    <header className="
      fixed top-0 left-0 right-0 z-50
      h-16 px-4 sm:px-6
      bg-white/90 backdrop-blur-lg
      border-b border-gray-100
      shadow-sm
    ">
      <div className="flex items-center justify-between h-full">
        {/* Left: Hamburger (mobile) + Logo */}
        <div className="flex items-center gap-4">
          <button
            onClick={onMenuClick}
            className="lg:hidden p-2 rounded-lg hover:bg-gray-100"
            data-testid="header-menu-btn"
          >
            <MenuIcon />
          </button>
          <Logo data-testid="header-logo" />
        </div>

        {/* Center: Search (desktop only) */}
        <div className="hidden md:block flex-1 max-w-lg mx-8">
          <SearchInput data-testid="header-search" />
        </div>

        {/* Right: Notifications + User */}
        <div className="flex items-center gap-2">
          <NotificationButton data-testid="header-notifications" />
          <UserMenu data-testid="header-user-menu" />
        </div>
      </div>
    </header>
  );
}
```

## Design Tokens

| Property | Value |
|----------|-------|
| Background | white/90% + backdrop blur |
| Shadow | shadow-sm (0 2px 4px rgba(0,0,0,0.06)) |
| Height | 64px fixed |
| Border | Bottom 1px gray-100 |
| Z-index | 50 |
