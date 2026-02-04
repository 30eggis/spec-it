# Design System (Switchable)

## Concept

Design System ≠ Theme (dark/light)
Design System = Complete visual identity that can be swapped

```
design-systems/
├── default/tokens.json     ← Suprema brand (blue, rounded)
├── dark/tokens.json        ← Dark variant
└── brand-b/tokens.json     ← Different client (green, sharp)
```

## Token Extraction

```javascript
evaluate_script({
  function: `() => {
    const tokens = { colors: {}, typography: {}, spacing: {}, borders: {}, shadows: {} };
    document.querySelectorAll('*').forEach(el => {
      const styles = getComputedStyle(el);
      // Collect unique colors, fonts, spacing values
    });
    return tokens;
  }`
})
```

## Token Structure

```json
{
  "name": "Suprema Default",
  "colors": {
    "primary": {
      "50": "#eff6ff",
      "500": "#3b82f6",
      "600": "#2563eb",
      "700": "#1d4ed8"
    },
    "background": {
      "default": "#f8fafc",
      "card": "#ffffff",
      "sidebar": "#ffffff"
    },
    "text": {
      "primary": "#1e293b",
      "secondary": "#64748b",
      "muted": "#94a3b8"
    },
    "status": {
      "success": "#22c55e",
      "warning": "#f59e0b",
      "error": "#ef4444",
      "info": "#3b82f6"
    }
  },
  "typography": {
    "fontFamily": {
      "sans": "system-ui, -apple-system, sans-serif",
      "mono": "monospace"
    },
    "fontSize": {
      "xs": "0.75rem",
      "sm": "0.875rem",
      "base": "1rem",
      "lg": "1.125rem",
      "xl": "1.25rem",
      "2xl": "1.5rem"
    }
  },
  "spacing": {
    "1": "0.25rem",
    "2": "0.5rem",
    "4": "1rem",
    "6": "1.5rem",
    "8": "2rem"
  },
  "borderRadius": {
    "sm": "0.25rem",
    "md": "0.5rem",
    "lg": "0.75rem",
    "xl": "1rem",
    "2xl": "1.5rem",
    "full": "9999px"
  },
  "shadows": {
    "sm": "0 1px 2px rgba(0,0,0,0.05)",
    "md": "0 4px 6px rgba(0,0,0,0.1)",
    "lg": "0 10px 15px rgba(0,0,0,0.1)"
  }
}
```

## Design System Switcher

```typescript
// lib/designSystem.ts
import defaultTokens from '@/design-systems/default/tokens.json';
import darkTokens from '@/design-systems/dark/tokens.json';

const systems = { default: defaultTokens, dark: darkTokens };

export function useDesignSystem(name: string = 'default') {
  const tokens = systems[name] || systems.default;

  useEffect(() => {
    Object.entries(tokens.colors).forEach(([category, values]) => {
      Object.entries(values).forEach(([key, value]) => {
        document.documentElement.style.setProperty(
          `--color-${category}-${key}`, value
        );
      });
    });
  }, [tokens]);

  return tokens;
}
```

## Creating New Design System

```json
// design-systems/brand-b/tokens.json
{
  "name": "Brand B",
  "colors": {
    "primary": {
      "500": "#10b981",  // Green instead of blue
      "600": "#059669"
    },
    "background": {
      "default": "#fafafa",
      "card": "#ffffff"
    }
  }
}
```

## Usage

```tsx
<AppShell shell="employee" designSystem="brand-b">
  <Dashboard />
</AppShell>
```
