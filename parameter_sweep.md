# Parameter sweep

Five process parameters were swept one at a time, with the other four held
fixed. For each condition `I_D/I_off` and subthreshold swing were extracted and
compared against the targets: `I_D` > 1e-5 A/µm, SS < 100 mV/dec,
`I_off` < 1e-14 A/µm.

Device fixed at `Lg` = 250 nm, gate oxidation time 10.

---

## LDD dose

**Swept:** 1e12, 5e12, 3e13 cm⁻² → **selected 1e12**

The lightly doped drain forms a low-concentration region at the gate edge,
relieving field crowding near the drain and suppressing hot-carrier effects.
Raising the dose lowers on-resistance, but too high a dose worsens
short-channel effects.

Across the sweep, increasing dose reduced `I_D/I_off` and degraded SS
monotonically. The lowest dose was best on both metrics.

## LDD energy

**Swept:** 1, 2, 3, 4, 5 keV → **selected 1 keV**

Implant energy sets the projected range `R_p`, and therefore junction depth. A
deeper junction weakens the gate's control of the channel, opening the door to
punch-through and DIBL.

`I_D/I_off` fell and SS degraded as energy increased. 1 keV was best on both.

## S/D dose

**Swept:** 5e15, 6e15, 7e15 cm⁻² → **selected 5e15**

Source/drain dose sets the main doping concentration, forming ohmic contact and
minimizing parasitic resistance `R_S/D` to secure `I_on`. But an excessive dose
steepens the dopant gradient near the junction, raising junction leakage, and
lateral diffusion shortens the effective channel.

The `I_off` increase and SS degradation outweighed the `I_D` gain at every step
up, so `I_D/I_off` fell with dose. The lowest dose was best on both.

## S/D energy

**Swept:** 1, 2, 3, 4, 5 keV → **selected 1 keV**

Same junction-depth mechanism as LDD energy, but S/D is the higher-concentration
region, so depth changes act more strongly on short-channel effects.

`I_D/I_off` fell and SS degraded with increasing energy. 1 keV was best on both.

## RTA time

**Swept:** 1, 2, 4, 8 s → **selected 1 s**

Rapid thermal annealing repairs implant lattice damage and electrically
activates the dopant. Longer anneals raise activation but also redistribute
dopant by thermal diffusion, `D = D₀·exp(−Ea/k_B·T)`, deepening the junction.

Since both LDD and S/D were implanted at 1 keV to form ultra-shallow junctions,
excessive annealing destroys exactly the profile the low-energy implants were
chosen to create. `I_D/I_off` fell and SS degraded with anneal time; 1 s was
best on both.

---

## Selected condition

| Parameter | Reference | Selected |
|---|---|---|
| LDD dose | 1e14 cm⁻² | 1e12 cm⁻² |
| LDD energy | 10 keV | 1 keV |
| S/D dose | 5e15 cm⁻² | 5e15 cm⁻² |
| S/D energy | 10 keV | 1 keV |
| RTA time | 10 s | 1 s |

**`I_D/I_off` improved ~700×. SS improved ~16%.**

Every parameter landed at the shallow, low-dose end of its swept range. At
`Lg` = 250 nm the device is short-channel limited throughout, so anything that
deepens a junction costs more in gate control than it returns in drive current.
S/D dose was already at the optimum in the reference condition — the entire
gain came from the four depth-related parameters.
