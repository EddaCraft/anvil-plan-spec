# Anvil Plan Spec (APS)

A lightweight specification format for planning and task authorisation in
AI-assisted development.

## What is APS?

APS provides a structured way to:

- **Plan work** before implementation begins
- **Authorise tasks** that AI agents can execute
- **Track execution** through observable checkpoints

It acts as a trust layer between humans and AI — humans remain accountable
for decisions while AI assists with planning and implementation.

## Hierarchy

```mermaid
graph TD
    A[Index] -->|contains| B[Leaf/Module]
    B -->|contains| C[Task]
    C -->|executed via| D[Steps]

    A -.-|"non-executable<br/>describes intent"| A
    B -.-|"executable if Ready<br/>bounded scope"| B
    C -.-|"execution authority<br/>single outcome"| C
    D -.-|"checkpoints<br/>observable actions"| D
```

| Layer | Purpose | Executable? |
|-------|---------|-------------|
| **Index** | High-level plan with modules and milestones | No |
| **Leaf/Module** | Bounded scope with interfaces and tasks | If status is Ready |
| **Task** | Single coherent change with validation | Yes — execution authority |
| **Steps** | Ordered actions with checkpoints | Yes — granular execution |

## Quick Start

1. **Copy templates** from `templates/` to your project
2. **Create an Index** to define your plan's scope and modules
3. **Create Leaf modules** for each bounded area of work
4. **Add Tasks** when a module is ready for implementation
5. **Generate Steps** (optional) for granular execution guidance

See [Getting Started](docs/getting-started.md) for a complete walkthrough.

## Templates

| Template | Use When |
|----------|----------|
| [index.template.md](templates/index.template.md) | Starting a new plan or initiative |
| [leaf.template.md](templates/leaf.template.md) | Defining a bounded module with tasks |
| [simple.template.md](templates/simple.template.md) | Small, self-contained features |
| [steps.template.md](templates/steps.template.md) | Breaking tasks into executable steps |

## Examples

- [User Authentication](examples/user-auth/) — Adding auth to an existing app
- [OpenCode Companion App](examples/opencode-companion/) — Building a companion tool

## AI Guidance

APS includes prompts for AI assistants:

- [docs/ai/prompting/](docs/ai/prompting/) — Tool-agnostic prompts
- [docs/ai/prompting/opencode/](docs/ai/prompting/opencode/) — OpenCode/Claude variants

See [AGENTS.md](AGENTS.md) for collaboration rules when using AI in this repo.

## Principles

1. **Specs describe intent** — what and why, not how
2. **Tasks authorise execution** — no task, no implementation
3. **Humans remain accountable** — AI proposes, humans approve
4. **Checkpoints are observable** — every step has a verifiable state

## Project Structure

```text
your-project/
├── plans/
│   ├── index.aps.md              # Main plan
│   ├── modules/                  # Leaf modules
│   │   ├── auth.aps.md
│   │   └── payments.aps.md
│   ├── execution/                # Step files
│   │   └── AUTH-001.steps.md
│   └── decisions/                # ADRs (optional)
│       └── 001-use-jwt.md
```

## Versioning

This project does not currently publish versioned releases. The `main` branch
is considered stable. See [CHANGELOG.md](CHANGELOG.md) for recent changes.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Apache-2.0. See [LICENSE](LICENSE).
