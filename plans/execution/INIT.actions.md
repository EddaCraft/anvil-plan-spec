# NPM Init Command - Action Plan

| Module | Status | Updated |
|--------|--------|---------|
| INIT | Not Started | 2026-01-11 |

## Overview

This action plan breaks down the npm init command implementation into observable checkpoints. Each action maps to work items from the module specification.

## Phase 1: Foundation (INIT-001)

### Action 1.1: Create package structure

- [ ] Create `packages/create-aps/` directory (or separate repo based on D-005)
- [ ] Initialize `package.json` with metadata:
  - Name: `create-aps` (or decided alternative)
  - Version: `0.1.0`
  - Description: "Initialize Anvil Plan Spec structure in your project"
  - Keywords: `["aps", "planning", "ai-assisted", "scaffold", "init"]`
  - Repository, homepage, bugs URLs
  - License: MIT (match main repo)
- [ ] Set bin entry point: `"bin": { "create-aps": "./bin/create-aps.js" }`
- [ ] Add npm init alias: `"name": "create-aps"` enables `npm init aps`

**Checkpoint:** `npm pack` creates tarball without errors

### Action 1.2: Create minimal CLI entry point

- [ ] Create `bin/create-aps.js` with shebang `#!/usr/bin/env node`
- [ ] Add basic argument parsing (process.argv or commander/yargs)
- [ ] Implement `--help` and `--version` flags
- [ ] Add `--update` flag (no-op for now, validated in later phase)
- [ ] Make file executable (`chmod +x bin/create-aps.js`)

**Checkpoint:** `node bin/create-aps.js --help` displays usage

### Action 1.3: Set up project tooling

- [ ] Add `.npmignore` to exclude tests, docs, etc.
- [ ] Create basic test structure (Jest or Mocha)
- [ ] Add ESLint config (match main repo standards)
- [ ] Set up package scripts in package.json:
  - `"test"`: run test suite
  - `"lint"`: run ESLint
  - `"prepare"`: any pre-publish steps

**Checkpoint:** `npm test` runs (even if no tests yet), `npm run lint` passes

## Phase 2: Interactive Prompts (INIT-002)

### Action 2.1: Install and configure prompts library

- [ ] Decide on prompt library (inquirer vs prompts - see D-002)
- [ ] Add as dependency: `npm install inquirer` (or chosen alternative)
- [ ] Create `lib/prompts.js` module to encapsulate prompt logic

**Checkpoint:** Import successful, library works in test script

### Action 2.2: Implement project type selection

- [ ] Add prompt: "What type of project are you planning?"
  - Option 1: Quickstart (single file, try APS in 5 min)
  - Option 2: Simple (small feature, 1-3 work items)
  - Option 3: Single Module (bounded feature with interfaces)
  - Option 4: Multi-Module (2-6 modules, typical project)
  - Option 5: Large Initiative (6+ modules, expanded structure)
- [ ] Store selection in config object
- [ ] Add logic to map selection to template variant

**Checkpoint:** Running CLI shows project type prompt, selection is stored

### Action 2.3: Implement additional prompts

- [ ] Add prompt: "Project name?" (default: directory name)
- [ ] Add prompt: "Module ID prefix?" (for multi-module, default: auto-derive from name)
- [ ] Add prompt: "Include example modules?" (yes/no, default: no)
- [ ] Add prompt: "Include decision log structure?" (yes/no, default: yes)
- [ ] Add conditional logic (e.g., skip module prefix for quickstart)

**Checkpoint:** All prompts display in appropriate contexts, answers captured

### Action 2.4: Add prompt validation

- [ ] Validate project name (no special chars, not empty)
- [ ] Validate module prefix (2-6 uppercase letters, regex: `[A-Z]{2,6}`)
- [ ] Show helpful error messages for invalid inputs
- [ ] Allow users to go back/cancel

**Checkpoint:** Invalid inputs show errors, valid inputs proceed

## Phase 3: File Scaffolding (INIT-003)

### Action 3.1: Bundle templates in package

- [ ] Copy templates from main repo to `packages/create-aps/templates/`
  - `quickstart.template.md`
  - `simple.template.md`
  - `module.template.md`
  - `index.template.md`
  - `index-expanded.template.md`
  - `actions.template.md`
- [ ] Copy `scaffold/plans/aps-rules.md` to `templates/aps-rules.md`
- [ ] Ensure templates are included in npm package (check .npmignore)

**Checkpoint:** `npm pack && tar -tzf create-aps-*.tgz | grep templates` shows all templates

### Action 3.2: Implement directory creation

- [ ] Create `lib/scaffold.js` module
- [ ] Implement function to create directory structure:
  - `plans/`
  - `plans/modules/`
  - `plans/execution/`
  - `plans/decisions/` (if selected)
- [ ] Use `fs.mkdirSync(path, { recursive: true })` for safety
- [ ] Handle permission errors gracefully

**Checkpoint:** Test run creates expected directory tree

### Action 3.3: Implement template file copying

- [ ] Copy appropriate index template based on project type:
  - Quickstart → `quickstart.template.md` → `plans/index.aps.md`
  - Simple → `simple.template.md` → `plans/index.aps.md`
  - Single Module → `module.template.md` → `plans/modules/01-[name].aps.md`
  - Multi-Module → `index.template.md` → `plans/index.aps.md`
  - Large Initiative → `index-expanded.template.md` → `plans/index.aps.md`
- [ ] Copy template files to appropriate locations:
  - `aps-rules.md` → `plans/aps-rules.md`
  - `module.template.md` → `plans/modules/.module.template.md`
  - `simple.template.md` → `plans/modules/.simple.template.md`
  - `actions.template.md` → `plans/execution/.actions.template.md`

**Checkpoint:** Generated files match expected structure for each project type

### Action 3.4: Implement template variable substitution

- [ ] Replace `[Module Title]` with user's project name
- [ ] Replace module ID placeholders (AUTH → user's prefix)
- [ ] Replace `@username` with git config user (if available)
- [ ] Update Status to "Draft" in generated files
- [ ] Keep `.template.md` files unchanged (pure templates)

**Checkpoint:** Generated index.aps.md contains personalized values

### Action 3.5: Add example modules (optional)

- [ ] If user selected "include examples", copy example modules:
  - Example from `examples/` directory in main repo
  - Or create simplified examples inline
- [ ] Place in `plans/modules/` with descriptive names
- [ ] Mark as examples in file (comment or note)

**Checkpoint:** Examples appear when selected, absent when not

## Phase 4: Update Mode (INIT-004)

### Action 4.1: Implement APS structure detection

- [ ] Create `lib/detect.js` module
- [ ] Check if `plans/` directory exists
- [ ] Check if `plans/aps-rules.md` exists
- [ ] Check if `plans/index.aps.md` or `plans/modules/*.aps.md` exist
- [ ] Return object with detection results

**Checkpoint:** Running in existing APS project returns detection object

### Action 4.2: Create version tracking file

- [ ] Define format for `plans/.aps-version`:
  ```json
  {
    "createApsVersion": "0.1.0",
    "lastUpdated": "2026-01-11T12:00:00Z",
    "templates": {
      "module.template.md": "0.1.0",
      "simple.template.md": "0.1.0",
      "actions.template.md": "0.1.0"
    }
  }
  ```
- [ ] Write version file on initial scaffold
- [ ] Read version file in update mode

**Checkpoint:** Fresh init creates `.aps-version` file with current package version

### Action 4.3: Implement --update flag logic

- [ ] When `--update` flag detected:
  - Run APS structure detection
  - If no APS structure found, show error: "No APS structure detected. Run without --update to initialize."
  - If detected, proceed with update
- [ ] Only update files matching `.template.md` pattern
- [ ] Update `aps-rules.md` (backup old version as `aps-rules.md.bak`)
- [ ] Update `.aps-version` with new version
- [ ] Preserve all `.aps.md` files (user's work)

**Checkpoint:** `--update` in existing project refreshes templates, preserves specs

### Action 4.4: Add dry-run mode

- [ ] Add `--dry-run` flag
- [ ] Show what would be created/updated without writing files
- [ ] Display file paths and whether they would be created/updated/skipped
- [ ] Use colored output (green=create, yellow=update, gray=skip)

**Checkpoint:** `--dry-run` shows accurate preview without modifying files

## Phase 5: Non-Interactive Mode (INIT-005)

### Action 5.1: Define config file schema

- [ ] Create JSON schema for `aps-init.json`
- [ ] Document all supported fields (projectType, projectName, etc.)
- [ ] Add schema validation (use Ajv or similar)

**Checkpoint:** Schema document exists, examples validate

### Action 5.2: Implement config file loading

- [ ] Add `--config <path>` flag
- [ ] Read and parse JSON file
- [ ] Validate against schema
- [ ] Show clear error messages for invalid configs

**Checkpoint:** `--config valid.json` loads without prompts

### Action 5.3: Implement CLI flag overrides

- [ ] Add CLI flags for all options:
  - `--type <quickstart|simple|module|multi|large>`
  - `--name <project-name>`
  - `--prefix <MODULE-ID>`
  - `--examples` (boolean)
  - `--decisions` (boolean)
- [ ] CLI flags override config file values
- [ ] Skip prompts if all required values provided

**Checkpoint:** `npx create-aps --type simple --name "My Feature"` works non-interactively

### Action 5.4: Add config file generation

- [ ] Add `--save-config` flag to save answers as JSON
- [ ] Export current settings to `aps-init.json`
- [ ] Useful for replicating setup across projects

**Checkpoint:** `--save-config` creates valid config file from interactive session

## Phase 6: Validation and Error Handling (INIT-006)

### Action 6.1: Implement target directory validation

- [ ] Check if target directory exists
- [ ] If exists and not empty, show contents count
- [ ] Prompt: "Directory not empty. Continue? (y/N)"
- [ ] Add `--force` flag to skip this prompt

**Checkpoint:** Running in non-empty dir requires confirmation

### Action 6.2: Detect conflicting structures

- [ ] Check for `plans/` directory without APS structure
- [ ] Check for files that would be overwritten
- [ ] Show clear error: "Found plans/ directory but not APS structure. Rename or use different directory."

**Checkpoint:** Conflicting structures produce helpful error messages

### Action 6.3: Add Git repository detection

- [ ] Check if `.git` directory exists in target
- [ ] Check if `plans/` is in `.gitignore`
- [ ] Suggest: "Consider committing APS files to version control"
- [ ] Don't auto-modify .gitignore (user decision)

**Checkpoint:** Git detection works, suggestion displayed when applicable

### Action 6.4: Implement permission checking

- [ ] Test write permissions before attempting scaffold
- [ ] Show clear error if no write access: "Cannot write to [path]. Check permissions."
- [ ] Fail fast before creating partial structure

**Checkpoint:** Permission errors caught early with helpful message

## Phase 7: Post-Init Guidance (INIT-007)

### Action 7.1: Create success message template

- [ ] Design formatted output for successful init
- [ ] Include:
  - ✓ Success indicator
  - Directory structure created
  - Files generated (list)
  - Next steps section
- [ ] Use box-drawing characters or color for readability

**Checkpoint:** Success message is clear and helpful

### Action 7.2: Add dynamic next steps

- [ ] Customize guidance based on project type:
  - Quickstart: "Edit plans/index.aps.md and start planning!"
  - Multi-Module: "Define your modules in plans/index.aps.md"
- [ ] Include links:
  - Getting started guide (URL or relative path)
  - Documentation link
- [ ] Mention `aps lint` validation when available

**Checkpoint:** Next steps relevant to user's selections

### Action 7.3: Add aps-rules.md reminder

- [ ] Prominently mention `plans/aps-rules.md`
- [ ] Suggest: "Share plans/aps-rules.md with AI assistants for best results"
- [ ] Consider showing first few lines of aps-rules.md as preview

**Checkpoint:** Users understand importance of aps-rules.md

## Phase 8: Documentation (INIT-008)

### Action 8.1: Write comprehensive package README

- [ ] Create `README.md` in package root
- [ ] Sections:
  - Quick start
  - Installation options
  - Interactive mode walkthrough (with screenshots/examples)
  - Non-interactive mode examples
  - Update existing project
  - Configuration reference
  - Troubleshooting
  - Migration from scaffold/init.sh
- [ ] Add badges (npm version, downloads, license)

**Checkpoint:** README covers all features with examples

### Action 8.2: Create detailed API/CLI reference

- [ ] Document all flags and options
- [ ] Show examples for common scenarios
- [ ] Include config file schema
- [ ] Add troubleshooting section with common errors

**Checkpoint:** All CLI options documented with examples

### Action 8.3: Add migration guide for scaffold users

- [ ] Compare bash script vs npm command
- [ ] Show equivalent commands
- [ ] Explain benefits of npm approach
- [ ] Note: bash script remains available for curl-based installs

**Checkpoint:** Migration path clear for existing users

## Phase 9: Testing (INIT-009)

### Action 9.1: Create test fixtures

- [ ] Empty directory fixture
- [ ] Existing project fixture (non-APS)
- [ ] Existing APS project fixture
- [ ] Invalid config files
- [ ] Mock git repository

**Checkpoint:** Test fixtures cover all scenarios

### Action 9.2: Write unit tests

- [ ] Test prompt logic (lib/prompts.js)
- [ ] Test scaffold logic (lib/scaffold.js)
- [ ] Test detection logic (lib/detect.js)
- [ ] Test template substitution
- [ ] Mock file system operations

**Checkpoint:** Unit tests cover core logic, >70% coverage

### Action 9.3: Write integration tests

- [ ] Test full init flow (fresh directory)
- [ ] Test update mode (existing APS)
- [ ] Test non-interactive mode (config file)
- [ ] Test error cases (permissions, conflicts)
- [ ] Use temporary directories for isolation

**Checkpoint:** Integration tests pass, >80% overall coverage

### Action 9.4: Add snapshot tests for generated files

- [ ] Capture expected output for each project type
- [ ] Compare generated files to snapshots
- [ ] Update snapshots when templates change intentionally

**Checkpoint:** Snapshot tests ensure consistent output

### Action 9.5: Test on multiple platforms

- [ ] Test on macOS
- [ ] Test on Linux
- [ ] Test on Windows (path separators, permissions)
- [ ] CI runs tests on all platforms

**Checkpoint:** Tests pass on all target platforms

## Phase 10: Publishing and Integration (INIT-010)

### Action 10.1: Finalize package naming

- [ ] Decide: `create-aps` vs `@anvil/create-aps` (see D-001)
- [ ] Check npm registry for name availability
- [ ] Create npm organization if using scoped package
- [ ] Reserve package name with placeholder publish if needed

**Checkpoint:** Package name confirmed and available

### Action 10.2: Set up automated publishing

- [ ] Create GitHub Action workflow for npm publish
- [ ] Trigger on version tags (e.g., `v0.1.0`)
- [ ] Use `NPM_TOKEN` secret for authentication
- [ ] Add changelog generation step

**Checkpoint:** GitHub Action publishes on tag push

### Action 10.3: Publish initial version to npm

- [ ] Review package contents (`npm pack` and inspect)
- [ ] Test installation from tarball locally
- [ ] Publish to npm: `npm publish`
- [ ] Verify package page on npmjs.com
- [ ] Test installation: `npm init aps` and `npx create-aps`

**Checkpoint:** Package available on npm registry, installation works

### Action 10.4: Update main repository documentation

- [ ] Update main README.md:
  - Add npm installation as primary method
  - Move bash script to "Alternative Methods" section
  - Add npm badge
- [ ] Update docs/getting-started.md:
  - Add npm init flow as first option
  - Include interactive prompt walkthrough
  - Keep bash script option for completeness
- [ ] Update CHANGELOG.md with npm package release

**Checkpoint:** Main repo docs reflect npm availability

### Action 10.5: Create announcement and examples

- [ ] Write announcement (GitHub Discussion or blog post)
- [ ] Create example projects using npm init
- [ ] Add to examples/ directory if appropriate
- [ ] Share on relevant platforms (Reddit, HN, Twitter)

**Checkpoint:** Community aware of npm package availability

## Phase 11: Post-Launch Polish (Optional)

### Action 11.1: Add telemetry (opt-in)

- [ ] Implement opt-in telemetry using minimal library
- [ ] Track: project type selections, success/failure rates
- [ ] Respect DNT header and --no-telemetry flag
- [ ] Anonymous, no PII collection
- [ ] Clear disclosure in prompts

**Checkpoint:** Telemetry provides usage insights without privacy concerns

### Action 11.2: Create GitHub template repository

- [ ] Complement npm package with GitHub template
- [ ] Users can click "Use this template" button
- [ ] Pre-populated with APS structure
- [ ] Different branches for different project types

**Checkpoint:** GitHub template provides alternative onboarding path

### Action 11.3: Add upgrade command (future)

- [ ] Research `aps upgrade` command design
- [ ] Migrate between template versions
- [ ] Handle breaking changes gracefully
- [ ] Separate work item (out of scope for v1)

**Checkpoint:** Upgrade path planned for future

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Name collision on npm | High | Reserve name early, check availability |
| Breaking changes in templates | Medium | Version tracking, careful migration |
| Platform-specific path issues | Medium | Use path.join, test on Windows/Mac/Linux |
| Users expect features beyond init | Low | Clear scope, point to roadmap |
| Maintenance burden (two init methods) | Medium | Keep bash script minimal, npm as primary |

## Notes

- Start with minimal viable package (Phases 1-3) for early testing
- Update mode (Phase 4) is critical for adoption by existing users
- Testing (Phase 9) should be ongoing throughout development
- Consider soft launch (unlisted npm package) before public announcement
