# Claude Code Plugin (@aps/claude-code-plugin)

| Field | Value |
|-------|-------|
| Status | Draft |
| Owner | @EddaCraft |
| Created | 2026-01-01 |
| Module ID | CCPLUGIN |

## Purpose

Full-featured Claude Code plugin providing APS integration through commands, agents, skills, and hooks.

## In Scope

- Slash commands: `/aps-plan`, `/aps-validate`, `/aps-task`
- Subagents: plan-analyzer, plan-validator
- Skills: aps-planning, aps-validation (auto-invoked)
- Hooks: SessionStart (setup), PreToolUse (validate writes), Stop (cleanup)
- MCP server integration (optional, for advanced features)
- Marketplace publishing

## Out of Scope

- OpenCode-specific features (those go in opencode-planspec)
- Web UI or visual editors
- Git hosting services integration
- Issue tracker sync (separate module if needed)

## Interfaces

### Plugin Structure

```
aps-claude-code-plugin/
├── .claude-plugin/
│   ├── plugin.json              # Plugin metadata
│   └── marketplace.json         # Publishing config
├── commands/
│   ├── plan.md                  # /aps-plan command
│   ├── validate.md              # /aps-validate command
│   ├── task.md                  # /aps-task command
│   └── module.md                # /aps-module command
├── agents/
│   ├── plan-analyzer.md         # Project analysis agent
│   └── plan-validator.md        # Validation agent
├── skills/
│   ├── aps-planning/
│   │   └── SKILL.md
│   └── aps-validation/
│       └── SKILL.md
├── hooks/
│   ├── hooks.json               # Hook definitions
│   └── scripts/
│       ├── session-start.sh
│       ├── validate-write.sh
│       └── post-check.sh
├── .mcp.json                    # MCP server config (optional)
└── README.md
```

### Commands Interface

**`/aps-plan`** - Create or analyze APS plan
- Analyzes project structure
- Generates index.aps.md following templates
- Interactive refinement with user

**`/aps-validate <file>`** - Validate APS document
- Parses markdown structure
- Checks against schema (via @aps/core)
- Reports errors/warnings with line numbers

**`/aps-task <module-id> <description>`** - Add task to module
- Locates module file
- Appends task with ID
- Updates dependencies if needed

**`/aps-module <name>`** - Create new module
- Renders module template
- Creates file in plans/modules/
- Updates index.aps.md

### Skills Interface

**aps-planning** - Auto-invoked when user discusses planning
```markdown
---
name: aps-planning
description: Generate and work with APS for project planning
allowed-tools: Read, Grep, Glob, Bash
---
[Embedded .aps-rules.md content]
```

**aps-validation** - Auto-invoked for validation tasks
```markdown
---
name: aps-validation
description: Validate APS documents for correctness
allowed-tools: Read, Grep, Glob
---
[Validation rules and schemas]
```

### Agents Interface

**plan-analyzer** - Deep project analysis
- Tools: Read, Grep, Glob, Bash
- Model: sonnet
- Scans codebase, identifies components, generates structured plan

**plan-validator** - Comprehensive validation
- Tools: Read, Grep
- Model: haiku (fast validation)
- Checks structure, cross-references, completeness

### Hooks Interface

```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "bash ~/.claude/plugins/aps/scripts/session-start.sh"
      }]
    }],
    "PreToolUse": [{
      "matcher": "Write.*\\.aps\\.md$",
      "hooks": [{
        "type": "command",
        "command": "bash ~/.claude/plugins/aps/scripts/validate-write.sh $TOOL_INPUT"
      }]
    }],
    "Stop": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "bash ~/.claude/plugins/aps/scripts/post-check.sh"
      }]
    }]
  }
}
```

## Dependencies

- **@aps/core** - Core APS functionality
- **@aps/cli** - For script invocation
- Claude Code SDK (implicit, provided by runtime)

## Acceptance Criteria

- [ ] Plugin installable via `/plugin install aps-integration`
- [ ] All four slash commands work correctly
- [ ] Skills auto-activate when appropriate
- [ ] Agents can be invoked and complete tasks
- [ ] Hooks execute at correct lifecycle points
- [ ] Validation uses @aps/core schemas
- [ ] Published to Claude Code marketplace
- [ ] README with installation and usage examples

## Tasks

*Tasks will be added when module status changes to Ready*

## Execution Notes

Claude Code plugins are **markdown-first** - keep complexity in @aps/core, expose simple markdown interfaces here.

## Risks

| Risk | Mitigation |
|------|------------|
| Claude Code plugin API changes | Monitor changelog, maintain compatibility layer |
| Skill activation unreliable | Strong descriptions, test activation patterns |
| Hook performance impact | Keep scripts fast, async where possible |
| Marketplace approval delays | Test thoroughly, follow guidelines |

## Decisions

- **CCPLUGIN-D001:** Use markdown-first approach (minimal scripting) — *approved*
- **CCPLUGIN-D002:** Hooks call @aps/cli commands, not inline logic — *approved*
- **CCPLUGIN-D003:** Skills embed .aps-rules.md verbatim — *pending*
