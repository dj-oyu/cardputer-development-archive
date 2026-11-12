# Compact private face-mask sampler

This closes the previous offline-only deduplication gap: **the C sampler directly reads the exact 7,963-byte six-unique R8 span blob**. This is independent, supplied-coordinate arithmetic only. It does not implement a renderer, receiver selection, visibility, head transforms, arbitrary expression interpolation, or material color blending. No source model, previous prototype file, runtime, device, or public repository was changed.

## Frozen provenance

`prototype-frozen.sha256` is the unchanged earlier `face-mask-prototype/SHA256SUMS`. `prepare.py` verifies that entire frozen artifact set, original and current 2k-v2 model identities, optional 2D-face candidate identity, and source PNG/script/spec/state hashes before generating this sampler's data header. `bindings.json` records those hashes, the copied original sampler/header/test/oracle source bindings, and the exact blob hash. `encoding-report.json` is copied provenance from the broader prior experiment, not a statement that its other formats are included here. Original `face-mask-prototype/README.md` remains the detailed mapping/provenance reference, unmodified.

Candidate: `fox-2d-brows-mouth-prototype.blend`, SHA-256 3e1035cb2a2574d9ee1edcc3a30b5af82b0a479e4b877033f0552f8ffaa02f8d. Original fox: d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a. Latest 2k-v2 derivative: 384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8. None is a claim of runtime adoption or repository HEAD integration.

Coordinates must already be in `Face Ink Projection (head attached)` object's frame, parented by the candidate script to `Head Pivot • driven`, not an arbitrary mesh-local coordinate frame. Brow: x[-.42,.42], z[2.68,3.13], strict y<-.45. Mouth: x[-.38,.38], z[2.075,2.34], strict y<-.85. Full eight-mask order: brow neutral/smile/stern/worried, mouth neutral/smile/stern/worried. State-to-unique map [0,1,2,3,4,5,4,4]; neutral/stern/worried mouth is identical. Selected expression states only, with inherited spec hashes identifying exact controls/defaults.

## Compact byte layout and C lookup

`r8-unique-span.bin` and `compact-data.h` encode identical bytes:
- Offset 0: 8 one-byte state-to-unique table IDs.
- Offset 8: 769 little-endian uint16 payload-relative column offsets, **1,538 bytes**.
- Offset 1,546: **6,417 bytes** of spans. Each column record contains first row, length, then original coverage bytes within that span, including partial values and interior zeros. Outside the span is zero.
- Total: **7,963 bytes**, no header/checksum/alignment padding included or required by the format.

The C code reads both offset bytes individually and combines them, so it requires neither native-endian uint16 layout nor aligned uint16 access. It uses the state map before selecting a column. Nearest lookup loads the state byte, two offset bytes, two span metadata bytes and an in-span value, with bounds checks. Bilinear performs four source-sample lookups. These are structural lookup counts, not measured device performance. Embedded trusted schema-bound data is validated offline; there is no external arbitrary-blob loader API.

The production-equivalent translation unit includes **only** `compact-data.h`, not the raw oracle or alternative encodings. `oracle-data.h` is compiled into the test translation unit only. Sanitized test executables consequently contain test data; they are not the footprint artifact. The separately compiled unsanitized `sampler-host-O0.o` and `sampler-host-O2.o` are the isolated footprint artifacts.

## Sampling contract

API names/types and coordinate arithmetic inherit the prior experiment. Modes are now only **1 = exact R8 nearest**, **2 = declared fixed bilinear**; modes 0/3 and all others return an atomic error. frac 0 means explicit millionths, and frac 16/20/24 directly accepts signed Q16/Q20/Q24. Bounds/gates use exact decimal rationals without conversion through micro-units. All coordinates must lie in [-16,16]. Invalid mask, mode, frac, coordinate bound, null pointer or count returns -1 without modifying output. Scalar and block counts 1/2/4/8 use an 8-byte transactional temporary. Caller provides valid readable/writable storage. No heap allocation.

Mapping: u=(x-x0)/(x1-x0), top-origin t=(z1-z)/(z1-z0); nearest=floor(128u),floor(64t). Domain x0<=x<x1,z0<z<=z1, strict original Y gate. Outside is zero. Bilinear computes floor(128u*65536)-32768 and floor(64t*65536)-32768, floors tap indexes, zero-fills missing taps and rounds weighted coverage nearest/half-up. Sample location is quantized downward by less than 1/65536 texel before filtering. Domain clipping precedes filtering. This is **declared source-pixel arithmetic, not exact Blender Linear/CLIP/SVM float32 parity**.

All 8-bit texture values, including 4,767 partial-coverage pixels across eight states, are retained. Raw coverage, binary threshold, opaque material blending, source texture AA, texture interpolation and final screen AA remain distinct. This preserves source R8 samples, not a rendered appearance promise.

## Tests and host inspection

Run `sh run-tests.sh`. Both O0/O2 GCC 14.2 builds use -Wall -Wextra -Wconversion -Werror, AddressSanitizer and UndefinedBehaviorSanitizer. Each passes:
- **65,536 source pixels through the actual compact C nearest sampler**, compared with raw source pixels.
- **7,865,666 scalar/group comparisons** against inherited independent __int128 source-pixel oracle: texel centers/boundaries, +/-1 coordinate tick, direct Q16/Q20/Q24 and micro-units, random samples and blocks.
- 96 separate strict-gate probes at nonzero pixels; transactional invalid cases, untouched block tails and coordinate extremes.

The comparison count is smaller than the original because binary and redundant RLE modes were deliberately removed; nearest and bilinear retain the same boundary grids and random-block schedule. Group equality is not SIMD. ASAN_OPTIONS=detect_leaks=0 is inherited because LeakSanitizer is incompatible with this environment's ptrace; no leak-check pass is claimed.

Host inspection (`object-report.json`, `symbols-*`, `sections-*`, `undefined-*`, `sampler-host-*.su`):
- Both isolated objects contain one read-only table symbol `face_compact_blob`, size 0x1f1b = **7,963 bytes**; .rodata=7,963, .data=0, .bss=0. No oracle/alternate table symbols.
- O0 .text=1,915 bytes; O2 .text=1,245 bytes. Object sections also include host unwind/compiler metadata; neither number is a complete target firmware footprint.
- O0 undefined symbols: none. O2 undefined symbols: **memcpy**, introduced by the host optimizer for transactional output copying. Its implementation and stack cost are not included in this object's report.
- GCC per-function static stack reports: O0 valid/q16ratio/floordiv/pixel each16, sample176, face_block72, face_scalar32 bytes. O2 pixel8, face_block128, face_scalar8 bytes. These are individual host function reports, **not summed/observed call-chain peaks**. Inlining, ABI, compiler flags and external memcpy affect interpretation.

Table storage is a ROM candidate. Actual target section placement, working SRAM, stack peak, division/library costs, timing and performance remain unmeasured. No scene/renderer/visibility/query/device/public operations were used.
