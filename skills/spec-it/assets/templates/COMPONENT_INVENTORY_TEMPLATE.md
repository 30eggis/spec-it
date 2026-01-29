# Component Inventory

## Summary

| Category | Count | Location |
|----------|-------|----------|
| Common | {{common_count}} | src/components/common/ |
| UI (shadcn) | {{ui_count}} | src/components/ui/ |
| Feature | {{feature_count}} | src/components/features/ |
| Local | {{local_count}} | src/app/**/components/ |
| **Total** | **{{total_count}}** | |

## Common Components

| Component | Props | Usage | Status |
|-----------|-------|-------|--------|
{{#each common_components}}
| {{name}} | {{props}} | {{usage_count}} files | {{status}} |
{{/each}}

## UI Components (shadcn)

| Component | Customization | Usage |
|-----------|---------------|-------|
{{#each ui_components}}
| {{name}} | {{customized}} | {{usage_count}} files |
{{/each}}

## Feature Components

| Component | Feature | Usage |
|-----------|---------|-------|
{{#each feature_components}}
| {{name}} | {{feature}} | {{usage_count}} files |
{{/each}}

## Local Components

| Component | Current Location | Usage | Migration Recommendation |
|-----------|------------------|-------|--------------------------|
{{#each local_components}}
| {{name}} | {{location}} | {{usage_count}} files | {{migration_recommendation}} |
{{/each}}

## Migration Candidates

Local components used in other locations:

{{#each migration_candidates}}
### {{name}}
- **Current Location**: {{location}}
- **Usage Locations**: {{usage_locations}}
- **Recommendation**: → {{recommended_location}}
- **Reason**: {{reason}}
{{/each}}

## Unused Components

{{#each unused_components}}
- {{name}} ({{location}})
{{/each}}
