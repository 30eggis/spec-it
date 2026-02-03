# Design Context Integration

Load and use design system tokens for accurate wireframe generation.

**Reference:** `skills/shared/design-token-parser.md` for full parser spec.

## Supported Token Formats

| Format | Detection | Source |
|--------|-----------|--------|
| **Tokens Studio** | `"value"` + `"type"` | Figma Tokens |
| **Style Dictionary** | `"value"` only | Amazon |
| **DTCG (W3C)** | `"$value"` + `"$type"` | W3C draft |
| **Custom** | Nested JSON/YAML | Any |

## Loading Design Context

When `--designContext` parameter is provided:

```
designContextPath = args.designContext
DESIGN_CONTEXT_ENABLED = true

# Parse tokens (dynamic - any format)
tokenFile = Read(designContextPath)
format = detectTokenFormat(tokenFile)

# Flatten to path-based map
flatTokens = flattenTokenTree(tokenFile)
# → { "color.semantic.bg.brand.primary": { value: "#4D6BE2", type: "color" } }

# Resolve aliases
resolvedTokens = resolveAliases(flatTokens)

# Group by type
WIREFRAME_TOKEN_MAP = groupByType(resolvedTokens)

# Build reverse lookup
VALUE_LOOKUP = buildValueLookup(resolvedTokens)
```

## Token Reference Format

Use **full token path** as reference:

```yaml
# Dynamic paths from actual design system
background: "_ref:color.semantic.bg.brand.primary"
padding: "_ref:spacing.24"
border_radius: "_ref:radius.m"
typography: "_ref:typography.heading.m-bold"
```

## Auto-Matching Algorithm

```
function matchCssToToken(cssValue, tokenMap, valueLookup):
  # 1. Exact match via reverse lookup
  IF valueLookup[cssValue]:
    RETURN "_ref:" + valueLookup[cssValue]

  # 2. Color approximate match (delta < 10)
  IF isColor(cssValue):
    FOR path, token IN tokenMap.color:
      IF colorDistance(cssValue, token.value) < 10:
        RETURN "_ref:" + path

  # 3. Nearest numeric match for spacing
  IF isNumber(cssValue):
    nearestPath = findNearestSpacing(cssValue, tokenMap.spacing)
    RETURN "_ref:" + nearestPath

  # 4. No match
  LOG_WARNING("No token match: " + cssValue)
  RETURN cssValue
```

## Wireframe Generation Rules

When DESIGN_CONTEXT_ENABLED:

| Source Value | Wireframe Value |
|--------------|-----------------|
| `#4D6BE2` | `_ref:color.semantic.bg.brand.primary` |
| `16px` gap | `_ref:spacing.16` |
| `border-radius: 8px` | `_ref:radius.m` |

## Component Token Shortcuts

If design system has component-level tokens:

```yaml
props:
  background: "_ref:color.button.primary.background"
  text_color: "_ref:color.button.primary.text"
```
