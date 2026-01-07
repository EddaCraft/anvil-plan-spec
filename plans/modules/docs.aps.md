# Documentation Module

| ID | Owner | Status |
|----|-------|--------|
| DOCS | @aneki | Complete |

## Purpose

Improve onboarding and workflow clarity through better documentation structure, concrete examples, and "day in the life" guides.

## In Scope

- Reorganize getting-started.md (decision tree first)
- Create "Development Workflow" guide with concrete examples
- Add completion/archival guidance
- Solo developer documentation

## Out of Scope

- Video tutorials (different medium)
- Tool-specific plugins or integrations
- Translated documentation
- AI prompt variants (covered in existing docs/ai/prompting/)

## Interfaces

**Depends on:**

- TPL (templates) — documentation references current template structure ✓ Complete

**Exposes:**

- docs/getting-started.md — improved onboarding
- docs/workflow.md — new daily workflow guide

## Ready Checklist

- [x] Purpose and scope are clear
- [x] Dependencies identified (TPL complete)
- [x] At least one task defined

## Work Items

### DOCS-001: Reorganize getting-started.md

- **Intent:** Put decision tree first so users immediately know which template to use
- **Expected Outcome:** getting-started.md leads with "Which template?" flowchart, then walks through each path
- **Validation:** Decision tree appears in first 50 lines; markdownlint passes
- **Confidence:** high
- **Status:** ✓ Complete

### DOCS-002: Create workflow.md

- **Intent:** Show concrete "day in the life" examples of using APS
- **Expected Outcome:** New file docs/workflow.md with scenarios: starting a feature, mid-implementation, handoff, completion
- **Validation:** File exists with at least 3 workflow scenarios
- **Confidence:** high
- **Status:** ✓ Complete

### DOCS-003: Add completion guidance

- **Intent:** Clarify what happens when a plan or module is done
- **Expected Outcome:** Section in workflow.md covering: marking complete, archival options, when to delete vs keep
- **Validation:** grep "Completion\|Archive" docs/workflow.md returns matches
- **Confidence:** high
- **Status:** ✓ Complete

### DOCS-004: Add solo developer notes

- **Intent:** Address feedback that APS feels "heavy" for solo devs
- **Expected Outcome:** Section in getting-started.md or workflow.md with solo dev guidance (use Simple template, skip formal modules)
- **Validation:** grep -i "solo" docs/*.md returns matches
- **Confidence:** high
- **Status:** ✓ Complete

### DOCS-005: Surface examples more prominently

- **Intent:** Address "examples are buried" feedback
- **Expected Outcome:** README and getting-started.md link to examples earlier; examples/ appears in quick start section
- **Validation:** Examples link appears in first 100 lines of README
- **Confidence:** high
- **Status:** ✓ Complete

## Execution

Steps: [../execution/DOCS.steps.md](../execution/DOCS.steps.md)

## Notes

- Reference the hello world example from README (already exists)
- Keep docs concise — avoid duplicating template content
