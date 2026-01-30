# shadcn/ui Component List

Reference list of shadcn/ui components for spec-it.

## Installation Command

```bash
npx shadcn-ui@latest add [component-name]
```

## Component List

### Form Components

| Component | Purpose | Dependencies |
|-----------|---------|--------------|
| Button | Button | - |
| Input | Text input | - |
| Textarea | Multi-line input | - |
| Checkbox | Checkbox | @radix-ui/react-checkbox |
| Radio Group | Radio buttons | @radix-ui/react-radio-group |
| Select | Dropdown selection | @radix-ui/react-select |
| Switch | Toggle switch | @radix-ui/react-switch |
| Slider | Slider | @radix-ui/react-slider |
| Form | Form container | react-hook-form, zod |
| Label | Label | @radix-ui/react-label |

### Layout Components

| Component | Purpose | Dependencies |
|-----------|---------|--------------|
| Card | Card container | - |
| Separator | Divider | @radix-ui/react-separator |
| Aspect Ratio | Maintain ratio | @radix-ui/react-aspect-ratio |
| Scroll Area | Scroll region | @radix-ui/react-scroll-area |
| Resizable | Resizable panels | react-resizable-panels |

### Navigation Components

| Component | Purpose | Dependencies |
|-----------|---------|--------------|
| Tabs | Tab navigation | @radix-ui/react-tabs |
| Navigation Menu | Navigation | @radix-ui/react-navigation-menu |
| Menubar | Menubar | @radix-ui/react-menubar |
| Breadcrumb | Breadcrumb | - |
| Pagination | Pagination | - |

### Overlay Components

| Component | Purpose | Dependencies |
|-----------|---------|--------------|
| Dialog | Modal dialog | @radix-ui/react-dialog |
| Sheet | Side sheet | @radix-ui/react-dialog |
| Drawer | Drawer | vaul |
| Popover | Popover | @radix-ui/react-popover |
| Tooltip | Tooltip | @radix-ui/react-tooltip |
| Alert Dialog | Confirm dialog | @radix-ui/react-alert-dialog |
| Hover Card | Hover card | @radix-ui/react-hover-card |
| Context Menu | Right-click menu | @radix-ui/react-context-menu |
| Dropdown Menu | Dropdown menu | @radix-ui/react-dropdown-menu |
| Command | Command palette | cmdk |

### Data Display

| Component | Purpose | Dependencies |
|-----------|---------|--------------|
| Table | Table | - |
| Data Table | Advanced table | @tanstack/react-table |
| Avatar | Avatar | @radix-ui/react-avatar |
| Badge | Badge | - |
| Calendar | Calendar | react-day-picker |
| Carousel | Carousel | embla-carousel-react |
| Chart | Chart | recharts |

### Feedback Components

| Component | Purpose | Dependencies |
|-----------|---------|--------------|
| Alert | Alert box | - |
| Toast | Toast notification | @radix-ui/react-toast |
| Sonner | Toast (alternative) | sonner |
| Progress | Progress bar | @radix-ui/react-progress |
| Skeleton | Loading skeleton | - |

### Utility Components

| Component | Purpose | Dependencies |
|-----------|---------|--------------|
| Accordion | Accordion | @radix-ui/react-accordion |
| Collapsible | Collapse/Expand | @radix-ui/react-collapsible |
| Toggle | Toggle button | @radix-ui/react-toggle |
| Toggle Group | Toggle group | @radix-ui/react-toggle-group |

## Common Combinations

### Form
```bash
npx shadcn-ui@latest add form input button label
```

### Table
```bash
npx shadcn-ui@latest add table badge button dropdown-menu
```

### Modal
```bash
npx shadcn-ui@latest add dialog button input
```

### Navigation
```bash
npx shadcn-ui@latest add navigation-menu button avatar dropdown-menu
```

## Customization Guide

### Adding Variants
```typescript
// button.tsx
const buttonVariants = cva(
  "...",
  {
    variants: {
      variant: {
        default: "...",
        destructive: "...",
        // Add new variant
        success: "bg-green-500 text-white hover:bg-green-600",
      },
    },
  }
);
```

### Adding Sizes
```typescript
const buttonVariants = cva(
  "...",
  {
    variants: {
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        // Add new size
        xl: "h-14 rounded-lg px-10 text-lg",
      },
    },
  }
);
```

## Reference Links

- [shadcn/ui Official Docs](https://ui.shadcn.com/)
- [Radix UI Primitives](https://www.radix-ui.com/)
- [Tailwind CSS](https://tailwindcss.com/)
