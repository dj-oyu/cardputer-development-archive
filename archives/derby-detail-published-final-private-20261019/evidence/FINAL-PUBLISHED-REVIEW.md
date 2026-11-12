# Final published fix review

Checked UTC: 2026-10-19T21:01:32.674572+00:00

Result: **No unresolved major finding in the reviewed updated exact heads.** This supersedes the earlier P1-unresolved review for the previous published heads; CI and device acceptance remain separate.

| Variant / Draft PR | Exact reviewed head | Original comparison base | Files changed from base |
|---|---|---|---|
| baseline / PR21 | `90b9f686e7c6897bc53e26e3b82fbe5569b968fd` | `0c52600fc34deafbadc53bc48e4fc98931e404e4` | 33 |
| native / PR22 | `baa41e984339436dca6157a29326d3b863825761` | `44f9c56121b5aab4fb2eca0fcf9fbe54d833a276` | 33 |
| batch / PR23 | `fded982793d0b99246a7335fe22d791985fd6e96` | `3a641d4d996938339b44fe735aba876ad031b3a2` | 35 |

All three local checkouts are clean and their HEADs exactly match the parent-supplied published IDs. Each original comparison base remains an ancestor. Remote readback equality was reported by the parent and was not independently queried here.

All 30 common changed files are SHA256-identical across the three trees. The batch-only runner generator, snapshot observation and batch proof change are expected variant-specific additions. The nine C hashes in all three heads match the retained reserve-fix target review.

## P1 resolution

- Detail ON returns after settlement/digest, then emits one successful output record per separate reporting frame. All 40 detailed records, coarse summary and whole-trial END are split across calls/returns.
- Output refusal aborts with invalid END handling. Independent ASan/UBSan and O2 tests exercised 110 ms successful writes, all 42 final-repetition refusal positions, at most 220 ms refusal handling, already-expired sessions and the formerly vulnerable 179.950001 s final-write start.
- A conservative 250 ms session reserve precedes each qualifying output; the final valid END no longer begins when the documented bounded USB call could cross 180 seconds.
- The complete-stream strict parser rejects InternalError/RUNAWAY/LOADSTALL, including faults after a valid-looking END. OFF generation and five production C O0 .text preservation checks passed in the retained reserve-fix review.
- The preceding target review passed 27 syntax checks and 18 ON/OFF object builds with retained Xtensa GCC15.2 / IDF6.0.1 headers/config. Source hashes bind those results to these nine C sources. Static .bss/.data increase was 3,056 bytes; report.constprop stack was 1,136 bytes for both modes. This is not an exact new firmware link or runtime high-water proof.

## Independent batch mode-proof check

- verify_derby_runner_batch.py starts from the shipping PAN, applies the detail transform when enabled, then applies runner batching. This matches actual CMake generation order.
- The helper checks cache mode, js_runners presence, the exact generated PAN file, target bytes in ELF, prohibited alternate bytes, IDF6.0.1 and paired BIN/ELF hash. Detail ON additionally rejects shipping PAN bytes mixed into ELF.
- Repo-external check_batch_proof.py exercised 8 positive cases (four runner/detail modes plus normalized detail aliases) and 26 negative cases, including mode/native/cache/PAN/generated-path/BIN mismatches and shipping PAN contamination. All passed.
- test_derby_detail_proof.py independently passed in all three trees; the batch case reaches both the actual mandatory diagnostic prove(build) and runner proof using detailed synthetic BIN/ELF. Existing test_derby_runner_batch_proof.py also passed.
- Synthetic files and mocked nm symbols establish helper logic only; they do not establish an actual target ELF or active device mode.

## Remaining acceptance and evidence

- Await/inspect exact new-head CI target ON/OFF links, mandatory proofs, map/size and compiler stack artifacts. Running CI is not marked PASS here.
- Validate actual target overhead, runtime heap/stack high-water, continuations and bounded live-broker collection followed by strict local detailed parsing.
- Source/workload identity and host proofs do not establish LCD pixels, actual USB losslessness or target performance.
- Structured final source checks: FINAL-PUBLISHED-REVIEW.json.
- Synthetic mode matrix: PUBLISHED-FIX-FINAL/batch-proof-cases.json; reproduce with PUBLISHED-FIX-FINAL/check_batch_proof.py.
- Existing synthetic tests: PUBLISHED-FIX-FINAL/proof-test-results.json and adjacent logs.
- Retained actual object/source/config evidence: P1-FIX-REVIEW/RESERVED-DEADLINE/report.json, objects/, unit.log, generation.log and reproduce.py.
- These private evidence files contain environment paths and must not be publicly uploaded. This final pass performed no repository edit, MCP/source/build job, actual firmware compile/link, USB, flash, publication or merge action. No action in this review was denied, pending or uncertain.
