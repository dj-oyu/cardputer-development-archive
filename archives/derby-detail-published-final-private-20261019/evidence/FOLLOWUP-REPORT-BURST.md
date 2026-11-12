# Follow-up finding: synchronous detailed-report burst

Result: **P1 unresolved on the three reviewed published heads.** This follow-up supersedes the earlier no-major-finding conclusion. Source identity/coherence and previous compiler evidence remain valid.

## Evidence

- `main/pocket/derby_fixed_workload.c:60-75` emits 26 stage records, 13 event records and one detail END in one native call: 40 `df_write` calls.
- `report():77-104` then writes the coarse summary and, on repetition 3, writes the final END before returning: 41 calls for repetitions 1/2; 42 for repetition 3.
- `main/pocket/derby_fixed_workload_device.c` maps each `df_write` to `usb_console_frame`.
- `main/hal/usb_console.c:14-18,35-67` starts a fresh 50 ms budget on each call. The documented IDF driver mutex/ring waits make the contract at most 100 ms plus tick rounding per call. A sequence of slow successful writes can therefore occupy about 4.1/4.2 seconds plus rounding/formatting. It is bounded in count, but it does not preserve a 250 ms guest-turn bound.
- `main/main.c:1408` configures a 1,024-byte TX ring. One repetition's report exceeds that ring; normal low-latency host drain may be fast enough, but no measured device bound or source guarantee establishes less than 250 ms for the burst.
- `main/app_session.c:654-656,685-687` enforces the 250 ms watchdog through the QuickJS interrupt predicate. `components/quickjs-ng/quickjs-ng/quickjs.c:9774-9827` polls it in interpreter execution. `yield_alarm` only requests a VM yield; neither mechanism preempts this C I/O loop.

## Failure and qualification implications

A refused write follows `DF_OUTPUT -> DF_ABORT` and emits an invalid END attempt. It has no retry loop, so write refusal does not create unbounded waiting and the ordinary loss/schema gate rejects incomplete output.

Slow successful writes are different: there is no report-wide deadline check or owner-turn return between them. After repetition 3, `report` has already set `DF_DONE` and emitted valid END before the guest regains control. A later watchdog/FRAME RUNAWAY can therefore occur after terminal success was published; `df_fail` ignores `DF_DONE`. This is a static code-path concern, not a reproduced device watchdog result.

The parser/collector does not independently close that gap. A read-only mutation of a retained actual host log inserted `InternalError: interrupted` and a generic RUNAWAY error after valid END and before STOP. `parse_detail` still returned all 3 repetitions and the memory collector accepted its 6 positive framing cases (32 existing negatives still rejected). See `report-burst-parser-observation.json`. This demonstrates acceptance of general errors after valid END; it does not reproduce the transport slowdown or actual watchdog behavior.

## Required acceptance work

Before claiming the 250 ms turn contract, bound output across owner turns or through a shared deadline covering the report, failure END handling and terminal-success commit. A bounded owner-side report pump outside the guest-native call is a robust option; merely retaining individual per-write timeouts is insufficient. Preserve the measured fixture, snapshot values, output order and strict loss rejection.

Add a slow-success transport/clock regression, an output-refusal regression, and a final-repetition delayed-output case proving no valid END is accepted after a turn-budget failure. Normal host-throughput success alone does not cover this case.

No repository edit, source/build job, USB, MCP or remote action was performed in this follow-up.
