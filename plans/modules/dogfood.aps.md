# Dogfood Module

| ID      | Owner  | Priority | Status      |
| ------- | ------ | -------- | ----------- |
| DOGFOOD | @aneki | high     | In Progress |

## Purpose

Make this repository a credible APS example by keeping its own roadmap and
module specs accurate, linked, current, and validated.

## Background

The public roadmap referenced modules that did not exist in `plans/modules/`.
That undermines APS as a planning format: users should be able to inspect this
repo and see the same discipline we recommend elsewhere.

## In Scope

- Every linked module in `plans/index.aps.md` has a corresponding module spec
- Active modules include actionable work items with validation
- Completed modules retain concise historical specs rather than disappearing
- Plan updates are included with changes that affect APS templates, prompts,
  examples, installer behavior, or validation behavior
- Markdown linting remains the baseline verification for plan edits

## Out of Scope

- Rewriting historical completed modules in exhaustive detail
- Replacing the roadmap with generated output
- Implementing ORCH automation before ORCH work is selected

## Interfaces

**Depends on:**

- VAL — plan files must be lintable

**Exposes:**

- `plans/index.aps.md` as the authoritative roadmap
- `plans/modules/*.aps.md` as the complete module registry

## Ready Checklist

- [x] Purpose and scope are clear
- [x] Dependencies identified
- [x] Decisions resolved
- [x] Work items defined with validation

## Work Items

### DOGFOOD-001: Reconcile roadmap module links — In Progress

- **Intent:** Remove broken plan references from the public roadmap
- **Expected Outcome:** Every markdown link in the Modules tables points to an
  existing module spec, and every active module has a current status.
- **Validation:** `./bin/aps lint plans && npx markdownlint-cli "plans/**/*.md"`
- **Files:** plans/index.aps.md, plans/modules/\*.aps.md
- **Confidence:** high

### DOGFOOD-002: Define plan hygiene checks — Ready

- **Intent:** Make stale APS plans detectable before they drift again
- **Expected Outcome:** A documented checklist or lint enhancement verifies
  index-to-module link integrity, active work item status, and required
  validation fields for non-complete work.
- **Validation:** Check runs locally and fails on a deliberately broken module
  link in a fixture or temporary test project
- **Files:** lib/lint.sh, lib/Lint.psm1, test/fixtures/, docs/workflow.md
- **Confidence:** medium
- **Dependencies:** DOGFOOD-001

### DOGFOOD-003: Add contribution guidance for APS plan updates — Ready

- **Intent:** Make plan updates part of normal repo contribution hygiene
- **Expected Outcome:** `AGENTS.md` and contributor docs say when APS plan files
  must be updated, how to mark work item status, and what validation to run.
- **Validation:** `npx markdownlint-cli "AGENTS.md" "CONTRIBUTING.md" "docs/**/*.md"`
- **Files:** AGENTS.md, CONTRIBUTING.md, docs/workflow.md
- **Confidence:** high
- **Dependencies:** DOGFOOD-001
