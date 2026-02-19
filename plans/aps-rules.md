# APS Rules for AI Agents

> This file guides AI agents working with APS specs in this repository.
> Keep it in `plans/` so agents discover it when exploring the planning directory.

## Core Principle

**Specs describe intent. Work Items authorise execution. Actions are checkpoints, not tutorials.**

## Hierarchy

| Layer | Purpose | You Write | You DON'T Write |
|-------|---------|-----------|-----------------|
| Index | Plan overview | Modules, milestones, risks | Implementation details |
| Module | Bounded work area | Interfaces, work items, boundaries | Code snippets |
| Work Item | Execution authority | Outcome, validation command | How to implement |
| Action | Checkpoint | Observable state | Implementation detail |

## Actions: The Lean Rule

Actions translate work item intent into **observable checkpoints**. They are NOT implementation guides.

### Format

```markdown
### Action 1 — [Action verb] [target]

**Purpose**
[Why this action exists]

**Produces**
[Concrete artefacts or state]

**Checkpoint**
[Observable state — max ~12 words]

**Validate**
`[command]` *(optional)*
```

### What Goes WHERE

| Write in Action | Write NOWHERE (emerges from patterns) |
|-----------------|---------------------------------------|
| "Auth middleware exists" | Which library to use |
| "Tests pass" | Test implementation details |
| "Migration applied" | SQL schema definition |
| "Function handles errors" | Try/catch structure |

### Anti-Patterns (NEVER do this)

```markdown
# ❌ BAD: Implementation tutorial disguised as action
### Action 1 — Create authentication middleware

**Checkpoint**
Middleware created in src/middleware/auth.ts that:
  - Extracts JWT from Authorization header
  - Validates token using jsonwebtoken library
  - Decodes payload and extracts user ID
  - Attaches user object to request context
  - Returns 401 if token invalid or expired
```

```markdown
# ✅ GOOD: Observable checkpoint only
### Action 1 — Create authentication middleware

**Checkpoint**
Auth middleware validates requests, attaches user to context

**Validate**
`npm test -- auth.middleware.test.ts`
```

### Why Lean Actions?

1. **Implementation emerges** from existing patterns + agent judgment
2. **Specs don't rot** — checkpoints stay valid even when code changes
3. **Agents stay autonomous** — they figure out HOW, you verify WHAT
4. **Review stays fast** — humans scan checkpoints, not implementation plans

## Work Item Rules

Work Items are **execution authority** — permission to make changes.

### Required Fields

- **Intent:** One sentence — what outcome this achieves
- **Expected Outcome:** Testable/observable result
- **Validation:** Command to verify completion

### Optional Fields

- **Scope/Non-scope:** What will and won't change
- **Dependencies:** Other work item IDs that must complete first
- **Confidence:** low/medium/high
- **Files:** Best-effort list (not exhaustive)

### Work Item Anti-Patterns

| ❌ Don't | ✅ Do |
|----------|-------|
| "Implement JWT auth using jsonwebtoken" | "Add token-based authentication" |
| "Create UserService class with methods..." | "User operations are encapsulated" |
| "Add try/catch blocks to all handlers" | "API errors return consistent format" |

## Naming Conventions

### Module Files

Name module files with a numeric prefix based on dependency order:

```text
modules/
├── 01-core.aps.md      # Foundation, no dependencies
├── 02-auth.aps.md      # Depends on core
├── 03-payments.aps.md  # Depends on auth
└── 04-ui.aps.md        # Depends on all above
```

- Use zero-padded numbers (`01-`, `02-`, not `1-`, `2-`)
- Order matches dependency flow (foundational → dependent)
- Order should reflect the Modules table in `index.aps.md`

### Work Item IDs

Work Items use the module's ID prefix: `AUTH-001`, `AUTH-002`, `CORE-001`, etc.

## Creating APS Documents

**Important:** Templates are reference documents. Never edit template files directly.
Instead, create a **new file** using the template structure as a guide.

### When Asked to Plan

1. Read existing `plans/index.aps.md` if present
2. Identify which template fits (index, module, simple)
3. Create a new document with sections populated with **intent**, not implementation
4. Mark assumptions explicitly
5. Leave work items empty until module is Ready

### When Asked to Execute

1. Find the work item in the relevant `.aps.md` file
2. Check work item has **Ready** status
3. Create an action plan in `plans/execution/` if complex
4. Execute one action at a time, validate checkpoint
5. Mark work item complete when validation passes

## File Locations

```text
plans/
├── aps-rules.md                # This file (agent guidance)
├── index.aps.md                # Root plan
├── issues.md                   # Development-time discoveries (issues & questions)
├── modules/                    # Module specs (numbered by dependency order)
│   ├── 01-core.aps.md
│   └── 02-auth.aps.md
├── execution/                  # Action plans
│   ├── [WORKITEM-ID].actions.md  # Per-work-item (complex projects)
│   └── [MODULE].actions.md       # Per-module (simple projects)
└── decisions/                  # ADRs (optional)
    └── [NNN]-[title].md
```

## Monorepo Conventions

For repositories with multiple packages/apps. See `docs/monorepo.md` for full guidance.

### Package Tagging

Every module declares `Packages: pkg1, pkg2` in metadata. Work items inherit or narrow the package scope.

### Session Start Ritual

Before touching code:

1. **Orient** — Read `plans/index.aps.md` "What's Next" section, then relevant module(s)
2. **Confirm authority** — Work item exists, status = Ready, packages are clear
3. **Declare intent** — State: "Executing AUTH-002 (core, api): [description]"

If no Ready work item exists:

- Create Draft work item first
- Ask human to mark Ready before proceeding
- OR if trivial fix, note in session end summary

### Session End Ritual

After completing work:

1. **Update status** — Mark work items: `In Progress`, `Complete: YYYY-MM-DD`, or `Blocked: [reason]`
2. **Capture discovered work** — Add as Draft items with package tags
3. **Log discoveries** — Add issues (ISS-NNN) or questions (Q-NNN) to `plans/issues.md`
4. **Update "What's Next"** — Remove completed, add new Ready items, re-sequence if needed
5. **Session summary** — Brief note: what completed, what discovered, what's next

**Key principle:** The next agent should pick up exactly where you left off without archaeology.

## Issues & Questions Tracker

Use `plans/issues.md` to log development-time discoveries:

- **Issues (ISS-NNN)** — Bugs, limitations, edge cases noticed during development
- **Questions (Q-NNN)** — Unknowns that need answers, deferred decisions

### When to Log

| Log as Issue | Log as Question |
|--------------|-----------------|
| "API rate-limits at 100 req/min" | "Should retry logic live in client or transport?" |
| "Login fails intermittently on Safari" | "What's the session expiry policy?" |
| "Edge case: empty array not handled" | "Do we need to support IE11?" |

### Referencing

From work items, notes, or commits:

- `See ISS-001` or `Related: ISS-001, Q-002`
- In commits: `Addresses ISS-001`

### Not a Bug Tracker

This is for **planning-level visibility**, not routine bugs. Use your project's bug tracker for:

- User-reported bugs
- Production incidents
- Detailed reproduction steps

## Quick Reference

| If agent is... | Check for... |
|----------------|--------------|
| Writing actions | Max 12 words per checkpoint? No implementation detail? |
| Writing work items | Outcome-focused? Has validation command? |
| Planning module | Boundaries clear? No premature work items? |
| Executing | Work item status is Ready? Prerequisites met? |
| In monorepo | Packages tagged? "What's Next" updated? |
| Found issue/question | Logged in issues.md with proper ID? |
