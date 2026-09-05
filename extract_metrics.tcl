# extract_metrics.tcl
#
# svisual post-processing for the p-channel sweep.
#
# The transfer curve alone does not report the figures of merit needed to
# compare conditions, so Vt, subthreshold swing, transconductance and the
# on/off currents are extracted here and written out per node.
#
# Sign convention: the p-channel drain current is negative across the sweep,
# so the on-current is the sweep minimum and the off-current is the maximum.
# This is reversed from the n-channel case.

# Extract curve parameters only when the sdevice node has status done
if { $status == "done" } {

    load_library extract

    set Vgs [get_variable_data "gate OuterVoltage"  -dataset PLT($n)]
    set Ids [get_variable_data "drain TotalCurrent" -dataset PLT($n)]

    # Threshold voltage by the peak-transconductance method
    ext::ExtractVtgm out=Vtgm name=Vtgm v= $Vgs i= $Ids

    # On-current: largest magnitude, i.e. the minimum for a p-channel device
    ext::ExtractExtremum out=Id   name=Id   x= $Vgs y= $Ids type=min

    # Off-current: closest to zero, i.e. the maximum
    # NOTE: I_off should strictly be read at Vg = 0 V. This takes the sweep
    # extremum instead — close, but not the same point. See README limitations.
    ext::ExtractExtremum out=Ioff name=Ioff x= $Vgs y= $Ids type=max

    # Subthreshold swing, referenced to Vtgm/3 rather than a fixed offset so
    # the window tracks the device rather than sitting at an arbitrary bias
    ##ext::ExtractSS out=SS name=SS v= $Vgs i= $Ids vo= 0.01
    ext::ExtractSS out=SS name=SS v= $Vgs i= $Ids vo= [expr $Vtgm/3.0]

    # Transconductance
    ext::ExtractGm out=gm name=gm v= $Vgs i= $Ids
}
