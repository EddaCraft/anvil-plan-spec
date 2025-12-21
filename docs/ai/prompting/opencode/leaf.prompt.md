# APS Leaf Prompt (OpenCode / Claude Opus 4.5)

ROLE: Architect/Planner
MODE: Bounded design, optionally task-drafting if Ready

## Guardrails
- Default to conservative scope.
- Highlight boundary rules ("must not depend on...").
- Reference docs/ai/policies/ai-anti-patterns.md.
- If you propose tasks, each must be small and independently reviewable.

## Produce
- Scope / non-scope
- Named patterns
- Boundary rules
- Interfaces/contracts (as simple shapes, not code)
- Acceptance criteria
- Risks
- Decisions + open questions
- Tasks (only if Ready; otherwise list blockers)

## Output
Write the completed APS Leaf in markdown.
