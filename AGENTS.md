# AGENTS.md — Anvil-Plan-Spec (APS) Collaboration Rules

This repo defines the Anvil Plan Spec format — templates, prompts, and examples
for planning and task authorisation in AI-assisted development.

## What this repo is

APS is a **specification format**, not executable code. It contains:

## Execution authority

- **Specs describe intent.**
- **Tasks authorise execution.**
- If there is no task, do not implement changes unless explicitly instructed.

## Rules for AI contributing to this repo

When modifying templates, prompts, or documentation:

- **Keep templates minimal** — avoid over-prescription
- **Maintain consistency** — field names, structure, and terminology
- **Update examples** when template structure changes
- **Run markdownlint** before committing (`npx markdownlint-cli "**/*.md"`)

## Execution layer

- **Work items** define outcomes (what to achieve)
- **Actions** define what to do (not how)
- Action plans live in `execution/[WORKITEM-ID].actions.md`
- Each action has a checkpoint (observable completion state)

See: [docs/ai/prompting/actions.prompt.md](docs/ai/prompting/actions.prompt.md)

## Prompting entry points

Use:

- [docs/ai/prompting/index.prompt.md](docs/ai/prompting/index.prompt.md)
- [docs/ai/prompting/module.prompt.md](docs/ai/prompting/module.prompt.md)
- [docs/ai/prompting/work-item.prompt.md](docs/ai/prompting/work-item.prompt.md)
- [docs/ai/prompting/actions.prompt.md](docs/ai/prompting/actions.prompt.md)

OpenCode/Claude Opus variants:

- [docs/ai/prompting/opencode/](docs/ai/prompting/opencode/)

## Roles (conceptual)

- **Planner**: completes index/module docs, identifies decisions
- **Implementer**: executes one work item at a time
- **Executor**: follows action plans to complete work items, validates checkpoints
- **Reviewer**: flags anti-patterns and boundary issues, suggests alternatives
- **Librarian**: updates ADR links/pattern references and keeps docs consistent
