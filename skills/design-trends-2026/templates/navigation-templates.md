# Navigation Templates

실제 2026 SaaS UI 예시에서 추출한 네비게이션 패턴.

---

## 1. Sidebar Navigation

### Type A: Full Sidebar with Sections
> 출처: Destined, MedOps

```tsx
// components/navigation/sidebar-full.tsx
interface SidebarItem {
  icon: React.ElementType;
  label: string;
  href: string;
  badge?: string | number;
  hasSubmenu?: boolean;
  active?: boolean;
}

interface SidebarSection {
  title?: string;
  items: SidebarItem[];
}

interface SidebarFullProps {
  logo: React.ReactNode;
  subtitle?: string;
  sections: SidebarSection[];
  footer?: React.ReactNode;
}

export function SidebarFull({ logo, subtitle, sections, footer }: SidebarFullProps) {
  return (
    <aside className="w-[240px] h-screen bg-white border-r border-gray-100
                      flex flex-col">
      {/* Logo */}
      <div className="h-16 px-5 flex items-center gap-2 border-b border-gray-100">
        {logo}
        {subtitle && (
          <span className="text-[10px] text-gray-400">{subtitle}</span>
        )}
      </div>

      {/* Sections */}
      <div className="flex-1 overflow-y-auto py-4">
        {sections.map((section, sectionIndex) => (
          <div key={sectionIndex} className="px-4 mb-6">
            {section.title && (
              <p className="text-[11px] font-semibold text-gray-400
                           uppercase tracking-wider mb-3 flex items-center gap-2">
                {section.title}
                <span className="flex-1 h-px bg-gray-200" />
              </p>
            )}
            <nav className="space-y-1">
              {section.items.map((item, itemIndex) => (
                <SidebarItem key={itemIndex} {...item} />
              ))}
            </nav>
          </div>
        ))}
      </div>

      {/* Footer */}
      {footer && (
        <div className="p-4 border-t border-gray-100">
          {footer}
        </div>
      )}
    </aside>
  );
}

function SidebarItem({ icon: Icon, label, href, badge, hasSubmenu, active }: SidebarItem) {
  return (
    <a
      href={href}
      className={cn(
        "flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium",
        "transition-colors duration-150",
        active
          ? "bg-blue-50 text-blue-600"
          : "text-gray-600 hover:bg-gray-50 hover:text-gray-900"
      )}
    >
      <Icon className="w-5 h-5 flex-shrink-0" />
      <span className="flex-1">{label}</span>
      {badge && (
        <span className={cn(
          "px-2 py-0.5 text-xs font-bold rounded",
          active ? "bg-blue-100 text-blue-600" : "bg-red-100 text-red-600"
        )}>
          {badge}
        </span>
      )}
      {hasSubmenu && <ChevronRight className="w-4 h-4 text-gray-400" />}
    </a>
  );
}
```

### Type B: Icon-Only Sidebar (Dark)
> 출처: HR Admin Dashboard

```tsx
// components/navigation/sidebar-icon.tsx
interface IconNavItem {
  icon: React.ElementType;
  href: string;
  label: string; // for accessibility
  active?: boolean;
}

interface SidebarIconProps {
  logo: React.ReactNode;
  items: IconNavItem[];
}

export function SidebarIcon({ logo, items }: SidebarIconProps) {
  return (
    <aside className="w-[72px] h-screen bg-[#1e2a4a] flex flex-col items-center py-4">
      {/* Logo */}
      <div className="w-12 h-12 rounded-xl overflow-hidden mb-6">
        {logo}
      </div>

      {/* Navigation */}
      <nav className="flex-1 flex flex-col items-center gap-2">
        {items.map((item, index) => (
          <IconNavButton key={index} {...item} />
        ))}
      </nav>
    </aside>
  );
}

function IconNavButton({ icon: Icon, href, label, active }: IconNavItem) {
  return (
    <a
      href={href}
      aria-label={label}
      className={cn(
        "w-11 h-11 rounded-xl flex items-center justify-center",
        "transition-all duration-200",
        active
          ? "bg-amber-400 text-gray-900 shadow-lg shadow-amber-400/30"
          : "text-gray-400 hover:text-white hover:bg-white/10"
      )}
    >
      <Icon className="w-5 h-5" />
    </a>
  );
}
```

### Type C: Gradient Active State Sidebar
> 출처: MudraBank Transaction

```tsx
// components/navigation/sidebar-gradient.tsx
interface GradientNavItem {
  icon: React.ElementType;
  label: string;
  href: string;
  active?: boolean;
}

export function SidebarGradient({ items }: { items: GradientNavItem[] }) {
  return (
    <nav className="space-y-1">
      {items.map((item, index) => (
        <GradientNavButton key={index} {...item} />
      ))}
    </nav>
  );
}

function GradientNavButton({ icon: Icon, label, href, active }: GradientNavItem) {
  return (
    <a
      href={href}
      className={cn(
        "flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium",
        "transition-all duration-200",
        active
          ? "bg-gradient-to-r from-orange-400 to-red-500 text-white shadow-lg shadow-orange-500/30"
          : "text-gray-600 hover:bg-gray-50"
      )}
    >
      <Icon className="w-5 h-5" />
      <span>{label}</span>
    </a>
  );
}
```

### Type D: Collapsible Submenu Sidebar
> 출처: HR Admin Payslip

```tsx
// components/navigation/sidebar-collapsible.tsx
interface CollapsibleNavItem {
  icon: React.ElementType;
  label: string;
  href?: string;
  children?: { label: string; href: string; active?: boolean }[];
  active?: boolean;
  expanded?: boolean;
}

export function CollapsibleNavItem({
  icon: Icon,
  label,
  href,
  children,
  active,
  expanded: initialExpanded = false,
}: CollapsibleNavItem) {
  const [expanded, setExpanded] = useState(initialExpanded);
  const hasChildren = children && children.length > 0;

  return (
    <div>
      {/* Parent Item */}
      <button
        onClick={() => hasChildren && setExpanded(!expanded)}
        className={cn(
          "w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-medium",
          "transition-colors duration-150",
          active
            ? "bg-blue-50 text-blue-600"
            : "text-gray-600 hover:bg-gray-50"
        )}
      >
        <Icon className="w-5 h-5" />
        <span className="flex-1 text-left">{label}</span>
        {hasChildren && (
          <ChevronRight className={cn(
            "w-4 h-4 transition-transform",
            expanded && "rotate-90"
          )} />
        )}
      </button>

      {/* Children */}
      {hasChildren && expanded && (
        <div className="mt-1 ml-9 space-y-1">
          {children.map((child, index) => (
            <a
              key={index}
              href={child.href}
              className={cn(
                "block px-4 py-2 text-sm rounded-lg transition-colors",
                child.active
                  ? "text-blue-600 font-medium"
                  : "text-gray-500 hover:text-gray-700 hover:bg-gray-50"
              )}
            >
              {child.label}
            </a>
          ))}
        </div>
      )}
    </div>
  );
}
```

---

## 2. Top Navigation / Header

### Type A: Dashboard Header with Welcome
> 출처: HR Admin, Spoon

```tsx
// components/navigation/header-welcome.tsx
interface HeaderWelcomeProps {
  greeting: string;
  subtitle?: string;
  userName?: string;
  actions?: React.ReactNode;
}

export function HeaderWelcome({
  greeting,
  subtitle,
  userName,
  actions,
}: HeaderWelcomeProps) {
  return (
    <header className="h-16 px-8 bg-white border-b border-gray-100
                       flex items-center justify-between">
      {/* Left: Welcome Message */}
      <div>
        <h1 className="text-xl font-bold text-gray-900">
          {greeting}{userName && `, ${userName}`}!
        </h1>
        {subtitle && (
          <p className="text-sm text-gray-500">{subtitle}</p>
        )}
      </div>

      {/* Right: Actions */}
      <div className="flex items-center gap-4">
        {actions}
      </div>
    </header>
  );
}

// Usage
<HeaderWelcome
  greeting="Hello Admin"
  subtitle="Measure How Fast You're Growing Monthly Recurring performance management."
  actions={
    <>
      <select className="px-3 py-1.5 border border-gray-200 rounded-lg text-sm">
        <option>Year</option>
      </select>
      <SearchInput placeholder="Search" />
    </>
  }
/>
```

### Type B: Header with Status Indicator
> 출처: Spoon Restaurant

```tsx
// components/navigation/header-status.tsx
interface HeaderStatusProps {
  appName: string;
  welcomeMessage?: string;
  status: { label: string; active: boolean };
  date?: string;
}

export function HeaderStatus({
  appName,
  welcomeMessage,
  status,
  date,
}: HeaderStatusProps) {
  return (
    <header className="h-14 px-6 flex items-center justify-between">
      {/* Left */}
      <div className="flex items-center gap-4">
        <h1 className="text-lg font-semibold text-white">{appName}</h1>
        {welcomeMessage && (
          <span className="text-sm text-gray-400">{welcomeMessage}</span>
        )}
      </div>

      {/* Right */}
      <div className="flex items-center gap-4">
        {/* Status Badge */}
        <span className={cn(
          "flex items-center gap-2 px-3 py-1 rounded-full text-sm font-medium",
          status.active
            ? "bg-green-500/20 text-green-400"
            : "bg-gray-500/20 text-gray-400"
        )}>
          <span className={cn(
            "w-2 h-2 rounded-full",
            status.active ? "bg-green-400" : "bg-gray-400"
          )} />
          {status.label}
        </span>

        {/* Date */}
        {date && (
          <span className="text-sm text-gray-400 flex items-center gap-2">
            <Calendar className="w-4 h-4" />
            {date}
          </span>
        )}
      </div>
    </header>
  );
}
```

### Type C: Header with Tabs
> 출처: Destined

```tsx
// components/navigation/header-tabs.tsx
interface HeaderTabsProps {
  logo: React.ReactNode;
  tabs: { label: string; active?: boolean }[];
  onTabChange?: (index: number) => void;
  searchPlaceholder?: string;
}

export function HeaderTabs({
  logo,
  tabs,
  onTabChange,
  searchPlaceholder = "Search",
}: HeaderTabsProps) {
  return (
    <header className="h-14 px-6 bg-white border-b border-gray-100
                       flex items-center gap-6">
      {/* Logo */}
      <div className="flex-shrink-0">
        {logo}
      </div>

      {/* Tabs */}
      <nav className="flex items-center gap-1">
        {tabs.map((tab, index) => (
          <button
            key={index}
            onClick={() => onTabChange?.(index)}
            className={cn(
              "px-4 py-2 text-sm font-medium rounded-lg transition-colors",
              tab.active
                ? "text-blue-600"
                : "text-gray-500 hover:text-gray-700 hover:bg-gray-50"
            )}
          >
            {tab.label}
          </button>
        ))}
      </nav>

      {/* Spacer */}
      <div className="flex-1" />

      {/* Search */}
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
        <input
          type="text"
          placeholder={searchPlaceholder}
          className="w-64 h-9 pl-10 pr-4 bg-gray-50 rounded-lg
                     text-sm text-gray-900 placeholder:text-gray-400
                     border-none focus:ring-2 focus:ring-blue-100"
        />
      </div>
    </header>
  );
}
```

---

## 3. Breadcrumb

### Type A: Simple Breadcrumb
> 출처: MedOps

```tsx
// components/navigation/breadcrumb.tsx
interface BreadcrumbProps {
  items: { label: string; href?: string }[];
}

export function Breadcrumb({ items }: BreadcrumbProps) {
  return (
    <nav className="flex items-center gap-2 text-sm">
      {items.map((item, index) => (
        <React.Fragment key={index}>
          {index > 0 && (
            <ChevronRight className="w-4 h-4 text-gray-400" />
          )}
          {item.href ? (
            <a
              href={item.href}
              className="text-gray-500 hover:text-gray-700 transition-colors"
            >
              {item.label}
            </a>
          ) : (
            <span className="text-gray-900 font-medium">{item.label}</span>
          )}
        </React.Fragment>
      ))}
    </nav>
  );
}

// Usage
<Breadcrumb
  items={[
    { label: "Dashboard", href: "/" },
    { label: "Hospitals", href: "/hospitals" },
    { label: "Doctor List" },
  ]}
/>
```

---

## 4. Tab Navigation

### Type A: Content Tabs
> 출처: Destined Messages

```tsx
// components/navigation/content-tabs.tsx
interface ContentTab {
  label: string;
  count?: number;
}

interface ContentTabsProps {
  tabs: ContentTab[];
  activeIndex: number;
  onChange: (index: number) => void;
  variant?: "underline" | "pills";
}

export function ContentTabs({
  tabs,
  activeIndex,
  onChange,
  variant = "underline",
}: ContentTabsProps) {
  if (variant === "pills") {
    return (
      <div className="flex gap-2 p-1 bg-gray-100 rounded-lg">
        {tabs.map((tab, index) => (
          <button
            key={index}
            onClick={() => onChange(index)}
            className={cn(
              "px-4 py-2 text-sm font-medium rounded-md transition-all",
              activeIndex === index
                ? "bg-white text-gray-900 shadow-sm"
                : "text-gray-500 hover:text-gray-700"
            )}
          >
            {tab.label}
            {tab.count !== undefined && (
              <span className="ml-1.5 text-xs text-gray-400">
                ({formatCount(tab.count)})
              </span>
            )}
          </button>
        ))}
      </div>
    );
  }

  return (
    <div className="flex border-b border-gray-200">
      {tabs.map((tab, index) => (
        <button
          key={index}
          onClick={() => onChange(index)}
          className={cn(
            "px-4 py-3 text-sm font-medium border-b-2 -mb-px transition-colors",
            activeIndex === index
              ? "text-blue-600 border-blue-600"
              : "text-gray-500 border-transparent hover:text-gray-700 hover:border-gray-300"
          )}
        >
          {tab.label}
          {tab.count !== undefined && (
            <span className={cn(
              "ml-1.5",
              activeIndex === index ? "text-blue-500" : "text-gray-400"
            )}>
              ({formatCount(tab.count)})
            </span>
          )}
        </button>
      ))}
    </div>
  );
}

function formatCount(count: number): string {
  if (count >= 1000000) return `${(count / 1000000).toFixed(1)}M`;
  if (count >= 1000) return `${(count / 1000).toFixed(0)}k`;
  return String(count);
}
```

---

## 5. Mobile Navigation

### Type A: Bottom Navigation
> 출처: Mobile-First Design Pattern

```tsx
// components/navigation/bottom-nav.tsx
interface BottomNavItem {
  icon: React.ElementType;
  label: string;
  href: string;
  active?: boolean;
  badge?: number;
}

export function BottomNav({ items }: { items: BottomNavItem[] }) {
  return (
    <nav className="fixed bottom-0 left-0 right-0 z-50
                    h-16 bg-white border-t border-gray-200
                    flex items-center justify-around
                    safe-area-inset-bottom">
      {items.map((item, index) => (
        <a
          key={index}
          href={item.href}
          className={cn(
            "flex flex-col items-center justify-center gap-1 px-4 py-2",
            "transition-colors",
            item.active ? "text-blue-600" : "text-gray-500"
          )}
        >
          <div className="relative">
            <item.icon className="w-6 h-6" />
            {item.badge && item.badge > 0 && (
              <span className="absolute -top-1 -right-1 w-4 h-4
                              bg-red-500 text-white text-[10px] font-bold
                              rounded-full flex items-center justify-center">
                {item.badge > 9 ? '9+' : item.badge}
              </span>
            )}
          </div>
          <span className="text-xs font-medium">{item.label}</span>
        </a>
      ))}
    </nav>
  );
}
```

---

## 6. Page Title Components

### Type A: Page Header with Actions
> 출처: MudraBank

```tsx
// components/navigation/page-header.tsx
interface PageHeaderProps {
  title: string;
  subtitle?: string;
  actions?: React.ReactNode;
  backHref?: string;
}

export function PageHeader({
  title,
  subtitle,
  actions,
  backHref,
}: PageHeaderProps) {
  return (
    <div className="mb-6">
      {/* Back link */}
      {backHref && (
        <a
          href={backHref}
          className="inline-flex items-center gap-1 text-sm text-gray-500
                    hover:text-gray-700 mb-2"
        >
          <ChevronLeft className="w-4 h-4" />
          Back
        </a>
      )}

      {/* Title row */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">{title}</h1>
          {subtitle && (
            <p className="mt-1 text-sm text-gray-500">{subtitle}</p>
          )}
        </div>
        {actions && (
          <div className="flex items-center gap-3">
            {actions}
          </div>
        )}
      </div>
    </div>
  );
}
```

---

## 7. CSS Utilities

```css
/* Sidebar base */
.sidebar-base {
  @apply w-[240px] h-screen bg-white border-r border-gray-100;
  @apply flex flex-col;
}

.sidebar-dark {
  @apply bg-[#1e2a4a] border-gray-800;
}

/* Nav item states */
.nav-item-active {
  @apply bg-blue-50 text-blue-600;
}

.nav-item-active-gradient {
  @apply bg-gradient-to-r from-orange-400 to-red-500 text-white;
  @apply shadow-lg shadow-orange-500/30;
}

.nav-item-active-border {
  @apply bg-blue-50 text-blue-600 border-l-4 border-blue-600;
}

/* Icon button active */
.icon-btn-active {
  @apply bg-amber-400 text-gray-900;
  @apply shadow-lg shadow-amber-400/30;
}

/* Tab underline */
.tab-underline-active {
  @apply text-blue-600 border-b-2 border-blue-600;
}

/* Header heights */
.header-sm { @apply h-12; }
.header-md { @apply h-14; }
.header-lg { @apply h-16; }

/* Safe area for mobile */
.safe-area-inset-bottom {
  padding-bottom: env(safe-area-inset-bottom);
}
```
