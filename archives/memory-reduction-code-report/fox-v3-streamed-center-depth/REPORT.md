# Streamed center depth: pre-actual implementation

Private opt-in code is based only on completed fox-v3-cached-profile-renderer. All162 baseline frozen files reverified; old exported full-depth APIs and their complete function bodies remain unchanged. This is pre-actual evidence, not fixed40/42 acceptance or device fit.

## Storage and lifetime

New center storage is exactly7680-byte eight-row strip plus960-byte pending row, total8640 instead of129600. Full private RGB64800, AA workspace72512 and caller profile cache3224 remain. Sixteen pending copies add3840float elements/15360bytes per frame; no reinterpretation of old HDR copying counters. The last row of each non-final strip is copied after its HDR copy, then read after the next center strip computes neighboring IDs. Rows0..134 and all boundary rows retain existing shader/composition/profile order. Quarter winner depth remains independent. Diagnostic capture copies each completed strip once,32400floats/129600bytes in17copies.

KsnStreamDepth's48-byte host descriptor is frozen before callbacks. Its strip/pending/capture and separate24-byte work report are disjoint admitted spans. All remain live synchronously; callbacks may not free/reallocate admitted memory. Optional capture is NULL/0 or exact129600bytes. The private core retains cached baseline trust boundary: adapter admits cache and static encoded profile asset. Old full-depth APIs have not silently lost retention guarantees.

No callback sink was added: optional capture is direct private memcpy, so it has no opaque sink failure mechanism. Allocation rollback and final file-write failures still prevent accepted output. Core scratch/RGB/capture may be partial on failure. Existing source verification, background finish and post-render checks remain. Diagnostics can exist after failure; files are not a multi-file atomic transaction. New suffix is included in fresh-prefix checks, and capture output is absent when disabled.

## Host accounting

Product main83760 (baseline83792), renderer named chain4944 (5008), background4016/4096 (4080). Named render373552, construction442964, overall named peak442964 vs494608, decrease51644. Gross depth saving120960 is render-only, not whole-runtime savings. Largest product requested allocation remains72512. Descriptor/report are already within measured frames, not counted twice. Model/cold/build storage ends before render; cache is allocated late. Memory exclusions and lack of target placement/runtime watermark remain explicit.

Observer main83776 and the same child peaks. Full diagnostics peak1280792 includes additional depth129600, HDR777600, global control24 and observer frame delta16. No-depthcapture canaries still retain HDR diagnostics and peak1151192. Neither diagnostic RSS is product memory. Pure no-HDR product is separately built/measured. Old raw profile data remains replaced by unchanged445248-byte encoded singleton; this task claims no further LUT saving.

## Work and validation

All original caps stay unchanged. New pending/capture fixed limits3840/32400 are float elements. Combined producer work includes these and must remain <=637599. New copy guard increments are16 in production and33 with capture. Core admission170/189; adapter351/378 OFF and378/406 ON. Total admission521/548 production,567/595 diagnostic, below1024. Other semantic counters remain unchanged by design and require exact replay validation.

Synthetic/legacy/adapter/sanitizer outcomes are recorded in PREREQUISITE_REPORT.json and independent review artifacts. LeakSanitizer cannot operate under this environment's ptrace; the initial failed invocation is retained and ASan/UBSan rerun with leak checking disabled, as previous validated work. No general leak-clean claim.

Only comparison/run_fixed40.py is the approved pending42-condition route:40full-depth diagnostic frames plus2no-depthcapture front-baseline OFF/ON canaries using the same HDR-observer binary. No actual frames may run until independent review, source/comparison freeze and explicit execution gate. Earlier copied actual runner scripts are historical references, not execution routes. No device, SDK, firmware, public repository, PR, physical quality/profile/model/reference change, rejected owned-context or paged-BVH dependency.
