# Prompts Module

| ID | Owner | Status |
|----|-------|--------|
| PROMPT | @aneki | Draft |

## Purpose

Maintain and expand AI prompts that guide assistants through APS document creation and execution, with potential tool-specific variants for different AI coding assistants.

## In Scope

- Maintain existing prompts in docs/ai/prompting/
- Evaluate need for tool-specific variants (Cursor, Copilot, Windsurf, etc.)
- Improve prompt effectiveness based on usage feedback

## Out of Scope

- Fine-tuning AI models on APS
- Building AI plugins or extensions
- Automated prompt testing infrastructure

## Interfaces

**Depends on:**

- TPL (templates) — prompts reference template structure

**Exposes:**

- docs/ai/prompting/*.prompt.md — AI guidance prompts

## Ready Checklist

- [x] Purpose and scope are clear
- [x] Dependencies identified
- [ ] At least one work item defined

## Work Items

*Define work items when promoting to Ready*

## Notes

- Existing prompts: index.prompt.md, module.prompt.md, actions.prompt.md, work-item.prompt.md
- OpenCode-specific variants exist in docs/ai/prompting/opencode/
- Decision: Tool-specific variants needed, or at minimum a stub/pointer to generic AGENTS.md
