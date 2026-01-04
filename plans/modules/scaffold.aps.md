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

- npm/npx package (future consideration)
- Interactive prompts or configuration
- Modifying existing files in target repo

## Interfaces

**Depends on:**

- None

**Exposes:**

- `scaffold/init.sh` — executable script
- `scaffold/plans/` — source templates for copying

## Ready Checklist

- [x] Purpose and scope are clear
- [x] Dependencies identified (none)
- [x] At least one task defined

## Tasks

### SCAFFOLD-001: Create scaffold directory structure

- **Intent:** Establish source files that init.sh will copy to target projects
- **Expected Outcome:** scaffold/plans/ contains aps-rules.md, index template, module templates, steps template
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
- **Non-scope:** Cannot test until deployed

## Execution

Steps: [../execution/SCAFFOLD.steps.md](../execution/SCAFFOLD.steps.md) *(not needed — tasks complete)*

## Notes

- Script detects local vs remote mode automatically
- Refuses to overwrite existing plans/ directory
