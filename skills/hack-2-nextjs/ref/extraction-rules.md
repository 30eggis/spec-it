# Extraction Rules (CRITICAL)

Rules for extracting and transforming source code without corruption.

---

## 1. Forbidden Actions

### 1.1 Absolute Prohibitions

| Action | Description | Result |
|--------|-------------|--------|
| **Speculation** | Adding things not in original ("it probably should be...") | SKILL FAILURE |
| **Imagination** | Design improvements, "better" UX suggestions | SKILL FAILURE |
| **Arbitrary Changes** | Modifying layout, classes, structure | SKILL FAILURE |
| **Code Generation** | Writing components from scratch | SKILL FAILURE |
| **Prediction** | Guessing what the designer intended | SKILL FAILURE |
| **Suggestion** | Proposing alternatives to original | SKILL FAILURE |

### 1.2 Specific Prohibitions

```
DO NOT:
- Change grid-cols-N values
- Change gap-N values
- Change flex-direction
- Add classes not in original
- Remove classes from original
- "Improve" layout structure
- "Optimize" component architecture
- Apply "React best practices" that alter structure
- Create components that don't exist in source
- Write StatCard, TimeClock, etc. from imagination
```

---

## 2. Allowed Actions

### 2.1 Component Aggregation

Extracting common patterns and creating props for external injection:

```tsx
// ALLOWED: Extract props from repeated patterns
// Original (found 3+ times):
<div className="rounded-lg p-4 bg-white">
  <h3>Title A</h3>
  <p>Value A</p>
</div>

// Aggregated component:
interface CardProps {
  title: string;  // Extracted from pattern
  value: string;  // Extracted from pattern
}

function Card({ title, value }: CardProps) {
  return (
    <div className="rounded-lg p-4 bg-white">  // Classes preserved!
      <h3>{title}</h3>
      <p>{value}</p>
    </div>
  );
}
```

### 2.2 Design Token Substitution

Replacing hardcoded values with tokens:

```tsx
// Original
<div className="bg-[#3b82f6] text-[#1e293b]">

// After token substitution
<div className="bg-primary text-textPrimary">
```

### 2.3 Route Path Substitution

Converting file paths to NextJS routes:

```tsx
// Original
<a href="file:///mockup/leave.html">

// After route substitution
<Link href="/leave">
```

### 2.4 HTML to JSX Syntax Conversion

| HTML | JSX | Allowed |
|------|-----|---------|
| `class="..."` | `className="..."` | YES |
| `for="..."` | `htmlFor="..."` | YES |
| `<img>` | `<img />` | YES |
| `<input>` | `<input />` | YES |
| `style="color:red"` | `style={{color:'red'}}` | YES |
| `tabindex="0"` | `tabIndex={0}` | YES |
| `onclick="..."` | Remove (wire separately) | YES |

---

## 3. The Golden Rule

```
COLLECT, DON'T CREATE.

Your job is to:
1. Extract what exists
2. Organize into candidates
3. Aggregate common patterns
4. Substitute tokens/routes
5. Document mock data

Your job is NOT to:
1. Invent new designs
2. Improve the original
3. Suggest better approaches
4. Write custom implementations
```

---

## 4. Validation Checklist

Before completing extraction, verify:

- [ ] All classes match original source
- [ ] No new classes were added
- [ ] No classes were removed
- [ ] Layout structure unchanged
- [ ] Grid columns match original
- [ ] Gap values match original
- [ ] No "improvements" applied
- [ ] Components extracted from actual patterns (not imagined)
- [ ] Props derived from actual variations (not invented)

---

## 5. Error Examples

### BAD: Speculation

```tsx
// Original has no loading state
// BAD: Adding speculated loading state
{isLoading ? <Spinner /> : <Content />}  // FORBIDDEN
```

### BAD: Imagination

```tsx
// Original: grid-cols-3
// BAD: "Improving" to grid-cols-4 for "better balance"
<div className="grid grid-cols-4">  // FORBIDDEN
```

### BAD: Code Generation

```tsx
// Original: inline calendar markup
// BAD: Writing custom MiniCalendar component from scratch
function MiniCalendar({ events, onDateClick }) {  // FORBIDDEN
  // ... custom implementation
}
```

### GOOD: Proper Aggregation

```tsx
// FOUND: Same pattern in P001, P002, P005
// GOOD: Extract pattern as-is, parameterize only variable parts
function StatCard({ title, value, icon }: StatCardProps) {
  return (
    // Exact classes from original
    <div className="rounded-2xl p-6 shadow-sm border border-slate-100">
      // Exact structure from original
    </div>
  );
}
```
