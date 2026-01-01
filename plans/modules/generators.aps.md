# APS Generators for Skills & Commands

| Field | Value |
|-------|-------|
| Status | Draft |
| Owner | @EddaCraft |
| Created | 2026-01-01 |
| Module ID | GEN |

## Purpose

CLI generators that create skills, slash commands, and hooks from APS templates - providing lightweight integration for users who don't want full plugins.

## In Scope

- `aps generate skill <tool>` - Generate skill for Claude Code, OpenCode, etc.
- `aps generate command <tool>` - Generate slash commands
- `aps generate hooks <tool>` - Generate hook configurations
- Templates for each tool (Claude Code, OpenCode, Cursor, Aider)
- Installation helpers (copy to correct directories)
- Update/sync commands when APS templates change

## Out of Scope

- Full plugin packaging (that's handled by plugin modules)
- Tool-specific complex logic (keep generated code simple)
- Automatic installation (user manually copies files)

## Interfaces

### CLI Commands

```bash
# Generate Claude Code skill
aps generate skill claude-code
# Creates ~/.claude/skills/aps-planner/SKILL.md

# Generate OpenCode skill
aps generate skill opencode
# Creates .opencode/skills/aps-planner/SKILL.md

# Generate Cursor rules
aps generate rules cursor
# Creates .cursorrules with APS guidance

# Generate slash commands
aps generate command claude-code plan
# Creates ~/.claude/commands/aps-plan.md

# Update existing generated files
aps generate sync
# Updates all previously generated files
```

### Generator Templates

**Claude Code Skill Template:**
```markdown
---
name: aps-planning
description: Generate and work with Anvil Plan Specifications
allowed-tools: Read, Grep, Glob, Bash, Write, Edit
version: {{ APS_VERSION }}
---

{{ .aps-rules.md content }}

## Templates

Available at ~/.claude/skills/aps-planner/templates/:
- index.template.md
- module.template.md
- simple.template.md
- steps.template.md

## Commands

Use these commands for APS operations:
```bash
aps validate <file>    # Validate APS document
aps scaffold <dir>     # Initialize plans/ directory
aps list tasks         # Show Ready tasks
```

{{ Additional guidance }}
```

**OpenCode Skill Template:**
```markdown
---
name: aps-planning
description: Generate and work with Anvil Plan Specifications for project planning
---

{{ .aps-rules.md content }}

## OpenCode-Specific Instructions

When working in OpenCode:
- Use `plans/` directory at project root
- Reference .aps-rules.md for guidance
- Follow template structure strictly

{{ Additional guidance }}
```

**Cursor Rules Template:**
```markdown
# APS Planning Rules for Cursor

{{ .aps-rules.md content }}

## Quick Commands

Before implementing features:
1. Check for plans/index.aps.md
2. If missing, create using template
3. Get user approval before execution

## Templates

Download from: https://raw.githubusercontent.com/EddaCraft/anvil-plan-spec/main/templates/
```

**Aider Config Template:**
```yaml
# .aider.conf.yml - APS Integration
architect-prompts:
  - "Check plans/ directory for APS specifications"
  - "Only execute tasks marked with Ready status"
  - "Follow APS hierarchy: Index → Module → Task → Steps"

lint-cmds:
  - "aps validate plans/"
```

### Generator Logic

```typescript
// @aps/cli/src/generators/skill.ts
export async function generateSkill(tool: ToolType, options: GenerateOptions) {
  const templates = {
    'claude-code': claudeCodeSkillTemplate,
    'opencode': opencodeSkillTemplate,
    'cursor': cursorRulesTemplate,
    'aider': aiderConfigTemplate
  }

  const targetPaths = {
    'claude-code': '~/.claude/skills/aps-planner/',
    'opencode': './.opencode/skills/aps-planner/',
    'cursor': './.cursorrules',
    'aider': './.aider.conf.yml'
  }

  // 1. Load .aps-rules.md and templates from @aps/core
  const apsRules = await core.getAPSRules()
  const templates = await core.getTemplates()

  // 2. Render tool-specific template
  const content = await renderTemplate(templates[tool], {
    APS_VERSION: core.VERSION,
    APS_RULES: apsRules,
    TEMPLATES: templates
  })

  // 3. Copy templates to target directory
  const targetPath = expandPath(targetPaths[tool])
  await fs.mkdir(targetPath, { recursive: true })
  await fs.writeFile(`${targetPath}/SKILL.md`, content)

  // 4. Copy templates
  for (const [name, template] of Object.entries(templates)) {
    await fs.writeFile(`${targetPath}/templates/${name}`, template)
  }

  // 5. Track generation for sync
  await trackGeneration(tool, targetPath)

  console.log(`✓ Generated ${tool} skill at ${targetPath}`)
}
```

### Sync Mechanism

Track generated files in `~/.aps/generated.json`:
```json
{
  "version": "1.0.0",
  "generated": [
    {
      "tool": "claude-code",
      "type": "skill",
      "path": "~/.claude/skills/aps-planner/",
      "created": "2026-01-01T12:00:00Z",
      "aps_version": "0.1.0"
    },
    {
      "tool": "opencode",
      "type": "command",
      "path": "./.opencode/commands/plan.md",
      "created": "2026-01-01T12:05:00Z",
      "aps_version": "0.1.0"
    }
  ]
}
```

When templates update:
```bash
aps generate sync
# Regenerates all tracked files with new templates
# Warns if user modified files
```

## Dependencies

- **@aps/core** - Templates and rules source
- **handlebars** or **ejs** - Template rendering
- **yaml** - Config generation

## Acceptance Criteria

- [ ] Can generate Claude Code skills
- [ ] Can generate OpenCode skills
- [ ] Can generate Cursor rules
- [ ] Can generate Aider config
- [ ] Generated files work in respective tools
- [ ] `sync` command updates all generated files
- [ ] Detects user modifications before overwriting
- [ ] Installation instructions in output
- [ ] Templates embedded in @aps/core

## Tasks

*Tasks will be added when module status changes to Ready*

## Execution Notes

Generators are **the lightweight path** - users who want full control without plugin complexity.

Key advantages:
1. No plugin marketplace dependencies
2. Users can modify generated files
3. Works even on restricted systems
4. Simpler mental model
5. Faster iteration during development

## Risks

| Risk | Mitigation |
|------|------------|
| Generated files drift from templates | Sync command with warnings |
| Tool directory conventions change | Version detection, path fallbacks |
| User modifications lost on sync | Diff check, backup before overwrite |
| Templates grow stale | CI checks against latest tool versions |

## Decisions

- **GEN-D001:** Track generations in ~/.aps/generated.json — *approved*
- **GEN-D002:** Warn before overwriting modified files — *approved*
- **GEN-D003:** Support both global and project-local generation — *pending*
- **GEN-D004:** Generate skills before commands (higher value) — *approved*
