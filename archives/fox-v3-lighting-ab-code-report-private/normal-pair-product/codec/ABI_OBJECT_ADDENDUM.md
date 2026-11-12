# ABI, object size, and temporary stack addendum

This addendum measures the already frozen codec; no product source or existing ZIP was changed. It is a host compile/layout measurement, not a frame performance benchmark or a firmware fit test.

## Reproduction and scope

From this directory:

```
./abi-object-report/measure.sh
python ./abi-object-report/summarize.py
```

GCC 14.2.0, x86_64 host. The flags match the frozen actual-eyeB native renderer: `-std=c11 -O2 -Wall -Wextra -Werror -Wno-misleading-indentation -ffp-contract=off -fexcess-precision=standard`. `-fstack-usage` is added identically to old and new objects. No sanitizer, LTO, link, target compiler, or CPU timing is involved.

The four changed product files comprise two headers and two C translation units. Four relocatable objects were measured: original and candidate compact_opaque.o, original and candidate ksn_mesh_depth.o. Both headers were used in their corresponding ABI probes. Detailed section, symbol, unresolved-symbol, and compiler stack-usage outputs are in `abi-object-report/{old,new}`; machine-readable results are in `abi-object-report/summary.json`.

## Persistent control and storage

The complete ABI probe output is byte-identical: every size, alignment, field size, and field offset for all ten relevant structs matches. Both headers' complete struct declaration text also matches the original.

| Type | Original sizeof | Candidate sizeof |
|---|---:|---:|
| co_buffer | 32 | 32 |
| co_view | 24 | 24 |
| co_pixel_input | 32 | 32 |
| co_pixel_vertex | 64 | 64 |
| ksn_mesh_snapshot | 48 | 48 |
| ksn_mesh_pixel_snapshot | 64 | 64 |
| ksn_mesh_pixel_stats | 16 | 16 |

Snapshot scene prefix remains 416 bytes, storage cap remains 65,536 bytes, and no persistent codec setting/state field is introduced. Both measured translation units have zero `.data` and zero `.bss` before and after. Neither has an allocator reference before or after; the codec introduces no allocation, retained pointers, or additional persistent mutable storage. **Incremental persistent mutable state/control RAM is therefore 0 bytes for this change.** This does not mean that read-only code/constants or temporary stack usage are unchanged.

## Host object sections

`.rodata` totals below include all `.rodata.cst*` sections. Units are bytes.

| Object | Text old | Text new | Delta | Rodata old | Rodata new | Delta | Data/BSS old→new |
|---|---:|---:|---:|---:|---:|---:|---|
| compact_opaque.o | 5,314 | 6,037 | +723 | 64 | 68 | +4 | 0/0 → 0/0 |
| ksn_mesh_depth.o | 8,880 | 9,264 | +384 | 172 | 172 | 0 | 0/0 → 0/0 |
| Combined | 14,194 | 15,301 | +1,107 | 236 | 240 | +4 | 0/0 → 0/0 |

Combined `.eh_frame` is 1,720 → 1,704 bytes (-16). These are relocatable host sections, not linked executable/flash deltas. Read-only constants and executable mappings have a cost; their placement on a target is linker/platform-dependent and has not been measured.

## Temporary stack is not zero-cost

GCC's per-function own-frame reports (not including callees) show:

| Operation/function | Original | Candidate | Interpretation |
|---|---:|---:|---|
| Pixel record append implementation | co_append_pixel 144 | append_pixel 320 | +176 own-frame bytes in the shared new implementation |
| Pixel snapshot append implementation | ksn_mesh_pixel_append 528 | pixel_append 560 | +32 own-frame bytes in the shared new implementation |
| co_pixel_vertex_at | 112 | 128 | +16 own-frame bytes |
| co_read | 224 | 224 | unchanged |
| pixel_scene | 432 | 432 | unchanged |
| strip | 912 | 912 | unchanged, dynamic/bounded classification |
| pixel_render_extended | 592 | 592 | unchanged, dynamic/bounded classification |
| ksn_mesh_pixel_begin | 896 | 896 | unchanged |

New public append wrappers each report 8-byte own frames. **The old/default OFF entry points use the same new helpers, so OFF also bears these increased temporary frames; this is not an ON-only cost.** Full `.su` outputs preserve all remaining function reports, including some reduced accessor frames.

The actual O2 disassembly confirms all four wrappers only set the option/register arguments and directly tail-jump into the helper, with no stack allocation, push, or ordinary call. The compact wrapper+helper pair therefore does not keep two additional frames live: its own-frame estimate is 320 bytes; the snapshot wrapper+helper pair is 560 bytes. For a deliberately conservative sum that ignores verified tail-call elimination, the corresponding simple upper sums are 328 and 568 bytes. These bounds are **only for each wrapper/helper pair, excluding all callers and nested callees**. See `abi-object-report/new/append-wrapper-disassembly.txt` and the complete disassembly logs.

During snapshot append, the snapshot and record append implementations can be nested. Their own-frame estimates sum conservatively to 560 + 320 = 880 bytes, versus original 528 + 144 = 672 bytes (+208). This sum excludes validation helpers and surrounding callers; it is not a measured complete call-chain peak or an estimate of the renderer's total peak stack. Other branches such as scene validation can determine the actual maximum. The compiled target and its complete call graph would need separate analysis.

The increase reflects bounded temporary validation/remapping and decode work. It must be budgeted separately from owned snapshot bytes. No source change was made to optimize it after freeze.

## Limits

The previously predicted 6,372-byte wire saving is **not evidence of whole-product RAM fit**, even after actual C snapshot parity confirms it. The existing fixed 65,536-byte storage allocation remains the same unless a caller separately changes it; a smaller serialized payload by itself does not reclaim that allocation. Host BVH/visibility/transport memory, model/arena allocations, scratch/color buffers, call-chain peak stack, target ABI, linker sections, other firmware state, and Pocket lifecycle integration are separate costs. This addendum establishes no ESP32 or other hardware fit claim.

All four frozen candidate and baseline source hashes were rechecked unchanged. SOURCE_FREEZE.json remains SHA-256 `230140690027b5a775c328c9a50ef9d5c68b44c345539b740eb2d482697b5a4a`.
