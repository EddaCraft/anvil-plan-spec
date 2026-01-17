# Anvil Plan Spec CLI

Command-line tool to initialize [Anvil Plan Spec (APS)](https://github.com/EddaCraft/anvil-plan-spec) structure in your projects.

## What is APS?

Anvil Plan Spec (APS) is a lightweight, portable specification format for planning and work authorization in AI-assisted development. It provides:

- **Structured planning** before implementation begins
- **Execution authority** through work items that AI agents can act on
- **Observable checkpoints** for tracking progress
- **Zero vendor lock-in** - pure markdown, versioned in git

## Installation

### Global Installation

```bash
npm install -g @anvil-plan-spec/cli
```

Then use the `aps` command anywhere:

```bash
aps init
```

### One-Time Use with npx

```bash
npx @anvil-plan-spec/cli init
```

## Quick Start

1. **Initialize APS in your project:**

   ```bash
   cd your-project
   aps init
   ```

2. **Follow the interactive prompts** to choose your project type

3. **Start planning!** Edit `plans/index.aps.md` to define your work

## Usage

### Interactive Mode (Recommended)

```bash
# Initialize in current directory
aps init

# Initialize in specific directory
aps init ./my-project
```

The CLI will ask you:
- **Project type**: quickstart, simple, module, multi-module, or large initiative
- **Project name**: Used in templates
- **Module prefix**: For multi-module projects (e.g., AUTH, PAY)
- **Include examples**: Sample modules to get started
- **Include decisions**: Directory for decision records (ADRs)

### Non-Interactive Mode

Perfect for scripts and CI/CD:

```bash
# Minimal setup
aps init --non-interactive --type simple --name "My Feature"

# With all options
aps init --non-interactive \
  --type multi \
  --name "My Project" \
  --force
```

### Update Mode

Refresh templates in an existing APS project without overwriting your work:

```bash
aps init --update
```

This will:
- ✓ Update `.template.md` files
- ✓ Update `aps-rules.md`
- ✓ **Preserve** all your `.aps.md` files

## Project Types

| Type | Description | Use Case | Time |
|------|-------------|----------|------|
| **quickstart** | Single file, minimal structure | Try APS quickly | 5 min |
| **simple** | Small features (1-3 work items) | Bug fixes, small enhancements | 15 min |
| **module** | Single bounded feature with interfaces | Complete feature modules | 30 min |
| **multi** | Multiple modules (2-6) | Typical projects | 1 hour |
| **large** | Complex initiatives (6+ modules) | Large projects | 1-2 hours |

## Options

| Option | Description |
|--------|-------------|
| `--update` | Update templates in existing APS project |
| `--force` | Skip safety prompts (use with caution) |
| `--non-interactive` | Run without prompts (requires `--type`) |
| `--type <type>` | Project type: `quickstart`, `simple`, `module`, `multi`, `large` |
| `--name <name>` | Project name for templates |
| `--help, -h` | Show help message |
| `--version, -v` | Show version number |

## Examples

### Create a Quickstart Project

```bash
aps init --type quickstart --name "Try APS"
```

### Multi-Module Project

```bash
aps init --type multi --name "E-commerce Platform"
```

### Update Existing Project

```bash
cd existing-project-with-aps
aps init --update
```

### Custom Directory

```bash
aps init ~/projects/my-app --type simple
```

## What Gets Created

```
your-project/
└── plans/
    ├── .aps-version           # Version tracking
    ├── index.aps.md          # Main planning file
    ├── aps-rules.md          # AI agent guidance (portable!)
    ├── modules/
    │   ├── .module.template.md
    │   └── .simple.template.md
    ├── execution/
    │   └── .actions.template.md
    └── decisions/            # Optional
```

## Next Steps After Init

1. **Edit** `plans/index.aps.md` to define your work items or modules
2. **Share** `plans/aps-rules.md` with your AI assistant for best results
3. **Learn** the workflow at [Getting Started Guide](https://github.com/EddaCraft/anvil-plan-spec/blob/main/docs/getting-started.md)
4. **Explore** examples at [examples/](https://github.com/EddaCraft/anvil-plan-spec/tree/main/examples)

## Workflow Integration

### With AI Assistants (Claude, GitHub Copilot, etc.)

Share `plans/aps-rules.md` with your AI assistant:

```
"I'm using Anvil Plan Spec for planning. Here are the rules: [paste aps-rules.md]

Let's work on plans/modules/auth.aps.md"
```

### With Git

```bash
# Commit your plans
git add plans/
git commit -m "Add APS planning structure"

# Plans are version-controlled alongside code
git log plans/
```

### With CI/CD

Coming soon: `aps lint` to validate plans in CI.

## Troubleshooting

### "Directory not empty" Warning

This is a safety feature. Options:
- Use `--force` to skip the prompt
- Create APS structure in a subdirectory
- Confirm you want to proceed

### "No APS structure detected" Error

You used `--update` but the directory doesn't have APS structure. Remove `--update` to initialize fresh.

### Permission Errors

Ensure you have write access to the target directory:

```bash
ls -la /path/to/directory
```

## Migrating from Bash Script

If you're using the bash scaffold script (`scaffold/init.sh`), the CLI provides the same functionality with better UX:

| Bash Script | CLI Equivalent |
|-------------|----------------|
| `./scaffold/init.sh` | `aps init` |
| `./scaffold/init.sh my-project` | `aps init my-project` |
| `./scaffold/init.sh --update` | `aps init --update` |

The bash script remains available for environments where Node.js isn't available.

## Repository Identification

The CLI can initialize APS in any directory. To use APS across multiple repositories:

1. **Per-repository**: Run `aps init` in each repository
2. **Monorepo**: Run `aps init` once at the root, or in each package
3. **Multi-repo project**: Share `aps-rules.md` across repos, maintain separate plans

## Contributing

Contributions welcome! Please see [CONTRIBUTING.md](https://github.com/EddaCraft/anvil-plan-spec/blob/main/CONTRIBUTING.md).

## License

MIT - see [LICENSE](https://github.com/EddaCraft/anvil-plan-spec/blob/main/LICENSE)

## Links

- [Main Repository](https://github.com/EddaCraft/anvil-plan-spec)
- [Documentation](https://github.com/EddaCraft/anvil-plan-spec/tree/main/docs)
- [Examples](https://github.com/EddaCraft/anvil-plan-spec/tree/main/examples)
- [Issue Tracker](https://github.com/EddaCraft/anvil-plan-spec/issues)
