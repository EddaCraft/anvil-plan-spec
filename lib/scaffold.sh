#!/usr/bin/env bash
#
# Scaffold logic for `aps init` and `aps update`
#

APS_VERSION="${APS_VERSION:-main}"
APS_BASE_URL="https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/$APS_VERSION/scaffold"

# Files to download for plans/
PLAN_FILES=(
  "plans/aps-rules.md"
  "plans/modules/.module.template.md"
  "plans/modules/.simple.template.md"
  "plans/modules/.index-monorepo.template.md"
  "plans/execution/.steps.template.md"
)

# Files to download for the planning skill
SKILL_FILES=(
  "aps-planning/SKILL.md"
  "aps-planning/reference.md"
  "aps-planning/examples.md"
  "aps-planning/hooks.md"
  "aps-planning/scripts/install-hooks.sh"
  "aps-planning/scripts/init-session.sh"
  "aps-planning/scripts/check-complete.sh"
)

# Files to download for slash commands
COMMAND_FILES=(
  "commands/plan.md"
  "commands/plan-status.md"
)

# Download a file from GitHub
download() {
  local src="$1"
  local dest="$2"
  local url="$APS_BASE_URL/$src"

  mkdir -p "$(dirname "$dest")"
  if ! curl -fsSL "$url" -o "$dest"; then
    error "Failed to download: $url"
    echo "  Check your network and ensure APS_VERSION='$APS_VERSION' is valid." >&2
    exit 1
  fi
}

# Prompt user with a yes/no question. Returns 0 for yes, 1 for no.
# Non-interactive defaults to the provided default.
ask_yn() {
  local prompt="$1"
  local default="${2:-n}"

  if [[ -t 0 ]]; then
    local yn_hint
    if [[ "$default" == "y" ]]; then yn_hint="Y/n"; else yn_hint="y/N"; fi
    printf "%s [%s] " "$prompt" "$yn_hint"
    read -r answer
    answer="${answer:-$default}"
    [[ "$answer" =~ ^[Yy] ]]
  else
    [[ "$default" == "y" ]]
  fi
}

# Check if APS hooks are already configured
has_aps_hooks() {
  local target="${1:-.}"
  local settings="$target/.claude/settings.local.json"
  [[ -f "$settings" ]] && grep -q 'aps-planning/scripts\|\[APS\]' "$settings" 2>/dev/null
}

# Download plan templates to target
install_plans() {
  local target="$1"
  local plans_dir="$target/plans"

  mkdir -p "$plans_dir/modules" "$plans_dir/execution" "$plans_dir/decisions"

  for f in "${PLAN_FILES[@]}"; do
    download "$f" "$plans_dir/${f#plans/}"
  done
}

# Download the index template (init only, not update)
install_index() {
  local target="$1"
  download "plans/index.aps.md" "$target/plans/index.aps.md"
  touch "$target/plans/decisions/.gitkeep"
}

# Download skill files to target
install_skill() {
  local target="$1"

  for f in "${SKILL_FILES[@]}"; do
    download "$f" "$target/$f"
  done
  chmod +x "$target/aps-planning/scripts/"*.sh
}

# Download slash commands to .claude/commands/
install_commands() {
  local target="$1"
  local commands_dir="$target/.claude/commands"

  mkdir -p "$commands_dir"
  for f in "${COMMAND_FILES[@]}"; do
    download "$f" "$commands_dir/${f#commands/}"
  done
}

# Two-step hook prompt
prompt_hooks() {
  local target="$1"

  echo ""
  if ask_yn "Install APS hooks into .claude/settings.local.json?" "y"; then
    (cd "$target" && bash aps-planning/scripts/install-hooks.sh)
  else
    if ask_yn "Would you like me to copy them for you to install/review later?" "y"; then
      info "Hook scripts are at: aps-planning/scripts/"
      echo "  Run ./aps-planning/scripts/install-hooks.sh when ready"
      echo "  See aps-planning/hooks.md for what each hook does"
    else
      info "Skipping hooks. You can install them later:"
      echo "  ./aps-planning/scripts/install-hooks.sh"
    fi
  fi
}

# --- Subcommands ---

cmd_init() {
  local target="."

  while [[ $# -gt 0 ]]; do
    case $1 in
      --help|-h) cmd_init_help; exit 0 ;;
      *) target="$1"; shift ;;
    esac
  done

  local plans_dir="$target/plans"

  if [[ -d "$plans_dir" ]]; then
    error "plans/ directory already exists at $target"
    echo ""
    echo "To update an existing project:"
    echo "  aps update"
    echo ""
    echo "To reinstall from scratch:"
    echo "  rm -rf $plans_dir && aps init"
    exit 1
  fi

  echo ""
  info "Initialising APS in $target"
  echo ""

  # Templates and rules
  install_plans "$target"
  install_index "$target"
  info "plans/ (templates, rules, index)"

  # Skill
  install_skill "$target"
  info "aps-planning/ (skill, reference, examples, hooks, scripts)"

  # Commands
  install_commands "$target"
  info ".claude/commands/ (plan, plan-status)"

  echo ""
  echo "  plans/"
  echo "  ├── aps-rules.md                     <- Agent guidance (READ THIS)"
  echo "  ├── index.aps.md                     <- Your main plan (edit this)"
  echo "  ├── modules/"
  echo "  │   ├── .module.template.md          <- Template for modules"
  echo "  │   ├── .simple.template.md          <- Template for small features"
  echo "  │   └── .index-monorepo.template.md  <- Index for monorepos"
  echo "  ├── execution/"
  echo "  │   └── .steps.template.md           <- Template for steps"
  echo "  └── decisions/"
  echo ""
  echo "  aps-planning/"
  echo "  ├── SKILL.md                         <- Planning skill (core rules)"
  echo "  ├── reference.md                     <- APS format reference"
  echo "  ├── examples.md                      <- Real-world examples"
  echo "  ├── hooks.md                         <- Hook configuration guide"
  echo "  └── scripts/                         <- Hook install + session scripts"
  echo ""
  echo "  .claude/commands/"
  echo "  ├── plan.md                          <- /plan command"
  echo "  └── plan-status.md                   <- /plan-status command"

  # Hooks
  prompt_hooks "$target"

  echo ""
  info "Next steps:"
  echo "  1. Edit plans/index.aps.md to define your plan"
  echo "  2. Copy templates to create modules (remove leading dot)"
  echo "  3. Use /plan in Claude Code to start planning"
  echo ""
}

cmd_init_help() {
  cat <<EOF
aps init - Create APS structure in a new project

Usage:
  aps init [target-dir]

Creates plans/, aps-planning/ skill, .claude/commands/, and optionally
installs hooks. Refuses to run if plans/ already exists.

Options:
  --help    Show this help

Environment:
  APS_VERSION   Git ref to download from (default: main)

Examples:
  aps init              # Init in current directory
  aps init ./my-project # Init in a subdirectory
EOF
}

cmd_update() {
  local target="."

  while [[ $# -gt 0 ]]; do
    case $1 in
      --help|-h) cmd_update_help; exit 0 ;;
      *) target="$1"; shift ;;
    esac
  done

  local plans_dir="$target/plans"

  if [[ ! -d "$plans_dir" ]]; then
    error "No plans/ directory found at $target"
    echo ""
    echo "To create a new APS project:"
    echo "  aps init"
    exit 1
  fi

  echo ""
  info "Updating APS in $target"
  echo ""

  # Templates and rules (preserves user specs)
  install_plans "$target"
  info "plans/ (templates, rules)"

  # Skill
  install_skill "$target"
  info "aps-planning/ (skill, reference, examples, hooks, scripts)"

  # Commands
  install_commands "$target"
  info ".claude/commands/ (plan, plan-status)"

  # Hooks: prompt only if not already configured
  if ! has_aps_hooks "$target"; then
    prompt_hooks "$target"
  else
    echo ""
    info "Hooks already configured (not modified)."
    echo "  To update: ./aps-planning/scripts/install-hooks.sh"
  fi

  echo ""
  info "Your specs (index.aps.md, modules/*.aps.md) were NOT modified."
  echo ""
}

cmd_update_help() {
  cat <<EOF
aps update - Update APS templates, skill, and commands

Usage:
  aps update [target-dir]

Updates templates, rules, skill files, and commands without touching
your specs (index.aps.md, modules/*.aps.md, execution/*.actions.md).

If hooks are not yet configured, prompts to install them.

Options:
  --help    Show this help

Environment:
  APS_VERSION   Git ref to download from (default: main)

Examples:
  aps update              # Update current directory
  aps update ./my-project # Update a subdirectory
EOF
}
