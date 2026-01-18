# Example: Optics Matching Work Item

This example shows how to structure a work item for lattice optics matching using APS.

---

## OPTICS-001: Match beta functions at interaction point

**Status:** Ready
**Module:** 01-optics-matching.aps.md
**Lattice Region:** Final focus (s=200m to s=250m)

### Intent

Adjust quadrupole strengths in the final focus section to achieve target beta functions
at the interaction point (IP) for optimal luminosity. Target: βx=1.0m, βy=0.01m (flat beams).

### Physics Context

- Flat beams (βx >> βy) maximize luminosity in electron-positron colliders
- Final focus quadrupoles must focus beam to small spot without exceeding strength limits
- Critical for CESR-c luminosity upgrade

### Expected Outcome

**Observable results after completion:**

1. **Beta functions at IP match target:**
   - βx = 1.0m ± 5% (0.95m to 1.05m)
   - βy = 0.01m ± 5% (0.0095m to 0.0105m)

2. **No degradation of upstream optics:**
   - Global tune preserved: Qx ≈ 0.60, Qy ≈ 0.58 (within ±0.02)
   - Beta beat < 10% in arc sections

3. **Magnet strengths within operational limits:**
   - All quadrupoles: |K1| < 0.5 m⁻²
   - All sextupoles: |K2| < 10 m⁻³

### Validation

Run these Tao commands after lattice modification:

```bash
# Launch Tao with updated lattice
tao -lat lattice_final_focus.bmad -noplot

# Check beta functions at IP (element IP, s=245.3m)
tao> show beam@IP

# Verify tune
tao> show tune

# Check beta beat in arcs
tao> show -element beginning::end beta_a

# Check quadrupole strengths
tao> show -attribute k1 quad::*
```

**Success criteria in output:**
- `beta_x` at IP: 0.95 ≤ value ≤ 1.05 m
- `beta_y` at IP: 0.0095 ≤ value ≤ 0.0105 m
- `Tune_x`: 0.58 ≤ value ≤ 0.62
- `Tune_y`: 0.56 ≤ value ≤ 0.60
- All quadrupole `k1`: |value| < 0.5 m⁻²

### Parameters to Adjust

**Primary variables (Final Focus Quadrupoles):**

| Element | Parameter | Initial | Range | Role |
|---------|-----------|---------|-------|------|
| Q1F | k1 | 6.2 m⁻² | [5.0, 7.0] | Horizontal focusing near IP |
| Q1D | k1 | -5.1 m⁻² | [-6.0, -4.0] | Vertical focusing near IP |
| Q2F | k1 | 4.8 m⁻² | [4.0, 6.0] | Horizontal focus upstream |
| Q2D | k1 | -3.9 m⁻² | [-5.0, -3.0] | Vertical focus upstream |

**Constraints (Fixed):**
- IP location: s = 245.3m (fixed)
- Beam energy: 5.3 GeV (fixed)
- Emittance: εx = 2.5 nm, εy = 0.01 nm (fixed for now)

### Dependencies

**Requires:**
- None (first work item in module)

**Blocks:**
- OPTICS-002 (chromaticity correction depends on final optics)
- APER-001 (aperture check uses final beta functions)

### Implementation Approach

**Option 1: Manual iteration (learning/debugging)**

1. Baseline measurement
2. Adjust Q1F by small step (±0.1 m⁻²)
3. Observe beta function change at IP
4. Iterate until convergence
5. Validate tune preservation

**Option 2: Tao matching (recommended for production)**

Use Tao's built-in optimizer:

```tao
! Define matching variables
use var Q1F[k1] Q1D[k1] Q2F[k1] Q2D[k1]

! Define matching targets
use dat beta_x@IP  = 1.0   weight=100
use dat beta_y@IP  = 0.01  weight=100
use dat tune_x     = 0.60  weight=50
use dat tune_y     = 0.58  weight=50

! Run optimizer
optimizer lmdif
```

**Option 3: PyTao scripted optimization (AI-assisted)**

Python script for automated matching with logging:

```python
from pytao import Tao

tao = Tao("-lat lattice_final_focus.bmad -noplot")

# Define optimization parameters
variables = ["Q1F[k1]", "Q1D[k1]", "Q2F[k1]", "Q2D[k1]"]
targets = {
    "beta_x@IP": 1.0,
    "beta_y@IP": 0.01,
    "tune_x": 0.60,
    "tune_y": 0.58
}

# Run matching algorithm
result = tao.match(variables, targets, method="lmdif")

# Validate and save
if result.converged:
    tao.cmd("write lattice lattice_optics_matched.bmad")
    print("✓ Matching successful!")
else:
    print("✗ Matching failed. Check constraints.")
```

### Rollback Plan

If matching fails or produces unphysical results:

1. **Revert lattice:** `git checkout lattice_final_focus.bmad`
2. **Check diagnostics:**
   - Are quadrupole strengths hitting limits?
   - Is beta beat in arcs > 20%? (indicates unstable solution)
   - Did tune cross integer or half-integer resonance?
3. **Adjust strategy:**
   - Widen parameter ranges
   - Add intermediate matching points
   - Relax tolerances temporarily

### Notes

- Final focus design based on CESR-c Low Emittance Optics (2003)
- Reference: "Low Emittance Tuning of the Cornell Electron Storage Ring", PRST-AB 2003
- Similar design used at KEKB and SuperKEKB
- This work item focuses on linear optics only; nonlinear optimization in OPTICS-003

### Related Files

- **Lattice:** `lattices/cesr_final_focus.bmad`
- **Tao init:** `tao_configs/match_beta_ip.init`
- **PyTao script:** `scripts/match_optics_ip.py`
- **Validation plots:** `validation/optics_matching/` (generated after completion)

---

## Action Plan: OPTICS-001.actions.md

See `plans/execution/OPTICS-001.actions.md` for detailed checkpoint-based execution steps.

Preview:
- [ ] Baseline: Record current beta functions at IP
- [ ] Adjust Q1F strength within [5.0, 7.0] m⁻²
- [ ] Adjust Q1D strength within [-6.0, -4.0] m⁻²
- [ ] Run Tao matching algorithm with IP constraints
- [ ] Verify βx at IP: [0.95m, 1.05m]
- [ ] Verify βy at IP: [0.0095m, 0.0105m]
- [ ] Check global tune in [0.58, 0.62] both planes
- [ ] Validate beta beat < 10% in arc sections
- [ ] Check quadrupole strengths |K1| < 0.5 m⁻²
- [ ] Save converged lattice to lattice_optics_matched.bmad
- [ ] Generate validation plots (beta functions, phase advance)
- [ ] Update lattice documentation with final parameters
