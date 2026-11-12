# Pre-render gate result

Status: implementation and synthetic gate tests PASS; full all10 capture NOT STARTED. Independent review and explicit render admission remain pending.

## Immutable baseline and isolated edit

The baseline is the completed floor-direct ON renderer in floor-display-combination/capture-001 with its completed floor-ON/background/display outputs, verified against recorded hashes. New world OFF is not old floor OFF. Original visibility, lighting, geometry, model, camera, source rho, AA ledgers and inputs are unmodified. No stopped/unverified context code was read or used.

The new terminal path is rho_receiver * rho_floor * source Lworld * visible fraction / outer16. Sixteen existing cosine directions leave the primary floor hit using the same floor-normal orientation and unchanged nearest-ray epsilon, bound, intersection, side and budget API. Blockers return zero; Le and direct-floor paths are untouched. The result component and new visibility counts are separate. Existing bounce_result (256B), counters (112B), scene layout and owned/binding API are unchanged.

## Executed tests

- tests/run.sh: O2 and ASan+UBSan pass. New 24 combinations cover upper/lower receiver sides, reversed winding, open/fully blocked hemisphere, zero world and zero floor rho. Unblocked values equal rho_receiver*rho_floor*Lworld, blocked values are zero, world doubling doubles the new component exactly, and every previous component/counter remains exact.
- New failures: finite input, fixed16 rejection, generation mismatch, output/work alias, per-shader/per-hit semantic limit, empty hit reservation, shared ray/node/triangle exhaustion, and attempts to expand original visibility caps. Failure leaves both output structures unchanged; consumed prepaid work and visibility charges remain recorded.
- Original completed floor, pixel, bounce, quadrature, ground and visibility tests pass. Existing nearest-ray epsilon/far/edge/tie/invalid tests and independent 1000-ray/1000-segment brute-force checks pass. No visibility implementation was changed.
- tests/parity.sh: actual synthetic boundary-AA raster compiled once against the completed renderer and once against the candidate OFF. Exact combined file comparison includes RGB565, depth, center HDR, quarter HDR, old bounce counters/result, direct/transport budgets and old floor-work ledger. Both SHA256 ebedf5d8c8f4346edea6cfef32ce5f02e953c4817a543bd35ac7906a6533e05c. 16 center commits and 1008 primary floor hits exercised.
- Same synthetic raster with new world ON passed O2 and ASan+UBSan; separately captured center component equals the expected floor-world value at every covered center, all new queries are accounted, and center observer updates equal old center commits.

Test preparation failures were corrected, not treated as passes: direct-budget fixture initially used the transport cap, and a triangle-exhaustion fixture initially traced a clear root; a pre-existing white-box visibility test was incorrectly linked twice. Link failure log is retained. LeakSanitizer cannot run under this environment's ptrace, as recorded in lsan-environment-failure.log; ASan+UBSan passed with detect_leaks=0. This is not a leak-sanitizer pass. Existing visibility allocation-failure/live-allocation tests pass.

## Work and memory

No original cap increased: transport20M/800M/300M; direct1M/100M/50M. New world rays charge the same transport ledger. Old counters exclude the new path by design and remain exact; new per-path visibility charges explain the total budget delta. New semantic reservations are 64 per shader and 6272 per eligible floor hit, maximum450598848 under the old frozen17241/71667 bounds. These host diagnostic units are not old8M admission or machine instructions.

Measured context576->608B (+32), separate world work104B, separate local component24B; no scene/geometry heap increase. Diagnostic center component array adds777600B plus8B pointer and8B counter, separate from runtime/core memory. Measured stack: bounce_eval_impl1344->1440 (+96); shade432->480 (+48); native main81792->81904 (+112); boundary raster1696 unchanged. The new helper is inlined at O2. STACK_RESOURCES.json records all translation-unit stack data and binary sections. No firmware-fit claim.

## Next stage, only after independent admission

Frozen all10 OFF followed by all10 ON, fixed front/oblique and baseline/direction/intensity/ambient/albedo. OFF verifies exact old numerical outputs and counters; only truthful context-size metadata differs. ON requires identical old components/counters and shared-budget delta exactly equal to the distinct new-path counts. Both complete before formal scoring. Original background events and proof, fixed two front floor overrides, original quarter masks and fixed profiles are reused. The raw new component is composed only at KEEP samples, so camera floor/world background is not double-counted. Failure aborts without a completion manifest. No threshold/model/reference/profile/sample-count changes.
