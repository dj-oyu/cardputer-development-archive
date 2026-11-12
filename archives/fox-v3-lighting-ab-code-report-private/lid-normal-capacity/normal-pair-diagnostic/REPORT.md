# Conditional exact normal-pair capacity diagnostic

This is a private standalone diagnostic, **not a product codec implementation or adoption**. Frozen actual-eyeB producer/parser/core files were copied unchanged into a diagnostic harness. The only native adapter addition writes the already-appended owned snapshot after instance disposal/poison and binding checks, then exits before rasterization. No renderer, quota, precision, geometry, image reference, original file or public repository was changed.

Raw snapshots, encoded snapshots and copied private geometry/harness are private and must not be bundled. Only code/reports and non-geometry summaries are intended for saving.

## Existing format and exact condition

Scene prefix: 416 B, unchanged. Mode4 record: 12-byte header, 56-byte vertex, 3 bytes/triangle, ceil(T/8) side bits, zero padding to 4-byte alignment. Within each vertex, front SNORM16 is offsets44/46/48; independently stored back SNORM16 is offsets50/52/54.

Only if **every serialized vertex in the entire record** has back[k] == -front[k] in all three integer components may a diagnostic record omit the six back-normal bytes and use a 50-byte vertex. A single differing component makes the entire record fall back to its original 56-byte representation. No normalization, rounding, epsilon, or modification of independently quantized normals is performed.

Diagnostic tag 0xE4 is not a production wire-mode assignment. Decode restores original mode4, original record length, all back values, indices, side bits, record/triangle order, and original zero padding. Python uses struct byte offsets; standalone C uses byte loads/stores and memcpy, not potentially misaligned typed loads at 50-byte strides. Negation/comparison uses widened integers.

INT16_MIN is already invalid under the original product pixel validation. Synthetic INT16_MIN tests demonstrate overflow-safe comparison/rejection only; they do **not** imply that such input is accepted by the product. Any future writer must retain original invalid-input rejection. Primary fallback tests use a normal-range one-component change.

## Actual appended snapshots: all ten conditions, both orders

- 20 snapshots, each 65216 B; 51 records and 1066 serialized vertices each.
- All 20 dump FNV fingerprints match the corresponding frozen actual-eyeB metadata, and all work/record/size values match. Scene/core/compiled-model files are byte-identical. No new rasterization was needed.
- Every actual record is eligible: 51/51 per snapshot, 1020/1020 across the set. Every serialized vertex is eligible: 1066 per snapshot, 21320 across the set. Component mismatches: zero. Actual front INT16_MIN values: zero.
- Encoded size is **58844 B in all 20 snapshots**. Saving is **6372 B after alignment**, leaving **6692 B** under the unchanged 65536 B cap, versus current 320 B.
- Raw six-byte saving would be 6396 B; alignment reduces the total by 24 B. Per snapshot, 29 records have no adjustment, 17 save two bytes less, and five save two bytes more than 6×V.
- Decode produces the exact old full byte sequence in every snapshot, including 416-byte scene prefix, headers, record order, indices/side bits, and zero padding.
- Worst case when every record falls back: original **65216 B**, headroom **320 B**. This sample does not establish eligibility or guaranteed savings for other assets, poses, or future geometry.

`capacity-summary.json` records each frame/order and each record's eligibility counts and aligned size; it contains no vertex coordinates or raw normals. `dump-summary.json` pins private dump files. Independent reconstruction: `/tmp/normal-pair-capacity-independent.json` (reviewer verified all20 and re-ran seven tests).

## Regression tests

`test_prototype.py`: 7/7 pass. Tests cover all20 exact roundtrips, normal-range single-component change causing whole-record fallback, all51 fallback preserving all bytes/old size, no INT16_MIN wrap, compact invalid minimum rejection, truncation, empty records, wrong length/mode/reserved fields, unused side bits and nonzero padding. These diagnostic checks are not a complete product parser safety assessment.

## Standalone C codec CPU measurement

`codec_bench.c` independently implements the diagnostic byte codec; no product source is included. `measure_codec.py` compiles with the same host O2/precision flags used for earlier host runs. For each of the 20 exact snapshots, three alternating copy/encode/decode batches of 1000 operations use preallocated buffers, ten warmups per batch, a volatile consumed output byte on every operation, and full memcmp after each batch. The binary also verifies encoded bytes against the Python prototype and full decode against the original before timing. Input/code/binary hashes are checked before and after.

Across the 60 actual-data batches per operation, per-call nanoseconds are:

| Operation | Min ns | Median ns | Max ns |
|---|---:|---:|---:|
| Simple byte copy | 1153.624 | 1312.249 | 2888.947 |
| Diagnostic conditional encode | 7812.690 | 8874.309 | 12055.613 |
| Diagnostic decode | 6575.821 | 7682.423 | 9234.469 |

Two additional normal-range asymmetric fixtures were measured separately. Single-record fallback encodes to59036 B; all-record fallback encodes to65216 B. All C encoded outputs match the Python reference and every batch restores/consumes the expected bytes. Full per-fixture min/median/max, order, flags and pins: `codec-cpu-001/COMPLETED.json`.

These numbers are **standalone C diagnostic encode/decode versus simple copy**. They are not the product writer's incremental cost, not integrated raster/parser overhead, and not device timing. Product integration CPU and device performance remain unmeasured in this report. No added CPU claim is inferred from Python test runtime.

## Next boundary

The measured savings justify considering a separately authorized opt-in implementation, with original default behavior, invalid-input rejection, whole-record fallback, old-byte reconstruction, side/order semantics and unchanged quotas preserved. Integration and acceptance require their own lifecycle, parser, all-frame byte/pixel equivalence and performance tests; this diagnostic alone does not establish them.
