# Integer frame pipeline: bounded next stage and future integration design

## Decision and current boundary

Stage1 is **independent AA/HDR and fixed-input arithmetic verification only**. It does not integrate with the real renderer, create/trace scene queries, change visibility or ownership/generation behavior, or run new frames. Real integration and any visibility-related changes require separate confirmation and review. No earlier experiment's admission is reused for a different action.

The useful next output is a deterministic arithmetic corpus and coherent scalar1/2/4/8 results, with exact status/error provenance. Keep the current renderer and its complete test suite unchanged. An integer chain that produces plausible pixels under an all-visible fixture is not a renderer with valid shadows/reflections.

## Stage matrix

### Already established, with exact scope

1. **Source conversion:** versioned AYFQ sidecar from pre-×38 native-basis metres; signed32 source position frac16/20, normals /32767, source-linear rho /32767, explicit part/material identity. Q16/Q20 bridge to legacy F32 changes only geometry. Source pipeline and eight-lane block data are implemented; full-frame integer loading is not.
2. **Independent projection/attributes:** source integer projection and coverage to nonnegative exact-sum Q14 barycentrics, then native attribute bridge to world position/light Q16, normalized signed16 normal, rho and depthQ10. 1/2/4/8 agrees with bounded oracles. Geometry coverage experiment compares triangle-sample decisions, not current renderer winner/depth behavior. Q20 source→Q16 lighting still loses four fractional bits.
3. **Frozen actual interpolation replay:** all7,678 original hit P/Ns/rho reconstruct bitwise (69,102 doubles); Q14 weights + integer normal/rho interpolation measured on frozen winners. Normal angular max0.01028°; this does not validate changed rays.
4. **Integer direct lighting/output chain:** raw-normal saved-hit fixture7,678 records, explicitly all-visible disk16+world reference,14 display changes/max one channel code; 1/2/4/8 agrees. Prepared scene conversion is offline. No actual shadow/bounce equivalence follows from this fixture.
5. **Standalone output:** original float profile reconstruction matches all40 saved RGB565 frames. Integer profile on Q19 input differs at44/1,296,000 pixels overall in that experiment. Its25,700-byte shaper table is additional storage, not free. Integer math is not a hardware speed proof.
6. **Geometry-only actual canary:** exactly3 real frames, unchanged floating shaders, original/q16/q20 front; original raw exact, q16 four RGB565 pixels changed, q20 display exact but HDR differs. No all-fixed real frame has been rendered.
7. **Completed primary-query evidence:** q20 changes a ground hit in a center result later replaced by AA, plus four final-quarter adjacent-triangle identities. Q16 has11 final-quarter classification changes despite unchanged aggregate ground count. This existing evidence proves changed directions/geometry must not inherit old hit masks. It does not authorize any new query work.

### Safe independent next work in this stage

A. **Post-render HDR boundary:** consume verified saved final linear HDR; quantize into declared Q24 or directly Q19; run checked conversion/profile/pack. Compare same-input float oracle, quantization-only effect, integer arithmetic-only effect and total separately. No replacement of renderer callbacks.

B. **AA subset with parity admission:** group saved four quarter slots by exact snapshot/pixel/sample ID. First reproduce original floating sum/order/divide4 and compare final HDR bitwise. Admit only complete groups whose reconstructed original four-slot average matches saved final HDR bitwise. This establishes aggregate pixel parity, not individual post-resolver slot identity when action records are missing. Existing capture is pre-resolver, so misses stored as zero and later overrides are not valid background radiances. Explicitly exclude groups with missing/changed composition, even if a partial average looks close. No covered-sample renormalization. For admitted groups, checked-add four nonnegative Q24 RGB values and convert the exact sum directly to average Q19 with one ties-even division by128, avoiding an intermediate rounded Q24 average. Retain per-stage and total errors/statuses.

C. **Hemisphere direction arithmetic:** consume saved raw Ns, integer-normalize, build exact specified tangent-frame rule and16 deterministic directions; compare to original mathematical direction values offline. Count least-component-axis changes near ties, per-index angle deltas, near-zero/invalid/fallback statuses. A direction change invalidates use of its old query result as transport evidence. Direction outputs are numbers only in this stage, not ray requests.

D. **Fixed-sample reflection reduction:** consume caller-supplied fixed arrays of primary rho, sample direct radiance, secondary rho and world radiance. Test the exact declared sum `rhoPrimary × (direct[j] + rhoSecondary[j] × world[j]) /16` and channels/rounding/overflow against an arbitrary-width integer/rational oracle. Synthetic fixed contributions are appropriate because complete captured sample contributions are absent. All supplied values remain immutable; reduction does not decide hit identity, facing, visibility or material sampling.

E. **Coherent width tests:** use identical input records, lane status semantics, sample order and output keys for scalar1/2/4/8. Batch across unrelated pixels/records; never average different pixels together. Include structured mask fixtures as synthetic supplied constants, explicitly not real scene visibility.

### Deferred: separate confirmation and reviewed design required

- Wiring any integer stage into actual shade/AA/output callbacks or running a new actual integer frame.
- Capturing new post-resolver sample records or per-secondary radiance/material contributions from a live renderer.
- New scene construction/query execution, visibility masks, nearest-hit/depth winner implementations or query-dependent material selection.
- Any modification to scene ownership, lifetime, mutation epochs, generation tokens, fingerprints, resource admission or existing gates.
- Applying old captured masks/hit identities to changed integer position, normal, direction or light sample positions.
- Device/PIE assembly integration, target profiling, new resource envelope, public model/image/profile distribution or broad scenario expansion.

This list is not a recipe to bypass a restriction. Unsupported or unapproved stages stay disconnected; report the missing boundary explicitly.

## Frozen corpus and lane layout

`CORPUS_PLAN.json` inventories existing files with SHA256, byte sizes and record counts; it is a data/plan manifest, not an execution authorization.

**Final-output corpus F:**40 verified HDR files with97,200 F64 channels each (32,400 RGB pixels), corresponding RGB565 files and complete HDR observer reports. Total1,296,000 pixels. Key `(arm,view,case,order,pixelIndex)`; retain source HDR independently of each quantized representation. Feed RGB channels from one pixel as a single lane. 32,400 is divisible by8; ordering and source hashes must survive every width.

**Quarter corpus Q:** front baseline9,540 slots =2,385 pixels×4;7,678 character hits,1,862 misses. Key `(snapshotSHA,x,y,sampleIndex)` plus record/node/face/sourceId/back for hit attribution. Resolve no new background. Current worker parity gate admits1,746 all-hit pixels (6,984 slots);639 pixels with at least one miss fail and are excluded (2,556 slots, including1,862 misses). Snapshot and target masks are identical but capture/current full RGB565 files differ, so no global merge is inferred. Width8 over admitted1,746 pixels leaves tail2; full2,385-pixel population would have tail1. Raw slot count9,540 has tail4, but grouping and parity admission must precede batching.

**Normal/direction corpus N:** the same7,678 saved raw interpolated Ns values; retain binary64 originals, quantized raw codes, normalized codes, basis-axis decision and16 direction records per hit. Width8 tail6 is handled as4+2 because existing API accepts1/2/4/8, or explicit validated inactive lanes in a future API, not invented active samples. The direction index belongs inside the pixel record. Existing primary trace can explain previous divergence, but its query answers are not inputs validating newly computed directions.

**Contribution corpus R:** synthetic16-sample radiance/material records with explicit scales and sample keys. Include zero/all-nonzero/alternating contributions, first/last sample only, maxima, odd ties, cancellation-free checked overflow, invalid channels, failure-lane output rules, and maximum near-domain conversion. No unknown contribution is silently filled with zero. Real reflection corpus is presently incomplete.

**Connectivity corpus S:** existing32-sample synthetic native-geometry→attribute→all-visible lighting→output fixture;20 covered. Preserve its synthetic all-visible declaration. Useful for integer continuity/status propagation, not scene-level image quality. The existing actual-input.bin direct-light fixture is a separate all-visible comparison, not final captured HDR.

For every corpus, batch outputs join by keys, not file position alone. Keep every rejected/excluded/near-zero/clamped record in accounting. A width with fewer successful lanes cannot appear more accurate by omitting failures.

## Exact independent numeric boundaries

- Source position: signed32 metre Q16/Q20; source geometry domain≤128m. Attribute bridge rejects exact weighted light hit outside±8m before rounding. Q20 source accumulator converts directly to lightQ16; no double rounding through a rounded position.
- Normal/rho: signed16 unit/linear divisor32767, not32768. Integer normal cancellation fallback when squared code length<512²; preserve status. Coordinate basis is native `(x,y,z)`→world `(x,−z,−y)`; backface rule remains an explicit input.
- Weights: nonnegative signed16 Q2.14, each≤16384, exact total16384. Do not float-renormalize inside the integer runtime.
- Direct scene: three lights×16 prepared samples; positionsQ16 within±8m; powerQ16≤256; worldQ24≤16. Lighting's plane-distance cutoff around0.127m is much stronger than the original floating endpoint condition. Unsupported input returns fallback; a whole renderer must not silently treat it as dark/visible.
- Radiance: nonnegative uint64 Q24; sum/product overflow must be checked before arithmetic/narrowing. The AA worker admits each Q24 slot at≤2^40−1, so four-slot sum≤2^42−4; average-Q19 uses one ties-even division by128. Four-sample AA and16-sample light/reflection reductions are different operations. Always average linear radiance before tone mapping.
- Profile boundary: checked ties-even Q24→uint32 UQ13.19, then immutable private shaper/LUT/cache. Domain overflow, profile high clamp and decode failure remain distinct statuses. No uint16 signed multiply assumption for tetrahedron weights that can equal65536 or LUT values up to65535.

## Minimal future patch surface, design only

The safest eventual first real-frame patch is **output only**, after explicit approval: the current `rh_encode` input is already final-composed linear RGB. A separately named adapter can convert/check and call integer output while leaving upstream shader/query/AA behavior unchanged. Required changes would be one explicit opt-in call site, private immutable shaper configuration/cache ownership accounting, status propagation and a side-by-side reference comparison. Do not change default path or pretend new shaper storage fits the old cap without accounting.

Next possible opt-in surface is **AA radiance storage/reduction**, only after complete post-resolver inputs exist. The insertion point is after `sc_shade_final` chooses character/floor/world radiance and before per-pixel linear averaging. It must not sit before background replacement or store miss=zero. Keep integer accumulation separate from original renderer until all slot composition/status correspondence is proven. This requires reviewed memory/layout/work and source provenance, not a mutable reuse of an old gate.

**Direct integer lighting** is a later distinct adapter after valid geometry/material/normal/query outcomes are available. The existing `il_pixel.visible[3]` is a contract requiring correct16-bit masks for the exact positions/light samples used. Passing unchanged old masks to newly quantized inputs only tests frozen arithmetic. Establishing fresh valid masks or changing query semantics is outside Stage1.

**Reflection** has a clean pure reduction boundary after sample contributions have been determined; direction generation is upstream and affects those contributions. Keep those two experiments separate. A full-frame implementation also needs side-dependent secondary normals/rho, direct light samples, world visibility, ground emission/reflection, floor-world terms and background composition. No single current saved array supplies all of these.

## Correctness and performance gates for a later authorized patch

1. Original default build/source hashes and all existing CI remain intact. New opt-in tests cannot replace original expected results, prune difficult cases, enlarge caps or disable counters. Preserve API/status/error-atomicity, guard, alias, lifetime and failure tests as existing obligations without modifying them here.
2. Freeze format/unit/rounding contracts, active variant scope, immutable input corpus and all generated private table hashes. Distinguish representation error, arithmetic approximation and geometry/path changes.
3. Require exact scalar1/2/4/8 outputs/statuses and deterministic sample summation order, including partial batches, multiple triangles/materials, explicit invalid lanes and near-domain cases. Include O0/O2 and sanitizer/oracle tests. No signed overflow, negative-shift assumptions or masked-lane side effects.
4. Gate original oracle reconstruction before every actual-data comparison. Report excluded groups and all fallback categories. No final-image claim from a triangle-sample coverage test, all-visible direct-light fixture, post-render quantization or fixed-path replay.
5. For an eventual actual opt-in frame, require a new confirmed scope and genuine candidate metadata/caps; unchanged original control first; own-input counts; report HDR errors and final RGB565, boundary/character/floor/world/mixed subsets, and any separately authorized query correspondence. Numeric differences remain measurements until acceptable quality criteria are agreed in advance.
6. Performance requires target-specific implementation and permission: measure full-frame costs including conversion, gather/table/cache traffic, normalization/division/64-bit operations, scalar fallback, tail packing and memory. Report cycles/pixel and end-to-end latency alongside quality. Existing host no-floating-op scans and eight-lane source loops do not prove PIE instructions, speedup or target memory fit.
7. Keep new output shaper25,700B and any radiance buffer/state in explicit stack/heap/readonly ledgers. A 128-bit lane width does not turn32/64-bit geometric arithmetic or uint64 reductions into eight safe signed16 lanes.

## Source-linked evidence

- `ayatsuri-fixed-pipeline-20261105/converter/README.md`, `quality/replay/README.md`: source encoding and frozen attribute parity.
- `ayatsuri-fixed-integer-geometry-20261105/{README.md,ATTRIBUTE_BRIDGE.md,geometry.h,attribute_bridge.h}`: numeric domains and connectivity limits.
- `ayatsuri-fixed-integer-chain-20261105/{README.md,private/RAW_RESULTS.json,private/SOURCE_PINS.json}`: actual all-visible raw-normal fixture and scalar widths.
- `ayatsuri-fixed-integer-light-20261105/{integer_light.h,normal_bridge.h}`: prepared masks/domain/fallback contracts.
- `ayatsuri-fixed-integer-output-20261105/README.md`: table, format, profile error and actual40 output results.
- `ayatsuri-fixed-render-20261105/plan/canary-output/{RESULT.md,RESULT.json}`: completed3-frame geometry-only evidence.
- `ayatsuri-fixed-render-20261105/visibility-trace/{REPORT.md,RESULT.json,OUTPUT_FREEZE.json}`: completed query correspondence evidence, read-only here.
- Current unchanged `fox-v3-indexed-bvh-bounds/{code/ksn_bounded_hdr_impl.inc,private-build/product/main/ui/kasane/ksn_scene_composition_impl.inc}`: eventual final-radiance/output insertion boundaries; no modification made.
- Stage1 sibling `aa/` and `reflection/` reports will supply exact newly admitted arithmetic counts and APIs; pending results must not be promoted to proven full-frame behavior.

## Stage1 AA completion update

The independent AA worker has now completed `aa/README.md` and `aa/private/{CORPUS,RESULTS,SOURCE_PINS,ARTIFACT_HASHES}.json`.

- Strict baseline gate:1,746 pixels/6,984 slots reconstruct both final HDR and original profile RGB565 exactly before candidate evaluation. Integer AA changes zero displayed pixels in this subset.
- Excluded639 pixels contain2,556 slots (1,862 misses+694 hits); final resolver action/chosen radiance are missing. They remain excluded, not approximated.
- Separate32,400 already-resolved final HDR inputs produce one green-channel one-code display change; this is output conversion, not reconstructed full AA.
- Width1/2/4/8 and O0/O2 sanitizer results agree, actual fallback/clamp counts zero.
- Concrete API: `aa_init`, `aa_put` with explicit KEEP/REPLACE chosen inputs, `aa_reduce`, `aa_finish`, `aa_finish_block`. No resolver is computed by this API. Duplicate/incomplete slots reject.
- State update is atomic per put; finish outputs are unchanged on failure. Block output array commits only if every lane succeeds. External encoder/cache side effects are not rolled back. Future caller contracts must preserve this distinction, rather than claiming fully transactional shared-cache behavior.

These new results add a proven independent reduction boundary; they do not change the deferred integration/visibility permission boundary above.

## Stage1 reflection arithmetic completion update

The direction/reducer worker reports its independent candidate in `reflection/integer_reflection.h`:

- `hr_directions16` / `hr_block` select the least-absolute raw input component BEFORE integer normalization. Exact minimum-component ties return `HR_BASIS_AMBIGUOUS`; produced directions are diagnostic only, not accepted query directions. Other failures do not publish output. Do not reinterpret a nonzero status as valid visibility input.
- All7,678 actual saved normals accepted, zero ambiguous/failure/basis-switch cases observed;122,848 directions have max angle error0.0068922257°, RMS0.0020793915°. Synthetic near-tie cases demonstrate97.18°/77.60° per-index jumps and are flagged. Raw-axis ordering is justified against exact mathematical normalization, not universal floating-normalizer tie parity.
- `hr_fixed_sample` contains externally supplied direct/world uint32 UQ13.19 radiance, secondary rho/32767 and an active flag. `hr_reduce16` / `hr_reduce_block` return uint64 Q19. The flag is a fixed contribution selector, not a ray query result inferred here. The30,000-component synthetic reduction comparison reports max absolute error1.39194e−6. Actual captured per-direction radiance terms are unavailable, so no real reflection-quality result follows.
- **Scale seam remains explicit:** reflection samples/results use Q19, while direct lighting and AA slots use Q24. They are not directly interchangeable pointers. Promoting admitted reflection Q19 output to Q24 by an exact checked ×32 is straightforward under a proved bound; producing uint32 Q19 samples from arbitrary Q24 radiance can overflow and needs a checked converter/status. Neither bridge is claimed integrated by this plan. A later independent bridge test can prove representation/connectivity without doing any scene/query work.

Source result details and hashes remain in the owning worker's report; these findings do not change current permission scope.
