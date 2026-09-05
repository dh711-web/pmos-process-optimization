# n-channel → p-channel modifications

Five edits to the SimpleMOS flow. The base template is Synopsys-licensed and is
not reproduced here — only the lines that changed.

---

### 1. Substrate doping (sprocess)

A p-channel device conducts with holes, so the channel forms in an n-type body.
The substrate is switched from Boron to Phosphorus to create the N-well.

```diff
  ## step Init
- init concentration= @NWell@ field= Boron      slice.angle= 180 !DelayFullD
+ init concentration= @NWell@ field= Phosphorus slice.angle= 180 !DelayFullD
```

### 2. Source/drain implant (sprocess)

Source and drain must supply holes, so the dopant flips from n-type Phosphorus
to p-type Boron.

```diff
  ## step SD Implant
- implant Phosphorus dose= @SD_Dose@ energy= @SD_e@
+ implant Boron      dose= @SD_Dose@ energy= @SD_e@
```

### 3. LDD implant (sprocess)

The lightly doped drain relieves field crowding at the gate edge. It must match
the polarity of the source/drain it extends, so Arsenic becomes Boron.

```diff
  ## step LDD implant
- implant Arsenic dose= @LDD_Dose@ energy= @LDD_e@
+ implant Boron   dose= @LDD_Dose@ energy= @LDD_e@
```

### 4. Gate sweep polarity (sdevice)

A p-channel device inverts under negative gate bias, so the sweep target is
reversed.

```diff
  *- Vg sweep
  NewCurrentPrefix="IdVg_"
  Quasistationary(
    DoZero
    InitialStep= 0.01 Increment= 1.5
    MinStep= 1e-5 MaxStep= 0.05
-   Goal { Name="gate" Voltage=  2.5 }
+   Goal { Name="gate" Voltage= -2.5 }
  ){ Coupled {Poisson Electron Hole} }
```

### 5. Drain bias (workbench parameter)

The drain bias points set on the sdevice node are reversed to match.

```diff
- Vd = 0.05, 1.0
+ Vd = -0.05, -1.0
```

---

## Note on current sign

With the bias reversed, drain current is negative throughout the sweep. The
extraction script therefore reads the on-current as the sweep **minimum** and
the off-current as the **maximum** — the opposite of the n-channel convention.
See `extract_metrics.tcl`.
