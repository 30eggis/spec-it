# Complete Page Example

전체 페이지 구현 예제.

## Dashboard Page

```tsx
// app/(dashboard)/dashboard/page.tsx
import { DashboardLayout } from '@/layouts/dashboard-with-sidebar';
import { NeoCard } from '@/components/ui/neo-card';
import { StatCard } from '@/components/ui/stat-card';

export default function DashboardPage() {
  return (
    <DashboardLayout>
      {/* Page Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <p className="text-gray-500 mt-2">Welcome back, Kim Minsu</p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
        <StatCard
          title="Today Status"
          value="Present"
          icon={<CheckCircle className="w-5 h-5 text-green-600" />}
          trend={100}
          trendLabel="On time"
          testId="stat-today"
        />
        <StatCard
          title="This Week"
          value="42h 30m"
          icon={<Clock className="w-5 h-5 text-blue-600" />}
          trend={5.2}
          trendLabel="vs last week"
          testId="stat-week"
        />
        <StatCard
          title="Leave Balance"
          value="12 days"
          icon={<Calendar className="w-5 h-5 text-purple-600" />}
          testId="stat-leave"
        />
        <StatCard
          title="Pending"
          value="2"
          icon={<FileText className="w-5 h-5 text-amber-600" />}
          testId="stat-pending"
        />
      </div>

      {/* Content Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Today Status Card */}
        <NeoCard testId="card-today">
          <h3 className="text-lg font-semibold mb-4">Today's Status</h3>
          <TodayTimeline />
        </NeoCard>

        {/* Quick Actions Card */}
        <NeoCard testId="card-actions">
          <h3 className="text-lg font-semibold mb-4">Quick Actions</h3>
          <QuickActions />
        </NeoCard>

        {/* Recent Requests - Full Width */}
        <NeoCard className="lg:col-span-2" testId="card-requests">
          <h3 className="text-lg font-semibold mb-4">Recent Requests</h3>
          <RecentRequestsList />
        </NeoCard>
      </div>
    </DashboardLayout>
  );
}
```

## YAML Wireframe Reference

```yaml
screen:
  id: SCR-002
  name: Dashboard
  route: /dashboard
  layout: dashboard-with-sidebar

grid:
  areas:
    desktop: |
      "header header header header"
      "stat1 stat2 stat3 stat4"
      "today actions actions actions"
      "requests requests requests requests"
    tablet: |
      "header header"
      "stat1 stat2"
      "stat3 stat4"
      "today today"
      "actions actions"
      "requests requests"
    mobile: |
      "header"
      "stat1"
      "stat2"
      "stat3"
      "stat4"
      "today"
      "actions"
      "requests"

components:
  - type: page-header
    zone: header
    props:
      title: "Dashboard"
      subtitle: "Welcome back, {userName}"
    testId: dashboard-header

  - type: stat-card
    zone: stat1
    props:
      title: "Today Status"
      value: "Present"
      icon: "check-circle"
      iconColor: "green-600"
    testId: stat-today

  - type: neo-card
    zone: today
    children:
      - type: heading
        props: { level: 3, text: "Today's Status" }
      - type: timeline
        props: { variant: "today" }
    testId: card-today

  - type: neo-card
    zone: requests
    props:
      className: "lg:col-span-2"
    children:
      - type: heading
        props: { level: 3, text: "Recent Requests" }
      - type: table
        props: { variant: "requests" }
    testId: card-requests
```
