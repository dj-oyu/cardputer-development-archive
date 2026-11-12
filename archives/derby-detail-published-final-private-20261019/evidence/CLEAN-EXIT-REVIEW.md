# Clean-exit fix — independent final review

Reviewed UTC: 2026-10-19T21:43:07.540079+00:00

**Result: no unresolved major finding in the final reviewed source.** This is a source/host/retained-toolchain review, not a device PASS or exact new firmware link. No repository change, remote operation, hardware, USB or MCP operation was performed by this reviewer.

| Variant | Exact local candidate | Tree |
|---|---|---|
| baseline | `64a13d3eda0b205cd560f4791c8211b2c458de01` | `fe90d7e2e78e680423f40131830071af99944225` |
| native | `2b82842efd6762130a920600f3fb7f67aa57fd9a` | `6648060e994f1f240a15db8a1f7e8fae1286bbf8` |
| batch | `8b4923614bc0d57909fcc32e225997de1cce628b` | `020c8b038f7876adc458715f18552e065acc1dbc` |

All three checkouts were clean and all 12 files of this follow-up are SHA256-identical across variants. `CLEAN-EXIT/final-heads.json` retains each hash. The target-compiled C hashes match these candidates; the compiler run preceded their local commit, so source hashes rather than its recorded previous HEADs provide the final binding.

## Acceptance behavior reviewed

- Detail ON alone exposes a narrow completion predicate: live guest, fixture DONE, exit request, no parked frame/jobs, and no existing stop request. Owner completion additionally requires the current app_tick result to be ESP_OK. The optional release tick is skipped only for completed diagnostics.
- Continuation dispatch/errors are evaluated before completion. Pending work is drained; an unsuccessful continuation or existing runaway outcome reaches the ordinary error teardown. At the completed boundary app_tick returns to the owner without starting the legacy extra interrupting frame. Back and externally requested stop do not take the successful completion path.
- The owner checks the **actual existing interrupt predicate**, including last armed turn deadline, immediately before accepting completion. A successful VM return at 250001 us ends in ESP_ERR_TIMEOUT without EXIT; it is not deferred to a turn that could rearm the clock. This addresses the late-native-return/preemption gap in e==ESP_OK alone.
- Only then can native owner code emit `DERBY_DETAIL_EXIT v=1 session=<same session> clean=1`. Its C helper requires DONE, three reported repetitions, zero trial quality, no prior attempt, monotonic clock and 250 ms reserve before the 180 s session limit. A refused/partial attempt cannot be retried into success. Write failure takes the error teardown.
- EXIT is outside the live JS stack and measured window. Final END and EXIT can share an owner tick: two bounded writes allow up to 220 ms under the host's 110 ms-per-write model, plus other owner work/preemption. The normal frame watchdog remains installed; the extra owner write is bounded separately and does not establish a hard 250 ms bound for the entire owner tick. No performance or pure-transfer claim follows from this test.
- Existing end_run/app_stop teardown is reused: stop hooks and cancellation/resource ordering remain intact, APP_STOPPED precedes HOME_READY, and a successful diagnostic does not set the home execution-failure indicator. The app-stop internals are unchanged.

## Strict parser and repaired review findings

The parser still rejects every InternalError and the other complete-stream fatal patterns, including faults after END/HOME. It now rejects actual synchronous `hook threw:` as well as asynchronous rejection and stop-hook timeout. Correct tag/full payload IDF markers and bare host markers are recognized; arbitrary text cannot prove stop/home.

A single exact owner EXIT is mandatory for detail ON, bound to the same session and positioned END < EXIT < STOP < HOME. This prevents a genuine failing final guest turn, including a non-InternalError exception, from qualifying merely because it emitted END first. Missing, duplicate, wrong identity, unclean or reordered EXIT is rejected. Detail OFF emits no new record and retains its previous fixture bytes.

Two findings caught during this review were fixed before these final candidates: synchronous hook-threw was initially omitted from the fatal regex; and an initial EXIT-order check reused a variable that the per-repetition detail trailer had shadowed. The final parser uses fixed_end_lines, and its SHA256 is `9064850a370d1111f553368828c0c1698b2f1ff34579819f135a91710efd961e`.

## Independent validation

- **18 actual Xtensa syntax checks and six actual object builds passed**: main.c, app_session.c and derby_fixed_workload.c, three variants, detail ON/OFF. Uses retained GCC15.2 / IDF6.0.1 config/includes, not a new complete target build. Command vectors, object hashes, .su/.nm evidence and reproducible helper are under CLEAN-EXIT.
- The three changed production C files have identical OFF preprocessor bodies against previous baseline `90b9f686...` after standardizing only diagnostic __LINE__/__FILE__ constants. This is not a claim of complete object byte identity. No additional static-data difference appeared in these objects beyond the existing controller snapshot (752-byte ON/OFF difference); the new completion queries use 32 bytes each and EXIT helper 160 bytes in retained compiler stack reports. These are compiler frame sizes, not whole-call-chain or runtime high-water measurements.
- Actual production dispatch/app_tick/owner tick_run/end_run extracted host tests passed ASan/UBSan and O2: normal final return, release guard, pending drain, final frame and continuation failure, runaway, forced stop, Back, EXIT refusal and late successful frame/continuation returns. Real interrupt() is extracted too. Guest/presenter ports, arm_turn budget machinery and app_stop internals remain modeled/stubbed; this does not replace a live lifecycle test.
- **Independent baseline detail-ON ASan/UBSan real QuickJS/controller/renderer fixture passed** all three dependent repetitions, new native EXIT and strict parser, collector contract, bounded-tail/startup failures and known work/render hashes. Each repetition retains 120 contexts, 4,975 draws, input hash `986b2e6e027af00d`, procedural pixel hash `c1b0fdbde748d0de`, panel hash `cec4b765a2794b14`. Host timings are not device performance.
- Latest accounting/output/parser tests passed, including **38 negative cases**. Six additional repo-external parser cases reject EXIT before END, after STOP, after HOME, wrong session, hook-threw and late InternalError. No device bytes were sanitized into accepted evidence.
- ON/OFF/ON regeneration and exact comparison-base OFF JS plus five production C O0 OFF .text preservation tests independently passed in all three variants. The parent completed all six new O2 ON/OFF fixtures; this reviewer independently reran each saved strict quality/identity/detail verification and read comparison.json (all three semantic_equal=true). These are dependent host runs, not device speed/overhead or new-head CI. HOST-TEST-MANIFEST.json records each result/raw digest.

## Prior trial and remaining work

The original baseline raw capture remains unchanged and failed: SHA256 `c25c11fc9a04e73a430291d202f00fceca3e94748976ec37a5604e9e4d66b3d5`, still rejected for the runtime fault. Its old END/coarse validity is not upgraded. See BASELINE-DEVICE-BLOCKER.md.

Remaining acceptance is pending, not denied: exact new-head target CI/link/mode proof and separately authorized device validation are not performed here. There is no native/batch detailed hardware result or overhead conclusion. The parent's source-cache scan-limit blocker is external to this source review; no source fetch or flash was attempted here. Preserve raw/receipt/objects/commands privately, not in public PR content.

## Publication and source-cache blockers (parent reported)

The first three GitHub blobs (docs, app_session.c, app_session.h) were created, then automatic approval review **denied create_blob for main/main.c** while applying the initial no-publication restriction despite the parent's reported later new-head/CI authorization. No branch/ref update or new-head CI occurred. This action remains denied; neither parent nor reviewer retried it. Local candidates, compiler objects and host results are complete and preserved. Resolve the authorization blocker explicitly rather than changing routes to bypass it.

Separately, the parent reports physical source cache 14/16 entries, 1,208,131,635 bytes and source_cache_scan_limit. Resolution is pending with the parent; no new fetch/flash is authorized or performed here. This does not prevent the completed local review.
