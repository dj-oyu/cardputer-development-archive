# New query-aligned primary visibility trace

PREPARE/FREEZE ONLY until the parent independently reviews and explicitly says GO. This is a new per-query identity/distance trace, not a retry of already completed aggregate metadata. Do not modify frozen metadata/preflight files or old gates.

## Question

Explain why Q20 has70341 primary ground hits versus70342 baseline/Q16. Align corresponding ray requests before attributing changes. Determine whether classification/primitive changes belong to a final quarter input, the last retained center input, an overwritten intermediate center input, or a center later replaced by AA. Aggregate equality is not shadow parity.

## Authorized scope and limits

- Exactly baseline, Q16, Q20 front baseline inputs from frozen geometry preflight.
- 17070 shader-input events each:9392 intermediate center updates +7678 final quarter hits.
- Exactly16 primary hemisphere directions per event, thus273120 rays/variant and819360 total maximum.
- Per variant hard cumulative caps:100000000 node visits,50000000 triangle tests. Never reset during a variant. Failure produces partial trace and explicit failure record, then stops without retry.
- Original scene bounds/limits:1167 vertices,1566 triangles including ground,2048 triangle/4095 node/524288-byte admission ceilings. Original visibility implementation and exact bounce norm/direction functions.
- No full shader/light evaluation, no direct shadow segments, no secondary bounce rays, no renderer/image generation, no public/device operations.
- Host binary trace is40bytes/query,10924800 bytes/variant. Output is exclusive-create; run reservation is exclusive. No prior outputs overwritten. Preparation sidecars are separate immutable copies, original inputs read-only.

## Correspondence proof

Preparation derives per-event keys `(phase,x,y,per-pixel-update-ordinal)` independently for each source file. Phase0 is a center depth update; phases1..4 correspond to quarter offset0..3. For quarter hits the ordinal is always0. Keys are sorted only after construction. It asserts identical complete key sets and per-group update counts across variants, not mere equal row counts. File index is retained as provenance but never used to join across variants. Primitive input node/face/sourceID/back/recordOffset is stored separately, so changes are not hidden by including primitive identity in the join key. Ray key appends direction j0..15.

For phase0, only the last update at that pixel can survive center evaluation. If the target mask selects the pixel, that last center input is still replaced by quarter AA. Otherwise it is a retained center input. Quarter hits are labelled final-quarter; this indicates final quarter geometry input, not proof that later background composition retains its color.

Preparation verifies dot/norm/cross/direction text verbatim against allowed current bounce.c. The C helper compiles unchanged visibility.c. Explicit source hashes bind both. It normalizes each Ns and generates the same16 directions; no approximate or integer predicate is introduced in this diagnostic.

## Execution validation and outputs

Run requires the independently reviewed exact FREEZE.json SHA256. Before every variant and after all variants, all pinned inputs/source/binary hashes must match. Trace helper keeps original failure/budget behavior. Completed counters must match each prior aggregate metadata row exactly (rays,nodes,triangles,ground/character/miss,event/scene bytes). Reordering independent queries for alignment does not change query geometry or reset budgets.

Trace rows: little-endian U32 found,U32 triangle (UINT32_MAX miss),F64 distance (0 miss),3×F64 direction. Row `eventOrdinal*16+j` is tied to keys.json and that variant's aligned-identities.json. Aligned-events.f64le is17070×6 physical P and interpolated Ns, providing source-ray context without assuming identical primitive inputs.

Analysis counts all hit-boolean, ground/character/miss classification, triangle ID, distance and direction changes. Each classification/triangle divergence records its full aligned key, disposition, both primitive inputs and both ray outputs. It groups differences by retained/overwritten center versus final quarter, and isolates the Q20 ground delta. Raw traces preserve every distance change even when no classification changes. Any incomplete run is not certified.

## Commands

Already permitted preparation/build (no ray execution):

`sh ayatsuri-fixed-render-20261105/visibility-trace/build.sh`

`python ayatsuri-fixed-render-20261105/visibility-trace/driver.py --prepare`

After explicit independent GO only:

`python ayatsuri-fixed-render-20261105/visibility-trace/driver.py --run <reviewed-FREEZE-SHA256>`

No existing aggregate metadata command or fixed42 renderer gate is invoked. A trace result does not establish secondary shadow or full rendered parity.
