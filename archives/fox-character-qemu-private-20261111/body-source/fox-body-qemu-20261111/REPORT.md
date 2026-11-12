# Private 2k-v2 body QEMU native render

## Measured result
ESP32-S3 QEMU 9.2.2 with ESP-IDF 6.0.1/GCC15.2.0 completed two complete initialize/render/dispose lifecycles. Each rendered three selected source poses (0,31,63), two views, forward then reverse: 24 logged visits plus8 additional pause renders of pose31,32 body_frame calls total. All24 frame hashes match the identically adapted host harness. Six captured240x135 RGB565 frames compare byte-exactly with host (zero differing pixels). Pose31 is neutral and63 returns to neutral; the repeated neutral is deliberate, not a distinct extreme pose. No PSRAM.

The exact path is source-local DQ plus all-smooth normal reconstruction -> explicit coordinate-basis/winding adapter -> immutable AYNM/native geometry overrides -> compact frame-owned packets -> production ksn_mesh_render. This is only the454-triangle body of the1,982-triangle diagnostic derivative, not full fox, QuickJS, the higher Kasane compositor, original Principled/eye materials, or physical display/performance. See the separate host report for full64-pose coverage and Blender-input comparisons.

Initial evidence-v1 was intentionally interrupted when host visual QA found the source/native coordinate-basis mismatch. It is rejected evidence, retained for traceability. Final evidence-v2 was built only after the explicit basis plus winding correction. No production source or original blend changed.

## Actual target memory
- Internal-capability startup free318,300 B, largest253,952 B.
- Initialized/rendered free282,456 B, largest217,088 B, measured minimum282,456 B.
- Both final disposals restore free318,300 B and largest253,952 B, no per-lifecycle accumulation in this bounded native-only harness.
- Main task configured24,576 B; lowest recorded remaining stack HWM20,536 B. This is this exercised target workload, not an exhaustive production stack guarantee.
- IDF size: DIRAM106,860 B (.bss70,272, .data11,373, .text25,215); flash rodata75,336 B. Source fixture/model symbols are at0x3c... mapped flash addresses, not silently counted as RAM. Full symbols and size output retained.
- Body target arena34,996 B plus7 requested alignment bytes. Observed initialize/release internal heap delta35,844 B also includes allocator/runtime effects and is not an allocation-traced attribution. Target geometry descriptors184 B, snapshot capacity32,768 B, max used9,544 B. Other buffer sizes appear in BODY_MEMORY UART and host report.
- These are a minimal isolated native test. It omits firmware UI, QuickJS, drivers, scheduling and production allocations; do not add/subtract another firmware's ledger to infer fit.

## Reproduce
Use source qemu-esp32s3-20261111/idf-env.sh from the prepared official toolchain environment, or an equivalent IDF6.0.1/GCC15.2.0 setup. Build this project with an isolated absolute build path and isolated SDKCONFIG. It expects sibling qemu-render-20261111 at public828baa3af69c55e7884c53557ea39f91190010a0, fox-body-native-20261111, and provisional DQ/normal headers under hone-dq-converter-20261106.

Run run_qemu.py with --build, --output NEW_DIRECTORY, --qemu and --seconds300. It uses only a virtual flash file, -nic none, no monitor/display/socket, snapshot mode, and stops at FOX_BODY_QEMU_DONE. No USB/device commands are run. decode.py requires final UART, host O2 output directory and a new capture directory. Hashes in run-metadata.json pin binary/config/UART. QEMU elapsed time is not a real-device FPS metric.
