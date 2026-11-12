# Baseline device acceptance blocker — independent review

Reviewed UTC: 2026-10-19T21:33:15.651763+00:00

**Status: NOT QUALIFIED. This trial is not a hardware PASS.** The unchanged strict detailed parser rejects the complete raw capture. Broker coarse validity establishes its narrower fixture/transport contract, not clean runtime completion or detailed acceptance. Native/batch device trials remain stopped; this review performed no device, USB, MCP, source-fetch, build or flash action and changed no repository file.

## Bound evidence

- Baseline exact source/checkout: `90b9f686e7c6897bc53e26e3b82fbe5569b968fd`; checkout was clean during review.
- Private raw: `device-baseline/trial.log`, 31,098 bytes / 249 lines, SHA256 `c25c11fc9a04e73a430291d202f00fceca3e94748976ec37a5604e9e4d66b3d5`. The bytes match decoded `fixed_trial.raw_base64` in `device-private/detail-baseline-fixed-result.json` exactly.
- Receipt: complete, 88,954 ms, no reported gaps/overflow/truncation/partial tail/disconnect/reset/refusal. Three coarse repetitions and the final coarse record report valid/quality zero. There are 78 detailed stage rows, 39 byte rows and three detailed trailers; counts alone do not qualify their values.
- Source/build proof names the exact source above; ELF SHA256 `166214130f735f298e64dc3e2143d01e645ad3c11de971a4d5f7e459f30c20d8`; app BIN SHA256 `c71e7381be4ecfed8c8afeadf2d6812de920b7668bcc8b259c55202e6e22d8c4`. Retained flash receipt reports readback/passive-boot verification. The trial receipt itself labels installed boot-source image unverified; retain the separate flash/source/build binding rather than treating boot text as cryptographic identity.

## Findings and cause

1. **P1 — clean exit and strict acceptance are incompatible on the current target.** The valid-looking whole END is line 236, the sole runtime-fault match is an interrupted InternalError at line 238, and the stop/home markers follow at lines 246/247. Calling `parse_detail(raw.decode('ascii'), expected=True)` on the untouched capture reproduces `detail runtime fault in complete transport`.

   Existing `main/pocket/pocket_app.c:638–648` explicitly describes `pocket.app.exit()` as a deferred failed-turn interrupt, not a clean exit. At the empty-queue boundary, `main/app_session.c:2358–2376` sees the exit flag, sets `stop_requested`, and still dispatches the next guest frame. The generated diagnostic requests exit after the last reporting call returns. Reconstructing the exact generated play source in memory maps its line 147 to the next frame's `GK.some(...K.pressed...)` input check, matching the private exception stack. This makes deliberate exit the strongly supported explanation; it is still an inference, not a reason recorded by the runtime.

   `interrupt()` at app_session.c:654–656 returns **stop_requested OR expired 250 ms deadline**. The exception text alone cannot distinguish these causes. An END-followed-by-InternalError whitelist would also admit a true deadline or other runtime failure after the last output, reopening the late-fault hole closed by the previous P1 fix. The final controller state also suppresses later `df_fail()` updates, so a valid END is not a substitute for clean whole-stream completion. `pocket_app_reset()` can rewrite the displayed error to APP EXITED; that UI string is not proof of a fault-free turn.

2. **P1 — target lifecycle markers do not match parser input grammar.** The actual stop and home lines have the IDF envelope with tags `app` and `shell`. The detailed parser at tools/games/derby_detail_result.py:15–19 requires exact bare `APP_STOPPED` / `HOME_READY`; both bare counts are zero in the raw capture. Fixing the exit exception alone leaves this independent rejection. The pinned broker collector observes canonical bare markers, while its receipt preserves the raw wire; the retained broker source snapshot omits serial_backend.py, so the live normalization implementation was not independently inspected here.

The host shell model emits bare markers and does not execute the real app.exit/owner lifecycle. Its passing completion tests therefore did not cover either target mismatch.

## Minimal follow-up recommendation

- Keep all current runtime-fault rejections, including failures after END and after HOME. Do not filter the existing capture into a replacement qualifying stream or retrospectively label it accepted.
- Add a **fixed-diagnostic-only** completion decision at the foreground owner boundary. After successful `app_tick()` completion, require successful final controller state/END, the diagnostic exit request, no existing forced-stop/deadline/quality failure, and no parked frame or pending guest jobs. The owner then uses existing `end_run(ESP_OK)` without entering another guest frame. Expose a narrow app-session query/latch rather than reading guest internals from main. `tick_run()` must make the decision before any optional second release tick and before the next iteration can take the legacy exit→stop→dispatch path.
- Preserve the continuation rule: jobs and finally blocks from the exiting logical turn finish first. Never replace a non-OK dispatch/continuation result, runaway, timeout, presenter failure or externally requested stop with successful completion. Do not globally change ordinary app or overlay self-exit semantics as part of this diagnostic fix.
- Retain existing `app_stop()` teardown: bounded stop hook, cancellation and reset ordering, resource destruction, then APP_STOPPED, followed by existing HOME_READY. Returning through `end_run(ESP_OK)` also avoids setting the home execution-failure indicator for a successful diagnostic. Do not call teardown from within the native reporting call or a live JS stack.
- Normalize only exact recognized lifecycle lines in a small input view: bare host form plus an anchored IDF envelope with the correct `app`/`shell` tag, optionally documented ANSI SGR. Preserve original raw bytes, receipt and digest. Avoid substring matching or arbitrary diagnostic removal; reject wrong-tag, duplicate, reordered, partial or malformed markers.
- Add host tests using the actual owner/lifecycle path or a faithful bounded harness: clean final return; exit with pending continuation/finally/jobs; final-call failure/refusal; post-END timeout/exception; forced stop and Back; stop-hook failure; successful UI exit and single STOP/HOME ordering; bare/prefixed/ANSI markers plus wrong-tag/duplicate/order negatives. Keep existing 19 fault mutations and after-END/after-HOME rejects. Apply the same guarded fix to all three variant heads and review exact new heads / CI ON/OFF target results before any separately authorized next flash.

## Remaining blocker

Detailed hardware acceptance is **pending a source fix and new validation**, not denied or uncertain execution: the baseline finite trial definitely completed collection and the present strict gate definitely failed. The precise interrupt cause is not encoded in this capture; source/stack evidence supports deliberate exit but cannot upgrade it to an accepted run. No native/batch detailed device comparison or overhead/performance conclusion is available from this review. The raw capture and private receipts remain intact.
