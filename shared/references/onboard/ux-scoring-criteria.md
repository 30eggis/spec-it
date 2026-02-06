# UX Scoring Criteria

Reference document for `ux-scorer` agent.

## Overview

Score each screen on 6 categories, each 0-100 points.
Total score = average of all categories.

---

## Category 1: Action Distance (0-100)

**Definition**: Distance between user input and action buttons.

### Measurement

```javascript
// Get positions with Playwright
const inputs = await page.locator('input, select, textarea').all();
const submitBtn = await page.locator('button[type="submit"], button:has-text("확인"), button:has-text("저장")').first();

const lastInput = inputs[inputs.length - 1];
const inputBox = await lastInput.boundingBox();
const btnBox = await submitBtn.boundingBox();

const distance = Math.sqrt(
  Math.pow(btnBox.x - inputBox.x, 2) +
  Math.pow(btnBox.y - inputBox.y, 2)
);
```

### Deduction Rules

| Condition | Deduction |
|-----------|-----------|
| Button >500px from last input | -20 |
| Button outside viewport (requires scroll) | -30 |
| Related actions not grouped together | -15 |
| Action button in unexpected location (e.g., top-left) | -10 |

### Best Practice

- Primary action button within 200px of input area
- Related buttons grouped together
- Consistent button placement across similar screens

---

## Category 2: Scroll Depth (0-100)

**Definition**: Page height relative to viewport.

### Measurement

```javascript
const pageHeight = await page.evaluate(() => document.body.scrollHeight);
const viewportHeight = await page.evaluate(() => window.innerHeight);
const scrollRatio = pageHeight / viewportHeight;
```

### Deduction Rules

| Condition | Deduction |
|-----------|-----------|
| 2x viewport height | -10 |
| 3x viewport height | -25 |
| 5x+ viewport height | -50 |
| Primary action below fold | -20 |
| Important content below fold | -15 |

### Best Practice

- Critical content above fold
- Max 2x scroll for most pages
- Pagination/infinite scroll for long lists

---

## Category 3: Element Density (0-100)

**Definition**: Number of interactive elements visible in viewport.

### Measurement

```javascript
const interactiveCount = await page.evaluate(() => {
  return document.querySelectorAll(
    'button, input, select, textarea, a, [role="button"], [tabindex]'
  ).length;
});

const tableColumns = await page.evaluate(() => {
  const headers = document.querySelectorAll('th, [role="columnheader"]');
  return headers.length;
});
```

### Deduction Rules

| Condition | Deduction |
|-----------|-----------|
| >20 interactive elements | -10 |
| >30 interactive elements | -25 |
| >50 interactive elements | -50 |
| Table with >15 columns | -20 |
| Form with >10 fields visible at once | -15 |

### Best Practice

- Max 15-20 interactive elements per viewport
- Group related inputs
- Use progressive disclosure for complex forms
- Horizontal scroll for wide tables (or column selection)

---

## Category 4: Mouse Travel (0-100)

**Definition**: Estimated mouse movement for primary workflow.

### Measurement

Analyze primary workflow path:
1. Identify workflow steps (e.g., filter → select → action)
2. Calculate element positions
3. Sum movement distances

```javascript
// Example: Filter-Select-Action workflow
const filterPos = await page.locator('.filter-bar').boundingBox();
const tableRow = await page.locator('table tbody tr').first().boundingBox();
const actionBtn = await page.locator('button:has-text("승인")').boundingBox();

const path1 = distance(filterPos, tableRow);  // Filter to row
const path2 = distance(tableRow, actionBtn);  // Row to action
const totalTravel = path1 + path2;
```

### Deduction Rules

| Condition | Deduction |
|-----------|-----------|
| Left→Right→Left zigzag pattern | -15 |
| Top→Bottom→Top repeated movement | -15 |
| Long diagonal movement (>1000px) | -10 |
| Edge-to-edge required | -20 |

### Best Practice

- Linear workflow paths (top-to-bottom or left-to-right)
- Actions near related content
- Avoid forcing back-and-forth movement

---

## Category 5: Visual Grouping (0-100)

**Definition**: How well related elements are visually grouped.

### Measurement

```javascript
// Check spacing consistency
const cards = await page.locator('.card, [class*="rounded"][class*="shadow"]').all();
const gaps = [];
for (let i = 1; i < cards.length; i++) {
  const prev = await cards[i-1].boundingBox();
  const curr = await cards[i].boundingBox();
  gaps.push(curr.y - (prev.y + prev.height));
}
const gapVariance = calculateVariance(gaps);
```

### Deduction Rules

| Condition | Deduction |
|-----------|-----------|
| Uneven spacing between related items | -15 |
| No visual group separation (cards/lines/spacing) | -20 |
| Inconsistent label-input distance | -10 |
| Related actions scattered | -15 |

### Best Practice

- Consistent spacing within groups
- Clear visual separation between groups
- Labels close to their inputs
- Related actions grouped together

---

## Category 6: Consistency (0-100)

**Definition**: Pattern consistency across similar screens.

### Measurement

Compare with similar screen types:
- Dashboard ↔ Dashboard
- Table page ↔ Table page
- Form ↔ Form

```javascript
// Compare button positions across screens
const screen1BtnPos = await getButtonPosition(screen1);
const screen2BtnPos = await getButtonPosition(screen2);
const positionDiff = distance(screen1BtnPos, screen2BtnPos);
```

### Deduction Rules

| Condition | Deduction |
|-----------|-----------|
| Button position differs from similar screens | -20 |
| Table column order inconsistent | -15 |
| Filter/search position varies | -15 |
| Navigation pattern differs | -10 |

### Best Practice

- Same screen type = same layout
- Consistent button placement
- Consistent table column order
- Consistent navigation patterns

---

## Score Calculation

```
Total = (Action + Scroll + Density + Mouse + Grouping + Consistency) / 6
```

## Grade Scale

| Score | Grade | Action |
|-------|-------|--------|
| 90-100 | A | Minor polish |
| 80-89 | B | Good, address specific issues |
| 70-79 | C | Needs improvement |
| 60-69 | D | Significant issues |
| <60 | F | Major redesign needed |

## Priority Weighting (Optional)

For overall project score, weight by screen importance:

| Screen Type | Weight |
|-------------|--------|
| Dashboard | 1.5x |
| Primary workflow | 1.3x |
| Settings | 0.8x |
| Edge cases | 0.5x |
