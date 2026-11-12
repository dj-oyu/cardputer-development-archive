# Camera-background hook: design only, not implementation authorization

## Current stop status

Parent preflight reports the original direct-ray quota also fails: combined added direct queries1,118,832 front /1,203,920 oblique, combined maximum1,642,832; background-only1,486,704 /1,656,192. It additionally found3 front floor-in-front slots, so the claimed background-only ordering equivalence is not established. Those are parent-reported preflight results, not measurements made by this design worker. Implementation remains stopped pending parent disposition. This document proposes call-site accounting only; it assigns no new budget, inherits no floor-reflection allowance, and authorizes no workaround for either failure.

## Frozen base and admission result

Use `fox-v3-boundary-rho-affine-evaluation/actual-A2` and its A2 quarter-offset/rho-affine source, not the older boundary core and not the floor-reflection experiment. A2 reserves 7,923,890 stages front and 7,673,634 oblique, leaving 76,110 and 326,366 under its unchanged 8M cap. Its workspace is 137,312 bytes plus the existing 8,192-byte transient-stack reserve, or 145,504 bytes. Its existing immutable tables are already separately reported as 7,930+360=8,290 bytes, not re-described as fitting the older 8,192-byte identity-only cap.

The combined arm has C=27,236/26,703 non-target center misses, S=1,862/2,199 selected sample misses, B=C+S=29,098/28,902 callback evaluations, and N=30,015/30,009 non-target centers (front/oblique). Just 8*C encode/write stages are 217,888/213,624. Front cannot admit even that isolated addition under old8M. The complete proposed core-only additions below are 816,518/810,546, before resolver work, descriptor fingerprint bytes, or preflight. Both old8M admissions therefore fail. No core/model/source edits or rendering were performed for this design.

## Smallest explicit API and control separation

Add one separately named composite host entry point, `ksn_mesh_pixel_render_camera_background_experimental`, taking the existing A2 arguments plus a background binding. The binding contains a nohit callback, context pointer plus explicit context byte size, independent background-stage ledger/report, immutable descriptor identity and preflight binding. The conceptual callback is:

`bool background(context, owned_lights, screen_x, screen_y, sample_tag, out_linear_rgb[3])`

`sample_tag` is 0..3 for the existing fixed quarter offsets and 4 for a center. Coordinates are the actual existing sample coordinates, with no +.5 or quantization. This callback returns radiance, not coverage/depth. It does not replace the character shader. The resolver itself builds a local candidate, checks it, and copies its 3 doubles only on success. Core also validates returned RGB independently. A separate size-aware background observer can stream floor/world classification and direct/world/emission components; those diagnostic bytes and I/O are separately counted.

A NULL background binding in the new entry immediately calls the untouched A2 entry. No newly added descriptor checks, loops or guards run in that branch, so old bytes, counters and failure behavior remain eligible for exact replay. Existing A2 functions/defaults remain unchanged. Non-NULL work is confined to a separately copied/new host implementation.

### Selected sample miss

At the existing final-winner nohit branch:
1. Preserve the existing character nohit count, source sentinel and character hit=false.
2. Initialize local `sampleRGB[3]` to zero.
3. Invoke the resolver into local output, never directly into the HDR accumulator.
4. On false or any nonfinite/negative component, fail the whole frame. A partial callback write never reaches the accumulator.
5. Add the three valid values to the existing band HDR sum, checking finite sums.
6. Emit background diagnostics separately. Character hit/depth/source identity and original hit counts are unchanged. The existing sample observer may include the actual returned nohit radiance, but must keep hit=false; it must not relabel a floor hit as a character hit.

After four samples, use the same denominator4, equal mean, clamp/float sRGB/lroundf565 path. All covered character sample computations and calls remain identical.

### Non-target center miss

Reuse the existing final output loop, which already scans all32,400 pixels. For a non-target, inspect center_id once. Only sentinel65535 invokes the center background resolver once, validates local HDR, and uses the existing single-pixel encode/write arithmetic once. A covered non-target center's RGB/depth is never touched. Target centers never invoke background, because their four samples supply the output. The added center-ID classification and encoding receive explicit new charges despite sharing the existing loop.

### Background-only control

Use a separate small background-control entry rather than pretending this is the combined arm with zero character color. It performs no character camera shader calls and has no character-depth output. It uses the same retained character+floor shadow BVH. Its mask is the preflight-produced, source-geometry/snapshot/camera-bound fixed A2 mask in the existing `workspace.targets`, not a mask recomputed after hiding the character or derived from background RGB.

Prepare that mask directly in the existing workspace buffer and bind its digest before the control call. If an external4050-byte mask is copied instead, charge that construction buffer and copy/validation peak explicitly. Do not leave an unaccounted retained4050-byte copy alive. The control evaluates C0=P-T centers plus S0=4T samples, B0=P+3T:39,555 front and39,573 oblique. Report it as a synthetic camera-hidden control; original character geometry metrics are not repaired by its background.

## Exact proposed core-stage dispatch accounting

These are proposed bounded stages, not CPU instructions and not an assertion that the new work is old bbox49-equivalent. The implementation must expose each category, pre-admit it and compare observed counts against the reservation. Each guard dispatch is separately charged. All fail paths retain consumed counters.

For the combined arm, retain every old A2 category unchanged and append:

| New category | Count |
|---|---:|
| Fixed binding/alias/generation validation | 512 |
| Frozen target bitset fingerprint bytes | 4,050 |
| Non-target center-ID classification | N |
| Query preparation: coordinates, tag, destination setup | 4B |
| Local RGB zero initialization | 3B |
| Callback dispatch | B |
| Returned RGB finite/nonnegative checks | 3B |
| Callback attempt/success-domain accounting | 2B |
| Selected nohit HDR addition plus finite checks | 6S |
| Non-target center encode/write | 8C |
| Guard dispatches for those five per-call charges, sample accumulation, center encode,17 classification guards and2 frame charges | 5B+S+C+19 |

The resulting core-only additions are front816,518 and oblique810,546. A proposed immutable descriptor canonical fingerprint adds its actual serialized byte length separately; the layout below would add848 bytes. No floor-intersection/evaluator stage is hidden in the single callback-dispatch stage. Existing final-target averaging is unchanged and remains in old A2 work.

Background-only control has its own ledger rather than falsely reporting old character work as performed: binding512; mask copy+hash upper8100 (actual hash-only4050 when prepared in place); band HDR clear3P; sample enumeration/mask-test4P; final output scan/mask-test P; query4B0; local zero3B0; callback B0; validation3B0; event accounting2B0; target accumulation6S0; encoding8P; guard dispatches5B0+S0+P+105. This is1,338,287/1,338,779 stages plus descriptor hash and all resolver/preparation work. The independent control is not admitted by this estimate: it still needs its own fixed direct/BVH/work accounting and full domain completion.

## Resolver and preflight costs must remain separate

The nohit callback is opaque to the core and its costs cannot be hidden in one dispatch unit. Its ledger needs distinct counts for camera affine transforms, ray/plane solve and nonfinite checks, clip/ray-parameter checks, finite-triangle tests, geometric normal orientation/tangent classification, existing evaluator input/light validation, all48 disk kernels per floor evaluation, positive-kernel endpoint setup, actual shadow queries, floor-world/Le composition, result validation/atomic copy, and its own counter guards. True world misses use source world radiance itself and have separate copy/classification counters.

Let F be callback floor hits, W=B-F be true misses, and D be positive direct kernels. Required exact event bounds are floor intersection attempts B, triangle tests<=2B, floor evaluator calls F, disk kernels48F, and direct shadow calls D<=48F. D belongs to the existing primary direct1M/100M/50M budget, never transport. Existing transport20M/800M/300M is unchanged. No rho/power shortcut may suppress positive-kernel visibility calls if the unchanged evaluator would issue them. BVH nodes/triangle work still needs actual bounded execution or a valid conservative bound.

Preflight is a distinct preparation phase with its own cost and memory peak. Its floor-ordering domain is every center plus all four selected samples: P+4T=41,940/41,964 positions, including retained character hits. This differs from both B and the background-only control B0. It must separately count point enumeration, floor solves/tests, camera clip conversions, candidate finite checks, character-depth comparisons, positive disk kernels, mask/source/generation binding and guards. Preflight output must bind camera, snapshot, mask, floor, lights/material and scene generation; replaying a stale count is not admission. Source near/far/origin and exact rounded inverse basis remain prerequisites owned by the camera audit. No numeric floor/evaluator stage reservation or admission certificate is claimed before that resolver/preflight design is frozen.

## Owned-memory and stack proposal, not measured ABI admission

Retain the original owned snapshot, visibility scene and transport scene; never duplicate or rebuild a larger BVH. Retain its existing geometry binding when constructing background data. A concrete 64-bit-layout candidate is:

- Immutable descriptor448B: native camera9float+version40B; inverse basis72B; target/origin/direction72B; clip/axial values24B; four floor vertices96B+6indices/padding8B; source rho/Le48B; seven generation/fingerprint tokens56B; retained vis_binding32B.
- Optional owned zero-world `FoxDiskScene`408B, prepared once from the pinned full light scene. This permits the unchanged evaluator to give direct-only floor RGB for independent component reporting, without a full scene copy per pixel or subtractive cancellation. Full original world radiance remains accessible through the immutable light argument. Prepared zero-world scene must be validated/pinned to the original light fingerprint; this is not a new illumination setting.
- Mutable callback context248B: five8-byte pointers (descriptor, direct budget, background ledger, optional observer/context), fourteen64-bit counters and four RGB component-sum triples.
- Proposed32-category separate background ledger/report536B: two32xuint64 arrays, totals and status. If the frozen resolver requires more categories, increase this proposal visibly before admission.

This proposal adds1640 owned bytes, giving147,144 bytes if the new call chain can be proven inside the existing8192-byte stack reserve. That leaves312 bytes, so there is no room for casual hidden arrays. An additional conservative512-byte stack allowance instead gives147,656, exceeding the old147,456 cap by200. Neither case is a measured acceptance: final `sizeof`, overlap spans, compiler call-chain stack report and full ownership peak must be checked after implementation authorization. Generic user observers have separately reported diagnostic state/stack; their memory must never be called product fit. A second4050-byte mask, duplicated lights beyond the408B above, retained temporary camera inputs or a full-frame HDR array would invalidate this proposal.

## Required lifecycle, failure and equivalence fixtures

- NULL callback direct-dispatch reproduces frozen A2 all20 RGB/depth/snapshot/target/counter outputs exactly.
- Black/no-floor callback matches prior output with non-NULL background accounting. rho0 alone is not a black fixture when Le/world remain.
- One and three nohit samples: returned HDR enters the four denominator, including values above1; no early clamp or divide by hits. Covered sample fields and character depth remain exact.
- Non-target covered pixels unchanged; non-target misses resolved exactly once; selected center misses never double-resolved. World/floor radiance never sets character hit/source/depth/coverage.
- Callback false after partial local write; success with NaN/Inf/negative; accumulator overflow; individual new ledger exhaustion; shared direct ray/node/triangle exhaustion. No completed publication or quality manifest after failure.
- Caller descriptor/camera/material inputs poisoned/freed after owned binding. Retained old scene/descriptor replay after a new scene is installed must still use its original lights/floor/camera/generations.
- Reject mismatched camera/light/material/floor/snapshot/mask/generation, descriptor mutation, stale preflight and incorrect preflight expected domain counts.
- Size-aware context overlap with workspace/RGB/depth/snapshot/identity/descriptor/budgets/scene allocations rejects before writes. Avoid the old one-byte-only opaque-context test for this new API. Test observer/context span aliases separately.
- Finite floor/sky classification: negative ray parameter, clip-before/after, outside finite triangles, exact parallel, exact tangent; nonfinite/near-parallel overflow fails rather than falling back to world. Shared floor diagonal has a deterministic no-crack rule.
- Preflight any floor-in-front result stops background-only equivalence; exact ties must be reported and resolved explicitly, never with an invented epsilon. Comparison precision must be the audited common native depth convention.
- Background-only control: fixed-mask digest matches combined A2, camera character shaders remain zero, shadow BVH retains character, and every one of39,555/39,573 control points completes or the entire control is incomplete.
