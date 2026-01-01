# APS Cross-Tool Plugin Architecture

| Field | Value |
|-------|-------|
| Status | Draft |
| Owner | @EddaCraft |
| Created | 2026-01-01 |

## Problem

APS is currently template-only (markdown files). To become a default planning tool for AI coding assistants like oh-my-opencode (OMO), we need programmatic integration across multiple tools (OpenCode, Claude Code, Cursor, Aider).

Creating tool-specific implementations would duplicate logic and create maintenance burden. We need a core library with thin tool-specific adapters.

## Success Criteria

**Foundation:**
- [ ] Core APS library (`@aps/core`) published to npm
- [ ] CLI tool (`@aps/cli`) works standalone with validation/scaffolding

**Full Plugin Path:**
- [ ] Claude Code plugin (`aps-claude-code-plugin`) published to marketplace
- [ ] OpenCode plugin (`opencode-planspec`) installable via npm

**Lightweight Generator Path:**
- [ ] `aps generate skill <tool>` creates working skills for Claude Code, OpenCode, Cursor, Aider
- [ ] `aps generate command <tool>` creates slash commands
- [ ] Generated files work immediately in respective tools

**Distribution & Adoption:**
- [ ] At least 3 tools can use APS (via plugins OR generators)
- [ ] OMO documentation references APS as recommended planning layer
- [ ] Community examples showing both integration approaches

## Constraints

- Must maintain APS's tool-agnostic philosophy
- Templates remain human-readable markdown (no proprietary formats)
- Core library has zero AI tool dependencies
- Backward compatible with existing APS markdown files

## Modules

| Module | Purpose | Status | Dependencies |
|--------|---------|--------|--------------|
| [core](./modules/core.aps.md) | Core APS validation, parsing, scaffolding | Draft | — |
| [cli](./modules/cli.aps.md) | Standalone CLI wrapping @aps/core | Draft | core |
| [generators](./modules/generators.aps.md) | Generate skills/commands for any tool (lightweight path) | Draft | core, cli |
| [claude-code-plugin](./modules/claude-code-plugin.aps.md) | Full Claude Code plugin (full-featured path) | Draft | core, cli |
| [opencode-plugin](./modules/opencode-plugin.aps.md) | Full OpenCode plugin (full-featured path) | Draft | core, cli |
| [omo-integration](./modules/omo-integration.aps.md) | oh-my-opencode partnership & distribution | Draft | opencode-plugin |

## Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Core library API changes break adapters | High | Semantic versioning, adapter tests in CI |
| Tools evolve their plugin APIs | Medium | Keep adapters thin, easy to update |
| npm package namespace conflict | Low | Check availability early, reserve names |
| OMO maintainer not interested | Medium | Plugin works standalone, OMO optional |

## Open Questions

- [ ] Should core library be TypeScript or tool-agnostic (e.g., Rust)?
- [ ] Do we need a JSON schema alongside markdown templates?
- [ ] Should CLI auto-update skills when templates change?
- [ ] How do we handle versioning across core + plugins?

## Decisions

- **D-001:** Use monorepo for core + plugins — *pending*
- **D-002:** TypeScript for initial implementation (can port later) — *pending*
- **D-003:** Publish to npm under `@aps/*` namespace — *pending*
