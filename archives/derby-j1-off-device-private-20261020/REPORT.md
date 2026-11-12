# J1 OFF: build, flash, collection and strict record gate PASS

Same-head J1 OFF build, flash and one fixed-workload collection succeeded. All three dependent repetitions have quality=0, valid=1, 120/120 contexts and finish=5DC86E18. The unmodified r2 verification function accepted the actual raw/transport/build/flash/collector chain. ON/OFF fixed fixture, work/race counters and native build-call counts match. Session release succeeded; final saved status has no active job, owner, queue or current execution/ownership uncertainty. OFF remains installed; the successful ON artifact bundle remains the recovery target.

| Mode | Work us rep 1 | Rep 2 | Rep 3 | Mean work ms |
|---|---:|---:|---:|---:|
| ON, reused accepted capture | 6767374 | 6772187 | 6771247 | 6770.269333 |
| OFF, this collection | 5355331 | 5358850 | 5352879 | 5355.686667 |

ON mean elapsed work is 26.4127226761% greater than OFF, a difference of 1414.582667 ms. This is a descriptive comparison of additional detail instrumentation, with existing telemetry, aggregate measurement and fixed workload ON in both builds. Three repetitions share one boot/session per mode and are not independent trials. Elapsed work can include preemption; it is not pure transfer time, an optimization speedup, physical LCD acceptance or proof of wire traffic savings.

## Exact chain

Repository dj-oyu/cardputer-adv-pocketjs, head b561aea1c0798feb28055a00d36681fae81ac58a, source receipt f943d8a86e72e70015040a73e1d389f09b3fda1839ae44ea361b1b8423ecb822. New explicit user approval updated the old OFF operation restriction for this exact sequence. The previously denied operation was confirmed absent. Its expired plan was prepared normally again; the one authorized retry succeeded. No new head/source registration, authorization change, MCP deployment or publication was performed.

- Build derby-j1-off-build-b561aea1-20261020: 14:11:23–14:16:34 UTC, 2026-10-20. Plan b036edfb81a512c3ec7f0852ed696a9763a98357fb8e1767ff5dff19e3e4449b. IDF6.0.1 / esp32s3 / explicit detail OFF / durable artifact_status=verified.
- Flash derby-j1-off-flash-b561aea1-20261020: 14:25:36–14:31:00 UTC. Plan f1ebd715c34990c29248f5d00613557d2da24fdb6b7b6f5147fb670fe7ac61bb. Full-segment readback and passive expected boot evidence passed. Current OFF receipt 95ae1faaddf01a4cb54b98249e578a55578b9911bfb3b0107863bb8d5d53ad0b.
- Collection derby-j1-off-fixed-b561aea1-20261020: 14:32:55–14:34:17 UTC, serial_close, derby_fixed_trial_verified. Plan 9dd08ec35da89dec184abdbce438cb9abcfc381f4988122f0c8a4bdb5711546d. Typed binding names the successful OFF flash job, full ELF/BIN, manifest, modeproof, source and receipt.
- Release succeeded. Final status at 14:36:10 UTC has no active lease/job/owner/queue or current uncertainty. Historical needs_review remains present; that history is not used as authorization or inferred current device uncertainty.

ON recovery receipt db1e10643f69ab8510dfd43df9d4649ddf26f91a03c081910cfec15f6de46a18 was revalidated before flashing and frozen in the OFF plan. It is an artifact bundle, not a full raw backup. No rollback was performed. ON was not measured again.

## Evidence

OFF BIN: 2293600 bytes, SHA256 83d8b1f110f4d0626be4784c08fe2acdb116c835aa4055ce108761ab5b7af48a. OFF ELF: 20027092 bytes, SHA256 082b86ab9c0663fb60128d47d1442056855a4a4679739c8cfc8a7e02f024e5fc.

Manifest canonical SHA256 8d49507f59454e6dc5b57901b47d867231f95a1a673e7d2750905efb0d7bf78e; actual-build modeproof canonical SHA256 a4a7f87ed5ea75ba99a857dbe2c6f9aba50707a75fadee1425cf98f97dc2ff9b. Detailed native symbols are absent; actual linked ELF/generated-view checks passed at the provider. Exact J1 verification selects detail-specific generated play/view. Expected cache/play/view hash and size differences were checked separately from invariant mode/source/work identity. Production r2 was not changed.

Raw capture: 21669 bytes, SHA256 f2aaa18f6766f0f3a858b31c0a23250afaf8ebbc9248267fe2de63d805df1278. Owner transport duration 78023 ms, complete=true; gaps, overflow, truncation, partial tail, disconnect, reset and refusal all false. OFF has no detailed records. Strict r2 verifies END, owner EXIT and STOP/HOME. This is recorded owner evidence, not an independent physical display inspection.

Build 2120 and flash 238 log entries are preserved contiguously without gap, expiry or overlap. Build log SHA256 51b58849e2390a3023445df523dc956763a0225cf148ba086134054b09e58ba5; flash log SHA256 bd296e688e0a43f3951fe86184ad8f75323bf55f8c264cc7c2468a4ca87dcacf. Successful ON has the same SDK gdbinit diagnostic; error.c.obj is a compiler source filename. Neither is reported as an OFF build failure.

Host build gate 19 checks PASS; independent saved-build review 30/30 PASS, saved-flash-plan review 23/23 PASS and final record/function/parity review 25/25 PASS, all with no findings. The final reviewer independently reran the host function gate with unchanged output hashes and no API/USB/SDK/build/prove/device action. Review is retained in INDEPENDENT-OFF-FINAL-REVIEW.*. FINAL-PRESERVATION-CHECK.json confirms all original 98 input files and both production r2 modules remain byte-identical.

## Reproduction and remaining conditions

Host-only record/function verification and fixed-work comparison:

```bash
python3 -B /workspace/derby-evidence/j1-off-resume-20261020/validate_off_trial.py
```

This imports the real exact-J1 prove module without calling it and executes the unmodified r2 function on actual records. No stub or monkeypatch is used. Provider actual-build proof is verified, but local Linux has no actual OFF BIN/ELF bodies. Local actual-image prove and the complete all-argument --build CLI are NOT_RUN here; this is a remaining validation condition, not a PASS or a request for another device run.

PRIVATE-WINDOWS-OFF-HANDOFF.md/json provides the exact build job/head/artifact hashes, eight immutable inputs, byte hashes, seven selected canonical JSON hashes and full CLI command. Next action: independent Windows read-only actual prove and full unmodified r2 CLI using the existing OFF build and captured chain. Preserve raw bytes and JSON types, reject duplicate keys, retain originals and document envelope extraction. No rebuild, flash, ON remeasurement or OFF recapture is required. Parent separately attested the accepted ON full actual-prove/r2 CLI result; it is not promoted to an OFF result.

The runtime catalog exposes 22 broker tools. Updated description and concrete catalog agree on explicit derby_detail_mode ON/OFF for allowlisted J1 and flash_job_id binding to a successful owned current flash receipt. The unknown request-type projection does not establish local full CLI execution.

All evidence is private. The same Library artifact is updated from its pre-device build checkpoint, preserving earlier versions. Unrelated public create_tree remains uncertain and held; there was no retry or publication in this task. Old担当WIP was not obtained by this sequence, and reconstructed code is not claimed identical to that old implementation.
