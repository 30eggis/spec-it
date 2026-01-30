# Dashboard Templates

실제 2026 SaaS UI 예시에서 추출한 대시보드 템플릿 패턴.

---

## 1. Sidebar Navigation Patterns

### Pattern A: Icon + Text Sidebar (Light)
> 출처: MedOps, Destined

```tsx
// components/layout/sidebar-light.tsx
export function SidebarLight() {
  return (
    <aside className="w-[240px] h-screen bg-white border-r border-gray-100 flex flex-col">
      {/* Logo */}
      <div className="h-16 px-6 flex items-center border-b border-gray-100">
        <span className="text-xl font-bold text-blue-600">Med</span>
        <span className="text-xl font-bold text-gray-400">@</span>
        <span className="text-xl font-bold text-gray-800">ps</span>
        <span className="text-xs text-gray-400 ml-2">Healthcare Dashboard</span>
      </div>

      {/* Search */}
      <div className="px-4 py-4">
        <div className="relative">
          <input
            type="text"
            placeholder="Search"
            className="w-full h-10 pl-4 pr-10 rounded-lg border border-gray-200
                       text-sm focus:outline-none focus:border-blue-400
                       focus:ring-2 focus:ring-blue-100"
          />
          <Search className="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
        </div>
      </div>

      {/* Menu */}
      <nav className="flex-1 px-3 py-2 space-y-1">
        <NavItem icon={LayoutGrid} label="Dashboard" active />
        <NavItem icon={Building2} label="Hospitals" />
        <NavItem icon={Sparkles} label="Medical Role" hasSubmenu />
        <NavItem icon={Wallet} label="Accounts" hasSubmenu />
        <NavItem icon={Users} label="Patients" />
        <NavItem icon={Calendar} label="Appointments" />
        <NavItem icon={FileText} label="Reports" />
        <NavItem icon={Settings2} label="Management" />
        <NavItem icon={Settings} label="Settings" />
        <NavItem icon={UserCog} label="Human Resources" />
        <NavItem icon={LogOut} label="Logout" />
      </nav>

      {/* CTA Card */}
      <div className="mx-4 mb-4 p-4 bg-blue-600 rounded-xl text-white text-center">
        <p className="text-sm font-medium">Upgrade or modify</p>
        <p className="text-sm font-medium">your plan anytime!!</p>
      </div>
    </aside>
  );
}

function NavItem({ icon: Icon, label, active, hasSubmenu }: NavItemProps) {
  return (
    <button
      className={cn(
        "w-full flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium",
        "transition-colors duration-150",
        active
          ? "bg-blue-50 text-blue-600 border-l-3 border-blue-600"
          : "text-gray-600 hover:bg-gray-50 hover:text-gray-900"
      )}
    >
      <Icon className="w-5 h-5" />
      <span className="flex-1 text-left">{label}</span>
      {hasSubmenu && <ChevronRight className="w-4 h-4" />}
    </button>
  );
}
```

### Pattern B: Icon-Only Sidebar (Dark)
> 출처: HR Admin Dashboard

```tsx
// components/layout/sidebar-icon-only.tsx
export function SidebarIconOnly() {
  return (
    <aside className="w-[72px] h-screen bg-[#1e2a4a] flex flex-col items-center py-4">
      {/* Logo */}
      <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-orange-400 to-red-500
                      flex items-center justify-center mb-6">
        <span className="text-white font-bold text-sm">hr ad.</span>
      </div>

      {/* Navigation Icons */}
      <nav className="flex-1 flex flex-col items-center gap-2">
        <IconButton icon={ArrowLeftRight} />
        <IconButton icon={TrendingUp} active />
        <IconButton icon={LayoutGrid} />
        <IconButton icon={Percent} />
        <IconButton icon={DollarSign} />
        <IconButton icon={FileText} />
        <IconButton icon={Hand} />
        <IconButton icon={PenTool} />
        <IconButton icon={Briefcase} />
      </nav>
    </aside>
  );
}

function IconButton({ icon: Icon, active }: { icon: any; active?: boolean }) {
  return (
    <button
      className={cn(
        "w-11 h-11 rounded-xl flex items-center justify-center",
        "transition-all duration-200",
        active
          ? "bg-amber-400 text-gray-900 shadow-lg shadow-amber-400/30"
          : "text-gray-400 hover:text-white hover:bg-white/10"
      )}
    >
      <Icon className="w-5 h-5" />
    </button>
  );
}
```

### Pattern C: Sidebar with Sections
> 출처: Destined App

```tsx
// components/layout/sidebar-sections.tsx
export function SidebarSections() {
  return (
    <aside className="w-[220px] h-screen bg-white border-r border-gray-100 flex flex-col">
      {/* Logo */}
      <div className="h-16 px-5 flex items-center gap-2">
        <Heart className="w-5 h-5 text-pink-500" />
        <div>
          <span className="text-lg font-semibold text-blue-600">Destined</span>
          <p className="text-[10px] text-gray-400">Online Dating App</p>
        </div>
      </div>

      {/* Menu Section */}
      <div className="px-4 py-4">
        <p className="text-[11px] font-medium text-gray-400 uppercase tracking-wide mb-3">
          Menu ——
        </p>
        <nav className="space-y-1">
          <NavItem icon={LayoutGrid} label="Dashboard" active />
          <NavItem icon={Users} label="Users" />
          <NavItem icon={MessageCircle} label="Chat Requests" />
          <NavItem icon={AlertCircle} label="User Reports" />
          <NavItem icon={CreditCard} label="Subscriptions" hasSubmenu />
        </nav>
      </div>

      {/* Support Section */}
      <div className="px-4 py-4">
        <p className="text-[11px] font-medium text-gray-400 uppercase tracking-wide mb-3">
          Support ——
        </p>
        <nav className="space-y-1">
          <NavItem icon={Settings} label="Settings" />
          <NavItem icon={HelpCircle} label="Help" />
          <NavItem icon={LogOut} label="Logout" />
        </nav>
      </div>

      {/* Quote Card */}
      <div className="mt-auto mx-4 mb-4 p-4 bg-blue-600 rounded-xl text-white">
        <p className="text-xs leading-relaxed">
          "I was considering my future as many do at this time of the year..."
        </p>
      </div>
    </aside>
  );
}
```

---

## 2. KPI/Stat Cards

### Pattern A: Gradient KPI Card (Dark Theme)
> 출처: Spoon Restaurant, Destined

```tsx
// components/ui/gradient-kpi-card.tsx
interface GradientKPICardProps {
  title: string;
  value: string | number;
  subtitle?: string;
  gradient: "red" | "teal" | "purple" | "blue";
  icon?: React.ReactNode;
  action?: { label: string; onClick: () => void };
}

const gradients = {
  red: "bg-gradient-to-br from-red-500 to-orange-600",
  teal: "bg-gradient-to-br from-teal-400 to-cyan-500",
  purple: "bg-gradient-to-br from-purple-500 to-pink-500",
  blue: "bg-gradient-to-br from-blue-500 to-indigo-600",
};

export function GradientKPICard({
  title,
  value,
  subtitle,
  gradient,
  icon,
  action,
}: GradientKPICardProps) {
  return (
    <div className={cn(
      "relative rounded-2xl p-6 text-white overflow-hidden",
      gradients[gradient]
    )}>
      {/* Background decoration */}
      <div className="absolute top-2 right-2 opacity-20">
        {icon}
      </div>

      {/* Content */}
      <p className="text-sm font-medium opacity-90 mb-2">{title}</p>
      <p className="text-4xl font-bold mb-1">{value}</p>
      {subtitle && (
        <p className="text-xs opacity-80">{subtitle}</p>
      )}

      {action && (
        <button className="mt-4 px-4 py-2 bg-white/20 hover:bg-white/30
                          rounded-lg text-sm font-medium transition-colors">
          {action.label}
        </button>
      )}
    </div>
  );
}

// Usage Example (Spoon Dashboard)
<GradientKPICard
  title="New Orders"
  value="25"
  subtitle="All online incoming orders through app and website"
  gradient="red"
  icon={<Bell className="w-8 h-8" />}
  action={{ label: "View All", onClick: () => {} }}
/>
```

### Pattern B: Stat Card with Trend
> 출처: MudraBank Invoices

```tsx
// components/ui/stat-card-trend.tsx
interface StatCardTrendProps {
  title: string;
  value: string | number;
  trend: number;
  trendLabel?: string;
  variant: "dark" | "light";
}

export function StatCardTrend({
  title,
  value,
  trend,
  trendLabel = "than last month",
  variant,
}: StatCardTrendProps) {
  const isPositive = trend > 0;

  return (
    <div className={cn(
      "rounded-2xl p-6",
      variant === "dark"
        ? "bg-gradient-to-br from-blue-600 via-indigo-600 to-purple-700 text-white"
        : "bg-white border border-gray-100 text-gray-900"
    )}>
      <p className={cn(
        "text-sm font-medium mb-3",
        variant === "dark" ? "text-white/80" : "text-gray-500"
      )}>
        {title}
      </p>

      <div className="flex items-end gap-3">
        <span className="text-4xl font-bold font-mono">{value}</span>
        <div className={cn(
          "flex items-center gap-1 text-sm font-medium",
          isPositive ? "text-green-400" : "text-red-400"
        )}>
          {isPositive ? (
            <TrendingUp className="w-4 h-4" />
          ) : (
            <TrendingDown className="w-4 h-4" />
          )}
          <span>{isPositive ? "+" : ""}{trend}%</span>
        </div>
      </div>

      <p className={cn(
        "text-xs mt-2",
        variant === "dark" ? "text-white/60" : "text-gray-400"
      )}>
        {isPositive ? "+" : ""}{Math.abs(trend * 10)}% {trendLabel}
      </p>
    </div>
  );
}
```

### Pattern C: Overview Stat Card with Icon
> 출처: HR Admin Dashboard

```tsx
// components/ui/overview-stat-card.tsx
interface OverviewStatCardProps {
  label: string;
  value: string | number;
  icon: React.ReactNode;
  iconBg?: string;
  trend?: "up" | "down";
}

export function OverviewStatCard({
  label,
  value,
  icon,
  iconBg = "bg-orange-100",
  trend,
}: OverviewStatCardProps) {
  return (
    <div className="flex items-center gap-4 p-4 bg-white rounded-xl border border-gray-100">
      <div className={cn(
        "w-12 h-12 rounded-full flex items-center justify-center",
        iconBg
      )}>
        {icon}
      </div>
      <div>
        <p className="text-2xl font-bold text-gray-900">{value}</p>
        <p className="text-sm text-gray-500">{label}</p>
      </div>
      {trend && (
        <div className={cn(
          "ml-auto w-8 h-8 rounded-full flex items-center justify-center",
          trend === "up" ? "bg-green-100" : "bg-red-100"
        )}>
          {trend === "up" ? (
            <TrendingUp className="w-4 h-4 text-green-600" />
          ) : (
            <TrendingDown className="w-4 h-4 text-red-600" />
          )}
        </div>
      )}
    </div>
  );
}

// Usage
<div className="flex gap-4">
  <OverviewStatCard
    label="Users"
    value="348"
    icon={<TrendingUp className="w-5 h-5 text-orange-600" />}
    iconBg="bg-orange-100"
  />
  <OverviewStatCard
    label="Events"
    value="128"
    icon={<CheckCircle className="w-5 h-5 text-green-600" />}
    iconBg="bg-green-100"
    trend="down"
  />
  <OverviewStatCard
    label="Holidays"
    value="10"
    icon={<TrendingUp className="w-5 h-5 text-blue-600" />}
    iconBg="bg-blue-100"
    trend="up"
  />
</div>
```

---

## 3. Data Tables

### Pattern A: Clean Table with Avatars
> 출처: MedOps Doctor List

```tsx
// components/ui/data-table-clean.tsx
interface Doctor {
  id: string;
  name: string;
  credential: string;
  specialty: string;
  fee: number;
  experience: string;
  availability: string[];
  avatar: string;
}

export function DoctorTable({ doctors }: { doctors: Doctor[] }) {
  return (
    <div className="bg-white rounded-xl border border-gray-100 overflow-hidden">
      {/* Header */}
      <div className="px-6 py-4 border-b border-gray-100">
        <h2 className="text-lg font-semibold text-gray-900">Doctor List</h2>
      </div>

      {/* Table */}
      <table className="w-full">
        <thead>
          <tr className="border-b border-gray-100">
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              #
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Name
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Speciality
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Fee
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Experience
            </th>
            <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Availability
            </th>
          </tr>
        </thead>
        <tbody className="divide-y divide-gray-50">
          {doctors.map((doctor, index) => (
            <tr
              key={doctor.id}
              className="hover:bg-gray-50 transition-colors cursor-pointer"
            >
              <td className="px-6 py-4 text-sm text-gray-500">
                {String(index + 1).padStart(2, '0')}
              </td>
              <td className="px-6 py-4">
                <div className="flex items-center gap-3">
                  <img
                    src={doctor.avatar}
                    alt={doctor.name}
                    className="w-10 h-10 rounded-full object-cover"
                  />
                  <div>
                    <p className="text-sm font-medium text-gray-900">{doctor.name}</p>
                    <p className="text-xs text-gray-400">{doctor.credential}</p>
                  </div>
                </div>
              </td>
              <td className="px-6 py-4 text-sm text-gray-600">
                {doctor.specialty}
              </td>
              <td className="px-6 py-4 text-sm text-gray-900 font-medium">
                {doctor.fee.toLocaleString()}
              </td>
              <td className="px-6 py-4 text-sm text-gray-600">
                {doctor.experience}
              </td>
              <td className="px-6 py-4">
                <div className="flex gap-1">
                  {['S', 'M', 'T', 'W', 'T'].map((day, i) => (
                    <span
                      key={i}
                      className={cn(
                        "w-6 h-6 rounded-full text-xs font-medium",
                        "flex items-center justify-center",
                        doctor.availability.includes(day)
                          ? "bg-green-500 text-white"
                          : "bg-gray-100 text-gray-400"
                      )}
                    >
                      {day}
                    </span>
                  ))}
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
```

### Pattern B: Transaction List with Status
> 출처: MudraBank Transaction

```tsx
// components/ui/transaction-list.tsx
type TransactionStatus = "Confirm" | "Pending" | "Failed";

interface Transaction {
  id: string;
  recipient: string;
  avatar: string | React.ReactNode;
  invoice: string;
  status: TransactionStatus;
}

const statusStyles: Record<TransactionStatus, string> = {
  Confirm: "text-green-600",
  Pending: "text-orange-500",
  Failed: "text-red-500",
};

export function TransactionList({ transactions }: { transactions: Transaction[] }) {
  return (
    <div className="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700">
      {/* Header */}
      <div className="px-6 py-4 flex items-center justify-between border-b border-gray-100 dark:border-gray-700">
        <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
          Transaction
        </h3>
        <div className="flex gap-2">
          <button className="px-3 py-1.5 text-sm text-gray-600 dark:text-gray-300
                            border border-gray-200 dark:border-gray-600 rounded-lg
                            hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">
            <Printer className="w-4 h-4 inline mr-1.5" />
            Print
          </button>
          <button className="px-3 py-1.5 text-sm text-gray-600 dark:text-gray-300
                            border border-gray-200 dark:border-gray-600 rounded-lg
                            hover:bg-gray-50 dark:hover:bg-gray-700 transition-colors">
            <Filter className="w-4 h-4 inline mr-1.5" />
            Filter
          </button>
        </div>
      </div>

      {/* Search */}
      <div className="px-6 py-3 border-b border-gray-100 dark:border-gray-700">
        <input
          type="text"
          placeholder="Search by name email"
          className="w-full px-4 py-2 bg-gray-50 dark:bg-gray-700 rounded-lg
                     text-sm text-gray-900 dark:text-white
                     placeholder:text-gray-400 dark:placeholder:text-gray-500
                     border-none focus:ring-2 focus:ring-blue-500"
        />
      </div>

      {/* List */}
      <div className="divide-y divide-gray-100 dark:divide-gray-700">
        {transactions.map((tx) => (
          <div
            key={tx.id}
            className="px-6 py-4 flex items-center gap-4 hover:bg-gray-50
                       dark:hover:bg-gray-700/50 transition-colors"
          >
            {/* Checkbox */}
            <input
              type="checkbox"
              className="w-4 h-4 rounded border-gray-300 text-blue-600
                         focus:ring-blue-500 focus:ring-offset-0"
            />

            {/* Avatar */}
            <div className="w-10 h-10 rounded-lg bg-gray-100 dark:bg-gray-600
                           flex items-center justify-center overflow-hidden">
              {typeof tx.avatar === 'string' ? (
                <img src={tx.avatar} alt="" className="w-full h-full object-cover" />
              ) : (
                tx.avatar
              )}
            </div>

            {/* Info */}
            <div className="flex-1">
              <p className="text-sm font-medium text-gray-900 dark:text-white">
                {tx.recipient}
              </p>
            </div>

            {/* Invoice */}
            <p className="text-sm text-gray-500 dark:text-gray-400 font-mono">
              {tx.invoice}
            </p>

            {/* Status */}
            <div className="flex items-center gap-1.5">
              <span className={cn(
                "w-2 h-2 rounded-full",
                tx.status === "Confirm" && "bg-green-500",
                tx.status === "Pending" && "bg-orange-500",
                tx.status === "Failed" && "bg-red-500"
              )} />
              <span className={cn("text-sm font-medium", statusStyles[tx.status])}>
                {tx.status}
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
```

---

## 4. Charts

### Pattern A: Area Chart with Gradient (Dark Theme)
> 출처: Spoon Restaurant Dashboard

```tsx
// components/charts/area-chart-dark.tsx
import { Area, AreaChart, ResponsiveContainer, XAxis, YAxis, Tooltip } from 'recharts';

export function SalesChart({ data }: { data: any[] }) {
  return (
    <div className="bg-[#1a1a2e] rounded-2xl p-6">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <div>
          <h3 className="text-white font-semibold">September 2020</h3>
          <div className="flex items-center gap-2 mt-1">
            <span className="w-2 h-2 rounded-full bg-purple-400" />
            <span className="text-xs text-gray-400">Sales Graph</span>
          </div>
        </div>
        <button className="px-3 py-1.5 text-sm text-gray-400 border border-gray-700
                          rounded-lg hover:bg-gray-800 transition-colors">
          <Calendar className="w-4 h-4 inline mr-1.5" />
          Change date
        </button>
      </div>

      {/* Chart */}
      <ResponsiveContainer width="100%" height={250}>
        <AreaChart data={data}>
          <defs>
            <linearGradient id="salesGradient" x1="0" y1="0" x2="0" y2="1">
              <stop offset="0%" stopColor="#a78bfa" stopOpacity={0.4} />
              <stop offset="100%" stopColor="#a78bfa" stopOpacity={0} />
            </linearGradient>
          </defs>
          <XAxis
            dataKey="day"
            axisLine={false}
            tickLine={false}
            tick={{ fill: '#6b7280', fontSize: 12 }}
          />
          <YAxis
            axisLine={false}
            tickLine={false}
            tick={{ fill: '#6b7280', fontSize: 12 }}
            tickFormatter={(value) => `${value / 1000}k`}
          />
          <Tooltip
            contentStyle={{
              backgroundColor: '#1f2937',
              border: 'none',
              borderRadius: '8px',
              color: '#fff',
            }}
          />
          <Area
            type="monotone"
            dataKey="sales"
            stroke="#a78bfa"
            strokeWidth={2}
            fill="url(#salesGradient)"
          />
        </AreaChart>
      </ResponsiveContainer>
    </div>
  );
}
```

### Pattern B: Multi-Line Chart
> 출처: HR Admin Dashboard

```tsx
// components/charts/multi-line-chart.tsx
import { Line, LineChart, ResponsiveContainer, XAxis, YAxis, Tooltip, Legend } from 'recharts';

export function PerformanceChart({ data }: { data: any[] }) {
  return (
    <div className="bg-gradient-to-r from-pink-50 to-purple-50 rounded-2xl p-6">
      {/* Header */}
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-2">
          <span className="text-lg font-bold text-gray-900">2014</span>
          <div className="flex gap-4 ml-4 text-xs">
            <span className="text-blue-600">Marketing: 2437</span>
            <span className="text-orange-500">Design: 7689</span>
            <span className="text-gray-600">Development: 7689</span>
            <span className="text-purple-600">Others: 7689</span>
          </div>
        </div>
        <div className="flex gap-2">
          <button className="px-3 py-1 text-xs bg-white rounded-lg shadow-sm">
            Sort by
          </button>
          <button className="px-3 py-1 text-xs bg-white rounded-lg shadow-sm">
            Years
          </button>
        </div>
      </div>

      {/* Chart */}
      <ResponsiveContainer width="100%" height={200}>
        <LineChart data={data}>
          <XAxis
            dataKey="year"
            axisLine={false}
            tickLine={false}
            tick={{ fill: '#6b7280', fontSize: 11 }}
          />
          <YAxis hide />
          <Tooltip />
          <Line
            type="monotone"
            dataKey="marketing"
            stroke="#3b82f6"
            strokeWidth={2}
            dot={false}
          />
          <Line
            type="monotone"
            dataKey="design"
            stroke="#f97316"
            strokeWidth={2}
            dot={{ fill: '#f97316', r: 4 }}
          />
          <Line
            type="monotone"
            dataKey="development"
            stroke="#6b7280"
            strokeWidth={2}
            dot={false}
          />
        </LineChart>
      </ResponsiveContainer>
    </div>
  );
}
```

### Pattern C: Donut Chart with Stats
> 출처: Destined Dashboard

```tsx
// components/charts/donut-chart-stats.tsx
import { PieChart, Pie, Cell, ResponsiveContainer } from 'recharts';

interface DonutChartProps {
  title: string;
  percentage: number;
  stats: { label: string; value: string; color: string }[];
}

export function DonutChartStats({ title, percentage, stats }: DonutChartProps) {
  const data = [
    { value: percentage },
    { value: 100 - percentage },
  ];

  return (
    <div className="bg-white rounded-2xl p-6 border border-gray-100">
      {/* Header */}
      <div className="flex items-center justify-between mb-4">
        <h3 className="font-semibold text-gray-900">{title}</h3>
        <div className="flex items-center gap-2">
          <button className="px-3 py-1 text-xs text-gray-600 border border-gray-200 rounded-lg">
            Last 1 month
          </button>
          <button className="p-1 text-gray-400 hover:text-gray-600">
            <MoreVertical className="w-4 h-4" />
          </button>
        </div>
      </div>

      <div className="flex gap-6">
        {/* Chart */}
        <div className="relative w-[140px] h-[140px]">
          <ResponsiveContainer>
            <PieChart>
              <Pie
                data={data}
                innerRadius={50}
                outerRadius={65}
                startAngle={90}
                endAngle={-270}
                dataKey="value"
              >
                <Cell fill="#3b82f6" />
                <Cell fill="#e5e7eb" />
              </Pie>
            </PieChart>
          </ResponsiveContainer>
          {/* Center Label */}
          <div className="absolute inset-0 flex flex-col items-center justify-center">
            <span className="text-2xl font-bold text-gray-900">{percentage}%</span>
            <span className="text-[10px] text-gray-400">Percentage of</span>
            <span className="text-[10px] text-gray-400">Subscribers</span>
          </div>
        </div>

        {/* Stats */}
        <div className="flex-1 space-y-3">
          {stats.map((stat, index) => (
            <div key={index} className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <ChevronRight className="w-4 h-4 text-gray-400" />
                <span className="text-sm text-gray-600">{stat.label}</span>
              </div>
              <span className={cn("text-sm font-semibold", stat.color)}>
                {stat.value}
              </span>
            </div>
          ))}
        </div>
      </div>

      {/* Legend */}
      <div className="flex gap-6 mt-4 pt-4 border-t border-gray-100">
        <div className="flex items-center gap-2">
          <span className="w-3 h-0.5 bg-blue-600" />
          <span className="text-xs text-gray-500">Percentage of Subscribers</span>
        </div>
        <div className="flex items-center gap-2">
          <span className="w-3 h-0.5 bg-green-400" />
          <span className="text-xs text-gray-500">Percentage of Advertisement</span>
        </div>
        <div className="flex items-center gap-2">
          <span className="w-3 h-0.5 bg-pink-400" />
          <span className="text-xs text-gray-500">Percentage of Events</span>
        </div>
      </div>
    </div>
  );
}
```

---

## 5. 3D Visual Cards

### Pattern A: Subscription/Pricing Card with 3D Icon
> 출처: 3D Visuals & Interactive Product Demos

```tsx
// components/ui/pricing-card-3d.tsx
interface PricingCard3DProps {
  icon3D: React.ReactNode; // 3D rendered icon/image
  subscribers: string;
  name: string;
  duration: string;
  selected?: boolean;
}

export function PricingCard3D({
  icon3D,
  subscribers,
  name,
  duration,
  selected = false,
}: PricingCard3DProps) {
  return (
    <div className={cn(
      "relative bg-white rounded-2xl p-6 transition-all duration-300",
      "hover:shadow-xl hover:-translate-y-1",
      selected
        ? "border-2 border-blue-500 shadow-lg shadow-blue-100"
        : "border border-gray-100"
    )}>
      {/* 3D Icon */}
      <div className="w-24 h-24 mx-auto mb-4">
        {icon3D}
      </div>

      {/* Content */}
      <div className="text-center">
        <p className="text-sm text-gray-500 mb-1">{subscribers} Subscribers</p>
        <h3 className="text-xl font-semibold text-blue-600 mb-1">{name}</h3>
        <p className="text-sm text-gray-400">{duration}</p>
      </div>

      {/* Action */}
      <button className="w-full mt-6 py-2.5 text-sm font-medium text-gray-600
                        border border-gray-200 rounded-xl
                        hover:bg-gray-50 hover:border-gray-300 transition-colors">
        Customise
      </button>
    </div>
  );
}

// CSS for 3D effect shadow (optional)
const icon3DStyles = `
  .icon-3d {
    filter: drop-shadow(0 20px 30px rgba(0, 0, 0, 0.15));
    transform: perspective(1000px) rotateX(5deg);
  }
`;
```

---

## 6. Message/Chat Components

### Pattern A: Message List with Badges
> 출처: Destined Chat Requests

```tsx
// components/ui/message-list.tsx
interface Message {
  id: string;
  name: string;
  avatar: string;
  preview: string;
  time: string;
  unreadCount?: number;
  active?: boolean;
}

export function MessageList({ messages }: { messages: Message[] }) {
  return (
    <div className="bg-white rounded-xl border border-gray-100">
      {/* Header */}
      <div className="px-4 py-3 border-b border-gray-100">
        <h3 className="font-semibold text-gray-900">Messages</h3>
        <input
          type="text"
          placeholder="Search"
          className="w-full mt-3 px-3 py-2 bg-gray-50 rounded-lg text-sm
                     border-none focus:ring-2 focus:ring-blue-500"
        />
      </div>

      {/* Tabs */}
      <div className="flex border-b border-gray-100">
        <button className="flex-1 px-4 py-2.5 text-sm font-medium text-blue-600
                          border-b-2 border-blue-600">
          Issue Raised (100k)
        </button>
        <button className="flex-1 px-4 py-2.5 text-sm font-medium text-gray-500
                          hover:text-gray-700">
          Unresolved
        </button>
        <button className="flex-1 px-4 py-2.5 text-sm font-medium text-gray-500
                          hover:text-gray-700">
          Resolved
        </button>
      </div>

      {/* Messages */}
      <div className="divide-y divide-gray-50">
        {messages.map((msg) => (
          <div
            key={msg.id}
            className={cn(
              "px-4 py-3 flex items-center gap-3 cursor-pointer transition-colors",
              msg.active
                ? "bg-blue-600 text-white"
                : "hover:bg-gray-50"
            )}
          >
            {/* Avatar */}
            <div className="relative">
              <img
                src={msg.avatar}
                alt={msg.name}
                className="w-10 h-10 rounded-full object-cover"
              />
              {msg.unreadCount && (
                <span className="absolute -top-1 -right-1 w-5 h-5
                                bg-red-500 text-white text-[10px] font-bold
                                rounded-full flex items-center justify-center">
                  {msg.unreadCount}
                </span>
              )}
            </div>

            {/* Content */}
            <div className="flex-1 min-w-0">
              <div className="flex items-center justify-between">
                <span className={cn(
                  "font-medium text-sm",
                  msg.active ? "text-white" : "text-gray-900"
                )}>
                  {msg.name}
                </span>
                <span className={cn(
                  "text-xs",
                  msg.active ? "text-white/70" : "text-gray-400"
                )}>
                  {msg.time}
                </span>
              </div>
              <p className={cn(
                "text-sm truncate",
                msg.active ? "text-white/80" : "text-gray-500"
              )}>
                {msg.preview}
              </p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
```

---

## 7. Profile/Employee Cards

### Pattern A: Payslip Employee Card
> 출처: HR Admin Payslip

```tsx
// components/ui/employee-profile-card.tsx
interface EmployeeProfileCardProps {
  company: string;
  name: string;
  employeeId: string;
  designation: string;
  address: string;
  avatar: string;
  isNew?: boolean;
}

export function EmployeeProfileCard({
  company,
  name,
  employeeId,
  designation,
  address,
  avatar,
  isNew = false,
}: EmployeeProfileCardProps) {
  return (
    <div className="bg-gradient-to-r from-pink-100 via-purple-50 to-blue-100
                    rounded-2xl p-6 relative overflow-hidden">
      {/* Company Badge */}
      <span className="inline-block px-3 py-1 bg-blue-600 text-white text-xs
                       font-medium rounded-full mb-4">
        {company}
      </span>

      {/* Profile */}
      <div className="flex items-start gap-4">
        <div className="relative">
          <img
            src={avatar}
            alt={name}
            className="w-16 h-16 rounded-xl object-cover"
          />
          {isNew && (
            <span className="absolute -top-2 -left-2 px-2 py-0.5
                            bg-orange-500 text-white text-[10px] font-bold
                            rounded-full">
              New
            </span>
          )}
        </div>
        <div>
          <h3 className="text-xl font-semibold text-gray-900">{name}</h3>
          <p className="text-sm text-gray-500">Employee ID: {employeeId}</p>
          <p className="text-sm text-gray-500">Designation: {designation}</p>
          <p className="text-sm text-gray-500 mt-1">
            <MapPin className="w-3 h-3 inline mr-1" />
            {address}
          </p>
        </div>
      </div>
    </div>
  );
}
```

---

## 8. Full Layout Examples

### Layout A: Dashboard with Left Sidebar + Stats + Chart
> 출처: HR Admin, Spoon

```tsx
// app/dashboard/page.tsx
export default function DashboardPage() {
  return (
    <div className="flex h-screen bg-gray-50">
      {/* Sidebar */}
      <SidebarIconOnly />

      {/* Main Content */}
      <main className="flex-1 overflow-auto">
        {/* Header */}
        <header className="h-16 bg-white border-b border-gray-100 px-8
                          flex items-center justify-between">
          <div>
            <h1 className="text-xl font-bold text-gray-900">Hello Admin!</h1>
            <p className="text-sm text-gray-500">
              Measure How Fast You're Growing Monthly Recurring performance management.
            </p>
          </div>
          <div className="flex items-center gap-4">
            <select className="px-3 py-1.5 border border-gray-200 rounded-lg text-sm">
              <option>Year</option>
            </select>
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="text"
                placeholder="Search"
                className="pl-9 pr-4 py-2 border border-gray-200 rounded-lg text-sm w-64"
              />
            </div>
          </div>
        </header>

        {/* Content */}
        <div className="p-8">
          {/* Overview Section */}
          <section className="mb-8">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">Overview</h2>
            <div className="grid grid-cols-3 gap-4">
              <OverviewStatCard
                label="Users"
                value="348"
                icon={<TrendingUp className="w-5 h-5 text-orange-600" />}
                iconBg="bg-orange-100"
              />
              <OverviewStatCard
                label="Events"
                value="128"
                icon={<Check className="w-5 h-5 text-green-600" />}
                iconBg="bg-green-100"
                trend="down"
              />
              <OverviewStatCard
                label="Holidays"
                value="10"
                icon={<TrendingUp className="w-5 h-5 text-blue-600" />}
                iconBg="bg-blue-100"
                trend="up"
              />
            </div>
          </section>

          {/* Charts Grid */}
          <div className="grid grid-cols-2 gap-6">
            <SalaryStatisticsChart />
            <PerformanceChart />
          </div>
        </div>
      </main>
    </div>
  );
}
```

### Layout B: Dark Theme Dashboard
> 출처: Spoon Restaurant

```tsx
// Tailwind config for dark theme
const darkThemeConfig = {
  colors: {
    dark: {
      bg: '#0f0f23',
      card: '#1a1a2e',
      border: '#2a2a4a',
      text: {
        primary: '#ffffff',
        secondary: '#9ca3af',
        muted: '#6b7280',
      }
    }
  }
};

// app/dashboard-dark/page.tsx
export default function DarkDashboard() {
  return (
    <div className="flex h-screen bg-[#0f0f23]">
      {/* Sidebar */}
      <aside className="w-[200px] bg-[#1a1a2e] border-r border-[#2a2a4a] p-4">
        {/* ... dark sidebar content */}
      </aside>

      {/* Main */}
      <main className="flex-1 p-6 overflow-auto">
        {/* Header */}
        <header className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-4">
            <h1 className="text-xl font-semibold text-white">Spoon</h1>
            <span className="text-sm text-gray-400">Hello Magrot, Welcome to Spoon</span>
          </div>
          <div className="flex items-center gap-3">
            <span className="flex items-center gap-2 px-3 py-1 bg-green-500/20
                            text-green-400 rounded-full text-sm">
              <span className="w-2 h-2 bg-green-400 rounded-full" />
              Restaurant Open
            </span>
            <span className="text-sm text-gray-400">24 September 2022</span>
          </div>
        </header>

        {/* KPI Cards */}
        <div className="grid grid-cols-4 gap-4 mb-6">
          <GradientKPICard
            title="New Orders"
            value="25"
            gradient="red"
            subtitle="All online incoming orders"
          />
          {/* ... more cards */}
        </div>

        {/* Charts */}
        <div className="grid grid-cols-3 gap-6">
          <div className="col-span-2">
            <SalesChart />
          </div>
          <EarningDetailsCard />
        </div>
      </main>
    </div>
  );
}
```
