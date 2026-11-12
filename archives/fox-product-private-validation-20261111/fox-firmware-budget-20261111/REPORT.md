# Full-product memory and source-render load audit

## Decision
Full firmware runtime fit is **not established**, but an isolated full frozen-product build now succeeds. Required official third-party sources were retrieved at the exact pinned commits after the initial missing-source configure failure. The source/render path is correct in the accepted bounded guest, but its RAM and CPU costs cannot be extrapolated to a production coexistence guarantee. No public changes, hardware actions, security setting changes, AF_UNIX retries, existing build modifications or parallel QuickJS branch work occurred.

## Provenance and reproducibility
- Selected baseline: qemu-render-20261111 HEAD `828baa3af69c55e7884c53557ea39f91190010a0`. Source snapshot produced by `git archive 828baa3` under this directory's `source/`.
- Alternative inventories only: cardputer-firmware-main and current HEAD `1b4524e3db8524365f58e8c7fb56531c31b55e22`; integrated HEAD `2980d1d593e8819214affeb5033324d95dea1ec7`. They were not substituted for the selected baseline.
- qemu-render/build-target is a failed minimal q7 configure, not a linked full product; no full-product ELF/map was found in these trees.
- Existing official toolchain: ESP-IDF v6.0.1; Xtensa GCC 15.2.0, esp-15.2.0_20251204. Used existing idf-env.sh, component manager disabled; generated files only under new directory.
- Isolated `idf.py -C source -B build -D SDKCONFIG=<absolute new build/sdkconfig> reconfigure` failed at main/CMakeLists.txt:16, missing BMI270. See configure.log. This is an absent-input failure, not access denial. The initial attempt downloaded nothing. Subsequently the three official repositories were cloned into the isolated source copy and checked out at exact Gitlink SHAs; no security options changed.
- Required exact Gitlinks: BMI270 `41129fcfe39c583ee5462d79195741945d51c1fe`; minimp3 `ea99364f61c14656440e8d77e9c233ccf3124633`; Opus `22244de5a79bd1d6d623c32e72bf1954b56235be`. Original source trees were absent. Resolved by official Git clones (boschsensortec/BMI270_SensorAPI, lieff/minimp3, xiph/opus), exact detached commit verification, and a successful full build. See dependencies.log and build-full.log. Full source/defaults remain untouched. The archive has no Git metadata, so the build version/memlog commit is unspecified; baseline provenance is the recorded archive SHA, not that generated version.

## Configuration differences that prohibit naive heap subtraction
Product defaults target ESP32-S3FN8, no PSRAM; 8 MB flash, size optimization, 240 MHz, USB serial/JTAG console, main task 8192 B, RTOS 1000 Hz, 32 KiB instruction cache, QIO flash. VM helper IRAM is enabled by default; ordinary device/probe flags and prepared-mesh experiment are off. Existing MEMPROT setting was preserved, never modified.
The minimal accepted guest has 16 KiB instruction cache, 24576 B main task and RTOS 100 Hz. It omits the full UI/peripheral/session workload. Its 195988 B minimum free heap cannot be treated as production room. Historical docs' idle/free numbers describe other builds and have not been adopted as current measurements.

## Ledger: measured layout versus requested capacity versus unknown runtime
All numbers are bytes. The complete product has a linked map; explicitly labelled source-only/layout counts remain distinct; allocator metadata, alignment and fragmentation are additional unless explicitly included.

| Area | Budget/evidence | Lifetime and uncertainty |
|---|---|---|
| Full product static | BSS76512, data21893, IRAM text81687 + vectors1028 = DIRAM181120; Flash Code1714576, Flash Data817428 | Measured full ELF/map, baseline only, character renderer not linked. DIRAM nominal remainder160640 is not aggregate runtime heap. RTC slow36, RTC fast24. |
| Runtime immutable geometry | 16330 + RGB constants144 | Flash-mapped in accepted guest; not equal RAM savings |
| Two mutable snapshots | 31952 | Existing buffers replaced by lease-owned pool, not duplicated |
| Renderer excluding strip | 86840 target | Frame24320 + workspace14512 + compositor48008; exclusive scratch, no parallel renderer |
| Existing proof strip |1920| Replaced by new two-strip staging, not retained twice |
| New staging pool |3856| Two 960-pixel RGB565 arrays plus y/height metadata; additional to product board buffer pending actual lending integration |
| New lease metadata |496 + two static mutexes176| Xtensa measured: pool40, slot24, reader40; 2*(40+2*24+4*40). Target FreeRTOS mutex sizeof88 each; excludes callback storage and bridge extra state |
| Render + snapshots + new staging + leases + locks |123320| 120712 -1920 +3856 +496 +176; lower-bound subsystem subtotal, not total firmware |
| Product board LCD buffer |3840| `board.c shared[240*8]`; BOARD_STRIP_HALF=1, ordinary tx_buf absent. SPI descriptors/driver allocation additional. This is NOT a 64800-B full framebuffer |
| Product UI task |32768 requested| main.c:1566; task control block extra; actual high-water unknown |
| IDF background task stacks |Event2304; esp_timer3584; idle1536 per task; FreeRTOS timer2048; LWIP TCP/IP3072 configured| Resolved sdkconfig; lifecycle/TCBs/actual high-water additional |
| Boot main task |8192 configured| Transient boot overlap depends on exact lifecycle; not blindly added permanently |
| Audio task |4096 requested| sound.c, can coexist with UI; I2S 4 DMA descriptors ×128 frames configured, driver allocations need runtime |
| QuickJS app heap cap |163840| app_session.c:1529, JS_SetMemoryLimit in guest.c:674. Cap not preallocation; native calloc not necessarily charged. VM C stack limit20480 is inside task stack, NOT additional stack memory |
| Overlay JS heap cap |163840| Same session mode, not evidence of a simultaneous second complete VM |
| Kasane runtime base |9088 target sizeof| Single contiguous calloc holding controls, two command banks6144 and text banks2048; sizes.c and target-sizes.txt. App tail separate or appended |
| Kasane app tail |≤3072 source assertion| Exact kasane_state not measured here; base+tail largest block can reach12160 |
| Optional Kasane cache |3120 target sizeof| Three allocations; lazy; runtime-lifetime until destroy |
| Optional Kasane animations |896 target sizeof| One lazy two-bank allocation |
| Schema/source/asset/native bridge |Unknown variable| See allocation-source-locations.txt; source controls/JS objects and native scene copying must be measured in integrated build |
| Prepared mesh cache |OFF default| No allocation budget inferred for disabled experimental path. Source-color private raster already owns its own 14512 workspace |
| Wi-Fi |4 static RX;8 dynamic RX;8 dynamic TX;8 management buffers configured| STA-only, no aggregation, Wi-Fi IRAM opt off; driver allocates on activation. Time-sync worker3072 and autosync2048 prefer RTC RAM then fall back to internal DRAM; TCBs internal |
| Network |HTTP task6144 requested; TLS dynamic buffers| One request at a time in source; TLS handshake includes input16384/output4096 plus contexts; source comment's old failed allocation is not current measurement. LWIP IPv6 off/max sockets4/receive mailbox16; task stacks/buffers require runtime peak measurement |
| BLE |Not enabled by selected defaults| sdkconfig.ble is separate opt-in; BT_ENABLED absent from resolved sdkconfig; no BT linked in baseline |
| Audio stream / MP3 / Opus / SD |Stream ring6144 per actual active owner; MP3 task24576; SD4096; Opus decode12288; Opus network6144| Optional feature lifetimes can overlap character/UI; decoder state/packet buffers additional. Do not sum every mutually exclusive codec as universal steady state |
| Peripherals / text / storage / fonts / overlays |Unresolved| Board SPI/I2C, keyboard, IMU, SD mount, font/text caches and queues must be included by full map + phase measurements; cold flash data must remain separated |

Product-capacity stress example: renderer subtotal123320 + app cap163840 + UI stack32768 + board3840 + Kasane base9088 + max tail3072 + optional cache3120 + animation896 = **339944 B**, excluding almost all firmware static memory, IDF tasks, drivers and allocation overhead. This is a *capacity scenario*, not actual allocation or a measured failure. It proves that promising all configured capacities simultaneously is unjustified; provisioning must use measured peaks and an explicit feature envelope, not minimal-guest free heap.

Largest-block gates matter independently of free total: largest renderer allocation if monolithic may be86840; static placement avoids that individual allocation but permanently consumes the same SRAM. Each snapshot15976, staged pixel buffer1928, base+tail≤12160, TLS input16384, and decoder allocations need their actual caps/lifetimes tested. Snapshot retirement allows no reuse until final CPU reader; DMA keeps only independently owned strips pinned. Old/pending snapshots overlap by design. Cancellation/teardown must drain borrowed strips before freeing them. Third snapshot would add15976 and is not included.

## Source-render load measurement
`python measure_load.py` builds separate instrumented copies of the frozen primary host wrapper, scene raster and compositor; all original sources remain unchanged. It measures operations without changing render arithmetic. `load-results.json`, host-load.log and host-command.json retain evidence.

All **2656 original records** match the prior host log exactly: 91 frame records and 2565 row records. No new QEMU run performed.

Across all 91 tested host frames:
- 136 band raster passes per frame: 34 bands × (one visible layer + one exhaustion pass) × (full preflight + publication render).
- 281004–281356 covered-fragment callbacks per frame.
- 70354–70682 actual material evaluations per frame.
- 18764–18996 repeated binned triangle visits; 692–704 packet batch preparations.
- Maximum accepted layers1; fractional material samples0 **for these views/states only**. These captures do not bound all transparency scenes. Existing separate fractional/compositor tests remain necessary.
- Host process CPU17.452–42.144 ms per instrumented frame, including capture/log bookkeeping where enabled. Host scheduling/cache/output and instrumentation differ from target. **Not physical FPS, not target throughput, not a 20-FPS pass.**
- Configured layer limit16 admits up to17 raster traversals per band including exhaustion, at most1156 across two34-band sweeps; failure behavior and content decide actual early termination. Additional preflight RGB conversion repeats 32400 output pixels even though preflight discards them.

## Optimization candidates and tested private cutout prototype
1. Add an explicit validation-only compositor path that executes identical geometry, source shader, ordering, layer and finite-value checks, but omits final discarded RGB565 background conversion. Keep preflight failure rollback tests and byte-exact target comparisons. No memory increase required; expected savings must be measured.
2. Cache invariant per-band triangle setup across peeling passes or hold bounded prepared batches, with exact source-triangle identity/tie ordering and immutable snapshot generation. Trading memory against repeated 692–704 preparations needs measured sizing before implementation.
3. Do not remove full-frame preflight merely because ordinary samples pass: a final-band shader/overflow failure must not partially publish LCD output. Whole-frame caching would add64800 B and is a poor unproven RAM tradeoff here.
4. Preserve exact alpha/depth semantics. The observed one-layer content does not authorize flattening transparency, opaque substitution, arbitrary alpha cutoff or dropping original degenerate topology.

Implemented clean private source `composite-cutout.c` within the private candidate. It reuses existing workspace, tries one raster pass selecting the exact nearest source-colored alpha1 fragment while alpha0 never claims depth, and falls back to the unchanged general compositor on an evaluated fractional candidate. Invalid shader values still fail atomically. The source callback must be pure and snapshot-immutable, since fallback replays it. Full-frame preflight remains, no complete framebuffer is allocated, no alpha threshold added, and equal-depth triangle identity ordering is unchanged.

Fast path validation:
- All 91 original frame hashes and 2565 captured rows match exactly (`fast-results.json`). Material call counts intentionally differ, so only rendering records are compared, not old diagnostic counters.
- Same tested frame workload drops136→68 band raster passes; covered fragment callbacks281004–281356→140502–140678; triangle visits18764–18996→9382–9498; batch preparations692–704→346–352.
- One bounded instrumented host run:10.223–16.096ms/frame versus baseline17.452–42.144ms; not a controlled physical speed ratio or device-FPS measurement.
- Existing compositor invariants pass O2 and ASan/UBSan: .01 fractional transparency, layer-limit rollback, late error/recovery, equal-depth identity, opaque termination, all65536 RGB565 background roundtrips, preflight and overlap/overflow aliases. LeakSanitizer disabled; no leak-freedom claim.
- 3000 deterministic differential cases compare old/new return values and full output bytes across random binary/fractional/negative/NaN/infinite alpha, explicit shader failures, depths/ties, arbitrary backgrounds and batch/layer limits. All pass, including no publication on failure (`differential.log`).
- Clean source compiles for Xtensa against the existing guest config. Two static FreeRTOS lock init/take/give wrappers compile; no target runtime concurrency proof from this smoke.
- This does not yet reduce48008-B compositor storage because general fractional fallback remains resident. The separate review and composed QEMU reports provide the later correctness checks. No target performance result or physical20-FPS gate is claimed.

## Required full-product acceptance run
Full build, ELF/map, per-file size data, symbols and resolved sdkconfig are now captured. Remaining: heap free/minimum/largest by INTERNAL|8BIT and DMA/EXEC/RTC caps; UI/audio/network stack high-water. Measure boot, home, model import (including old/new asset overlap), QuickJS parse, steady rendering, both snapshots busy, both strips borrowed, stop/restart/cancel, optional audio, SD mount, Wi-Fi sync and TLS handshake. Log before/after and peak lifetime; verify repeated-cycle recovery. Existing board I/O requires coordinated eventual hardware tests. QEMU cannot establish LCD/SPI/DMA latency or physical framebuffer delivery.


## Full-product static detail
Actual map sections (not sum of per-object approximate attribution): BSS76512, data21893, IRAM text81687, vectors1028. Top attribution entries: ksn_render11469 DIRAM, ksn_pet8209, pocket_grid7206, QuickJS quickjs.c6171 including6119 IRAM, app_control5633, board5091, Wi-Fi wl_cnx4002; exact component/file ledger is full-size-files.json and build/memory.jsonl. The board's shared3840-B buffer is inside its baseline static allocation and must not be added twice to the baseline181120-B figure.

Relevant actual RAM symbols: board shared3840; renderer blend_lut_alpha2048 and blend_lut_solid2048; ksn_pet cache_rows8192; decoded5572; grid slots7200; app control5264; interrupt stack3072. Other named symbols in full-symbols.txt at0x3c... are mapped flash even when nm labels them D/d: do not count those as mutable RAM. Map section membership is authoritative.

Full ELF/bin/map SHA256 and pinned dependency commits are in full-build-provenance.json. Expected application image2636648 B before binary padding; existing flash_budget and memlog build checks completed. Frame lint reports NEW/GREW findings already in the unmodified frozen baseline, so this build is not claimed to clear an independent performance gate.

The measured136→68 passes applies only to this binary-alpha workload: fractional fallback adds an initial speculative partial traversal per band, which is not included in `w->passes` when aborted, so this is not a universal2× speedup or cost bound and fractional workloads can become more expensive.
