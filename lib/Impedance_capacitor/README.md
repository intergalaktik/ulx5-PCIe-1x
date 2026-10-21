# v10_footprint — ULX5M_SI.pretty (TASK-5667)

KiCad 9/10 footprinti AC kondenzatora 0402 za M2 v0.2 i GS v006. Kondenzator ostaje 0402 (0201 zabranjen, TASK-5606), a ravnine ostaju pune.

| footprint | pločica (poprijeko × uzduž) | središta | upotreba |
|---|---|---|---|
| **C_0402_SI_C** | 0,30 × 0,35 | ±0,450 | **TX**: M2 C143/C144, GS C134/C135 (preporuka TASK-5641: 81 Ω, Γ 2,3 %) |
| **C_0402_SI_M** | 0,40 × 0,35 | ±0,425 | **REFCLK**: M2 C136/C137, GS C129/C130/C136/C137 |
| C_0402_SI_CN8 | kao C | ±0,450 | rezerva TX; vrat 0,09 × 1,17 crta se kao VOD + `kicad_dru/SAMO_ZA_CN8_MN8_*.kicad_dru` |
| C_0402_SI_MN8 | kao M | ±0,425 | rezerva TX (IPC kl. 3); vrat kao gore |

TX izbor je promijenjen s CN8 (TASK-5649) na **C** nakon 3D simulacije cijelog para (TASK-5641, commit 6d9b786): vrat podiže impedanciju preko 85 Ω i povećava Γ.
Vrat nije dio footprinta. Kad je bio ugrađen kao ravni pad uz os kondenzatora, DRC na M2 dao je 3 nove clearance povrede i 1 connection_width.

Maska je 1:1 i pasta 1:1, obje **eksplicitno** u footprintu. Obje ploče imaju `pad_to_paste_clearance -0,05`, što bi otvor paste na C svelo na 0,20 × 0,25 (AR 0,56).

## Datoteke
- `ULX5M_SI.pretty/` — knjižnica; `out/ULX5M_SI_footprint_TASK-5667.zip` — knjižnica + uputa + dru odsječci
- `out/ULX5M_SI_footprint_TASK-5667.pdf` — str. 1 uputa za ugradnju, str. 2 provjera, str. 3 prije|poslije
- `ploca_m2/`, `ploca_gs/` — kopije ploča: `prije`, `kontrola` (samo spremljeno), `ulx5m-*` (C+M), `ulx5m-*_CN8` (na dorađenoj ploči TASK-5649); `*.drc.json`, `drc_razlika_{A,B}.json`

## Ponavljanje
```
python3 alat/gen_fp.py                                   # .kicad_mod + out/footprinti.json
~/app/tmp/TASK-5386/k10py.sh alat/provjera_fp.py         # pločice/pasta/maska prema TASK-5640 -> SVE_OK
bash alat/provjeri_ploce.sh                              # ugradnja na kopije + DRC razlika (izlaz 0 = 0 novih)
k10py.sh alat/izvuci_geom.py <ploca> out/geom_<grupa>_{prije,poslije}.json REF,REF   # 5 grupa, vidi GRUPE u alat/slike.py
~/app/tmp/tools/openems/env/bin/python alat/slike.py && ~/app/tmp/tools/openems/env/bin/python alat/pdf_uputa.py
```
