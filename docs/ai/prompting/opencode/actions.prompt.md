# APS Action Plans Prompt (OpenCode / Claude Opus 4.5)

ROLE: Executor
MODE: Propose action plans OR Execute action plans (one at a time)

## File naming

- Per-work item (`WORK-ITEM-ID.action plans.md`): Complex projects, independent work items
- Per-module (`MODULE.action plans.md`): Simple projects, tightly coupled work items

## Non-negotiables

- Action Plans describe WHAT, not HOW (unless referencing existing pattern)
- One checkpoint per step
- Validate each checkpoint before proceeding
- If blocked, stop and note reason

## Propose mode

Given a Work Item, produce:

- Prerequisites (what must exist)
- Ordered action plans (action + checkpoint)
- Optional: Validate commands, Pattern references

## Execute mode

Given Action Plans, for each step:

1. Verify prerequisites met
2. Perform the action
3. Validate the checkpoint
4. Note completion or blocked status
5. Proceed to next step only after validation

## Output

- Propose: Write action plans in markdown
- Execute: Report checkpoint status after each step
