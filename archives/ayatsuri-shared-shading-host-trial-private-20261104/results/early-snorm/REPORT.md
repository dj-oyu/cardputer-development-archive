# Early back-SNORM live-range experiment

**Result: exact host outputs, but no host stack/code improvement. Keep as a counterexample; do not adopt over bounded on this evidence.** Only one new variant was made. `candidate-early-snorm` copies `candidate-bounded` and changes only `main/ayatsuri/ayatsuri_model.c`. The earlier three trees and tests are unchanged, verified by before/after whole-directory hashes.

## Exactness

- All 8 production pairs pass: O0/O2 and ASan+UBSan O0/O2, each mixed and mesh-only. Binary outputs and TSVs match. This covers 676 state records and 604 production-raster frames across configurations, including failure/recovery state. Both builds retain light-only counters.
- Mixed output: `fa6a02b2e4a33bd86721085734e4c83b708d431b6769c7df137e3b1a9f22f2cc`.
- Mesh-only output: `8dd8a880c333d60da7c3c4784ab3a833cc9cef5f66170bef952c82fab2ec5ee1`.
- The shader header is byte-identical to bounded, so its prior standalone stress evidence applies. A fresh complete run also passes all 8 plain/counted O0/O2 and sanitizer configurations: 775,078 cases each, digest `292ef07cc5ef172f`. It exercises the unchanged header; it does not independently test the new mesh-loop scheduling. The full production matrix tests that scheduling.
- LSan was explicitly disabled because this sandbox uses ptrace, which LSan does not support. ASan/UBSan remain enabled. No leak-test claim. m32 was not run: the separate multilib probe lacks `bits/libc-header-start.h`.
- Persistent storage stays unchanged: arenas 4,996/7,440 bytes, instance 168, model 128, zero counted API allocations, model object .data/.bss zero. This is not an all-RAM neutrality claim.

## O2 emitted result

GCC 14.2 x86-64; strict arithmetic flags below. A fresh bounded control has byte-identical .text to `analysis/host-assembly/bounded_model.o`.

| Metric | Bounded | Early back SNORM | Change |
|---|---:|---:|---:|
| GNU size text-class aggregate | 28,668 | 28,732 | +64 |
| Actual .text | 27,196 | 27,260 | +64 |
| mesh_packet symbol bytes | 5,144 | 5,208 | +64 |
| mesh_packet .su maximum | 1,504 | 1,520 | +16 |
| mesh steady frame, including saved registers/return address | 1,472 | 1,488 | +16 |
| terms preparation .su | 96 | 96 | 0 |
| color helper .su | 64 | 64 | 0 |
| evaluator .su | 1,152 | 1,152 | 0 |
| Static explicit rsp-memory instructions in mesh | 224 | 223 | -1 |

GNU size text-class includes read-only/unwind sections, not only executable .text. Read-only constants and .eh_frame remain unchanged. Early mesh has 1,069 static instructions versus 1,067 bounded, with 21 call sites in each. Static rsp-memory counts exclude LEA/NOP and do not assume rbp is a frame pointer; they are not spill counts, dynamic traffic, or cycles.

At the checked shader calls, mesh plus terms helper is 1,584 bytes (bounded 1,568); mesh plus color helper is 1,552 (bounded 1,536), before library callees. Sequential helper frames must not be summed together. This is not a whole-evaluator or interrupt-aware peak.

## What actually happened to the live ranges

Addresses below refer to `analysis/early-snorm/{bounded,early}_model.asm`.

- Bounded keeps x/y at rsp+0x380, z at +0x390, and length at +0x8 across front calls 0x1310/0x1354/0x1384. Back quantization then reloads the doubles at 0x13dc and 0x13fb.
- Early branches at 0x12ca to the sided-only back loop 0x1500–0x15a3, then jumps at 0x15ae back to front shading. It therefore consumes x/y/z (rsp+0x390/+0x398/+0x3a0) and length (rsp+0x0) before front calls 0x131a/0x135f/0x138b. Length's slot is reused for a float term at 0x1332. No normal double is needed after those calls on the current vertex.
- Front shorts occupy rsp+0x1d0; separate back shorts occupy +0x210 and survive the front calls. The later back preparation at 0x144f receives the precomputed back array. The intended 32-byte double lifetime reduction is real, but the compiler retains/rearranges stack slots rather than reducing its fixed frame.
- A concrete new allocation spill is the descriptor pointer: early saves rbx at rsp+0x30 at 0x14f2 and restores it at 0x15a9 around back quantization. The verbose assembly identifies it as `_411` / `%sfp`, and its subsequent +14/+16/+18 byte loads identify the mesh descriptor. Bounded instead keeps that pointer in r15 and has a 4-byte packed-front-color spill/reload at 0x13d2/0x1492 around its later back loop. Thus spills change; they do not simply vanish. Both variants still save/reload the four float terms across the first color call. No global spill total is inferred from the compiler logs.

The front quantization, its existing nonzero validation, and all negative-double operations, floor/clamp/casts are unchanged. Back shorts are computed only when sided; there is no back rejection or negation of rounded front shorts. Shader and color-store order stays front then back. Moving back quantization changes the timing of floating exceptions/errno relative to front shading; enabled traps/intermediate observations are outside the validated output contract.

## Source identity and reproduction

- baseline model SHA-256: `bf1ba06d55f9029b5c95981087cc3ee40651523759d6e044538a5d4f6c999864`.
- candidate-bounded model SHA-256: `8e4217e57e12568094c0443e022df74d712ef8bcd215ba7a74bef154bd0c0c89`.
- candidate-early-snorm model SHA-256: `0d88020bc43cbf4b380971ebfa736688f260336595d61c0a8bb157e5a680a990`.
- Bounded and early shader SHA-256: `535c7b47326d7251deeb2fff5cd0c2b4e61945f0579be53646ecd8c213d11719`.
- Patch SHA-256: `8c9b8d4bea4d6d282f6f4e56b62b1a7b5db87c93bbbf99d526323f974d791b10`.

Complete source hashes, protected-tree snapshots, paired TSV checks, and emitted metrics are in `analysis/early-snorm/source-identities.json`, `frozen-inputs-{start,end}.json`, and `metrics.json`. Full run evidence is in `matrix.json` and `shade-stress/stress.json`; all output binaries are preserved.

From the experiment root:

```sh
python3 tests/run_matrix.py --baseline-dir baseline --candidate-dir candidate-early-snorm --output-dir results/early-snorm --disable-leak-sanitizer --leak-sanitizer-disabled-reason 'LeakSanitizer is disabled because this sandbox uses ptrace, which LSan does not support; ASan and UBSan remain enabled.'
python3 tests/run_shade_stress.py --baseline-dir baseline --candidate-dir candidate-early-snorm --output-dir results/early-snorm/shade-stress --disable-leak-sanitizer --leak-sanitizer-disabled-reason 'LeakSanitizer is disabled because this sandbox uses ptrace, which LSan does not support; ASan and UBSan remain enabled.'
sh analysis/early-snorm/compile.sh
python3 analysis/early-snorm/count_static_instructions.py
```

The compile script records commands with `-std=c11 -O2 -ffp-contract=off -fexcess-precision=standard -fno-fast-math -fstack-usage -fdump-rtl-ira -fira-verbose=10`, dumps disassembly and size/stack evidence, and builds a fresh bounded control. `delivery/early-snorm.patch` is the small unified patch relative to bounded. Apply only to a fresh copy of bounded, not to a frozen input.

The runner also records noisy host timings versus baseline. They are not a direct bounded-versus-early timing experiment and do not rank these two variants. No target compiler/device result, target speed, original/private asset, install, remote write, or CI change is part of this experiment. The separate target comparison of the first three variants is not affected. No operation was denied or left uncertain. Stop after this one tested candidate.
