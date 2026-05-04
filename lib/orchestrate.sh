#!/usr/bin/env bash
#
# APS orchestration commands
#

declare -a ORCH_ITEM_IDS=()
declare -a ORCH_ITEM_TITLES=()
declare -a ORCH_ITEM_STATUSES=()
declare -a ORCH_ITEM_DEPS=()
declare -a ORCH_ITEM_MODULES=()
declare -a ORCH_ITEM_FILES=()
declare -A ORCH_MODULE_STATUSES=()

orch_reset_state() {
  ORCH_ITEM_IDS=()
  ORCH_ITEM_TITLES=()
  ORCH_ITEM_STATUSES=()
  ORCH_ITEM_DEPS=()
  ORCH_ITEM_MODULES=()
  ORCH_ITEM_FILES=()
  ORCH_MODULE_STATUSES=()
}

orch_trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

orch_field_value() {
  local content="$1"
  local field="$2"

  printf '%s\n' "$content" | awk -v field="$field" '
    $0 ~ "^- \\*\\*" field ":\\*\\*" {
      sub("^- \\*\\*" field ":\\*\\*[[:space:]]*", "")
      if ($0 != "") print
      found = 1
      next
    }
    found && /^[[:space:]]+[^[:space:]]/ {
      gsub(/^[[:space:]]+/, "")
      sub(/^- /, "")
      print
      next
    }
    found { exit }
  '
}

orch_item_content() {
  local file="$1"
  local start_line="$2"

  awk -v start="$start_line" '
    NR == start { found=1; next }
    found && /^### / { exit }
    found { print }
  ' "$file"
}

orch_normalize_status() {
  local raw="$1"
  local fallback="${2:-Ready}"

  [[ -z "$raw" ]] && echo "$fallback" && return
  raw=$(printf '%s' "$raw" | sed -E 's/^[^A-Za-z]+//')

  case "$raw" in
    Complete*) echo "Complete" ;;
    "In Progress"*) echo "In Progress" ;;
    Ready*) echo "Ready" ;;
    Draft*) echo "Draft" ;;
    Blocked*) echo "Blocked" ;;
    *) echo "Unknown" ;;
  esac
}

orch_item_matches_module() {
  local item_index="$1"
  local filter="$2"

  [[ -z "$filter" ]] && return 0

  local file="${ORCH_ITEM_FILES[$item_index]}"
  local module_id="${ORCH_ITEM_MODULES[$item_index]}"
  local base
  base=$(basename "$file" .aps.md)

  [[ "${module_id,,}" == "${filter,,}" || "${base,,}" == "${filter,,}" ]]
}

orch_load_index_modules() {
  local plan_root="$1"
  local index_file="$plan_root/index.aps.md"

  [[ -f "$index_file" ]] || return 0

  while IFS='|' read -r module status; do
    ORCH_MODULE_STATUSES["$module"]="$status"
  done < <(awk -F '|' '
    /^\| *\[/ {
      module = $2
      status = $4
      gsub(/.*\[/, "", module)
      gsub(/\].*/, "", module)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", status)
      if (module != "" && status != "") print toupper(module) "|" status
    }
  ' "$index_file")
}

orch_load_work_items() {
  local plan_root="$1"
  local module_dir="$plan_root/modules"

  [[ -d "$module_dir" ]] || return 1

  local file
  while IFS= read -r file; do
    local module_id module_status
    module_id=$(get_module_id "$file")
    module_status=$(get_status "$file")
    module_status=$(orch_normalize_status "$module_status" "Draft")

    [[ -n "$module_id" ]] || module_id=$(basename "$file" .aps.md | tr '[:lower:]' '[:upper:]')
    ORCH_MODULE_STATUSES["$module_id"]="$module_status"

    [[ "$module_status" == "Complete" || "$module_status" == "Draft" || "$module_status" == "Blocked" ]] && continue

    while IFS=: read -r line_num header; do
      [[ -n "$header" ]] || continue

      local id title content status deps
      header=$(orch_trim "$header")
      id=$(printf '%s\n' "$header" | sed -E 's/^### ([A-Za-z]+-[0-9]+):.*/\1/')
      title=$(printf '%s\n' "$header" | sed -E 's/^### [A-Za-z]+-[0-9]+:[[:space:]]*//; s/[[:space:]]+[^[:alnum:][:space:]]+[[:space:]]+Complete.*$//')
      content=$(orch_item_content "$file" "$line_num")
      status=$(orch_field_value "$content" "Status")

      if [[ -z "$status" && "$header" == *"Complete"* ]]; then
        status="Complete"
      fi

      status=$(orch_normalize_status "$status" "Ready")
      deps=$(orch_field_value "$content" "Dependencies")

      ORCH_ITEM_IDS+=("$id")
      ORCH_ITEM_TITLES+=("$title")
      ORCH_ITEM_STATUSES+=("$status")
      ORCH_ITEM_DEPS+=("$deps")
      ORCH_ITEM_MODULES+=("$module_id")
      ORCH_ITEM_FILES+=("$file")
    done <<< "$(get_work_items "$file")"
  done < <(find "$module_dir" -type f -name "*.aps.md" ! -name ".*" 2>/dev/null | sort)
}

orch_item_index() {
  local id="$1"
  local i

  for i in "${!ORCH_ITEM_IDS[@]}"; do
    [[ "${ORCH_ITEM_IDS[$i]}" == "$id" ]] && echo "$i" && return 0
  done

  return 1
}

orch_dependency_complete() {
  local dep="$1"

  if [[ "$dep" =~ ^[A-Z]+-[0-9]+$ ]]; then
    # Decision dependencies (D-NNN) are resolved in the plan text, not as work items.
    [[ "$dep" == D-* ]] && return 0

    local idx
    idx=$(orch_item_index "$dep" || true)
    [[ -n "$idx" && "${ORCH_ITEM_STATUSES[$idx]}" == "Complete" ]]
    return
  fi

  local module_status="${ORCH_MODULE_STATUSES[$dep]:-}"
  [[ "$module_status" == "Complete" ]]
}

orch_deps_complete() {
  local deps="$1"
  local dep_ids=()
  local dep

  [[ -z "$deps" || "$deps" == "None" || "$deps" == "-" ]] && return 0
  [[ ! "$deps" =~ [[:alnum:]] ]] && return 0

  while IFS= read -r dep; do
    [[ -n "$dep" ]] && dep_ids+=("$dep")
  done < <(printf '%s\n' "$deps" | grep -oE '[A-Z]+-[0-9]+|[A-Z]{2,}' || true)

  [[ ${#dep_ids[@]} -eq 0 ]] && return 1

  for dep in "${dep_ids[@]}"; do
    orch_dependency_complete "$dep" || return 1
  done

  return 0
}

orch_deps_display() {
  local deps="$1"

  deps=${deps//$'\n'/, }
  echo "${deps:-None}"
}

cmd_next() {
  local plan_root="plans"
  local module_filter=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --plans)
        plan_root="${2:-}"
        [[ -n "$plan_root" ]] || { error "--plans requires a directory"; return 1; }
        shift 2
        ;;
      --help|-h)
        cat <<EOF
Usage: aps next [module] [options]

Show the next Ready work item whose dependencies are Complete.

Arguments:
  module    Optional module ID or module file name, e.g. AUTH or auth

Options:
  --plans DIR  Plan root directory (default: plans)
  --help       Show this help
EOF
        return 0
        ;;
      -*)
        error "Unknown option: $1"
        return 1
        ;;
      *)
        module_filter="$1"
        shift
        ;;
    esac
  done

  if [[ ! -d "$plan_root" ]]; then
    error "Path not found: $plan_root"
    return 1
  fi

  orch_reset_state
  orch_load_index_modules "$plan_root"
  orch_load_work_items "$plan_root" || {
    error "No modules directory found: $plan_root/modules"
    return 1
  }

  local i
  for i in "${!ORCH_ITEM_IDS[@]}"; do
    orch_item_matches_module "$i" "$module_filter" || continue
    [[ "${ORCH_ITEM_STATUSES[$i]}" == "Ready" ]] || continue
    orch_deps_complete "${ORCH_ITEM_DEPS[$i]}" || continue

    echo "${ORCH_ITEM_IDS[$i]}: ${ORCH_ITEM_TITLES[$i]}"
    echo "Module: ${ORCH_ITEM_MODULES[$i]} | Dependencies: $(orch_deps_display "${ORCH_ITEM_DEPS[$i]}") | Status: ${ORCH_ITEM_STATUSES[$i]}"
    echo "File: ${ORCH_ITEM_FILES[$i]}"
    return 0
  done

  if [[ -n "$module_filter" ]]; then
    warn "No ready work item found for module: $module_filter"
  else
    warn "No ready work item found"
  fi
  return 1
}
