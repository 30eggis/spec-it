# Card Templates

실제 2026 SaaS UI 예시에서 추출한 카드 컴포넌트 템플릿.

---

## 1. KPI/Stat Cards

### Type A: Large Number with Gradient
> 출처: Destined Dashboard, MudraBank Invoices

```tsx
// components/cards/kpi-gradient-card.tsx
interface KPIGradientCardProps {
  title: string;
  value: string;
  subtitle?: string;
  trend?: { value: number; label: string };
  gradient: "teal" | "pink" | "blue" | "purple" | "orange";
  illustration?: React.ReactNode;
}

const gradientMap = {
  teal: "from-teal-400 to-cyan-500",
  pink: "from-pink-400 to-rose-500",
  blue: "from-blue-500 to-indigo-600",
  purple: "from-purple-500 to-violet-600",
  orange: "from-orange-400 to-red-500",
};

export function KPIGradientCard({
  title,
  value,
  subtitle,
  trend,
  gradient,
  illustration,
}: KPIGradientCardProps) {
  return (
    <div className={cn(
      "relative rounded-2xl p-6 text-white overflow-hidden",
      "bg-gradient-to-br",
      gradientMap[gradient]
    )}>
      {/* Background illustration */}
      {illustration && (
        <div className="absolute top-2 right-2 w-20 h-20 opacity-80">
          {illustration}
        </div>
      )}

      {/* Content */}
      <div className="relative z-10">
        <p className="text-sm font-medium text-white/80 mb-2">{title}</p>
        <p className="text-4xl font-bold mb-1">{value}</p>
        {subtitle && (
          <p className="text-xs text-white/70">{subtitle}</p>
        )}
        {trend && (
          <div className="flex items-center gap-1 mt-2">
            <TrendingUp className="w-4 h-4" />
            <span className="text-sm font-medium">
              {trend.value > 0 && "+"}{trend.value}% {trend.label}
            </span>
          </div>
        )}
      </div>
    </div>
  );
}

// Usage Example
<KPIGradientCard
  title="Total Users"
  value="100 millions"
  subtitle="Average 11k users daily"
  gradient="teal"
  illustration={<UserGroupIllustration />}
/>
```

### Type B: Minimal Stat with Icon
> 출처: HR Admin Dashboard

```tsx
// components/cards/stat-icon-card.tsx
interface StatIconCardProps {
  label: string;
  value: string | number;
  icon: React.ReactNode;
  iconBg: string;
  trend?: "up" | "down" | "neutral";
}

export function StatIconCard({
  label,
  value,
  icon,
  iconBg,
  trend,
}: StatIconCardProps) {
  return (
    <div className="flex items-center gap-4 p-5 bg-white rounded-2xl
                    border border-gray-100 shadow-sm">
      {/* Icon */}
      <div className={cn(
        "w-14 h-14 rounded-full flex items-center justify-center",
        iconBg
      )}>
        {icon}
      </div>

      {/* Stats */}
      <div className="flex-1">
        <p className="text-3xl font-bold text-gray-900">{value}</p>
        <p className="text-sm text-gray-500">{label}</p>
      </div>

      {/* Trend indicator */}
      {trend && (
        <div className={cn(
          "w-10 h-10 rounded-full flex items-center justify-center",
          trend === "up" && "bg-green-100",
          trend === "down" && "bg-red-100",
          trend === "neutral" && "bg-gray-100"
        )}>
          {trend === "up" && <TrendingUp className="w-5 h-5 text-green-600" />}
          {trend === "down" && <TrendingDown className="w-5 h-5 text-red-600" />}
          {trend === "neutral" && <Minus className="w-5 h-5 text-gray-600" />}
        </div>
      )}
    </div>
  );
}
```

### Type C: Dark Theme KPI Card
> 출처: Spoon Restaurant

```tsx
// components/cards/kpi-dark-card.tsx
interface KPIDarkCardProps {
  title: string;
  value: string | number;
  subtitle?: string;
  variant: "primary" | "secondary" | "outline";
  badge?: React.ReactNode;
  action?: { label: string; onClick: () => void };
}

export function KPIDarkCard({
  title,
  value,
  subtitle,
  variant,
  badge,
  action,
}: KPIDarkCardProps) {
  const variantStyles = {
    primary: "bg-gradient-to-br from-red-500 to-orange-600 text-white",
    secondary: "bg-[#1f1f3a] text-white border border-[#2a2a4a]",
    outline: "bg-transparent text-white border border-[#2a2a4a]",
  };

  return (
    <div className={cn(
      "rounded-2xl p-6 relative",
      variantStyles[variant]
    )}>
      {/* Badge */}
      {badge && (
        <div className="absolute top-4 right-4">
          {badge}
        </div>
      )}

      {/* Content */}
      <p className={cn(
        "text-sm font-medium mb-2",
        variant === "primary" ? "text-white/90" : "text-gray-400"
      )}>
        {title}
      </p>
      <p className="text-5xl font-bold mb-1">{value}</p>
      {subtitle && (
        <p className={cn(
          "text-xs",
          variant === "primary" ? "text-white/70" : "text-gray-500"
        )}>
          {subtitle}
        </p>
      )}

      {/* Action */}
      {action && (
        <button
          onClick={action.onClick}
          className={cn(
            "mt-4 px-4 py-2 text-sm font-medium rounded-lg transition-colors",
            variant === "primary"
              ? "bg-white/20 hover:bg-white/30 text-white"
              : "bg-blue-600 hover:bg-blue-700 text-white"
          )}
        >
          {action.label}
        </button>
      )}
    </div>
  );
}
```

---

## 2. Profile Cards

### Type A: Employee Payslip Card
> 출처: HR Admin Payslip

```tsx
// components/cards/employee-card.tsx
interface EmployeeCardProps {
  company: string;
  name: string;
  employeeId: string;
  designation: string;
  address: string;
  avatar: string;
  isNew?: boolean;
}

export function EmployeeCard({
  company,
  name,
  employeeId,
  designation,
  address,
  avatar,
  isNew,
}: EmployeeCardProps) {
  return (
    <div className="bg-gradient-to-r from-pink-100 via-purple-50 to-blue-100
                    rounded-2xl p-6 relative">
      {/* Company Badge */}
      <span className="inline-block px-4 py-1.5 mb-4
                       bg-blue-600 text-white text-xs font-semibold
                       rounded-full">
        {company}
      </span>

      {/* Profile Row */}
      <div className="flex items-start gap-4">
        {/* Avatar with New badge */}
        <div className="relative flex-shrink-0">
          <img
            src={avatar}
            alt={name}
            className="w-16 h-16 rounded-xl object-cover"
          />
          {isNew && (
            <span className="absolute -top-2 -left-2 px-1.5 py-0.5
                            bg-orange-500 text-white text-[9px] font-bold
                            rounded-full">
              New
            </span>
          )}
        </div>

        {/* Info */}
        <div className="flex-1 min-w-0">
          <h3 className="text-xl font-semibold text-gray-900">{name}</h3>
          <div className="mt-1 space-y-0.5 text-sm text-gray-600">
            <p>Employee ID: <span className="font-medium">{employeeId}</span></p>
            <p>Designation: <span className="font-medium">{designation}</span></p>
            <p className="flex items-start gap-1 mt-2 text-gray-500">
              <MapPin className="w-4 h-4 flex-shrink-0 mt-0.5" />
              <span>{address}</span>
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
```

### Type B: Doctor/User Row Card
> 출처: MedOps Doctor List (Selected State)

```tsx
// components/cards/user-row-card.tsx
interface UserRowCardProps {
  rank: number;
  name: string;
  credential: string;
  specialty: string;
  fee: number;
  experience: string;
  availability: string[];
  avatar: string;
  selected?: boolean;
  onClick?: () => void;
}

export function UserRowCard({
  rank,
  name,
  credential,
  specialty,
  fee,
  experience,
  availability,
  avatar,
  selected,
  onClick,
}: UserRowCardProps) {
  return (
    <div
      onClick={onClick}
      className={cn(
        "flex items-center gap-4 px-6 py-4 cursor-pointer transition-all",
        selected
          ? "bg-blue-50 border-l-4 border-blue-500"
          : "hover:bg-gray-50 border-l-4 border-transparent"
      )}
    >
      {/* Rank */}
      <span className="w-8 text-sm text-gray-400 font-medium">
        {String(rank).padStart(2, '0')}
      </span>

      {/* Avatar & Name */}
      <div className="flex items-center gap-3 min-w-[200px]">
        <img
          src={avatar}
          alt={name}
          className="w-10 h-10 rounded-full object-cover"
        />
        <div>
          <p className="text-sm font-medium text-gray-900">{name}</p>
          <p className="text-xs text-gray-400">{credential}</p>
        </div>
      </div>

      {/* Specialty */}
      <div className="flex-1">
        <p className="text-sm text-gray-600">{specialty}</p>
      </div>

      {/* Fee */}
      <div className="w-20 text-right">
        <p className="text-sm font-medium text-gray-900">
          {fee.toLocaleString()}
        </p>
      </div>

      {/* Experience */}
      <div className="w-20 text-center">
        <p className="text-sm text-gray-600">{experience}</p>
      </div>

      {/* Availability */}
      <div className="flex gap-1">
        {['S', 'M', 'T', 'W', 'T'].map((day, i) => (
          <span
            key={i}
            className={cn(
              "w-6 h-6 rounded-full text-[10px] font-bold",
              "flex items-center justify-center",
              availability.includes(day)
                ? "bg-green-500 text-white"
                : "bg-gray-100 text-gray-400"
            )}
          >
            {day}
          </span>
        ))}
      </div>
    </div>
  );
}
```

---

## 3. Pricing/Subscription Cards

### Type A: 3D Icon Pricing Card
> 출처: 3D Visuals & Interactive Product Demos

```tsx
// components/cards/pricing-3d-card.tsx
interface Pricing3DCardProps {
  icon: React.ReactNode; // 3D rendered image/component
  subscribers: string;
  planName: string;
  duration: string;
  selected?: boolean;
  onCustomize?: () => void;
}

export function Pricing3DCard({
  icon,
  subscribers,
  planName,
  duration,
  selected,
  onCustomize,
}: Pricing3DCardProps) {
  return (
    <div className={cn(
      "bg-white rounded-2xl p-6 text-center",
      "transition-all duration-300",
      "hover:shadow-xl hover:-translate-y-1",
      selected
        ? "border-2 border-blue-500 shadow-lg shadow-blue-500/20"
        : "border border-gray-100 shadow-sm"
    )}>
      {/* 3D Icon */}
      <div className="w-24 h-24 mx-auto mb-4 flex items-center justify-center">
        {icon}
      </div>

      {/* Subscriber count */}
      <p className="text-sm text-gray-500 mb-1">
        {subscribers} Subscribers
      </p>

      {/* Plan name */}
      <h3 className="text-xl font-semibold text-blue-600 mb-0.5">
        {planName}
      </h3>

      {/* Duration */}
      <p className="text-sm text-gray-400">
        {duration}
      </p>

      {/* CTA */}
      <button
        onClick={onCustomize}
        className="w-full mt-6 py-2.5 text-sm font-medium
                  text-gray-600 border border-gray-200 rounded-xl
                  hover:bg-gray-50 hover:border-gray-300
                  transition-colors"
      >
        Customise
      </button>
    </div>
  );
}
```

---

## 4. Message/Chat Cards

### Type A: Message Preview Card
> 출처: Destined Chat Requests

```tsx
// components/cards/message-preview-card.tsx
interface MessagePreviewCardProps {
  name: string;
  avatar: string;
  preview: string;
  time: string;
  unreadCount?: number;
  active?: boolean;
  onClick?: () => void;
}

export function MessagePreviewCard({
  name,
  avatar,
  preview,
  time,
  unreadCount,
  active,
  onClick,
}: MessagePreviewCardProps) {
  return (
    <div
      onClick={onClick}
      className={cn(
        "flex items-center gap-3 px-4 py-3 cursor-pointer transition-all",
        active
          ? "bg-blue-600 text-white rounded-xl mx-2"
          : "hover:bg-gray-50"
      )}
    >
      {/* Avatar with unread badge */}
      <div className="relative flex-shrink-0">
        <img
          src={avatar}
          alt={name}
          className="w-10 h-10 rounded-full object-cover"
        />
        {unreadCount && unreadCount > 0 && (
          <span className="absolute -top-1 -right-1 w-5 h-5
                          bg-red-500 text-white text-[10px] font-bold
                          rounded-full flex items-center justify-center">
            {unreadCount > 9 ? '9+' : unreadCount}
          </span>
        )}
      </div>

      {/* Content */}
      <div className="flex-1 min-w-0">
        <div className="flex items-center justify-between">
          <span className={cn(
            "font-medium text-sm",
            active ? "text-white" : "text-gray-900"
          )}>
            {name}
          </span>
          <span className={cn(
            "text-xs",
            active ? "text-white/70" : "text-gray-400"
          )}>
            {time}
          </span>
        </div>
        <p className={cn(
          "text-sm truncate mt-0.5",
          active ? "text-white/80" : "text-gray-500"
        )}>
          {preview}
        </p>
      </div>
    </div>
  );
}
```

---

## 5. Transaction/List Item Cards

### Type A: Transaction Row
> 출처: MudraBank Transaction

```tsx
// components/cards/transaction-row.tsx
interface TransactionRowProps {
  recipient: string;
  avatar: string | React.ReactNode;
  invoice: string;
  status: "Confirm" | "Pending" | "Failed";
  selected?: boolean;
  onSelect?: (selected: boolean) => void;
}

export function TransactionRow({
  recipient,
  avatar,
  invoice,
  status,
  selected,
  onSelect,
}: TransactionRowProps) {
  const statusConfig = {
    Confirm: { color: "text-green-600", dot: "bg-green-500" },
    Pending: { color: "text-orange-500", dot: "bg-orange-500" },
    Failed: { color: "text-red-500", dot: "bg-red-500" },
  };

  return (
    <div className="flex items-center gap-4 px-6 py-4
                    hover:bg-gray-50 dark:hover:bg-gray-700/50 transition-colors">
      {/* Checkbox */}
      <input
        type="checkbox"
        checked={selected}
        onChange={(e) => onSelect?.(e.target.checked)}
        className="w-4 h-4 rounded border-gray-300 text-blue-600
                   focus:ring-blue-500 focus:ring-offset-0"
      />

      {/* Avatar */}
      <div className="w-10 h-10 rounded-lg bg-gray-100 dark:bg-gray-600
                     flex items-center justify-center overflow-hidden">
        {typeof avatar === 'string' ? (
          <img src={avatar} alt="" className="w-full h-full object-cover" />
        ) : (
          avatar
        )}
      </div>

      {/* Recipient */}
      <span className="flex-1 text-sm font-medium text-gray-900 dark:text-white">
        {recipient}
      </span>

      {/* Invoice */}
      <span className="text-sm text-gray-500 dark:text-gray-400 font-mono">
        {invoice}
      </span>

      {/* Status */}
      <span className="flex items-center gap-1.5">
        <span className={cn("w-2 h-2 rounded-full", statusConfig[status].dot)} />
        <span className={cn("text-sm font-medium", statusConfig[status].color)}>
          {status}
        </span>
      </span>
    </div>
  );
}
```

---

## 6. Earning/Revenue Cards

### Type A: Earning Details Card
> 출처: Spoon Dashboard

```tsx
// components/cards/earning-card.tsx
interface EarningCardProps {
  title: string;
  items: {
    label: string;
    value: string;
    link?: string;
  }[];
}

export function EarningCard({ title, items }: EarningCardProps) {
  return (
    <div className="bg-[#1f1f3a] rounded-2xl p-6 border border-[#2a2a4a]">
      {/* Header */}
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-white font-semibold">{title}</h3>
        <button className="text-gray-400 hover:text-gray-300 transition-colors">
          <Calendar className="w-4 h-4" />
        </button>
      </div>

      {/* Items */}
      <div className="space-y-4">
        {items.map((item, index) => (
          <div key={index} className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-400">{item.label}</p>
              {item.link && (
                <a href="#" className="text-xs text-green-400 hover:underline">
                  {item.link}
                </a>
              )}
            </div>
            <span className="px-3 py-1.5 bg-green-500 text-white
                           text-sm font-bold rounded-lg">
              {item.value}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}

// Usage
<EarningCard
  title="All Earning Details"
  items={[
    { label: "Total Earnings this Month", value: "$478", link: "view all details" },
    { label: "Total refund this Month", value: "$23", link: "view all details" },
  ]}
/>
```

---

## 7. Action/CTA Cards

### Type A: Sidebar CTA Card
> 출처: MedOps, Destined

```tsx
// components/cards/sidebar-cta-card.tsx
interface SidebarCTACardProps {
  variant: "solid" | "quote";
  title?: string;
  subtitle?: string;
  quote?: string;
  buttonLabel?: string;
  onAction?: () => void;
}

export function SidebarCTACard({
  variant,
  title,
  subtitle,
  quote,
  buttonLabel,
  onAction,
}: SidebarCTACardProps) {
  if (variant === "quote") {
    return (
      <div className="mx-4 mb-4 p-4 bg-blue-600 rounded-xl text-white">
        <p className="text-xs leading-relaxed italic">
          "{quote}"
        </p>
      </div>
    );
  }

  return (
    <div className="mx-4 mb-4 p-4 bg-blue-600 rounded-xl text-white text-center">
      {title && <p className="text-sm font-medium">{title}</p>}
      {subtitle && <p className="text-sm font-medium">{subtitle}</p>}
      {buttonLabel && (
        <button
          onClick={onAction}
          className="mt-3 w-full py-2 bg-white text-blue-600
                    text-sm font-medium rounded-lg
                    hover:bg-blue-50 transition-colors"
        >
          {buttonLabel}
        </button>
      )}
    </div>
  );
}
```

---

## 8. CSS Utilities for Cards

```css
/* Base card styles */
.card-base {
  @apply bg-white rounded-2xl border border-gray-100;
  @apply shadow-sm hover:shadow-md transition-shadow;
}

.card-dark {
  @apply bg-gray-800 rounded-2xl border border-gray-700;
}

/* Card hover effects */
.card-hover-lift {
  @apply transition-all duration-300;
  @apply hover:-translate-y-1 hover:shadow-xl;
}

.card-hover-glow {
  @apply transition-shadow duration-300;
  @apply hover:shadow-[0_0_30px_rgba(59,130,246,0.15)];
}

/* Card selected states */
.card-selected {
  @apply border-2 border-blue-500 shadow-lg shadow-blue-500/20;
}

.card-selected-row {
  @apply bg-blue-50 border-l-4 border-blue-500;
}

/* Gradient backgrounds */
.card-gradient-teal {
  @apply bg-gradient-to-br from-teal-400 to-cyan-500;
}

.card-gradient-pink {
  @apply bg-gradient-to-br from-pink-400 to-rose-500;
}

.card-gradient-purple {
  @apply bg-gradient-to-br from-purple-500 to-violet-600;
}

.card-gradient-profile {
  @apply bg-gradient-to-r from-pink-100 via-purple-50 to-blue-100;
}
```
