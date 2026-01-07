# APS Action Plan Prompt (Tool-Agnostic)

You are creating or executing APS Action Plans - the granular execution layer.
Action Plans translate Work Item intent into ordered, observable actions.

## File naming

- **Per-work-item** (`WORK-ITEM-ID.actions.md`): Complex projects, independent work items
- **Per-module** (`MODULE.actions.md`): Simple projects, tightly coupled work items

## Relationship to other layers

- **Work Item** = What to achieve (outcome)
- **Action Plan** = What actions to take (checkpoints)
- **Implementation** = How to code it (emerges from patterns + judgment)

## Rules

- Actions describe WHAT to do, not HOW to implement
- "How" only appears when referencing existing patterns
- Each action must include: Purpose, Produces, and Checkpoint
- If >8 actions, recommend splitting the Work Item
- No time prescriptions (actions aren't estimates)

## Action format

Each action must include:

- Action heading with verb + target (e.g., "Action 1 — Create middleware function")
- **Purpose**: Why this action exists
- **Produces**: Concrete artefacts or state
- **Checkpoint**: Observable state (max ~12 words)

Optional fields:

- **Validate**: Command to verify completion
- **Status**: Only if Blocked or Deferred, with reason

## Creating action plans (Propose mode)

- Extract actions from Work Item intent
- Order by dependency (what must exist first)
- Keep actions independently verifiable
- Flag assumptions explicitly
- Avoid implementation detail in checkpoints

## Executing action plans (Execute mode)

- Validate prerequisites before starting
- Complete one action fully before proceeding
- Mark blocked actions with reason
- Do not skip checkpoints

## Output

Write action plans in markdown matching `templates/actions.template.md`.
