# Form Templates

실제 2026 SaaS UI 예시에서 추출한 폼 템플릿 패턴.

---

## 1. Authentication Forms

### Pattern A: Split Layout Sign Up
> 출처: MudraBank Sign Up

```tsx
// components/auth/sign-up-split.tsx
export function SignUpSplit() {
  return (
    <div className="min-h-screen flex">
      {/* Left: Image */}
      <div className="hidden lg:flex lg:w-1/2 relative">
        <img
          src="/auth-bg.jpg"
          alt=""
          className="absolute inset-0 w-full h-full object-cover"
        />
        {/* Optional overlay */}
        <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent" />
      </div>

      {/* Right: Form */}
      <div className="w-full lg:w-1/2 flex items-center justify-center p-8">
        <div className="w-full max-w-md">
          {/* Header */}
          <div className="mb-8">
            <h1 className="text-3xl font-bold text-gray-900 mb-2">Sign Up</h1>
            <p className="text-gray-500">
              Join the millions of people who trust Mudra Bank for their finances.
            </p>
          </div>

          {/* Form */}
          <form className="space-y-5">
            {/* Full Name */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1.5">
                Full Name
              </label>
              <input
                type="text"
                placeholder="peter@info.com"
                className="w-full px-4 py-3 rounded-xl border-2 border-green-500
                           text-gray-900 placeholder:text-gray-400
                           focus:outline-none focus:border-green-600
                           transition-colors"
              />
            </div>

            {/* Email */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1.5">
                Email
              </label>
              <input
                type="email"
                placeholder="peter@info.com"
                className="w-full px-4 py-3 rounded-xl border border-gray-200
                           text-gray-900 placeholder:text-gray-400
                           focus:outline-none focus:border-green-500 focus:ring-2 focus:ring-green-100
                           transition-all"
              />
            </div>

            {/* Password */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1.5">
                Password
              </label>
              <div className="relative">
                <input
                  type="password"
                  placeholder="••••••••••"
                  className="w-full px-4 py-3 pr-12 rounded-xl border border-gray-200
                             text-gray-900
                             focus:outline-none focus:border-green-500 focus:ring-2 focus:ring-green-100
                             transition-all"
                />
                <button
                  type="button"
                  className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400
                            hover:text-gray-600 transition-colors"
                >
                  <EyeOff className="w-5 h-5" />
                </button>
              </div>
            </div>

            {/* Confirm Password */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1.5">
                Confirm Password
              </label>
              <div className="relative">
                <input
                  type="password"
                  placeholder="••••••••••"
                  className="w-full px-4 py-3 pr-12 rounded-xl border border-gray-200
                             text-gray-900
                             focus:outline-none focus:border-green-500 focus:ring-2 focus:ring-green-100
                             transition-all"
                />
                <button
                  type="button"
                  className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400
                            hover:text-gray-600 transition-colors"
                >
                  <EyeOff className="w-5 h-5" />
                </button>
              </div>
            </div>

            {/* Submit */}
            <button
              type="submit"
              className="w-full py-3.5 bg-green-500 hover:bg-green-600
                         text-white font-medium rounded-xl
                         transition-colors duration-200
                         focus:outline-none focus:ring-2 focus:ring-green-500 focus:ring-offset-2"
            >
              Next
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
```

### Input Styles Extracted

```tsx
// components/ui/form-input.tsx
interface FormInputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
  variant?: "default" | "focused" | "success" | "error";
}

const inputVariants = {
  default: `
    border border-gray-200
    focus:border-blue-500 focus:ring-2 focus:ring-blue-100
  `,
  focused: `
    border-2 border-green-500
    focus:border-green-600
  `,
  success: `
    border-2 border-green-500
    bg-green-50/30
  `,
  error: `
    border-2 border-red-500
    bg-red-50/30
    focus:ring-2 focus:ring-red-100
  `,
};

export function FormInput({
  label,
  error,
  variant = "default",
  className,
  ...props
}: FormInputProps) {
  return (
    <div className="space-y-1.5">
      {label && (
        <label className="block text-sm font-medium text-gray-700">
          {label}
        </label>
      )}
      <input
        className={cn(
          "w-full px-4 py-3 rounded-xl",
          "text-gray-900 placeholder:text-gray-400",
          "transition-all duration-200",
          "focus:outline-none",
          inputVariants[variant],
          error && inputVariants.error,
          className
        )}
        {...props}
      />
      {error && (
        <p className="text-sm text-red-500 flex items-center gap-1">
          <AlertCircle className="w-4 h-4" />
          {error}
        </p>
      )}
    </div>
  );
}
```

---

## 2. Search Inputs

### Pattern A: Simple Search with Icon
> 출처: MedOps, Destined

```tsx
// components/ui/search-input.tsx
interface SearchInputProps {
  placeholder?: string;
  variant?: "default" | "filled" | "minimal";
  size?: "sm" | "md" | "lg";
  onSearch?: (value: string) => void;
}

const variants = {
  default: `
    bg-white border border-gray-200
    focus-within:border-blue-400 focus-within:ring-2 focus-within:ring-blue-100
  `,
  filled: `
    bg-gray-50 border-none
    focus-within:bg-gray-100 focus-within:ring-2 focus-within:ring-blue-100
  `,
  minimal: `
    bg-transparent border-b border-gray-200
    rounded-none focus-within:border-blue-500
  `,
};

const sizes = {
  sm: "h-9 text-sm",
  md: "h-10 text-sm",
  lg: "h-12 text-base",
};

export function SearchInput({
  placeholder = "Search",
  variant = "default",
  size = "md",
  onSearch,
}: SearchInputProps) {
  const [value, setValue] = useState("");

  return (
    <div className={cn(
      "relative flex items-center rounded-lg transition-all",
      variants[variant],
      sizes[size]
    )}>
      <Search className="absolute left-3 w-4 h-4 text-gray-400" />
      <input
        type="text"
        value={value}
        onChange={(e) => setValue(e.target.value)}
        onKeyDown={(e) => e.key === "Enter" && onSearch?.(value)}
        placeholder={placeholder}
        className={cn(
          "w-full h-full pl-10 pr-4 bg-transparent",
          "text-gray-900 placeholder:text-gray-400",
          "focus:outline-none",
          variant === "minimal" ? "rounded-none" : "rounded-lg"
        )}
      />
    </div>
  );
}
```

### Pattern B: Search with Dark Theme
> 출처: MudraBank Dark

```tsx
// components/ui/search-input-dark.tsx
export function SearchInputDark({ placeholder = "Search" }) {
  return (
    <div className="relative">
      <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-500" />
      <input
        type="text"
        placeholder={placeholder}
        className="w-full h-11 pl-11 pr-4
                   bg-gray-800 rounded-xl
                   text-white placeholder:text-gray-500
                   border border-gray-700
                   focus:outline-none focus:border-gray-600 focus:ring-1 focus:ring-gray-600
                   transition-all"
      />
    </div>
  );
}
```

---

## 3. Filter & Action Buttons

### Pattern A: Filter Bar
> 출처: MudraBank Transaction

```tsx
// components/ui/filter-bar.tsx
interface FilterBarProps {
  onPrint?: () => void;
  onFilter?: () => void;
  filters?: { label: string; value: string }[];
}

export function FilterBar({ onPrint, onFilter, filters }: FilterBarProps) {
  return (
    <div className="flex items-center gap-2">
      {/* Print Button */}
      <button
        onClick={onPrint}
        className="inline-flex items-center gap-1.5 px-3 py-1.5
                   text-sm text-gray-600 dark:text-gray-300
                   border border-gray-200 dark:border-gray-600 rounded-lg
                   hover:bg-gray-50 dark:hover:bg-gray-700
                   transition-colors"
      >
        <Printer className="w-4 h-4" />
        Print
      </button>

      {/* Filter Button */}
      <button
        onClick={onFilter}
        className="inline-flex items-center gap-1.5 px-3 py-1.5
                   text-sm text-gray-600 dark:text-gray-300
                   border border-gray-200 dark:border-gray-600 rounded-lg
                   hover:bg-gray-50 dark:hover:bg-gray-700
                   transition-colors"
      >
        <SlidersHorizontal className="w-4 h-4" />
        Filter
      </button>
    </div>
  );
}
```

### Pattern B: Tab Filters
> 출처: Destined Messages

```tsx
// components/ui/tab-filters.tsx
interface TabFiltersProps {
  tabs: { label: string; count?: number }[];
  activeTab: number;
  onChange: (index: number) => void;
}

export function TabFilters({ tabs, activeTab, onChange }: TabFiltersProps) {
  return (
    <div className="flex border-b border-gray-100">
      {tabs.map((tab, index) => (
        <button
          key={index}
          onClick={() => onChange(index)}
          className={cn(
            "flex-1 px-4 py-3 text-sm font-medium transition-colors",
            "border-b-2 -mb-px",
            activeTab === index
              ? "text-blue-600 border-blue-600"
              : "text-gray-500 border-transparent hover:text-gray-700 hover:border-gray-300"
          )}
        >
          {tab.label}
          {tab.count !== undefined && (
            <span className={cn(
              "ml-1.5",
              activeTab === index ? "text-blue-600" : "text-gray-400"
            )}>
              ({tab.count >= 1000 ? `${(tab.count / 1000).toFixed(0)}k` : tab.count})
            </span>
          )}
        </button>
      ))}
    </div>
  );
}

// Usage
<TabFilters
  tabs={[
    { label: "Issue Raised", count: 100000 },
    { label: "Unresolved" },
    { label: "Resolved" },
  ]}
  activeTab={0}
  onChange={setActiveTab}
/>
```

---

## 4. Button Styles

### Primary Button Variants

```tsx
// components/ui/button.tsx
const buttonVariants = {
  // Green Primary (MudraBank style)
  primary: `
    bg-green-500 hover:bg-green-600 active:bg-green-700
    text-white font-medium
    shadow-sm hover:shadow
  `,

  // Blue Primary (MedOps style)
  primaryBlue: `
    bg-blue-600 hover:bg-blue-700 active:bg-blue-800
    text-white font-medium
    shadow-sm hover:shadow
  `,

  // Orange/Coral Primary (MudraBank Transaction)
  primaryOrange: `
    bg-gradient-to-r from-orange-400 to-red-500
    hover:from-orange-500 hover:to-red-600
    text-white font-medium
    shadow-sm hover:shadow
  `,

  // Secondary (Outline)
  secondary: `
    bg-white hover:bg-gray-50
    text-gray-700 font-medium
    border border-gray-200 hover:border-gray-300
  `,

  // Ghost
  ghost: `
    bg-transparent hover:bg-gray-100
    text-gray-600 font-medium
  `,

  // Dark Theme
  dark: `
    bg-gray-700 hover:bg-gray-600
    text-white font-medium
    border border-gray-600
  `,
};

const buttonSizes = {
  sm: "h-8 px-3 text-sm rounded-lg",
  md: "h-10 px-4 text-sm rounded-xl",
  lg: "h-12 px-6 text-base rounded-xl",
  xl: "h-14 px-8 text-base rounded-xl",
};

export function Button({
  variant = "primary",
  size = "md",
  className,
  children,
  ...props
}: ButtonProps) {
  return (
    <button
      className={cn(
        "inline-flex items-center justify-center gap-2",
        "transition-all duration-200",
        "focus:outline-none focus:ring-2 focus:ring-offset-2",
        buttonVariants[variant],
        buttonSizes[size],
        className
      )}
      {...props}
    >
      {children}
    </button>
  );
}
```

### Sidebar Navigation Button
> 출처: MudraBank Transaction

```tsx
// components/ui/nav-button.tsx
interface NavButtonProps {
  icon: React.ElementType;
  label: string;
  active?: boolean;
  badge?: string;
}

export function NavButton({ icon: Icon, label, active, badge }: NavButtonProps) {
  return (
    <button
      className={cn(
        "w-full flex items-center gap-3 px-4 py-3 rounded-xl",
        "text-sm font-medium transition-all duration-200",
        active
          ? "bg-gradient-to-r from-orange-400 to-red-500 text-white shadow-lg shadow-orange-500/30"
          : "text-gray-600 hover:bg-gray-50"
      )}
    >
      <Icon className="w-5 h-5" />
      <span className="flex-1 text-left">{label}</span>
      {badge && (
        <span className={cn(
          "px-2 py-0.5 text-xs font-bold rounded",
          active ? "bg-white/20 text-white" : "bg-red-100 text-red-600"
        )}>
          {badge}
        </span>
      )}
    </button>
  );
}
```

---

## 5. Select/Dropdown

### Pattern A: Simple Select
> 출처: HR Admin

```tsx
// components/ui/select-simple.tsx
export function SelectSimple({
  options,
  value,
  onChange,
  placeholder = "Select...",
}: SelectSimpleProps) {
  return (
    <div className="relative">
      <select
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="appearance-none w-full h-10 pl-4 pr-10
                   bg-white border border-gray-200 rounded-lg
                   text-sm text-gray-700
                   focus:outline-none focus:border-blue-400 focus:ring-2 focus:ring-blue-100
                   cursor-pointer transition-all"
      >
        <option value="" disabled>{placeholder}</option>
        {options.map((opt) => (
          <option key={opt.value} value={opt.value}>
            {opt.label}
          </option>
        ))}
      </select>
      <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
    </div>
  );
}
```

### Pattern B: Dropdown Button
> 출처: Destined Dashboard

```tsx
// components/ui/dropdown-button.tsx
export function DropdownButton({
  label,
  options,
  value,
  onChange,
}: DropdownButtonProps) {
  const [open, setOpen] = useState(false);

  return (
    <div className="relative">
      <button
        onClick={() => setOpen(!open)}
        className="inline-flex items-center gap-2 px-4 py-2
                   bg-white border border-gray-200 rounded-lg
                   text-sm text-gray-700 font-medium
                   hover:bg-gray-50 transition-colors"
      >
        {label}
        <ChevronDown className={cn(
          "w-4 h-4 transition-transform",
          open && "rotate-180"
        )} />
      </button>

      {open && (
        <div className="absolute top-full left-0 mt-1 w-48
                       bg-white border border-gray-200 rounded-lg shadow-lg
                       py-1 z-50">
          {options.map((opt) => (
            <button
              key={opt.value}
              onClick={() => {
                onChange(opt.value);
                setOpen(false);
              }}
              className={cn(
                "w-full px-4 py-2 text-left text-sm",
                "hover:bg-gray-50 transition-colors",
                value === opt.value
                  ? "text-blue-600 font-medium"
                  : "text-gray-700"
              )}
            >
              {opt.label}
            </button>
          ))}
        </div>
      )}
    </div>
  );
}
```

---

## 6. Checkbox Styles

### Pattern A: Transaction Checkbox
> 출처: MudraBank Transaction

```tsx
// components/ui/checkbox.tsx
interface CheckboxProps {
  checked?: boolean;
  onChange?: (checked: boolean) => void;
  variant?: "default" | "rounded";
}

export function Checkbox({
  checked = false,
  onChange,
  variant = "default",
}: CheckboxProps) {
  return (
    <button
      role="checkbox"
      aria-checked={checked}
      onClick={() => onChange?.(!checked)}
      className={cn(
        "w-5 h-5 flex items-center justify-center",
        "border-2 transition-all duration-150",
        variant === "rounded" ? "rounded-md" : "rounded",
        checked
          ? "bg-blue-600 border-blue-600"
          : "bg-white border-gray-300 hover:border-gray-400"
      )}
    >
      {checked && (
        <Check className="w-3 h-3 text-white" strokeWidth={3} />
      )}
    </button>
  );
}
```

---

## 7. Badge & Status Indicators

### Pattern A: Availability Badges
> 출처: MedOps Doctor List

```tsx
// components/ui/availability-badges.tsx
interface AvailabilityBadgesProps {
  days: ("S" | "M" | "T" | "W" | "F")[];
  available: string[];
}

export function AvailabilityBadges({ days, available }: AvailabilityBadgesProps) {
  return (
    <div className="flex gap-1">
      {days.map((day, index) => {
        const isAvailable = available.includes(day);
        return (
          <span
            key={index}
            className={cn(
              "w-6 h-6 rounded-full text-xs font-semibold",
              "flex items-center justify-center",
              isAvailable
                ? "bg-green-500 text-white"
                : "bg-gray-100 text-gray-400"
            )}
          >
            {day}
          </span>
        );
      })}
    </div>
  );
}
```

### Pattern B: Status Dot
> 출처: MudraBank, Spoon

```tsx
// components/ui/status-dot.tsx
type StatusType = "online" | "offline" | "busy" | "confirm" | "pending" | "failed";

const statusColors: Record<StatusType, string> = {
  online: "bg-green-500",
  offline: "bg-gray-400",
  busy: "bg-red-500",
  confirm: "bg-green-500",
  pending: "bg-orange-500",
  failed: "bg-red-500",
};

export function StatusDot({ status }: { status: StatusType }) {
  return (
    <span className={cn(
      "inline-block w-2 h-2 rounded-full",
      statusColors[status]
    )} />
  );
}

// With label
export function StatusBadge({ status, label }: { status: StatusType; label: string }) {
  return (
    <span className="inline-flex items-center gap-1.5">
      <StatusDot status={status} />
      <span className={cn(
        "text-sm font-medium",
        status === "confirm" && "text-green-600",
        status === "pending" && "text-orange-500",
        status === "failed" && "text-red-500"
      )}>
        {label}
      </span>
    </span>
  );
}
```

### Pattern C: "New" Badge
> 출처: HR Admin Payslip

```tsx
// components/ui/new-badge.tsx
export function NewBadge({ className }: { className?: string }) {
  return (
    <span className={cn(
      "inline-block px-2 py-0.5",
      "bg-orange-500 text-white",
      "text-[10px] font-bold uppercase tracking-wide",
      "rounded-full",
      className
    )}>
      New
    </span>
  );
}
```

### Pattern D: Live Badge
> 출처: Spoon Dashboard

```tsx
// components/ui/live-badge.tsx
export function LiveBadge() {
  return (
    <span className="inline-flex items-center gap-1.5 px-2 py-0.5
                     bg-red-500 text-white text-xs font-bold
                     rounded animate-pulse">
      <span className="w-1.5 h-1.5 bg-white rounded-full" />
      Live
    </span>
  );
}
```
