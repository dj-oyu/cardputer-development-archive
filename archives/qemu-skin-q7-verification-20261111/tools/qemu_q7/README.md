# Isolated Q7 opt-in QEMU correctness and memory profile

Source HEAD: `828baa3af69c55e7884c53557ea39f91190010a0` (PR #126 stacked on #125).
Only test files in this directory were added. No production edits, hardware, flash,
private model, network/security changes, upload or deployment occurred.

## Profile and coverage

A small standalone ESP-IDF 6.0.1/GCC 15.2.0 ESP32-S3 executable calls real
`ksn_mesh_prepare`, `ksn_mesh_q7_prepare`, `ksn_mesh_q7_render` and original
`ksn_mesh_render`, with a frozen pre-flat-span Q7 oracle. Source inventory/hashes
are in manifest.json. main/CMakeLists.txt explicitly adds sources and defines
KSN_MESH_PREPARED_PROTOTYPE=1, KSN_MESH_Q7_CERTIFIED_PROTOTYPE=1, Q7_CERT_MODE=3.
EDGE4 and benchmark preflight are absent/OFF. No QuickJS, skin, display or DMA.
ESP_PLATFORM is preserved; no PIE sources or global identity guards are needed.
Strict FP flags apply to all test and renderer sources, including oracle:
-O2 -fno-fast-math -fno-associative-math -fno-reciprocal-math
-ffp-contract=off -frounding-math -fno-lto -fstack-usage -UNDEBUG.

Public test_row_reuse.c's four overlapping colored quads (8 triangles), 240x135,
16 moving frames × two stripe modes (4-row band/1-row workspace and 8/8) × two
lifecycles = 64 candidate frame visits, each checked against the predecessor.
Pixel bytes, depth, owner, statistics and floating exception flags must match.
Nine corner cases additionally cover signed zero, uncertain mask, occlusion,
quantized zero step, one step, invalid certificate, whole-frame fallback and
non-nearest rounding. Workspace offsets/alignment/overflow/capacity and partial
failure plus uint64 statistics wrap are tested. Explicit invalid-y, capacity65,
undersized-snapshot and untouched-output-sentinel checks are included.

The test adaptation reduces original 9×150 timing work to 1×16 correctness work,
uses aligned heap interiors (+7 each, raw owners freed), static comparison buffers
to fit 24KiB stack, UART captures, and heap observations. Failure buffers are reset
on every scenario. Timing values remain raw diagnostic output and are NOT target
performance measurements. Captures 0/2/4 are Q7; 100/102/104 are original float.

## Observed results

QEMU completed all assertions. Every 16-frame main pass reports depth_fast=286720,
mask_fast=210432, depth_exact=mask_exact=0, spans=286720, rejects=76288, digest=d3048ac5.
This verifies actual certified Q7 execution, not fallback-only execution.
Selected three candidate and three float full RGB565 images match the host exactly.
The selected float/candidate images also happen to match for these flat public quads.
This is NOT a general claim: full repository host numeric tests (plain and
ASan/UBSan) report 17172000 samples with coverage differences=158, owner=164,
depth=162, RGB=2518, same-owner RGB=2354, same-owner >1-channel-unit=0.
Their 600-scene certificate suite and 1000-scene independent halfspace span checks
pass. Approximate coverage/color, certified depth/mask, and optimization-to-
predecessor equality are separate claims.

No PSRAM. Standalone heap starts/returns to 202764 bytes in initial run, largest
139264; each aligned prepared+Q7 allocation lowers free by 5640 bytes. Requested
sizes are 1624+3864+14 padding=5502, remainder allocator overhead. Minimum free
197108; stack high-water 19672 bytes remaining from 24576. Heap integrity true.
Final authoritative figures are in build-target/uart.log after limit-test addition.
Repeated lifecycle returns are evidence for this native isolated profile only,
not universal leak freedom or full product memory admission. Test BSS retains two
full images, stripe workspaces and failure buffers, unlike the shipping product.

Symbols, map, compile_commands.json, disassembly and stack-use files are retained.
flat_span_run is in IRAM (4037...), ksn_mesh_q7_render and prepare in flash (4200...).
The IRAM leaf calls ROM double helpers __floatsidf/__muldf3/__adddf3/__subdf3/
__truncdfsf2 at 4000... in the inspected binary. This is placement evidence only,
not proof that the entire call chain is safe with cache disabled.

## Reproduce

From repository root:

    python3 tools/qemu_q7/generate.py
    bash tools/qemu_q7/run_host.sh
    source /workspace/scratch/6d8dcdbcdc54/qemu-esp32s3-20261111/idf-env.sh
    O="$PWD/tools/qemu_q7"
    idf.py -C "$O" -B "$O/build-target" -D SDKCONFIG="$O/build-target/sdkconfig" build
    python "$O/run_qemu.py" --qemu /workspace/scratch/6d8dcdbcdc54/qemu-esp32s3-20261111/bin/qemu-system-xtensa --build "$O/build-target" --seconds 300
    python3 tools/qemu_q7/decode.py tools/qemu_q7/host.log tools/qemu_q7/host-captures
    python3 tools/qemu_q7/decode.py tools/qemu_q7/build-target/uart.log tools/qemu_q7/target-captures --reference tools/qemu_q7/host-captures
    python3 tools/kasane_contract/run_mesh_q7.py --plain
    python3 tools/kasane_contract/run_mesh_q7.py

run-metadata.json records bounded socket-free command, version, hashes and completion.
QEMU uses file serial, -machine esp32s3 -display none -monitor none -nic none
-snapshot -icount shift=2. No AF_UNIX attempt occurred.

## Superseded attempts and exclusions

build.log is the failed initial relative -B configure. It created untracked
repository-root build-target/; sibling also had a similar configure and moved its
failed directory to tools/qemu_skin/failed-configure. Do not package root build-target/
or treat mixed failed configure evidence as a successful build. No shared failed
outputs were removed here. build-corrected.log has the test printf uint32_t format
mismatch; the generated test now casts to unsigned and build-final.log is successful.
first-run-uart.log preserves the first passing run before extra explicit limit checks.
Only tools/qemu_q7/build-target is the successful build for this profile.

No S3 throughput/FPS, arbitrary fox/model visual quality, full-product RAM, task
concurrency, peripheral, hardware or cache-disabled acceptance is claimed. The
historical bbee585a 15.890fps device trial is not a result of this build.

All required harness files are self-contained here. generate.py reads only tracked
repository contract/renderer sources. run_qemu.py, decode.py and sdkconfig.defaults
were initially adapted/copied from qemu_scene but are now independent local copies;
reproduction does not read any untracked qemu_scene/qemu_mesh/qemu_skin files.
The pinned repository plus ESP-IDF/toolchain/QEMU installation are required.

## Source-only staging

The local .gitignore excludes generated sources, build directories, captures,
executables and run evidence without deleting them. `git add tools/qemu_q7`
therefore stages only source/scripts/configuration, this README and manifest.json
(unless files are explicitly force-added). Review with `git add -n tools/qemu_q7`.

Target scope is Q7_CERT_MODE=3 only: 16 frames × band_rows/depth_rows pairs (4,1)
and (8,8) × two lifecycles = 64 candidate frame visits. Corner-case tests are
additional. These target results do not establish all certificate modes or all
Q7 paths; the separately recorded host numeric/certificate suites are not an
all-mode target run.
