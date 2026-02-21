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

### Copilot

Copy to `.github/agents/` in your repository:

```bash
mkdir -p .github/agents
cp scaffold/agents/copilot/aps-planner.md .github/agents/
cp scaffold/agents/copilot/aps-librarian.md .github/agents/
```

### OpenCode

Copy to `.opencode/agents/` in your project:

```bash
mkdir -p .opencode/agents
cp scaffold/agents/opencode/aps-planner.md .opencode/agents/
cp scaffold/agents/opencode/aps-librarian.md .opencode/agents/
```

Agents are configured as subagents — invoke via `@aps-planner` or
`@aps-librarian`.

### Codex

Place the TOML configs and merge the config snippet:

```bash
mkdir -p .codex/agents
cp scaffold/agents/codex/aps-planner.toml .codex/agents/
cp scaffold/agents/codex/aps-librarian.toml .codex/agents/
```

Then merge `scaffold/agents/codex/codex-config-snippet.toml` into your
`.codex/config.toml`. Use `/agent spawn aps-planner` to start.

### Gemini

Copy skills and link them:

```bash
mkdir -p .gemini/skills
cp -r scaffold/agents/gemini/aps-planner .gemini/skills/
cp -r scaffold/agents/gemini/aps-librarian .gemini/skills/
```

Gemini uses skills (not agents) — activate via `activate_skill`.

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

This regenerates all tool variants (Claude Code, Copilot, OpenCode, Codex)
from `scaffold/agents/core/`. Gemini skills are handwritten since the SKILL.md
format differs structurally — the build script verifies they exist.
