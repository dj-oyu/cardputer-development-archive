# J1 ON physical trial — official success, local parser compatibility gate blocked

OFF was not started. No retry, new firmware source head, automatic rollback, arbitrary command, manual settings/limit/permission change or extra physical trial occurred.

Completed:
- Exact existing ON build derby-j1-on-build-b561aea1-s30-20261020 was revalidated and reused; it was not rebuilt.
- Source b561aea1c0798feb28055a00d36681fae81ac58a, receipt f943d8a86e72e70015040a73e1d389f09b3fda1839ae44ea361b1b8423ecb822, canonical mode proof a504d85a5a3378469e68f278e4710d5bdee78e03147c68f6aa28f31d3c4953eb.
- ON flash derby-j1-on-flash-b561aea1-20261020 ran10:42:00→10:47:15 UTC, succeeded / firmware_flash_completed.
- Current J0 batch recovery receipt916b1fe2dc4bea181bea6ce71958f995725cba185231706a2fd0d861b92daefe was frozen and the mandatory ROM/prewrite check completed before write.
- Postwrite full-segment SHA256 readback plus passive IDF6.0.1/expected ELF25249d3df boot verified. All237provider flash-log entries retained continuously.
- Successful flash selected current ON receipt db1e10643f69ab8510dfd43df9d4649ddf26f91a03c081910cfec15f6de46a18. Original J0 history/recovery evidence remains retained.
- Typed collector plan635b430c80f7d273db417a40237698b51462283d60cc4a6482ce6d6d251a3f78 bound flash job/current receipt/build/source/manifest/modeproof/BINELF/principal/device/epoch.
- ON collector derby-j1-on-fixed-b561aea1-20261020 ran10:49:01→10:50:33 UTC and officially succeeded / derby_fixed_trial_verified / serial_close / owner_exit_v2.
- Three dependent reps have quality0/valid1 and work_us6767374/6772187/6771247. These are ON observations, not an ON/OFF comparison or J0 baseline replacement.
- Raw capture31325bytes, SHA256 f436833a2e6b3eb50492691f141ff13fd67607f6ce1df0755c2f457419523670; transport complete, duration87895ms, gaps/overflow/truncation/partial_tail/disconnect/reset/refused allfalse.
- END line238→matching owner EXIT239→STOP241→HOME242, each once. APP_ID line3 and READY line10 each occur once with timestamp/tag prefixes.

Local gate discrepancy:
1. Exact J1 parse_completion rejects timestamp-prefixed APP_ID/DERBY READY with completion_missing_or_duplicate_marker. It already permits prefixes for STOP/HOME. Project parse_collected and pinned v2 parse_collected both accept complete known work/transport; exact J1 completion/detail gates are not accepted.
2. Exact J1 verify_derby_recorded_trial expects binding configured_expected_firmware_sha256; deployed runtime exports expected_firmware_sha256 and a typed flash_receipt object. The mismatch is recorded, not silently substituted.

OFF comparison gate is held. OFF build/flash/collector jobs were never created. Original parser-reference files preserve exact primary-source contents; any proposed host-only compatibility fix is isolated in parser-candidate, with a reviewable patch/tests. No candidate changes firmware, accepts another firmware source head, reruns ON, or authorizes OFF.

Lease/stop state:
The lease remained live throughout the active collector, which completed10:50:33. It expired while offline parsing was investigated. The first stop status already showed idle/unowned/lease0; a release call returned invalid_session and was not retried. Subsequent status remained idle/unowned, all queues/work sessions0 and all current uncertaintyfalse. The bearer was cleared from memory and never saved. Successful ON remains the last verified installed image; no rollback occurred.

Preservation and scope:
Raw transport is private in the evidence folder and private Library only. No raw UART was published. Existing ON build full evidence archive is nested unchanged as ON-BUILD-ACCEPTED-v1.zip. Recent reads of older RAM build/flash logs report expiry, while original complete logs and durable verified manifests remain preserved.

The independent flash/collector-plan review passed24checks. Final parser discrepancy/candidate review is saved separately. The J1 primary pinned collector was fetched at its declared88890ed7 source and SHA256-checked; this is host-parser reference data, not a new firmware source. A failed initial reference path and an extra-newline serialization issue were corrected locally from original metadata before hash checks passed; hardware was not rerun.

Blocking action: exact-J1 independent completion/detail and recorded-chain acceptance for the saved ON trial. Target: derby-j1-on-fixed-b561aea1-20261020. Reason: timestamp/tag and binding schema compatibility. Status: official physical collector succeeded, independent exact-J1 helper gate failed; OFF remains pending. No automatic approval rejection occurred and no execution outcome is uncertain.

Evidence-only source/build proof validates retained provider BIN/ELF hashes; actual BIN/ELF bodies were not independently copied/rehashed in Linux. This trial does not attest physical LCD pixel hashes. Whole ON/OFF physical comparison remains incomplete.

