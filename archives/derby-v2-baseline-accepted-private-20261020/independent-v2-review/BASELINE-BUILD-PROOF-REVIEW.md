# v2 baseline registered build proof — independent review

Reviewed UTC: 2026-10-20T01:04:19.144748+00:00

**PASS for registered source/build and saved flash-prepare binding only. Flash/readback and the new strict trial remain pending; this is not hardware acceptance.**

Successful source and manifest name exact head `37af4225ad329aac4c5e79c880d7d69760b770be`, reviewed tree `7753c5c8919ee36c24080ce08102438a285da6f2`, source digest `9e89fd87e0019e52a8111fc1adb24f3a689934188095539e157c92f8a1f5898d`. Source receipt and all submodule bindings match the build plan and manifest. Build job/plan hashes agree; terminal result is succeeded / firmware_build_succeeded_no_flash. Plans share v2 epoch `62c7885ab3f34ce6b9fc6973754c85f2`.

Primary saved server response **baseline-build-logs-020.json** explicitly has artifact_status=verified and the identical full manifest. This is separate from the normalized combined record's verified=true. The reviewer's earlier artifact-status evidence concern is withdrawn: the initial search mistakenly excluded the log-response JSON files. One network_error log-read response (006) is historical; later terminal result and recovered proof are present. Do not infer a complete globally contiguous log history from entry sequence numbers alone.

The actual registered build's diagnostic proof at **sequence 2105** equals both baseline-diagnostic-proof.json and the combined proof. Detail, fixed workload, measure and telemetry are all ON, required dd_ APIs and df_detail_exit_record are present, and exact fixed boundary rules hold. Embedded play/view, fixed seed `2545F491`, fixture identity and same source's CI-ON protocol proof agree. Target is ESP32S3 / IDF6.0.1.

| Artifact | Bytes | Recorded SHA256 |
|---|---:|---|
| app BIN | 2,296,736 | `63f35801715ce8f211a7ded14c138f1e9a6a40415bc39170660f92c779743e7d` |
| app ELF | 20,045,388 | `e2e49a8637d0ef0ee3c7f839c7323f76d5d230e66e474216419a7ba21f7c3a3b` |

Manifest and paired diagnostic proof agree on these artifact sizes/hashes. The separately saved successful flash-prepare response selects this exact build job and BIN/ELF; its manifest hash equals SHA256 of the saved manifest's canonical JSON. This confirms prepare binding, not execution or readback. The manifest itself correctly says flash_authorized=false / flash admission not evaluated because flash is a separate operation; the saved formal prepare is the later stage. No approval decision is inferred by this reviewer.

No full binary files were downloaded or rehashed locally; this assessment binds saved server artifact-status/manifest/proof evidence and formal prepare. Actual verified flash/readback, complete raw/transport receipt and strict parse(expected=True) of this expected-ON baseline still need a separate review. Do not proceed to later variants on coarse validity alone. The old baseline failed capture remains FAIL.

Input digests and structured checks: BASELINE-BUILD-PROOF-REVIEW.json. No live MCP/device read, USB, source/build/flash execution, retry, repository or GitHub modification was performed by this reviewer.
