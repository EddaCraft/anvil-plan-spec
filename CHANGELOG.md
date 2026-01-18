# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - Unreleased

Initial release of Anvil Plan Spec (APS).

### Added

- **CLI** — `npx anvil-plan-spec init` to scaffold APS in any project
- **Templates** — Index, Module, Simple, Actions, and Solution templates in `templates/`
- **Prompts** — Tool-agnostic and OpenCode/Claude variants in `docs/ai/prompting/`
- **Examples** — User Authentication and OpenCode Companion worked examples
- **Documentation** — Getting started guide, workflow guide, ADR template
- **CI/CD** — GitHub Actions for linting and npm publishing

### Documentation

- README with hierarchy diagram, quick start, and compound engineering philosophy
- AI Agent Implementation Guide for autonomous AI assistants
- AGENTS.md with collaboration rules for AI contributors
- CONTRIBUTING.md with scope guardrails and PR process
- Getting started guide with workflow decision tree

### Terminology

This release establishes the following terminology:

- **Work Item** — A single authorised change (formerly "Task")
- **Action Plan** — Ordered actions with checkpoints (formerly "Steps")
- **Module** — A bounded area of work (formerly "Leaf")
