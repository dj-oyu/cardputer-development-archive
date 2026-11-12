# Private fixed-point interpolation prototype

## Scope and status

Portable C11 scalar reference/model for 1/2/4/8-pixel SoA blocks. This is an **approximate converter-first design experiment**, not a production renderer change, not tested S3 assembly, and not a pass of existing exact image/reference tests. Current disk lighting, visibility, coverage, mask/material selection, geometry and shadows are untouched. A later host-only scalar benchmark is provided in BENCHMARK.md; no S3 speed claim is made. Only this directory was written.

The input is a triangle already selected by unchanged geometry/coverage logic. Material side and palette must be selected by the unchanged double path before this kernel. A quantized mask decision close to zero is not permitted. The output consists of interpolated attributes; all downstream disk-light math remains double. Retain original assets/reference data until a separately approved error gate permits a new format.

## Encoding contract for a future converter

- Barycentrics: signed 16-bit Q2.14, nonnegative on this fast path. One is 16384 and all three integers sum to exactly 16384. Divide by the measured sum only for finite input in [0,1] whose sum differs from one by at most 1e-12. Largest-remainder partition, ties resolved in vertex order, avoids the common negative third-weight bug from independently rounding two weights. Exact vertices and constants remain exact in integer space.
- Signed Q1.15 cannot represent +1; unsigned Q0.16 cannot represent 65536. Unsigned scale 65535 removes the power-of-two shift, while feeding values over 32767 to the signed PIE multiplier is wrong. Q2.14 is a deliberate accuracy/implementation tradeoff, not a claim of optimal precision.
- Normals: preserve existing signed values and /32767 convention. New converter values use scale 32767 for [-1,+1]. Interpolated normals are not normalized here. Near-zero normals have no useful angular error bound; keep existing normalization and degeneracy behavior in the double path.
- Reflectance rho: decode sRGB before interpolation, at conversion time where possible, and round linear [0,1] to signed 0..32767. RGB565 is used as the synthetic reference input because that is the current format. A native Blender linear export should preserve its own full-precision reference and be evaluated separately; it must not silently reinterpret sRGB integers as linear.
- Positions: example local coordinate scale 1024 gives [-32,31.9990234375]. Store a double origin and explicit scale per object/packet if using local coordinates, and reconstruct only after interpolation. Scale and origin must be common to all three vertices in a triangle and must reflect evaluated transforms/animation. The prototype does not choose origins, compute skinning or validate animated envelopes. Reject or retain double payload when range/error budget fails. Converting positions for shading does not authorize quantizing rasterization/intersections.
- Generic encoder rejects nonfinite data, nonpositive/nonfinite scale, overflow, and out-of-range rounded values **before** integer conversion. It does not silently clamp. Invalid weights or lane counts fail. Caller routes failure to original double path. The scalar output is untouched on failure; block validates all active lanes before writing.

Rounding is nearest, halfway to even, matching Python round in the versioned converter. Scalar encoding uses explicit floor/remainder/parity rather than nearbyint/rint; integer MAC rounding uses quotient/remainder/parity. The integer MAC rounding is fenv-independent. Floating preparation, including x*scale and barycentric normalization, requires FE_TONEAREST; tests verify this mode. Explicit floor/remainder does not by itself make floating preparation independent of the active rounding mode. There are no negative signed shifts. This convention must be matched exactly by a future target backend. No fast-math flags.

## Exact integer-domain proof

For each lane, w_j >= 0 and sum(w_j)=16384; every attribute a_j is in [-32768,32767]. Thus every partial MAC and final MAC lies within [-536870912,536854528]. These fit signed 30 bits and the signed 40-bit QACC range [-549755813888,549755813887]. Intermediate saturation is unreachable. Product and accumulation explicitly promote to int64 in the model, so there is no signed-overflow UB. Rounding adjusts the quotient by at most one according to remainder magnitude and quotient parity; the result stays in int16 range. QACC's saturation is not used as an error policy.

The normalization tolerance changes original double weights by at most about 1e-12 each. With exact partition arithmetic each weight quantization is less than 1/16384 (the tested symmetric worst case is 2/(3*16384)). A conservative per-component interpolation bound is 3*M/16384 + vertex_round_error + output_round_error, where M=max(abs(attribute)) in real units, plus the tiny normalization tolerance term. Prefer tighter measured scene-specific bounds. Quantization is not exact equality to the old float/double pipeline. Propagation through normal normalization, nonlinear disk integrals, specular response or RGB565 thresholds is not established here; a small attribute error is not a proof of a small final image error.

## Proposed S3 mapping, not implemented

Each aligned 16-byte row contains one attribute or weight for eight pixels. Three weight rows and three attribute rows use six of eight QR registers; stream one component at a time, preserving weights if useful. Different triangles may share a block but require gathering their payload into the SoA tile. `fk_tile` is 96 bytes for one component; batching nine components simultaneously would waste registers and staging memory. Tail 1/2/4 cases must either use scalar work or initialize/pad unused lanes before a full vector load; this C model reads only active lanes.

TRM v1.8 section 1.8.139 defines EE.VMULAS.S16.QACC as eight signed 16x16 products accumulated separately in eight 40-bit lanes. EE.ZERO.QACC and three MACs implement the weighted sum. EE.SRCMB.S16.QACC is the extraction family, but its shift/rounding semantics must be checked and corrected to match the explicit reference before writing assembly. Do not assume this instruction implements ties-even rounding. For tiny blocks, staging/extraction costs may erase gains. Floating load/store instructions are not float SIMD arithmetic; no generic 32-bit vector multiply is assumed.

## Frozen reference and validation

`reference.h` freezes the current RGB565 float `powf` sRGB decoder, rho's two-step affine expression, and double weighted accumulation for normal/position. Rho is checked against the actual affine helper expression, not a differently associated sum. The frozen reference is local to this experiment; original production reference tests remain unchanged and have not been rerun or weakened.

`test_kernel.c` deterministic xorshift generator seed 0xa5b43920e727c1d3, 100000 samples per attribute; random convex weights, exact vertices, midpoint and thirds; random RGB565 rho, existing SNORM16 normal codes, and continuous local positions; independent full-range signed attributes and independently randomized weights in lanes 1..7; exact scalar/block checks at widths 1,2,4,8. Exhaustively checks all 65536 RGB565 values in all channels. Negative tests cover NaN, infinities, invalid sums, negative weights, storage overflow, scale failures, malformed lane counts and rounded positive/negative 0.5,1.5,2.5 and boundary half ties, equal weight remainders. Endpoints -32768/+32767 checked. This is synthetic testing, not a Blender asset corpus or a complete proof of the converter.

Run `bash run_tests.sh` with GCC 14.2.0. O0 and O2, ASan and UBSan, both pass and output files compare byte-identically. LeakSanitizer was attempted but cannot run under the environment's ptrace; leak detection is explicitly disabled in successful runs. No dynamic allocation is used by the kernel. `results-O0.txt` and `results-O2.txt` contain maxima, RMS, p50, p95 and p99.

Results (absolute real-unit errors):

| Component | Maximum | RMS | p95 | p99 |
|---|---:|---:|---:|---:|
| Linear rho | 0.0000585712812185 | 0.0000143655722758 | 0.0000280812804687 | 0.0000364698876354 |
| Normal component | 0.0000847896879395 | 0.0000206024515558 | 0.0000412035138386 | 0.000053999438323 |
| Local position (scale 1024) | 0.00275347066831 | 0.000685145733992 | 0.00136625468994 | 0.001789713167 |

Palette-only max error 0.0000148760177866; barycentric max error 0.0000406901041667. Scalar/SoA mismatches zero across 4.5 million active-lane comparisons (100000 x 3 x (1+2+4+8)). No final RGB/image error or S3 speedup was measured. See BENCHMARK.md for the separately scoped host-only interpolation timings.

## Source provenance

See `SHA256SUMS` for prototype and exact source hashes. Read-only source paths from workspace root:
- `fox-v3-indexed-bvh-bounds/code/ksn_bounded_ring_helpers.inc`, lines 103-114: old per-pixel dataflow.
- `fox-v3-indexed-bvh-bounds/private-build/product/main/ayatsuri/compact_opaque.h`: world double, normal int16, RGB565 contract.
- `fox-v3-indexed-bvh-bounds/private-build/product/main/ayatsuri/ayatsuri_shade.h`, line 46: float sRGB decoder.
- `fox-v3-indexed-bvh-bounds/private-build/product/main/ui/kasane/ksn_aa_rho_affine.h`: current rho operation order.
- `pdf_reference/trm.txt`, lines 2009-2021 and 8026-8063: QACC and signed lane MAC definition.


## Coordination with AYFQ v1 converter

The neighboring converter currently exports signed32 metre positions with fractional bits 16/20, not this illustrative signed16 local-position encoding. **Do not pass those positions to fk_tile or narrow them.** Keep position interpolation in the double/int64 fallback, or design a separately validated rebasing/range-check contract. Linear rho and normals share the new ties-even /32767 contract. Legacy asymmetric normal rounding belongs only to the frozen baseline.

Both encode and MAC output now use nearest ties-to-even. Largest-remainder barycentric partition is a distinct rule and retains deterministic vertex-order tie breaking. New scalar encode accepts values just beyond a storage endpoint only if their rounded integer is representable, matching the converter's post-round range check. Physical rho/normal range validation is the caller's responsibility.


## Cross-language bridge and review regression

`python3 test_bridge.py` compiles a C stdin harness at O0/O2 with ASan/UBSan and compares `fk_encode` to values actually encoded and decoded by neighboring AYFQ compiler. Per build: 639 normal components, 639 linear-rho components, and 12 exact scaled half ties/int16 endpoints, all 1290 equal. Values use Python float.hex -> C scanf %la, preserving binary64 inputs. Includes normal/rho endpoints and ±0.5/1.5/2.5 scaled ties. Bridge explicitly sets FE_TONEAREST. `python3 review_converter.py` verifies repaired provenance-marker checks, nonunit-normal rejection, pair-write error cleanup and successful pair output. Both scripts disable Python bytecode writes and write only within this directory. See `CONVERTER_REVIEW.md` for updated findings and scope.


## Host-only benchmark

`bash run_benchmark.sh` reproduces frozen-double, fixed-prepared and fixed-mixed regimes at widths 1/2/4/8. See BENCHMARK.md for scope/caveats, benchmark-samples.csv for all 72 CPU-clock samples and benchmark-binding.txt for exact command/binary/source binding. This host shows no prepared-kernel win; weight preparation and gather/dequantization make the mixed path substantially slower. These results do not predict S3 speed.
