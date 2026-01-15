# Core Infrastructure Module

| ID | Owner | Status |
|----|-------|--------|
| CORE | @aneki | Draft |

## Purpose

Provide machine-readable configuration and metadata support to enable programmatic APS discovery and tooling integration.

## In Scope

- `.aps/config.json` specification and schema
- YAML frontmatter support in templates
- JSON Schema for APS document validation
- Frontmatter parsing utilities for tooling
- Version tracking for template upgrades

## Out of Scope

- Binary file formats
- Database storage
- API endpoints
- Real-time sync
- Cloud-hosted configuration

## Interfaces

**Depends on:**

- VAL (validation) — uses config for validation rules
- INIT (npm-init) — generates config during scaffold

**Exposes:**

- `.aps/config.json` — project-level APS configuration
- `.aps/schema/` — JSON schemas for validation
- Frontmatter spec — YAML block at top of APS files
- `lib/config.js` — config parser (for validation and TUI tools)

## Boundary Rules

- Config discovery must work without npm dependencies
- Frontmatter must remain optional (don't break existing specs)
- Schema must be compatible with standard JSON Schema validators

## Ready Checklist

- [ ] Purpose and scope are clear
- [ ] Dependencies identified
- [ ] At least one work item defined

## Work Items

### CORE-001: Define config.json specification

- **Intent:** Establish canonical structure for `.aps/config.json`
- **Expected Outcome:** Markdown doc with JSON schema and field definitions
- **Validation:** File exists at `docs/config-spec.md` with complete schema
- **Confidence:** high
- **Fields to include:**
  - `apsVersion` (semver)
  - `indexPath` (relative path to index)
  - `modulesPath` (directory for modules)
  - `executionPath` (directory for action plans)
  - `conventions` (ID format, checkpoint word limit, etc.)
  - `aiGuidance` (path to aps-rules.md)
  - `validation` (strictness level, ignore patterns)

### CORE-002: Define frontmatter specification

- **Intent:** Establish YAML frontmatter format for APS documents
- **Expected Outcome:** Specification document with examples and field definitions
- **Validation:** File exists at `docs/frontmatter-spec.md`
- **Confidence:** high
- **Frontmatter structure:**
  ```yaml
  ---
  aps:
    type: module | index | work-item | action-plan
    id: AUTH | CORE-001 | etc
    status: Draft | Ready | In Progress | Blocked | Complete
    dependencies: [CORE, SESSION]
    owner: @username
    created: YYYY-MM-DD
    updated: YYYY-MM-DD
  ---
  ```

### CORE-003: Create JSON schemas

- **Intent:** Enable IDE autocomplete and programmatic validation
- **Expected Outcome:** JSON Schema files for config.json and frontmatter
- **Validation:** Schemas validate example files correctly
- **Confidence:** high
- **Files:**
  - `.aps/schema/config.schema.json`
  - `.aps/schema/frontmatter.schema.json`
  - `.aps/schema/module.schema.json` (for full module structure)
  - `.aps/schema/work-item.schema.json`

### CORE-004: Implement config discovery logic

- **Intent:** Provide reusable function to locate and parse config
- **Expected Outcome:** Node.js module that finds `.aps/config.json` from any subdirectory
- **Validation:** `node -e "require('./lib/config').discover()" works from nested dirs`
- **Confidence:** high
- **Features:**
  - Walk up directory tree to find `.aps/` directory
  - Parse and validate config.json
  - Provide defaults if config missing (fallback mode)
  - Detect project root (git, package.json, or .aps/ presence)

### CORE-005: Implement frontmatter parser

- **Intent:** Provide utility for tools to extract frontmatter from APS files
- **Expected Outcome:** Parser function that separates frontmatter from markdown body
- **Validation:** Parses test fixtures with and without frontmatter correctly
- **Confidence:** high
- **Features:**
  - Extract YAML frontmatter block (--- delimited)
  - Parse YAML to JavaScript object
  - Return body with frontmatter removed
  - Handle files without frontmatter gracefully

### CORE-006: Add config generation to npm-init

- **Intent:** Ensure scaffolded projects have config.json by default
- **Expected Outcome:** `npm init aps` creates `.aps/config.json` with sensible defaults
- **Validation:** Generated config passes JSON Schema validation
- **Confidence:** medium
- **Dependencies:** INIT-003 (scaffolding logic)
- **Generated config:**
  - Reflects user's prompt choices (module paths, etc.)
  - Includes version number from package
  - Sets conventions based on project type

### CORE-007: Add frontmatter to template files

- **Intent:** Provide frontmatter examples in templates for users to fill
- **Expected Outcome:** All templates have frontmatter block with commented guidance
- **Validation:** Visual inspection of templates
- **Confidence:** high
- **Templates to update:**
  - `templates/module.template.md`
  - `templates/index.template.md`
  - `templates/simple.template.md`
  - `templates/actions.template.md`

### CORE-008: Create migration guide for existing projects

- **Intent:** Help users add config and frontmatter to pre-v0.3 projects
- **Expected Outcome:** Documentation showing upgrade path
- **Validation:** Guide includes step-by-step instructions and before/after examples
- **Confidence:** high
- **Sections:**
  - Adding `.aps/config.json` manually
  - Using `npm init aps --update` to add config
  - Optional: adding frontmatter to existing files
  - Backward compatibility notes (frontmatter is optional)

### CORE-009: Update validation to use config

- **Intent:** Make validator config-aware
- **Expected Outcome:** `aps lint` reads config for conventions and paths
- **Validation:** Validator respects custom moduleIdFormat from config
- **Confidence:** medium
- **Dependencies:** VAL-003, CORE-004
- **Behavior:**
  - If config exists, use conventions from config
  - If no config, use hard-coded defaults
  - Warn if config exists but has invalid values

## Execution

Action Plan: [../../execution/v0.3/CORE.actions.md](../../execution/v0.3/CORE.actions.md)

## Decisions

- **D-001:** Config format — *decided: JSON (widely supported, easy to parse)*
- **D-002:** Config location — *decided: `.aps/` (hidden, top-level, clear ownership)*
- **D-003:** Frontmatter format — *decided: YAML (standard in markdown ecosystem)*
- **D-004:** Frontmatter required? — *decided: optional (backward compatibility)*
- **D-005:** Schema format — *decided: JSON Schema Draft 7 (broad tool support)*

## Notes

- Config enables future features (custom validators, alternative layouts)
- Frontmatter complements tables (easier to parse programmatically)
- Keep backward compatibility: tools must handle files without frontmatter
- Consider `.aps/` as future home for cache, temp files (like `.git/`)
