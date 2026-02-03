# UI Measurement, SSR, and Time Rules

## DOM_MEASURE_RESYNC
Applies to: UI that measures DOM to position indicators.
Criteria:
- Recompute on resize, font load, content change.
- Use ResizeObserver or equivalent.
Failure conditions:
- Indicator misaligned after layout changes.
- Measurement is only performed once.
Test checklist:
- Resize container and change font size.
- Verify indicator stays aligned.

## REF_CLEANUP
Applies to: dynamic lists with refs or maps.
Criteria:
- Clean refs when list items are removed.
- Prevent stale references from accumulating.
Failure conditions:
- Map grows over time without cleanup.
- Ref points to unmounted element.
Test checklist:
- Change list length.
- Verify ref map size matches items.

## SSR_SAFE_MEDIAQUERY
Applies to: media query hooks and SSR rendering.
Criteria:
- Avoid hydration mismatch by stable initial value.
- Do not re-register listeners on every state change.
Failure conditions:
- Hydration warnings on first render.
- Listener adds/removes on each change.
Test checklist:
- SSR render + hydrate.
- Verify no warnings and stable value after mount.

## TIME_CALC_SAFE
Applies to: time math, durations, scheduling.
Criteria:
- Use timezone-safe parsing.
- Guard start/end inversion and invalid dates.
Failure conditions:
- Negative or NaN durations.
- Timezone shift causes wrong result.
Test checklist:
- Cross-day and timezone edge cases.
- Start after end.

## FORMAT_DURATION_SAFE
Applies to: duration formatting and rounding.
Criteria:
- Prevent "1h 60m" and similar artifacts.
- Normalize minutes to 0..59 after rounding.
Failure conditions:
- UI shows invalid duration format.
Test checklist:
- 59.6 minutes and 119.6 minutes.
- Verify normalized output.
