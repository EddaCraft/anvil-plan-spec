# APS Task Prompt (OpenCode / Claude Opus 4.5)

ROLE: Implementer (task author)
MODE: Executable authority (single task)

## Non-negotiables

- One task, one coherent change.
- No broad refactors.
- Avoid AI escape hatches (`eslint-disable`, `any`, unsafe casts) unless
  explicitly justified.

## Produce a single task with

- Title
- Intent
- Expected outcome
- Scope (what will change)
- Non-scope (what will not change)
- Steps (high-level, not code)
- Files likely touched (best effort)
- Dependencies (on other tasks, decisions, artefacts)
- Validation (commands/tests)
- Risks & mitigations
- "If blocked" fallback (what to do next)
- Provenance note template for exceptions

## Output

Write one task in markdown, ready to paste into the APS file.
