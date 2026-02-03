# Keyboard Navigation

키보드 네비게이션 가이드.

## Tab Order

1. Skip link ("Skip to main content")
2. Header (logo, search, notifications, profile)
3. Sidebar navigation
4. Main content area
5. Footer

## Skip Link

```tsx
<a
  href="#main-content"
  className="
    sr-only focus:not-sr-only
    focus:absolute focus:top-4 focus:left-4
    focus:z-50 focus:px-4 focus:py-2
    focus:bg-white focus:rounded
    focus:shadow-lg
  "
>
  Skip to main content
</a>

<main id="main-content" tabIndex={-1}>
  ...
</main>
```

## Within Forms

| Key | Action |
|-----|--------|
| Tab | Next field |
| Shift+Tab | Previous field |
| Enter | Submit (on buttons only) |
| Space | Toggle checkbox/radio |
| Arrow | Navigate select/radio |

## Dialog/Modal

| Key | Action |
|-----|--------|
| Tab | Cycle through focusable elements |
| Escape | Close dialog |
| Enter | Confirm (if focused on button) |

```tsx
// Focus trap implementation
<dialog
  onKeyDown={(e) => {
    if (e.key === 'Escape') onClose();
  }}
>
  <FocusTrap>
    {/* Modal content */}
  </FocusTrap>
</dialog>
```

## Custom Components

### Dropdown Menu

```tsx
<div
  role="menu"
  onKeyDown={(e) => {
    if (e.key === 'ArrowDown') focusNext();
    if (e.key === 'ArrowUp') focusPrev();
    if (e.key === 'Escape') close();
    if (e.key === 'Enter') selectCurrent();
  }}
>
  <button role="menuitem" tabIndex={0}>Item 1</button>
  <button role="menuitem" tabIndex={-1}>Item 2</button>
</div>
```

## YAML Reference

```yaml
accessibility:
  keyboard:
    tabOrder:
      - "skip-link"
      - "header"
      - "sidebar"
      - "main"
      - "footer"
    formKeys:
      tab: "Next field"
      shiftTab: "Previous field"
      enter: "Submit"
      space: "Toggle"
      arrow: "Navigate options"
    dialogKeys:
      escape: "Close"
      tab: "Cycle focus"
```

## Testing Checklist

- [ ] Can reach all interactive elements with Tab
- [ ] Tab order is logical (left-to-right, top-to-bottom)
- [ ] Skip link works and is visible on focus
- [ ] Modals trap focus
- [ ] Escape closes modals/dropdowns
