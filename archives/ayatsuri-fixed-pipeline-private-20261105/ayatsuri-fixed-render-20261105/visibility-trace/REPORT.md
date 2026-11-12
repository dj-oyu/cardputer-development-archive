# Query-aligned primary visibility trace: completed

Executed only after independent review and GO for FREEZE SHA256 `672dd3d70861682cdfcec3549396f4b3386d8b585a3fa3fd7073b398140ced73`. All source/input hashes matched before each variant and after the three traces. All eight aggregate counters for each variant exactly matched the already completed metadata study. No failed operation or retry occurred.

## The Q20 one-ground-hit difference

Exact ray key is `[phase=0,x=120,y=45,per-pixel-center-update-ordinal=3,direction-j=0]`. Input identity remains node31,face33,source46,front side. This is the last center update at an AA-target pixel, labelled **center-replaced-by-AA**, not a retained center or final-quarter shader input.

- Baseline: ground triangle1564, distance3.2740567764969346m.
- Q20: character triangle801, distance0.10987985850994768m.
- P changed by6.546526140443134e-7m; max Ns component change3.2860716615013e-5. The resulting direction changes near a visibility boundary.
- This accounts exactly for ground70342→70341 and character115756→115757, with no miss-count change.

The changed center shading result is replaced by the later AA result at this pixel. Thus the aggregate floor-count discrepancy is not itself a retained final-color input. It still consumes real intermediate work, so it legitimately changes the work metadata. This finding does not prove full Q20 lighting/shadow parity.

## Other changes

| Metric versus baseline | Q16 | Q20 |
|---|---:|---:|
| Hit/miss boolean changes |10|0|
| Miss/character/ground classification changes |14|1|
| Triangle-ID changes (including miss) |40|6|
| Distance-value changes |186103|186098|
| Direction-vector changes |273079|271770|
| Net ground-hit delta |0|-1|

Q16 classification changes:3 center-replaced-by-AA,11 final-quarter. Its equal aggregate ground count hides compensating per-query differences.

Q16 triangle changes:6 center-replaced-by-AA,10 overwritten center,3 retained center,21 final-quarter.

Q20 triangle changes:1 overwritten center,1 center-replaced-by-AA and4 final-quarter. Its four final-quarter changes are all between two character triangles sharing an original edge (two common original vertex IDs):

- `[phase2,x127,y67,ordinal0,j8]`:325→312; distance delta−9.66188e-8m.
- `[phase2,x136,y47,ordinal0,j13]`:1014→1017; distance delta−4.02742e-7m.
- `[phase3,x134,y52,ordinal0,j11]`:1004→1005; distance delta−2.50905e-6m.
- `[phase4,x134,y37,ordinal0,j7]`:1230→1229; distance delta−1.76309e-7m.

The overwritten-center change732→746 also shares an original edge. Shared-edge adjacency suggests boundary-sensitive primitive ownership, but does not prove identical interpolated material/normal or secondary response. Distances/directions change widely because geometry quantization changes the interpolated ray inputs, even where hit classifications remain unchanged.

## Exact scope and correspondence

17070 independently aligned events per variant:4694 overwritten center updates,1919 last center updates subsequently replaced by AA,2779 retained center inputs and7678 final-quarter hits. Alignment by `(phase,x,y,per-pixel-update-ordinal,j)` was proven from key sets and per-pixel counts, not assumed from file order. Changing primitive input identity is retained separately. Q16 has3 changed primitive inputs; Q20 has0.

Exactly273120 nearest rays per variant,819360 total, no direct shadow segments or secondary rays:

- Baseline:21883182 node visits,7442309 triangle tests;ground70342,char115756,miss87022.
- Q16:21921502 node visits,7445834 triangle tests;ground70342,char115756,miss87022.
- Q20:21923864 node visits,7432466 triangle tests;ground70341,char115757,miss87022.

All stayed within reviewed per-variant100M-node/50M-triangle ceilings. Original bounded scene bytes69276. No physical shader, full renderer or device executed here. This new trace is distinct from the earlier aggregate metadata computation; its purpose and outputs are per-query identity/distance classification.

## Artifacts

- `RESULT.json`: complete counter equality and comparison summaries.
- `q16.divergences.json`, `q20.divergences.json`: every classification/triangle changed key with both inputs and outputs.
- `Q20_DETAIL.json`: exact original-edge adjacency and input/distance deltas.
- `{baseline,q16,q20}.trace.bin`:40-byte records retaining every query's found flag, triangle, distance and direction.
- `keys.json`, `*.aligned-identities.json`, `*.aligned-events.f64le`: immutable joins to source events.
- `FREEZE.json`: independently reviewed input/code freeze.
- `OUTPUT_FREEZE.json`: completed output hashes and verified input freeze.

Frozen metadata, preflight, renderer gates and original sources were not modified. No public operations occurred.
