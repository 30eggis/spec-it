# Route Map

## Purpose

`route_map.json` is the central registry that maps:
- Routes → Components
- Routes → Shells (per persona)
- Routes → Depth (for breadcrumbs)
- Design systems available

## Structure

```json
{
  "meta": {
    "version": "1.0",
    "appName": "App Name",
    "defaultShell": "employee",
    "defaultDesignSystem": "default"
  },

  "designSystems": {
    "default": "design-systems/default/tokens.json",
    "dark": "design-systems/dark/tokens.json"
  },

  "shells": {
    "hr-admin": {
      "name": "HR 관리자",
      "sidebar": { "items": [...] },
      "header": { "showModeToggle": true, "showNotifications": true }
    },
    "employee": {
      "name": "직원",
      "sidebar": { "items": [...] },
      "header": { "showModeToggle": true, "showNotifications": true }
    }
  },

  "routes": {
    "/": {
      "title": "대시보드",
      "shells": {
        "hr-admin": { "component": "HRDashboard" },
        "employee": { "component": "EmployeeDashboard" }
      },
      "depth": 0,
      "breadcrumb": ["대시보드"]
    },
    "/attendance": {
      "title": "출퇴근 기록",
      "shells": {
        "hr-admin": { "component": "AttendanceManagement" },
        "employee": { "component": "MyAttendance" }
      },
      "depth": 1,
      "parent": "/",
      "breadcrumb": ["대시보드", "출퇴근 기록"]
    },
    "/attendance/[id]": {
      "title": "출퇴근 상세",
      "shells": {
        "hr-admin": { "component": "AttendanceDetail" }
      },
      "depth": 2,
      "parent": "/attendance",
      "breadcrumb": ["대시보드", "출퇴근 기록", "상세"]
    }
  },

  "components": {
    "ui": ["Modal", "Button", "Card", "Input"],
    "layout": ["AppShell", "Sidebar", "Header"],
    "widget": ["StatCard", "TimeClock", "Calendar"]
  }
}
```

## Route Detection

Detect routes from:
- Navigation links (`href`, `onClick` handlers)
- Conditional renders (`if/switch` on route)
- File structure if local project

## Utility Functions

```typescript
// lib/routeMap.ts
class RouteMap {
  getShell(shellType: string): ShellConfig
  getRoute(path: string): RouteConfig
  getBreadcrumb(path: string): string[]
  getRouteDepth(path: string): number
  isRouteAccessible(path: string, shell: string): boolean
}

export const routeMap = new RouteMap();
```

## Usage in Components

```tsx
// Get shell config
const shellConfig = routeMap.getShell('hr-admin');

// Get breadcrumb for current route
const breadcrumb = routeMap.getBreadcrumb('/attendance/123');
// → ["대시보드", "출퇴근 기록", "상세"]

// Check access
const canAccess = routeMap.isRouteAccessible('/management', 'employee');
// → false (management is hr-admin only)
```
