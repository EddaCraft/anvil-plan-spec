# [MODULE-NAME]: [Brief Description]

**Status:** [Proposed | Ready | Active | Complete]
**Owner:** [Name or team responsible]
**Lattice:** [Path to Bmad lattice file, e.g., `lattices/main.bmad`]

## Problem

[Describe the accelerator design challenge or physics problem this module addresses.
Examples:
- Beta functions at interaction point don't meet target specifications
- Chromaticity correction needed to prevent instabilities
- Dynamic aperture insufficient for beam lifetime requirements]

## Success Criteria

What physics outcomes define success? Use measurable, observable quantities.

- [ ] [Twiss parameter] at [location] within [tolerance]
- [ ] [Beam parameter] achieves [target value]
- [ ] [Stability metric] meets [requirement]
- [ ] Validation: [Specific Tao/PyTao command or tracking result]

**Example:**
- [ ] βx = 1.0m ± 5% at interaction point (s=245.3m)
- [ ] βy = 0.01m ± 5% at interaction point (s=245.3m)
- [ ] Global tune (Qx, Qy) in range [0.58, 0.62]
- [ ] Validation: `tao -lat lattice.bmad -command "show beam@IP; show tune"`

## Scope

### In Scope
- [Specific lattice regions or elements involved]
- [Physics effects to be modeled]
- [Parameter ranges to explore]

### Out of Scope
- [What this module explicitly does NOT address]
- [Deferred items for later modules]

## Interfaces

### Inputs
- **Initial lattice:** [File name or state description]
- **Beam parameters:** [Energy, current, emittance, etc.]
- **Constraints:** [Fixed elements, aperture limits, cost constraints]

### Outputs
- **Modified lattice:** [Expected output file name]
- **Performance metrics:** [What gets measured/reported]
- **Documentation:** [Design notes, validation plots]

## Boundaries

### Physics Constraints
- [Beam stay clear requirements]
- [Magnet strength limits]
- [RF power budget]
- [Synchrotron radiation limits]

### Dependencies
- **Requires:** [Other modules that must complete first]
- **Blocks:** [Modules waiting on this one]

## Work Items

[Work items are added when the module status is "Ready". Each work item represents
a single, actionable change to the lattice with clear validation criteria.]

### [PREFIX]-001: [First work item title]
**Status:** [Proposed | Ready | In Progress | Done]
**Intent:** [What physics goal does this accomplish?]
**Outcome:** [Observable result after completion]
**Validation:** `[Tao command or script to verify success]`
**Dependencies:** [None | List of work item IDs]

### [PREFIX]-002: [Second work item title]
**Status:** [Proposed | Ready | In Progress | Done]
**Intent:** [What physics goal does this accomplish?]
**Outcome:** [Observable result after completion]
**Validation:** `[Tao command or script to verify success]`
**Dependencies:** [[PREFIX]-001]

## Notes

[Design considerations, tradeoffs, alternative approaches, or references to papers/designs]

## References

- [Bmad manual section]
- [Relevant physics papers]
- [Similar lattice designs at other facilities]
- [Simulation studies or measurement data]
