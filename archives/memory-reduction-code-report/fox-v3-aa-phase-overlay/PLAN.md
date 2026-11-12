# AA phase overlay

Completed baseline: fox-v3-segmented-model-arena. Private new root only. Move the 4800-byte center ID ring into an anonymous center-phase struct after the unchanged 5760-byte delayed HDR row in the existing 13440-byte winner union. This opt-in bounded workspace changes ABI and all consumers are recompiled. Legacy generic AA and model APIs remain unchanged. No arithmetic, eight-row order, callback, representation, packing, guard or budget changes.

Lifetime proof: fox-v3-aa-storage-audit/LIFETIME.md. Both center loops consume all center IDs and finish delayed HDR before any quarter winner initialization. Delayed HDR and center IDs do not overlap each other. Quarter geometry initializes all active winner arrays. One complete workspace ownership span remains, so no new admission pairs.

Synthetic gates: legacy O0/O2 with ASan/UBSan; producer, contiguous ring and depth bands exact output/order/report tests, ring wraps, delayed rows7/15, tail7, maximum accepted ID91, forward/reverse, poisoned then unpoisoned repeat; shader/profile/resolver first/middle/final failure and admission nonmutation; adapter late finish/prefix protection; integration and segmented model regressions. Depth-band oracle comparison permits only its existing admission charge120→210, everything else exact. LSAN disabled under ptrace, not a leak-clean claim.

Build observer and product separately, measure stack/text/heap, verify baseline unchanged and freeze sources. Parent and independent reviewer gates are mandatory before any actual run. Fixed40 actual target: completed baseline OFF20 then ON20, canary first in each arm, identical same-arm/order five raw formats/material/snapshot/physical counters. The only permitted non-timing report delta is .aa.json workspaceBytes77312→72512. No stale model-size exception. Actual runner remains run_segmented_model_actual.py with new root/base and gate AA_PHASE_OVERLAY_FIXED40_APPROVED.

Core RGB/depth are private scratch and can mutate before late failure. Bridge finish and native postchecks precede final pixel/depth publication; private attempt/completion markers protect external acceptance, not atomic multi-file publication. Preserve existing failure behavior and do not reclaim output scratch.

Expected saving4800 bytes workspace/global named render peak if stacks unchanged. No target/device-fit or speedup claim. No source geometry/reference/model/profile, SDK, device, public or PR changes. Baseline untouched and no rejected owned-context/paged-BVH input used.
