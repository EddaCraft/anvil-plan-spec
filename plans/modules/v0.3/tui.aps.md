# TUI Dashboard Module

| ID | Owner | Status |
|----|-------|--------|
| TUI | @aneki | Draft |

## Purpose

Provide a terminal-based dashboard for visualizing APS project status, progress, and structure without leaving the command line.

## In Scope

- `aps status` command showing TUI dashboard
- Module progress visualization (progress bars, completion %)
- Work item status breakdown (To Do, In Progress, Blocked, Complete)
- Dependency graph visualization (text-based)
- Interactive navigation between modules
- Filtering and search functionality
- Refresh on file changes (watch mode)

## Out of Scope

- Web-based dashboard (long-term roadmap)
- Real-time collaboration features
- Edit-in-place functionality (read-only dashboard)
- Chart generation (PNG/SVG export)
- Integration with external tools (Jira, Linear, etc.)

## Interfaces

**Depends on:**

- VAL (validation) — uses parser for reading APS files
- CORE (core-infra) — reads config.json for project structure

**Exposes:**

- `aps status` — launches TUI dashboard
- `aps status --summary` — prints summary without TUI (CI-friendly)
- `aps status --watch` — auto-refresh on file changes
- `aps status --module <id>` — show specific module details

## Boundary Rules

- Must work in any terminal (no GUI required)
- Must handle large projects (50+ modules) performantly
- Must degrade gracefully if terminal is too small

## Ready Checklist

- [ ] Purpose and scope are clear
- [ ] Dependencies identified
- [ ] At least one work item defined

## Work Items

### TUI-001: Choose and prototype TUI library

- **Intent:** Evaluate TUI options and build proof-of-concept
- **Expected Outcome:** Decision on library with working hello-world dashboard
- **Validation:** Simple TUI app renders in terminal with navigation
- **Confidence:** high
- **Options to evaluate:**
  - **blessed** (mature, low-level, full control)
  - **ink** (React-based, modern, good DX)
  - **terminal-kit** (high-level, batteries included)
  - **blessed-contrib** (built on blessed, charts/widgets)
- **Criteria:**
  - Performance with 50+ modules
  - Navigation patterns (arrow keys, vim keys)
  - Refresh/redraw capabilities
  - Community support and maintenance

### TUI-002: Implement APS file parser and aggregator

- **Intent:** Read all APS files and aggregate status data
- **Expected Outcome:** Function returns project summary object
- **Validation:** Parser handles example projects (user-auth, opencode-companion)
- **Confidence:** high
- **Dependencies:** VAL (reuse validation parser), CORE (config reading)
- **Data to extract:**
  - Index metadata (name, status, modules)
  - Module list with status and work item counts
  - Work item list with status, dependencies, validation
  - Dependency graph (module → module references)

### TUI-003: Design and implement main dashboard view

- **Intent:** Create primary view showing project overview
- **Expected Outcome:** TUI displays project name, module list, overall progress
- **Validation:** Dashboard renders all modules with status indicators
- **Confidence:** high
- **Layout:**
  ```
  ┌─ APS Dashboard: My Project ──────────────────┐
  │ Status: In Progress     Progress: 45% (9/20) │
  ├───────────────────────────────────────────────┤
  │ Modules                                       │
  │ ✓ 01: Core [Complete] 5/5 work items         │
  │ → 02: Auth [In Progress] 3/7 work items      │
  │   03: Session [Ready] 0/4 work items         │
  │   04: UI [Draft] 0/0 work items              │
  ├───────────────────────────────────────────────┤
  │ [Enter] Details  [Tab] Filter  [Q] Quit      │
  └───────────────────────────────────────────────┘
  ```

### TUI-004: Implement module detail view

- **Intent:** Show work items and progress for selected module
- **Expected Outcome:** Drill-down view with work item list and metadata
- **Validation:** Selecting module shows all work items with status
- **Confidence:** high
- **Layout:**
  ```
  ┌─ Module: Authentication (AUTH) ───────────────┐
  │ Status: In Progress      Owner: @aneki       │
  │ Progress: 3/7 work items (43%)               │
  ├───────────────────────────────────────────────┤
  │ Work Items                                    │
  │ ✓ AUTH-001: Create login endpoint            │
  │ ✓ AUTH-002: Add password hashing             │
  │ → AUTH-003: Implement JWT tokens             │
  │ ⧗ AUTH-004: Add OAuth (blocked: credentials) │
  │   AUTH-005: Password reset flow              │
  │   AUTH-006: Email verification               │
  │   AUTH-007: Rate limiting                    │
  ├───────────────────────────────────────────────┤
  │ Dependencies: CORE ✓                         │
  │ [Esc] Back  [Enter] Work Item  [Q] Quit     │
  └───────────────────────────────────────────────┘
  ```

### TUI-005: Implement work item detail view

- **Intent:** Show full work item details including validation and dependencies
- **Expected Outcome:** Deepest drill-down showing all work item fields
- **Validation:** View displays intent, outcome, validation, dependencies
- **Confidence:** medium
- **Layout:**
  ```
  ┌─ Work Item: AUTH-003 ─────────────────────────┐
  │ Title: Implement JWT tokens                  │
  │ Status: In Progress      Confidence: High    │
  ├───────────────────────────────────────────────┤
  │ Intent:                                       │
  │ Enable stateless auth with token validation  │
  │                                               │
  │ Expected Outcome:                             │
  │ API requests with valid tokens succeed       │
  │                                               │
  │ Validation:                                   │
  │ curl -H "Authorization: Bearer ..." /api/me  │
  │                                               │
  │ Dependencies: AUTH-002 ✓                     │
  │ Files: src/middleware/auth.ts, lib/jwt.ts    │
  ├───────────────────────────────────────────────┤
  │ [V] Run Validation  [Esc] Back  [Q] Quit    │
  └───────────────────────────────────────────────┘
  ```

### TUI-006: Add dependency graph visualization

- **Intent:** Show module dependencies in terminal-friendly format
- **Expected Outcome:** Text-based graph showing module relationships
- **Validation:** Graph correctly represents dependencies from index
- **Confidence:** medium
- **Format:**
  ```
  ┌─ Dependency Graph ────────────────────────────┐
  │                                               │
  │   CORE ✓                                      │
  │    ├─> AUTH →                                 │
  │    └─> SESSION                                │
  │         └─> NOTIF                             │
  │                                               │
  │   UI                                          │
  │    └─> THEME                                  │
  │                                               │
  │ ✓ Complete   → In Progress   ○ Not Started   │
  ├───────────────────────────────────────────────┤
  │ [Esc] Back  [Q] Quit                         │
  └───────────────────────────────────────────────┘
  ```

### TUI-007: Implement filtering and search

- **Intent:** Allow users to filter modules/work items by status, owner, etc.
- **Expected Outcome:** Tab or hotkey opens filter menu, updates view
- **Validation:** Filtering by "In Progress" shows only active items
- **Confidence:** medium
- **Filters:**
  - Status (Draft, Ready, In Progress, Blocked, Complete)
  - Owner (@username)
  - Module ID
  - Search by text (fuzzy match on title/intent)

### TUI-008: Add watch mode for auto-refresh

- **Intent:** Dashboard updates when APS files change (during development)
- **Expected Outcome:** `aps status --watch` refreshes on file modification
- **Validation:** Editing work item status updates dashboard in real-time
- **Confidence:** medium
- **Implementation:**
  - Use fs.watch or chokidar to monitor plans/ directory
  - Debounce updates (avoid thrashing on multiple saves)
  - Show notification "Refreshed" in corner
  - Handle parse errors gracefully (show error, don't crash)

### TUI-009: Add summary mode for CI/CD

- **Intent:** Provide non-interactive summary output for scripts
- **Expected Outcome:** `aps status --summary` prints text report
- **Validation:** Output is parseable, exit code reflects project health
- **Confidence:** high
- **Output format:**
  ```
  APS Project Status: My Project

  Overall: In Progress (45% complete, 9/20 work items)

  Modules:
    ✓ Core         [Complete]     5/5 work items
    → Auth         [In Progress]  3/7 work items
      Session      [Ready]        0/4 work items
      UI           [Draft]        0/0 work items

  Blockers: 1
    - AUTH-004: Blocked on credentials from infra team
  ```

### TUI-010: Add validation runner integration

- **Intent:** Allow running work item validation from dashboard
- **Expected Outcome:** Pressing 'V' on work item runs validation command
- **Validation:** Command executes, output displayed in modal
- **Confidence:** medium
- **Dependencies:** VAL (validation CLI)
- **Features:**
  - Execute validation command in shell
  - Capture stdout/stderr
  - Show result (pass/fail) with output
  - Update work item status indicator if validation passes

### TUI-011: Add keyboard shortcuts and help screen

- **Intent:** Make dashboard navigable and discoverable
- **Expected Outcome:** '?' or 'h' shows help overlay with all shortcuts
- **Validation:** Help screen documents all keybindings
- **Confidence:** high
- **Shortcuts:**
  - `↑/↓` or `j/k` — Navigate list
  - `Enter` — Drill down / select
  - `Esc` — Back / exit detail
  - `Tab` — Next section / toggle filter
  - `/` — Search
  - `r` — Refresh
  - `v` — Run validation (on work item)
  - `g` — Show dependency graph
  - `?` or `h` — Help
  - `q` — Quit

### TUI-012: Performance optimization for large projects

- **Intent:** Ensure dashboard remains responsive with 50+ modules
- **Expected Outcome:** Sub-second render time for large projects
- **Validation:** Benchmark with synthetic 100-module project
- **Confidence:** medium
- **Optimizations:**
  - Lazy load work item details (only parse when viewing)
  - Virtual scrolling for long lists
  - Cache parsed results (invalidate on file change)
  - Incremental parsing (only re-parse changed files)

## Execution

Action Plan: [../../execution/v0.3/TUI.actions.md](../../execution/v0.3/TUI.actions.md)

## Decisions

- **D-001:** TUI library — *pending: evaluate blessed vs ink*
- **D-002:** Keyboard shortcuts — *decided: support both arrow keys and vim keys*
- **D-003:** Graph format — *decided: ASCII tree (no box drawing for max compatibility)*
- **D-004:** Watch mode — *decided: opt-in with --watch flag (avoid surprise behavior)*
- **D-005:** Validation execution — *decided: run in dashboard context, show output (don't exit to shell)*

## Acceptance Criteria

Dashboard is ready when:
- [ ] Renders project overview with all modules and status
- [ ] Navigation works (arrow keys, enter, esc)
- [ ] Drill-down shows module → work item details
- [ ] Summary mode works for CI/CD
- [ ] Watch mode updates on file changes
- [ ] Help screen documents all shortcuts
- [ ] Performance: <1s render for 50-module project

## Risks

| Risk | Mitigation |
|------|------------|
| TUI library has rendering bugs | Prototype early, have fallback option (terminal-kit) |
| Terminal size too small | Detect size, show error with minimum requirements |
| File parsing errors crash dashboard | Try/catch all parsing, show errors gracefully |
| Watch mode consumes too many resources | Use debouncing, add --watch-interval flag |

## Notes

- Web dashboard is explicitly out of scope for v0.3 (long-term roadmap)
- TUI is primary workflow for developers (quick status check)
- Consider `aps status --json` for custom integrations
- Future: Export to HTML for static hosting (separate work item)
