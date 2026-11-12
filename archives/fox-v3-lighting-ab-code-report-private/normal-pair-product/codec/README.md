# Private normal-pair pixel snapshot codec

Host-renderer-only, explicit opt-in lossless serialization. No publication, PR, device, flash, Pocket lifecycle integration, quantization change, or capacity change. This directory contains code and synthetic tests only. Actual geometry, source assets, screenshots, and actual snapshot dumps are intentionally absent.

## API and wire contract

- `co_append_pixel(buffer, input)` remains the default mode 4 writer. Every valid record is byte-identical to the frozen original writer.
- `co_append_pixel_normal_pair(buffer, input)` is the only new codec entry point. It writes mode 5 when all three back-normal components of every referenced, serialized vertex equal the promoted-integer negative of the corresponding front component. Any valid mismatch emits one complete mode 4 record. Unreferenced vertices do not determine eligibility or validity, matching existing compaction semantics.
- `ksn_mesh_pixel_append_normal_pair(snapshot, patch, vertices, bits, node)` exposes the same opt-in through the existing private host snapshot API. The existing begin/append functions and snapshot control layout are unchanged. There is no global flag or changed default.
- Modes 0/1/2 are unchanged, mode 3 stays reserved, mode 4 retains a 56-byte vertex, and mode 5 uses a 50-byte vertex. Mode 5 was unused in this record registry. The independent diagnostic tag 0xE4 is not accepted.
- The first 50 vertex bytes are identical to mode 4: x/y/mask/depth F32 at 0/4/8/12, raw RGB565 A/B at 16/18, world F64[3] at 20, and front SNORM16[3] at 44. Back normals are reconstructed with promoted integer negation. INT16_MIN remains invalid and is never silently accepted or negated into an unrepresentable value.
- The 12-byte record header, record/triangle order, used-vertex remapping, indices, selected side bits, reserved fields, and four-byte zero padding retain their existing meanings. Per-record length is aligned(12 + stride*used_vertex_count + 3*triangles + ceil(triangles/8)). Counts are bounded before arithmetic. Padding remains zero. A 50-byte stride is not naturally aligned; all floating-point and integer wire reads/writes are bytewise plus memcpy, never typed pointer dereferences.
- `co_read` accepts one complete record at the beginning of an available span, permitting following records. It requires the exact canonical length in that record's header, valid counts, finite fields, valid/nonzero normals, indices, unused side bits, and zero reserved/padding bytes. It publishes the view only on success. It rejects an overflowing input span or output overlap.
- Existing vertex, triangle, and side accessors accept mode 5 where mode 4 was meaningful. Pixel accessors accept only modes 4/5. Generic nonpixel rendering rejects both pixel modes, and pixel rendering rejects nonpixel records. Pixel rendering also checks the declared record count.
- Pixel append APIs reject source-source, source-control, and source-storage overlap before writes. Source fields and scene are copied; no source pointer survives append/begin. The source objects must be readable and stable for the duration of the call. Failed append preserves all destination bytes and metadata, including work accounting. Failed render keeps snapshot data and published stats unchanged; partial pixel/scratch output must be discarded, as before.

## Tests

Run from any directory:

```
./tests/run.sh [output-directory]
```

The runner compiles and runs at both `-O0` and `-O2` with GCC, AddressSanitizer, UndefinedBehaviorSanitizer, `-fno-omit-frame-pointer`, and `-ffp-contract=off`. It compiles a frozen copy of the original compact codec under renamed symbols to independently compare old output bytes. Existing unrelated misleading-indentation warnings are suppressed; other enabled warnings remain errors.

Coverage:

- 3,840 complete record comparisons across 3..32 source vertices and 1..64 triangles, alternating eligible records and valid single-component mismatches.
- Exact restored old-record bytes, decoded float/double bits (including negative zero and extreme finite values), masks, raw palettes, front/back normals, sparse used-vertex remapping, selected sides, order, and padding.
- Old default mode 4 and legacy modes 0/1/2 output byte comparisons, including sided palette reduction paths.
- Whole-record fallback for each component and mixed 4/5 snapshots; unused mismatched/nonfinite/INT16_MIN vertices are correctly excluded by existing used-vertex semantics.
- NaN/infinity, coordinate range, zero normals, legacy INT16_MIN rejection, malformed indices/counts/modes/reserved fields/unused side bits/padding/lengths, every truncated byte length, capacity and packet limits, overflow ranges, aliases, and atomic failures.
- Odd vertex counts, all record-start alignments 0..7, short direct accessor views, 168-byte opt-in capacity versus legacy/fallback rejection, and parser output rollback.
- Pixel snapshot forward/reverse records, exact same-order OFF/ON RGB565/depth/stats, copied scene and poisoned borrowed inputs, independent snapshots, work/capacity rollback, and pixel/nonpixel separation.
- Unmodified legacy pixel-renderer suite and opt-in visibility-binding suite, including snapshot fingerprint mutation, stale generations, retained/replaced visibility scene ownership, cumulative budgets, and alias failures.

LeakSanitizer cannot run in this sandbox because of its ptrace environment. `detect_leaks=0` disables only leak checking; ASan and UBSan remain enabled. No allocator was added to product code. This is not a firmware fit/performance claim. Actual all-v3 renders, snapshot budget confirmation, and renderer CPU measurements are separate integration work.

## Product changes

Only these four copied product files differ from frozen `fox-v3-eye-evaluation/actual-eyeB`:

- product/main/ayatsuri/compact_opaque.c
- product/main/ayatsuri/compact_opaque.h
- product/main/ui/kasane/ksn_mesh_depth.c
- product/main/ui/kasane/ksn_mesh_depth.h

`SOURCE_FREEZE.json` records their original and candidate SHA-256 hashes. Tests and borrowed generic renderer/visibility dependencies are local code only. No frozen baseline was edited.
