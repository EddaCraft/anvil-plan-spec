# AGENTS.md — Anvil Collaboration Rules

This repo uses Anvil to improve trust in AI-assisted development.

## Core idea

Anvil is a trust broker between AI and humans. AI can propose and implement;
humans remain accountable.

## Execution authority

- **Specs describe intent.**
- **Tasks authorise execution.**
- If there is no task, do not implement changes unless explicitly instructed.

## AI anti-patterns

Do not introduce:

- broad eslint disables
- `any` type escapes
- unsafe casts
- "make it pass" hacks

If unavoidable:

1. add an inline note explaining why
2. record the same note in provenance metadata

See: [docs/ai/policies/ai-anti-patterns.md](docs/ai/policies/ai-anti-patterns.md)

## Architecture & boundaries

- Respect structural boundaries (layers, contexts, modules).
- Prefer public interfaces over reaching into internals.
- Warn on new boundary crossings, acknowledge existing drift.

See: [docs/ai/policies/architecture-and-boundaries.md](docs/ai/policies/architecture-and-boundaries.md)

## Risk acceptance

Approving exceptions or accepting risk is **human-only**.
AI may propose options and mitigations, but must not approve exceptions.

## Execution layer

- **Tasks** define outcomes (what to achieve)
- **Steps** define actions (what to do, not how)
- Steps live in `execution/[TASK-ID].steps.md` or `execution/[MODULE].steps.md`
- Each step has a checkpoint (observable completion state)

See: [docs/ai/prompting/steps.prompt.md](docs/ai/prompting/steps.prompt.md)

## Prompting entry points

Use:

- [docs/ai/prompting/index.prompt.md](docs/ai/prompting/index.prompt.md)
- [docs/ai/prompting/leaf.prompt.md](docs/ai/prompting/leaf.prompt.md)
- [docs/ai/prompting/task.prompt.md](docs/ai/prompting/task.prompt.md)
- [docs/ai/prompting/steps.prompt.md](docs/ai/prompting/steps.prompt.md)

OpenCode/Claude Opus variants:

- [docs/ai/prompting/opencode/](docs/ai/prompting/opencode/)

## Roles (conceptual)

- **Planner**: completes index/module docs, identifies decisions
- **Implementer**: executes one task at a time
- **Executor**: follows steps to complete tasks, validates checkpoints
- **Reviewer**: flags anti-patterns and boundary issues, suggests alternatives
- **Librarian**: updates ADR links/pattern references and keeps docs consistent
