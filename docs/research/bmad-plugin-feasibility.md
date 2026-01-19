# BMAD Method Plugin Feasibility Research

> Research conducted: 2026-01-19
> Status: Feasibility Analysis Complete

## Executive Summary

Building an APS plugin for BMAD Method is **highly feasible** and presents a compelling integration opportunity. Both frameworks share philosophical alignment around structured human-AI collaboration, and their complementary strengths create natural synergy points. BMAD excels at guided workflow execution with specialized agents, while APS provides a trust/authorization layer with observable checkpoints.

**Recommendation:** Proceed with plugin development, starting with a bidirectional integration that allows BMAD workflows to generate APS specs and BMAD agents to consume/validate APS artifacts.

---

## 1. BMAD Method Overview

### What is BMAD?

BMAD Method ("Build More, Architect Dreams") is an AI-driven agile development framework featuring:
- **21 specialized agents** (PM, Architect, Developer, UX Designer, Scrum Master, etc.)
- **50+ guided workflows** across 4 development phases
- **Scale-adaptive intelligence** (complexity levels 0-4)
- **MIT licensed**, fully open source

Repository: https://github.com/bmad-code-org/BMAD-METHOD

### BMAD Architecture

```
Module (bmm)
├── agents/           # YAML-based agent definitions
│   ├── pm.agent.yaml
│   ├── architect.agent.yaml
│   ├── dev.agent.yaml
│   └── ...
├── workflows/
│   ├── 1-analysis/
│   ├── 2-plan-workflows/
│   ├── 3-solutioning/
│   └── 4-implementation/
├── data/             # Templates and standards
├── teams/            # Team configurations
├── sub-modules/      # Tool integrations (e.g., claude-code/)
└── module.yaml       # Module configuration
```

### BMAD Agent Structure (YAML)

```yaml
# Example: pm.agent.yaml
id: pm
name: "John"
title: "Product Manager"
icon: "📋"
module: bmm
hasSidecar: false

persona:
  role: "Product Manager specializing in collaborative PRD creation..."
  identity: "8+ years launching B2B/consumer products..."
  communication_style: "Direct, data-driven questioning approach"
  principles:
    - "User-centered design"
    - "Iterative validation"
    - "Jobs-to-be-Done framework"

menu:
  - trigger: ["WS", "workflow status"]
    execute: "../workflows/workflow-status/workflow.md"
    description: "Track workflow progress"
  - trigger: ["CP", "create prd"]
    execute: "./workflows/create-prd/workflow.yaml"
    description: "Create Product Requirements Document"
```

### BMAD Workflow Structure

```
workflow/
├── workflow.md           # Workflow documentation
├── template.md           # Output template
└── steps/                # Step-by-step definitions
```

Workflows are organized into 4 phases:
1. **Analysis** - Research, product brief creation
2. **Planning** - PRD, architecture, epic planning
3. **Solutioning** - Design, technical decisions
4. **Implementation** - Sprint execution, reviews

---

## 2. Compatibility Analysis

### Philosophical Alignment

| Aspect | BMAD Method | APS | Alignment |
|--------|-------------|-----|-----------|
| **Core Purpose** | Guided AI collaboration | Trust/authorization layer | High |
| **Human Control** | Humans guide through menus | Humans authorize work items | High |
| **Structure** | Phase-based workflows | Checkpoint-based validation | High |
| **Observability** | Workflow status tracking | Checkpoints (≤12 words) | High |
| **Format** | YAML + Markdown | Pure Markdown | Medium |
| **Complexity Handling** | Scale-adaptive (0-4) | Module/work item hierarchy | High |

### Structural Mapping

| BMAD Concept | APS Equivalent | Mapping Strategy |
|--------------|----------------|------------------|
| Module | Index | 1:1 mapping |
| Workflow Phase | Module | Group workflows by bounded scope |
| Workflow | Work Item | Each workflow becomes an authorized unit |
| Workflow Steps | Action Plan | Steps map to checkpoints |
| Agent Output (PRD, etc.) | Produces/Expected Outcome | Template outputs become APS artifacts |
| Workflow Status | Work Item Status | Direct status sync |

### Complementary Strengths

**BMAD brings to APS:**
- Rich agent personas for guided spec creation
- Structured workflow execution
- Scale-adaptive complexity handling
- Pre-built development lifecycle workflows

**APS brings to BMAD:**
- Authorization/trust layer before execution
- Observable checkpoint validation
- Lean specification format (WHAT not HOW)
- Version-controlled planning artifacts
- Validation framework (CLI linting)

---

## 3. Integration Approaches

### Approach A: BMAD Generates APS (Recommended First Step)

BMAD workflows output APS-formatted specs:

```
BMAD Workflow                    APS Output
─────────────────────────────    ──────────────────────────
brainstorm-project          →    index.aps.md (draft)
create-product-brief        →    index.aps.md (updated)
architecture-planning       →    modules/*.aps.md
epic-story-generation       →    work items in modules
implementation-planning     →    execution/*.actions.md
```

**Implementation:**
1. Create APS output templates for BMAD workflows
2. Add APS generation commands to relevant agents (PM, Architect)
3. Inject APS rules into BMAD agent personas

### Approach B: BMAD Consumes APS

BMAD agents read and validate APS specs:

```
APS Spec                         BMAD Action
─────────────────────────────    ──────────────────────────
index.aps.md                →    PM validates completeness
modules/*.aps.md            →    Architect reviews scope
work items (status=Ready)   →    Dev executes with guidance
checkpoints                 →    SM tracks progress
```

**Implementation:**
1. Create APS reader/parser for BMAD
2. Add APS validation workflows
3. Map APS status to BMAD workflow states

### Approach C: Bidirectional Sync (Full Integration)

```
┌─────────────────┐                    ┌─────────────────┐
│   BMAD Method   │◄──────────────────►│       APS       │
│                 │                    │                 │
│  ┌───────────┐  │   generates        │  ┌───────────┐  │
│  │  Agents   │──┼───────────────────►│  │   Index   │  │
│  └───────────┘  │                    │  └───────────┘  │
│                 │                    │        │        │
│  ┌───────────┐  │   generates        │  ┌─────▼─────┐  │
│  │ Workflows │──┼───────────────────►│  │  Modules  │  │
│  └───────────┘  │                    │  └───────────┘  │
│                 │                    │        │        │
│  ┌───────────┐  │   validates        │  ┌─────▼─────┐  │
│  │  Status   │◄─┼────────────────────│  │Work Items │  │
│  └───────────┘  │                    │  └───────────┘  │
│                 │   reads status     │        │        │
│  ┌───────────┐  │◄───────────────────│  ┌─────▼─────┐  │
│  │Execution  │  │                    │  │  Actions  │  │
│  └───────────┘  │                    │  └───────────┘  │
└─────────────────┘                    └─────────────────┘
```

---

## 4. Technical Implementation Plan

### Phase 1: APS Output Templates for BMAD

Create new BMAD templates that output APS format:

```
src/bmm/data/
├── aps-index.template.md         # Index spec template
├── aps-module.template.md        # Module spec template
├── aps-work-item.template.md     # Work item template
└── aps-actions.template.md       # Action plan template
```

### Phase 2: BMAD Agent Integration

Add APS-aware commands to existing agents:

```yaml
# Addition to pm.agent.yaml menu
- trigger: ["APS", "generate aps"]
  execute: "./workflows/generate-aps-spec/workflow.yaml"
  description: "Generate APS specification from PRD"

- trigger: ["APSV", "validate aps"]
  execute: "./workflows/validate-aps-spec/workflow.yaml"
  description: "Validate APS specification completeness"
```

### Phase 3: APS Workflows

Create dedicated BMAD workflows for APS:

```
src/bmm/workflows/aps/
├── generate-index/
│   ├── workflow.md
│   ├── steps/
│   └── aps-index.template.md
├── generate-modules/
├── validate-spec/
└── sync-status/
```

### Phase 4: Claude Code Sub-Module

Extend existing Claude Code integration:

```
src/bmm/sub-modules/claude-code/
├── config.yaml              # Add APS config options
├── injections.yaml          # Add APS injection points
└── aps-agents/
    ├── aps-spec-creator.yaml
    ├── aps-validator.yaml
    └── aps-checkpoint-tracker.yaml
```

---

## 5. Example Integration Workflow

### User Journey: Feature Development with BMAD + APS

```
1. User starts BMAD: `*workflow-init`
   → BMAD recommends "BMad Method" track

2. Analysis Phase (BMAD)
   → PM agent runs `brainstorm-project`
   → Outputs: project-context.md

3. Generate APS Index (Integration)
   → PM agent runs `generate-aps-spec`
   → Outputs: plans/index.aps.md (status: Draft)

4. Planning Phase (BMAD)
   → PM creates PRD
   → Architect designs solution
   → Each outputs mapped to APS modules

5. Authorization (APS)
   → Human reviews plans/index.aps.md
   → Changes status to "Ready" for approved modules
   → Work items get authorized

6. Implementation Phase (BMAD + APS)
   → Dev agent reads APS work items (status=Ready)
   → Executes with BMAD workflow guidance
   → Updates APS checkpoints on completion

7. Validation (APS)
   → Each checkpoint validated via APS validation commands
   → Work item marked complete when all checkpoints pass
```

---

## 6. Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Format translation complexity | Medium | Start with simple 1:1 mappings, iterate |
| BMAD version changes | Medium | Pin to stable BMAD version, abstract interface |
| Philosophical drift | Low | Both projects share core values |
| Maintenance burden | Medium | Contribute upstream, minimize custom code |
| User confusion (two systems) | Medium | Clear documentation, seamless UX |

---

## 7. Success Criteria

1. **Spec Generation**: BMAD workflows can output valid APS specs
2. **Bidirectional Status**: Work item status syncs between systems
3. **Checkpoint Validation**: BMAD can execute and validate APS checkpoints
4. **Agent Awareness**: BMAD agents understand APS authorization model
5. **User Experience**: Seamless workflow without manual format translation

---

## 8. Recommended Next Steps

1. **Immediate**: Create APS output templates for BMAD's core workflows
2. **Short-term**: Add `generate-aps` command to PM and Architect agents
3. **Medium-term**: Create dedicated APS validation workflows
4. **Long-term**: Full bidirectional sync with status tracking

---

## 9. Resources

### BMAD Method
- Repository: https://github.com/bmad-code-org/BMAD-METHOD
- Documentation: https://docs.bmad-method.org
- License: MIT

### Anvil Plan Spec
- Repository: https://github.com/EddaCraft/anvil-plan-spec
- License: Apache-2.0

---

## Appendix A: BMAD Agent Types

| Agent | Role | APS Integration Point |
|-------|------|----------------------|
| PM (John) | Product requirements | Index, Module generation |
| Architect | Technical design | Module, Work Item creation |
| Developer | Implementation | Work Item execution |
| Analyst | Research & discovery | Index problem statement |
| UX Designer | User experience | Module interfaces |
| Scrum Master | Process management | Status tracking, validation |
| Tech Writer | Documentation | Solution library |

## Appendix B: BMAD Workflow Phases → APS Mapping

| BMAD Phase | Workflows | APS Output |
|------------|-----------|------------|
| 1-Analysis | brainstorm, research | index.aps.md (Problem, Context) |
| 2-Planning | PRD, epic-story | modules/*.aps.md, Work Items |
| 3-Solutioning | architecture, design | Module interfaces, Dependencies |
| 4-Implementation | sprint, review | execution/*.actions.md |

## Appendix C: Key BMAD Files for Integration

```
src/bmm/
├── agents/pm.agent.yaml              # Primary spec generation agent
├── agents/architect.agent.yaml       # Module/interface generation
├── workflows/1-analysis/             # Index content source
├── workflows/2-plan-workflows/       # Work item source
├── data/project-context-template.md  # Adapt for APS
├── sub-modules/claude-code/          # Extend for APS
└── module.yaml                       # Add APS configuration
```
