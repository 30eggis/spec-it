# auth-centered Layout

Clean centered layout for authentication screens.

## Usage

| Screen | Description |
|--------|-------------|
| SCR-001 | Login |
| Password Reset | - |

## Structure

```yaml
layout:
  type: auth-centered
  background: blob-shapes
  content:
    position: center
    maxWidth: 440px
    children:
      - logo
      - form-card (neumorphic)
      - sso-button
      - footer-links
```

## Responsive

| Breakpoint | Behavior |
|------------|----------|
| Desktop (>1024px) | Centered card 440px max-width, vertical center |
| Tablet (768-1024px) | Centered card 80% width, vertical center |
| Mobile (<768px) | Full-screen card, no margin, top padding 20% |

## Component

```tsx
// layouts/auth-centered.tsx
export function AuthCenteredLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="min-h-screen bg-gray-50 relative overflow-hidden">
      {/* Background blob shapes */}
      <BlobBackground />

      {/* Main content */}
      <div className="relative z-10 flex min-h-screen items-center justify-center px-4 py-12">
        <div className="w-full max-w-[440px]">
          {children}
        </div>
      </div>

      {/* Footer */}
      <footer className="absolute bottom-4 left-0 right-0 text-center">
        <p className="text-sm text-gray-500">
          © 2026 Time & Attendance System
        </p>
      </footer>
    </div>
  );
}
```

## Grid Definition

```yaml
grid:
  areas: |
    "background"
    "content"
    "footer"
  rows: "1fr auto 48px"
  columns: "1fr"

zones:
  background:
    position: absolute
    inset: 0
    zIndex: 0
  content:
    display: flex
    alignItems: center
    justifyContent: center
    zIndex: 10
  footer:
    position: absolute
    bottom: 0
    textAlign: center
```
