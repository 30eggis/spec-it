# Screen Reader Support

스크린 리더 지원 가이드.

## ARIA Landmarks

```html
<header role="banner">
  <nav role="navigation" aria-label="Main navigation">
    ...
  </nav>
</header>

<main role="main" aria-label="Page content">
  ...
</main>

<aside role="complementary" aria-label="Sidebar">
  ...
</aside>

<footer role="contentinfo">
  ...
</footer>
```

## Live Regions

### Status Messages (Polite)

```html
<div role="status" aria-live="polite">
  Loading...
</div>

<div role="status" aria-live="polite">
  3 results found
</div>
```

### Error Messages (Assertive)

```html
<div role="alert" aria-live="assertive">
  Form submission failed
</div>

<div role="alert" aria-live="assertive">
  Password must be at least 8 characters
</div>
```

## Common Patterns

### Icon Button

```tsx
<button aria-label="Close dialog">
  <XIcon aria-hidden="true" />
</button>
```

### Loading State

```tsx
<button disabled aria-busy="true">
  <Spinner aria-hidden="true" />
  <span>Saving...</span>
</button>
```

### Form Field

```tsx
<div>
  <label htmlFor="email">Email</label>
  <input
    id="email"
    type="email"
    aria-describedby="email-error"
    aria-invalid={hasError}
  />
  {hasError && (
    <p id="email-error" role="alert">
      Please enter a valid email
    </p>
  )}
</div>
```

### Modal Dialog

```tsx
<dialog
  role="dialog"
  aria-modal="true"
  aria-labelledby="dialog-title"
  aria-describedby="dialog-description"
>
  <h2 id="dialog-title">Confirm Action</h2>
  <p id="dialog-description">Are you sure?</p>
</dialog>
```

## YAML Reference

```yaml
accessibility:
  aria:
    landmarks:
      header: { role: "banner" }
      nav: { role: "navigation", ariaLabel: "Main navigation" }
      main: { role: "main", ariaLabel: "Page content" }
      aside: { role: "complementary", ariaLabel: "Sidebar" }
      footer: { role: "contentinfo" }
    liveRegions:
      status: { role: "status", ariaLive: "polite" }
      alert: { role: "alert", ariaLive: "assertive" }
    patterns:
      iconButton: { ariaLabel: "required" }
      loading: { ariaBusy: true }
      modal: { role: "dialog", ariaModal: true }
```

## Testing Checklist

- [ ] All images have alt text
- [ ] All icon buttons have aria-label
- [ ] Form fields have associated labels
- [ ] Error messages are announced
- [ ] Loading states are announced
- [ ] Landmarks are properly defined
