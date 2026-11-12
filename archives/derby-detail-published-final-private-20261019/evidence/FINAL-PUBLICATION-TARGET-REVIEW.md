# Final publication and target proof — independent review

Reviewed UTC: 2026-10-19T22:11:33.293498+00:00

**PASS for exact-source publication binding and all six retained target-link/mode-proof receipts.** No unresolved source/binding finding. This is not overall CI completion or device acceptance.

| Variant | Final public/local exact head | Unchanged reviewed tree | Target jobs OFF / ON |
|---|---|---|---|
| baseline | `37af4225ad329aac4c5e79c880d7d69760b770be` | `7753c5c8919ee36c24080ce08102438a285da6f2` | 118332337448 / 118332337203 |
| native | `92e70b7fbb2c15d99734a518096dffdf046d2ae3` | `24f0575743c7de7d4873c531221db6e1fcf1f14f` | 118332357934 / 118332357592 |
| batch | `ea64b0ec9c176f852c853cb10142581ee527d7fc` | `63bf0b2ee03168230de588f2a038e3e694b1d4d4` | 118332382898 / 118332383109 |

All three local feature checkouts are clean; complete trees equal the reviewed proof-repair candidates c90ee61b / 3d861298 / 826c74a1. The two Python repair hashes also match the prior independent review.

Each retained log hash matches FINAL-CI-TARGET-RECEIPTS.json. Independently parsed raw logs contain an actual ELF link and successful project build, followed by the same record_verification, mandatory diagnostic proof and resource JSON recorded in the receipt. Source commit/tree/project version, IDF6.0.1, telemetry and coarse-measure ON, fixed workload identity, paired BIN/ELF hashes, embedded play/view checks and fixed hardware-seed proof all agree.

The repaired exact boundary rule is satisfied in both record_verification and mandatory proof: **df_detail_exit_record is required and present in each detail-ON ELF, absent in each OFF ELF**. Required dd_ boundaries are present ON and all dd_ symbols absent OFF; unknown df_ boundaries are still rejected. These are checks of actual-target build proof emitted by the CI tools, not the earlier synthetic-only tests. BIN/ELF files were not independently downloaded and rehashed locally; this review binds their recorded hashes to the retained CI logs and exact source.

Resource evidence is limited correctly: actual linked dd_ static state is **2,304 bytes ON / zero OFF**. This is not the entire detailed-memory increase: the fixed-controller snapshot and other state are outside that dd_ sum. The maximum among nine collected translation units is **2,992 bytes per function** (mark_fused), both ON and OFF; the EXIT helper is 160 bytes ON. Compiler frame sizes do not establish whole call-chain stack, owner main.c stack coverage, ISR nesting, runtime heap/stack high-water or memory headroom. No new target timing/overhead conclusion follows.

The parent reports overall CI 25/29 successful with four normal/stage-accounting/m32 host jobs still running at this handoff. This review does not upgrade pending checks to PASS. Prior proof-failed CI runs remain historical FAIL; these six new exact-head target proof jobs supersede only the previously missing target-link/mode-proof validation.

The old baseline hardware capture remains unchanged **FAIL**. Source/flash remain on hold for the parent's cache preflight/authorization resolution. No test repetition, repository edit, target rebuild, new source retrieval, MCP, USB or hardware action was performed. Structured source/log/artifact bindings: FINAL-PUBLICATION-TARGET-REVIEW.json. Raw logs and detailed artifact receipts remain private.
