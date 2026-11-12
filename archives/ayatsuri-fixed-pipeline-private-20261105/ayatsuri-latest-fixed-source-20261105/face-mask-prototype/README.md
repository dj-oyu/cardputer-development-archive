# Private fixed face-mask arithmetic experiment

This is supplied-data arithmetic only, not a renderer, adopted runtime asset, scene integration, performance measurement, or Cardputer output. No Blender/build/render script was executed. Original inputs are read-only and their pre/post hashes are checked. No device or public operation was performed. No visibility, ray, receiver selection, head transform, or material-color implementation is included.

## Identity and mapping

`encoding-report.json` records SHA-256 for the original `latest-fox-source-readonly/fox-bubble-bold.blend` (d15a3316…122c1a), latest 2k-v2 derivative (384ada0c…63fba8), optional candidate `fox-2d-brows-mouth-prototype.blend` (3e1035cb…02f8d), all eight PNGs, table metadata, scripts and state/spec files. Every relevant candidate input matches its existing MANIFEST.json. The original and derivative match the task's pinned identities. The workspace root is not a Git repository; no runtime/repository HEAD adoption is implied.

Read-only script evidence: extraction evaluates frame 1, resets source expression defaults, changes selected controls, then projects evaluated world-space vertices. Mask generation draws at 512x256 and downsamples to 128x64 L with Lanczos. Prototype creates `Face Ink Projection (head attached)` parented to `Head Pivot • driven`, captures inverse parent matrix and sets identity basis. Coordinates here must already be in **that projection object's coordinate frame**, not arbitrary mesh-local space or a historical GLB frame. Computing that transform is outside this experiment.

Material mapping read from render_prototype.py:
- Brow: x=[-.42,.42], z=[2.68,3.13], strict y<-.45.
- Mouth: x=[-.38,.38], z=[2.075,2.34], strict y<-.85.
- u=(x-x0)/(x1-x0), v=(z-z0)/(z1-z0). Top-origin image t=1-v.
- Existing candidate uses Non-Color R8, Linear interpolation, CLIP, and mixes ink into opaque receiver Base Color. It does not use the binary tables. Receiver object selection and material colors are not implemented here.

Table order: brow neutral, smile, stern, worried; mouth neutral, smile, stern, worried. Controls are neutral {}, smile {Smile:1, Brow Raise:.7}, stern {Brow Style:2, Brow Furrow:.6}, worried {Brow Style:1}. These are four discrete selected states, not arbitrary controls or interpolated expressions. Saved candidate is neutral. Existing 3D muzzle and Smile deformation remain outside this test.

## Exact representations

All 65,536 source pixels validate against independent decoded data.
- Raw R8: 65,536 bytes.
- Threshold >=128: 2,048 bytes, 128 pairs (inclusive first,last row) per mask, empty=(255,0). Exact for binary silhouettes only; loses partial coverage.
- Exact nonzero R8 runs: 18,655 bytes = 2,050-byte uint16 column-offset index + 16,605-byte triples (first row,length,value). At most 15 runs/column. Nearest lookup scans at most 15 records.
- Exact R8 column spans: **11,595 bytes** = 2,050-byte offsets + 9,545-byte payload. Each column stores first row, length, then every original R8 value through its last nonzero row, including any interior zeros and all partial edge values. Outside is zero. Direct nearest lookup: one indexed offset, two metadata bytes, range check, one indexed coverage byte. Bilinear uses four such lookups.
- Deduplicated span: **7,963 bytes** = 8-byte state-to-unique map + 1,538-byte offsets + 6,417-byte payload, six unique masks.
- Deduplicated RLE: 12,331 bytes = 8-byte map + 1,538-byte offsets + 10,785-byte payload.

Binary files are explicitly schema-bound payloads, little-endian uint16 indexes; they include no implicit C struct padding, header, checksum, or alignment. State map is [0,1,2,3,4,5,4,4]. Neutral/stern/worried mouth pixels and PNG hashes match. Deduplicated serialized files are offline decoded and verified at every pixel. The C sampler uses the simple eight-mask arrays; adopting dedup adds one state-map lookup and is not yet a C runtime feature.

These byte counts are read-only storage payloads (ROM candidates), not measured device memory. `sampler.c` compiles all three experiment representations, totaling 32,298 declared table bytes; `oracle-data.h` (65,536 bytes) is test-only. Deployment would select a representation rather than retain all. Read-only placement depends on platform/compiler. Sampler allocates no heap, holds an 8-byte transactional output temporary plus bounded scalar locals; exact stack/SRAM and compiler spills are not measured. Caller owns input and output buffers.

## C contract

`FaceQuery`: signed int32 x/y/z, mask 0..7, mode 0..3, frac 0/16/20/24. frac=0 is an explicitly separate millionths format; other frac values directly accept signed Q16/Q20/Q24. No hidden conversion through millionths is used for Q inputs. Decimal region bounds are exact integer rationals; comparisons multiply coordinates by 1,000,000 and bounds by 2^frac. Input coordinates must lie in [-16,16] in all axes. Unsupported frac/mode/mask, out-of-bound coordinates, null pointers or block counts other than 1/2/4/8 return -1 without modifying any output byte. Scalar is block1. Valid readable query storage and writable output storage are caller preconditions. Fixed trusted tables are generated and validated offline, not supplied by a hostile loader.

Modes: 0 binary nearest (0 or 255), 1 exact span nearest, 2 exact span fixed bilinear, 3 exact RLE nearest. Successful result is one coverage byte per query, never a color or transparency decision.

Domain policy deliberately declared: x0<=x<x1 and z0<z<=z1; outside gives zero. Gate uses the original strict rational inequality, with no epsilon. Nearest reads floor(128u), floor(64t). In bilinear mode, s=floor(128u*65536)-32768 and r=floor(64t*65536)-32768; floor division chooses the top-left tap, including negatives. Fractions are unsigned Q16, missing taps are zero. Four weights sum to 2^32; final coverage is nearest with half-up rounding. Boundary domain clipping happens before filtering, so edges can have half contribution and corners quarter contribution. This is a declared source-pixel model, **not Blender Linear/CLIP/SVM float32 parity**. It quantizes sample location downward by less than 1/65536 texel before filtering. No claim of exact unquantized bilinear equality is made.

The production math uses int64/uint64 only. Splitting ratio into quotient/remainder avoids multiplying a large Q-coordinate numerator by 65536. Inside the region, maximum remainder*65536 is below 9.24e17 (<INT64_MAX); coverage weighted sum is at most 255*2^32. No signed right-shift or signed left-shift of negative values is used. The independent test oracle uses __int128 direct rational formulas and the original uncompressed source pixels, not production pixel accessors or mapping helpers.

Raw R8 coverage, binary threshold, material blending, source-mask downsampling AA, bilinear texture filtering, and final screen AA are separate concepts. This experiment covers only the first two and explicitly declared texture filtering. Preserving 8-bit values preserves source texture samples, not final image AA or appearance under motion/deformation.

## Verification

Run `sh run-tests.sh` (Python/Pillow plus C11 GCC-compatible __int128 for test oracle). O0 and O2 builds use -Wall -Wextra -Wconversion -Werror and AddressSanitizer + UndefinedBehaviorSanitizer. Each passes **14,231,234 sample/group comparisons**, exhaustive 65,536-pixel representation verification, invalid-input output preservation, all texel boundary/center grids with +/-1 input tick, randomized queries and blocks across four coordinate formats, coordinate extremes, and **96 separate strict-gate probes at nonzero source pixels**. Blocks1/2/4/8 equal scalar/source oracle; this is grouping correctness, not SIMD or speedup.

LeakSanitizer initially failed at process exit because this execution environment uses ptrace. Reruns use ASAN_OPTIONS=detect_leaks=0; AddressSanitizer and UndefinedBehaviorSanitizer remain enabled. No leak-check pass is claimed. Tests and logs are private arithmetic artifacts; no practical performance or renderer correctness conclusion follows.
