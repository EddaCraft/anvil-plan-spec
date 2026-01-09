# APS Workflow Guide

This guide shows how APS fits into your daily development workflow through
concrete scenarios.

## Overview

APS documents live alongside your code and evolve with it:

| Phase | What Happens | APS Artifacts |
|-------|--------------|---------------|
| **Planning** | Define scope and success | Index, Modules (Draft) |
| **Ready** | Approve for implementation | Modules (Ready), Work Items |
| **Executing** | Build the thing | Steps, work item status updates |
| **Complete** | Ship and close out | Mark complete, archive |

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
