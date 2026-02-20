# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

## [0.2.0] - 2026-02-20

First release of Anvil Plan Spec (APS).

### Added

- **Templates** — Index, Module, Simple, Actions, and Quickstart templates in `templates/`
- **Scaffold** — One-command setup via `curl | bash` with `--update` support
- **Validation CLI** — `aps lint` command to validate APS documents with CI integration
- **Hooks system** — SessionStart, PreToolUse, PostToolUse, Stop hooks with install
  script and hook configuration
- **PowerShell port** — Full PS CLI (`aps.ps1`), scaffold module, all hook scripts
  ported to PS, one-liner PS install/update
- **CLI improvements** — `init` and `update` subcommands, improved validation rules
  (field checks, ID regex), issues tracker rule
- **Docs restructure** — Extracted installation guide, CLI usage guide, AI agent guide
  from README; README refocused as landing page
- **Prompts** — Tool-agnostic and OpenCode/Claude variants in `docs/ai/prompting/`
- **Examples** — User Authentication and OpenCode Companion worked examples
- **Planning specs** — v0.3 install and agents module specs (meta: APS plans its own
  development)
- **Documentation** — Getting started guide, workflow guide, ADR template, project structure
- **Roadmap** — Planned features and direction
- **Claude Code Tasks** — Integration guidance in aps-rules.md

### Changed

- Renamed "Leaf" template to "Module" for clarity
- Renamed "Steps" template to "Actions" for clarity
- Changed `SCOPE` placeholder to `ID` in templates to avoid confusion with In/Out Scope sections

### Documentation

- README with hierarchy diagram, quick start, and principles
- AGENTS.md with collaboration rules for AI contributors
- CONTRIBUTING.md with scope guardrails and PR process
- Getting started guide with decision tree
- Workflow guide with day-in-the-life scenarios
- Monorepo support guide
