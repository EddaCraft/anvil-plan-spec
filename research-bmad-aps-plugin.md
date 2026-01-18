# Research: APS Plugin for Bmad Accelerator Design

## Executive Summary

**Verdict: HIGHLY FEASIBLE**

Building a plugin to enable bmad users to use APS (Anvil Plan Spec) for planning accelerator designs is not only feasible but would provide significant value to the accelerator physics community. The combination of bmad's existing Python interface (PyTao) and APS's tool-agnostic markdown format creates a natural integration point.

## Background

### What is Bmad?

Bmad is a subroutine library for simulating relativistic charged particle beams in high-energy accelerators and storage rings. Developed at Cornell's CLASSE (Cornell Laboratory for Accelerator-based ScienceS and Education), it is:

- **Written in Fortran 2008** with object-oriented, modular design
- **Used at major facilities** including Cornell, SLAC (LCLS, FACET-II), and Brookhaven National Laboratory
- **Highly flexible** with multiple tracking algorithms (Runge-Kutta, symplectic/Lie algebraic integration)
- **Well-documented** with comprehensive manuals and training workshops

### Bmad Ecosystem Components

1. **Bmad Core Library** — Fortran subroutine library for physics calculations
2. **Tao (Tool for Accelerator Optics)** — General-purpose simulation program built on Bmad
3. **PyTao** — Python interface enabling programmatic access and advanced optimization
4. **SciBmad.jl** — Modern Julia/Python reimplementation with GPU support and differentiability
5. **Lattice File Format** — Custom format for defining accelerator structures (based on MAD standard)

### Current Planning Workflows in Bmad

Accelerator designers currently:

1. **Define lattices** using Bmad lattice files (text-based format)
2. **Run simulations** via Tao (interactive command-line or GUI)
3. **Optimize designs** using PyTao scripts for parameter tuning
4. **Document decisions** in papers, wikis, or facility-specific documentation
5. **Share designs** via lattice files and ad-hoc documentation

**Pain Points:**
- Planning is scattered across wikis, emails, and papers
- No standardized format for design intent and rationale
- Difficult to track design evolution over time
- Limited AI-assisted design workflows
- Knowledge transfer between facilities is manual

## Feasibility Analysis

### Technical Feasibility: ✅ HIGH

**Favorable Factors:**

1. **Python Interface Exists** — PyTao provides mature, production-ready access to Tao/Bmad
2. **Modular Architecture** — SciBmad.jl demonstrates ecosystem openness to new tools
3. **Text-Based Workflows** — Both Bmad lattice files and APS specs are plain text
4. **Version Control Ready** — Accelerator facilities already use git for lattice files
5. **No Deep Integration Required** — APS can operate as a planning layer above existing tools

**Implementation Pathways:**

| Approach | Complexity | Time to MVP | Best For |
|----------|------------|-------------|----------|
| APS templates for accelerator design | Low | 1-2 weeks | Quick validation with users |
| Standalone CLI tool (Python) | Medium | 4-6 weeks | Flexible, tool-agnostic integration |
| PyTao extension | Medium-High | 6-8 weeks | Deep integration with existing workflows |
| SciBmad.jl integration | High | 8-12 weeks | Modern ecosystem, GPU workflows |

### User Need: ✅ STRONG

The accelerator physics community would benefit significantly from:

1. **Structured Planning** — Moving from ad-hoc to systematic design documentation
2. **AI-Assisted Design** — Leveraging LLMs for lattice optimization and exploration
3. **Cross-Facility Collaboration** — Standardized format for sharing design intent
4. **Version-Controlled Planning** — Track design decisions alongside lattice files
5. **Checkpoint-Based Validation** — Verify design steps meet physics requirements

### Adoption Risk: ⚠️ MEDIUM

**Challenges:**

1. **Domain Specificity** — Physicists may resist "software engineering" processes
2. **Learning Curve** — APS adds conceptual overhead for users unfamiliar with structured planning
3. **Competing Tools** — Facilities have existing documentation systems (Confluence, wikis)
4. **Conservative Community** — Accelerator physics has slower tool adoption than software dev

**Mitigation Strategies:**

- Start with physics-specific templates (lattice design, optics optimization)
- Focus on AI-assisted design as the "killer feature"
- Partner with a single facility (Cornell, SLAC) for pilot program
- Emphasize lightweight adoption (just markdown files, no installation required)

## Proposed Architecture

### Option 1: APS Templates for Accelerator Design (Recommended MVP)

**Description:** Create accelerator-physics-specific APS templates without building custom software.

**Components:**

```
plans/
├── aps-rules.md                    # Standard APS rules
├── index.aps.md                    # Project: "CESR Lattice Redesign"
├── modules/
│   ├── 01-optics-matching.aps.md   # Module: Match beta functions
│   ├── 02-chromaticity.aps.md      # Module: Correct chromaticity
│   └── 03-dynamic-aperture.aps.md  # Module: Optimize dynamic aperture
└── execution/
    ├── OPTICS-001.actions.md       # Actions: Adjust quadrupole strengths
    └── OPTICS-002.actions.md       # Actions: Validate Twiss parameters
```

**Work Item Example:**

```markdown
### OPTICS-001: Match beta functions at interaction point

**Intent:** Adjust quadrupole strengths to achieve target beta functions (βx=1m, βy=0.01m) at IP.

**Expected Outcome:**
- Twiss parameters at IP match target within 5% tolerance
- No upstream optics degradation (checked via tune preservation)

**Validation:**
```bash
tao -lat lattice.bmad -command "show beam@IP; show tune"
```

**Dependencies:** None
**Status:** Ready
```

**Action Plan Example:**

```markdown
# OPTICS-001: Match beta functions at interaction point

## Actions

- [ ] Baseline: Record current beta functions at IP (Twiss output)
- [ ] Adjust Q1F strength in range [5.0, 7.0] T/m
- [ ] Adjust Q1D strength in range [-6.0, -4.0] T/m
- [ ] Run Tao matching algorithm with IP constraints
- [ ] Verify βx within [0.95m, 1.05m] at IP s=245.3m
- [ ] Verify βy within [0.0095m, 0.0105m] at IP s=245.3m
- [ ] Check global tune remains in [0.58, 0.62] in both planes
- [ ] Save converged lattice to lattice_optics_matched.bmad
```

**Benefits:**
- ✅ No code to write or maintain
- ✅ Works with existing Tao/PyTao workflows
- ✅ Immediate adoption possible
- ✅ Validates concept before investing in tooling

**Limitations:**
- ❌ No automatic lattice file generation from specs
- ❌ Manual sync between APS specs and Bmad lattice files
- ❌ No specialized UI or integration

### Option 2: Standalone CLI Tool (`aps-bmad`)

**Description:** Python CLI tool that bridges APS planning and Bmad workflows.

**Features:**

```bash
# Initialize APS for accelerator project
aps-bmad init --project "CESR-Optics" --lattice lattice.bmad

# Parse lattice and suggest modules
aps-bmad suggest-modules --lattice lattice.bmad

# Execute work item using PyTao
aps-bmad execute OPTICS-001 --validate

# Generate validation report
aps-bmad validate --module optics-matching

# Export APS specs to facility wiki format
aps-bmad export --format confluence
```

**Architecture:**

```python
aps-bmad/
├── cli.py                  # Click-based CLI
├── parser.py               # Parse Bmad lattice files
├── executor.py             # PyTao integration for execution
├── validator.py            # Run Tao commands for validation
├── templates/
│   ├── lattice-design.md   # Template for lattice design modules
│   ├── optics-matching.md  # Template for optics work items
│   └── aperture-check.md   # Template for aperture validation
└── utils.py
```

**PyTao Integration:**

```python
from pytao import Tao
from aps_bmad import APSExecutor

# Read work item from APS spec
work_item = APSExecutor.load("plans/modules/01-optics.aps.md", "OPTICS-001")

# Initialize Tao with lattice
tao = Tao("-lat lattice.bmad -noplot")

# Execute validation command from work item
result = tao.cmd(work_item.validation_command)

# Mark work item as complete if validation passes
if work_item.validate(result):
    APSExecutor.complete("OPTICS-001")
```

**Benefits:**
- ✅ Bidirectional integration (APS ↔ Bmad)
- ✅ Automated validation using PyTao
- ✅ Can generate lattice modifications from specs
- ✅ Extensible via plugins

**Complexity:**
- Moderate Python development (4-6 weeks for MVP)
- Requires PyTao installation and Bmad distribution
- Needs domain expertise for lattice parsing

### Option 3: PyTao Extension Module

**Description:** Extend PyTao with APS planning capabilities as a native module.

**Integration:**

```python
from pytao import Tao
from pytao.aps import APSPlanner

tao = Tao("-lat lattice.bmad")

# Initialize APS for this Tao session
planner = APSPlanner(tao, plans_dir="plans/")

# Generate module from current lattice state
planner.create_module(
    name="optics-matching",
    problem="Beta functions at IP don't match target",
    success_criteria=["βx = 1.0m ± 5%", "βy = 0.01m ± 5%"]
)

# Execute work item with automatic validation
planner.execute("OPTICS-001", validate=True)

# Export planning artifacts
planner.export_report("optics-report.md")
```

**Benefits:**
- ✅ Deep integration with PyTao workflows
- ✅ Access to full Tao state for intelligent suggestions
- ✅ Could become official PyTao feature
- ✅ Leverages existing PyTao user base

**Challenges:**
- Requires buy-in from PyTao maintainers
- Higher development complexity
- Tightly coupled to PyTao release cycle

### Option 4: SciBmad.jl Integration

**Description:** Build APS support into the modern SciBmad.jl ecosystem.

**Rationale:**

SciBmad.jl is explicitly designed to be:
- **Modular** — APS could be a separate package
- **Polymorphic** — Works with Julia and Python
- **Modern** — GPU support, differentiability
- **Actively developed** — Open to new features

**Architecture:**

```julia
using SciBmad, APSPlanner

# Define lattice with APS metadata
lattice = Lattice("cesr.bmad", aps_plan="plans/index.aps.md")

# Create work item from lattice state
work_item = create_work_item(
    lattice,
    module="optics-matching",
    intent="Match beta functions at IP"
)

# AI-assisted optimization with checkpoints
optimize_with_aps(
    lattice,
    work_item="OPTICS-001",
    method=:gradient_descent,
    checkpoints=true
)
```

**Benefits:**
- ✅ Aligns with modernization efforts
- ✅ GPU-accelerated AI-assisted design
- ✅ Differentiable physics + structured planning = powerful combination
- ✅ Future-proof integration

**Timeline:**
- Longer development cycle (8-12 weeks)
- Requires Julia expertise
- SciBmad.jl still maturing

## Use Cases

### 1. Lattice Design Planning

**Scenario:** Design a new storage ring lattice from scratch.

**APS Workflow:**

1. **Index:** Define project goals (beam energy, emittance targets, cost constraints)
2. **Modules:** Break into modules (optics matching, chromaticity correction, dynamic aperture)
3. **Work Items:** Create actionable items (e.g., "Design FODO cell with phase advance 90°")
4. **Action Plans:** Checkpoint-based steps (e.g., "Place quadrupoles at 0m, 10m, 20m")
5. **Execution:** Use Tao/PyTao to implement and validate each work item
6. **Validation:** Run particle tracking, measure emittance, check stability

**Benefits:**
- Clear separation of planning (APS) and execution (Bmad/Tao)
- AI can suggest lattice topologies based on design goals
- Version control tracks design evolution
- Easy to onboard new team members

### 2. AI-Assisted Accelerator Optimization

**Scenario:** Use Claude Code to optimize an existing lattice for lower emittance.

**Workflow:**

```markdown
User: "Optimize CESR lattice to reduce emittance by 20%"

Claude:
1. Reads plans/index.aps.md to understand project
2. Creates module: plans/modules/05-emittance-optimization.aps.md
3. Breaks into work items:
   - EMIT-001: Survey current emittance budget
   - EMIT-002: Identify high-dispersion regions
   - EMIT-003: Adjust quadrupole strengths in arc sections
   - EMIT-004: Re-match chromaticity after changes
4. For each work item:
   - Generates action plan with checkpoints
   - Uses PyTao to modify lattice
   - Runs Tao validation commands
   - Marks complete when checkpoints pass
5. Produces final report with lattice file and validation results
```

**Key Advantage:** AI agent has structured framework for complex multi-step optimization.

### 3. Cross-Facility Collaboration

**Scenario:** SLAC wants to adapt Cornell's CESR lattice design for LCLS-II-HE.

**APS Workflow:**

1. **Cornell exports APS specs** — Plans directory with all modules and work items
2. **SLAC clones repository** — Gets both lattice files and design rationale
3. **SLAC reviews APS index** — Understands design goals, constraints, decisions
4. **SLAC adapts modules** — Modifies work items for different beam parameters
5. **SLAC validates locally** — Uses their Tao installation with updated lattice
6. **SLAC contributes back** — Submits PR with improvements to common modules

**Benefits:**
- Standardized format for design sharing
- Git workflow for collaboration (PRs, issues, discussions)
- Design rationale travels with lattice files
- Easier to adapt designs than start from scratch

### 4. Training and Education

**Scenario:** Teach accelerator physics students lattice design using Bmad.

**APS Workflow:**

Instructor provides:
```
bmad-course/
├── plans/
│   ├── index.aps.md                # Course: "Accelerator Lattice Design"
│   ├── modules/
│   │   ├── 01-fodo-cell.aps.md     # Assignment 1: Design basic FODO cell
│   │   ├── 02-achromat.aps.md      # Assignment 2: Double-bend achromat
│   │   └── 03-nonlinear.aps.md     # Assignment 3: Nonlinear dynamics
```

Students:
- Follow structured work items with clear outcomes
- Use validation commands to check their work
- Submit completed action plans showing their process
- Instructor reviews via git diffs

**Benefits:**
- Self-guided learning with clear checkpoints
- Students learn both physics and systematic design process
- Automated validation reduces instructor grading burden
- Reusable course materials

## Implementation Roadmap

### Phase 1: Validation (2-4 weeks)

**Goal:** Prove concept with minimal tooling.

**Tasks:**
1. Create accelerator-specific APS templates
   - Lattice design module template
   - Optics matching work item template
   - Dynamic aperture action plan template
2. Pilot with 1-2 real lattice design projects
   - Partner with Cornell or SLAC
   - Use existing Tao/PyTao workflows
   - Collect feedback from physicists
3. Document best practices
   - "How to plan lattice designs with APS"
   - Example: CESR optics correction project
4. Refine templates based on feedback

**Success Criteria:**
- [ ] 2+ physicists successfully use APS templates
- [ ] Feedback indicates clear value over existing workflows
- [ ] Minimal resistance to adoption

### Phase 2: Tooling (6-8 weeks)

**Goal:** Build standalone CLI tool for better integration.

**Tasks:**
1. Develop `aps-bmad` CLI
   - Lattice file parsing
   - PyTao integration for execution
   - Validation automation
2. Add specialized commands
   - `aps-bmad suggest-modules` — Analyze lattice, propose modules
   - `aps-bmad validate` — Run all validation commands
   - `aps-bmad export` — Convert to wiki/PDF
3. Create documentation and examples
4. Package for easy installation (`pip install aps-bmad`)

**Success Criteria:**
- [ ] CLI tool reduces manual work by 50%+
- [ ] Installation process takes < 5 minutes
- [ ] Works with existing PyTao installations

### Phase 3: Ecosystem Integration (8-12 weeks)

**Goal:** Integrate into PyTao or SciBmad.jl ecosystem.

**Tasks:**
1. Engage with maintainers
   - Present concept to PyTao team
   - Propose feature addition to SciBmad.jl
2. Contribute upstream
   - Submit PRs with APS support
   - Add tests and documentation
3. Community building
   - Present at Bmad/Tao workshops
   - Write paper for accelerator physics conference
   - Create video tutorials

**Success Criteria:**
- [ ] Official support in PyTao or SciBmad.jl
- [ ] 5+ facilities using APS for accelerator planning
- [ ] Community contributions to templates

## Key Benefits for Bmad Users

### For Individual Designers

1. **AI-Assisted Design** — Use Claude Code, ChatGPT, or Cursor with structured planning
2. **Design Documentation** — Automatic record of intent, decisions, and validation
3. **Checkpoint-Based Workflow** — Validate progress at each step, catch errors early
4. **Reproducible Designs** — Clear action plans make designs reproducible

### For Accelerator Facilities

1. **Knowledge Transfer** — Onboard new staff faster with documented design process
2. **Collaboration** — Share designs with clear rationale, not just lattice files
3. **Version Control** — Track lattice evolution alongside design decisions
4. **Compliance** — Meet documentation requirements for project reviews

### For the Community

1. **Standardization** — Common format for sharing accelerator designs
2. **Best Practices** — Codify lattice design workflows into templates
3. **Education** — Better teaching materials for accelerator physics courses
4. **Innovation** — Enable AI-assisted discovery of novel lattice topologies

## Challenges and Mitigations

### Challenge 1: Domain Complexity

**Problem:** Accelerator physics is highly specialized. Generic software planning concepts may not map cleanly.

**Mitigation:**
- Co-develop with domain experts (physicists at Cornell, SLAC)
- Create physics-specific templates and terminology
- Focus on observable physics outcomes (beta functions, emittance) not software abstractions

### Challenge 2: Adoption Resistance

**Problem:** Physicists may see this as "software bloat" or unnecessary process.

**Mitigation:**
- Lead with AI-assisted design (exciting new capability)
- Keep it optional — works alongside existing workflows, not replacing them
- Emphasize markdown simplicity (no new software required for basic use)
- Show concrete time savings (faster optimization, fewer bugs)

### Challenge 3: Integration Complexity

**Problem:** Bidirectional sync between APS specs and Bmad lattice files is non-trivial.

**Mitigation:**
- Start with uni-directional (APS → validation, not APS → lattice generation)
- Use PyTao's existing command interface (no deep Bmad internals needed)
- Leverage text-based lattice format (easier parsing than binary)

### Challenge 4: Validation Specificity

**Problem:** Physics validation is complex (particle tracking, stability analysis, not just unit tests).

**Mitigation:**
- Work items specify Tao commands for validation (domain-appropriate)
- Checkpoints describe observable physics outcomes (measurable via Tao)
- Allow flexibility for custom validation scripts

## Conclusion

Building an APS plugin for bmad is **highly feasible** and would provide **significant value** to the accelerator physics community. The combination of:

1. **Existing Python interface** (PyTao) provides integration point
2. **Text-based workflows** (lattice files + markdown) enable version control
3. **Modular ecosystem** (SciBmad.jl) shows openness to new tools
4. **AI-assisted design demand** creates natural adoption pathway

**Recommended Path Forward:**

1. **Start with templates** (Phase 1) — Validate concept with minimal investment
2. **Build CLI tool** (Phase 2) if Phase 1 shows strong adoption
3. **Integrate upstream** (Phase 3) if community embraces the approach

The lowest-risk approach is creating accelerator-specific APS templates and piloting with a single facility. If successful, the community will drive demand for deeper integration.

**Next Steps:**

1. Create lattice design APS templates (see `/templates/accelerator-design/`)
2. Reach out to Cornell CLASSE or SLAC to pilot with real project
3. Document example: "Using APS to plan CESR optics correction"
4. Present at next Bmad/Tao workshop for community feedback

## References

- [Bmad Manual (2025)](https://www.classe.cornell.edu/bmad/bmad-manual.pdf)
- [PyTao GitHub](https://github.com/bmad-sim/pytao)
- [SciBmad.jl GitHub](https://github.com/bmad-sim/SciBmad.jl)
- [Bmad School Tutorials](https://github.com/ChristopherMayes/bmad-school)
- [Anvil Plan Spec (APS) Documentation](https://github.com/EddaCraft/anvil-plan-spec)

---

**Research conducted:** 2026-01-18
**Author:** AI Research Analysis via Claude Code
**Status:** Feasibility confirmed — Recommended for Phase 1 implementation
