# Exact AgX LUT access and profile contract audit

Read-only source/report audit, 2026-11-04. No evaluator, baseline, renderer, SDK, device, repository, reference, or profile asset was changed. No fit or rendering was performed. Codec measurement is a separate workstream; this report does not select a measured codec or claim target admission.

## Result

Lossless storage can preserve the current profile only if every decoded scalar equals the existing uint16 node and the existing evaluator's arithmetic, domain handling, ordering, and status semantics remain unchanged. Prefer a bounded value-copy four-vertex gather over replacing each source read with a shared-cache pointer. The existing 4096-byte background cap is not permission to spend 4096 bytes of profile scratch. The current host evidence is not a 32-bit target stack/link/runtime proof.

## Frozen source and addressing

Source: `fox-v3-profile-integration-feasibility/build-private/agx_profile.c`, lines 4–15; constants and array declaration: `build-private/agx_lut.inc`, lines 1–6. N=65; 274625 RGB nodes; 823875 uint16 scalars; 1647750 bytes. Original node index is `(x*65+y)*65+z`, scalar index is `node*3+c`, c=0..2. x/y/z correspond to input R/G/B. Axis strides are 4225,65,1. Do not confuse this source order with a codec's reblocked traversal order.

For bases b and sorted axes o, the four node indices are i0, i1=i0+s[o0], i2=i1+s[o1], i3=i2+s[o2]. These are four distinct vertices and twelve distinct uint16 values, not eight cube corners. Source line 12 reads three initial channels; line 13 expresses three steps × three channels × two endpoints, hence 21 scalar read occurrences. A compiler may optimize occurrences; do not equate them with measured loads or decoder calls.

For nonnegative finite inputs, base coordinates remain within 0..63 and vertices within 0..64. Maximum node index is 274624 and maximum scalar index is 823874. Index/count arithmetic fits uint32_t; that observation is not a license to truncate byte offsets or size_t checks in an external loader. Partial edge blocks must derive dimensions from 65 and the block origin, with no assumptions of divisibility or readable padding.

## Arithmetic and API invariants

- Null input/output or any negative/nonfinite input returns INVALID=2 before output writes (lines 5–6). Negative zero is accepted by the existing comparison. Inputs must remain stable during the call; existing local result allows in-place overlap.
- Promote each float input to double; clamp only when x > exact AGX_HI and OR CLAMP_HIGH=1. Preserve the literal constants, double log1p, division and multiplication order, floor, and final-cell base adjustment (lines 8–9). The closest float to the nominal upper endpoint may already be above it; preserve flags, not just color.
- Fractions are cast to float after u-base. Keep the exact pairwise sorting algorithm and strict `>` comparisons (line 10). Do not replace it with a purported stable axis sort: the existing swap sequence is the contract, including ties.
- Preserve `(float)node / 65535.0f` separately at the expression positions. Keep result initialization followed by the three sequential float `result += fraction*(next-current)` updates. Do not rewrite as weighted barycentric sums, reciprocal multiplication, integer interpolation, trilinear interpolation, FMA, fast-math, double accumulators, or reordered additions.
- Keep final fminf(1,fmaxf(0,result)) and status return. Decoder failure, if introduced, needs an explicit propagated failure contract and output atomicity, never an invented zero node or silent successful partial result.
- Exact integer reconstruction is necessary but not a cross-compiler floating-point proof. Validate float bits/status under the actual compiler and floating-point options; target ABI/libm/FMA differences remain separate.

## Bounded fetch recommendation

A conceptual internal gather takes four checked node indices, immutable encoded bytes plus lengths/index metadata, and explicit bounded caller-owned scratch; it copies twelve uint16 values into `vertex[4][3]` (24 bytes) before floating arithmetic. It may group vertices by block, decode each unique block once, and scatter copied RGB values back to original vertex order. Once copied, use the original expression structure and division at each occurrence. Do not retain references into reusable decode storage.

A scalar value-return accessor is memory-safe if implemented correctly, but not sufficient to bound decodes to four. A single-block cache repeatedly invoked from the original 21 occurrences can thrash between edge endpoints; conservative bound is 21 misses. C does not fix evaluation order of subtraction operands. Pointer-return accessors are worse: one call can invalidate storage needed by the other operand, and mutation can be unsequenced. Returning copies in separate full expressions avoids this class of issue.

For regular nonoverlapping monotone rectangular spatial tiles, the tetrahedron's three positive-axis steps enter at most four distinct blocks. A gather then requires at most four decodes. Do not transfer this bound blindly to planar channels, unusual index permutations, or codecs requiring other blocks as predictors: count their dependencies separately. A full RGB B-cube buffer costs 6*B^3 bytes before descriptor, bit-reader, predictor, alignment, and gather storage. Prior B4/B8 designs used 384/3072 bytes respectively, not total stack bounds.

Avoid hidden global/TLS mutable caches: the existing evaluator is stateless, allocation-free, and has no initialization requirement. Shared caching introduces reentrancy/concurrency and reset-lifetime obligations; a lock is also a runtime cost. Caller-owned explicit scratch requires a callback/context integration decision because the present `agx_profile_eval(in,out)` has no context argument. A per-call bounded local scratch is conceptually possible, but must pass new named-stack measurement. No implementation or API adoption is authorized by this audit.

An eventual decoder must check metadata/count/version, every offset/length without overflow, block and channel bounds, residual/predictor signed range, exact reconstructed uint16 range, bitstream exhaustion and canonical padding. Never assume corrupt input cannot occur merely because a table is const. Reuse must bind cache identity to the exact immutable table/version, and failure must not leave a stale valid cache entry.

## Renderer ownership and stack integration boundary

`fox-v3-aa-phase-overlay/harness/profile_bridge.c:1–4` directly includes the pinned evaluator and exports the full `agx_lut` span through `row_profile_storage`. `harness/row_transport_bridge.c:19–31,77–89` includes that span in pairwise alias and scene-overlap admission. Replacing storage therefore affects more than the fetch expression: every encoded payload/index/header and mutable scratch span must remain correctly represented in admission/accounting. A compressed byte count with a stale pointer to old storage would not satisfy this contract.

`fox-v3-aa-phase-overlay/NAMED_STACK.json:271–319` reports own agx_profile_eval host frame144 bytes, center-profile chain1360 and quarter-profile chain1168. Lines492–499 record background4080/cap4096, renderer5008/cap8192 and separately counted observer main83776. The product ledger (`MEMORY_LEDGER.json:27–34,46–48`) instead uses main83792 and named render total491384. These are different named paths, not a universal4096 scratch budget. Library/runtime stacks are excluded (NAMED_STACK lines516–522). Adding a codec to a profile path must recompute that chain and overall maximum; adding mutable heap scratch changes live-span admission and phase totals. Actual 32-bit target frame size, ABI/layout, libm stack, linker placement, flash/cache latency and runtime capacity remain unknown.

## Existing quality evidence and rejected approximation

`fox-v3-agx-profile/profile/REPORT.md:3,7–20` records finite holdout validation, not all-RGB OCIO equivalence. Frozen gates use channel quanta31/63/31: RMSE≤0.5, p99≤1, max≤2. 84981 accepted samples include50000 independent log-HDR,5000 linear HDR,2049 dark/gray,12288 saturated-axis,36 endpoints,1000 all-high,8912 mixed-high and5696 first-cell fixtures, plus15 atomic-invalid tests. The u16 integration REPORT lines7,23 establishes all823875 original float-node bits recovered, all84981 synthetic outputs/statuses and324000 actual outputs/statuses/nearest565 exact. Lossless storage preserves this baseline approximation; it does not improve its official-transform accuracy.

`fox-v3-profile-factorized33/REPORT.md:7–15` documents a separate numerical, not bit-exact, functional factorization. Its reduced33³ candidate FAILED unchanged precision gates: log-HDR p99 1.527/1.336/.586 and max3.813/4.011/3.429; saturated axes also failed. All50000 failing-group inputs were within domain. Better selected image metrics cannot rescue this failure. Functional approximation is therefore not the preferred route for this lossless task; no retuning, fit or new image evaluation is proposed.

Earlier fixed Lorenzo B4/B8 storage was also rejected: `fox-v3-profile-flash-feasibility/REPORT.md:3–16,24–32` totals1725193/1692601 bytes, both larger than1647750 raw and above historical544048 free flash. This is not a lossless entropy lower bound; separately authorized measurements may assess a different fixed design, but neither historical rejection nor this access audit constitutes new fit success.

Future standalone validation, if separately authorized: first exhaustive original-order integer reconstruction; then independent bounded random-access and malformed-input checks; preserve zero output/status differences against frozen profile on existing synthetic/actual input buffers without rerendering; exercise ties, all tetrahedron permutations, block/edge boundaries, aliases, invalids and cache interleaving. Run same-compiler/options O2 and sanitizer builds and compare every continuous float bit, status and nearest565 value. The parent identifies retained current40 HDR buffers as available for this stage: preserve the baseline raw-double-to-float conversion, per-sample multiplicity and source hashes, and compare all40 rather than silently substituting the older10-frame set. This is proposed coverage, not a test run in this audit. Exhaustive integer recovery plus unchanged expressions establishes storage fidelity; the finite evaluator replay establishes observed standalone outputs, not all-floating-environment equivalence. It does not establish renderer callback wiring, admission coverage, scratch lifetime, failure propagation or whole-frame atomic publication. Target linking/stack/runtime evidence remains a later independent requirement.

## SHA-256 source pins read for this audit

- evaluator C: 219bfd8f602c20017818757aae64220b27f40a48ca7ce7652fff0cbe9c194483
- uint16 LUT include: 3b4b28704b39cc64942b0be6d69f7e1c1c05a09b2289b3b7850007868e7c0432
- overlay profile bridge: f202c2730ccdb9bfb9586165c4c57a99eebff3a8ab83f83afc1d9a21c52db166
- integration U16_RESULTS.json: be23d950e7fa0a8b96e50f83dfe4e5a8128e511aec9bf8b958b7642334cf62db
- factorized33 REPORT.md: 268f1e3bb8961757913b3b46a9740b7c3e1c8b5d84b5a36084c2429ff8963ba8
- prior lossless REPORT.md: 9bd60eb1a3946dd20dec654e7e4e6ad6b0be19e874b8b7111f2ffa1e8d7df87f
