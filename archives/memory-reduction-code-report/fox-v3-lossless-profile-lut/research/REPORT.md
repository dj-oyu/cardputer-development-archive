# Lossless independently indexed 65³ AgX LUT study

## Result and scope

Selected **cube4 adaptive Rice/fixed-width predictor codec**, total **445,248 bytes** including every channel header, 19,656-byte uint32 offset index, and 32-byte global header. Raw LUT is 1,647,750 bytes. This saves 1,202,502 bytes (72.98%). The previously measured **544,048-byte factory partition remainder** would leave **98,800 bytes before new decoder text, other RO, alignment, and linking**. That remainder is illustrative, not a firmware-fit result. Baseline inputs were not modified; no original image, model, or scene reference was used.

All 823,875 uint16 values were verified exactly in Python for every custom codec/layout. C channel decoding and the stateless random vertex fetch separately matched all 274,625 vertices (823,875 uint16 values). Evaluator/renderer correctness, Xtensa text/stack, target performance, and firmware partition fit are outside this study.

## Frozen finite experiment

Layouts: cube4, cube8, cube16, line64, line256 only. Each channel chooses the shortest record, with ties preserving enumeration order: minimum fixed-width; then first-difference fixed-width and Rice k0..16; second-difference fixed-width and Rice k0..16; Lorenzo fixed-width and Rice k0..16. The fixed-only family omits Rice options. zlib9 raw-channel-planar or Lorenzo residual bytes is a size-only reference, independently reset each block. No compression parameter fitting or further search.

| Layout | Fixed/predictor | Rice + fixed/predictor | zlib reference |
|---|---:|---:|---:|
| cube4 | 535,385 | **445,248** | 413,177 |
| cube8 | 565,355 | 345,016 | 253,896 |
| cube16 | 754,565 | 334,410 | 215,415 |
| line64 | 768,599 | 632,570 | 565,764 |
| line256 | 762,722 | 588,822 | 426,785 |

All values include the same index convention and global header. cube8/16 save more flash but multiply maximum decoded channel scratch and cold decode work by 8/64. cube4 is the recommendation for small bounded scratch and simple decoder. zlib needs a separate inflater implementation/state and is not recommended on this evidence.

## Frozen wire format

Single contiguous blob, all multibyte integers little-endian. Header size32: magic `AGXL4R01` (8), gridN uint16=65, blockside uint16=4, block count uint32=4913, total blob size uint32, index offset uint32=32, data offset uint32=19688, reserved uint32=0. Followed by4914 uint32 offsets relative to data start, including zero and terminal size. Blocks ordered x,y,z, z fastest, each coordinate0..16. Actual edge shape is1 instead of4 on coordinate16.

Each block has three channel records, RGB order. Record starts mode uint8, k uint8. Mode0 adds minimum uint16 then packs all sample-minus-minimum values at k bits. Modes1/2/3 predict with previous, twice previous minus second previous, or three-dimensional causal Lorenzo inclusion/exclusion. Missing predecessors at block boundaries are zero. Difference is reduced modulo65536 into signed range[-32768,32767] then zigzag encoded. Modes1/2/3 use fixed k bits; modes5/6/7 use matching predictor with Rice: quotient zero bits, a one terminator, then k low bits. Bits LSB-first; each channel padded to next byte. Mode4 invalid. Predictors reconstruct modulo65536, with 32-bit signed arithmetic sufficient for all intermediate sums.

## Access, scratch, and validation

Public API `lossless_fetch(blob,len,vertex,rgb)` independently decodes one block into a **128-byte caller-stack channel scratch**, reusing that scratch across channels and copying only the selected value into a6-byte staged RGB result. It has no writable globals or persistent cache and exposes no scratch pointers. Public RGB output changes only after complete success. Input/output overlap is rejected. The low-level channel helper may mutate its private scratch on failure; it is not the transactional public output API.

The selected block's offset pair and all decoded record boundaries are checked per fetch, as are exact header fields, first/terminal offsets, vertex range, record modes, k<=16, unary quotient bounds, and min+residual overflow. A selected block is limited to396 bytes; each channel reader is likewise bounded. This also prevents size_t bit-count overflow on32-bit targets. Complete index monotonicity is verified by construction/full traversal, not scanned on every vertex fetch. This is not an authenticated file format: validly structured edits can change LUT values. For trusted compiled const data, the current implementation still pays these per-access checks. No stripped-check performance mode was measured.

The selected actual maximum encoded block is304 bytes. A cold fetch reconstructs at most64*3=192 uint16 values. Four tetrahedral corner calls therefore reconstruct at most768 values, without full-LUT RAM expansion. At block boundaries four vertices can occupy1..4 blocks. Across64³ cells the distinct-block distribution is110,592 cells with1,110,592 with2,36,864 with3,4,096 with4, independent of tetrahedron axis order. No cache/grouping optimization was implemented, so the straightforward four-call API repeats decoding when corners share a block.

Rice decoding is bounded by the selected record length and legal16-bit residual. The measured maximum chosen quotient is102. Host timings in JSON are diagnostic only, not MCU cycle estimates. The original profile must retain uint16 conversion `/65535.0f` and exact interpolation order; lossless LUT equality alone does not prove a changed evaluator bit-identical.

## Reproduction and private data

Run `python3 fox-v3-lossless-profile-lut/research/measure_lossless.py` for finite study aggregates; run `python3 fox-v3-lossless-profile-lut/research/verify_c.py` for private blob generation and C exhaustive verification. Python uses only installed standard library. C uses installed host cc. `aggregate_results.json`, `c_verification.json`, and scripts contain aggregate results/code, not LUT samples. Generated `private/agx_cube4_rice.bin` and any derived embedded header must remain private and excluded from public bundles pending the existing licensing gate. `.gitignore` excludes private data and build outputs. Input source SHA256 is recorded; source licensing is unchanged by lossless encoding.

## Host-only C resource measurement

GCC14.2.0 x86_64, `-Os -std=c11 -fstack-usage`: `.text`1382 bytes, `.rodata`8, `.eh_frame`200; `size` reports1590 combined text-class bytes, zero `.data`/`.bss`. Static stack report: public fetch208 bytes (includes channel scratch and staged RGB), nested decoder56 bytes, u32 accessor8 bytes. Conservative fetch+decoder call-chain total264 bytes excluding caller frames. This does not predict Xtensa code generation, stack, or cycles. No target toolchain was present in PATH. Latest exhaustive host fetch pass took0.701 seconds including ctypes calls for274,625 vertices; not a renderer benchmark.
