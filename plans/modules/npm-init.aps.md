# NPM Init Command Module

| ID | Owner | Priority | Status |
|----|-------|----------|--------|
| INIT | @aneki | high | Ready |

## Purpose

Provide a zero-friction npm-based initialization command that scaffolds APS structure in any project, making APS accessible to the npm ecosystem without requiring git clone or curl commands.

## In Scope

- npm package publishable to registry
- `npm init aps` / `npx create-aps` command support
- Interactive prompts for project setup decisions
- Scaffold generation (directories, templates, aps-rules.md)
- Feature parity with existing `scaffold/init.sh`
- `--update` flag to refresh templates without overwriting specs

## Out of Scope

- IDE plugins or editor integrations (separate module)
- CLI subcommands beyond init (e.g., `aps lint` is in VAL module)
- Runtime dependencies for validation (keeping APS zero-dependency)
- Hosted template registry or template marketplace

## Interfaces

**Depends on:**

- TPL (templates) — copies templates into user projects ✓ Complete
- Documentation structure — for post-init guidance ✓ Complete

**Exposes:**

- `npm init aps [directory]` — standard npm init pattern
- `npx create-aps [directory]` — create-* pattern for npx
- `npx create-aps --update` — refresh templates in existing project
- JSON configuration file for non-interactive mode

## Constraints

- Must remain lightweight (minimal npm dependencies)
- Generated files must be pure markdown (no npm runtime required post-init)
- Must work offline after initial package download
- Should detect existing APS structure and offer update vs overwrite

## Ready Checklist

- [x] Purpose and scope are clear
- [x] Dependencies identified
- [x] At least one work item defined

## Work Items

### INIT-001: Create npm package structure

- **Intent:** Establish project foundation as publishable npm package
- **Expected Outcome:** Package with package.json, bin entry point, basic CLI parser
- **Validation:** `npm pack` succeeds, `npx . --help` shows usage
- **Confidence:** high
- **Files:**
  - `package.json` (name: `create-aps` or `@anvil/create-aps`)
  - `bin/create-aps.js` (CLI entry point)
  - `lib/` (core logic)
  - `.npmignore` (exclude development files)

### INIT-002: Implement interactive prompts

- **Intent:** Guide users through project setup without requiring prior APS knowledge
- **Expected Outcome:** Interactive CLI asks for project type, creates appropriate structure
- **Validation:** Running without flags shows prompts; selections affect generated files
- **Confidence:** high
- **Prompts to include:**
  - Project size (quickstart / single module / multi-module / large initiative)
  - Project name (for index.aps.md title)
  - Module ID prefix (if applicable)
  - Include examples? (yes/no)
  - Include decision log template? (yes/no)

### INIT-003: Implement directory and file scaffolding

- **Intent:** Generate APS structure matching user selections from prompts
- **Expected Outcome:** Creates plans/, plans/modules/, plans/execution/, copies appropriate templates
- **Validation:** Generated structure matches scaffold/init.sh output for equivalent options
- **Confidence:** high
- **Files to generate:**
  - `plans/index.aps.md` (selected template variant)
  - `plans/aps-rules.md` (portable AI guidance)
  - `plans/modules/.module.template.md`
  - `plans/modules/.simple.template.md`
  - `plans/execution/.actions.template.md`
  - `plans/decisions/` (if selected)
  - Optional: example modules if requested

### INIT-004: Implement --update flag behavior

- **Intent:** Allow users to refresh templates in existing projects without losing work
- **Expected Outcome:** Updates .template.md files and aps-rules.md, preserves user's .aps.md files
- **Validation:** Running in existing project updates templates but doesn't touch index.aps.md
- **Confidence:** medium
- **Logic:**
  - Detect existing APS structure (plans/ directory exists)
  - Only overwrite files matching `.template.md` pattern
  - Update `aps-rules.md` only if older than package version
  - Show diff summary of what would change (dry-run option)

### INIT-005: Add non-interactive mode with config file

- **Intent:** Support CI/CD and scripted project generation
- **Expected Outcome:** Accepts JSON config file or CLI flags for all options
- **Validation:** `npx create-aps --config aps-init.json` creates structure without prompts
- **Confidence:** medium
- **Config format:**
  ```json
  {
    "projectType": "multi-module",
    "projectName": "My Project",
    "modulePrefix": "PROJ",
    "includeExamples": false,
    "includeDecisions": true,
    "targetDir": "./my-project"
  }
  ```

### INIT-006: Implement directory validation and conflict detection

- **Intent:** Prevent accidental overwrites and provide clear error messages
- **Expected Outcome:** CLI detects existing APS structure, non-empty directories, and prompts accordingly
- **Validation:** Running in non-empty dir shows warning; existing plans/ triggers update mode question
- **Confidence:** high
- **Checks:**
  - Target directory exists and is not empty → warn and confirm
  - `plans/` exists but not APS structure → error with guidance
  - APS structure detected → offer --update mode
  - Git repository detected → remind about .gitignore (if needed)

### INIT-007: Add post-init guidance and next steps

- **Intent:** Help users understand what to do after scaffolding
- **Expected Outcome:** CLI outputs formatted guidance with links and suggested next steps
- **Validation:** Output includes links to getting-started.md and first module prompt
- **Confidence:** high
- **Output includes:**
  - Success message with structure created
  - Link to docs/getting-started.md
  - Reminder to copy aps-rules.md to AI context
  - Example first command (e.g., "Edit plans/index.aps.md to define your first module")
  - Mention of `aps lint` validation (when VAL module is complete)

### INIT-008: Create comprehensive README and documentation

- **Intent:** Provide clear installation and usage instructions for npm users
- **Expected Outcome:** README.md in package with examples, options reference, and migration guide
- **Validation:** README covers all CLI flags, config options, and common scenarios
- **Confidence:** high
- **Sections:**
  - Installation (`npm install -g create-aps` vs `npx`)
  - Quick start (`npm init aps`)
  - Interactive mode walkthrough
  - Non-interactive mode examples
  - Update existing project (`--update`)
  - Migration from scaffold/init.sh
  - Troubleshooting

### INIT-009: Add automated tests for CLI behavior

- **Intent:** Ensure reliability across different project states and options
- **Expected Outcome:** Test suite covering prompt flows, file generation, update mode, error cases
- **Validation:** `npm test` passes with >80% coverage
- **Confidence:** medium
- **Test scenarios:**
  - Fresh init in empty directory
  - Init in existing project (non-APS)
  - Update mode with existing APS files
  - Non-interactive mode with config file
  - Error handling (no write permissions, invalid paths)
  - All project type variations generate correct files

### INIT-010: Publish to npm and update main repository documentation

- **Intent:** Make package available to users and integrate with existing docs
- **Expected Outcome:** Package published to npm, README.md updated with npm instructions
- **Validation:** `npm view create-aps` shows published package; main README shows npm option first
- **Confidence:** high
- **Tasks:**
  - Choose package name (`create-aps` vs `@anvil/create-aps`)
  - Set up npm organization if needed
  - Configure GitHub Actions for automated publishing
  - Update main README.md with npm installation as primary method
  - Update docs/getting-started.md to include npm init flow
  - Add badge showing npm version to main README

## Execution

Action Plan: [../execution/INIT.actions.md](../execution/INIT.actions.md)

## Decisions

- **D-001:** Package name — *pending: `create-aps` (follows npm init convention) vs `@anvil/create-aps` (namespaced, requires organization)*
- **D-002:** Prompt library — *decided: use `prompts` or `inquirer` for interactive CLI (widely adopted, minimal dependencies)*
- **D-003:** Template storage — *decided: bundle templates in npm package at `templates/` directory, same structure as current repo*
- **D-004:** Update mechanism — *decided: version-based, track last applied version in `plans/.aps-version` file*
- **D-005:** Monorepo vs separate repo — *pending: keep in main repo as `packages/create-aps/` vs separate `create-aps` repository*

## Notes

- Feature parity with `scaffold/init.sh` is critical for adoption
- The bash script can remain as lightweight option for curl-based installs
- Consider adding `--dry-run` flag to preview changes before writing files
- Future enhancement: `aps upgrade` command to migrate between template versions
- GitHub template repository could complement npm package for "Use this template" button
- Consider telemetry (opt-in) to understand which project types are most popular
