# DERBY detailed clean-exit wire contract for MCP maintainer

Published source heads: baseline9b9e9ae46c08a6597f871419b280874d5e09033c, native0e3a457f0bd1897ff147954104735a20b7735e52, batchefb9aa4ee71970ded23c80f8a4bc3eb375ea84fb. No target/source/flash acceptance yet. Source of truth: main/main.c end_derby_detail_run; main/app_session.c app_derby_detail_finished/app_derby_detail_deadline_ok/app_tick; main/pocket/derby_fixed_workload.c df_detail_exit_record; tools/games/derby_detail_result.py; tools/test_derby_detail.py.

For detail ON, one boot/session with three dependent replays: for each rep1..3, 26 DERBY_DETAIL stage records, 13 DERBY_DETAIL_BYTES event records, one DERBY_DETAIL_END, then its DERBY_FIXED summary. After rep3:

```text
DERBY_FIXED_END v=1 session=N reps=3 valid=1 quality=0 independent=0
DERBY_DETAIL_EXIT v=1 session=N clean=1
I (<decimal timestamp>) app: APP_STOPPED
I (<decimal timestamp>) shell: HOME_READY
```

These are full exact logical lines with LF, not substring tokens. Extra unrelated diagnostic lines may appear between them and must remain available for fatal-error inspection. Native lifecycle tags must be app/shell respectively, severity I, decimal timestamp, exact payload, optional ANSI SGR. Bare APP_STOPPED/HOME_READY is accepted for host fixtures. Detail OFF has no DERBY_DETAIL* records and keeps the previous fixed fixture contract.

EXIT means normal guest/owner completion, not successful teardown or physical LCD proof. Owner requires successful last app_tick, live guest, fixture DONE, exit requested, no parked frame/pending jobs and no forced-stop request. Continuations/finally/jobs finish first. Before accepting, check the actual installed stop/deadline interrupt predicate against the last armed250ms deadline without rearm. Late successful VM return must immediately take timeout teardown, never become successful on the next tick. Only then native owner emits EXIT once. Controller additionally requires three reported reps, trial_quality0, DONE, no prior write attempt, monotonic clock and250ms reserve before180s session deadline. Failed/refused/partial write is not retried. EXIT is outside the live JS stack and measured window. END and EXIT can share an owner tick; two110ms modeled writes plus other owner work do not prove a hard250ms whole-owner-tick bound. Existing stop-hook/cancellation/teardown then emits STOP, existing owner emits HOME.

Failure behavior:
- Before final END, controller failure may emit END valid0/nonzero quality/fewer reps. Missing/truncated/refused output is invalid; never discard an invalid rep.
- Final guest/continuation error after a valid END, or owner deadline failure, emits no qualifying EXIT and takes existing error teardown. STOP/HOME may still appear; they do not convert it to success.
- EXIT reserve/one-shot/write failure takes error teardown; a missing or partial EXIT is invalid.
- A stop hook can fail after successful EXIT. Reject hook threw:, hook rejected:, stop hook did not finish, all InternalError, RUNAWAY/LOADSTALL/watchdog/assert/OOM/etc anywhere in complete captured transport, including after END/EXIT/HOME. Do not whitelist interrupted exceptions based on END or EXIT.
- Require one same-session/version clean1 EXIT, END<EXIT<STOP<HOME, one STOP/HOME each. Reject wrong tag/severity/full payload, duplicates, missing markers, unknown/malformed detail fields, schema/order/identity/count/accounting/work differences. Current parser has38 negative cases plus independent mutations. Keep raw bytes/receipt SHA unchanged; normalization is a recognized marker input view only.

Observed coarse/strict mismatch:
- Job derby-detail-baseline-fixed-90b9f686-20261019, finished2026-10-19 21:27:33UTC; old source90b9f686e7c6897bc53e26e3b82fbe5569b968fd.
- Broker result succeeded/derby_fixed_trial_verified and fixed_trial.valid=true using pinned coarse parser4d60de5e82193975596bc23981d3189e2e6bf78d.
- Complete31098B/88954ms transport; raw SHA256 c25c11fc9a04e73a430291d202f00fceca3e94748976ec37a5604e9e4d66b3d5. Three summaries advertisedvalid1/quality0; END line236, InternalError: interrupted line238, STOP246, HOME247. User physically saw APP ERROR→HOME. No EXIT exists in that old image.
- Strict detailed parser rejected the unchanged raw stream for runtime fault. The old coarse parser ignores detail/lifecycle fault semantics, so its narrower validity must not be reported as clean detailed acceptance. A source/stack-supported explanation is legacy app.exit deliberate interrupt, but the same exception can be watchdog; reason is not encoded in the old capture. Never retrospectively accept it.

MCP recommendations: expose separate transport/coarse/detail/runtime-completion gates, preserve the fatal reason and source/parser versions, distinguish recognized device failure from collection/transport uncertainty, and retain source/build/verified-flash binding separately from boot text or configured_expected_hash. Do not drop errors to satisfy success. Physical LCD and pure-transfer claims are outside this wire protocol. Current source/flash hold remains; this note authorizes no broker/registration/hardware change.

Proof-only follow-up heads: baseline37af4225ad329aac4c5e79c880d7d69760b770be, native92e70b7fbb2c15d99734a518096dffdf046d2ae3, batchea64b0ec9c176f852c853cb10142581ee527d7fc. Only2 build-verifier Python files differ; runtime/wire unchanged. Detail expectation must be bound to the verified build mode, not inferred as OFF when detail rows happen to be missing. Unknown/missing detail in an expected-ON build must fail. NewheadCI is in progress, no newdeviceacceptance.
