# Roadmap

This document outlines the planned evolution of Anvil Plan Spec (APS).

## Current State (v0.1)

APS is a specification format for planning and task authorisation. It includes:

- **Templates** — Index, Leaf, Simple, Steps
- **Prompts** — Tool-agnostic and OpenCode variants
- **Examples** — User Auth, OpenCode Companion
- **Documentation** — Getting started guide, ADR template

## Near Term

### Validation Tooling

- [ ] CLI tool to validate APS documents against templates
- [ ] Check required fields are present
- [ ] Validate task ID format and dependencies
- [ ] Integrate with CI pipelines

### Additional Examples

- [ ] API migration example (multi-phase, high-risk)
- [ ] Greenfield project example (starting from scratch)
- [ ] Bug fix workflow example (small scope)

### Prompt Improvements

- [ ] Cursor/Copilot prompt variants
- [ ] Prompt for reviewing APS documents
- [ ] Prompt for estimating task confidence

## Medium Term

### Template Extensions

- [ ] Risk register template (standalone) //decision pending as this strays into PM territory.
- [ ] Decision log template (beyond ADRs)
- [ ] Retrospective template (post-completion) //decision pending as this strays into PM territory.

### Integration Patterns

- [ ] Guide for syncing APS with issue trackers
- [ ] Export formats (Markdown summary, JSON)
- [ ] Import from existing planning docs

## Long Term

### Ecosystem

- [ ] VS Code extension for APS authoring
- [ ] GitHub Action for APS validation
- [ ] Community template gallery

## Non-Goals

These are explicitly out of scope for APS:

- Runtime execution engines
- Project management tool integrations (Jira, Linear plugins) //final decision pending as this could be a good hand-off
- AI model training or fine-tuning
- Cloud-hosted services

## Contributing

Have ideas for the roadmap? Open an issue to discuss.
