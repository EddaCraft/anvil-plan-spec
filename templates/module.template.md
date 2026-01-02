<!-- APS: See docs/ai/prompting/ for AI guidance -->
<!--
Work can begin when: status=Ready AND tasks exist.
Module ID: Use 2-6 uppercase chars (AUTH, PAY, UI, CORE, etc.)
File naming: NN-name.aps.md by dependency order (01-core.aps.md, 02-auth.aps.md)
-->

# [Module Title]

| ID | Owner | Priority | Status |
|----|-------|----------|--------|
| AUTH | @username | medium | Draft |

## Purpose

[Why this module exists and what problem it solves — one paragraph max]

## In Scope

- [What this module handles]

## Out of Scope *(optional)*

- [What belongs elsewhere — only if clarification needed]

## Interfaces *(optional)*

**Depends on:**

- [Module/Service] — [what we need]

**Exposes:**

- [API/function] — [what others use]

## Constraints *(optional)*

- [Architectural rules, e.g., "AUTH must not import from UI"]

## Ready Checklist

Change status to **Ready** when:

- [ ] Purpose and scope are clear
- [ ] Dependencies identified (or confirmed none)
- [ ] At least one task defined

## Tasks

<!--
Required: Intent, Expected Outcome, Validation
Optional: Non-scope, Files, Dependencies, Confidence, Risks

Confidence levels:
- high: Clear requirements, familiar patterns
- medium: Some unknowns, moderate risk  
- low: Exploratory, high uncertainty
-->

### AUTH-001: [Task title]

- **Intent:** [What this achieves — one sentence]
- **Expected Outcome:** [Observable/testable result]
- **Validation:** `[test command]`
- **Confidence:** medium
- **Non-scope:** [What won't change] *(optional)*
- **Files:** [Likely files] *(optional — best effort)*
- **Dependencies:** AUTH-XXX *(optional)*

### AUTH-002: [Another task]

- **Intent:** [What this achieves]
- **Expected Outcome:** [Testable result]
- **Validation:** `[test command]`
- **Confidence:** medium

## Execution *(optional)*

Steps: [./execution/AUTH.steps.md](./execution/AUTH.steps.md)

## Decisions *(optional)*

- **D-001:** [Decision] — [rationale]

## Notes *(optional)*

- [Additional context]
