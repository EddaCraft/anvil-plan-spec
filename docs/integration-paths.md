# APS Integration Paths

There are two ways to integrate APS with your AI coding tool: **Full Plugins** or **Generators**.

## Quick Comparison

| Feature | Full Plugins | Generators |
|---------|-------------|------------|
| **Installation** | One command | Generate files, copy to tool dirs |
| **Updates** | Automatic (plugin update) | Manual (`aps generate sync`) |
| **Customization** | Limited (plugin config) | Full control (edit generated files) |
| **Complexity** | Higher (plugin system) | Lower (just files) |
| **Tool Support** | Depends on marketplace | Works anywhere |
| **Best For** | Production use, teams | Experimentation, solo devs |

---

## Path 1: Full Plugins (Recommended for Teams)

Complete plugin packages with all features integrated.

### Claude Code Plugin

**Installation:**
```bash
/plugin install aps-integration@eddacraft/aps-claude-code-plugin
```

**Features:**
- ✅ Slash commands: `/aps-plan`, `/aps-validate`, `/aps-task`, `/aps-module`
- ✅ Auto-invoked skills: Planning and validation expertise
- ✅ Specialized agents: Deep analysis and validation
- ✅ Hooks: Auto-setup, write validation, post-checks
- ✅ Updates: Plugin updates bring new features

**Use when:**
- Working in a team with shared standards
- Want consistent APS behavior across team
- Prefer one-command installation
- Want automatic updates

### OpenCode Plugin

**Installation:**
```bash
bunx oh-my-opencode install --with-planning
# Or standalone:
npm install -g opencode-planspec
```

**Features:**
- ✅ Commands: `/plan`, `/module`, `/validate`
- ✅ Tools: Validation, task finding
- ✅ Skills: APS planning guidance
- ✅ Hooks: Context injection
- ✅ MCP servers: Optional advanced features

**Use when:**
- Using oh-my-opencode (OMO)
- Want TypeScript-based extensibility
- Need MCP server integration
- Building on OpenCode ecosystem

---

## Path 2: Generators (Recommended for Solo/Experimentation)

Generate skills and commands from templates - lightweight, customizable.

### How It Works

```bash
# 1. Install CLI
npm install -g @aps/cli

# 2. Generate for your tool
aps generate skill claude-code     # Creates ~/.claude/skills/aps-planner/
aps generate skill opencode        # Creates .opencode/skills/aps-planner/
aps generate rules cursor          # Creates .cursorrules
aps generate config aider          # Creates .aider.conf.yml

# 3. Generated files are ready to use - no plugin installation needed

# 4. Customize as needed (edit generated files)

# 5. Update when templates change
aps generate sync
```

### What Gets Generated

**For Claude Code:**
```
~/.claude/skills/aps-planner/
├── SKILL.md                 # APS planning skill with .aps-rules.md
├── templates/               # All APS templates
│   ├── index.template.md
│   ├── module.template.md
│   ├── simple.template.md
│   └── steps.template.md
└── scripts/                 # Helper scripts
    ├── validate.sh
    └── scaffold.sh
```

**For OpenCode:**
```
.opencode/skills/aps-planner/
├── SKILL.md                 # APS planning skill
└── templates/               # APS templates
```

**For Cursor:**
```
.cursorrules                 # APS rules embedded in Cursor config
```

**For Aider:**
```
.aider.conf.yml              # Architect mode prompts for APS
```

### Use When:

- ✅ Want full control over generated files
- ✅ Experimenting with APS integration
- ✅ Solo developer or small team
- ✅ Don't want plugin marketplace dependencies
- ✅ Working on restricted systems
- ✅ Need to customize heavily

### Advantages

1. **No Plugin System Required** - Just files in the right places
2. **Full Transparency** - See exactly what's generated
3. **Easy Customization** - Edit any generated file
4. **Works Anywhere** - No marketplace, no approval process
5. **Faster Iteration** - Regenerate and test immediately

### Disadvantages

1. **Manual Updates** - Run `aps generate sync` when templates update
2. **More Setup** - Need to understand where files go
3. **Divergence Risk** - Custom edits may conflict with updates

---

## Comparison Matrix

### Claude Code Integration

| Aspect | Plugin | Generator |
|--------|--------|-----------|
| Installation | `/plugin install aps-integration` | `aps generate skill claude-code` |
| Location | Plugin system | `~/.claude/skills/aps-planner/` |
| Commands | Automatic | Manual creation if wanted |
| Agents | Included | Not included (use main Claude) |
| Hooks | Automatic | Manual setup |
| Updates | `/plugin update` | `aps generate sync` |
| Customization | Config only | Full file editing |

### OpenCode Integration

| Aspect | Plugin | Generator |
|--------|--------|-----------|
| Installation | `npm install opencode-planspec` | `aps generate skill opencode` |
| Location | node_modules | `.opencode/skills/aps-planner/` |
| Commands | TypeScript | Generated markdown |
| Tools | Full API | Basic via skill |
| MCP Servers | Yes | No |
| Updates | `npm update` | `aps generate sync` |
| Customization | Limited | Full |

---

## Which Should I Choose?

### Choose Full Plugins if:

- ✅ You want the **complete experience** with all features
- ✅ You're working in a **team** that needs consistency
- ✅ You prefer **automatic updates**
- ✅ You're using **oh-my-opencode** (it bundles the OpenCode plugin)
- ✅ You want **specialized agents** for analysis and validation
- ✅ You need **hooks** for automatic enforcement

### Choose Generators if:

- ✅ You want to **try APS quickly** without commitment
- ✅ You're a **solo developer** or small team
- ✅ You need **full control** over integration
- ✅ You want to **customize heavily**
- ✅ You're on a **restricted system** without marketplace access
- ✅ You prefer **simple, transparent** tools

### Can I Use Both?

**Yes!** You can:
- Start with generators to experiment
- Switch to full plugin when ready for production
- Use plugins on some projects, generators on others
- Use generators for quick prototypes, plugins for main work

---

## Examples

### Example 1: Solo Developer Experimenting

```bash
# Quick start with generators
npm install -g @aps/cli
aps generate skill claude-code
# Edit ~/.claude/skills/aps-planner/SKILL.md to customize
# Start using APS in Claude Code immediately
```

### Example 2: Team Using oh-my-opencode

```bash
# Full plugin approach
bunx oh-my-opencode install --with-planning
# Everyone on team gets same APS integration
# Updates handled by OMO updates
```

### Example 3: Hybrid Approach

```bash
# Use plugin for main project
/plugin install aps-integration

# Use generator for experimental side project
cd ~/side-project
aps generate skill claude-code --local
# Generates .claude/skills/aps-planner/ in current project
```

---

## Migration Paths

### From Generator to Plugin

```bash
# 1. Remove generated files
rm -rf ~/.claude/skills/aps-planner/

# 2. Install plugin
/plugin install aps-integration

# 3. Your plans/ directory still works - no changes needed
```

### From Plugin to Generator

```bash
# 1. Disable plugin
/plugin disable aps-integration

# 2. Generate files
aps generate skill claude-code

# 3. Customize generated files as needed
```

---

## Getting Started

### Quick Start with Generators

```bash
# 1. Install CLI
npm install -g @aps/cli

# 2. Generate for your tool of choice
aps generate skill claude-code    # Or opencode, cursor, aider

# 3. Start using APS
# In Claude Code: Skills auto-activate
# In OpenCode: Skills available in .opencode/skills/
# In Cursor: Rules active in .cursorrules
```

### Quick Start with Plugins

```bash
# For Claude Code:
/plugin install aps-integration@eddacraft/aps-claude-code-plugin
/aps-plan

# For OpenCode (via OMO):
bunx oh-my-opencode install --with-planning
/plan

# For OpenCode (standalone):
npm install -g opencode-planspec
/plan
```

---

## FAQ

**Q: Can I customize plugins?**
A: Limited - via plugin config. For full customization, use generators.

**Q: Will generators get updates?**
A: Yes - run `aps generate sync` when new templates are available.

**Q: Which is "better"?**
A: Depends on your needs. Plugins for teams/production, generators for solo/experimentation.

**Q: Can I contribute to plugins?**
A: Yes! Both plugins are open source. See CONTRIBUTING.md.

**Q: Do I need @aps/core directly?**
A: No - CLI includes it. Only needed if building your own tools.

**Q: What about Cursor/Aider?**
A: Currently only generators - they don't have plugin systems like Claude Code/OpenCode.

---

## Next Steps

1. **Choose your path** based on the guidance above
2. **Follow installation** for your chosen approach
3. **Try APS** on a small project first
4. **Share feedback** to help improve both approaches

See also:
- [Installation Guide](./installation.md)
- [Getting Started with APS](./getting-started.md)
- [Plugin Development](./plugin-development.md)
