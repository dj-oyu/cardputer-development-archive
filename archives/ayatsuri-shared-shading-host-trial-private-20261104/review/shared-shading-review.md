# Independent review: exact shared mesh shading

Reviewed 2026-11-04. Scope: the three frozen local generic/public-derived trees, supplied synthetic tests, recorded host outputs, fresh independent host builds, and existing x86-64 disassembly. No product source or supplied test was edited. No original model/image/private asset, device, install, or network write was used.

## Decision and remaining blockers

**No correctness blocker found for the documented strict-IEEE host configuration.** Both candidates preserve the checked output, including failed-evaluation state and exact production raster pixels. The bounded candidate has substantially less host code/frame growth than the fully inlined candidate and is the better of these two host candidates to carry into target evaluation.

This is not target-release or speed approval. These claims remain blocked or unverified:

- **Target behavior/performance:** this review has no target compiler output, linked firmware map, target stack watermark, target cycles, or device result. The parent reports an S3 compiler comparison is underway separately; it is not incorporated here.
- **All-RAM neutrality:** arena, instance/model storage, allocations, and model object writable static storage are unchanged. Stack usage is not generally unchanged. Host `.su` files are individual-function figures, not whole-call-chain peaks; a source-level term struct does not establish a RAM saving.
- **32-bit host:** not run because the independent multilib probe cannot find `bits/libc-header-start.h`. This is a toolchain limitation, not a tested pass or code failure.
- **Leaks:** LSan was explicitly disabled for the stated sandbox/ptrace limitation. ASan and UBSan passed; no leak-test claim is supported.
- **Reproduction documentation:** `tests/README.md` is still the earlier light-only README, names the older public commit as baseline, and lists only four test sources. For this experiment the correct baseline is the frozen already-light-only tree in `BASE_SOURCE_FREEZE.json`; the README should distinguish it and include the stress-test workflow before publishing this experiment.

No operation was denied or left in an uncertain execution state during this review.

## Source identity and independent evidence

The actual differences are exactly:

1. `baseline` → `candidate`: `main/ayatsuri/ayatsuri_shade.h` introduces preparation of four float terms, a color evaluator from those terms, and a compatibility wrapper. `main/ayatsuri/ayatsuri_model.c` shares terms for A/B on each side and copies the resulting two colors together.
2. `candidate` → `candidate-bounded`: only `ayatsuri_shade_from_terms` changes from `static inline` to `static __attribute__((noinline))`, plus a comment.
3. Model types, arena sizing, validation, dispatch, counters, raster source, and all other product files remain unchanged.

The baseline hashes were independently checked against all 12 entries in `BASE_SOURCE_FREEZE.json`. Current source, harness, and fixture hashes match both completed production matrices. The stress reports' current source/harness hashes and per-configuration JSON run logs were also independently checked, rather than accepting their PASS labels alone.

`review/verify_review.py` is a separate review-only verifier. It checked all 16 recorded production A/B fixture pairs byte-for-byte and compared their TSVs; then built all three product variants afresh at O2 and ran both full-production fixtures for each. It also built and ran fresh uninstrumented O2 stress executables for both candidates. All checks passed. Its machine-readable result and build/run logs are in `review/recheck/verification.json` and adjacent files.

The exact output hashes are identical across O0, O2, ASan+UBSan O0/O2, both experiment suites, and the fresh O2 builds:

| Fixture | Binary bytes | SHA-256 |
| --- | ---: | --- |
| mixed | 6,574,028 | `fa6a02b2e4a33bd86721085734e4c83b708d431b6769c7df137e3b1a9f22f2cc` |
| mesh_only | 6,674,257 | `8dd8a880c333d60da7c3c4784ab3a833cc9cef5f66170bef952c82fab2ec5ee1` |

The mixed fixture records 86 states and 77 raster frames with 6,005 harness checks per run; mesh-only records 83 states and 74 raster frames with 5,700 checks. The binary records include complete arena bytes, input/cache lighting/camera state, status and evaluated state, packet metadata/storage, copied frames, and all 240×135 RGB565 pixels. Work counters are checked by the harness and exact matching TSVs. The renderer is the real production `ksn_procedural.c`, with production `ksn_mesh_depth.c` for sided runs. The harness serializes native packets itself; it does not exercise the JavaScript submission layer.

## C and numerical review

### Term splitting and rounding

The original normal conversion, normalization, dot expression order, `fmaxf` operations, conditional `powf`, and thickness arithmetic are copied unchanged into `ayatsuri_shade_terms_prepare`. All four outputs are floats, as were the original locals. No double intermediate, reciprocal approximation, material change, reassociation, LUT, or approximate power is introduced.

`ayatsuri_shade_from_terms` retains the original RGB565 extraction, channel expression, clamping, `lroundf`, shift/OR packing, and casts. The material exponent remains validated in [1,128]; other material coefficients and light RGB remain validated in [0,1]. The `front > 0 && nh > 0` short-circuit condition is unchanged. The fallback when the half-vector cannot be normalized is unchanged. Signed zero is not rewritten by a new shortcut.

The paired initializer need not execute its A and B calls in textual order under C's initializer evaluation rules. That does not change the promised output: the functions only read the supplied material/light/terms and produce independent colors, with no writes to shared model state. They finish before the pair is copied. The source API documents IEEE arithmetic, contraction off, and no excess precision. The experiments use those flags; this review does not extend bit-exactness to fast-math, different excess precision, enabled floating traps, or observation of intermediate floating exception/errno timing.

The compatibility `ayatsuri_shade_sample` still computes the same single color. The bounded header uses a compiler extension already used by the unchanged `mesh_packet` boundary, so it does not newly introduce a different compiler portability requirement within this source tree.

### Front/back normals

Front SNORM generation still uses double `component * 32767 / length + 0.5`, floor, clamp to [-32767,32767], and then `int16_t`. Front nonzero validation is unchanged. Back SNORM is independently quantized from the negated double component, not obtained by negating rounded front shorts. Terms are prepared separately for each side; the two albedos share only their own side's terms. This preserves the important asymmetric half-tie behavior.

### Paired memcpy bounds and aliasing

The front copy starts from the byte address of the entire `ksn_proc_gouraud_vertex` plus `offsetof(color_a)`, not from an incorrectly widened `uint16_t *` subobject store. It copies exactly two `uint16_t` values (four bytes). The existing binary32 size assertion and 16-byte vertex layout assertion leave the three floats followed by the adjacent two 16-bit colors, so this copy reaches exactly `color_a` and `color_b`, not the following vertex. Native value representation is preserved; this is not a new endian conversion. The model already rejects unsupported endianness.

For the back copy, `v < nv`, with validated `nv <= 32`. The allocated sided tail includes `4 * nv` bytes of back colors, followed by eight bytes of face bits and alignment padding. `mesh_back_colors(...) + 2*v` therefore has four valid destination bytes for every iteration. The stack source array does not overlap either destination. `memcpy` avoids a new alignment or type-punned wider-store assumption. Paired writes add no lifetime escape or retained pointer.

An explicit offset adjacency assertion could document the new copy assumption more locally, but the current layout constraints already establish it for the supported format; this is not a blocking defect.

### Failure/publication behavior

No error check or return is removed or moved in either current candidate. Normal/projection validation and front nonzero rejection precede shading as before. Shader calls have no status failure path under the validated input contract. Delaying color A's store until color B is computed therefore does not remove an ordinary observable partial-failure state. Subsequent vertex/hole failures still leave `evaluated == false`, and prior owned frames remain separate and unchanged. The matrix covers failures and recovery, stale owner/generation, busy state, invalid light/camera/targets, overflowing transforms, target invalidation, copied-frame preservation, and disposal. It verifies exact arena state on recorded failed evaluations as well as successful output.

Concurrent observation or trapping mid-shader is not an API guarantee; paired copies should not be described as an atomic-publication guarantee.

## Stress-test coverage and limits

Both `results/shade_stress` and `results/shade_stress_bounded` have all eight required configurations passing: plain/counted at O0 and O2, then plain/counted under ASan+UBSan at O0 and O2. Each configuration processes 775,078 cases, with:

- 1,550,156 paired-color comparisons against the unchanged frozen shader;
- another 1,550,156 compatibility-wrapper color comparisons;
- 3,100,312 bitwise term comparisons and 5,425,546 basis/half-flag checks;
- common digest `292ef07cc5ef172f`, independently reproduced by both fresh O2 builds;
- 43,056 directed cases, 524,288 exhaustive-color cases, 282 channel rounding-boundary cases, 7,452 separately quantized front/back tie cases, and 200,000 deterministic random cases;
- all 65,536 RGB565 values in both color slots across eight scenarios, exponent endpoints/fractional values, thickness extremes, grazing and axis normals, subnormal through maximum finite directions, opposing/near-canceling half vectors, and 27 tie pairs whose rounded backs are not integer negations of their fronts.

The unchanged frozen shader is the final-color oracle. The independent term oracle copies the original arithmetic ordering and checks the new split's four output bits; it is a differential oracle, not an independently specified physical lighting model. Counted builds establish source invocation reuse, while separate plain builds avoid treating instrumentation as production compiler behavior.

Instrumented totals per configuration:

| Call | Baseline | Shared candidate |
| --- | ---: | ---: |
| normal `sqrtf` | 1,550,156 | 775,078 |
| conditional `powf` | 430,744 | 215,372 |
| channel `lroundf` | 4,650,468 | 4,650,468 |

These are source-call counts excluding basis preparation and oracle calls, not retired instructions or cycles. Not every RGB565 pair/material/normal tuple is exhaustive. The production fixtures use four vertices and two triangles per mesh with one common material coefficient set, not maximum-sized 32-vertex meshes or arbitrary scene contents. Numerical breadth comes from the separate stress test; transformed pipeline coverage comes from the production matrix. There is no target, QuickJS, Blender, or private-asset integration evidence in this review.

## Storage, code size, and assembly

Persistent storage is unchanged in all recorded and fresh production runs:

- mixed arena: 4,996 bytes; mesh-only arena: 7,440 bytes;
- host instance: 168 bytes; host model descriptor: 128 bytes;
- counted API allocations: zero;
- model object `.data` and `.bss`: both zero for all three O2 variants;
- same source types and arena-size expressions; no per-vertex retained normal/term cache.

Use **“no additional persistent arena/heap/static writable storage”**, not an unqualified “no additional RAM.” Host x86-64 GCC 14.2 O2 measurements are:

| Metric | Baseline | Candidate | Bounded |
| --- | ---: | ---: | ---: |
| GNU `size` text-class total | 28,420 | 29,876 | 28,668 |
| actual `.text` section | 27,004 | 28,476 | 27,196 |
| `.eh_frame` | 1,072 | 1,056 | 1,128 |
| `mesh_packet` `.su` maximum | 1,488 | 1,616 | 1,504 |
| evaluator `.su` | 1,152 | 1,152 | 1,152 |
| original sample helper `.su` | 112 | absent | absent |
| terms preparation helper `.su` | absent | 96 | 96 |
| color-from-terms helper `.su` | absent | inlined | 64 |

Read-only constant sections are unchanged. GNU `size`'s text-class number includes non-executable read-only sections: it is not the `.text` section alone. Actual `.text` growth is +1,472 bytes for candidate and +192 bytes for bounded. O0 mesh `.su` grows 1,104 → 1,136 in both candidates, so the bounded O2 outcome is not a compiler-independent storage result.

The O2 assembly confirms ordinary candidate inlines channel calculation into `mesh_packet`, while bounded makes four calls to the color helper across the front/back paths and two terms-preparation calls. Baseline has four sample-helper call sites. This establishes the emitted call structure for this host object, not how frequently a branch executes or the target's structure.

The ordinary mesh steady frame is 1,584 bytes, baseline 1,456, and bounded 1,472, including saved registers and incoming return address. Their larger `.su` maxima also include bounded outgoing-argument stack use on other calls. At the checked shader call sites, baseline mesh + sample is 1,456 + 112 = 1,568 bytes before library callees; bounded mesh + terms preparation is 1,472 + 96 = 1,568, and bounded mesh + color helper is 1,472 + 64 = 1,536. The two bounded helpers run sequentially, so their frames must not be summed together. This explains why a new 64-byte helper does not itself prove a higher shader-path peak. It also does not prove whole-evaluator peak neutrality: other call paths, linked libm frames, target ABI, and interrupts require separate accounting.

`%rbp` is demonstrably not a dedicated frame pointer here. For example bounded `shade_from_terms` assigns `%rdx` to `%rbp` at 0x316 to address material data, and mesh code uses `%rbp` for pointers and packed colors. Therefore counts that classify every `(%rbp)` operand as a stack access are invalid. Counting only explicit `%rsp` memory instructions and excluding LEA/NOP yields 210/274/224 static mesh instructions for baseline/candidate/bounded, respectively. These are incomplete static stack-reference counts, not spill counts or dynamic traffic; some stack addresses are carried through other registers. The IRA dumps are useful corroborating compiler artifacts, but this review derives no total spill count from grepping them.

Recorded seven-round paired timing medians suggest reduced host evaluation times, but ranges overlap or occasionally regress and the two suites were run at different times. They do not reliably rank bounded versus ordinary candidate or establish target cycles/FPS. For bounded, paired median candidate/baseline ratios are mixed light 0.887, mixed full 0.923, mesh light 0.848, mesh full 0.942; mixed full reaches 1.0006 and mesh full 1.0516 in individual rounds. Treat timing as supporting experimental data only.

## Assessed next experiment: shorten double lifetimes

The parent's proposed next idea is supported by the current bounded host disassembly, but was not implemented here. In `bounded_model.asm`, length is stored at `%rsp+0x8` (0x11b8), x/y at `%rsp+0x380` (0x11ff), and z at `%rsp+0x390` (0x11e4). Those 32 bytes survive front terms/color calls at 0x1310/0x1354/0x1384 and are loaded again in the back-quantization loop at 0x13dc/0x13fb.

Preparing separate front and back SNORM arrays before the first shading call could end those double lifetimes earlier. Required semantic constraints:

1. Preserve front quantization and its existing nonzero check first.
2. Prepare back only for sided meshes, with the same separate double expression and floor/clamp. Do not use negated front shorts or change multiply/divide order.
3. Keep separate front/back arrays and do not add a new rejection that changes existing status behavior.
4. Keep the same shading and publication order after quantization; rerun both numerical and full production exactness matrices.

No ordinary validated-input output obstacle was found beyond changed floating exception/errno observation timing. Two three-short arrays add six bytes relative to the current reused array, while shortening 32 bytes of double liveness. Stack slot reuse, alignment, other simultaneous scratch, and register allocation can offset or erase that opportunity; **no byte saving or speed gain is claimed without an actual compiled variant**, and no target claim follows from this host observation.

## Recommended disposition

Keep current sources frozen for comparison. Carry bounded as the preferred host candidate into the separate target compiler/stack/code review, retain ordinary candidate as a useful control, and correct the stale reproduction README. Any later live-range experiment should be a separately hashed variant with its own exact-output/stress/stack evidence. Merge or release decisions should use the actual target flags and linked artifacts, not source libm-call reductions alone.
