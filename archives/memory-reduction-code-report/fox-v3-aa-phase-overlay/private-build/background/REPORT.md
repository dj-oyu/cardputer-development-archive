# Private camera-background module, synthetic verification

This module is a separate explicit host experiment in the new root. No actual physical frame, shadow traversal over actual source geometry, image/reference comparison, public/model/device change, or original-root edit was performed by this implementation task. The original direct1M and AA8M failures remain failures of those original budgets. Background shadows use their separately approved2M/200M/100M budget; transport and original character budgets remain unchanged.

## API and ownership

`background.h` owns the input/scene/work/context/result contracts. `fox_bg_scene_build` copies752B input, prepares exact native Q32/t32 and its inverse, and retains the existing BVH. The976B scene owns all camera/floor/rho/Le/illumination values. Native camera and source axial clip remain distinct. Illumination has an independent generation token; old `vis_generation.light` is not modified. Field-group changes require their corresponding generation; all tokens nonzero/monotonic. Identity fingerprint changes require a geometry/pose change, and snapshot changes require a relevant scene/material/illumination/camera token, not merely an emission-token change.

`fox_bg_context_begin` validates snapshot/identity byte fingerprints and all51 prepared lighting doubles once. Snapshot/identity/input buffers may subsequently be destroyed; the work and dedicated shadow-budget controls remain live caller-owned controls. The new background budget starts at zero and is cumulative. `fox_bg_compose` adapts the full private result to the core24B query/40B result. It does not allocate a redundant208B wrapper result: `ctx.last_result` receives the complete successful private result. Both public APIs have failure-atomic outputs. Accepted work and traversal consumption are not rolled back. KEEP RGB is zero; missing character depth and SCENE_MISS floor depth are canonical positive zero; other sample tags/modes reject.

`fox_bg_context_finish` is the frame-end gate prepaid at frame entry: exact Q completion, KEEP+FLOOR+WORLD=Q, WORLD miss-reason sum, successful evaluator/world counts equal the work ledger, positive queries equal consumed shadow rays, and valid current generations/limits. Failed/partial work cannot pass this gate. No image rollback is promised by the surrounding renderer; failed private partial frames must not be published.

Two finite-floor triangles use the exact existing geometry preflight convention, inclusive boundaries and first-ordinal equal-distance tie. Floor depths are exact float32 native projections; no epsilon-based precedence. Only floor selected in final slots receives DISK16 direct + rho*source_world + Le, with Le once. A true camera floor miss receives source world radiance. Character geometry remains in the retained shadow BVH. The unchanged segment uses its existing1e-5 endpoint exclusion, no normal offset; emitting-disk admission separately keeps1e-9.

## Fixed accounting

V5 rates and hard cap are unchanged: per slot2048, selected floor36736, world miss64, one construction8192, frame4096+8*(snapshot+identity bytes), global1,540,298,112. All15 category caps and total/count caps are checked before atomic reservation. Per-case category/total bounds use actual Q/shading bounds; global41,964 geometry-slot reservation is conservative and is not runtime permission to shade discarded target centers. Runtime Q never exceeds39,573. The shared cap proof substitutes64 for36736 on a world miss, enforcing FLOOR+WORLD<=shade_bound. All48 kernel/callback allowances are prepaid even if an evaluator later fails early; these are billed reservations, not a false claim that early-failure code executed all48 kernels.

The core-integration fixed cap1,680,000 remains separate; combined new-host cap1,541,978,112. Fees are named source-semantic reservations, not measured CPU instructions. Fixed guard validation is performed once at public admission; subsequent internal fee charges occur only before any external callback and use the already validated ledger.

Queries alone fit:39573*48=1,899,504<2M. Node and triangle caps are abort gates, not proven actual-frame fits. Actual BVH traversal was exercised only in small synthetic fixtures here.

## Synthetic fixtures

`tests/run.sh` passes GCC14.2.0 O2 with Werror and O1 AddressSanitizer+UndefinedBehaviorSanitizer. LeakSanitizer is disabled; this report does not claim a LSan run. Tests include:

- Known analytic direct-helper equality, direct/world/Le component recomposition, Le once, finite HDR, dark source, black rho still executing48 positive queries where geometry is positive.
- Front/behind/exact depth tie; KEEP zero RGB; private/compact atomic commits; center tag and all four exact±.25 offsets.
- Shared diagonal and finite edge; reversed winding, both floor sides, tilted-plane normal/helper equality; exact parallel, negative t, outside, strict/inclusive source clip boundaries; source-vs-native camera distinction; nonfinite arithmetic.
- Occluder retention, endpoint length<=2*segment epsilon failure, emitting-disk endpoint failure, ray/node/triangle quota exhaustion and no interpretation of failure as clear.
- Poisoned/freed original descriptor/snapshot/identity/BVH handles; retained-old-generation replay after new illumination; all field-group successful replacements and stale/decreasing/zero-token rejection; retain overflow and atomic failed binding/scene/context replacement.
- Full-span/interior aliases among input/slot/context/result/scene/work/budget, canonical missing-depth negatives, invalid tags/modes/finite values.
- All15 fee-category failures, total and count failures, no partial charge on failed reservation, no refund after admitted evaluator/query failure, aggregate-counter overflow and incomplete finish rejection.

## Memory and stack

Measured host64: input752, scene976, binding64, work296, context376, private result208, query24, compact40, budget48 bytes. Resolver steady live state1696 includes all dedicated caller-owned controls once. Core binding104+ledger160+report400 adds664, giving2360 steady bytes. One old+new scene adds976; with simultaneous caller input752, construction/replacement peak4088. If the external4050-byte mask buffer is also live, conservative new-host peak8138<16384. Existing retained BVH and its possible old/new generations are separately accounted original state, not hidden in this new allocation total. No full-frame HDR allocation or canonical16KiB serialization buffer is added.

GCC O2 `.su` reports callback16 + resolver1024 + disk wrapper48 + evaluator352 + bridge80 + segment432 + box80 =2032 bytes. Core worker reports current final full-fixture composite frame1664 plus dispatch80, yielding the complete named core-to-visibility chain3776<=4096. The earlier isolated core compile measured1648; the larger final value is used. Control256+80+2032=2368. Admission-only helper frames do not overlap the callback chain. This is a named C-frame proof, excluding native adapter/main callers, compiler runtime and libm internals; those caller frames remain separately reported rather than silently included. The parent owns final bridge/whole-root integration proof. No32-bit ABI/stack claim.

## Evidence scope

`BYTE_PROOF.json` checks32 inherited physical/visibility/transport production files against frozen A2 source hashes, all identical. `SOURCE_FREEZE.json` is the formal background-module freeze fragment with root-relative production/evidence paths for merging into the whole-root freeze. The core worker owns separately changed composition files and whole-root verification. Original source and all earlier preflight/diagnostic freezes remain unchanged.
