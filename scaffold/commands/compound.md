# /compound

Capture learnings from completed work into reusable knowledge.

## Instructions

### 1. Identify what was learned

1. If the user describes a specific learning, use that.
2. Otherwise, scan for recently completed work items (`Complete` status) and reviewed issues (`plans/issues.md` with `Status: Resolved`).
3. Ask: what did we learn that would help the next person (or AI) working in this codebase?

### 2. Classify the learning

Determine where the learning belongs:

| Type | Destination | When to use |
|------|-------------|-------------|
| Implementation pattern | `docs/solutions/` | Solved a non-obvious problem with a reusable approach |
| Architecture decision | `plans/decisions/` | Made a design choice with trade-offs worth recording |
| Broad rule | `plans/aps-rules.md` | Discovered a constraint that applies across the project |
| Process improvement | `aps-planning/SKILL.md` | Found a better way to plan or execute |

### 3. Write the knowledge document

#### For solutions (`docs/solutions/`)

Create a file named `YYYY-MM-DD-slug.md` using this structure:

```markdown
# [Title]

## Symptom
[What you observed that indicated a problem]

## Root Cause
[Why the symptom occurred]

## Solution
[What you did to fix it, with enough detail to reproduce]

## Prevention
[How to avoid this in the future]

## Related
- [Links to relevant specs, issues, or code]
```

#### For architecture decisions (`plans/decisions/`)

Create a file named `NNN-slug.md` using this structure:

```markdown
# [Decision Title]

**Date:** YYYY-MM-DD
**Status:** Accepted

## Context
[What situation required a decision]

## Decision
[What was decided and why]

## Alternatives Considered
[Other options and why they were not chosen]

## Consequences
[What this decision enables and constrains]
```

#### For broad rules (`plans/aps-rules.md`)

Append a new rule to the existing file. Keep it to one or two sentences. Rules should be concrete and actionable — not aspirational.

#### For process improvements

Suggest the improvement to the user. Do not modify `aps-planning/SKILL.md` directly unless asked — it is a shared template.

### 4. Cross-reference

1. Link the knowledge document back to the work item or issue that produced it.
2. If the learning changes how future work items should be written, note that in `plans/aps-rules.md`.

### 5. Verify

1. Run `./bin/aps lint` to check for spec errors.
2. Confirm the new document is in the right location and follows the format.

## Reminders

- Knowledge compounds only if it is written down. Do not skip this step.
- Prefer updating existing documents over creating new ones. Check if a relevant solution or decision already exists before writing a new file.
- Keep solutions concrete. "We learned that X causes Y" is better than "consider the implications of X."
- Do not capture trivial learnings. If it is in the framework docs or obvious from the code, it does not need a solution document.
- One learning per document. Do not stuff multiple unrelated findings into one file.
