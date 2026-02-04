# App Shell Definition

## Concept

App Shell = Sidebar + Header + Layout structure that wraps page content.
Different personas/contexts get different shells.

```
┌─────────────────────────────────────────┐
│  Header                            🔔   │  ← Shell
├────────┬────────────────────────────────┤
│        │                                │
│ Side   │     Page Content               │  ← Changes per route
│ bar    │                                │
│        │                                │
├────────┴────────────────────────────────┤
│  Profile                                │  ← Shell
└─────────────────────────────────────────┘
```

## Shell Detection

Analyze navigation structure for:
- Sidebar menu items per context
- Header elements per context
- Footer visibility
- Access control patterns

## Shell Configuration

```json
{
  "shells": {
    "hr-admin": {
      "name": "HR 관리자",
      "sidebar": {
        "items": [
          { "id": "dashboard", "icon": "Home", "label": "대시보드", "route": "/" },
          { "id": "attendance", "icon": "Clock", "label": "출퇴근 기록", "route": "/attendance" }
        ]
      },
      "header": {
        "showModeToggle": true,
        "showNotifications": true
      },
      "features": ["approve", "reports", "settings"]
    },
    "employee": {
      "name": "직원",
      "sidebar": {
        "items": [
          { "id": "dashboard", "icon": "Home", "label": "대시보드", "route": "/" },
          { "id": "my-attendance", "icon": "Clock", "label": "내 출퇴근", "route": "/my-attendance" }
        ]
      },
      "header": {
        "showModeToggle": true,
        "showNotifications": true
      },
      "features": ["request", "view"]
    },
    "guest": {
      "name": "게스트",
      "sidebar": { "items": [] },
      "header": { "showModeToggle": false, "showNotifications": false },
      "features": []
    }
  }
}
```

## AppShell Component

```typescript
interface AppShellProps {
  shell: ShellType;          // 'hr-admin' | 'employee' | 'guest'
  designSystem?: string;     // 'default' | 'dark' | 'brand-b'
  children: ReactNode;
}

export const AppShell: React.FC<AppShellProps> = ({
  shell,
  designSystem,
  children
}) => {
  const config = routeMap.getShell(shell);
  const tokens = useDesignSystem(designSystem);

  return (
    <DesignSystemProvider tokens={tokens}>
      <div className="app-shell">
        <Sidebar items={config.sidebar.items} />
        <Header {...config.header} />
        <main>{children}</main>
      </div>
    </DesignSystemProvider>
  );
};
```

## Usage

```tsx
// Page with HR admin shell
<AppShell shell="hr-admin">
  <HRDashboard />
</AppShell>

// Page with employee shell + different design
<AppShell shell="employee" designSystem="dark">
  <EmployeeDashboard />
</AppShell>
```
