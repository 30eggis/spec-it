# Dashboard Grid Patterns

역할별 대시보드 그리드 패턴.

## Employee Dashboard (2-column)

```yaml
grid:
  areas:
    desktop: |
      "today weekly"
      "today actions"
      "recent recent"
    tablet: |
      "today"
      "weekly"
      "actions"
      "recent"
    mobile: |
      "today"
      "weekly"
      "actions"
      "recent"
  columns:
    desktop: "1fr 1fr"
    tablet: "1fr"
  rows:
    desktop: "auto auto 1fr"

zones:
  today:
    rowSpan: 2  # Desktop only
  recent:
    colSpan: full
```

## Manager Dashboard (3-column)

```yaml
grid:
  areas:
    desktop: |
      "team pending overtime"
      "calendar calendar calendar"
    tablet: |
      "team pending"
      "overtime overtime"
      "calendar calendar"
    mobile: |
      "team"
      "pending"
      "overtime"
      "calendar"
  columns:
    desktop: "1fr 1fr 1fr"
    tablet: "1fr 1fr"
  rows:
    desktop: "auto 1fr"

zones:
  calendar:
    colSpan: full
```

## HR Dashboard (4-column)

```yaml
grid:
  areas:
    desktop: |
      "present absent leave remote"
      "alerts alerts alerts alerts"
      "trends trends health health"
    tablet: |
      "present absent"
      "leave remote"
      "alerts alerts"
      "trends trends"
      "health health"
  columns:
    desktop: "1fr 1fr 1fr 1fr"
    tablet: "1fr 1fr"

zones:
  alerts:
    colSpan: full
  trends:
    colSpan: 2
  health:
    colSpan: 2
```

## Implementation Example

```tsx
// Employee Dashboard
<div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
  {/* Today Status - spans 2 rows on desktop */}
  <Card className="lg:row-span-2">
    <TodayStatus />
  </Card>

  {/* Weekly Summary */}
  <Card>
    <WeeklySummary />
  </Card>

  {/* Quick Actions */}
  <Card>
    <QuickActions />
  </Card>

  {/* Recent Requests - full width */}
  <Card className="lg:col-span-2">
    <RecentRequests />
  </Card>
</div>
```
