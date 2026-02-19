# Compound Module

| ID | Owner | Status |
|----|-------|--------|
| COMPOUND | @aneki | Draft |

## Purpose

Support the Review/Learn phase of compound engineering by providing tooling for documenting solutions, extracting patterns, and making knowledge searchable across projects.

## In Scope

- Solution documentation workflow (using solution.template.md)
- Pattern extraction from repeated solutions
- Search across documented solutions
- Integration with planning workflow (referencing past solutions)

## Out of Scope

- AI-powered solution suggestion (too complex for v1)
- Cross-organization knowledge sharing
- Hosted solution registry

## Interfaces

**Depends on:**

- TPL (templates) — uses solution.template.md
- DOCS — workflow guidance references compound phase

**Exposes:**

- `aps review` — CLI command to start review workflow
- docs/solutions/ — standardized solution structure

## Ready Checklist

- [x] Purpose and scope are clear
- [x] Dependencies identified
- [ ] At least one work item defined

## Work Items

*Define work items when promoting to Ready*

## Notes

- solution.template.md already exists in templates/
- Key insight: "After documenting 3+ similar issues, extract a pattern"
- Consider: CLI to scaffold solution doc, search solutions, suggest patterns
