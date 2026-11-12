# Typed final-color stores: bounded A/B

2026-11-04. This is one small successor to the exact shared-shading candidate. Control is candidate-bounded, not the original repeated-shader evaluator. Candidate is candidate-typed-stores. Only model.c's two final front/back color write blocks change. No approximate arithmetic, precision contract, failure check, output layout, ownership rule or persistent storage changes.

## Change and host correctness

Both RGB565 values are computed before either destination write. Front writes use declared color_a/color_b fields, and back writes use existing uint16 elements. No uint32 punning, wider alignment or restrict assumption is introduced. The independent source review found no new local correctness blocker. Existing raw-arena API effective-type requirements are not proved for arbitrary caller-declared byte arrays; tests use valid allocated/typed storage. Neither implementation promises atomic pair publication.

The new production matrix passes all eight A/B pairs: O0/O2 and ASan+UBSan O0/O2, mixed and mesh-only synthetic models. There are 676 state records and 604 full production raster frames. Exact arena, packet, status, failure/recovery states and RGB565 pixels match, as do full TSVs. Mixed output SHA256 is fa6a02b2e4a33bd86721085734e4c83b708d431b6769c7df137e3b1a9f22f2cc; mesh-only is 8dd8a880c333d60da7c3c4784ab3a833cc9cef5f66170bef952c82fab2ec5ee1.

A new independently built pair test runs the actual pair harness in separate control/candidate translation units with -fno-builtin-memcpy. Each of four strict-FP configurations tests 87,336 synthetic inputs, 1,746,720 pair calls, 3,493,440 exact output checks, and 24,454,080 surrounding-element checks. It covers identical input/output pointers, one-element overlap in either direction, disjoint buffers on either side, both uint16 index parities and 873,360 valid two-byte-but-not-four-byte-aligned output calls per configuration. All pass with digest cb0a1d5fd3f72de5. The reviewer independently reran O2.

These are new typed-store results, not inherited bounded test passes. The shader header remains byte-identical, with the previous standalone shader stress evidence preserved separately. No target numerical execution is implied. m32 was not run after its separate libc probe failed; LSan was explicitly disabled due to the sandbox restriction, while ASan and UBSan passed.

## Host cost

GCC14.2 x86-64 -O2, no fast-math, contraction off. The fresh bounded control's .text matches its earlier object exactly.

| Host metric, bytes | Bounded copy | Typed stores |
|---|---:|---:|
| Model GNU size text-class | 28668 | 28668 |
| Model executable .text | 27196 | 27196 |
| mesh_packet symbol size | 5144 | 5142 |
| mesh_packet individual .su | 1504 | 1520 |
| Pair text-class | 1322 | 1330 |
| Pair individual .su | 96 | 96 |

Terms/color helper frames remain 96/64. Model/instance/arena sizes, .data/.bss and tracked API allocations remain unchanged. Host temporary stack increases; total stack is not inferred from single .su values.

Host copy becomes one 32-bit destination store, whereas typed pair becomes two 16-bit stores. The latter does not reduce host destination-store count. Typed model holds the first front color in a spill slot across the second helper call; back color is retained in a saved register. It still preserves normal terms across calls. Static mesh instruction sites are 1067 to1051 and explicit rsp-memory sites224 to217; these are not dynamic instructions, spill totals or cycles.

Seven AB/BA timing rounds give paired typed/control median ratios: mixed light0.998, full1.009; mesh light1.015, full1.020. Ranges extend approximately0.827–1.257 across stages. This noisy experiment establishes no host speed improvement and is not evidence about ESP32-S3 speed.

## Target comparison

The isolated existing-toolchain comparison completed: ESP-IDF 6.0.1, Xtensa GCC15.2, actual GNU23/final-O2 firmware flags with -ffp-contract=off, -mlongcalls and -fno-builtin-memcpy. Four fresh objects were produced. The fresh control has the same allocated machine-code sections and code relocations as the previous bounded build.

| S3 static metric, bytes | Bounded copy | Typed stores |
|---|---:|---:|
| Model text-class including literals/rodata | 36896 | 36788 |
| mesh_packet executable section | 7234 | 7134 |
| mesh_packet individual frame | 1424 | 1424 |
| Pair text-class | 974 | 953 |
| Pair individual frame | 80 | 80 |

Data/BSS and helper frames are unchanged. The model's terms/color helper frames remain80/64. Thus the known mesh-to-terms compiler-frame sum stays1504, still16 above the earlier repeated-shader baseline1488. Neither local-frame equality nor this chain is a whole-stack peak measurement.

The two added final-color memcpy calls disappear from model (13 to11 static sites), and the pair copy disappears (1 to0). Existing decoder copies remain. Both colors finish before destination writes. For front vertex fields, the compiler keeps colorA in a7, packs colorB, and emits one aligned s32i at vertex+12. The back uint16 pointer and isolated pair use two s16i stores, respecting their weaker known alignment. Back writes are scheduled B then A, which is allowed for these ordinary nonvolatile stores; no atomicity or observed-order promise is introduced.

The typed pair no longer has the addressable colors temporary. ColorA stays in a7 across the second helper. Scalar preservation still exists: control thin/back/spec atSP32/36/40 changes to typed thin/spec atSP16/20; front/back terms also occupy preserved argument-independent registers. The outgoing thin slotSP0 and incoming output-pointer slotSP80 are ABI traffic, not spills. Do not infer a total spill count or cycles from these static observations.

This confirms a useful target-code improvement for this small change: fewer external calls and less object text without growing the existing target local/helper frames. It is not a measured target-speed claim. Host behavior differs and its stack increase remains a real measured tradeoff. No approximation was adopted.

The full private target bundle is libfile_e6d2fd16c8648191a2bc3a55b9bfd090 / file_0000000097ec8243832069e4d7f57131, version0, 10,022,355 bytes, SHA256 d60c24f35cc3b648f3dcb42ed4aa81cc060139cafc3bf55856fc88f74cd08016. The producing executor's byte-readback helper failed, but this executor then retrieved the saved bytes through the official Library materialization flow. ZIP hash, all93 manifest entries, all24 source files and the pair matched. Previously bounded reference objects included in the bundle also byte-match the earlier verified bundle. Independent review also matched 25,428 displayed instruction encodings and every saved call annotation to actual ELF bytes/relocations, and verified fresh control section/relocation equality. See delivery/TYPED_S3_EVIDENCE_VERIFIED.json and the independent review.

Runtime S3 numerical equality, cycles/FPS, linked layout/relaxation, register-window effects and whole-stack peak remain unmeasured. Exact commands and response contents are saved, but the full SDK/toolchain/configuration dependency closure is not bundled.

## Reproduction and identities

- Model SHA256 fb2595f220e47c02efc684fcd0ad4ba0da146eba99fd182e5aa25557eafa752c.
- Shader SHA256 535c7b47326d7251deeb2fff5cd0c2b4e61945f0579be53646ecd8c213d11719.
- delivery/typed-stores.patch SHA256 0f3d8855fdedd7a9af29cd4d4d3ece2c6596b250f0a4737b2d5223af6e5ffb4b.
- Pair SHA256 6ba28593e7963fed5f9901db57a065847be3030189dc957f09eba5ce659453e0.
- Production matrix: python3 tests/run_matrix.py --baseline-dir candidate-bounded --candidate-dir candidate-typed-stores --output-dir results/typed-stores --disable-leak-sanitizer --leak-sanitizer-disabled-reason 'Sandbox ptrace limitation; ASan and UBSan remain enabled.'
- Pair overlap test: python3 tests/typed-stores/run_alias.py.
- Host code generation: sh analysis/typed-stores/compile.sh.

Full source identities, build/run logs, model results, host assembly/IRA/reload and independent review are retained privately. Earlier frozen trees and tests match their starting hashes. New typed tests have separate directories. No original asset, image, character geometry, public publication, device operation or installation is part of this trial.
