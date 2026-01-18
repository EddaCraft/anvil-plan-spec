# OPTICS-001: Match beta functions at interaction point

**Work Item:** OPTICS-001
**Module:** 01-optics-matching.aps.md
**Status:** In Progress
**Owner:** [Your name or AI agent ID]

## Intent

Adjust quadrupole strengths in the final focus section to achieve target beta functions
(βx=1.0m, βy=0.01m) at the interaction point.

## Actions

Each action is a checkpoint — an observable state that should exist when the action completes.
Actions should be completed sequentially. Mark each checkbox when the checkpoint is verified.

### Setup & Baseline

- [ ] Baseline: Tao launched with lattice_final_focus.bmad loaded
- [ ] Baseline: Current beta functions at IP recorded (βx, βy values saved)
- [ ] Baseline: Current tune recorded (Qx, Qy values saved)
- [ ] Baseline: Quadrupole strengths logged for Q1F, Q1D, Q2F, Q2D

**Verification commands:**
```bash
tao> show beam@IP
tao> show tune
tao> show -attribute k1 quad::Q1F quad::Q1D quad::Q2F quad::Q2D
```

**Expected output location:** `logs/optics-001-baseline.txt`

---

### Parameter Adjustment (Manual Method)

- [ ] Q1F k1 adjusted to 6.5 m⁻² (from 6.2 m⁻²)
- [ ] Beta functions recomputed, βx at IP changed by ~5%
- [ ] Q1D k1 adjusted to -5.4 m⁻² (from -5.1 m⁻²)
- [ ] Beta functions recomputed, βy at IP decreased by ~8%
- [ ] Q2F k1 fine-tuned to 5.1 m⁻² (from 4.8 m⁻²)
- [ ] Q2D k1 fine-tuned to -4.2 m⁻² (from -3.9 m⁻²)

**Verification after each adjustment:**
```bash
tao> set element Q1F k1 = 6.5
tao> show beam@IP
```

---

### Optimization (Tao Matching Method)

**Note:** Use this section if using Tao's optimizer instead of manual adjustment.

- [ ] Matching variables defined: Q1F[k1], Q1D[k1], Q2F[k1], Q2D[k1]
- [ ] Matching targets set: beta_x@IP=1.0, beta_y@IP=0.01, tune preservation
- [ ] Optimizer invoked: `optimizer lmdif` completed without errors
- [ ] Optimizer converged: chi-squared < 1e-6 reported
- [ ] Optimizer solution verified: all variables within allowed ranges

**Verification commands:**
```bash
tao> use var Q1F[k1] Q1D[k1] Q2F[k1] Q2D[k1]
tao> use dat beta_x@IP = 1.0 weight=100
tao> use dat beta_y@IP = 0.01 weight=100
tao> optimizer lmdif
tao> show optimizer
```

---

### Validation: Beta Functions at IP

- [ ] βx at IP = [0.95m to 1.05m] ✓ (measured: ____ m)
- [ ] βy at IP = [0.0095m to 0.0105m] ✓ (measured: ____ m)
- [ ] Beta function ratio βx/βy ≈ 100 ✓ (measured: ____)

**Verification command:**
```bash
tao> show beam@IP
```

**Expected output:**
```
Element: IP, s = 245.300 m
beta_x  = 1.02 m     ✓ within [0.95, 1.05]
beta_y  = 0.0098 m   ✓ within [0.0095, 0.0105]
```

---

### Validation: Global Tune Preservation

- [ ] Qx (horizontal tune) in [0.58, 0.62] ✓ (measured: ____)
- [ ] Qy (vertical tune) in [0.56, 0.60] ✓ (measured: ____)
- [ ] Tune shift from baseline < 0.02 in both planes ✓

**Verification command:**
```bash
tao> show tune
```

**Expected output:**
```
Tune_x = 0.601    ✓ within [0.58, 0.62]
Tune_y = 0.583    ✓ within [0.56, 0.60]
```

---

### Validation: Beta Beat in Arc Sections

- [ ] Beta beat computed for full ring (0m to 768m)
- [ ] Maximum beta beat in arcs < 10% in both planes ✓
- [ ] No regions with beta beat > 20% (unstable optics) ✓

**Verification command:**
```bash
tao> show -element beginning::end beta_a
```

**Expected output:**
```
Max delta_beta/beta in arcs: 7.2%  ✓ < 10%
```

---

### Validation: Magnet Strength Limits

- [ ] Q1F k1 within [-0.5, 0.5] m⁻² or operational limits ✓ (value: ____)
- [ ] Q1D k1 within [-0.5, 0.5] m⁻² or operational limits ✓ (value: ____)
- [ ] Q2F k1 within [-0.5, 0.5] m⁻² or operational limits ✓ (value: ____)
- [ ] Q2D k1 within [-0.5, 0.5] m⁻² or operational limits ✓ (value: ____)
- [ ] All quadrupoles in final focus region checked ✓

**Verification command:**
```bash
tao> show -attribute k1 quad::*
```

**Expected:** All values |k1| < 0.5 m⁻²

---

### Output Generation

- [ ] Converged lattice saved to lattices/cesr_optics_matched.bmad
- [ ] Twiss parameters exported to data/optics_matched_twiss.dat
- [ ] Beta function plot generated: plots/beta_functions_ip.pdf
- [ ] Phase advance plot generated: plots/phase_advance_ring.pdf
- [ ] Validation summary written to validation/optics-001-summary.md

**Commands:**
```bash
tao> write lattice lattices/cesr_optics_matched.bmad
tao> write beam -at ele::* data/optics_matched_twiss.dat
tao> python3 scripts/plot_beta_functions.py data/optics_matched_twiss.dat
```

---

### Documentation

- [ ] Final quadrupole strengths documented in validation summary
- [ ] Comparison table: baseline vs. matched values created
- [ ] Git commit created: "OPTICS-001: Match beta functions at IP"
- [ ] Work item status updated to "Done" in 01-optics-matching.aps.md

**Git commands:**
```bash
git add lattices/cesr_optics_matched.bmad
git add validation/optics-001-summary.md
git add plots/beta_functions_ip.pdf
git commit -m "OPTICS-001: Match beta functions at IP

- Adjusted Q1F, Q1D, Q2F, Q2D strengths
- Achieved βx=1.02m, βy=0.0098m at IP (within 5% tolerance)
- Tune preserved: Qx=0.601, Qy=0.583
- Beta beat < 10% in all arc sections
- All magnets within operational limits

Validation: ✓ All checkpoints passed
Lattice: lattices/cesr_optics_matched.bmad"
```

---

## Completion Checklist

**All checkpoints passed:**
- [x] Setup & Baseline
- [x] Parameter Adjustment or Optimization
- [x] Beta Functions at IP validated
- [x] Global Tune preserved
- [x] Beta Beat acceptable
- [x] Magnet Strengths within limits
- [x] Output files generated
- [x] Documentation complete

**Work item OPTICS-001 status: DONE ✓**

---

## Notes

**Issues encountered:**
- None (or describe any problems and how they were resolved)

**Deviations from plan:**
- Used Tao optimizer instead of manual iteration (faster convergence)

**Lessons learned:**
- Q1F has largest impact on βx at IP (~0.2m change per 0.1 m⁻² change in k1)
- Tune is sensitive to Q2F and Q2D; needed tighter constraints during matching

**Follow-up work:**
- OPTICS-002 (chromaticity correction) can now proceed
- Consider sextupole optimization for nonlinear dynamics (OPTICS-003)
