# APS v0.2 — Usability & Adoption

| Field | Value |
|-------|-------|
| Status | Draft |
| Owner | @aneki |
| Created | 2025-12-31 |

## Problem

APS has strong foundations but adoption barriers prevent new users from getting value quickly:

1. **High activation energy** — Users need hours to understand before first use
2. **Agent guidance gap** — AI agents don't follow APS conventions without explicit prompting
3. **Missing workflow integration** — Unclear how APS fits into daily development

The usability review (APS-USABILITY-REVIEW.md) identified 15 issues across documentation, templates, and workflows. This plan addresses the high-impact items.

## Success Criteria

- [ ] New user can try APS in under 5 minutes (quickstart path)
- [ ] Scaffold copies templates + agent guidance into target repo
- [ ] Agents naturally follow lean-step conventions when aps-rules.md is present
- [ ] Documentation has clear "Day in the Life" workflow example

## Constraints

- No runtime dependencies — APS remains pure markdown
- No breaking changes to existing template structure
- Changes must pass markdownlint

## Modules

| Module | Purpose | Status | Dependencies |
|--------|---------|--------|--------------|
| [scaffold](./modules/scaffold.aps.md) | One-command setup for new projects | Complete | — |
| [templates](./modules/templates.aps.md) | Reduce friction, mark optional fields | Complete | — |
| [docs](./modules/docs.aps.md) | Workflow guide, improved onboarding | Complete | templates |
| [validation](./modules/validation.aps.md) | CLI tool to validate APS documents | Ready | templates |

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Template changes break existing specs | High | Keep field names stable, only add optional markers |
| Agents ignore aps-rules.md | Medium | Test with multiple AI tools, iterate on wording |
| Scope creep into PM territory | Medium | Maintain non-goals list, reject feature requests outside scope |

## Open Questions

- [ ] Should quickstart.template.md be the default entry point in README?
- [ ] Do we need tool-specific prompt variants (Cursor, Copilot) or is generic sufficient?
- [ ] Should validation be a standalone CLI or a GitHub Action first?

## Decisions

- **D-001:** Rename "Leaf" to "Module" — *decided: yes, improves clarity*
- **D-002:** Use `ID` instead of `SCOPE` in templates — *decided: yes, less confusing*
- **D-003:** Add aps-rules.md as portable agent guide — *decided: yes, travels with templates*
