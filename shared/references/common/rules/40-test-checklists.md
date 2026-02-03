# Test Checklists

Use these as minimum expectations when applying rules.

## TEST_COVERAGE_MIN_ROLE
- Role switcher restores persisted role and syncs.
- Sidebar filtering excludes restricted children.
- Empty roles list renders safely.

## TEST_COVERAGE_MEDIAQUERY
- SSR hydration has no mismatch warnings.
- Listener registration happens once per query.

## TEST_COVERAGE_BOUNDARIES
- Progress target 0/negative/NaN is safe.
- Percent clamped to 0..100 with correct aria values.

## TEST_COVERAGE_TIME
- start/end inversion produces safe output.
- Timezone boundary does not break duration.
- 59.6 minutes normalizes to valid hours/mins.

## TEST_COVERAGE_INTERVAL
- interval <= 0 rejected or clamped.
- No rapid loop or memory leak.
