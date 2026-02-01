# Core Safety Rules

Rule format:
- Keyword
- Applies to
- Criteria
- Failure conditions
- Test checklist

## BOUNDARY_GUARD
Applies to: any numeric input, props, API data, computed values.
Criteria:
- Guard against 0/negative/NaN/undefined before calculations.
- Provide safe fallback values for UI and logic.
Failure conditions:
- Division by 0 or NaN reaches UI or state.
- Unhandled undefined/empty data causes crash or invalid styles.
Test checklist:
- Inputs: 0, negative, undefined, NaN.
- Ensure render does not crash and outputs safe defaults.

## CLAMP_RANGE
Applies to: percentages, ratios, progress, width/height.
Criteria:
- Clamp computed values to expected range (typically 0..100).
- Ensure aria values reflect clamped result.
Failure conditions:
- Percent > 100 or < 0 reaches UI.
- aria-valuenow is invalid or mismatched with visuals.
Test checklist:
- Inputs outside range: -1, 101, Infinity.
- Verify style + aria values are consistent.

## EMPTY_COLLECTION_SAFE
Applies to: calculations using length, index, modulo.
Criteria:
- Check empty arrays before using length-based math.
- Provide a no-op or fallback UI.
Failure conditions:
- Divide/modulo by 0 or invalid array access.
- UI uses missing config entries.
Test checklist:
- Available list is empty.
- Ensure no errors and no invalid UI state.

## ACCESSIBILITY_SAFE
Applies to: aria attributes, roles, interactive UI.
Criteria:
- Aria values are valid type and within bounds.
- Interactive elements have consistent focus/label states.
Failure conditions:
- aria attributes get NaN/Infinity.
- Focus or label states mismatched with actual UI.
Test checklist:
- Validate aria-valuenow/aria-valuemax on edge inputs.
- Keyboard focus path works.

## INTERVAL_GUARD
Applies to: timers, polling, intervals.
Criteria:
- Reject interval <= 0.
- Enforce sane lower bound (e.g. >= 100ms).
Failure conditions:
- 0/negative intervals create tight loops.
- Re-render loop or CPU spike.
Test checklist:
- Interval 0, negative, and very small values.
- Verify no rapid loop or memory leak.
