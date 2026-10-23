#!/bin/bash
# ULX5M-M2 panel (KiKit, KiCad 10).
#
# VARIANT=lr (default): rails left/right, 2 tabs on each long edge (1/4 and 3/4).
# VARIANT=frame       : full frame, plus 2 tabs on the M.2 screw end, clear of
#                       the screw notch; no tabs on the gold-finger end.
#
# Tabs come from panel/kikit_tabs_m2.py (KiKit 'fixed' tabs can only spread
# them at i/(N+1) of every framed edge).
# Rail text is rotated 90deg so it reads along the rails.
#
# KIKIT can point to a local kikit instead of docker, e.g. KIKIT=kikit

REPO=${REPO:-/home/goran/projects/ulx5m-m2-git}
VARIANT=${VARIANT:-lr}
KIKIT=${KIKIT:-"docker run -it -v $REPO:/kikit yaqwsx/kikit:nightly-v10"}

TABS_PLUGIN='code: panel/kikit_tabs_m2.py.EdgeFractionTabs'
case "$VARIANT" in
    lr)
        FRAMING='railslr; width: 6mm; space: 2mm;'
        TABS="plugin; $TABS_PLUGIN; width: 5mm; arg: left=0.25,0.75 right=0.25,0.75;"
        OUT=panel/ulx5m-m2_panel.kicad_pcb
        ;;
    frame)
        FRAMING='frame; width: 6mm; space: 2mm; cuts: none;'
        TABS="plugin; $TABS_PLUGIN; width: 5mm; arg: left=0.25,0.75 right=0.25,0.75 top=0.2,0.8;"
        OUT=panel/ulx5m-m2_panel_frame.kicad_pcb
        ;;
    *)
        echo "Unknown VARIANT '$VARIANT' (lr|frame)" >&2
        exit 1
        ;;
esac

$KIKIT panelize \
                --source    'tolerance: 0.2mm;'                    \
                --layout    'grid; rows: 1; cols: 1; space: 2mm;' \
                --tabs      "$TABS"                               \
                --cuts      'vcuts;'                              \
                --framing   "$FRAMING"                            \
                --copperfill 'solid;'                             \
                --post      'millradius: 1mm;'                    \
                --fiducials '3fid; hoffset: 3mm; voffset: 10mm; coppersize: 2mm; opening: 2.5mm;' \
                --tooling   '4hole; hoffset: 3mm; voffset: 3mm; size: 3.2mm;' \
                --text      'simple; text: Intergalaktik d.o.o. ULX5M-M2-v0.2; anchor: ml; hoffset: 3mm; voffset: 0mm; orientation: 90deg; width: 1.2mm; height: 1.2mm; thickness: 0.25mm; hjustify: center; vjustify: center;' \
                --text2     'simple; text: Created on {date}; anchor: mr; hoffset: -3mm; voffset: 0mm; orientation: 90deg; width: 1.2mm; height: 1.2mm; thickness: 0.25mm; hjustify: center; vjustify: center;' \
                --post 'millradius: 0.5mm;' \
ulx5m-m2.kicad_pcb $OUT
