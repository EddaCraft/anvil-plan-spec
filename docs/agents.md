# APS Agents

APS provides two distributable agents that automate planning lifecycle and
repository hygiene tasks.

## Agents Overview

| Agent | Purpose | Model | Invocation |
|-------|---------|-------|------------|
| **APS Planner** | Planning, execution, status tracking, wave coordination | Opus | `@aps-planner` or Task dispatch |
| **APS Librarian** | Archiving, cross-refs, orphan detection, repo hygiene | Sonnet | `@aps-librarian` or Task dispatch |

### APS Planner

The Planner manages the full APS lifecycle:

- **Initialize** — bootstrap `plans/` in new projects
- **Plan** — create indexes, modules, work items, action plans
- **Status** — scan artefacts and report current state
- **Execute** — pick up Ready work items and implement them
- **Waves** — analyze dependencies and plan parallel execution

Use the Planner when starting new work, checking progress, or executing
planned work items.

### APS Librarian

The Librarian keeps your repo organized:

- **Audit** — scan for orphaned files, broken references, stale docs
- **Archive** — move completed modules to `plans/archive/`
- **Cross-refs** — verify all internal links resolve correctly
- **Filing** — identify stray planning docs and suggest proper locations

Use the Librarian after completing features, during cleanup sessions, or when
the repo feels disorganized.

## Planner vs Librarian

| Task | Agent |
|------|-------|
| "Create a plan for feature X" | Planner |
| "What's the status of our work?" | Planner |
| "Execute AUTH-001" | Planner |
| "Clean up after the auth module" | Librarian |
| "Are our docs consistent?" | Librarian |
| "Archive completed specs" | Librarian |

## Agents vs Skill

APS includes both **agents** (active dispatch) and a **skill** (passive
guidance):

- **Skill** (`aps-planning/SKILL.md`) — teaches the agent APS conventions.
  Always active. Provides behavioral nudges (plan before building, update
  specs as you work). Lightweight, no model cost.
- **Agents** (`aps-planner`, `aps-librarian`) — perform specific APS tasks
  when dispatched. Use tool calls and reasoning. Consume model tokens.

Use the skill for day-to-day guidance. Use agents when you need active help
with planning or cleanup.

## Installation

### Claude Code

Copy the agent files to your project:

```bash
mkdir -p .claude/agents
cp scaffold/agents/claude-code/aps-planner.md .claude/agents/
cp scaffold/agents/claude-code/aps-librarian.md .claude/agents/
```

Or if you installed APS via the scaffold scripts, agents are available in
`scaffold/agents/claude-code/` within the APS repository.

### Other Tools

Agent ports for Codex, Copilot, OpenCode, and Gemini are planned for a future
release. The core agent logic is shared — only the packaging format differs
per tool.

## Model Cost

- **Planner** uses Opus (most capable, higher cost) because planning requires
  deep reasoning about architecture, dependencies, and trade-offs.
- **Librarian** uses Sonnet (fast, lower cost) because repo hygiene is
  pattern-matching and file organization — less reasoning-intensive.

You can change the model in each agent's frontmatter if you prefer different
cost/capability trade-offs.

## Building Agent Variants

The build script generates tool-specific agents from shared core prompts:

```bash
bash scaffold/agents/build.sh
```

This regenerates the Claude Code agents from `scaffold/agents/core/`. When
adding support for new tools, extend `build.sh` with the appropriate
frontmatter generation.
