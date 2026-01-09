# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Purpose

This repo defines the Anvil Plan Spec (APS): a markdown-based specification format for planning and task authorisation in AI-assisted development. It is primarily templates, documentation, examples, and planning specs, not executable application code.

## Key AI & Execution Rules (from `AGENTS.md` and `plans/aps-rules.md`)

- **Specs vs execution**
  - Specs describe **intent** (what and why), not implementation details.
  - **Tasks** are the unit of execution authority. **No task, no implementation** — do not make code-level changes in downstream projects unless there is an explicit task, or the user explicitly instructs you to do so.
  - **Steps** are checkpoints: they record observable states to validate progress, not line-by-line implementation tutorials.
- **When editing APS templates, prompts, or docs in this repo**
  - Keep templates **minimal** and outcome-focused; avoid over-prescription of how to implement.
  - Maintain **consistency** of field names, structure, and terminology across all templates and docs.
  - When changing template structure or conventions, **update examples** and any affected docs/prompts so they stay aligned.
- **Using steps (`*.steps.md`)**
  - Each step has a short checkpoint (max ~12 words) that describes an observable state, optionally with a validation command.
  - Avoid encoding implementation details (APIs, specific libraries, control-flow) in checkpoints; those should emerge from patterns in the target codebase.
  - For deeper guidance on steps, consult `docs/ai/prompting/steps.prompt.md` and `plans/aps-rules.md`.

## Project Structure & Architecture

High-level layout (only the most important parts):

- `README.md`, `CHANGELOG.md`, `ROADMAP.md`, `CONTRIBUTING.md`, `AGENTS.md`
  - Top-level documentation for APS: what it is, why it exists, how to adopt it, and how to collaborate using AI.
- `docs/`
  - Narrative docs explaining how to adopt and work with APS.
  - `docs/getting-started.md` — template selection, manual vs scaffold setup.
  - `docs/workflow.md` — how APS fits into day-to-day development (planning → ready → executing → complete).
  - `docs/ai/prompting/` — **prompt entry points** for AI agents (index, module, task, steps) plus OpenCode/Claude variants under `docs/ai/prompting/opencode/`.
- `templates/`
  - Canonical APS templates used by downstream projects.
  - Includes index, expanded index, module, simple, quickstart, and steps templates.
  - When changing a template here, ensure:
    - Any references in `docs/` (especially `getting-started.md`) still match.
    - Examples under `examples/` remain valid or are updated.
- `examples/`
  - Worked APS specs that show real-world usage (e.g., user authentication, OpenCode companion app).
  - Treat these as executable examples of the spec format; keep them consistent with the current templates and rules.
- `scaffold/`
  - `scaffold/init.sh` plus a `scaffold/plans/` directory containing starter planning files (`aps-rules.md`, `index.aps.md`, and hidden templates for modules/steps).
  - This is the main mechanism for bootstrapping APS into another repo.
- `plans/`
  - APS planning specs **for this repo itself**.
  - `plans/aps-rules.md` — detailed rules for AI agents working with APS specs (naming conventions, hierarchy, step/task rules).
  - `plans/modules/` — modules describing bounded areas of work for maintaining APS (e.g., docs, templates).
  - `plans/execution/*.steps.md` — steps for executing internal APS tasks (e.g., `DOCS.steps.md`).
- `execution/`
  - Reserved for step files that describe execution against this repo directly (separate from `plans/execution/` which is part of the APS spec for this repo). Currently minimal/empty; follow the same lean-steps conventions if new step files are added here.

## Commands & Development Workflow

This repo is markdown- and shell-script–centric; there is no application build or automated test suite. The main development command is markdown linting.

### Linting (markdownlint)

- **Run full-repo lint (preferred before any PR):**

  ```bash
  npx markdownlint-cli "**/*.md"
  ```

- **Narrow lint (used in some steps specs, e.g., `plans/execution/DOCS.steps.md`):**

  ```bash
  npx markdownlint-cli docs/*.md README.md
  ```

- Ensure lint passes after editing any markdown (docs, templates, plans, examples).

### Scaffold script (bootstrapping APS into another project)

From a clone of this repo:

- **Initialise APS in a target project:**

  ```bash
  ./scaffold/init.sh /path/to/your-project
  ```

  This creates a `plans/` directory in the target project with:
  - `aps-rules.md` — portable agent guidance for that project.
  - `index.aps.md` — starting index plan.
  - Hidden templates under `plans/modules/` and `plans/execution/`.

- **Update templates in an existing APS-enabled project (preserving specs):**

  ```bash
  ./scaffold/init.sh --update /path/to/your-project
  ```

  This refreshes `aps-rules.md` and the hidden templates under `plans/` without touching existing `.aps.md` spec files.

- **Remote one-off usage (as documented in `README.md` / `docs/getting-started.md`):**

  ```bash
  curl -fsSL https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/scaffold/init.sh | bash
  ```

### Tests

- There is **no dedicated automated test suite** for this repo.
- Validation is primarily via:
  - `npx markdownlint-cli "**/*.md"` for formatting and style.
  - Ad-hoc commands embedded as `Validate:` lines in `*.steps.md` files (e.g., `grep`, `head`, `test -f`) for specific documentation tasks.

## How Warp Should Work Here

- When asked to **modify APS templates** (`templates/`) or **agent prompts** (`docs/ai/prompting/`):
  - Keep changes minimal and aligned with the existing APS hierarchy and terminology.
  - Cross-check `docs/`, `examples/`, and `plans/aps-rules.md` so everything stays consistent.
- When asked to **update examples** under `examples/`:
  - Treat them as consumers of the templates; ensure field names and structure mirror the latest templates and rules.
- When working with **`plans/` for this repo**:
  - Respect the APS hierarchy and rules in `plans/aps-rules.md`.
  - Only create or update tasks/steps when explicitly asked to plan or execute work.
- Before suggesting or finalising changes to markdown content, **run markdownlint** with one of the commands above and ensure it passes (or clearly note to the user if it does not).
