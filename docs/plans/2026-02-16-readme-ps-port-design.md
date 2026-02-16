# Design: README Restructure + PowerShell Full Port

**Date:** 2026-02-16
**Branch:** `feat/readme-restructure-ps-port`

## Problem

1. The README Quick Start doesn't appear until line 103, buried behind three conceptual sections. New users have to scroll past Philosophy, Hierarchy, and "Why APS?" before seeing how to install.
2. The AI Agent Implementation Guide (~200 lines) bloats the README and isn't relevant to most readers.
3. Full installation/usage details clutter the Quick Start when a link to docs would suffice.
4. The PowerShell port is incomplete — only `lint` works. `init`, `update`, hooks, and installers are bash-only.

## Design

### Part 1: README Restructure

**Principle:** Quick Start at the top, detailed docs linked not inlined.

**New section order:**

1. Title + intro paragraph (unchanged)
2. **Quick Start** — 1 curl command + "See docs/installation.md for more"
3. What is APS? (unchanged)
4. Why APS? (unchanged)
5. Hierarchy (unchanged)
6. Hello World Example (pulled up from Templates section)
7. Validation — trimmed, link to docs/usage.md for full CLI reference
8. Works Everywhere (unchanged)
9. Templates (without Hello World, now above)
10. Examples (unchanged)
11. Platform Support (pushed down — reference material)
12. AI Guidance — 3-5 lines + link to docs/ai-agent-guide.md
13. Philosophy: Compound Engineering (pushed down from position 3)
14. Principles (unchanged)
15. Project Structure (unchanged)
16. Versioning / Roadmap / Contributing / License (unchanged)

**New docs files:**

- `docs/installation.md` — Full install/update instructions for all platforms
- `docs/usage.md` — Full CLI usage, all options, CI integration examples
- `docs/ai-agent-guide.md` — Extracted from README (AI Agent Implementation Guide)

### Part 2: PowerShell Full Port

**Files to create:**

| File | Port of | Purpose |
|------|---------|---------|
| `lib/Scaffold.psm1` | `lib/scaffold.sh` | Download files, create/update APS structure |
| `scaffold/install.ps1` | `scaffold/install` | Windows one-liner installer |
| `scaffold/update.ps1` | `scaffold/update` | Windows one-liner updater |
| `scaffold/aps-planning/scripts/init-session.ps1` | `init-session.sh` | SessionStart hook |
| `scaffold/aps-planning/scripts/check-complete.ps1` | `check-complete.sh` | Stop hook (completion check) |
| `scaffold/aps-planning/scripts/pre-tool-check.ps1` | `pre-tool-check.sh` | PreToolUse hook |
| `scaffold/aps-planning/scripts/post-tool-nudge.ps1` | `post-tool-nudge.sh` | PostToolUse hook |
| `scaffold/aps-planning/scripts/enforce-plan-update.ps1` | `enforce-plan-update.sh` | Stop hook (plan updates) |
| `scaffold/aps-planning/scripts/install-hooks.ps1` | `install-hooks.sh` | Hook installer |

**Files to modify:**

- `bin/aps.ps1` — Add `init` and `update` commands, import Scaffold.psm1
- `README.md` — Full restructure per Part 1
- Platform Support table: hooks column → "PowerShell 5.1+"

**Porting conventions (same as Phase 1):**

- Case-sensitive operators (`-ceq`, `-cmatch`, `-cnotmatch`)
- Nested `Join-Path` for PS5 compatibility
- Errors to stderr via `[Console]::Error`
- `curl` → `Invoke-WebRequest`
- `jq` → `ConvertFrom-Json` (native)
- Same exit codes, same JSON output format
