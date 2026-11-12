# Private supplied-input integer kernel chain

This independent harness joins already-tested numeric kernels. It does not modify or integrate a renderer, perform a frame/render, query rays/visibility/BVH/scenes, evaluate animation, use a device, or publish anything. All retained deliverables are confined to this new directory. No target-speed, image-quality, latest-Blender-reproduction or production-readiness claim is made.

## Three separate provenances

1. Geometry/material: latest original source SHA d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a, derived 2k-v2 SHA 384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8, neutral sidecar SHA 00a81fbcd19c79c578bbbbd7ab077ee6f63048a106c5594675ff208670d5e85e. Canonical attribute-v2 Q20 provides the 155 triangles of the two exact eye-white materials. fixtures.json retains object/part/triangle/polygon/source-vertex identities, independent world/local streams, corner normals, four declared Q14 barycentric points, 12 named Q24 control states and hashes. Nearest-original-face hints are not used. Geometry remains evaluated neutral under every control state; this is not posed/blink geometry evaluation. Other 1,827 triangles/recipes, including contour/corner/face mask, are excluded.
2. Lighting: declared synthetic centers (0,4,3), (2,-4,3), (-2,4,3) metres, normals -Y,+Y,-Y, 16 explicitly repeated center samples per light, power RGB (1,2,3) Q16, world RGB (1/8,1/4,1/2) Q24. Repeated samples are intentionally numeric fixtures, not scene disk generation. Visibility is supplied all-visible, all-invisible, or (0x5555,0xaaaa,0x0f0f). No visibility is inferred. The four triangle vertex/edge/interior points are **not actual pixel AA samples**.
3. Output: the existing frozen private integer display-profile/shaper/RGB565 implementation. It is tested as a numeric mapping only. Its agreement with the latest .blend view transform/Look is **not established**. This private profile and linked test artifacts must not be published. No old model result is presented as a latest-model result.

The dependency manifest separates these groups. Source pins are inherited from the authoritative attribute binding, not a new source re-evaluation. Code, fixtures, compilers, binaries and reports are hashed separately by SHA256SUMS. No renderer HEAD binding is claimed.

## Exact runtime sequence

mc_prepare consumes Q24 controls using the integer control kernel and selected compact material Q16/Q20/Q24 build. For each supplied slot:

- Validate nonnegative Q14 weights sum exactly 16384; use signed64 MACs on canonical Q20 corners, then nearest-even division by 16384. World and object-local are interpolated independently.
- Convert world Q20 point to light Q16 by signed RNE /16. Convert local XZ Q20 to material Q16 by RNE /16, Q20 unchanged, or Q24 checked multiplication by16. Q24 does not recover precision discarded in canonical Q20 input. This is not three independently quantized geometry series.
- Evaluate BaseColor and Mix with compact C material. Reject Mix != 1 exactly. No guessed transparent/background blend, clamping or skipped sample is substituted. Returned roughness/IOR/specular parameters remain in audit output but are not consumed by the diffuse kernel.
- Require each linear BaseColor code in [0,2^Q]. Convert once to rho/32767 with RNE(color*32767/2^Q). No gamma/display transform occurs here.
- Interpolate supplied world raw /32767 normals using the same Q14 weights and integer-normalize. Local material coordinates never stand in for a world point or a projection frame.
- Call validated integer diffuse lighting once. The light kernel adds world and direct irradiance, then applies rho exactly once. No extra world term or rho multiplication is added by this chain. No reflected transport is evaluated or added.
- Accumulate four supplied Q24 slot results without intermediate mean rounding, tone mapping or RGB565. Divide exact sum by128 with RNE once to obtain Q19; then call the frozen integer profile/RGB565 once.

Only widths1/2/4/8 are accepted. All result lanes commit together after complete success. Cache warming may occur before later rejection; output atomicity does not mean cache rollback. Caller-owned frame/scene/input/cache/output must be nonoverlapping; no concurrent mutation is supported. The runtime chain allocates no heap. reference.c uses malloc/free only to supply test-owned caches to Python.

## Bounds and rejection

World corner admission is ±8m Q20, matching light Q16 ±524288; local corner admission is ±128m Q20. With convex Q14 weights, world MAC magnitude <=2^37, local <=2^41, normal <=2^29, safely signed64. Signed nearest-even helpers never receive INT64_MIN in these paths. Local Q24 narrowing is explicitly checked before int32 conversion; procedural domain/overflow checks remain those of the unchanged material kernel. Rho multiplication is <=2^24*32767, below2^39. Nonopaque and out-of-range color reject rather than clamp.

Light scene bounds and its near-plane/near-sample fallback checks remain enforced. Each radiance result must pass AA_SAMPLE_MAX=(2^40)-1; four-slot sum is below2^42. Q19 uint32 overflow rejects. Empty/bad profile cache rejects encoding. These are checked arithmetic guarantees, not an all-domain material success proof. The API does not implement renderer fallback handling.

## Validation and observations

Per Q, 155 triangles ×12 states ×3 visibility patterns ×4 supplied points gives22,320 material point evaluations:18,162 opaque numeric points and4,158 nonopaque exclusions. Of5,580 complete four-slot groups,4,473 succeed and1,107 reject nonopaque with output unchanged. Some opaque points belong to rejected mixed groups; they are not claimed as successful complete-chain results. admissions.json records every state/triangle/point status independently of visibility; examples.json gives selected accepted numeric tuples.

All accepted groups agree exactly with a staged reference: direct standalone C material/profile calls plus an independently written arbitrary-precision Python oracle for interpolation, conversion, normalization, light arithmetic, radiance and exact sum/128. Direct C light calls also match the oracle. The oracle is independent arithmetic/code, not an independently derived physical lighting model. Each Q has11,928 nonzero-direct accepted slot results, and all-invisible cases prove world*rho once. No claim of floating-transport agreement follows.

Per Q,512 width1/2/4/8 grouping/final-lane invalid-input atomicity checks and8 separate final-lane nonopaque atomicity checks pass. Rho conversion checks exhaust all65,537 Q16 admissible codes and test20,007 Q20/Q24 edge/random codes per Q, plus four invalid extremes with unchanged output. Native tests cover final-slot invalid barycentric/world/material/near-zero normal, empty-cache encoding failure at all widths, unsupported width, rho bounds/half ties, exact sum/128 ties, Q19 overflow atomicity, and the double-rounding counterexample sum65: RNE(65/128)=1 whereas RNE(RNE(65/4)/32)=0.

All six per-Q O0/O2 ASan+UBSan executables run the full latest fixture corpus in addition to boundary tests. No sanitizer findings. Leak detection is disabled because of this environment's ptrace restriction; runtime kernels allocate no heap. Full shared-library disassembly scans show no floating arithmetic/conversion instructions and undefined-symbol scans show no libm dependency. Integer SIMD moves do not imply SIMD arithmetic or target acceleration.

Added rho quantization error is measured against the **exact fixed material output**, not a float material result. Maximum absolute observed reflectance error: Q16 0.00001522805448; Q20 0.00001521780962; Q24 0.00001525878724, each <=1/(2*32767). Exact fractions and induced pre-rounding Q24 radiance differences are in results.json. Existing fixed-vs-float material differences, strict-edge flips and Q24 raw-product limitations are inherited unchanged from compact material results and are not erased by this integration. Float/Cycles differences are not recomputed or folded into these added-conversion numbers.

## Storage and host-only measurements

The harness deliberately retains audit intermediates, not a shipping-minimal layout:

- Selected compact material frame208B; uniform scratch192B; spatial scratch232B; selected-Q RGB LUT3084B.
- One supplied slot92B; four-slot input368B; one full audit output496B, including material/positions/normals/rho/radiance/final result. Width8 input2944B; caller output3968B; atomic staging output3968B. Per-lane temporary output496B and accumulator32B are separate logical storage. Compiler lifetime reuse may overlap storage.
- Synthetic scene684B; output cache3224B caller-owned. Existing profile encoded static blob445248B and shaper25700B, separately from material LUT and cache. These tables are not all SRAM-resident by assertion.
- Host GCC14.2 O2 chain own stack frame4848B; compact mc_eval432B; integer_output208B; cache fetch304B; aa_finish64B. Raw per-Q .su and object section sizes are retained. Chain .text Q20=4089B. These own frames are not a proved total call-stack maximum; nested calls, alignment and target ABI matter.
- fixtures.json is provenance/audit JSON, not runtime memory. fixtures.inc compiles full duplicate test inputs into sanitizer executables only. Neither is an optimized model representation.

No target SRAM budget, S3/PIE ABI, cache spill cost, timing, FPS or speedup follows.

## Explicit unfinished semantics

Principled roughness, IOR, specular and reflection transport; transparency/background handling; contour/corner/face-mask recipes; animation/modifier/normal updates; actual scene lights/visibility; actual pixel sample generation/coverage; latest-source display-view equivalence; renderer integration/fallback; and target performance/memory validation remain unimplemented. The optional face-mask projection basis is not silently combined with eye object-local XZ.

## Reproduction

Run `python prepare.py`, `sh build.sh`, `python verify.py > verify.log`, then `python audit.py` from this directory (scripts also locate their own directory). No source/model/renderer is edited. Build scripts link the frozen dependencies read-only and write only here. Test logs, admissions, hashes and disassembly are retained for audit.
