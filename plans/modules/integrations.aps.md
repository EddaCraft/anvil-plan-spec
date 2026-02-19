# Integrations Module

| ID | Owner | Status |
|----|-------|--------|
| INT | @aneki | Draft |

## Purpose

Enable APS documents to integrate with external tooling through structured data export, without creating vendor-specific plugins.

## In Scope

- JSON export of APS documents (machine-readable format)
- GitHub Issues sync (read/write work items as issues)
- Structured output for custom tooling
- Import from common formats (if feasible)
- MCP server for AI tool integration (shared with TASKS module)

## Out of Scope

- Vendor-specific plugins (Jira, Linear, Notion) — per Non-Goals
- Real-time sync or webhooks
- Hosted integration services

## Interfaces

**Depends on:**

- VAL (validation) — uses parser logic for document reading

**Exposes:**

- `aps export [file] --format json` — CLI export command
- `aps sync github` — GitHub Issues sync (optional)
- JSON schema for APS documents

## Ready Checklist

- [x] Purpose and scope are clear
- [x] Dependencies identified
- [ ] At least one work item defined

## Work Items

*Define work items when promoting to Ready*

## Notes

- JSON export enables users to build their own integrations
- GitHub sync is included because it's already an APS "platform" (markdown in repos)
- Consider: CSV export for spreadsheet users
