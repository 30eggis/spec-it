# Chapter Plan - Final

## Validation Summary

| Step | Agent | Result | Issues |
|------|-------|--------|--------|
| Divergent | divergent-thinker | {{ALTERNATIVES_COUNT}} alternatives | {{ALTERNATIVES_LIST}} |
| Critique 1 | critic (logic) | {{CRITIQUE1_RESULT}} | {{CRITIQUE1_ISSUES}} |
| Critique 2 | critic (feasibility) | {{CRITIQUE2_RESULT}} | {{CRITIQUE2_ISSUES}} |
| Critique 3 | critic (frontend) | {{CRITIQUE3_RESULT}} | {{CRITIQUE3_ISSUES}} |
| Planning | planner | {{PLANNING_RESULT}} | {{TOTAL_CHAPTERS}} chapters |

## Final Chapter Structure

{{#each chapters}}
### {{chapter_id}}: {{chapter_name}}
- **Purpose**: {{purpose}}
- **Expected Questions**: {{question_count}}
- **Deliverable**: `{{output_file}}`
- **Completion Criteria**: {{completion_criteria}}
{{#if dependencies}}
- **Dependencies**: {{dependencies}}
{{/if}}

{{/each}}

## Dependency Graph

```
{{dependency_graph}}
```

## Estimated Effort

- Total chapters: {{total_chapters}}
- Expected total questions: {{min_questions}}-{{max_questions}}
- Feature subchapters: {{feature_subchapters}}
