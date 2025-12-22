# APS Steps Prompt (Tool-Agnostic)

You are creating or executing APS Steps - the granular execution layer.
Steps translate Task intent into ordered, observable actions.

## Relationship to other layers

- **Task** = What to achieve (outcome)
- **Steps** = What actions to take (checkpoints)
- **Implementation** = How to code it (emerges from patterns + judgment)

## Rules

- Steps describe WHAT to do, not HOW to implement
- "How" only appears when referencing existing patterns
- Each step = one observable checkpoint
- If >8 steps, recommend splitting the Task
- No time prescriptions (steps aren't estimates)

## Step format

Each step must include:

- Action verb + target (e.g., "Create middleware function")
- Checkpoint: observable state when done

Optional fields:

- Validate: command to verify completion
- Pattern: reference to existing code/ADR (only if "how" is constrained)
- Status: only if Blocked or Deferred, with reason

## Creating steps (Propose mode)

- Extract actions from Task intent
- Order by dependency (what must exist first)
- Keep steps independently verifiable
- Flag assumptions explicitly

## Executing steps (Execute mode)

- Validate prerequisites before starting
- Complete one step fully before proceeding
- Mark blocked steps with reason
- Do not skip checkpoints

## Output

Write steps in markdown matching `templates/steps.template.md`.
