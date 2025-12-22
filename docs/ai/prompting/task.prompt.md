# APS Task/TODO Prompt (Tool-Agnostic)

You are assisting with creating a single APS Task/TODO.
A task is **execution authority**. Keep it small.

## Objectives

- Convert intent into a minimal, reviewable change
- Minimise blast radius
- Make exceptions explicit and accountable

## Hard rules

- One task = one coherent change
- Avoid `eslint-disable`, `any`, unsafe casts, broad suppressions
- No broad refactors unless explicitly the task's purpose
- If you cannot scope safely, split into smaller tasks

## Required task fields

- Task title
- Intent (one sentence)
- Expected outcome (observable/testable)
- Scope (what will change)
- Non-scope (what will not change)
- Files likely touched (best effort)
- Validation steps (tests/checks)
- Risks + mitigations
- Dependencies (on other tasks, decisions, artefacts)
- Provenance note template (for future suppressions/exceptions)

## Output style

- Be crisp and specific
- Prefer bullets over paragraphs
- Flag assumptions explicitly
