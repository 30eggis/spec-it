# Design Token Parser

Dynamic parser for design tokens supporting multiple formats:
- **Tokens Studio (Figma Tokens)** - Most common
- **Style Dictionary** - Amazon format
- **Design Token Community Group (DTCG)** - W3C draft standard
- **Custom formats** - Any nested JSON/YAML

## Supported Token Formats

### 1. Tokens Studio / Figma Tokens

```json
{
  "color": {
    "primitive": {
      "blue": {
        "50": { "value": "#2449DB", "type": "color" }
      }
    },
    "semantic": {
      "bg": {
        "brand": {
          "primary": { "value": "{color.primitive.blue.40}", "type": "color" }
        }
      }
    }
  }
}
```

**Characteristics:**
- Nested objects with `value` and `type` fields
- Alias references: `{color.primitive.blue.40}`
- Groups: primitive, semantic, component

### 2. Style Dictionary

```json
{
  "color": {
    "brand": {
      "primary": { "value": "#2449DB" }
    }
  }
}
```

**Characteristics:**
- Simpler structure
- CTI (Category/Type/Item) naming

### 3. DTCG (W3C Draft)

```json
{
  "color": {
    "brand": {
      "primary": {
        "$value": "#2449DB",
        "$type": "color",
        "$description": "Primary brand color"
      }
    }
  }
}
```

**Characteristics:**
- `$` prefix for meta fields
- `$value`, `$type`, `$description`

---

## Parser Algorithm

### Step 1: Detect Format

```
function detectFormat(tokenFile):
  IF has "$value" fields → DTCG
  IF has "value" + "type" fields → Tokens Studio
  IF has "value" only → Style Dictionary
  ELSE → Custom (treat as Tokens Studio)
```

### Step 2: Flatten Token Tree

Convert nested structure to flat path-based map:

```
Input:
{
  "color": {
    "semantic": {
      "bg": {
        "brand": {
          "primary": { "value": "#4D6BE2", "type": "color" }
        }
      }
    }
  }
}

Output:
{
  "color.semantic.bg.brand.primary": {
    "value": "#4D6BE2",
    "type": "color",
    "path": ["color", "semantic", "bg", "brand", "primary"]
  }
}
```

### Step 3: Resolve Aliases

```
Input:
{
  "color.semantic.bg.brand.primary": {
    "value": "{color.primitive.blue.40}",
    "type": "color"
  }
}

Output:
{
  "color.semantic.bg.brand.primary": {
    "value": "#4D6BE2",           // Resolved
    "rawValue": "{color.primitive.blue.40}",
    "type": "color"
  }
}
```

### Step 4: Group by Type

```
{
  "color": {
    "color.semantic.bg.brand.primary": "#4D6BE2",
    "color.primitive.blue.50": "#2449DB",
    ...
  },
  "spacing": {
    "spacing.4": 4,
    "spacing.8": 8,
    "spacing.tree-level.level1": 8,
    ...
  },
  "typography": {
    "typography.heading.m-bold": {
      "fontFamily": "Noto Sans",
      "fontSize": 18,
      "fontWeight": 700,
      "lineHeight": 24
    }
  }
}
```

---

## Wireframe Token Reference

### Reference Format

Use full path as token reference:

```yaml
# Instead of:
background: "_ref:colors.primary"

# Use:
background: "_ref:color.semantic.bg.brand.primary"
```

### Auto-Mapping Algorithm

When analyzing source HTML/CSS, find closest matching token:

```
function findClosestToken(cssValue, tokenMap):
  # 1. Exact match
  FOR token IN tokenMap.values:
    IF token.value == cssValue:
      RETURN token.path

  # 2. Approximate color match (within delta)
  IF isColor(cssValue):
    FOR token IN tokenMap.colors:
      IF colorDistance(cssValue, token.value) < 10:
        RETURN token.path

  # 3. Nearest numeric match (for spacing)
  IF isNumber(cssValue):
    RETURN findNearestValue(cssValue, tokenMap.spacing)

  # 4. No match - return raw value with warning
  LOG_WARNING("No token match for: " + cssValue)
  RETURN cssValue
```

---

## Output: design-context.yaml

Dynamic structure based on parsed tokens:

```yaml
meta:
  source: "/path/to/design-tokens.json"
  format: "tokens-studio"
  loadedAt: "2026-02-03T14:30:00Z"
  tokenCount: 156

# Flattened tokens grouped by type
tokens:
  color:
    "color.primitive.blue.50":
      value: "#2449DB"
      type: color
    "color.semantic.bg.brand.primary":
      value: "#4D6BE2"
      type: color
      alias: "color.primitive.blue.40"
    "color.semantic.bg.brand.primary-disabled":
      value: "#A7B6F1"
      type: color
    # ... all colors

  spacing:
    "spacing.4":
      value: 4
      type: spacing
      unit: px
    "spacing.tree-level.level1":
      value: 8
      type: spacing
      unit: px
    # ... all spacing

  typography:
    "typography.heading.m-bold":
      fontFamily: "Noto Sans"
      fontSize: 18
      fontWeight: 700
      lineHeight: 24
      type: typography
    # ... all typography

  radius:
    "radius.s":
      value: 4
      type: borderRadius
      unit: px
    # ... all radius

  shadow:
    "elevation.1":
      value: "..."
      type: boxShadow
      description: "Small modal like dropdown menu"
    # ... all shadows

# Reverse lookup: value → token path
valueLookup:
  "#4D6BE2": "color.semantic.bg.brand.primary"
  "#2449DB": "color.primitive.blue.50"
  "4": "spacing.4"
  "8": ["spacing.8", "spacing.tree-level.level1"]
  # ... for quick matching

# Component token shortcuts (if available)
componentTokens:
  button:
    primary:
      background: "color.button.primary.background"
      text: "color.button.primary.text"
  chip:
    selected:
      background: "color.chip.selected.background"
```

---

## Usage in Wireframe

```yaml
# Wireframe example using parsed tokens
sections:
  - id: "header"
    layout:
      background: "_ref:color.semantic.bg.neutral.primary"
      padding: "_ref:spacing.24"
      border_radius: "_ref:radius.m"
    children:
      - id: "title"
        type: "Text"
        props:
          typography: "_ref:typography.heading.m-bold"
          color: "_ref:color.semantic.text.neutral.primary"

      - id: "action_btn"
        type: "Button"
        props:
          background: "_ref:color.button.primary.background"
          text_color: "_ref:color.button.primary.text"
```

---

## Integration Points

### 1. spec-it-mock

```
# Load any format
tokenFile = user provided path
parsedTokens = parseDesignTokens(tokenFile)
Write: design-context.yaml (dynamic structure)
```

### 2. hack-2-spec

```
# Match CSS values to tokens
extractedColor = "#4D6BE2"
tokenRef = findClosestToken(extractedColor, parsedTokens)
# → "_ref:color.semantic.bg.brand.primary"
```

### 3. spec-it-execute

```
# Generate code with token references
Read: design-context.yaml
FOR each _ref in wireframe:
  resolvedValue = lookupToken(ref)
  # Generate CSS variable or direct value
```

---

## Supported Token Types

| Type | Fields | Example |
|------|--------|---------|
| `color` | value | `#4D6BE2`, `rgba(0,0,0,0.5)` |
| `spacing` | value, unit | `16`, `px` |
| `borderRadius` | value, unit | `8`, `px` |
| `borderWidth` | value, unit | `1`, `px` |
| `boxShadow` | value | `0 4px 6px rgba(0,0,0,0.1)` |
| `typography` | fontFamily, fontSize, fontWeight, lineHeight, letterSpacing | composite |
| `fontFamily` | value | `"Noto Sans"` |
| `fontSize` | value, unit | `16`, `px` |
| `fontWeight` | value | `700` |
| `lineHeight` | value | `24` or `1.5` |
| `opacity` | value | `0.5` |
| `sizing` | value, unit | `360`, `px` |
| `duration` | value, unit | `200`, `ms` |
| `cubicBezier` | value | `[0.4, 0, 0.2, 1]` |
