# APS Planning Skill

A Claude Code skill that teaches AI agents to use **Anvil Plan Spec (APS)** as
persistent memory for complex tasks.

Inspired by [planning-with-files](https://github.com/OthmanAdi/planning-with-files),
adapted for APS's structured planning hierarchy.

## The Problem

AI agents suffer from volatile memory:

- Context resets lose all planning state
- After 50+ tool calls, original goals drift out of attention
- Errors repeat because failures aren't tracked
- Handoffs require archaeology to understand what happened

## The Solution

Use APS markdown files as persistent disk-based memory:

```
Context Window = RAM (volatile, limited)
Filesystem     = Disk (persistent, unlimited)
→ Anything important gets written to APS files
```

Instead of generic planning files, APS provides a structured hierarchy:

```
Index (what are we building?)
  └─ Module (bounded work areas)
       └─ Work Item (authorized changes with validation)
            └─ Action Plan (execution checkpoints)
```

## What's Included

| File | Purpose |
|------|---------|
| `SKILL.md` | Core skill — behavioral rules and APS workflow |
| `reference.md` | Compact APS format reference (points to canonical docs) |
| `examples.md` | Real-world format examples (points to canonical examples) |
| `hooks.md` | Hook configuration for behavioral reinforcement |
| `scripts/install-hooks.sh` | Installs APS hooks into `.claude/settings.local.json` |
| `scripts/init-session.sh` | Reports planning status at session start |
| `scripts/check-complete.sh` | Verifies work items are resolved before stopping |

| Command | Purpose |
|---------|---------|
| `/plan` | Start or continue APS planning |
| `/plan-status` | Review current planning state |

## Quick Start

### 1. Install the skill

Copy `aps-planning/` into your project or install as a Claude Code plugin.

### 2. Add slash commands

Copy `commands/plan.md` and `commands/plan-status.md` into your project's
`.claude/commands/` directory, or keep them at `commands/` in the repo root.

### 3. Configure hooks (optional but recommended)

Run the install script:

```bash
./aps-planning/scripts/install-hooks.sh           # All hooks
./aps-planning/scripts/install-hooks.sh --minimal  # PreToolUse + Stop only
./aps-planning/scripts/install-hooks.sh --remove   # Remove APS hooks
```

This merges APS hooks into `.claude/settings.local.json` without clobbering
existing settings. See `hooks.md` for what each hook does.

### 4. Use it

Type `/plan` in Claude Code to start planning, or `/plan-status` to check
current state. The skill will guide you through creating the right APS
artefacts for your project.

## How It Reinforces Planning

| Mechanism | What it does |
|-----------|--------------|
| **SKILL.md rules** | Teaches "plan before building" and "read before deciding" |
| **5-Operation Rule** | After every 5 tool calls, check if still on-plan |
| **PreToolUse hook** | Reminds agent to re-read work item before code changes |
| **PostToolUse hook** | Nudges agent to update specs after changes |
| **Stop hook** | Blocks session end if work items are still in progress |
| **SessionStart hook** | Shows planning status so agent has immediate context |
| **Slash commands** | Easy invocation — `/plan` to start, `/plan-status` to check |

## Key Principles

1. **Specs describe intent, not implementation** — Write what/why, never how
2. **Plan before building** — No complex work without an APS file
3. **Read before deciding** — Re-read specs to prevent goal drift
4. **Update as you go** — Stale specs lose trust
5. **Never skip validation** — Run validation commands before marking complete
