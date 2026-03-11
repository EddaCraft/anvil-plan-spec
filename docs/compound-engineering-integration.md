# Compound Engineering Plugin Integration

How to use APS alongside the [Compound Engineering plugin](https://github.com/EveryInc/compound-engineering-plugin) (CE).

## How They Complement Each Other

APS and CE solve different layers of the same problem:

| Layer | APS | CE Plugin |
|-------|-----|-----------|
| **Spec format** | Structured, lintable, vendor-agnostic markdown | Freeform plan markdown in `docs/plans/` |
| **Validation** | CLI linting with error codes (E001-E013) | None |
| **Execution authority** | Explicit work item authorization model | Implicit (plan approval via conversation) |
| **Orchestration** | Lightweight commands (`/work`, `/review`, `/compound`) | Full loop with 28 agents and 22 commands |
| **Review** | Four perspectives (architecture, security, simplicity, correctness) | 15 specialized review agents |
| **Research** | Not provided — use CE or other tools | 5 research agents |
| **Platform scope** | Any AI tool, any IDE | Claude Code primary, Cursor secondary |

**The recommended split:**

- **APS** for the spec layer — structured planning, validation, execution authority
- **CE** for deep orchestration — research agents, detailed multi-agent review, knowledge capture at scale

## Using Both Together

### Directory Structure

APS and CE use separate directories. No conflicts:

```text
your-project/
├── plans/                  # APS specs (structured, linted)
│   ├── aps-rules.md
│   ├── index.aps.md
│   ├── modules/
│   ├── execution/
│   └── decisions/
├── docs/
│   ├── plans/              # CE plans (freeform markdown)
│   ├── research/           # CE research output
│   └── solutions/          # Shared — both APS and CE write here
├── aps-planning/           # APS skill and hooks
└── .claude/
    ├── commands/           # APS commands (/plan, /work, /review, /compound)
    └── settings.local.json # Can include both APS and CE hooks
```

### Workflow

Use APS for structured planning, then choose APS or CE commands for execution:

1. **Plan** — Use `/plan` to create APS specs with validated structure
2. **Research** — Use `/ce:research` for deep codebase or best-practice research (APS does not provide research agents)
3. **Execute** — Use `/work` (APS, spec-aware) or `/ce:work` (CE, freeform)
4. **Review** — Use `/review` (APS, four perspectives against spec) or `/ce:review` (CE, 15 specialized agents)
5. **Learn** — Use `/compound` (APS, writes to `docs/solutions/` and `plans/decisions/`) or `/ce:compound` (CE, parallel sub-agents)

### When to Use Which

| Situation | Use |
|-----------|-----|
| Creating a structured plan with validation | APS `/plan` |
| Quick research on codebase patterns | CE `/ce:research` |
| Executing a work item with authority checks | APS `/work` |
| Deep multi-agent review with 15 perspectives | CE `/ce:review` |
| Spec-focused review (does it match the plan?) | APS `/review` |
| Capturing a solution to a tricky problem | Either — both write to `docs/solutions/` |
| Recording an architecture decision | APS `/compound` (writes to `plans/decisions/`) |

### Hook Coexistence

Both APS and CE use Claude Code hooks. They can coexist in `.claude/settings.local.json`. APS hooks focus on plan discipline (re-read specs, update statuses). CE hooks focus on workflow orchestration.

If both are installed, there is no conflict — they trigger on different conditions.

## Teams Without CE

APS is fully self-sufficient. The `/plan`, `/work`, `/review`, and `/compound` commands cover the complete lifecycle without CE. The commands are lighter (no research agents, fewer review perspectives) but spec-aware — they read and update APS files directly.

## Teams Without APS

CE works independently. Its `docs/plans/` format is freeform markdown. Teams that want structured, lintable specs can add APS alongside CE at any time — the two do not interfere.
