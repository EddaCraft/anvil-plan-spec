# APS Workflow Guide

This guide shows how APS fits into your daily development workflow through
concrete scenarios.

## The Planning Lifecycle

APS follows the compound engineering philosophy: each unit of work should make
future work easier. The workflow has four phases that loop back to planning:

```
Plan → Execute → Validate → Learn → Plan again
  ↑                                      │
  └──────────────────────────────────────┘
```

| Phase | What Happens | APS Artefacts | How It Serves Planning |
|-------|--------------|---------------|------------------------|
| **Plan** | Define scope and success | Index, Modules, Work Items | Reference past patterns and solutions |
| **Execute** | Work against specs | Action Plans, status updates | Clean implementation from clear specs |
| **Validate** | Check outcomes against spec | Review notes, checklist | Verify plan was correct, update if not |
| **Learn** | Document solutions | Solution docs in `docs/solutions/` | Future plans start with known answers |

**The 80/20 principle:** Spend 80% of effort on planning and validation, 20% on
execution. Thorough preparation means fast, clean implementation.

**Why the cycle matters:** Planning without validation is guesswork. Validation
without learning repeats mistakes. The cycle exists to make each plan better
than the last.

## Phase Overview

## Scenarios

### Starting a Feature

You've been asked to add user authentication to an existing app.

1. **Assess scope.** Is this a single module or multiple? Auth typically
   touches login/logout, session management, password reset, maybe OAuth.
   That's at least 2 modules — create an Index.

2. **Create the Index:**

   ```markdown
   # Add User Authentication

   ## Problem
   Users currently have no way to log in. All data is public.

   ## Success Criteria
   - [ ] Users can register and log in
   - [ ] Sessions persist across browser refresh
   - [ ] Password reset flow works

   ## Modules
   | Module | Purpose | Status |
   |--------|---------|--------|
   | [auth](./modules/auth.aps.md) | Login, logout, registration | Draft |
   | [session](./modules/session.aps.md) | Token management | Draft |
   ```

3. **Draft the modules.** Create `auth.aps.md` with Purpose and Scope. Leave
   Work Items empty — you're still exploring.

4. **Get approval.** Share the Index with your team or reviewer. Discuss
   scope, dependencies, risks.

5. **Move to Ready.** Once approved, change module status to Ready and add Work Items:

   ```markdown
   ## Work Items

   ### AUTH-001: Create registration endpoint
   - **Intent:** Allow new users to create accounts
   - **Expected Outcome:** POST /api/register creates user, returns token
   - **Validation:** curl test returns 201
   ```

6. **Execute.** Work through work items. If a work item is complex, create a Action Plan file.

---

### Mid-Implementation

You're halfway through AUTH-001 and realize you need database migrations.

1. **Update the spec.** Add a new work item or note the dependency:

   ```markdown
   ### AUTH-001: Create registration endpoint
   - **Status:** In Progress
   - **Blocked:** Needs AUTH-000 (db migration) first
   ```

   Or add a new work item:

   ```markdown
   ### AUTH-000: Add users table migration
   - **Intent:** Create database schema for users
   - **Expected Outcome:** users table exists with email, password_hash columns
   - **Validation:** `psql -c '\d users'` shows table
   - **Status:** ✓ Complete
   ```

2. **Handle blockers.** If you're blocked on something outside your control:

   ```markdown
   ### AUTH-002: Add OAuth login
   - **Status:** Blocked
   - **Blocked:** Waiting on Google API credentials from infra team
   ```

3. **Track progress.** Update work item status as you go:
   - Remove status line = not started
   - `In Progress` = actively working
   - `Blocked` = waiting on something
   - `✓ Complete` = done and validated

---

### Handoff

You're going on vacation and someone else needs to continue your work.

1. **Update all statuses.** Make sure every work item reflects current state. The
   incoming dev should be able to look at the module and know exactly what's
   done and what's not.

2. **Document context.** Add notes for anything not obvious:

   ```markdown
   ## Notes

   - AUTH-002 is blocked on API credentials — ping @infra in Slack
   - The session token format follows RFC 7519 (JWT)
   - Tests are in `tests/auth/` — run with `npm test -- auth`
   ```

3. **Point to the spec.** Tell the incoming dev: "Start with
   `plans/modules/auth.aps.md` — it has everything you need."

---

### Completion and Archival

You've finished all work items in a module. Now what?

1. **Validate all work items.** Run each work item's validation command. Make sure
   everything actually works.

2. **Mark module complete:**

   ```markdown
   | ID | Owner | Status |
   |----|-------|--------|
   | AUTH | @you | Complete |
   ```

3. **Update the Index:**

   ```markdown
   | Module | Purpose | Status |
   |--------|---------|--------|
   | [auth](./modules/auth.aps.md) | Login, logout, registration | Complete |
   ```

4. **Decide on archival:**

   | Approach | When to Use |
   |----------|-------------|
   | **Keep as-is** | Ongoing reference, may need updates |
   | **Move to archive/** | Historical record, unlikely to change |
   | **Delete** | Ephemeral work, no long-term value |

   Most teams keep specs indefinitely — they're lightweight and provide context
   for future work.

5. **For completed initiatives.** When all modules are complete, update the Index:

   ```markdown
   | Field | Value |
   |-------|-------|
   | Status | Complete |
   | Completed | 2025-01-15 |
   ```

   Consider writing a brief retrospective in Notes:

   ```markdown
   ## Notes

   Completed in 3 weeks. Key learnings:
   - OAuth took longer than expected due to credential delays
   - Session module was simpler than anticipated — could merge into auth next time
   ```

## Tips

### Keep specs in sync

Update specs as you work, not after. Stale specs lose trust.

### Don't over-specify

Work Items describe **what**, not **how**. Implementation details belong in code
and comments, not specs.

### Use Steps sparingly

Most work items don't need a Action Plan file. Only create one when:

- Task has 5+ distinct actions
- Multiple people might work on it
- You want granular progress tracking

### Review specs in PRs

Include spec changes in your PRs. Reviewers should see what you planned
alongside what you built.

---

## Validate Phase

After completing work items, validate against the spec before shipping.

### Pre-Ship Checklist

Before merging or deploying, verify:

```markdown
## Review Checklist

### Functional
- [ ] All work item validations pass
- [ ] Edge cases handled
- [ ] Error states covered

### Quality
- [ ] Code follows existing patterns
- [ ] Tests added for new functionality
- [ ] No obvious security issues

### Documentation
- [ ] Spec reflects what was built
- [ ] README updated if needed
- [ ] Comments explain non-obvious code
```

### Multi-Perspective Review

For complex changes, consider multiple review angles:

| Perspective | Questions to Ask |
|-------------|------------------|
| **Developer** | Is this easy to understand and modify? |
| **Operations** | How do I deploy and troubleshoot this? |
| **End User** | Is the feature intuitive? Are errors helpful? |
| **Security** | What's the attack surface? Is data protected? |

### Review in Practice

1. **Run validations.** Execute every work item's validation command:

   ```bash
   # From each work item
   curl -X POST /api/register -d '...'  # AUTH-001
   psql -c '\d users'                   # AUTH-000
   ```

2. **Check against spec.** Does the implementation match the Expected Outcome?

3. **Update spec if needed.** If implementation diverged from plan (for good
   reasons), update the spec to reflect reality.

4. **Note issues found.** If review catches problems, document them:

   ```markdown
   ## Notes

   Review findings:
   - AUTH-002 needs rate limiting (deferred to AUTH-005)
   - Token expiry should be configurable (added to backlog)
   ```

---

## Learn Phase

After solving problems, document solutions to inform future planning.

### Why Document Solutions?

| First Occurrence | After Documenting |
|------------------|-------------------|
| 30+ minutes debugging | 2 minute lookup |
| Research from scratch | Reference past solution |
| Trial and error | Known working approach |

**Knowledge compounds.** Each documented solution makes future work faster.

### When to Document

Document immediately after fixing:

- **Non-trivial bugs** — Took multiple attempts to diagnose
- **Tricky configurations** — Easy to get wrong
- **Performance issues** — Required investigation
- **Integration problems** — External dependencies behaved unexpectedly

**Skip documentation for:**

- Simple typos or syntax errors
- Obvious issues with immediate fixes
- One-off problems unlikely to recur

### Solution Documentation Format

Create solution docs in `docs/solutions/` organized by category:

```text
docs/solutions/
├── performance/
│   └── n-plus-one-query-brief-system.md
├── configuration/
│   └── jwt-token-expiry-settings.md
├── integration/
│   └── oauth-redirect-uri-mismatch.md
└── database/
    └── migration-column-order-issue.md
```

### Solution Template

```markdown
# [Brief Problem Description]

## Symptom

What you observed:
- Error message (exact text)
- Unexpected behavior
- Performance issue

## Root Cause

What was actually wrong:
- Technical explanation
- Why it happened

## Solution

What fixed it:
- Code changes
- Configuration changes
- Command to run

## Prevention

How to avoid in future:
- Pattern to follow
- Check to add
- Test to write

## Related

- Work item: AUTH-001
- PR: #123
- Similar issue: [link to other solution]
```

### Learn Workflow in Practice

1. **Recognize the moment.** You just fixed something that took effort. Pause
   before moving on.

2. **Capture while fresh.** Context fades quickly. Document now, not later.

   ```bash
   # Create solution doc
   mkdir -p docs/solutions/performance
   # Write solution using the template
   ```

3. **Cross-reference.** Link to related work items, PRs, and similar issues.

4. **Make it findable.** Use clear filenames and categories. Future you (or
   your teammates) will search for this.

5. **Update specs.** If the solution affects how work should be done, update
   relevant module specs or add to project conventions.

### Building a Knowledge Base

Over time, your `docs/solutions/` becomes a searchable knowledge base:

```bash
# Find past solutions
grep -r "timeout" docs/solutions/
grep -r "OAuth" docs/solutions/
```

**Patterns emerge.** After documenting 3+ similar issues, consider:

- Adding to project conventions
- Creating a checklist for common pitfalls
- Updating templates to prevent the issue

### Knowledge Compounds

| After 1 Month | After 6 Months | After 1 Year |
|---------------|----------------|--------------|
| 5-10 solutions | 30-50 solutions | 100+ solutions |
| Occasional reference | Regular lookups | Comprehensive KB |
| Individual knowledge | Team knowledge | Institutional knowledge |

**Each solution documented makes future planning faster.** New team members
ramp up faster. Recurring problems get solved in minutes. Plans start with
known answers instead of research.

---

## Complete Workflow Example

Putting it all together for a feature:

1. **Plan** — Create index and modules. Define work items with validation commands.
2. **Execute** — Work against specs. Create action plans for complex items.
3. **Validate** — Run validation commands. Check outcomes against spec. Update if diverged.
4. **Learn** — Document tricky problems solved. Add to solution library.
5. **Plan again** — Next feature references past solutions. Starts faster.
