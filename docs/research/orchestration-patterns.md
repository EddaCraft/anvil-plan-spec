# Orchestration Patterns: BMAD, Overseer, and APS

> Research conducted: 2026-02-25
> Status: Complete
> Context: Exploring whether APS should offer native orchestration as an
> optional capability, informed by how BMAD and Overseer approach the problem.

## Executive Summary

BMAD Method and Overseer represent two fundamentally different approaches to
AI-agent orchestration. BMAD uses **prompt engineering** — the LLM itself is
the execution engine, guided by structured files it reads at runtime. Overseer
uses a **programmatic engine** — a Rust binary with SQLite state, exposed via
MCP. APS currently sits closer to BMAD's philosophy (markdown is truth, no
runtime dependencies) but lacks the programmatic affordances that would let
agents self-drive through a plan.

**Recommendation:** Offer an optional ORCHESTRATE module that layers
lightweight CLI tooling on top of existing APS markdown specs — giving agents
programmatic `next`, `start`, `complete` operations without introducing a
database or breaking APS's portable-markdown philosophy.

---

## 1. BMAD Method v6 — Deep Analysis

### What BMAD Actually Is

BMAD is a **prompt engineering framework**, not a software orchestration system.
The entire "orchestration" works by loading files into the LLM context window:

1. **Agent definitions** (YAML → compiled to XML-wrapped markdown) give the LLM
   a persona, menu, and behavioral constraints
2. **`workflow.xml`** is the "core OS" — XML instructions telling the LLM how
   to process YAML workflow configs step-by-step
3. **Handoffs are manual** — the user invokes each slash command; the LLM reads
   the next file and follows instructions
4. **State is `sprint-status.yaml`** — a flat YAML file updated by agents as
   instructed by their workflow steps
5. **IDE integration** generates platform-native command files (slash commands
   for Claude Code, rules for Cursor, etc.) that instruct the LLM to read
   specific files from `_bmad/`

Key repository: <https://github.com/bmad-code-org/BMAD-METHOD>

### BMAD Orchestration Mechanics

**The BMad Master Agent** (`src/core/agents/bmad-master.agent.yaml`) is a
meta-agent that greets the user, lists available tasks/workflows from CSV
manifests, and routes to specialized agents. It does not execute code — it is
a prompt personality loaded into an LLM context window.

**The Workflow Engine** (`src/core/tasks/workflow.xml`) processes every YAML
workflow through a 3-step flow:

1. Load and initialize — resolve config references, system variables, ask user
   for unknowns
2. Process each instruction step — handles `action`, `check`, `ask`, `goto`,
   `invoke-workflow`, `invoke-task`, `invoke-protocol`, `template-output` tags
3. Completion — confirm outputs saved, report status

**Handler dispatch** (not automated agent-to-agent handoffs):

- `workflow="path.yaml"` → load workflow.xml, pass the YAML as config
- `exec="path.md"` → read the markdown file and follow all instructions
- `action` → inline operations (list files, etc.)

**The `/bmad-help` router** (`src/core/tasks/help.md`) reads a CSV catalog and
uses phase/sequence ordering to recommend what the user should do next, checking
which artifacts already exist.

### BMAD State Management

**`sprint-status.yaml`** is the central state file:

```yaml
development_status:
  epic-1: in-progress
  1-1-user-authentication: done
  1-2-account-management: ready-for-dev
  1-3-plant-data-model: backlog
  epic-2: backlog
  2-1-personality-system: backlog
```

Status machines:
- **Epic:** backlog → in-progress → done
- **Story:** backlog → ready-for-dev → in-progress → review → done

Each workflow agent updates this file as part of its instructions. There is no
programmatic enforcement — the LLM follows instructions to update YAML fields.

### BMAD Agent Architecture

Every agent YAML has: `metadata` (id, name, title, icon, module, capabilities),
`persona` (role, identity, communication_style, principles), optional
`critical_actions`, and `menu` items. The compiler (`tools/cli/lib/agent/compiler.js`)
converts YAML to XML-wrapped markdown, injecting activation steps and handler
logic from shared components.

Notable: the Dev agent has strict `critical_actions` enforcing TDD, sequential
task execution, and honest reporting — behavioral constraints enforced purely
through prompting.

### BMAD Context Packaging (Epic Sharding)

Large documents (PRD, Architecture, Epics) can be split into smaller files via
`shard-doc.xml` (splits on `##` headings, generates `index.md`). The
`discover_inputs` protocol handles both formats transparently:

- `FULL_LOAD` — load all files in sharded directory
- `SELECTIVE_LOAD` — load specific shard by template variable
- `INDEX_GUIDED` — load index, analyze structure, intelligently select docs

Story files are "ultimate context engines" — self-contained docs aggregating
context from epics, architecture, previous stories, git history, and web
research so a Dev agent can implement without other documents.

### BMAD v6 Key Changes

1. **Step-file architecture** — each workflow step is a separate `.md` file
   loaded just-in-time (saves tokens)
2. **Direct slash command invocation** — workflows invocable without agent menus
3. **Smart input discovery** — `discover_inputs` protocol with 3 load strategies
4. **Cross-file reference validation** — ~483 references across ~217 files
5. **Module system** — core + extension modules (bmm, tea, bmgd, cis)
6. **20+ IDE/CLI platform support** — Claude Code, Cursor, Gemini CLI, etc.

### BMAD's Key Insight

The LLM itself is the best orchestrator — give it structured prompts, file
conventions, and behavioral constraints, and it will execute a complex agile
workflow. No daemon, no database, no API needed. The "integration" is just
where to put the command files so the IDE discovers them.

---

## 2. Overseer — Deep Analysis

### What Overseer Is

Overseer is a **programmatic task execution engine** — a Rust binary with
SQLite state management, exposed to LLM agents via MCP (Model Context Protocol).

Repository: <https://github.com/rust-syndicate/overseer>

### Overseer Architecture

```
┌─────────────────────────────────────────┐
│            MCP Interface                 │
│  (codemode: single "execute" tool)       │
├─────────────────────────────────────────┤
│         TaskExecutionEngine              │
│  nextReady() → start() → complete()      │
├─────────────────────────────────────────┤
│          PlanRepository                  │
│  plans/milestones/tasks (SQLite)         │
├─────────────────────────────────────────┤
│         GitIntegration                   │
│  branch-per-task, auto-commit            │
└─────────────────────────────────────────┘
```

### Overseer State Management

State lives in SQLite with a strict lifecycle:

```
Plan:     Draft → Active → Completed → Archived
Milestone: Pending → Active → Completed
Task:      Pending → Ready → InProgress → Completed → Verified
```

The engine enforces transitions programmatically. `nextReady()` resolves
dependencies and returns the next task to execute.

### Overseer's MCP Codemode Pattern

Overseer exposes a **single MCP tool** called `execute` that accepts natural
language commands. The LLM sends requests like:

```
"List all ready tasks"
"Start task 5"
"Complete task 5 with summary: implemented auth flow"
```

The server parses intent and routes to the appropriate operation. This
"codemode" pattern reduces the tool surface area while keeping natural language
flexibility.

### Overseer Context System

Each task gets **progressive context**: its own description, parent milestone
context, plan-level context, and relevant milestone learnings. Learnings are
captured at task completion and propagated to related milestones.

### Overseer VCS Integration

Branch-per-task with auto-commit:
- Starting a task creates `task/plan-<id>/task-<id>` branch
- Completing a task commits and optionally merges
- Clean separation of work streams

### Overseer's Key Insight

Programmatic `nextReady()` and state enforcement catch mistakes the LLM won't.
When agents can call `next()` to self-drive through a dependency graph, they
need less human intervention between steps.

---

## 3. Comparison Matrix

| Dimension | BMAD | Overseer | APS (current) |
|-----------|------|----------|---------------|
| **Engine** | LLM reads files | Rust binary + SQLite | LLM reads markdown specs |
| **State store** | `sprint-status.yaml` | SQLite database | Markdown Status fields |
| **State enforcement** | Prompt instructions | Programmatic | None (human reviews) |
| **Dispatch** | User picks slash command | Agent calls `nextReady()` | Human-directed |
| **Dependencies** | Implicit (phase ordering) | Explicit (DAG in SQLite) | Explicit (Dependencies field) |
| **Context** | Epic sharding → story files | Progressive (parent + learnings) | Re-read spec (5-Op Rule) |
| **VCS** | None | Branch-per-task | None |
| **Portability** | Any LLM that reads files | MCP-capable tools only | Any tool (pure markdown) |
| **Runtime deps** | None | Rust binary + SQLite | None |
| **Learning** | Previous story intelligence | Milestone learnings | Compound (solution docs) |
| **Platform support** | 20+ IDEs via command files | MCP clients | Any tool via AGENTS.md/skills |

---

## 4. Design Space for APS

APS already follows BMAD's philosophy more closely than Overseer's: markdown is
truth, no runtime dependencies, specs are portable. The gap is between:

- **Current state:** Agents re-read specs and make decisions; no programmatic
  dependency resolution; no `nextReady()`; state transitions are freetext
  markdown updates
- **Desired state:** Agents can self-drive through a plan; dependencies are
  resolved programmatically; state transitions are validated; learnings compound

### Three Approaches

**A. Pure BMAD-style (prompt-only orchestration)**

Build a Conductor agent that knows APS rules. No new tooling — the LLM scans
specs, resolves dependencies, and drives execution. Works everywhere.

Limitation: No programmatic validation. The LLM may misread dependencies or
skip state transitions. Everything depends on prompt quality.

**B. Pure Overseer-style (programmatic engine)**

Build an APS MCP server with SQLite state, `nextReady()`, branch management.
Maximum automation.

Limitation: Introduces runtime dependency. Markdown and database can drift.
Less portable. Basically building Overseer with a different schema.

**C. Synthesis: CLI on markdown (recommended)**

Layer lightweight CLI tooling on existing markdown specs. The markdown IS the
database. The CLI provides a programmatic interface to parse, query, and update
it. Optional MCP server wraps the CLI for agents that support MCP.

```
┌──────────────────────┐
│  APS Markdown Specs   │  Source of truth (always)
└──────────┬───────────┘
           │
     ┌─────┼─────────────────┐
     │     │                 │
┌────▼───┐ ┌──▼────┐  ┌──────▼───┐
│Conductor│ │aps CLI│  │MCP Server│
│ Agent   │ │(shell)│  │(optional)│
│Any tool │ │Any    │  │MCP tools │
└─────────┘ └───────┘  └──────────┘
     │          │            │
     └──────────┼────────────┘
                │
     ┌──────────▼───────────┐
     │  Agent Execution      │
     │  Planner/Implementer  │
     └──────────────────────┘
```

Key properties:
- **Markdown stays canonical** — CLI reads from and writes back to `.aps.md`
- **No drift** — there is no separate database to sync
- **Portable by default** — Conductor agent works everywhere; CLI works
  everywhere; MCP is optional enhancement
- **Progressive enhancement** — start with CLI; add MCP later; add VCS later
- **BMAD insight applied** — the LLM is the best orchestrator; give it tools
- **Overseer insight applied** — programmatic `nextReady()` catches mistakes

---

## 5. Applicable Patterns from BMAD

These BMAD patterns could enhance APS without changing its philosophy:

### 5.1 Step-File Architecture

BMAD's step-files load one step at a time into the LLM context, saving tokens.
APS action plans already do this (actions are sequential), but the pattern
could be more explicit — each action could reference external files for detailed
context rather than inlining everything.

### 5.2 Context Packaging

BMAD's story files are "ultimate context engines" — self-contained docs that
let an agent start fresh. APS could generate similar context packages when
starting a work item: pulling the item's intent, module scope, parent
decisions, and relevant learnings into a focused briefing.

### 5.3 Smart Input Discovery

BMAD's `discover_inputs` protocol handles both whole docs and sharded docs
with three load strategies. APS could use similar patterns when modules grow
large — sharding by section and loading selectively.

### 5.4 Platform-Native Command Generation

BMAD generates command files for 20+ platforms. APS already does this via
the AGENT module (Claude Code, Codex, Copilot, OpenCode, Gemini). The BMAD
approach confirms this is the right pattern for tool-agnostic distribution.

### 5.5 Behavioral Constraints via Prompting

BMAD's `critical_actions` (Dev agent must follow TDD, never skip tasks, never
lie about tests) are enforced purely through prompting. APS's aps-rules.md
serves the same purpose. The BMAD pattern validates that prompt-based
behavioral constraints work at scale.

---

## 6. Applicable Patterns from Overseer

### 6.1 Dependency Resolution (`nextReady()`)

The most valuable Overseer pattern. APS work items already have `Dependencies`
fields — a CLI could parse these and return the next item whose dependencies
are all Complete and whose status is Ready. This removes guesswork from agents.

### 6.2 Learning Propagation

Overseer captures learnings at task completion and propagates them to related
milestones. APS could capture learnings in work item metadata and surface them
when starting related items — similar to BMAD's "previous story intelligence."

### 6.3 State Machine Enforcement

Overseer's programmatic state transitions prevent invalid moves (e.g.,
completing a task that was never started). A CLI `aps complete` command could
validate transitions before updating the markdown.

### 6.4 Codemode MCP Pattern

Overseer's single-tool MCP interface (`execute` with natural language) is
elegant. An APS MCP server could expose similar natural-language-routed
operations rather than a large tool surface area.

---

## Sources

- [BMAD Method Repository](https://github.com/bmad-code-org/BMAD-METHOD)
- [BMAD Method Documentation](https://docs.bmad-method.org)
- [BMAD Party Mode](https://docs.bmad-method.org/explanation/party-mode/)
- [Overseer Repository](https://github.com/rust-syndicate/overseer)
