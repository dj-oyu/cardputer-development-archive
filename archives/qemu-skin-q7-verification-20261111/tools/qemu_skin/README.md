# Real QuickJS skin paths on ESP32-S3 QEMU

Test-only adaptation of the existing public `tools/ayatsuri/skin/test_js.c`, `test_batch.c`, scenarios and fixtures. Source revision: `828baa3af69c55e7884c53557ea39f91190010a0` (PR #126). No tracked production file changes. This is not the scene facade's automatic skin path or the unimplemented AYNM skin wire/importer.

## Reproduction

Prerequisites: exact checkout with dependencies, Node, GCC + ASan/UBSan for host, Python/Pillow for optional preview, official ESP-IDF 6.0.1 and its toolchain, official QEMU 9.2.2 ESP build. No new downloads or hardware are required in the provisioned workspace.

Run from repository root:

```sh
python3 tools/qemu_skin/generate.py
python3 tools/qemu_skin/generate_batch.py
python3 tools/qemu_skin/run_host.py
python3 tools/qemu_skin/run_host.py --batch
source /workspace/scratch/6d8dcdbcdc54/qemu-esp32s3-20261111/idf-env.sh
idf.py -C tools/qemu_skin -B "$PWD/tools/qemu_skin/build-target" -D SDKCONFIG="$PWD/tools/qemu_skin/build-target/sdkconfig" build
idf.py -C tools/qemu_skin -B "$PWD/tools/qemu_skin/build-batch" -D SDKCONFIG="$PWD/tools/qemu_skin/build-batch/sdkconfig" -D QSKIN_BATCH=ON build
python tools/qemu_skin/run_qemu.py --qemu /workspace/scratch/6d8dcdbcdc54/qemu-esp32s3-20261111/bin/qemu-system-xtensa --build tools/qemu_skin/build-target --seconds 180
python tools/qemu_skin/run_qemu.py --qemu /workspace/scratch/6d8dcdbcdc54/qemu-esp32s3-20261111/bin/qemu-system-xtensa --build tools/qemu_skin/build-batch --seconds 180
python3 tools/qemu_skin/decode.py tools/qemu_skin/host.log tools/qemu_skin/host-captures
python3 tools/qemu_skin/decode.py tools/qemu_skin/build-target/uart.log tools/qemu_skin/target-captures --reference tools/qemu_skin/host-captures
python3 tools/qemu_skin/decode.py tools/qemu_skin/host-batch.log tools/qemu_skin/host-batch-captures
python3 tools/qemu_skin/decode.py tools/qemu_skin/build-batch/uart.log tools/qemu_skin/target-batch-captures --reference tools/qemu_skin/host-batch-captures
```

`generated/scene.c` is always single-skin; `generated/batch.c` is always managed batch. Batch includes the same adapted single-skin helpers but invokes only batch tests. The CMake QSKIN_BATCH option chooses the file. The copied adapter is self-contained in this directory; no untracked qemu_scene/qemu_mesh/qemu_q7 dependency remains. `qemu_scene` in ELF/binary names and `QSCENE_` capture tags are retained harness names, not a scene-facade claim.

## Adaptations and limits

- Actual QuickJS → public `evaluateSkin`/`evaluateSkins` binding → native model packets → real Kasane compositor → delayed mock display transport, 240×135, four-row double-half buffer, image-row path. Each target profile performs two complete 240-visit lifecycles (120 poses forward and reverse).
- Preserve original input validation, OOM, busy, IO retry, independent actor, backing-array lifetime, native ready state, disposal and cyclic-GC assertions. Only full-frame oracle storage changes: C raster renders one row at a time and computes FNV32. Per-visit in-guest equivalence and reverse visits are **hash equality**, not full byte equality. Selected frames 0/30/60 are captured as RGB565LE bytes and compared exactly against the identically adapted ASan/UBSan host harness. All 120 forward frame hashes are also compared host/target; repeat captures are separated by lifecycle.
- Two 64,800-byte reference/isolated panels become hashes; the actual output panel remains. Native direct-oracle allocation reserves arena_bytes+7 and aligns the interior to 8 bytes, freeing its original owner. Embedded JS/AYNM assets avoid guest filesystems.
- ESP32-S3 identity is retained globally. `scalar.h` is forced only on ksn_render.c, ksn_blend_pie.c, and ksn_shiki.c because QEMU cannot execute PIE. No EDGE4 substitution.
- JS runtime uses JS_NewRuntime2 with internal-capability IDF allocator and heap_caps_get_allocated_size. No PSRAM; 160 KiB JS limit; 24 KiB main-task stack. Heap lines are actual target internal-capability free/largest/minimum measurements and include the test scaffold; they are not the complete production application's RAM budget.
- Host allocation ledger measurements are labeled host-only. On target those ledger counters are placeholders; their zero values do **not** prove target allocation-free operation. Target JS usage and internal heap API readings are real. LSan explicitly disabled for this environment; ASan/UBSan and host release-ledger checks retained.
- Batch work and near-limit expectations use sizeof/alignment formulas, not fixed 64-bit host totals.
- No physical LCD, SPI/DMA peripheral validation, actual timing/FPS, PIE, private character, scene automatic skin, importer, Q7 or latest two-core validation. Mock delayed transport checks buffer-loan/completion/ACK protocol only.

## Evidence

`host*.log`, `host*-commands.json`: reference runs/commands. `build-target/uart.log`, `build-batch/uart.log`: untouched UART transcripts. Each build's `run-metadata.json` retains the exact bounded socket-free QEMU command, version and firmware/UART SHA256. `*-captures/captures.json` retains all hashes and selected exact-byte results. The initial incorrect relative build path configuration is preserved in `build.log` and `failed-configure/`; subsequent builds use explicit isolated absolute paths. `build-corrected.log`, `batch-build.log`, `batch-rebuild.log` retain successful builds. No failed run is overwritten to imply success.

## Verified results

Both profiles completed within their 180-second bound, with two PASS lifecycles each. Single-skin: 16 initial OOM failures/17 successes per sweep; preserved 480-byte work on failed growth and recovered to576. Target JS frame peaks72676/72744 bytes, minimum internal free117804 bytes. Managed batch: 13 OOM failures/12 successes per sweep; target work803 bytes, near-limit16307 bytes (host823/16327), minimum internal free110824 bytes. Each profile started with285692 bytes free, released285400 after the first lifecycle and285400 after the second: 292 bytes retained once, no additional second-lifecycle loss. This matches earlier independent context-only behavior; the exact owner was not traced here, and this must not be called a new skin leak or exact-zero teardown.

For each profile, all120 forward-frame hashes matched the host in each lifecycle, with in-guest reverse replay also passing. All six selected target frames/profile matched host RGB565 bytes exactly (0 differing pixels). Captured previews show the public red skinned strip and blue background mesh at poses0/30/60; these are test fixtures, not a final character asset. Host ASan/UBSan runs and requested-allocation release ledgers passed. No production fix was required.
