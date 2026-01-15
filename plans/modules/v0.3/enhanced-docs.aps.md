# Enhanced Documentation Module

| ID | Owner | Status |
|----|-------|--------|
| EDOC | @aneki | Draft |

## Purpose

Complete terminology migration and enhance AI agent guidance with decision trees, before/after examples, and comprehensive glossary.

## In Scope

- Complete terminology migration (Tasks → Work Items, Steps → Action Plans)
- AI agent decision tree in aps-rules.md
- Before/after examples in prompting docs
- Comprehensive glossary in README and TERMINOLOGY.md
- Troubleshooting guide
- Solo developer guidance

## Out of Scope

- Video tutorials (future enhancement)
- Interactive documentation
- Hosted documentation site
- Translations to other languages
- API reference (no API exists)

## Interfaces

**Depends on:**

- TPL (templates v0.2) ✓ Complete — docs reference templates

**Exposes:**

- Enhanced `docs/ai/prompting/*.prompt.md` with examples
- Decision tree for AI agents in `plans/aps-rules.md`
- Glossary in `docs/TERMINOLOGY.md` and README
- Troubleshooting guide in `docs/troubleshooting.md`

## Boundary Rules

- Documentation must stay in markdown (no external tools)
- No content behind authentication or paywalls
- Keep docs in repo (no wiki or separate doc site)

## Ready Checklist

- [ ] Purpose and scope are clear
- [ ] Dependencies identified
- [ ] At least one work item defined

## Work Items

### EDOC-001: Complete terminology audit and migration

- **Intent:** Eliminate all references to old terminology
- **Expected Outcome:** Zero instances of "Task" (as layer) or "Step" (as file type) in repo
- **Validation:** `grep -rn "Task" --include="*.md" | grep -v "Work Item" | grep -v "EDOC-001" | wc -l` returns 0
- **Confidence:** high
- **Scope:**
  - All markdown files
  - All templates
  - All examples
  - All prompting docs
  - Exception: "task" as generic word (e.g., "the user's task") is OK

### EDOC-002: Add AI agent decision tree to aps-rules.md

- **Intent:** Help agents make correct choices without user intervention
- **Expected Outcome:** Decision tree section in aps-rules.md
- **Validation:** Visual inspection shows tree with 10+ decision points
- **Confidence:** high
- **Tree structure:**
  ```markdown
  ## AI Agent Decision Tree

  When user asks to...
  ├─ "Create a plan" or "Plan X"
  │  ├─ Single feature? → Use simple.template.md
  │  ├─ 2-5 modules? → Use index.template.md + module.template.md
  │  └─ 6+ modules? → Use index-expanded.template.md
  │
  ├─ "Add a work item" or "Create work item for X"
  │  ├─ Module exists? → Add to existing module file
  │  ├─ Module doesn't exist? → Ask: should I create module first?
  │  └─ Not sure which module? → Ask user to clarify
  │
  ├─ "Execute work item" or "Implement X"
  │  ├─ Status = Ready? → Proceed
  │  ├─ Status = Draft? → Ask user to approve first
  │  ├─ No status field? → Assume not started, confirm with user
  │  └─ Prerequisites exist? → Check dependencies completed
  │
  └─ "Create action plan" or "Break down work item"
     ├─ Work item complex (>3 actions)? → Create action plan file
     ├─ Work item simple? → Execute directly, no action plan needed
     └─ Checkpoints >12 words? → Simplify to observable outcome only
  ```

### EDOC-003: Enhance prompting docs with before/after examples

- **Intent:** Show concrete impact of following APS conventions
- **Expected Outcome:** Each prompt file has 2-3 before/after pairs
- **Validation:** All files in docs/ai/prompting/ have examples section
- **Confidence:** high
- **Files to enhance:**
  - `index.prompt.md` — good vs bad index
  - `module.prompt.md` — good vs bad module
  - `work-item.prompt.md` — good vs bad work item
  - `actions.prompt.md` — lean vs verbose checkpoints

### EDOC-004: Create comprehensive glossary

- **Intent:** Single source of truth for all APS terms
- **Expected Outcome:** Glossary section in docs/TERMINOLOGY.md with 20+ terms
- **Validation:** All core terms defined with examples
- **Confidence:** high
- **Terms to define:**
  - Index, Module, Work Item, Action Plan, Action, Checkpoint
  - Ready, Draft, In Progress, Blocked, Complete
  - Execution authority, Observable outcome, Validation command
  - Module ID, Work Item ID, Dependency, Boundary rule
  - Lean checkpoint, Implementation detail, Intent

### EDOC-005: Add glossary to README

- **Intent:** Make key terms discoverable from main entry point
- **Expected Outcome:** README has glossary section or link to TERMINOLOGY.md
- **Validation:** README includes definitions of 5 core terms
- **Confidence:** high
- **Core terms for README:**
  - Index — root plan
  - Module — bounded work area
  - Work Item — execution authority
  - Action Plan — checkpoint-based breakdown
  - Checkpoint — observable state

### EDOC-006: Create troubleshooting guide

- **Intent:** Help users debug common issues
- **Expected Outcome:** docs/troubleshooting.md with 10+ scenarios
- **Validation:** File exists with solutions for common problems
- **Confidence:** medium
- **Scenarios:**
  - "AI isn't following lean checkpoint rule"
  - "Not sure if I need index or simple template"
  - "Work item seems too big to execute"
  - "Module dependencies are unclear"
  - "Validation command keeps failing"
  - "Lost track of what's complete vs in progress"
  - "AI agent generated implementation in checkpoint"
  - "Should I split this module?"
  - "Module is Ready but work items aren't defined"
  - "Scaffold created structure I don't need"

### EDOC-007: Add solo developer guidance

- **Intent:** Show individual developers how to use APS effectively
- **Expected Outcome:** Section in docs/workflow.md or new docs/solo-dev.md
- **Validation:** Document addresses solo-specific concerns
- **Confidence:** medium
- **Content:**
  - Using @me or GitHub username for Owner field
  - When to create specs vs just coding
  - Treating APS as "notes to future self"
  - Minimal workflow (quickstart → work → done)
  - No approval process needed (you approve yourself)

### EDOC-008: Create mid-project adoption guide

- **Intent:** Help teams add APS to existing projects
- **Expected Outcome:** Guide at docs/adoption.md with step-by-step
- **Validation:** Document covers partial adoption strategy
- **Confidence:** medium
- **Sections:**
  - Start with Index capturing current state
  - Add modules for active work only (don't retrofit everything)
  - Use simple.template.md for one-off features
  - Gradually expand coverage as needed
  - Handle legacy work (mark as "before APS" or ignore)

### EDOC-009: Add "good vs bad" comparison table to aps-rules.md

- **Intent:** Quick reference for agents to check their work
- **Expected Outcome:** Table with 10+ comparisons
- **Validation:** Visual inspection of aps-rules.md
- **Confidence:** high
- **Comparisons:**
  | Bad | Good |
  |-----|------|
  | "Implement JWT auth using jsonwebtoken" | "Add token-based authentication" |
  | "Middleware created with 5 specific functions..." | "Auth middleware validates requests" |
  | "Create UserService class" | "User operations are encapsulated" |
  | Task-001, Task-002 | AUTH-001, AUTH-002 |
  | "Setup complete" | "Migration file exists with users table" |

### EDOC-010: Update README with npm init as hero

- **Intent:** Make npm init the primary onboarding path
- **Expected Outcome:** README Quick Start section shows npm init first
- **Validation:** npm init command appears before scaffold script
- **Confidence:** high
- **Dependencies:** INIT-010 (npm package published)
- **Structure:**
  ```markdown
  ## Quick Start

  ### Option A: npm (recommended)
  ```bash
  npm init aps
  # or
  npx create-aps
  ```

  ### Option B: Scaffold script
  ```bash
  curl -fsSL https://raw.githubusercontent.com/.../scaffold/init.sh | bash
  ```
  ```

## Execution

Action Plan: [../../execution/v0.3/EDOC.actions.md](../../execution/v0.3/EDOC.actions.md)

## Decisions

- **D-001:** Decision tree format — *decided: markdown indented list (readable in terminal)*
- **D-002:** Before/after examples — *decided: use real-world auth/user domain*
- **D-003:** Glossary location — *decided: TERMINOLOGY.md as canonical, summary in README*
- **D-004:** Solo dev guidance — *decided: section in workflow.md (keep docs consolidated)*

## Notes

- Terminology audit should be final pass (after all other v0.3 work)
- Consider regex patterns for common terminology mistakes
- Good vs bad comparisons are teaching tools (make them realistic)
- Troubleshooting guide will grow over time based on user feedback
