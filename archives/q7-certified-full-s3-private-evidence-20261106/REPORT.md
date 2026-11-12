# Certified scalar Q7: private full ESP32-S3 OFF/ON build evidence

Outcome: BOTH complete ordinary-application compile/link builds succeeded, exit0. Both IDF app/bootloader partition checks, project flash-budget targets and explicit `tools/memlog.py --map <map> --check` passed. No device/flash/monitor/reset, target execution, source correction, public commit/push, package installation or security change occurred. Parent host numerical/lifecycle/review results were not rerun and are not target numerical evidence.

## Provenance

The original ZIP initial download and exactly one authorized fresh official retry failed technically with helper exit1 `library file transfer failed: download failed`; no destination/partial bytes, no exposed HTTP status and no reported access denial. TRANSFER_FAILURE.json preserves exact identities/attempts. No further archive retry occurred. Git fetch of unavailable local merge commit failed CONNECT503. Parent then expressly authorized verified public equal-tree source.

Actual input: native Library text libfile_fde3_f-cdc26e2462948191823f3632bfa732b7_6912d64812a8819193a206c2b1117894; file_00000000e74081f5a0f3436e2c0d14db v0. Full consecutive read coverage1..895, has_more=false, 65508B SHA256 ec346849f23c5058a3b475445f45003786c897874b6e6e692924388d326e436a. Restored declared line boundaries/final LF; exact patch61502B SHA2566455fe71e493fc521f32dff26ad88eb08fabc1aa79278f1d6fae491da43df7a7.

Official GitHub connector verified public commit724d97ade710c90ffbf219bf4589210f039ec1e3 and full recursive tree a4322fb9455d449fbe1eab8d8a6ef983761c14b8. All1871 base blobs matched Git content hashes. Existing verified public blobs reused only by matching identity;11 missing blobs retrieved pinned through official connector. Three unchanged pinned gitlinks/vendor caches preserved. This reproduces the exact tree of unavailable local31572d5f, not its commit object/metadata. Fresh private Git index, no synthetic commit. `git apply --check` and apply succeeded; all12 manifest files' bytes/SHA256/blobSHA1 and candidate tree e488ab1ed190111a7bacd380c89841c47e756cb8 matched. Rechecked all12 and every other tracked public blob after build; no tracked source/default/partition change. Original checkout and all older evidence directories untouched.

## Configuration, emitted flags, dependencies

IDF /workspace/.setup/esp-idf v6.0.1, clean commit8c19b156084a0753687347cca1f5355782893533. Installed GCC15.2.0: /workspace/.setup/espressif/tools/xtensa-esp-elf/esp-15.2.0_20251204/xtensa-esp-elf/bin/xtensa-esp32s3-elf-gcc. Exact version/compiler hash in TOOLCHAIN.json. Existing supported activation/export and pinned dependencies, IDF_COMPONENT_MANAGER=0. No downloaded/installed dependencies.

Fresh build-off/build-on. Exact argv in build-*.command.txt. `idf.py -C source -B <absolute-build> -D SDKCONFIG=<absolute-build>/sdkconfig -D PROJECT_VER=q7-cert-e488ab1e ... build size`.
OFF passes only Q7=OFF: actual cache Q7/PREPARED/EDGE4=OFF/OFF/OFF (ordinary defaults). ON explicitly ON/ON/OFF. Both invalid selections were separately configured and rejected, exit2: `Q7 certified requires prepared ON and edge4 OFF` (preparedOFF and edge4ON). No firmware compiled in invalid directories.

Full compile_commands plus selected exact argv/dependency hashes/response-file contents saved per arm. Real ON Q7, prepared and oracle-depth commands ALL end with `-O2 -fno-fast-math -fno-associative-math -fno-reciprocal-math -ffp-contract=off -frounding-math -fno-lto -fstack-usage`. GNU23 inherited, S3/windowed/LE ABI, response -mlongcalls and original warning policy preserved; no O3, relaxed guard or extra suppression. Actual macros: FLT_EVAL_METHOD0, float4/double8, windowedABI1, little endian, FINITE_MATH_ONLY0; no FAST_MATH. Config/generated partitions byte-identical between arms; config SHA25627da218b4eb39e0b7166e5a43b1a9134521146fda4b66c8cc8630f1d9d8955ac. PSRAM disabled, dualcore/UI core1, PGO OFF. PROJECT_VER labels source identity only. Existing unrelated unused-variable warnings and SDK FATFS bool notes retained in full logs.

OFF has no Q7/prepared TU or symbols. ON retains real q7 bytes/prepare/render/span, prepared and unchanged packet oracle fallback. No edge4/raw or host edge4-stat symbol/TU, no PIE in Q7 object. No LTO boundary introduced. Final nm undefined names identical in both: __cxx_fatal_exception, start_app, start_app_other_cores. These are forced `-u` IDF extraction names (installed cxx CMake95, esp_system91/94); no final relocations, no new strong Q7/prepared/classifier unresolved symbol. See full map/nm/readelf/object imports.

## libc/FPU contract and limits

Actual libc is PICOLIBC with newlib compatibility, not a newly substituted newlib. fegetround inlines installed machine/fenv-fp.h85..89: reads FCR low two rounding bits; FE_TONEAREST0. Final ieee_environment disassembly retains `rur.fcr`, branch on non-nearest, volatile double underflow multiplication, volatile float load and float-to-double conversion and comparisons. Both actual prepare/render call this function. Double arithmetic/conversion resolves to existing S3 ROM helpers (__muldf3 at40002418, __extendsfdf2 at400022a4, etc); fenv call itself has no undefined function. nextafter and llround resolve from pinned picolibc S3 no-rtti libc.a, full map archive-member attribution saved. Software64 division/remainder (__divdi3/__moddi3) is present in span setup; raw object imports captured. No unsupported flag/libc compile/link error.

This proves generated checks/available symbols, NOT runtime IEEE correctness. FCR controls the hardware float environment; these source/disassembly checks do not establish every ROM software-double helper's rounding/underflow behavior or every boundary conversion. Nearest/gradual-underflow probes are narrow runtime admissions, not exhaustive FPU/libc validation; arithmetic environment must remain stable throughout calls. No guard or fallback was bypassed. Target numerical/certificate correctness remains unexecuted. Q7 coverage and Q16 RGB remain APPROXIMATE relative to original float renderer; accepted certificates only aim to preserve frozen-Q7 F32 depth/ties/mask sign.

## Static images/memory

|Arm|App BIN B|IDF image B|Flash code B|Flash data B|DIRAM B|
|---|---:|---:|---:|---:|---:|
|off|2635696|2635576|1714576|816356|181120|
|on|2647232|2647108|1726108|816356|181280|

ON−OFF: BIN+11536B, flash-code+11532B, flash-data0, DIRAM+160B. IRAM text81687/vectors1028 and DRAM data21893 unchanged; BSS76512→76672. Both pass190KiB (194560B) static budget: margins13440/13280B. Linked DIRAM remainder160640/160480B out of341760 is NOT available runtime heap. Factory app offset0x10000/slot0x300000; BIN spare510032/498496B. No device layout or fit inferred. No PSRAM/full framebuffer added.

## Target ABI and dynamic accounting

Final ELF DWARF (not host sizeof): prepared header152B, triangle184B because edge4 OFF; certificate72B, Q7extra208B, Q7triangle464B, Q7header152B, Q7stats88B. co_vertex-derived/structure offsets retained in ABI_DWARF.json. Q7 count-sized snapshot=152+464*N: eight-face3864B/pair7728B;64-face29848B/pair59696B per surface. Two surfaces with max Q7 pairs119392B. Temporary prepared snapshot=152+184*N: eight1624B/max11928B, freed on successful Q7 prepare. Four full Q7 slots plus one max temporary prepared=131320B in normal all-Q7 setup (before allocator overhead). Candidate Q7 replacement frees its old candidate BEFORE allocating, so no third Q7 snapshot for that surface. Committed Q7 stays intact; ACK swaps pointers/capacities.

Prepared candidate can persist on fallback; prepared growth uses allocate-before-free, so old+new prepared can coexist. A deliberately pessimistic independent-capacity bound for all four Q7 capacities, all four prepared capacities, plus one fresh prepared replacement is179032B; this is NOT an observed/reachable aggregate peak proof and overcounts mutually successful paths. Source excerpts document each allocation/free, OOM fallback and ACK. Packet pools and their replacement fresh buffers, two proc frames per surface, image/DMA buffers, VM/models, task stacks and allocator overhead/fragmentation remain additional. Therefore no total runtime fit conclusion.

Shared depth scratch=240*rows*4 (960B rows1 or7680B rows8); Q7 owner scratch1920B (allocated lazily even rows1), so2880/9600B together. Owner scratch shared serialized renderer, not DMA loan. Snapshot/setup totals above EXCLUDE these; e.g. normal max all-Q7 setup+rows8 scratch=140920B, plus all other runtime costs. Fixed backend stats88B and pointer/metadata are already represented in static map. calloc under noPSRAM config; no new external allocator. UI task32768B core1 unchanged; CP stack reservation is existing OS overhead, no new PIE/CP state needed by scalar Q7.

## Own frames, not nested peak

```
/workspace/private-q7-certified-full-s3-20261106/source/main/pocket/pocket_shiki_frame.c:477:13:render_rows	64	static
/workspace/private-q7-certified-full-s3-20261106/source/main/pocket/pocket_shiki_frame.c:870:16:js_commit	128	static
/workspace/private-q7-certified-full-s3-20261106/source/main/ui/kasane/ksn_mesh_prepared.c:8:21:gouraud_make_edge	96	static
/workspace/private-q7-certified-full-s3-20261106/source/main/ui/kasane/ksn_mesh_prepared.c:22:8:ksn_mesh_prepared_bytes	48	static
/workspace/private-q7-certified-full-s3-20261106/source/main/ui/kasane/ksn_mesh_prepared.c:32:6:ksn_mesh_prepare	176	static
/workspace/private-q7-certified-full-s3-20261106/source/main/ui/kasane/ksn_mesh_prepared.c:142:6:ksn_mesh_prepared_render	224	static
/workspace/private-q7-certified-full-s3-20261106/source/main/ui/kasane/ksn_mesh_q7_certified.c:24:13:ieee_environment	64	static
/workspace/private-q7-certified-full-s3-20261106/source/main/ui/kasane/ksn_mesh_q7_certified.c:16:6:ksn_mesh_q7_span	64	static
/workspace/private-q7-certified-full-s3-20261106/source/main/ui/kasane/ksn_mesh_q7_certified.c:58:8:ksn_mesh_q7_bytes	32	static
/workspace/private-q7-certified-full-s3-20261106/source/main/ui/kasane/ksn_mesh_q7_certified.c:59:6:ksn_mesh_q7_prepare	368	static
/workspace/private-q7-certified-full-s3-20261106/source/main/ui/kasane/ksn_mesh_q7_certified.c:102:6:ksn_mesh_q7_render	304	static
/workspace/private-q7-certified-full-s3-20261106/source/main/ui/kasane/ksn_mesh_depth.c:115:6:ksn_mesh_render	384	static
```

Q7 prepare368B, render304B, environment64B; prepared prepare176B/render224B; oracle own frame retained in .su; render_rows64B, js_commit128B. Static frames contain local numeric/address-taken arrays and ABI argument homes; not every stack access is allocator spill. Nested libm/software-double/JS/renderer frames, register-window spills, task/TLS/context and ISR costs are additional; no worst-callchain/high-water measured. Final and object disassembly/symbol/literal tables retained.

## Deliverables and remaining gates

Evidence contains both actual full ELF/BIN/map/config/partitions, exact argv/response/spec/dependency/source hashes, objects/.su/full disassembly, ABI_DWARF, libc source excerpts, logs and verified generic patch/manifest. Hashes below. No source fix or target-code execution occurred. Build-generated flash suggestions were never executed. Runtime numeric/FPU environment, DMA/ACK on device, heap/stack peaks, cache/preemption and cycles/FPS/min20fps remain unverified. Source compilation is not production-safety or hardware compatibility proof. Host tests/review remain parent-provided separate evidence.

### off artifact identities

{
  "cardputer_pocketjs.elf": {
    "bytes": 21679772,
    "sha256": "675a36c456fafb6dc383f9f58d7e748ec6d67d0beef6a7f3773682ed9b267592"
  },
  "cardputer_pocketjs.bin": {
    "bytes": 2635696,
    "sha256": "5b267dc0584b980dcce06cc899ece0a2e5e3ada8094781b8bcb964aad5b643cb"
  },
  "cardputer_pocketjs.map": {
    "bytes": 12125317,
    "sha256": "1535fff976b86be87ebae4e5d151617563bfe4ced3b0b8721b15abf00ddd747f"
  },
  "sdkconfig": {
    "bytes": 76052,
    "sha256": "27da218b4eb39e0b7166e5a43b1a9134521146fda4b66c8cc8630f1d9d8955ac"
  }
}

### on artifact identities

{
  "cardputer_pocketjs.elf": {
    "bytes": 21758988,
    "sha256": "cea60750e98bf821e375322c46dcac19606cee51508ed5d46be46ec6ad4837dd"
  },
  "cardputer_pocketjs.bin": {
    "bytes": 2647232,
    "sha256": "013a7cee457be6a273671d88a8135d15bdc6924076a5813c1821fe5ee96119cc"
  },
  "cardputer_pocketjs.map": {
    "bytes": 12156772,
    "sha256": "0ea8debbbd3c747032a3ad000d6da5e532030615b7f0c9fb3edbdb208145862e"
  },
  "sdkconfig": {
    "bytes": 76052,
    "sha256": "27da218b4eb39e0b7166e5a43b1a9134521146fda4b66c8cc8630f1d9d8955ac"
  }
}

