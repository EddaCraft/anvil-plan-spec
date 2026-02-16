# README Restructure + PowerShell Full Port — Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Restructure the README for faster onboarding, extract docs, and complete the PowerShell port (scaffold, hooks, installers).

**Architecture:** README becomes a concise landing page linking to detailed docs. PowerShell modules mirror bash scripts 1:1 using the same conventions established in Phase 1. Hook scripts output the same JSON format for Claude Code integration.

**Tech Stack:** PowerShell 5.1+, Markdown, GitHub Actions CI

---

## Batch 1: README Restructure + Doc Extraction

### Task 1: Extract AI Agent Implementation Guide to docs/

**Files:**

- Create: `docs/ai-agent-guide.md`
- Modify: `README.md`

**Step 1: Create docs/ai-agent-guide.md**

Copy the entire "AI Agent Implementation Guide" section from README.md (from the `---` separator + `## 🤖 AI Agent Implementation Guide` heading through the end of the "When Uncertain" subsection, ending before the next `---`) into `docs/ai-agent-guide.md`. Add a title and back-link:

```markdown
# AI Agent Implementation Guide

> This guide is for LLMs and AI agents working with APS.
> For human-readable docs, see the [README](../README.md).
```

Then paste the full content (Quick Decision Tree, Core Principles, Initialization/Planning/Execution Workflows, File Reading Priority, Common Scenarios, Anti-Patterns, Prompt Entry Points, Self-Check Questions, When Uncertain).

**Step 2: Replace the section in README.md**

Replace the entire AI Agent section (from `---` before it through `---` after it) with:

```markdown
## AI Guidance

APS includes `aps-rules.md` — a portable guide that travels with your specs.
Point your AI agent at this file and it will follow APS conventions.

- [AI Agent Implementation Guide](docs/ai-agent-guide.md) — Full guide for LLMs
- [Prompts](docs/ai/prompting/) — Tool-agnostic prompts
- [AGENTS.md](AGENTS.md) — Collaboration rules for this repo
```

**Step 3: Verify**

Run: `markdownlint README.md docs/ai-agent-guide.md`
Expected: No errors

**Step 4: Commit**

```bash
git add docs/ai-agent-guide.md README.md
git commit -m "docs: extract AI agent guide from README to docs/"
```

### Task 2: Create docs/installation.md

**Files:**

- Create: `docs/installation.md`

**Step 1: Write docs/installation.md**

Consolidate all installation content into one doc:

```markdown
# Installation

## Quick Install (Linux/macOS)

\`\`\`bash
curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/install | bash
\`\`\`

## Install Options

\`\`\`bash
# Install in a specific directory
curl -fsSL .../scaffold/install | bash -s -- /path/to/project

# Install a specific version
curl -fsSL .../scaffold/install | VERSION=v0.2.0 bash
\`\`\`

## Update Existing Project

\`\`\`bash
curl -fsSL .../scaffold/update | bash
\`\`\`

## Windows (PowerShell)

\`\`\`powershell
# Download and run the installer
Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/install.ps1" -UseBasicParsing).Content
\`\`\`

Or use the CLI directly after cloning:
\`\`\`powershell
.\bin\aps.ps1 init
\`\`\`

## Manual Setup

1. Copy templates from `templates/` to your project
2. Create an Index to define your plan's scope and modules
3. Create modules for each bounded area of work
4. Add Work Items when a module is ready for implementation

See [Getting Started](getting-started.md) for a complete walkthrough.

## What Gets Installed

[Tree diagram from scaffold/install output]
```

**Step 2: Commit**

```bash
git add docs/installation.md
git commit -m "docs: add installation guide"
```

### Task 3: Create docs/usage.md

**Files:**

- Create: `docs/usage.md`

**Step 1: Write docs/usage.md**

Consolidate CLI usage, validation details, and CI integration:

```markdown
# CLI Usage

## Commands

\`\`\`bash
aps lint [file|dir]     # Validate APS documents
aps init [dir]          # Create APS structure in a new project
aps update [dir]        # Update templates, skill, and commands
aps --help              # Show help
\`\`\`

## Validation

\`\`\`bash
./bin/aps lint plans/
./bin/aps lint plans/modules/auth.aps.md
./bin/aps lint . --json
\`\`\`

### PowerShell

\`\`\`powershell
.\bin\aps.ps1 lint plans\
.\bin\aps.ps1 lint plans\modules\auth.aps.md
.\bin\aps.ps1 lint plans\ --json
\`\`\`

### What It Checks

[Error/warning codes table]

### CI Integration

[GitHub Actions example from docs/ci-lint-example.yml]

### JSON Output

[Example JSON output]
```

**Step 2: Commit**

```bash
git add docs/usage.md
git commit -m "docs: add CLI usage guide"
```

### Task 4: Restructure README.md

**Files:**

- Modify: `README.md`

**Step 1: Rewrite README with new section order**

New structure:

1. **Title + intro** (keep as-is)
2. **Quick Start** — 2 lines: curl command + link to docs/installation.md
3. **What is APS?** (keep as-is)
4. **Why APS?** (keep as-is, remove the "Want to see APS in action?" callout — Hello World is now right below Hierarchy)
5. **Hierarchy** (keep as-is)
6. **Hello World Example** — pull from old Templates section, make standalone `## Hello World`
7. **Validation** — trim to 2-line example + link to docs/usage.md
8. **Works Everywhere** (keep as-is)
9. **Templates** — table only, no Hello World
10. **Examples** (keep as-is)
11. **Platform Support** (keep as-is from current README, will update in PS port tasks)
12. **AI Guidance** — already replaced in Task 1
13. **Philosophy: Compound Engineering** — moved from old position 3
14. **Principles** (keep as-is)
15. **Project Structure** (keep as-is)
16. **Versioning / Roadmap / Contributing / License** (keep as-is)

**Step 2: Verify**

Run: `markdownlint README.md`
Expected: No errors

**Step 3: Commit**

```bash
git add README.md
git commit -m "docs: restructure README — quick start at top, push details to docs"
```

---

## Batch 2: PowerShell Scaffold Module + CLI Commands

### Task 5: Create lib/Scaffold.psm1

**Files:**

- Create: `lib/Scaffold.psm1`

**Step 1: Write Scaffold.psm1**

Port `lib/scaffold.sh` to PowerShell. Key mappings:

| Bash | PowerShell |
|------|------------|
| `curl -fsSL "$url" -o "$dest"` | `Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing` |
| `mkdir -p "$(dirname "$dest")"` | `New-Item -ItemType Directory -Path (Split-Path $dest) -Force` |
| `chmod +x` | Not needed on Windows |
| `read -r answer` | `Read-Host` |
| `command -v direnv` | `Get-Command direnv -ErrorAction SilentlyContinue` |
| `grep -q 'pattern' file` | `(Get-Content file) -cmatch 'pattern'` |
| Bash arrays (`PLAN_FILES=()`) | PowerShell arrays (`$PlanFiles = @()`) |
| `"${f#scaffold/plans/}"` | `$f -creplace '^scaffold/plans/',''` |

Functions to implement:

- `Invoke-ApsDownload` — download a file from GitHub
- `Invoke-ApsDownloadRoot` — download from repo root (for bin/lib files)
- `Install-ApsPlans` — download plan templates
- `Install-ApsIndex` — download index template (init only)
- `Install-ApsSkill` — download skill files
- `Install-ApsCommands` — download slash commands
- `Install-ApsCli` — download CLI files (include PS files too)
- `Invoke-ApsInit` — full init workflow
- `Invoke-ApsUpdate` — full update workflow

Note: The PS version should download PS files in addition to bash files for the CLI install. Add to CLI_FILES:

- `bin/aps.ps1`
- `lib/Output.psm1`, `lib/Lint.psm1`, `lib/Scaffold.psm1`
- `lib/rules/Common.psm1`, `lib/rules/Module.psm1`, `lib/rules/Index.psm1`, `lib/rules/WorkItem.psm1`, `lib/rules/Issues.psm1`

Interactive prompts: use `Read-Host` for yes/no questions. Non-interactive (piped) mode uses defaults.

**Step 2: Commit**

```bash
git add lib/Scaffold.psm1
git commit -m "feat: add PowerShell scaffold module (port of scaffold.sh)"
```

### Task 6: Update bin/aps.ps1 with init and update commands

**Files:**

- Modify: `bin/aps.ps1`

**Step 1: Add Scaffold.psm1 import**

Add after the existing Import-Module lines:

```powershell
Import-Module (Join-Path $LibDir "Scaffold.psm1") -Force -Global
```

**Step 2: Add init and update help functions**

Add `Show-InitHelp` and `Show-UpdateHelp` functions.

**Step 3: Add init and update command functions**

Add `Invoke-InitCommand` and `Invoke-UpdateCommand` that parse arguments and call `Invoke-ApsInit`/`Invoke-ApsUpdate`.

**Step 4: Update main dispatch switch**

Add `"init"` and `"update"` cases.

**Step 5: Update help text**

Add `init` and `update` to the `Show-Help` output.

**Step 6: Verify**

Run: `/tmp/pwsh/pwsh -Command "& ./bin/aps.ps1 --help"`
Expected: Shows init, update, lint commands

**Step 7: Commit**

```bash
git add bin/aps.ps1
git commit -m "feat: add init and update commands to aps.ps1"
```

---

## Batch 3: PowerShell Hook Scripts

### Task 7: Port pre-tool-check.sh and post-tool-nudge.sh

**Files:**

- Create: `scaffold/aps-planning/scripts/pre-tool-check.ps1`
- Create: `scaffold/aps-planning/scripts/post-tool-nudge.ps1`

These are the simplest hooks — just check if plans/ exists and output JSON.

**Step 1: Write pre-tool-check.ps1**

```powershell
# APS PreToolUse Hook
if ((Test-Path plans) -and ((Test-Path plans/index.aps.md) -or (Test-Path plans/modules))) {
    Write-Output '{"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"[APS] Re-read your current work item before making changes. Are you still on-plan?"}}'
}
exit 0
```

**Step 2: Write post-tool-nudge.ps1**

```powershell
# APS PostToolUse Hook
if (Test-Path plans) {
    Write-Output '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"[APS] If you completed a work item or discovered new scope, update the APS spec now."}}'
}
exit 0
```

**Step 3: Commit**

```bash
git add scaffold/aps-planning/scripts/pre-tool-check.ps1 scaffold/aps-planning/scripts/post-tool-nudge.ps1
git commit -m "feat: add PowerShell PreToolUse and PostToolUse hook scripts"
```

### Task 8: Port init-session.sh

**Files:**

- Create: `scaffold/aps-planning/scripts/init-session.ps1`

Port the session initializer. Key mappings:

- `head -5 file | grep '^# '` → `(Get-Content file -TotalCount 5) -cmatch '^# '`
- `for f in dir/*.aps.md` → `Get-ChildItem -Path dir -Filter *.aps.md`
- `grep -qi '| *Ready *|'` → `(Get-Content file) -cmatch '\| *Ready *\|'`
- `basename "$f"` → `Split-Path $f -Leaf`
- `git rev-parse HEAD` → same (git works on Windows)

Outputs planning status summary and saves session baseline to `.claude/.aps-session-baseline`.

**Step 1: Write init-session.ps1**

Full port with color output via Write-Host.

**Step 2: Commit**

```bash
git add scaffold/aps-planning/scripts/init-session.ps1
git commit -m "feat: add PowerShell SessionStart hook script"
```

### Task 9: Port check-complete.sh

**Files:**

- Create: `scaffold/aps-planning/scripts/check-complete.ps1`

Port the completion checker. Key mappings:

- `grep -qE '^### [A-Z]+-[0-9]+:'` → `-cmatch '^### [A-Z]+-[0-9]+:'`
- `grep -qiE 'Status.*In Progress'` → `-cmatch 'Status.*In Progress'`(case-sensitive here since we control the format)
- `grep -c '^ *- \[ \]'` → count unchecked checkboxes via `-cmatch`
- Exit code 2 blocks Claude; stderr goes to Claude

**Step 1: Write check-complete.ps1**

Full port. Use `[Console]::Error.WriteLine()` for stderr output.

**Step 2: Commit**

```bash
git add scaffold/aps-planning/scripts/check-complete.ps1
git commit -m "feat: add PowerShell Stop hook (completion check)"
```

### Task 10: Port enforce-plan-update.sh

**Files:**

- Create: `scaffold/aps-planning/scripts/enforce-plan-update.ps1`

Port the plan update enforcer. Key mappings:

- `git diff --name-only` → same (git works on Windows)
- `git ls-files --others --exclude-standard` → same
- `cat .claude/.aps-session-baseline` → `Get-Content`
- `sort -u` → `Sort-Object -Unique`
- `grep -E "^plans/"` → `-cmatch '^plans/'`

**Step 1: Write enforce-plan-update.ps1**

Full port. Exit 2 + stderr when code changed but plans not updated.

**Step 2: Commit**

```bash
git add scaffold/aps-planning/scripts/enforce-plan-update.ps1
git commit -m "feat: add PowerShell Stop hook (plan update enforcement)"
```

---

## Batch 4: Hook Installer + Standalone Installers

### Task 11: Port install-hooks.sh

**Files:**

- Create: `scaffold/aps-planning/scripts/install-hooks.ps1`

The bash version uses embedded Python for JSON manipulation. PowerShell has native JSON support (`ConvertFrom-Json` / `ConvertTo-Json`), so no Python dependency needed.

Key mappings:

- `python3` embedded script → native PowerShell JSON ops
- `grep -q 'pattern' file` → `(Get-Content file) -cmatch 'pattern'`
- `chmod +x` → not needed

Modes: `--full` (default), `--minimal`, `--remove`

The PS version writes the same hook structure to `.claude/settings.local.json` but points to `.ps1` files instead of `.sh` files. The hooks JSON structure is identical.

**Step 1: Write install-hooks.ps1**

Full port. Three modes: full, minimal, remove. Uses `ConvertFrom-Json`/`ConvertTo-Json` for safe JSON merge.

**Step 2: Commit**

```bash
git add scaffold/aps-planning/scripts/install-hooks.ps1
git commit -m "feat: add PowerShell hook installer (no Python dependency)"
```

### Task 12: Create scaffold/install.ps1

**Files:**

- Create: `scaffold/install.ps1`

Port of `scaffold/install`. Key differences:

- Uses `Invoke-WebRequest` instead of `curl`
- No `chmod +x` needed
- PATH setup: suggests adding `bin\` to `$env:PATH` instead of direnv
- Downloads both bash and PS CLI files
- Hook prompt calls `install-hooks.ps1` instead of `install-hooks.sh`

**Step 1: Write scaffold/install.ps1**

Self-contained script (doesn't use Scaffold.psm1 — it's a standalone one-liner installer). Downloads everything and sets up the project.

**Step 2: Commit**

```bash
git add scaffold/install.ps1
git commit -m "feat: add PowerShell one-liner installer"
```

### Task 13: Create scaffold/update.ps1

**Files:**

- Create: `scaffold/update.ps1`

Port of `scaffold/update`. Same approach as install.ps1 but preserves user specs.

**Step 1: Write scaffold/update.ps1**

Self-contained updater script.

**Step 2: Commit**

```bash
git add scaffold/update.ps1
git commit -m "feat: add PowerShell one-liner updater"
```

---

## Batch 5: Update Platform Support + Final Integration

### Task 14: Update README Platform Support table and scaffold downloads

**Files:**

- Modify: `README.md` — Update Platform Support table
- Modify: `scaffold/install` — Add PS files to download list
- Modify: `scaffold/update` — Add PS files to download list

**Step 1: Update Platform Support table**

Change:

```markdown
| **Windows** | PowerShell 5.1+ | Coming soon | Manual setup |
```

To:

```markdown
| **Windows** | PowerShell 5.1+ | PowerShell 5.1+ | `Invoke-Expression (irm ...)` |
```

**Step 2: Update scaffold/install bash script**

Add PowerShell CLI files to the download loop so bash `install` also installs PS files:

- `bin/aps.ps1`
- `lib/Output.psm1`, `lib/Lint.psm1`, `lib/Scaffold.psm1`
- `lib/rules/Common.psm1`, `lib/rules/Module.psm1`, `lib/rules/Index.psm1`, `lib/rules/WorkItem.psm1`, `lib/rules/Issues.psm1`

Add PowerShell hook scripts to the skill download section:

- All 6 `.ps1` hook scripts

**Step 3: Update scaffold/update bash script**

Same additions as install.

**Step 4: Verify**

Run: `markdownlint README.md`
Expected: No errors

Run: `bash test/run.sh`
Expected: 15/15 pass

Run: `/tmp/pwsh/pwsh -Command "& ./bin/aps.ps1 lint plans/"`
Expected: All pass

**Step 5: Commit**

```bash
git add README.md scaffold/install scaffold/update
git commit -m "feat: update platform support, add PS files to scaffold downloads"
```

### Task 15: Verification

**Step 1: Run all bash tests**

```bash
bash test/run.sh
```

Expected: 15/15 pass

**Step 2: Run PowerShell lint tests**

```bash
/tmp/pwsh/pwsh -Command "& ./bin/aps.ps1 lint plans/"
/tmp/pwsh/pwsh -Command "& ./bin/aps.ps1 lint test/fixtures/valid/"
/tmp/pwsh/pwsh -Command "& ./bin/aps.ps1 lint test/fixtures/invalid/"
/tmp/pwsh/pwsh -Command "& ./bin/aps.ps1 lint plans/ --json"
```

Expected: Same results as bash version

**Step 3: Test PS help**

```bash
/tmp/pwsh/pwsh -Command "& ./bin/aps.ps1 --help"
```

Expected: Shows init, update, lint commands

**Step 4: Test PS hook scripts**

```bash
/tmp/pwsh/pwsh -Command "& ./scaffold/aps-planning/scripts/pre-tool-check.ps1"
/tmp/pwsh/pwsh -Command "& ./scaffold/aps-planning/scripts/post-tool-nudge.ps1"
/tmp/pwsh/pwsh -Command "& ./scaffold/aps-planning/scripts/init-session.ps1"
```

Expected: JSON output for pre/post tool, status summary for init-session

**Step 5: Verify markdown lint**

```bash
markdownlint README.md docs/installation.md docs/usage.md docs/ai-agent-guide.md
```

Expected: No errors

**Step 6: Mark complete or fix issues**
