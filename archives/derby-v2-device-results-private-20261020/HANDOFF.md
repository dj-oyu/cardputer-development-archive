# Parent handoff: controller split correction

Authorized correction implementation, host validation, Draft PR publication, exact-head CI and independent review are complete. This is not completion of device diagnosis or performance comparison. The previous worker WIP was unavailable: the detailed instrumentation was reconstructed from the specification; it was not recovered byte-identically from that worker.

| Variant | Draft PR | Exact new head | CI jobs |
|---|---|---|---:|
| baseline | [25](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/25) | dc2c5e044429a4904e91564aa7f9cb30d7d4cbbb | 7/7 |
| native | [26](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/26) | 3fafcadbd72ecbd0d799cbe9d29f037ff62c05d5 | 7/7 |
| batch | [27](https://github.com/dj-oyu/cardputer-adv-pocketjs/pull/27) | 711f94fa91c6e0d6ba7bc00def75ad686b724c7d | 9/9 |

All three variants and detail ON/OFF use the same explicit-strict global controller chunk. Original prog/view/scene/pan/play call order, synchronous failure propagation, fixture/seed/camera, 120 contexts, three dependent replays, watchdog/session, and bounded tail are retained. Inline restoration reproduces the old play bytes. Nested loading changes failure filename/cause and compile/run retry classification; exact old exception behavior is not claimed. Source changes do not alter C/VM/render/I/O or heap/stack budgets.

Evidence: REPORT.md, SOURCE-CHECKPOINT.json, per-variant correction.patch/complete.patch/correction.bundle/published.commit, 48 local check receipts plus batch normal runner, six target proof logs and parsed receipts, 10 successful runs/23 successful jobs, independent-review/CONTROLLER-FINAL-CI-REVIEW.md, and offline batch restore PASS. Auxiliary path-filtered workflows were not triggered and are not counted as PASS.

Preservation: prior-device-v4.zip retains all earlier code, host/CI and baseline/native accepted device results plus old batch OOM failure. This payload adds complete correction recovery materials. Stable private Library ID: libfile_54f384d164808191a369081825204874. Final current version/file ID/outer ZIP SHA256 are in the external CONTROLLER-LIBRARY.json receipt; no public raw logs or share link.

Blocked preservation action: workspace download of baseline fixed firmware archive12236305882 failed with CONNECT tunnel503, denied=false, local bytes=false. All23 archive metadata records, including six detail target and three separate fixed-firmware archives, are preserved. Existing detail upload paths omit the six build_detail BIN/ELF bodies; CI verified their pair, but local rehash cannot be claimed. Separate build_fixed archives are detail ON and cannot be equated with the six build_detail builds. Expiry2026-11-03 UTC. Local full target link was also blocked by dependency fetch503; exact-head CI full target jobs succeeded.

Hardware: no connection/reset/source/build/flash/measurement/recovery/MCP/USB was performed during this correction. Installed old batch head ea64b0ec remains the failed state. Prior derby-v2-batch-fixed-ea64b0ec-20261020 ended01:43:53 UTC needs_review/serial_fault_marker, play compile OOM, zero measured windows, valid=false. Serial close/idle/lease release was already confirmed before correction. No runtime OOM fix or performance gain is claimed.

Next owner: parent thread01a15560-53fc-74be-bdcc-e2ec8c3d200a reviews these results and adjusts the finite hardware trial/recovery/exclusive ownership procedure. New-head runtime startup, all-three device remeasurement, target OFF overhead comparison and runtime stack/heap remain pending. This agent does not resume hardware.
