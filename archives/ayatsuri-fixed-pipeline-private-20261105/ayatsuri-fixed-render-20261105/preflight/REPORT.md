# New geometry/snapshot/coverage preflight

Status: six independently derived geometry diagnostics complete. This is NOT a shaded render or a reused execution gate.

## Verified control before candidate evaluation

For front and oblique baseline cameras, the new diagnostic used unchanged current model evaluator, segmented arena owner, compact codec, snapshot append and disk-scene loader arithmetic. Its baseline snapshot, target mask and F32 center depth matched saved indexed-BVH-bounds outputs byte-for-byte. Every final quarter hit matched saved physical sample evidence exactly in record offset, node, face, physical side, source identity, depth, P, Ns and rho. Baseline hit counts and intermediate center updates also matched. Only after both controls passed did the driver evaluate q16 and q20 candidates.

Baseline original-order world geometry, with ground appended, has FNV f9c66f89d3536bf6, identical to saved renderer metadata. Source identity was independently generated from new GLB adapter parts/origins, then compared exactly to the prior 7930-byte table. Source identity remains unchanged because topology and correspondence do not change.

## Results

- All six snapshots: 54 records, 1564 character triangles; all source bindings/winding validated.
- Front targets: 2385; oblique targets: 2391. All candidate target masks are byte-identical to their baselines.
- Front center hits 4698; intermediate center updates 9392. Quarter hits [1922,1920,1933,1903] for baseline/q16/q20.
- Oblique center hits 5157; intermediate center updates 9636. Baseline/q20 quarter hits [1842,1853,1836,1834]; q16 [1843,1853,1836,1834].
- Logical winner differences versus baseline by phase [center,sample0,sample1,sample2,sample3]: q16 front [1,1,1,0,0]; q16 oblique [1,1,0,1,0]; q20 both [0,0,0,0,0]. These count record/face identity changes, not depth changes. Q16 center winner changes preserve source identity, explaining unchanged masks.
- No unchanged shadow/lighting quality claim follows. Even identical winners can have different P, depth and downstream visibility.

## Independent AA charge derivation

`derive_ledgers.py` reconstructs all 21 current AA categories from candidate geometry and authoritative charge call sites in `code/ksn_stream_depth_impl.inc` and `code/ksn_bounded_ring_helpers.inc`. It proves ALL21 predicted baseline observed counts equal saved actual observed counts. No baseline candidate counts are substituted.

Reservations use computed snapshot append work; center bbox visit upper bound; exact sample bbox/test/hit counts; fixed layout/count formulas; fixed structural caps for source validation (32768), identity bytes (8192), snapshot bytes (65536), and required admission/control contract (4160). The guard bound replaces actual center updates by bbox upper bound, adds the unused control allowance, then rounds up to 10000. This independently derives front 300000 and oblique 290000 guard reservations versus old 310000; no guard is removed or disabled. It is a candidate ledger, not a modification to an old ledger.

- Front total reservation 7913890 for all three geometries.
- Oblique baseline/q20 7653634, q16 7653660.
- All totals <=8000000. Final shade reservation is exactly 76 times candidate quarter hits.

The output `.aa-ledger.txt` has 21 unsigned integers in current enum order. `.aa-ledger.json` includes named predicted/upper categories and proof details. `LEDGERS.json` aggregates the six new results.

## Files and layout

Prefix is `{baseline,q16,q20}-{front,oblique}`.

- `.snapshot`: exact current owned snapshot, 416-byte light header plus codec packets; SHA/FNV in metadata.
- `.targets.u8`: 32400 row-major bytes, 0/1 per 240×135 pixel.
- `.targets.packed`: 4050 bytes, pixel i at bit (i%8) in byte i/8. Scene target FNV must use this packed representation: front dd51bcec009b27b1; oblique 66e48da613d39dfa. The `targetFNV` in geometry.json deliberately refers to u8 representation; named packed value is in ledger JSON.
- `.center-depth.f32le`, `.center-source.u16le`: 32400 values each; nohit is -infinity / 65535.
- `.winner-records.u16le`, `.winner-faces.u8`, `.winner-depths.f32le`: 5×32400 values, phase 0=center then phases1..4 quarter offsets (-.25,-.25), (+.25,-.25), (-.25,+.25), (+.25,+.25). Quarter arrays retain nohit outside the target mask. Record is ordinal0..53, NOT packet byte offset. No hit codes 65535/255/-infinity.
- `.events.jsonl`: every accepted intermediate center depth update (phase0), then final HIT events for each quarter phase1..4. Contains x/y, packet recordOffset relative to byte416, node, face, sourceId, back, depth, physical Blender-world metre P, interpolated unnormalized Ns, linear-decoded legacy rho. It contains no misses and does not execute a shader. It is sufficient to enumerate physical shader inputs for ray-only work prediction.
- `.world-vertices.f64le`: 1167×3 physical Blender-world metre coordinates. Character vertices first1163, then four original ground vertices.
- `.world-triangles.u32le`: 1566×3 global original-order vertex indices. Character first1564, then two ground triangles. Not snapshot visibility-reordered triangles.
- `.geometry.json`, `RESULT.json`: derived counts, differences and hashes.
- `identity.bin`: independently derived source table.

Binary numeric files use this verified little-endian IEEE host ABI. No C struct padding is serialized in winner/world arrays.

## Scope and resource limits

The C diagnostic admits exactly55 model nodes,54 mesh records and1564 original faces. Model input <=1MiB, snapshot capacity65536, original geometry1163+4 vertices/1564+2 triangles, viewport240×135, fixed17 eight-row bands and four quarter samples. Codec and snapshot work admission remain unchanged. It emits exclusively created files under a fresh reservation prefix. The Python driver refuses to rerun over a completed result.

`geometry_helpers.inc` is a verbatim extraction of the current canonical edge construction/evaluation helpers, not a fitted or simplified alternative. The independent coverage traversal preserves current order, edge closure, reciprocal/multiply order, F32 depth conversion and strict depth tie behavior. The current model evaluator necessarily computes discarded legacy vertex colors; **no physical pixel shader, transport shader, BVH query, floor or background shading runs**. This is no-physical-shading geometry preflight, not a promise that model_evaluate has no arithmetic related to legacy colors.

Host diagnostic static arrays use the explicitly reported `diagnosticStaticBytes`; its largest own stack frame is57088 bytes, plus called functions. The `.su` file records named stack usage. These are separate offline diagnostic resources, not target renderer memory/performance claims. Existing linked objects are pinned in BUILD.json. No device execution, public publication, baseline file edits, gate reuse or denied-tree access occurred.

## Remaining requirements before shaded canary

Independent floor/background metadata still must derive 16 primary nearest queries per shader event (including intermediate center updates), ground-hit counts and exact floor work allowances; background slots/intersections/override counts and resolver/category bounds; complete candidate geometry/material/snapshot fingerprints, scene target packed identity and input freeze. A new reviewed comparator/execution plan must bind these facts and new outputs. Existing fixed42 admissions are neither changed nor reused. No shaded comparison has been executed by this diagnostic.
