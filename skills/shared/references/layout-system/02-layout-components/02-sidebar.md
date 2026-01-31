# Sidebar Component

Main navigation sidebar with collapsible sections and role-based menu items.

## States

| State | Width | Description |
|-------|-------|-------------|
| Expanded | 240px | Full text labels, expandable submenus |
| Collapsed | 64px | Icons only, hover to expand submenu |
| Mobile Overlay | 100% | Full-screen overlay with backdrop |

## Structure (YAML)

```yaml
components:
  - type: aside
    zone: sidebar
    props:
      position: fixed
      top: 64px  # Header offset on desktop
      left: 0
      bottom: 0
    styles:
      background: white
      borderRight: "1px solid var(--gray-100)"
      width:
        expanded: 240px
        collapsed: 64px
    children:
      # Logo + Close/Collapse
      - type: div
        props:
          height: 64px
          display: flex
          alignItems: center
          justifyContent: space-between
          borderBottom: "1px solid var(--gray-100)"
        children:
          - type: logo
            props: { size: "sm" }
            condition: "!collapsed"
          - type: button
            props: { variant: ghost }
            testId: sidebar-toggle

      # Navigation
      - type: nav
        props:
          padding: 2
          overflowY: auto
          height: "calc(100vh - 64px)"
        children:
          - type: nav-section
            props: { title: "Main" }
            children:
              - type: nav-item
                props: { href: "/dashboard", icon: "home", label: "Dashboard" }
                testId: nav-dashboard

          - type: nav-section
            props: { title: "My Work" }
            children:
              - type: nav-item
                props: { href: "/attendance/clock", icon: "clock", label: "Clock In/Out" }
                testId: nav-clock
              - type: nav-item
                props: { href: "/attendance/status", icon: "calendar-check", label: "Status" }
                testId: nav-status
              - type: nav-item
                props: { href: "/attendance/timesheet", icon: "table", label: "Timesheet" }
                testId: nav-timesheet

          - type: nav-section
            props: { title: "Requests" }
            children:
              - type: nav-item
                props: { href: "/requests", icon: "file-text", label: "List" }
                testId: nav-requests
              - type: nav-item
                props: { href: "/requests/leave/new", icon: "umbrella", label: "Leave" }
                testId: nav-leave
              - type: nav-item
                props: { href: "/requests/overtime/new", icon: "clock-plus", label: "Overtime" }
                testId: nav-overtime

          # Role-based section
          - type: nav-section
            props: { title: "Approvals" }
            condition: "user.isManager"
            children:
              - type: nav-item
                props: { href: "/approvals/pending", icon: "check-circle", label: "Pending" }
                badge: "pendingCount"
                testId: nav-approvals

          - type: nav-section
            props: { title: "Support" }
            children:
              - type: nav-item
                props: { href: "/help", icon: "help-circle", label: "Help" }
                testId: nav-help
```

## Design Tokens

| Property | Value |
|----------|-------|
| Background | white |
| Border | Right 1px gray-100 |
| Item Hover | bg-gray-100 + rounded-lg |
| Active Item | bg-blue-50 + left border accent |
| Badge | Absolute positioned, blue-500 background |

## Mobile Backdrop

```yaml
- type: div
  condition: "open && isMobile"
  props:
    position: fixed
    inset: 0
    background: "rgba(0,0,0,0.5)"
    zIndex: 40
  onClick: onClose
```
