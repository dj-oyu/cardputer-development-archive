# Conditional supplied-branch radiance reducer

This standalone arithmetic prototype uses source-proven closure weights under an explicit **conditional numeric contract**. It is not a renderer transparency implementation, an existing renderer composite, or exact Cycles transport. No scene/background/visibility acquisition, frame/render, device, publishing, renderer or prior-kernel change occurs. Both frozen opaque connectors continue to reject nonopaque material results.

## What the source proves, and what is assumed

The latest two eye-white materials connect white Transparent first and Principled second to Mix Shader. At top-level incoming weight1, pinned Blender4.3.2 code at revision32f5fdce0a0a571a39198edf8d7b5d719bf59f2c clamps the factor and assigns weights1-w andw respectively. Principled Alpha is1; white Transparent adds no RGB tint. Source and graph evidence are pinned in transparency-spec/SPEC.md and evidence.json, with verified primary GitHub links. Its audit stops at closure weighting, not a complete path integrator.

This reducer additionally assumes the caller supplies **two complete, unweighted, linear RGB radiances for compatible sample/direction/transport conditions**: the opaque/Principled branch and the white-transparent continuation branch. Those conditions cannot be verified by this numeric API and are unresolved for an actual scene. Neither operand is BaseColor, rho, an already weighted contribution, nor the earlier diffuse-light approximation. No renderer identity is inferred from the mathematical linear combination.

The historical background audit establishes opaque KEEP/FLOOR/WORLD selection, not transparent continuation. KEEP's zero RGB is a sentinel, not a black background. This implementation does not consume or reinterpret those values. No missing eye background is guessed.

Original latest source SHA d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a, derived2k-v2 SHA384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8 and sidecar SHA00a81fbcd19c79c578bbbbd7ab077ee6f63048a106c5594675ff208670d5e85e remain explicit. These identify the material/fixture source, not the synthetic branch RGB or current-scene transport.

## Runtime interface and arithmetic

`tc_slot` contains already-clamped opaque weightw and white-transparent complementt, both Q16, Q20 or Q24 for the selected build, plus two RGB Q24 arrays. Require0<=w,t<=S, t=S-w, S=2^Q. Out-of-range or inconsistent weights reject; raw shader-factor clamping belongs upstream. Both radiance arrays are required and range-checked even at endpoint weights. Nonunit incoming closure weights, nested mixes and colored transparency are outside this interface.

For each component, compute exactly:

    mixed_Q24 = RNE((w * opaque_Q24 + t * continued_Q24) / S)

The two weighted terms are summed before **one** rounding. No pre-rounding each term, BaseColor multiplication, gamma, tone mapping or RGB565 occurs here. Atw=0 the result is the supplied continued branch exactly; atw=S it is the opaque branch exactly. Equal branch inputs remain unchanged for every valid weight.

For each group, blend its four supplied slots independently with their own weights and branch operands. Accumulate those mixed Q24 values exactly, then use the existing AA reduction RNE(sum/128) once to obtain averaged Q19. Apply the unchanged private integer profile/RGB565 once afterward. Four supplied tuples are not actual pixel AA. Averaging the weights or branches before their per-slot combination is invalid in general.

`tc_block` supports widths1/2/4/8. It stages final-only aa_result outputs and publishes all lanes only after every lane succeeds. A malformed final lane, Q19 overflow or profile failure leaves all caller outputs unchanged. The profile cache may warm before failure. Caller buffers must be disjoint and stable during calls. `tc_mix` also stages all three channels before committing. The runtime has no heap, floating-point arithmetic, material evaluator, geometry code or light evaluator.

**The control/material connection is in test-fixture preparation only.** prepare.py calls frozen integer mc_prepare/mc_eval on source-derived or explicitly synthetic local coordinates to obtain mix and complement. Runtime tc_block receives supplied weights and branch RGB; it does not evaluate the material or retrieve background.

## Bounds and rounding error

Each branch radiance code is in[0,M], M=2^40-1. Complementarity gives:

    w*A + (S-w)*B <= M*S <= (2^40-1)*2^24 = 2^64-2^24 < 2^64.

Each product and their sum therefore fit uint64 even at Q24. RNE uses quotient/remainder, not numerator+half, so no rounding-add overflow is possible. The rounded mixture remains in[0,M]. Four-slot accumulation is below2^42; Q19 uint32 overflow is explicitly rejected before encoding. Test oracles use Python arbitrary integers and native __uint128_t; the runtime itself needs only64-bit arithmetic.

Added mixture error relative to the exact combination of represented weights and supplied radiances is at most0.5 Q24 code. Averaging four such errors does not enlarge that bound; converting their mean to Q19 scales it by1/32, then adds at most0.5 Q19 code. Thus total added final-HDR error is bounded by33/64 Q19 code. This excludes inherited control/material/source quantization and fixed-vs-float predicate differences. It does not establish a general RGB565, original-float, physical-lighting or Cycles-output error bound. Exact observed source-plus-supplemental fixture maxima are in results.json; these maxima exclude the separate boundary/random tests. Explicit half-tie boundary cases attain the0.5 Q24 mixing-error limit.

## Fixtures and observations

**Source-derived coordinate set:**155 latest eye-white triangles ×4 declared Q14 barycentric points ×17 controls (all original12 states plus five Blink values between0 and.02) =10,540 point evaluations per Q. Canonical Q20 local-XZ interpolation and explicit material precision conversion preserve the frozen coordinate contract. Geometry remains neutral; control variation is not posed geometry evaluation. At these sampled source coordinates, all weights are binary:9,154 one and1,386 zero. New low-Blink controls do not by themselves prove fractional weights on these sampled geometry points.

**Separate synthetic-local supplement:** two sides at declared X=side*.285,Z=2, nine Blink settings, four independently supplied branch pairs per group. These are18 arithmetic groups/72 points, explicitly **not source surface geometry or screen pixels**. They produce8 weight-one,16 weight-zero and48 fractional points per Q. The source-backed b=1/128 witness evaluates in the actual frozen C material to w=39/64 andt=25/64 exactly. Other low-Blink settings test additional fractional codes. Supplemental IDs, Q24 controls, local codes and both branch arrays are retained separately in each fixtures-Q.json.

Both branch RGB arrays in every set are deterministic, declared synthetic operands independent of latest lights, normals, backgrounds or visibility. They are complete unweighted radiance test inputs by contract, not acquired or validated scene results.

For each Q, all2,653 groups match independent wide-integer mixture/sum/128 expectations and the frozen profile mapping. Every group is checked at widths1/2/4/8, giving10,612 successful-width and malformed-final-lane atomic checks.20,000 further full-range random mixtures per Q match the arbitrary-integer oracle. Native boundary tests cover endpoints, complementary weights, maximum40-bit radiances, invalid factors/radiances, Q19 overflow, empty-cache failure across widths1/2/4/8, plus a separate successful high-profile clamp case. Direct tc_mix failure checks also verify unchanged RGB output when its final channel is invalid.

Two explicit ordering counterexamples are retained:
- Half of1 plus half of1 rounds jointly to1; rounding the terms separately would give0.
- Four varying weights with paired branch values yield correct HDR19=0; independently averaging branches and weights would incorrectly yield50.

All six Q16/Q20/Q24×O0/O2 ASan+UBSan tests pass over the full source-plus-supplemental corpus and boundary checks. Leak detection is disabled for the environment's existing ptrace restriction. Full standalone disassembly shows no FP arithmetic/conversion; undefined-symbol scans show no libm or heap dependency. Test-only cache wrappers allocate host storage; they are excluded from standalone runtime libraries.

These2,653 conditional supplied-input successes do **not** mean that previously rejected nonopaque geometry groups are now supported by the renderer.

## Memory and provenance

- Supplied slot56B; four-slot input224B; width8 caller inputs1792B.
- Final-only output16B/lane; width8 caller output128B; separate atomic staging128B.
- Per-group accumulator32B and reusable mixed RGB24B. tc_mix has a separate24B logical result array before compiler lifetime/register reuse. Scalar arithmetic locals are separate.
- Existing caller-owned profile cache3224B; unchanged static encoded profile445248B and shaper25700B, one copy each. No material LUT is linked into the standalone reducer because material preparation is test-only.
- Host GCC14.2 O2 own frames:tc_mix8B,tc_block304B at all Q. Q20 reducer object text664B. No new readonly/data/BSS table is introduced. These are own host frames/sections, not peak nested stack, target SRAM, S3 ABI, timing or speedup.

The profile is the existing frozen numeric output mapping. Agreement with latest .blend view transform/Look is not established. Linked private-profile binaries are not for public distribution. A report/source-only package should omit .so, .o and native executables.

Dependency manifest separates source weight evidence, background exclusion evidence, frozen material test preparation and output-profile dependencies. It verifies all frozen audit111/compact50/spec5/background8 artifacts unchanged. No earlier opaque connector, source, renderer or CI file is modified.

## Unfinished work

Acquiring compatible complete branch radiances; actual transparent continuation and layered transport; Principled reflection/specular/diffuse behavior; shadow transmission; coverage/dither; film alpha; animation; current-scene geometry/lighting/background correspondence; latest-view display equivalence; renderer integration and target performance/memory remain unresolved. The source establishes closure weights only. The conditional supplied-radiance composition stops at that stated numeric boundary.

## Reproduce

Run `python prepare.py > prepare.log`, `sh build.sh`, `python verify.py > verify.log`, then `python audit.py`. All retained writes remain in this directory. The source evidence and frozen dependencies are read-only. SHA256SUMS binds source, fixtures, compiler evidence, logs, results, binaries and reports.
