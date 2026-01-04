# Roadmap

This document outlines the planned evolution of Anvil Plan Spec (APS).

## Current State

APS is a specification format for planning and task authorisation in AI-assisted
development. The format is stable and ready for use.

### Core Templates

| Template | Purpose |
|----------|---------|
| **Quickstart** | Try APS in 5 minutes — minimal single-file format |
| **Index** | Root plan with modules and milestones |
| **Index (Expanded)** | Larger initiatives with 6+ modules |
| **Module** | Bounded scope with interfaces and tasks |
| **Simple** | Small, self-contained features |
| **Steps** | Breaking tasks into executable checkpoints |

### Tooling

- **Scaffold script** — `./scaffold/init.sh` bootstraps APS into any project
  - Creates `plans/` directory structure with templates
  - Includes `aps-rules.md` for AI agent guidance
  - Update mode (`--update`) refreshes templates without overwriting specs
  - Works via local clone or `curl` from GitHub

### AI Integration

- **Prompts** — Tool-agnostic guidance in `docs/ai/prompting/`
- **OpenCode variants** — Optimised prompts for Claude Code / OpenCode
- **AGENTS.md** — Collaboration rules for AI contributors to this repo
- **aps-rules.md** — Portable agent guidance that travels with your specs

### Examples

- **User Authentication** — Adding auth to an existing app (multi-module)
- **OpenCode Companion** — Building a companion tool (greenfield)

### Documentation

- Getting started guide with workflow decision tree
- ADR template for architectural decisions
- Contributing guide with scope guardrails

## Near Term

### Validation

- [ ] CLI tool to lint APS documents (`aps lint`)
- [ ] Validate required fields and task dependencies
- [ ] Check checkpoint format in step files
- [ ] CI-friendly exit codes

### Additional Examples

- [ ] API migration (multi-phase, higher-risk work)
- [ ] Bug fix workflow (minimal scope, fast iteration)
- [ ] Monorepo setup (multiple index files)

### Prompt Coverage

- [ ] Cursor / Copilot prompt variants
- [ ] Prompt for reviewing specs before approval
- [ ] Prompt for generating steps from tasks

## Medium Term

### Template Refinements

- [ ] Decision log template (lightweight alternative to ADRs)
- [ ] Dependency visualization guidance
- [ ] Cross-module interface patterns

### Integration Guides

- [ ] Syncing APS with issue trackers (GitHub Issues, Linear, Jira)
- [ ] Export to JSON for tooling integration
- [ ] Embedding specs in PRs and code review workflows

## Long Term

### Ecosystem

- [ ] GitHub Action for APS validation in CI
- [ ] VS Code extension for authoring and navigation
- [ ] Community template gallery

### Specification

- [ ] Formal spec versioning (once patterns stabilize)
- [ ] Machine-readable schema (JSON Schema or similar)

## Non-Goals

These are explicitly out of scope for APS:

- **Execution engines** — APS describes intent; it doesn't run code
- **Vendor plugins** — No Jira/Linear/Notion plugins (specs are portable markdown)
- **AI training** — Not a dataset for model fine-tuning
- **Hosted services** — No cloud component; everything runs locally

## Contributing

Have ideas for the roadmap? [Open an issue](https://github.com/EddaCraft/anvil-plan-spec/issues) to discuss.
