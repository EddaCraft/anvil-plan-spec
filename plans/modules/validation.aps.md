# Validation Module

| ID | Owner | Status |
|----|-------|--------|
| VAL | @aneki | Complete |

## Purpose

Provide tooling to validate APS documents against expected structure, catching common errors before they cause confusion.

## In Scope

- CLI tool to validate APS markdown files
- Check required fields are present
- Validate task ID format (MODULE-NNN)
- Check dependency references resolve
- Warning on common issues (empty sections, missing checkpoints)

## Out of Scope

- IDE plugins or extensions (separate module)
- Automated fixes or corrections
- Semantic validation (e.g., "is this task well-written?")

## Interfaces

**Depends on:**

- TPL (templates) — validation rules based on template structure ✓ Complete

**Exposes:**

- `aps lint [file|dir]` — CLI command
- Exit codes for CI integration (0 = no errors, may include warnings; 1 = errors)
- JSON output option for tooling

## Ready Checklist

- [x] Purpose and scope are clear
- [x] Dependencies identified (TPL complete)
- [x] At least one task defined

## Work Items

### VAL-001: Define validation rules

- **Intent:** Establish what constitutes a valid APS document before writing code
- **Expected Outcome:** Markdown document listing required fields per template type (index, module, simple, steps)
- **Validation:** File exists at docs/validation-rules.md or plans/decisions/
- **Confidence:** high
- **Status:** ✓ Complete (docs/plans/2026-01-27-validation-cli-design.md)

### VAL-002: Create CLI skeleton

- **Intent:** Establish project structure and basic CLI interface
- **Expected Outcome:** Executable `aps` CLI that accepts `lint` subcommand with file/dir argument
- **Validation:** `./bin/aps lint --help` shows usage
- **Confidence:** high
- **Status:** ✓ Complete

### VAL-003: Implement field presence checks

- **Intent:** Detect missing required fields in APS documents
- **Expected Outcome:** CLI reports errors for missing Status, Purpose, Tasks sections
- **Validation:** Running against malformed test fixture returns non-zero exit
- **Confidence:** high
- **Status:** ✓ Complete

### VAL-004: Implement task ID format validation

- **Intent:** Catch malformed task IDs early (e.g., "Task 1" instead of "MOD-001")
- **Expected Outcome:** CLI warns on task IDs not matching `[A-Z]+-[0-9]{3}` pattern
- **Validation:** Test fixture with bad IDs triggers warning
- **Confidence:** medium
- **Status:** ✓ Complete

### VAL-005: Implement dependency resolution

- **Intent:** Catch broken references to other modules or tasks
- **Expected Outcome:** CLI warns when `Depends on` references non-existent modules
- **Validation:** Test fixture with broken dep triggers warning
- **Confidence:** medium
- **Status:** ✓ Complete (W003 rule for task deps; W002 for module deps deferred)

### VAL-006: Add CI example

- **Intent:** Show users how to run validation in GitHub Actions
- **Expected Outcome:** Example workflow file in docs/ or .github/examples/
- **Validation:** Valid YAML syntax; references aps lint command
- **Confidence:** high
- **Status:** ✓ Complete (docs/ci-lint-example.yml)

## Decisions

- **D-001:** CLI language — *decided: Shell script (bash) for v1, no runtime dependencies*
- **D-002:** Strictness levels — *decided: errors (exit 1) vs warnings (exit 0 with output)*

## Execution

Steps: Not needed — all tasks complete

## Notes

- Start simple with shell/grep — can rewrite in Node later if needed
- JSON Schema approach deferred — overkill for v1
- GitHub Action is a separate deliverable after CLI works
