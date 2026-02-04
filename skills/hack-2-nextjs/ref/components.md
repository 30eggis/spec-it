# Component Extraction

## Props Parameterization

Convert repeated patterns into reusable components with props.

### Before/After Example

```typescript
// Before: 5 similar hardcoded cards
<div class="bg-green-100"><span>287</span><span>출근</span></div>
<div class="bg-amber-100"><span>3</span><span>지각</span></div>
<div class="bg-red-100"><span>2</span><span>미출근</span></div>

// After: Parameterized component
interface StatCardProps {
  value: number;
  label: string;
  color: 'green' | 'amber' | 'red' | 'blue' | 'purple';
  icon?: ReactNode;
}

export const StatCard: React.FC<StatCardProps> = ({ value, label, color, icon }) => (
  <div className={`bg-${color}-100 ...`}>
    {icon}
    <span>{value}</span>
    <span>{label}</span>
  </div>
);
```

## Props Extraction Rules

| Variation Type | Prop Strategy |
|---------------|---------------|
| Text differs | `label: string` |
| Color differs | `color: ColorType` or `variant: string` |
| Icon differs | `icon: ReactNode` |
| Show/hide | `showX?: boolean` |
| Count differs | `items: Item[]` |
| Action differs | `onClick?: () => void` |

## Output: components.json

```json
{
  "components": [
    {
      "name": "StatCard",
      "category": "widget",
      "file": "components/dashboard/StatCard.tsx",
      "props": [
        { "name": "value", "type": "number", "required": true },
        { "name": "label", "type": "string", "required": true },
        { "name": "color", "type": "ColorType", "required": true },
        { "name": "icon", "type": "ReactNode", "required": false }
      ],
      "usedIn": ["/", "/reports"],
      "instances": 5
    }
  ]
}
```

## Component Categories

### UI Components (`components/ui/`)
- Modal, Button, Card, Input, Toast
- Generic, reusable across all pages

### Layout Components (`components/layout/`)
- AppShell, Sidebar, Header, Breadcrumb
- Page structure and navigation

### Widget Components (`components/dashboard/`)
- StatCard, TimeClock, Calendar, Chart
- Domain-specific, data-driven

### Icon Components (`components/icons/`)
- All SVG icons as React components
- Single Icons.tsx with named exports
