# APS Interactive Onboarding Design

**Date:** 2026-02-27
**Status:** Draft

## Problem

After running `curl | bash`, users land in a project with scaffolded files
and a "Next steps" message. There is no guided path from "I just installed"
to "I'm productively using APS." The current flow:

- Dumps everything at once regardless of what the user needs
- Doesn't adapt to user type (solo dev vs team vs AI agent operator)
- Doesn't know which AI tools the user works with
- Leaves manual steps: editing settings, installing hooks, configuring agents

## Goal

Replace the current `aps init` with an interactive TUI wizard that:

1. Adapts to the user's context (profile, scope, tooling)
2. Scaffolds exactly what they need
3. Leaves zero manual steps — working setup on completion
4. Shares visual identity with the Anvil product family (TUI from Anvil-001)

## Success Criteria

- [ ] User answers 3 questions and gets a fully working APS setup
- [ ] All selected AI tool integrations are installed and configured
- [ ] `aps lint` passes on the generated structure
- [ ] Non-interactive fallback works for CI and piped environments
- [ ] Existing `curl | bash` install remains as a lightweight alternative

## Wizard Flow

### Step 1: Profile (single-select)

Determines template defaults, hook suggestions, and guidance tone.

```
What are you using APS for?

  > Solo dev — personal project
    Team adoption — rolling out for a team
    AI agent setup — planning layer for AI tools
```

### Step 2: Scope (single-select)

Determines which index and module templates get scaffolded.

```
What's the scope of your first plan?

  > Small feature (1-3 work items)        -> quickstart template
    Module with boundaries                 -> module template
    Multi-module initiative                -> index + module templates
    Monorepo (multiple packages/apps)      -> monorepo index
```

### Step 3: AI Tooling (multi-select)

Determines which agents, hooks, skills, and commands get installed.

```
Which AI tools do you use? (space to toggle, enter to confirm)

  [x] Claude Code
  [ ] GitHub Copilot
  [ ] Codex
  [ ] OpenCode
  [ ] Gemini
  [ ] All of the above
  [ ] None / manual only
```

### Step 4: Scaffold + Verify (automated)

Downloads and installs based on selections, then verifies.

```
==> Installing APS

  > bin/aps + lib/              done
  > plans/ (simple template)    done
  > aps-planning/ (skill)       done
  > .claude/commands/           done
  > .claude/agents/             done
  > Hooks                       done
  > aps lint plans/             passed
```

### Step 5: Summary (results dashboard)

Shows what was installed, per-platform next steps, and doc links.

```
==> Ready!

  Installed:
    Plans       quickstart template in plans/
    CLI         bin/aps (lint, init, update)
    Skill       aps-planning/ (planning skill + hooks)
    Commands    .claude/commands/ (plan, plan-status)
    Agents      .claude/agents/ (aps-planner, aps-librarian)
    Hooks       .claude/settings.local.json

  Next steps:
    Run /plan in Claude Code to start planning

  Docs: https://github.com/EddaCraft/anvil-plan-spec
```

## What Gets Installed Per Selection

### By Profile

| Profile | Effect |
|---------|--------|
| Solo dev | Defaults to quickstart template, skips team-oriented guidance |
| Team adoption | Defaults to index template, includes review workflow guidance |
| AI agent setup | Defaults to module template, emphasises tool integration |

### By Scope

| Scope | Templates Installed |
|-------|-------------------|
| Small feature | `quickstart.template.md` as `plans/index.aps.md` |
| Module with boundaries | `module.template.md` in `plans/modules/` |
| Multi-module initiative | `index.template.md` + `module.template.md` |
| Monorepo | `index-monorepo.template.md` + `module.template.md` |

All scopes also get `aps-rules.md`, `execution/.steps.template.md`, and
`decisions/.gitkeep`.

### By AI Tooling

| Tool | What Gets Installed |
|------|-------------------|
| Claude Code | `aps-planning/` skill, `.claude/commands/`, `.claude/agents/aps-planner.md` + `aps-librarian.md`, hooks in `.claude/settings.local.json` |
| GitHub Copilot | `.github/copilot/agents/aps-planner.md` + `aps-librarian.md` |
| Codex | `codex.toml` snippet, agents in codex format |
| OpenCode | `.opencode/agents/aps-planner.md` + `aps-librarian.md` |
| Gemini | `.gemini/skills/aps-planner/SKILL.md` + `aps-librarian/SKILL.md` |
| None | Plans + CLI only, no integrations |

## Non-Interactive Fallback

When TTY is not available (CI, piped input, `--non-interactive` flag):

- Use smart defaults: solo dev, small feature, no AI tools
- Accept overrides via flags: `--profile team --scope monorepo --tools claude,copilot`
- Silent operation with exit code for success/failure

The existing `curl | bash` install script remains as the lightweight,
no-dependency alternative. Both paths produce the same end state.

## Architecture

```
aps-cli/
  src/
    index.ts                    Entry point (commander)
    commands/
      init.ts                   Init wizard command
      lint.ts                   Lint (port from bash or shell out)
      update.ts                 Update command
    tui/
      components/               OpenTUI components (SolidJS)
        Select.tsx              Single-select prompt
        MultiSelect.tsx         Checkbox multi-select (custom)
        Confirm.tsx             Y/N dialog
        Spinner.tsx             Progress indicator
        Header.tsx              Branded header
        ResultsDashboard.tsx    Summary panel
      commands/
        init/
          InitWizard.tsx        Wizard orchestrator
          ProfileStep.tsx       Step 1: profile selection
          ScopeStep.tsx         Step 2: scope selection
          ToolingStep.tsx       Step 3: AI tools multi-select
          SummaryStep.tsx       Step 5: results dashboard
      utils/
        theme.ts                EddaCraft shared theme
        tty-detection.ts        TTY/fallback detection
  build.ts                      Bun compile script (cross-platform)
  package.json
  tsconfig.json
```

Built with OpenTUI (Bun/Zig) using the SolidJS reconciler. Components
should match the visual language of Anvil-001 (shared EddaCraft theme,
keyboard conventions). Compiled to a single binary via
`bun build --compile` for each target platform.

## Keyboard Conventions (from Anvil-001)

| Action | Keys |
|--------|------|
| Navigate | Arrow keys or j/k |
| Select/confirm | Enter |
| Toggle checkbox | Space |
| Go back | Esc or left arrow |
| Quit | q or Ctrl+C |

## Decisions

| Decision | Choice | Notes |
|----------|--------|-------|
| TUI framework | **OpenTUI** (Bun/Zig) | SolidJS reconciler, native Zig TUI core, same product family as Anvil. Migrating from Ink. |
| Distribution | **Single binary** via `bun build --compile` | Cross-compile for linux-x64, darwin-arm64, windows-x64. Zero runtime deps for end users. |
| Where source lives | TBD | APS is public, Anvil is private. Need to decide whether aps-cli lives in APS repo or elsewhere. |
| Shared TUI components | TBD | Depends on source location. OpenTUI components may be extracted as a shared public package or copied. |

### Why OpenTUI

- Same product family as Anvil-001 (migrating Anvil from Ink to OpenTUI)
- Bun-compiled single binary — same approach Claude Code uses in production
- SolidJS reconciler for reactive components
- Built-in Select, Input, Textarea, TabSelect, Slider, ScrollBox, Markdown
- Native Zig core delivers sub-ms rendering
- Bun cross-compilation covers all target platforms

### Risk: Native Zig Addon in Compiled Binary

OpenTUI's Zig TUI core is a native addon. There is an open Bun issue
about `--compile` not always embedding native addons correctly. A spike
should verify this works before committing to the architecture.

## Relationship to Existing Install

The `curl | bash` installer (`scaffold/install`) remains as-is. It serves
users who want no runtime dependencies and works in non-interactive
environments. The TUI wizard is the premium path for interactive setup.

Both produce the same file structure. The wizard just makes smarter choices
about what to include.

## Build & Cross-Compilation

The CLI compiles to standalone binaries via `bun build --compile`:

```typescript
// build.ts
import solidPlugin from "@opentui/solid/bun-plugin"

const targets = [
  { target: "bun-linux-x64", outfile: "./dist/aps-linux-x64" },
  { target: "bun-linux-arm64", outfile: "./dist/aps-linux-arm64" },
  { target: "bun-darwin-arm64", outfile: "./dist/aps-darwin-arm64" },
  { target: "bun-darwin-x64", outfile: "./dist/aps-darwin-x64" },
  { target: "bun-windows-x64", outfile: "./dist/aps-windows-x64.exe" },
]

for (const { target, outfile } of targets) {
  await Bun.build({
    entrypoints: ["./src/index.ts"],
    plugins: [solidPlugin],
    compile: { target, outfile },
  })
}
```

Binaries are published as GitHub release assets. The `curl | bash`
installer can optionally download the binary instead of the bash CLI.

## Prior Art

- **Anvil-001** (`anvil init`) — 5-step TUI wizard with Ink (migrating to
  OpenTUI). Direct inspiration for UX patterns and shared theme.
- **Superpowers** — Per-platform install instructions (Claude Code, Cursor,
  Codex, OpenCode). Inspiration for the multi-tool selection model.
- **Claude Code** — Ships as a Bun-compiled single binary. Validates the
  distribution approach at scale.
