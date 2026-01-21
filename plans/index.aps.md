# APS Roadmap

| Field | Value |
|-------|-------|
| Status | Active |
| Owner | @aneki |
| Created | 2025-12-31 |
| Updated | 2026-01-21 |

## Problem

APS needs continued development to:

1. **Lower adoption barriers** — New users should get value in minutes, not hours
2. **Improve tooling** — Validation, search, and integration with existing workflows
3. **Build ecosystem** — Examples, templates, and community contributions

## Success Criteria

- [ ] New user can try APS in under 5 minutes
- [ ] CLI validates APS documents in CI pipelines
- [ ] Documentation covers common workflows with examples
- [ ] Knowledge compounds across projects via solution library

## Constraints

- No runtime dependencies — APS remains pure markdown
- No vendor lock-in — Specs stay portable across tools
- No breaking changes without migration path

## Modules

### Current (v0.2 — Usability)

| Module | Purpose | Status |
|--------|---------|--------|
| [scaffold](./modules/scaffold.aps.md) | One-command setup for new projects | Ready |
| [templates](./modules/templates.aps.md) | Reduce friction, mark optional fields | Complete |
| [docs](./modules/docs.aps.md) | Workflow guide, improved onboarding | Complete |
| [validation](./modules/validation.aps.md) | CLI tool to validate APS documents | Ready |

### Near Term

| Module | Purpose | Status |
|--------|---------|--------|
| [examples](./modules/examples.aps.md) | Additional worked examples | Draft |
| [prompts](./modules/prompts.aps.md) | Tool-specific prompt variants | Draft |
| [compound](./modules/compound.aps.md) | Review/Learn phase tooling | Draft |
| [integrations](./modules/integrations.aps.md) | JSON export, GitHub sync | Draft |

### Long Term

| Module | Purpose | Status |
|--------|---------|--------|
| ecosystem | GitHub Action, VS Code extension | Proposed |
| spec | Formal versioning, JSON Schema | Proposed |

## Non-Goals

These are explicitly out of scope:

- **Execution engines** — APS describes intent; it doesn't run code
- **Vendor plugins** — No Jira/Linear/Notion plugins (specs are portable markdown)
- **AI training** — Not a dataset for model fine-tuning
- **Hosted services** — No cloud component; everything runs locally

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Scope creep into PM territory | High | Maintain non-goals, reject out-of-scope requests |
| Template changes break existing specs | Medium | Keep field names stable, add optional markers |
| Tooling complexity undermines simplicity | Medium | CLI stays optional; markdown-first always |

## Decisions

- **D-001:** Rename "Leaf" to "Module" — *decided: yes, improves clarity*
- **D-002:** Use `ID` instead of `SCOPE` in templates — *decided: yes, less confusing*
- **D-003:** Add aps-rules.md as portable agent guide — *decided: yes, travels with templates*
- **D-004:** Adopt compound engineering philosophy — *decided: yes, planning lifecycle*
- **D-005:** Quickstart as default entry point — *decided: no, keep template choices*
- **D-006:** Tool-specific prompt variants — *decided: yes, need variants or stubs pointing to generic AGENTS.md*
- **D-007:** Validation approach — *decided: standalone CLI first, then GitHub Action wrapper*
- **D-008:** Solution docs organization — *decided: per-project with monorepo support*
- **D-009:** npm init module — *decided: merged into scaffold module, no separate npm package*
