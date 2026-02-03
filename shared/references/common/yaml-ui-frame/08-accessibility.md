# Accessibility

접근성 (a11y) 정의.

## Landmarks

```yaml
accessibility:
  landmarks:
    - role: "banner"
      element: "header"
      label: "Main header"

    - role: "navigation"
      element: "sidebar"
      label: "Main navigation"

    - role: "main"
      element: "main"
      label: "Main content"

    - role: "contentinfo"
      element: "footer"
      label: "Footer"
```

## Focus Order

```yaml
accessibility:
  focusOrder:
    - "skip-link"
    - "header-search"
    - "sidebar-nav"
    - "main-content"
    - "footer-links"
```

## Skip Links

```yaml
accessibility:
  skipLinks:
    - href: "#main-content"
      label: "Skip to main content"

    - href: "#navigation"
      label: "Skip to navigation"
```

## ARIA Labels

```yaml
accessibility:
  ariaLabels:
    - element: "sidebar-toggle"
      label: "Toggle sidebar menu"

    - element: "search-input"
      label: "Search"

    - element: "user-menu"
      label: "User menu"
      expanded: "aria-expanded"

    - element: "notifications"
      label: "Notifications"
      count: "aria-label"   # "3 unread notifications"
```

## Focus Management

```yaml
accessibility:
  focusManagement:
    modalOpen:
      action: "trap-focus"
      initialFocus: "first-focusable"

    modalClose:
      action: "return-focus"
      target: "trigger-element"

    drawerOpen:
      action: "trap-focus"

    sidebarCollapse:
      action: "maintain-focus"
```

## Keyboard Navigation

```yaml
accessibility:
  keyboard:
    - pattern: "menu"
      keys:
        - { key: "ArrowDown", action: "next-item" }
        - { key: "ArrowUp", action: "prev-item" }
        - { key: "Enter", action: "select" }
        - { key: "Escape", action: "close" }

    - pattern: "tabs"
      keys:
        - { key: "ArrowRight", action: "next-tab" }
        - { key: "ArrowLeft", action: "prev-tab" }
        - { key: "Home", action: "first-tab" }
        - { key: "End", action: "last-tab" }
```

## Screen Reader

```yaml
accessibility:
  screenReader:
    liveRegions:
      - id: "toast-container"
        role: "status"
        ariaLive: "polite"

      - id: "error-message"
        role: "alert"
        ariaLive: "assertive"

    announcements:
      - trigger: "form-submit"
        message: "Form submitted successfully"

      - trigger: "item-deleted"
        message: "Item deleted"
```

## Color Contrast

```yaml
accessibility:
  contrast:
    minimum: "WCAG AA"   # AA | AAA
    enforced:
      - { foreground: "text", background: "surface", ratio: "4.5:1" }
      - { foreground: "muted", background: "surface", ratio: "3:1" }
```
