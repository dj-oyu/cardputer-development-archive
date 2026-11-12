# PRIVATE standalone Xtensa fixed-kernel probe: prepared, blocked

## Finding

**No target compilation or target frame-lint result was produced.** An already installed Xtensa GCC/objdump/readelf was not discoverable on PATH or in the checked standard Espressif/XTensa roots. IDF_PATH is unset. availability.json records exact tools/roots checked. This is bounded discovery, not proof that no compiler exists anywhere on the machine.

Missing dependency: an existing ESP32-S3-configured Xtensa GCC with matching binutils, its C standard-library headers and verified compiler/core/ABI provenance. No installation, device/broker operation, target execution, full firmware/renderer build, public transfer or source/admission/CI modification was attempted. The independent earlier host592B chain own-frame figure is **not** an ESP32-S3 measurement.

## Prepared capsule

capsule/ contains byte-identical private source copies of four independent translation units and their complete quoted-include closure (19 files):

- Final-only numeric kernel-chain compact.c.
- Compact eye material material.c, including the selected-Q generated tables.
- Integer control.c.
- Conditional supplied-branch radiance conditional.c.

The copied headers include integer light/normal, accumulator and profile API declarations needed to compile those TUs. No actual profile blob/shaper, profile implementation, model, geometry fixture, renderer or fabricated profile is included. Profile calls remain unresolved external symbols in the relocatable objects, intentionally. A compile-only test needs their declarations, not substituted definitions. The copied material tables remain private source-derived data; this capsule is not approved for public distribution.

prepare_capsule.py verifies its whitelist and quoted includes while copying. capsule-manifest.json pins every copy against its frozen original. Prior source files and build recipes remain unchanged. No copied C arithmetic or warning was altered. Python script syntax and quoted-include completeness were checked; neither is a C target-build success.

## Proposed matrix and exact flags

run_probe.py is prepared but **not executed**, because its prerequisite toolchain is absent. It would compile4 TUs ×Q16/Q20/Q24 ×Os/O2 =24 separate objects. Control.c does not depend on MBITS; repeated control objects are reference comparisons, not three different control algorithms.

Each compile command is:

    <verified xtensa-esp32s3-elf-gcc> -std=c11 -mlongcalls -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -fstack-usage -fno-lto -Os_or_O2 -DMBITS=16_or_20_or_24 -c <capsule_source.c> -o <new_object.o>

The four target code-generation flags `-mlongcalls -ffunction-sections -fdata-sections -fstrict-volatile-bitfields` are taken from the pinned upstream standalone-compilation description in docs/perf/o2-machine-code.md. C11 comes from the frozen host recipes; fstack-usage and fno-lto make this probe's measurement boundary explicit. These are **not recovered ESP-IDF firmware flags**, and no parity with firmware commands, headers, inlining, linker relaxation, placement or timing is asserted. No LTO, forced inlining/noinline, warning suppression, substitute header or source edit is used.

The script conservatively requires compiler `-dumpmachine` = xtensa-esp32s3-elf and windowed-ABI builtin evidence, records versions/default target options/builtins and preserves supplied toolchain provenance. A unified xtensa-esp-elf toolchain may be usable, but its actual S3-selection flags must first be verified separately; the script refuses to guess them. The upstream document's GCC15.2 version is evidence about that document's experiment, not a compiler present here.

Example invocation, only after an existing authorized toolchain and provenance are available:

    python run_probe.py --compiler /absolute/installed/bin/xtensa-esp32s3-elf-gcc --objdump /absolute/installed/bin/xtensa-esp32s3-elf-objdump --readelf /absolute/installed/bin/xtensa-esp32s3-elf-readelf --toolchain-evidence /absolute/path/to/verified-s3-toolchain-provenance.txt

This command is a plan, not a run log. The script rejects nonexistent tools, unconfirmed ABI/target and an existing target-results directory. It never installs or executes target output and never links a firmware or ELF executable. Real output would go only to target-results/ under this directory, preserving objects, .su files, disassembly, tool metadata and exact command records. Missing C headers or unsupported real flags would remain explicit build errors, not trigger stubs or altered-flag retries.

## Applying frame_lint without false success

An exact copy of upstream tools/frame_lint.py at branch claude/vigilant-einstein-capnag revision5898ac4e311d2e48d915b89fd11276b586d72447 is included under scanner/ and hashed. The independent scanner audit found heuristic false positives and a fail-open --check path. Therefore unmodified frame_lint is exploratory evidence only, not an admission/CI gate or a proven lower-bound counter. This capsule does not repair or assume away its instruction/control-flow limitations. The wrapper preflights input and disassembly, but that does not cure semantic false positives.

For each future object, the wrapper first requires successful readelf validation of Xtensa relocatable architecture and successful, nonempty parseable objdump output. It then calls frame_lint with the explicit matching objdump path, separately for each TU/Q/optimization. A missing tool, failed command, scanner stderr or SKIPPED report cannot become a clean measurement. Raw disassembly is retained for checking candidate functions manually.

No firmware baseline is applied to these standalone objects. The upstream baseline belongs to another build; duplicate function names across Q/optimization variants must not be flattened into one baseline. No baseline is written or admission gate changed here.

Future reports should compare compiler .su own frames, observed `entry a1,N`, heuristic far-address constructions/accesses, and exact instruction locations across Os/O2 at the same Q. Static object sites are **not execution counts or cycles**. A frame below1020B is not a proof of no far/derived accesses, and a report with no rows is not proof of total-stack safety. Nested callees, register-window spills, task stacks, cache effects and actual workload frequency are outside this object-only result. Firmware linking/LTO can change code further. Xtensa 64-bit multiply/divide helpers and all external/nested callees require separate call-chain and linked-library analysis; this probe cannot infer their stack or cycles from a caller object. A final firmware ELF and its actual build configuration are required for integration/layout conclusions, and even that is not a cycle measurement. The earlier host own-stack592B .su file is pinned for provenance only, not used as a target estimate.

## Stopping condition

The requested compile/analyze action is blocked on an unavailable discoverable target toolchain, not denied or attempted unsuccessfully. Source-only preparation is complete. There are0 target objects,0 final ELF files,0 target runs and no target stack/performance conclusion. A legitimate installed compiler path plus matching binutils/configuration evidence is the smallest missing input; no target-toolchain installation or broader access was requested by this probe.
