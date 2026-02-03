# Context Synthesizer Guide

> Referenced by: context-synthesizer (exclusive)

## Purpose

Guide for generating `spec-map.md` by aggregating artifacts from phases P1, P2, P5, P6, P7, P8, P9.

---

## Input Sources

| Phase | Artifacts | Location |
|-------|-----------|----------|
| P1 | Requirements | `00-requirements/requirements.md` |
| P2 | Personas | `01-chapters/personas/*.md` |
| P5 | Critique Resolution | `critique-solve/*.md` |
| P6 | Chapter Plan | `01-chapters/chapter-plan-final.md` |
| P7 | Wireframes | `02-wireframes/**/*.yaml` |
| P8 | Component Inventory | `03-components/inventory.md` |
| P9 | Component Specs | `03-components/new/*.yaml` |

---

## Processing Steps

### Step 1: Index Requirements

```markdown
Read: 00-requirements/requirements.md

Extract:
- Section headers with line numbers
- User story IDs
- Functional requirement IDs
- Non-functional requirements
- MVP scope items
```

### Step 2: Catalog Personas

```markdown
Read: 01-chapters/personas/*.md

For each persona:
- ID
- Role
- Key scenarios (list)
- Associated screens
```

### Step 3: Map Chapters

```markdown
Read: 01-chapters/chapter-plan-final.md
Read: 01-chapters/decisions/*.md

For each chapter:
- Chapter ID
- File path
- Status (from critique resolution)
- Dependencies
```

### Step 4: Index Wireframes

```markdown
Scan: 02-wireframes/

Structure:
- By user type
  - By domain
    - Screen list
    - Individual wireframes

For each wireframe:
- Screen ID
- Title
- User type
- Domain
- File path
```

### Step 5: Catalog Components

```markdown
Read: 03-components/inventory.md
Read: 03-components/gap-analysis.md
Scan: 03-components/new/*.yaml

For each component:
- Name
- Category
- Status (new/existing/migrate)
- File path
- Priority
- Dependencies
```

### Step 6: Build Cross-References

```markdown
Component → Screen Usage:
- Parse wireframes for component references
- Build lookup table

Screen → Component Dependencies:
- Inverse of above

Persona → Screen Access:
- Parse persona definitions for screen lists
- Cross-reference with wireframe metadata
```

### Step 7: Generate Progressive Loading Guide

```markdown
Define context levels:

Minimal:
- spec-map.md only

Component Development:
- spec-map.md#components
- inventory.md
- specific component spec

Screen Implementation:
- spec-map.md#wireframes
- screen-list.md for domain
- specific wireframe

Full Context:
- requirements.md
- chapter-plan-final.md
- full spec-map.md
```

---

## Output Validation

### Required Sections

- [ ] Metadata with counts
- [ ] Quick navigation links
- [ ] Requirements index
- [ ] Personas catalog
- [ ] Chapters map
- [ ] Wireframes index
- [ ] Components catalog
- [ ] Cross-references
- [ ] Progressive loading guide

### Validation Checks

1. **File Existence**
   - All referenced files must exist
   - Paths must be relative to session root

2. **Line Count Accuracy**
   - Line ranges must be current
   - Update on regeneration

3. **Cross-Reference Integrity**
   - Bidirectional references complete
   - No orphaned artifacts

4. **Coverage**
   - All phases represented
   - No missing artifacts

---

## Incremental Updates

When updating spec-map.md after changes:

```
1. Identify changed artifacts
2. Update only affected sections
3. Revalidate cross-references
4. Update metadata counts
5. Regenerate progressive loading guide if structure changed
```

---

## Error Handling

| Error | Resolution |
|-------|------------|
| Missing file | Mark as "NOT FOUND" in spec-map |
| Empty directory | Note "No artifacts" |
| Parse error | Log warning, continue |
| Circular reference | Break cycle, warn |

---

## Performance Considerations

- Use glob patterns for bulk scanning
- Cache file metadata
- Lazy-load line counts
- Parallelize cross-reference building
