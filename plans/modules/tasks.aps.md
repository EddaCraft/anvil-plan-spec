# Tasks Integration Module

| ID | Owner | Status |
|----|-------|--------|
| TASKS | @aneki | Draft |

## Purpose

Enable APS to integrate with Claude Code's new Tasks primitive, allowing work items to be executed with dependency tracking, multi-agent coordination, and cross-session collaboration.

## Background

Anthropic announced Tasks as an evolution of TodoWrite in Claude Code (January 2025). Key capabilities:
- Tasks stored in `~/.claude/tasks` (file-system based)
- Dependencies via `blockedBy` metadata
- Multi-session/subagent collaboration
- Broadcast updates across sessions
- Environment variable for shared task lists: `CLAUDE_CODE_TASK_LIST_ID`

This creates a natural split: **APS handles planning** (durable, git-versioned), **Tasks handle execution** (runtime, ephemeral).

## In Scope

- Guidance for mapping APS concepts to Claude Code Tasks
- Prompt templates for task creation from APS specs
- CLI commands for APS ↔ Tasks synchronization
- MCP server exposing APS as queryable tools
- Updates to aps-rules.md for Tasks-aware agents

## Out of Scope

- Modifying Claude Code internals
- Real-time sync daemons (polling is acceptable)
- GUI or web interfaces
- Non-Claude AI tool integrations (separate modules)

## Interfaces

**Depends on:**

- VAL (validation) — reuse parser logic for reading APS documents
- INT (integrations) — share JSON schema work
- PROMPT (prompts) — coordinate on prompt organization

**Exposes:**

- `aps tasks export [module]` — generate Tasks from APS work items
- `aps tasks status` — show current task state
- `aps tasks sync` — bidirectional sync (task completion → APS status)
- MCP server: `aps-mcp` — exposes APS read/query tools
- Updated aps-rules.md with Tasks integration section

## Concept Mapping

| APS Concept | Claude Tasks Equivalent |
|-------------|------------------------|
| Work Item | Task |
| Work Item Dependencies | `blockedBy` field |
| Module | Agent work stream / Task List |
| Action Plan actions | Sub-tasks in sequence |
| Status (Ready/In Progress/Complete) | Task status |
| Validation command | Task completion gate |

## Ready Checklist

- [x] Purpose and scope are clear
- [x] Dependencies identified
- [x] At least one work item defined

## Work Items

### TASKS-001: Document Tasks integration guidance

- **Intent:** Provide clear guidance for using APS with Claude Code Tasks without requiring tooling
- **Expected Outcome:** Section in aps-rules.md explaining concept mapping, workflow, and best practices
- **Validation:** `grep -q "Claude Code Tasks" plans/aps-rules.md`
- **Confidence:** high
- **Dependencies:** none
- **Files:** plans/aps-rules.md

### TASKS-002: Create Tasks prompt templates

- **Intent:** Enable Claude to create Tasks from APS specs via prompting
- **Expected Outcome:** Prompt templates for: (1) creating tasks from module, (2) wave planning, (3) agent assignment
- **Validation:** Files exist in docs/ai/prompting/claudecode/
- **Confidence:** high
- **Dependencies:** TASKS-001
- **Files:** docs/ai/prompting/claudecode/*.prompt.md

### TASKS-003: Design task file format bridge

- **Intent:** Understand Claude Code's task storage format to enable programmatic integration
- **Expected Outcome:** Documentation of ~/.claude/tasks format with example files
- **Validation:** docs/tasks-format.md exists with schema description
- **Confidence:** medium
- **Risks:** Format may not be publicly documented; may need reverse engineering

### TASKS-004: Implement `aps tasks export`

- **Intent:** Generate Claude Code Tasks from APS work items programmatically
- **Expected Outcome:** CLI command that reads module, outputs task creation commands or JSON
- **Validation:** `./bin/aps tasks export plans/modules/01-example.aps.md` produces valid output
- **Confidence:** medium
- **Dependencies:** TASKS-003, VAL-002 (CLI skeleton)
- **Files:** bin/aps, lib/tasks-export.sh

### TASKS-005: Implement `aps tasks sync`

- **Intent:** Sync task completion status back to APS work item status fields
- **Expected Outcome:** CLI command that reads task state and updates APS markdown files
- **Validation:** Completing a task updates corresponding work item to "Complete" in module file
- **Confidence:** medium
- **Dependencies:** TASKS-003, TASKS-004

### TASKS-006: Create MCP server for APS

- **Intent:** Expose APS documents as queryable tools for Claude Code and other MCP clients
- **Expected Outcome:** MCP server with tools: list-modules, get-work-items, get-ready-items, update-status
- **Validation:** `npx @anthropic/mcp-cli test aps-mcp` passes tool discovery
- **Confidence:** medium
- **Dependencies:** TASKS-001, INT (JSON schema)
- **Files:** mcp-server/

### TASKS-007: Add scaffold integration

- **Intent:** New projects get Tasks-ready configuration out of the box
- **Expected Outcome:** scaffold/init.sh creates .claude/settings.json with APS-aware instructions
- **Validation:** Running init.sh creates .claude/ directory with customInstructions
- **Confidence:** high
- **Dependencies:** TASKS-001
- **Files:** scaffold/init.sh, scaffold/templates/.claude/

## Decisions

- **D-001:** Task List granularity — *pending: one per project vs one per module*
- **D-002:** Sync direction — *pending: APS-authoritative vs bidirectional*
- **D-003:** MCP server language — *pending: TypeScript (ecosystem) vs Python (simpler)*

## Execution Strategy

### Phase 1: Guidance (No Tooling)
- TASKS-001: aps-rules.md updates
- TASKS-002: Prompt templates
- TASKS-007: Scaffold hints

### Phase 2: CLI Integration
- TASKS-003: Format research
- TASKS-004: Export command
- TASKS-005: Sync command

### Phase 3: Deep Integration
- TASKS-006: MCP server

## Notes

- Start with prompt-based approach (Phase 1) — Claude already knows how to create Tasks
- CLI adds automation but isn't required for basic usage
- MCP server enables rich bidirectional integration but adds complexity
- Consider: watch mode for continuous sync during long sessions
