# Phase 3: hack-2-spec Integration

## Step 3.1: Determine Target Type

```
IF targetPath starts with "http://" OR "https://":
  targetType = "website"
ELSE IF targetPath is directory:
  targetType = "codebase"
ELSE:
  targetType = "file"
```

## Step 3.2: Invoke hack-2-spec

```
Skill(hack-2-spec, {
  source: targetPath,
  sourceType: targetType,
  outputDir: "${SESSION_DIR}/plan/tmp",
  designContext: "${SESSION_DIR}/plan/design-context.yaml"
})
```

## Step 3.3: Token Matching in Wireframes

hack-2-spec uses `designContext` to match CSS values to tokens:

```yaml
# Source CSS: background: #4D6BE2
# Generated wireframe:
layout:
  background: "_ref:color.semantic.bg.brand.primary"

# Source CSS: padding: 16px
# Generated wireframe:
layout:
  padding: "_ref:spacing.16"
```

## Step 3.4: Verify Token Coverage

```
FOR each wireframe in tmp/02-wireframes/**/*.yaml:
  unmatchedValues = findRawValues(wireframe)
  IF unmatchedValues.length > 0:
    LOG_WARNING("Unmatched values: " + unmatchedValues)
```
