# APS Hooks Configuration

Hooks reinforce APS planning behavior by triggering at key moments during
a Claude Code session. They solve the **attention drift problem**: after many
tool calls, agents forget their original goals.

## Quick Install

The fastest way to add hooks is the install script:

```bash
./aps-planning/scripts/install-hooks.sh           # All hooks
./aps-planning/scripts/install-hooks.sh --minimal  # PreToolUse + Stop only
./aps-planning/scripts/install-hooks.sh --remove   # Remove APS hooks
```

This safely merges hooks into `.claude/settings.local.json`, preserving any
existing settings and permissions. It's idempotent — running it twice won't
create duplicates.

## Recommended Hooks

If you prefer manual setup, add these to your project's
`.claude/settings.local.json` or your user-level `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|Bash",
        "hook": "if [ -d plans ] && [ -f plans/index.aps.md -o -d plans/modules ]; then echo '[APS] Re-read your current work item before making changes. Are you still on-plan?'; fi",
        "description": "Remind agent to check APS plan before writing code"
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hook": "if [ -d plans ]; then echo '[APS] If you completed a work item or discovered new scope, update the APS spec now.'; fi",
        "description": "Remind agent to update APS after code changes"
      }
    ],
    "Stop": [
      {
        "hook": "./aps-planning/scripts/check-complete.sh",
        "description": "Verify all in-progress work items are resolved before ending"
      }
    ],
    "SessionStart": [
      {
        "hook": "./aps-planning/scripts/init-session.sh",
        "description": "Show APS planning status at session start"
      }
    ]
  }
}
```

## How Each Hook Works

### PreToolUse (Write | Edit | Bash)

**When:** Before any code modification.

**Why:** After 10+ tool calls, the agent's attention drifts from its original
goal. This hook reminds it to re-read the current work item's Intent and
Expected Outcome before writing code.

**What it says:** "Re-read your current work item before making changes."

The agent should then check it's still working toward the right work item
before proceeding.

### PostToolUse (Write | Edit)

**When:** After writing or editing files.

**Why:** Agents often forget to update specs after completing work. This nudge
ensures status changes and new discoveries get captured immediately.

**What it says:** "If you completed a work item or discovered new scope, update
the APS spec now."

### Stop Hook

**When:** Before the session ends.

**Why:** Prevents the agent from stopping with work items still "In Progress"
and no status update. The next session would have to do archaeology to figure
out what happened.

**What it does:** Runs `check-complete.sh` which exits non-zero if work items
are still in progress, prompting the agent to update statuses.

### SessionStart Hook

**When:** At the beginning of a new session.

**Why:** Gives the agent immediate context about the project's planning state.
Instead of exploring from scratch, it knows what plans exist, what's in
progress, and what to work on next.

**What it does:** Runs `init-session.sh` which reports plan status, module
counts, and actionable work items.

## Minimal Setup

If you only want one hook, use **PreToolUse**. It has the highest impact on
preventing goal drift:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hook": "if [ -d plans ]; then echo '[APS] Check your work item intent before proceeding.'; fi"
      }
    ]
  }
}
```

## Notes

- Hooks only fire if a `plans/` directory exists, so they're silent in projects
  that don't use APS.
- The PreToolUse hook is intentionally lightweight — it's a reminder, not a
  blocker. The agent decides whether to re-read.
- The Stop hook is the only one that can block — it exits non-zero when work
  is incomplete, which prompts the agent to finish up.
- Scripts need execute permissions: `chmod +x aps-planning/scripts/*.sh`
