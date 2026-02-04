# Output Structure

## Directory Layout

```
hack-2-nextjs/
├── route_map.json              # Central registry
├── design-systems/
│   ├── default/
│   │   └── tokens.json         # Default design tokens
│   └── dark/
│       └── tokens.json         # Dark variant
├── analysis/
│   ├── patterns.json           # Detected repeated patterns
│   ├── components.json         # Extracted components list
│   └── design-tokens.json      # Raw extracted tokens
└── nextjs-app/
    ├── app/
    │   ├── layout.tsx          # Root layout
    │   ├── page.tsx            # Home page
    │   └── globals.css         # Global styles
    ├── components/
    │   ├── ui/                 # Shared UI components
    │   │   ├── Modal.tsx
    │   │   ├── ToastProvider.tsx
    │   │   └── ProgressRing.tsx
    │   ├── layout/             # App shells, navigation
    │   │   ├── AppShell.tsx
    │   │   ├── Sidebar.tsx
    │   │   ├── Header.tsx
    │   │   └── Breadcrumb.tsx
    │   ├── dashboard/          # Page-specific widgets
    │   │   ├── StatCard.tsx
    │   │   ├── TimeClock.tsx
    │   │   └── Calendar.tsx
    │   └── icons/
    │       └── Icons.tsx       # All icons
    ├── lib/
    │   ├── routeMap.ts         # Route map utilities
    │   ├── designSystem.ts     # Design system switcher
    │   └── types.ts            # Shared types
    ├── public/                 # Static assets
    │   └── images/
    ├── package.json
    ├── tailwind.config.ts
    └── tsconfig.json
```

## Key Files

### route_map.json
Central configuration for routes, shells, and components.

### design-systems/*/tokens.json
Design tokens for each visual variant.

### analysis/*.json
Intermediate analysis results (useful for debugging).

### components/layout/AppShell.tsx
Main shell component that wraps all pages.

### lib/routeMap.ts
Utilities to read and use route_map.json.

### lib/designSystem.ts
Design system switching logic.
