# APS Leaf/Module Prompt (Tool-Agnostic)

You are assisting with completing an APS Leaf/Module document.
This document is **bounded and near-executable**, but should remain conservative.

## Objectives
1) Define scope and boundaries precisely
2) Define interfaces/contracts (inputs/outputs) where relevant
3) Capture constraints, named patterns, and "must not" rules
4) Draft tasks only if the module is "Ready"; otherwise list blockers

## Rules
- Do not introduce AI anti-patterns (see docs/ai/policies/ai-anti-patterns.md)
- Prefer small, reviewable changes
- If a module is too large, recommend splitting

## Output format
Fill:
- Module Overview
- In Scope / Out of Scope
- Named patterns that apply
- Boundary rules (e.g. "Payments must not depend on Identity")
- Acceptance criteria
- Risks & mitigations
- Open questions & decisions
- Tasks:
  - If Ready: 2-8 tasks maximum, each small and independently reviewable
  - If Not Ready: "No tasks authorised" + list blockers

## Task drafting guidelines (if applicable)
Each task must include:
- Intent (one sentence)
- Expected outcome (testable)
- Files likely touched (best effort)
- "Do not touch" boundaries
- Validation (tests, checks)
- Risk points
