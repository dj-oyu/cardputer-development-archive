# Exact shared shading experiment

Private isolated comparison, 2026-11-04. No original asset, image, character data, or private physical-lighting implementation is included. No approximation or precision-contract change is applied. These are candidate implementations, not production acceptance.

## Frozen inputs and variants

The baseline is the completed generic light-only candidate from the public-derived b10976a3 source family. BASE_SOURCE_FREEZE.json identifies every input. It is not the older all-node evaluator.

- baseline: repeated per-normal normalization/dot/powf for color A/B.
- candidate: compute front/back/spec/thin once per side, apply the unchanged channel arithmetic to both albedos, then copy two RGB565 colors together.
- candidate-bounded: the same arithmetic, with a noinline color helper to reduce caller code growth and live ranges.

Front and back SNORM values still use separate original rounding. Matrix inversion, normal normalization, powf, clamps, channel rounding and target/alias/failure rules are unchanged. No additional model/instance/arena storage or allocation is introduced. Temporary stack and code size are measured separately and can increase.

## Host verification

Authoritative whole-evaluator comparisons are results/paired-colors and results/bounded-colors. Both passed 8 A/B comparisons (O0/O2 and ASan+UBSan O0/O2, two independent fixtures), with 676 state comparisons and 604 complete RGB565 frame comparisons per candidate. Exact status, targets, full arena, native packets, harness-owned frame and production-raster pixels agree. Source/harness identity is frozen before and after every run. This does not test QuickJS, Blender, production submission/commit/repair, firmware linking or a physical device.

Both candidates passed separate shade-level stress in results/shade_stress and results/shade_stress_bounded: 775,078 paired cases per config, 8 configs (plain and separately instrumented O0/O2 plus ASan+UBSan O0/O2). Per run: 1,550,156 shared RGB565 comparisons, the same wrapper-output comparisons, and 3,100,312 float-term bit comparisons. Every digest is 292ef07cc5ef172f. Coverage includes all RGB565 albedos, 200,000 deterministic random pairs, extreme/subnormal directions, signed zero, grazing and opposing directions, fractional and boundary exponents, thickness boundaries and 27 asymmetric front/back SNORM ties.

Instrumented source-call counts per complete stress run: sqrtf 1,550,156 to 775,078; conditional powf 430,744 to 215,372; lroundf unchanged at 4,650,468. These are not machine instruction or cycle counts. The uninstrumented runs separately confirm exactness.

m32 was not run because the separate 32-bit libc/toolchain probe failed. LSan was explicitly disabled due to the sandbox ptrace limitation. ASan and UBSan ran and passed. No leak or target-platform pass is implied.

## Host code generation and memory

GCC 14.2 x86-64, -O2, FP contraction off, standard excess precision, no fast-math:

- GNU size aggregate text: baseline 28,420 bytes; candidate 29,876 (+1,456); bounded 28,668 (+248). This aggregate includes read-only data/unwind metadata, not just .text.
- Actual .text: baseline 27,004; candidate 28,476 (+1,472); bounded 27,196 (+192). .data/.bss remain zero.
- mesh_packet single-function .su maximum: 1,488 / 1,616 / 1,504 bytes; evaluator remains 1,152. Helpers have separate frames. These figures are not whole-call-chain peaks and must not be summed indiscriminately across sequential calls.
- Instance 168 bytes, model 128; fixture arenas 4,996 and 7,440 bytes in every variant. Tracked open/init/targets/evaluate allocations are zero. Persistent memory is unchanged, not reduced.

Default inlining expanded channel calculations inside mesh_packet. The bounded variant reduces that code growth and caller live-state cost. The isolated host pair kernel stores both RGB565 colors with one 32-bit store. That observation cannot be extrapolated to ESP32-S3, whose firmware flags suppress builtin memcpy. Actual target compile/disassembly is now complete; TARGET_RESULTS.md documents the external memcpy call and all other target findings.

Disassembly, exact build diagnostics and GCC IRA dumps are under analysis/host-assembly. Static instruction counts distinguish explicit %rsp memory operands from general-purpose %rbp uses, but cannot label all stack access as spilling or infer dynamic cycle counts. Arrays, call arguments, ABI saves and spills are different.

## Host timing observations

Seven alternating AB/BA rounds, 50,000 evaluations per stage/run. Ratios are median paired candidate/baseline; baseline already includes light-only reuse.

- candidate: mixed light 0.880 (range 0.848–1.085), full 0.928 (0.793–1.139); mesh light 0.854 (0.792–0.934), full 0.834 (0.796–0.961).
- bounded: mixed light 0.887 (0.735–0.973), full 0.923 (0.872–1.001); mesh light 0.848 (0.685–0.976), full 0.942 (0.772–1.052).

These are noisy host evaluator observations, not a direct statistically controlled ranking between the two candidates and not S3 or full-frame speedups. Source-call reuse is established; real target cost remains to be measured. No candidate is adopted on these timings alone.

## Reproduction and pending work

Use tests/run_matrix.py with explicit --baseline-dir, --candidate-dir and --output-dir. Both builds deliberately expect light-only counters. Use tests/run_shade_stress.py for the standalone shader comparison. Explicit LSan opt-out flags are described by each runner; it defaults to enabled.

The existing ESP-IDF 6.0.1 / Xtensa GCC 15.2 environment was used read-only for inputs, with all new compile outputs in a separate temporary directory. No install, settings change, original checkout mutation, public push, PR, CI injection or device operation is authorized by that comparison. A separate earlier GitHub publication was rejected before execution; this work has not retried or bypassed it.

## Separate live-range counterexample

A fourth tree, candidate-early-snorm, prepares the separately rounded back SNORM before front shading, allowing x/y/z/length doubles to die earlier. This achieves the intended lifetime shortening in emitted host code but does not improve host storage: relative to bounded, mesh .su grows 1504 to 1520 bytes and .text grows 27196 to 27260 bytes. A new descriptor-pointer spill and the extra short array offset the opportunity. It is retained as a counterexample, not chosen over bounded. All 8 production comparisons and a fresh 8-configuration shader stress pass. The first 3 frozen trees/tests are unchanged. See results/early-snorm/REPORT.md and analysis/early-snorm for exact code, hashes, assembly and limits.

## Actual ESP32-S3 outcome

See TARGET_RESULTS.md. The bounded model grows target object text by 106 bytes while retaining the same 1424-byte mesh caller frame. The known mesh-to-normal-helper frame sum increases by 16 bytes (1488 to 1504); total peak stack remains unmeasured. The target preserves the shared work but the paired-copy spelling adds an external memcpy(4) call, so a single final 32-bit store is not achieved. All target source/object manifests are verified; numerical runtime identity and cycles are unmeasured.

## Follow-up: typed final stores

A fifth isolated variant, candidate-typed-stores, replaces only the bounded variant's two final color copies with typed assignments after computing both values. New production and overlap tests pass, but host mesh stack grows 16 bytes and no host speed improvement is established. See TYPED_STORE_RESULTS.md. S3 comparison completed: the two added memcpy calls disappear, front fields become one s32i, back/pair use two s16i, and model text drops108 bytes with target local/helper frames unchanged. Target numerical execution and cycles remain unmeasured.
