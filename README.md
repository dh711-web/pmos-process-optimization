# PMOS Process Optimization (Sentaurus TCAD)

Converting an n-channel MOSFET process flow to p-channel, then optimizing five
implant and anneal parameters against on/off current ratio and subthreshold
swing.

> Built on the SimpleMOS example distributed with Sentaurus. Only the
> modifications and the post-processing script are included here; the base
> template is Synopsys-licensed and not redistributed.

## Objective

Build a working p-channel device from the n-channel flow and find implant and
anneal conditions that meet all three targets simultaneously:

| Metric | Target |
|---|---|
| Drive current `I_D` | > 1e-5 A/µm |
| Subthreshold swing `SS` | < 100 mV/dec |
| Off current `I_off` | < 1e-14 A/µm |

Device: `Lg` = 250 nm, gate oxidation time 10, contacts defined after a reflect
step.

## What changed for p-channel

Five edits convert the flow. See [modifications.md](modifications.md) for the
before/after commands and the reason for each.

| | n-channel | p-channel |
|---|---|---|
| Substrate | Boron | Phosphorus (N-well) |
| S/D implant | Phosphorus | Boron |
| LDD implant | Arsenic | Boron |
| Gate sweep | 0 → +2.5 V | 0 → −2.5 V |
| Drain bias | +0.05, +1.0 V | −0.05, −1.0 V |

## Parameter sweep

Each parameter was swept with the other four held fixed, and `I_D/I_off` and
`SS` plotted per condition. Full reasoning in
[results/parameter_sweep.md](results/parameter_sweep.md).

| Parameter | Range swept | Optimum | Why |
|---|---|---|---|
| LDD dose | 1e12 – 3e13 cm⁻² | **1e12** | Higher dose degrades gate control; `I_D/I_off` falls and SS worsens |
| LDD energy | 1 – 5 keV | **1 keV** | Deeper junction weakens channel control (DIBL, punch-through) |
| S/D dose | 5e15 – 7e15 cm⁻² | **5e15** | `I_off` rise and SS degradation outweigh the `I_D` gain |
| S/D energy | 1 – 5 keV | **1 keV** | S/D is more sensitive to junction depth than LDD |
| RTA time | 1 – 8 s | **1 s** | Longer anneal redistributes dopant and destroys the ultra-shallow junction |

Every parameter optimized toward the shallow, low-dose end of its range. With
`Lg` at 250 nm the flow is short-channel limited throughout, so any change that
deepens a junction costs more in gate control than it returns in drive current.

## Result

Against the reference condition (LDD 1e14 cm⁻² / 10 keV, S/D 5e15 cm⁻² /
10 keV, RTA 10 s):

- **`I_D/I_off` improved ~700×**
- **`SS` improved ~16%**

## Limitations

- **`I_off` is approximated.** It should be read at `V_g` = 0 V. The extraction
  script instead takes the extremum of the sweep, which is close but not the
  same point. A targeted interpolation at `V_g` = 0 would be correct.
- **One-at-a-time sweep.** Each parameter was optimized with the others fixed,
  so interactions between them are not captured. A full factorial or an LHS
  design would find a different optimum if the parameters are coupled — LDD and
  S/D energy plausibly are, since both set junction depth.
- **Single geometry.** All sweeps ran at `Lg` = 250 nm. The conclusion that
  shallow always wins is specific to this channel length.

## Repository

```
modifications.md              n-channel → p-channel command edits
extract_metrics.tcl           svisual post-processing: Vt, SS, gm, I_D, I_off
results/parameter_sweep.md    per-parameter reasoning and selected conditions
```
