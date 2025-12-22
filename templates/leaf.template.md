<!-- APS: See docs/ai/prompting/ for AI guidance. Anti-patterns: docs/ai/policies/ai-anti-patterns.md -->
<!-- Executable only if tasks exist and status is Ready. -->

# [Module Title]

| Scope | Owner | Priority | Status |
|-------|-------|----------|--------|
| SCOPE | @username | medium | Draft |

## Purpose

[Why this module exists and what problem it solves]

## In Scope

- [What this module WILL do]
- [Boundaries of responsibility]

## Out of Scope

- [What this module will NOT do]
- [Things that belong elsewhere]

## Interfaces

**Depends on:**

- [Service/Module] — [what we need from it]

**Exposes:**

- [Endpoint/API] — [what others can use]

## Boundary Rules

- SCOPE must not depend on [OTHER-SCOPE]
- [Other architectural constraints]

## Acceptance Criteria

- [ ] [Testable criterion 1]
- [ ] [Testable criterion 2]

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| [Risk] | [How we address it] |

## Tasks

### SCOPE-001: [Task title]

- **Intent:** [Clear statement of what this task aims to achieve]
- **Expected Outcome:** [What success looks like — testable]
- **Scope:** [What will change]
- **Non-scope:** [What will NOT change]
- **Files:** [Best effort list of files likely touched]
- **Dependencies:** SCOPE-XXX, OTHER-YYY
- **Validation:** `[test command]`
- **Confidence:** medium
- **Risks:** [Brief risk notes]

### SCOPE-002: [Another task]

- **Intent:** [What this task does]
- **Expected Outcome:** [Testable outcome]
- **Scope:** [What changes]
- **Non-scope:** [What doesn't change]
- **Files:** [Files likely touched]
- **Dependencies:** SCOPE-001
- **Validation:** `[test command]`
- **Confidence:** medium

## Execution

Steps: [./execution/SCOPE.steps.md](./execution/SCOPE.steps.md) *(optional)*

## Decisions

- **D-001:** [Short decision] — [rationale]

## Notes

- [Additional context or considerations]
