# Scaffold Module

| ID | Owner | Status |
|----|-------|--------|
| SCAFFOLD | @aneki | Complete |

## Purpose

Provide one-command setup that copies APS templates and agent guidance into any project, eliminating manual file copying and folder creation.

## In Scope

- Shell script for local/remote execution
- Directory structure creation (plans/, modules/, execution/, decisions/)
- Template copying with agent guidance (aps-rules.md)
- Clear post-setup instructions

## Out of Scope

- Interactive prompts or configuration
- Modifying existing user spec files (.aps.md)

## Interfaces

**Depends on:**

- None

**Exposes:**

- `scaffold/init.sh` — executable script
- `scaffold/plans/` — source templates for copying

## Ready Checklist

- [x] Purpose and scope are clear
- [x] Dependencies identified (none)
- [x] At least one work item defined

## Work Items

### SCAFFOLD-001: Create scaffold directory structure

- **Intent:** Establish source files that init.sh will copy to target projects
- **Expected Outcome:** scaffold/plans/ contains aps-rules.md, index template, module templates, actions template
- **Validation:** `ls scaffold/plans/` shows all expected files
- **Confidence:** high
- **Status:** ✓ Complete

### SCAFFOLD-002: Create init.sh script

- **Intent:** One-command setup for new APS users
- **Expected Outcome:** Script creates plans/ structure and copies templates
- **Validation:** `./scaffold/init.sh /tmp/test && ls /tmp/test/plans/` shows structure
- **Confidence:** high
- **Status:** ✓ Complete

### SCAFFOLD-003: Support remote execution via curl

- **Intent:** Users can run init without cloning the repo
- **Expected Outcome:** `curl ... | bash` downloads and executes correctly
- **Validation:** Manual test after pushing to main branch
- **Confidence:** medium
- **Status:** ✓ Complete

### SCAFFOLD-004: Add --update flag to refresh templates

- **Intent:** Allow users to get latest templates without losing their specs
- **Expected Outcome:** `init.sh --update` overwrites .template.md files and aps-rules.md but preserves user's .aps.md files
- **Validation:** Run --update in existing project; templates refresh, index.aps.md unchanged
- **Confidence:** high
- **Status:** ✓ Complete

## Execution

Action Plan: Not needed — all work items complete

## Notes

- Script detects local vs remote mode automatically
- Refuses to overwrite existing plans/ directory
