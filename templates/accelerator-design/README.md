# APS Templates for Accelerator Design

This directory contains specialized APS templates for accelerator lattice design and optimization workflows using Bmad/Tao.

## Overview

These templates adapt the Anvil Plan Spec (APS) format for particle accelerator physics. They provide structured planning for:

- **Lattice design** — Optics matching, chromaticity correction, dynamic aperture
- **Beam optimization** — Emittance reduction, luminosity maximization
- **Machine commissioning** — Validation, error studies, correction strategies
- **Upgrade planning** — New insertion devices, energy upgrades, lattice modifications

## Templates

| File | Purpose | When to Use |
|------|---------|-------------|
| `lattice-module.template.md` | Define a bounded accelerator design module | Starting a new lattice design project or major modification |
| `optics-workitem.example.md` | Example work item for optics matching | Reference for creating physics-focused work items |
| `action-plan.example.md` | Checkpoint-based execution plan | Detailed implementation guide for complex work items |

## Quick Start

### 1. Initialize APS in Your Accelerator Project

```bash
cd your-accelerator-project/
mkdir -p plans/{modules,execution}
cp /path/to/aps/templates/accelerator-design/*.md plans/
```

### 2. Create Your First Module

Copy the lattice module template:

```bash
cp plans/lattice-module.template.md plans/modules/01-final-focus.aps.md
```

Fill in:
- **Problem:** What physics issue needs solving?
- **Success Criteria:** Observable outcomes (beta functions, emittance, tune, etc.)
- **Scope:** Which lattice regions and parameters are involved?
- **Work Items:** Specific, actionable changes with Tao validation commands

### 3. Define Work Items

For each change to the lattice, create a work item with:

- **Intent:** What physics goal does this accomplish?
- **Outcome:** Observable result (measurable via Tao/PyTao)
- **Validation:** Specific command(s) to verify success
- **Dependencies:** Other work items that must complete first

Example:
```markdown
### OPTICS-001: Match beta functions at interaction point

**Intent:** Achieve βx=1.0m, βy=0.01m at IP for optimal luminosity

**Outcome:**
- Beta functions at IP within 5% of target
- Global tune preserved (Qx, Qy within ±0.02)
- All quadrupoles within operational limits

**Validation:**
```bash
tao -lat lattice.bmad -command "show beam@IP; show tune"
```

**Dependencies:** None
```

### 4. Create Action Plans for Complex Work Items

For work items with multiple steps, generate an action plan:

```bash
cp plans/action-plan.example.md plans/execution/OPTICS-001.actions.md
```

Action plans break work into **checkpoints** — observable states that should exist:

```markdown
- [ ] Baseline: Current beta functions at IP recorded
- [ ] Q1F k1 adjusted to 6.5 m⁻² (from 6.2 m⁻²)
- [ ] Beta functions recomputed, βx at IP changed by ~5%
- [ ] Validation: βx at IP = [0.95m to 1.05m] ✓
```

### 5. Execute with Bmad/Tao

Use your existing workflow:

```bash
# Interactive Tao
tao -lat lattice.bmad

# PyTao scripting
python3 scripts/execute_optics_001.py

# Jupyter notebook
jupyter notebook analysis/optics_matching.ipynb
```

After each checkpoint, verify the state and check the box in your action plan.

### 6. Validate and Commit

When a work item completes:

1. Run the validation command from the work item
2. Generate any required plots or reports
3. Update work item status to "Done"
4. Commit lattice changes and APS specs together:

```bash
git add lattices/cesr_optics_matched.bmad
git add plans/modules/01-final-focus.aps.md
git add plans/execution/OPTICS-001.actions.md
git commit -m "OPTICS-001: Match beta functions at IP"
```

## Example Project Structure

```
your-accelerator-project/
├── lattices/
│   ├── main.bmad                    # Current lattice
│   └── optics_matched.bmad          # After OPTICS-001
├── plans/
│   ├── index.aps.md                 # Project: CESR Luminosity Upgrade
│   ├── modules/
│   │   ├── 01-final-focus.aps.md    # Module: Final focus optics
│   │   ├── 02-chromaticity.aps.md   # Module: Chromaticity correction
│   │   └── 03-dynamic-aperture.aps.md # Module: Nonlinear optimization
│   ├── execution/
│   │   ├── OPTICS-001.actions.md    # Detailed steps for beta matching
│   │   └── CHROM-001.actions.md     # Sextupole family adjustments
│   └── aps-rules.md                 # APS guidance for AI agents
├── scripts/
│   ├── match_optics_ip.py           # PyTao automation scripts
│   └── plot_beta_functions.py       # Visualization helpers
├── validation/
│   ├── optics-001-summary.md        # Validation results
│   └── plots/                       # Beta functions, phase advance, etc.
└── README.md
```

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│  1. PLAN                                                │
│  Define problem, success criteria, work items           │
│  Output: APS module spec                                │
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────┐
│  2. BREAK DOWN                                          │
│  Create action plan with observable checkpoints         │
│  Output: APS action plan                                │
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────┐
│  3. EXECUTE                                             │
│  Use Tao/PyTao to modify lattice, validate checkpoints  │
│  Output: Modified lattice file(s)                       │
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────┐
│  4. VALIDATE                                            │
│  Run validation commands, generate plots                │
│  Output: Validation summary, plots                      │
└─────────────────────┬───────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────┐
│  5. COMMIT                                              │
│  Update work item status, commit lattice + specs        │
│  Output: Git commit with full traceability              │
└─────────────────────────────────────────────────────────┘
```

## Key Concepts

### Observable Physics Outcomes

Unlike software development, accelerator design success is measured by **physics observables**:

- **Twiss parameters:** β, α, γ at specific locations
- **Beam size:** σx, σy (derived from emittance and beta functions)
- **Tunes:** Qx, Qy (betatron oscillation frequencies)
- **Chromaticity:** ξx, ξy (tune dependence on energy)
- **Dynamic aperture:** Minimum stable amplitude for particle tracking
- **Emittance:** Phase space volume occupied by beam
- **Luminosity:** Collision rate (for colliders)

### Validation with Tao Commands

Work items specify **Tao commands** for validation:

```markdown
**Validation:**
```bash
tao -lat lattice.bmad -command "show beam@IP"
```
**Expected:** beta_x = 1.0 ± 0.05 m, beta_y = 0.01 ± 0.0005 m
```

This makes validation **reproducible** and **automatable**.

### Checkpoint-Based Execution

Action plans use **checkpoints** instead of imperative instructions:

❌ **Bad (imperative):**
```markdown
- [ ] Open Tao with the lattice file
- [ ] Adjust the quadrupole strength by 0.1
```

✅ **Good (checkpoint):**
```markdown
- [ ] Baseline: Tao launched with lattice.bmad loaded
- [ ] Q1F k1 adjusted to 6.5 m⁻² (from 6.2 m⁻²)
- [ ] Beta functions recomputed, βx at IP changed by ~5%
```

Checkpoints describe **observable states** that should exist.

## AI-Assisted Workflows

APS works naturally with AI coding assistants:

### Example: Claude Code + PyTao

```markdown
User: "Optimize CESR lattice to reduce emittance by 20%"

Claude Code:
1. Reads plans/index.aps.md to understand project
2. Creates module: plans/modules/04-emittance-reduction.aps.md
3. Breaks into work items (survey, optimize, validate)
4. For EMIT-001:
   - Generates action plan with checkpoints
   - Writes PyTao script to scan parameter space
   - Runs particle tracking to measure emittance
   - Validates against success criteria
   - Commits lattice + specs when complete
```

The structured APS format gives AI agents a **framework** for complex multi-step physics optimization.

## Use Cases

### 1. Lattice Design from Scratch

**Project:** Design a new storage ring for synchrotron radiation

**Modules:**
- Arc section design (FODO cells, dispersion matching)
- Straight section insertion devices
- RF cavity placement and parameters
- Chromaticity correction scheme
- Dynamic aperture optimization

### 2. Machine Upgrade Planning

**Project:** Upgrade existing accelerator to higher energy

**Modules:**
- Magnet strength requirements and limits
- RF power budget and cavity modifications
- Aperture verification at new energy
- Beam lifetime predictions and mitigations

### 3. AI-Assisted Optimization

**Project:** Use ML to find optimal sextupole settings for chromaticity

**Modules:**
- Baseline measurement and modeling
- Parameter space exploration (Bayesian optimization)
- Multi-objective optimization (chromaticity vs. dynamic aperture)
- Validation with particle tracking

### 4. Commissioning Planning

**Project:** Commission newly-installed insertion device

**Modules:**
- Optics model with new insertion device
- Orbit correction strategy
- Coupling correction plan
- Injection efficiency optimization

### 5. Cross-Facility Collaboration

**Project:** Adapt CESR lattice design for use at another facility

**Workflow:**
1. Clone repository with CESR APS specs
2. Read design rationale in module specs
3. Adapt work items for different beam parameters
4. Validate locally with facility-specific constraints
5. Contribute improvements back via pull request

## Benefits

### For Accelerator Physicists

- **Structured design process** — Clear progression from problem to solution
- **Reproducible results** — Validation commands make results verifiable
- **AI assistance** — LLMs can help optimize complex lattices
- **Better documentation** — Design intent captured alongside lattice files

### For Facilities

- **Knowledge transfer** — Onboard new physicists faster
- **Collaboration** — Share designs with clear rationale
- **Version control** — Track lattice evolution over time
- **Compliance** — Meet documentation requirements for reviews

### For the Community

- **Standardization** — Common format for sharing accelerator designs
- **Best practices** — Codify proven design workflows
- **Education** — Better teaching materials for accelerator physics
- **Innovation** — Enable AI-assisted discovery of novel lattices

## Integration with Existing Tools

APS is **tool-agnostic** and works alongside your existing workflow:

| Tool | How APS Helps |
|------|---------------|
| **Tao (interactive)** | Use APS specs to guide manual optimization |
| **PyTao (scripts)** | Read validation commands from work items |
| **Jupyter notebooks** | Document analysis with APS checkpoints |
| **Elegant, MAD-X, etc.** | APS works with any accelerator code (just update validation commands) |
| **Git** | Version-control specs alongside lattice files |
| **Confluence/wikis** | Export APS specs to facility documentation |

## Next Steps

1. **Try it:** Copy templates to your project and plan a small lattice modification
2. **Adapt:** Modify templates for your facility's conventions and tools
3. **Share:** Contribute improved templates back to the APS project
4. **Automate:** Build facility-specific tooling (PyTao integrations, validation scripts)

## Resources

- [APS Documentation](../../README.md)
- [Bmad Manual](https://www.classe.cornell.edu/bmad/bmad-manual.pdf)
- [PyTao GitHub](https://github.com/bmad-sim/pytao)
- [Tao Tutorial](https://www.classe.cornell.edu/bmad/tutorial_bmad_tao.pdf)
- [Research: Bmad APS Plugin](../../research-bmad-aps-plugin.md)

## Contributing

Found these templates useful? Have suggestions?

- Open an issue: [github.com/EddaCraft/anvil-plan-spec/issues](https://github.com/EddaCraft/anvil-plan-spec/issues)
- Submit improvements via pull request
- Share your experience with the community

---

**Templates created:** 2026-01-18
**For:** Bmad/Tao accelerator physics community
**Status:** Experimental — feedback welcome!
