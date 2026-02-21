# Installation

## Quick Install (Linux/macOS)

```bash
curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/install | bash
```

This downloads the APS scaffold into the current directory. No global
installs, no package managers -- just your project files.

## Install Options

```bash
# Install in a specific directory
curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/install | bash -s -- ./my-project

# Install a specific version
curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/install | VERSION=v0.2.0 bash
```

The installer prompts you to set up Claude Code hooks and PATH
configuration. In non-interactive mode (piped without a terminal), it
uses sensible defaults.

## Update Existing Project

If you already have APS installed and want to pull the latest templates,
rules, and skill files:

```bash
curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/update | bash
```

Your specs are preserved -- the updater only replaces templates, rules,
the CLI, and skill files. It does not touch your `index.aps.md`, module
specs, or action plans.

**Updated files:**

- `bin/aps` + `lib/` (CLI)
- `aps-rules.md` (agent guidance)
- `modules/.module.template.md`, `.simple.template.md`, `.index-monorepo.template.md`
- `execution/.actions.template.md`
- `aps-planning/` (skill + scripts)
- `.claude/commands/` (plan, plan-status)

## Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/install.ps1 | iex
```

To install a specific version:

```powershell
$env:VERSION='v0.2.0'; irm https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/install.ps1 | iex
```

Or follow the [Manual Setup](#manual-setup) steps below.

## Manual Setup

If you prefer to set things up by hand:

1. Copy `bin/aps` and `lib/` into your project
2. Copy the templates from `scaffold/plans/` into `plans/`
3. Copy `scaffold/aps-planning/` for the Claude Code skill
4. Copy `scaffold/commands/` into `.claude/commands/`
5. Edit `plans/index.aps.md` to define your plan's scope and modules
6. Create modules by copying templates (remove the leading dot from filenames)
7. Add Work Items when a module is ready for implementation

## What Gets Installed

The install script creates the following structure in your project:

```
bin/
└── aps                              # CLI (lint, init, update)

plans/
├── aps-rules.md                     # Agent guidance
├── index.aps.md                     # Your main plan
├── modules/
│   ├── .module.template.md          # Module template
│   ├── .simple.template.md          # Simple feature template
│   └── .index-monorepo.template.md  # Index for monorepos
├── execution/
│   └── .actions.template.md          # Action plan template
└── decisions/

aps-planning/
├── SKILL.md                         # Planning skill (core rules)
├── reference.md                     # APS format reference
├── examples.md                      # Real-world examples
├── hooks.md                         # Hook configuration guide
└── scripts/                         # Hook install + session scripts

.claude/commands/
├── plan.md                          # /plan command
└── plan-status.md                   # /plan-status command
```

## Next Steps

After installation:

1. Edit `plans/index.aps.md` to define your plan
2. Copy templates to create modules (remove the leading dot)
3. Use `/plan` in Claude Code to start planning

For a full walkthrough, see the [Getting Started](getting-started.md)
guide.
