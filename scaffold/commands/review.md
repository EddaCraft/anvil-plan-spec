# /review

Review completed work against APS spec criteria from multiple perspectives.

## Instructions

### 1. Identify what to review

1. If the user specifies a work item ID, review that item.
2. If no ID is given, scan modules for items with status `Complete` that have not been reviewed. Look for a `Reviewed: yes` or `Reviewed: no` field.
3. If nothing is Complete, check for `In Progress` items and offer to review work-so-far.
4. Summarise the scope: which files were changed, what the spec's Expected Outcome was.

### 2. Gather context

1. Read the work item's **Intent**, **Expected Outcome**, and **Validation** fields.
2. Read the action plan if one exists in `plans/execution/`.
3. Identify all files that were created or modified for this work item (use git diff if available).
4. Run the work item's **Validation** command to confirm it still passes.

### 3. Review from four perspectives

Evaluate the work against each perspective. For each, note findings as **P1** (must fix), **P2** (should fix), or **P3** (consider).

#### Architecture

- Does the implementation fit the existing codebase structure?
- Are boundaries and responsibilities clear?
- Is coupling appropriate? Are dependencies in the right direction?
- Does it follow patterns already established in the project?

#### Security

- Are inputs validated at system boundaries?
- Are secrets, credentials, or tokens handled safely?
- Is there risk of injection (SQL, command, XSS)?
- Are access controls and permissions correct?

#### Simplicity

- Is there unnecessary abstraction or indirection?
- Could the same result be achieved with less code?
- Are there premature generalisations or speculative features?
- Is the code readable without extensive comments?

#### Correctness

- Does the implementation achieve the spec's **Expected Outcome**?
- Do edge cases have reasonable behaviour?
- Are error paths handled?
- Do all validation commands pass?

### 4. Report findings

Output findings using this format:

```markdown
## Review: WORK-ITEM-ID

**Spec:** [work item title]
**Validation:** [pass/fail]

### Findings

| # | Priority | Perspective | Finding |
|---|----------|------------|---------|
| 1 | P1 | security | [description] |
| 2 | P2 | simplicity | [description] |

### Summary
[1-2 sentences: overall assessment and recommended next step]
```

### 5. Record issues

1. If there are P1 or P2 findings, append them to `plans/issues.md`. Create the file if it does not exist. Use this format per issue:

```markdown
### ISSUE-NNN: [title]
- **Source:** [WORK-ITEM-ID]
- **Priority:** [P1/P2/P3]
- **Perspective:** [architecture/security/simplicity/correctness]
- **Description:** [what and why]
- **Suggested fix:** [concrete action]
- **Status:** Open
```

1. If all findings are P3 or there are no findings, note that the review passed cleanly.
1. If the work item had P1 issues, change its status back to `In Progress`.

### 6. Validate the spec

Run `./bin/aps lint` to ensure the spec is still well-formed after any status changes.

## Reminders

- Review against the **spec**, not your preferences. The Expected Outcome is the acceptance criteria.
- P1 means the work item is not actually complete. Be honest but not pedantic.
- P3 findings are suggestions, not blockers. Do not change work item status for P3-only reviews.
- Do not rewrite the implementation during review. Report findings and let the next `/work` cycle address them.
- If you find spec issues (missing validation, unclear intent), note them separately — those are planning issues, not implementation issues.
