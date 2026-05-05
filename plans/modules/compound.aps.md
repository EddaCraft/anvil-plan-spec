# Compound Module

| ID       | Owner  | Priority | Status |
| -------- | ------ | -------- | ------ |
| COMPOUND | @aneki | medium   | Draft  |

## Purpose

Capture reusable learnings from completed APS work so knowledge compounds
across projects instead of staying buried in one-off plans.

## In Scope

- Solution document template
- Review/Learn phase guidance
- Linking completed work items to reusable decisions, patterns, or solutions
- Repository-local solution library conventions

## Out of Scope

- Hosted knowledge base
- AI model training datasets
- Automatic semantic search

## Interfaces

**Depends on:**

- ORCH — optional learning capture may feed this module later

**Exposes:**

- `templates/solution.template.md`
- `plans/decisions/`
- Future solution-library documentation

## Work Items

### COMPOUND-001: Define solution library workflow — Draft

- **Intent:** Make post-work learning capture repeatable
- **Expected Outcome:** Documentation explains when to create a solution doc,
  how to link it from modules/work items, and how to avoid duplicating ADRs.
- **Validation:** Apply workflow to one completed APS repo change and link it
  from the relevant module
- **Files:** templates/solution.template.md, docs/workflow.md, plans/decisions/
- **Confidence:** medium
