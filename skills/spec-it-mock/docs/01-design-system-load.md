# Phase 2: Load Design System

**Reference:** `skills/shared/design-token-parser.md` for full parser spec.

## Supported Token Formats

| Format | Detection | Source |
|--------|-----------|--------|
| **Tokens Studio** | `"value"` + `"type"` | Figma Tokens |
| **Style Dictionary** | `"value"` only | Amazon |
| **DTCG (W3C)** | `"$value"` + `"$type"` | W3C draft |
| **Custom** | Nested JSON/YAML | Any |

## Step 2.1: Determine Source

```
IF designSystemPath == "Built-in (2026 Trends)":
  DESIGN_SYSTEM_PATH = "skills/design-trends-2026/tokens"
ELSE:
  DESIGN_SYSTEM_PATH = user's custom path
```

## Step 2.2: Parse Tokens

```
tokenFiles = Glob(DESIGN_SYSTEM_PATH + "/**/*.{json,yaml}")

FOR file IN tokenFiles:
  format = detectTokenFormat(file)
  tokens = parseTokenFile(file, format)
  mergedTokens = merge(mergedTokens, tokens)

# Flatten nested structure
flatTokens = flattenTokenTree(mergedTokens)
# → { "color.semantic.bg.brand.primary": { value: "#4D6BE2", type: "color" } }

# Resolve aliases
resolvedTokens = resolveAliases(flatTokens)

# Group by type
groupedTokens = groupByType(resolvedTokens)

# Build reverse lookup
valueLookup = buildValueLookup(resolvedTokens)
```

## Step 2.3: Create design-context.yaml

```yaml
meta:
  source: "${DESIGN_SYSTEM_PATH}"
  format: "${detectedFormat}"
  loadedAt: "$(date -Iseconds)"
  tokenCount: ${totalTokenCount}

tokens:
  color:
    "color.semantic.bg.brand.primary":
      value: "#4D6BE2"
      type: color
    # ... all colors

  spacing:
    "spacing.16":
      value: 16
      type: spacing
      unit: px
    # ... all spacing

  typography:
    "typography.heading.m-bold":
      fontFamily: "Noto Sans"
      fontSize: 18
      fontWeight: 700
      lineHeight: 24
    # ... all typography

  radius: { ... }
  shadow: { ... }

valueLookup:
  "#4D6BE2": "color.semantic.bg.brand.primary"
  "16": "spacing.16"
  # ...

componentTokens:
  button:
    primary:
      background: "color.button.primary.background"
      text: "color.button.primary.text"
```
