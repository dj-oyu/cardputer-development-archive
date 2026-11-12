# Independent adjacency-greedy packing experiment

Frozen inputs are `attribute-prototype/attributes-q16-v2.json` and `attributes-q20-v2.json`, hashes cf4bdf24d363454427544bb3596af15d0b1c8b820137e9f062e6c366023289b9 and81830dd0d7c363e3f7c6d6b7f4c4147112b0df89d7e28081763a9cfef0c9f536. Their hashes were verified before and after the experiment; canonical v2 was not changed. This folder contains candidates, not a replacement authoritative source IR or a runtime asset.

## Algorithm

Group triangles by original object and material, retaining every original triangle/corner attribute and source ID. A part starts with either the lowest remaining source triangle ID (`min_id`) or a highest remaining edge-adjacency degree seed (`max_remaining_degree`). Among triangles fitting≤32 distinct full-attribute vertices and≤64 triangles, greedily prefer greatest vertex reuse, then shared edges, then remaining adjacency degree, with stable source-ID tie breaking. When no triangle fits, start another part. Disconnected triangles may fill unused capacity if they fit; no spatial distance, nearest-face, ray, visibility or runtime scene query is used.

Adjacency is a dictionary of exact source/attribute edge keys, not a geometric evaluation. Source-degenerate eyelid triangles retain distinct source vertex identities even when coordinates coincide. No welding, geometry reduction, normal/color changes, material conversion or topology repair occurs.

## Results (identical schedules for Q16 and Q20)

| Case | Parts | Partition records | Extra copies beyond1322 |8-lane blocks | Max vertices / triangles |
|---|---:|---:|---:|---:|---:|
| Frozen canonical order |120|2302|980|319|32 /44|
| Greedy min-ID seed |99|1645|323|235|32 /49|
| Greedy max-degree seed |99|1651|329|235|32 /49|

The min-ID candidate removes657 partition copies and21 parts. Cross-part source edges decrease972→283, and source vertices spanning parts decrease559→255. All1,982 triangles and1,322 unique source vertices remain. All36 neutral-degenerate tags remain unchanged. The max-degree variant is also recorded; it is slightly worse in unpadded records and ties after8-lane padding.

Memory **formula comparisons only**, with unchanged definitions from the attribute prototype:

| Formula | Baseline | Min-ID candidate | Difference |
|---|---:|---:|---:|
| Audit unpadded `64+64P+40V+8T` |115680|88056|-27624|
| Audit8-lane padded |125680|97456|-28224|
| Hypothetical old AYFQ geometry-only `64+32P+8M+144B+4T` |57864|45096|-12768|

These exclude material recipes, deferred animation/provenance, optional UV6,336B, runtime scene/workspace, code, cache and allocator costs. They are not shipping layouts, total RAM, target fit, old-format admission or runtime-speed claims. No optimal partitioning result is asserted. Different heuristics or objectives could produce better or worse results.

## Exact checks

For each of the four candidates:
- Each source(object,triangle ID) occurs exactly once:1,982 entries.
- Material identity and every source triangle metadata field are identical.
- Ordered corner records are byte-for-byte canonical-JSON identical: source vertex ID, world/local fixed positions and world/local normal codes. Keeping corner order preserves winding.
- Shared source edge world-position values and all source vertex attribute sets are unchanged.
-36 authored neutral-degeneracy tags remain attached to the same triangles.
- Every part meets32 vertices/64 triangles, independently verified after packing.
- Repeating the algorithm yields the same candidate; Q16 and Q20 schedules match.
- Optional UV side-stream association remains through the original source object/triangle/corner IDs. The792 UV corners are verified unchanged; candidates reference the frozen canonical IR instead of copying the deferred payload.

Four further unittest groups pass: content/limits, UV association, detection of duplicate triangles and deliberate position/normal/material/winding/ID mutations, and unchanged input hashes. `results.json` carries all metrics and checks. Candidate JSONs contain the proposed part arrays and an exact source-IR hash reference; they do not pretend to include a working material/animation/runtime implementation.

## Runtime caveat

Geometric/material input preservation does **not** prove changing submission order is harmless in an existing renderer. Equal-depth winner tie breaking, alpha/transparency order, packet/source-ID mappings or implicit ordering assumptions could matter. A future integration would need an explicit order-independent/source-ID policy or mapping audit under separately authorized scope. No renderer, visibility, owned context, query, old loader or format gate was run or changed here.

Run `PYTHONDONTWRITEBYTECODE=1 python3 compare_packing.py` only in a fresh copy/output folder: output files use exclusive creation and are not overwritten. Run `PYTHONDONTWRITEBYTECODE=1 python3 test_packing.py` to verify the existing artifacts.
