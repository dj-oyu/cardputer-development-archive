# Frozen-path actual-attribute replay

## Result

Baseline reconstruction is **bitwise exact** for P, Ns and rho in all 7,678 actual hit samples: 69,102 binary64 values compared against parsed saved observer decimal values, zero differences. The trace has 9,540 quarter-sample rows including 1,862 misses; misses were not converted into hit samples. Baseline P/N/rho each comprise 23,034 components, max/RMS/mean absolute error all zero.

Candidate A retains the original normal vertex codes and quantizes decoded RGB565 albedo to signed-int16 storage with range 0..32767, decoded /32767. It applies the actual `kernel/fixed_kernel.h` Q2.14 weight preparation and integer MAC/rounding. Over 7,678 samples:

- Ns: max absolute component error 7.00013816e−5; RMS 1.70764265e−5; mean absolute 1.36599867e−5. 23,032/23,034 components changed.
- Normalized Ns angle: max 0.0102799374 degrees; RMS 0.00193789365 degrees.
- rho: max absolute component error 1.46821636e−5; RMS 9.95665420e−6; mean absolute 9.09583772e−6. 22,684/23,034 components changed.
- P remains unchanged by design: max/RMS/mean errors zero. This is not evidence about quantized-position error.
- Zero weight-preparation fallbacks. Zero original or candidate normals of length ≤1e−12. Minimum original interpolated normal length was 0.2351946554. No fallback samples were silently excluded.

Candidate B uses verified source-linear material identities and AYFQ normals:

- Source-linear integer rho vs source float linear rho: max 1.45276748e−5; RMS 8.11452928e−6; mean absolute 6.88995923e−6.
- Source-linear integer rho vs old decoded RGB565 rho: max 0.0143879864; RMS 0.00778751382; mean absolute 0.00587504398. This larger change is primarily the intentional replacement of the legacy palette, not integer quantization error.
- Source material is constant within each part. The actual C fixed kernel interpolates the identical integer material values at all three vertices and produces exactly that material value because weights sum to 16,384. No RGB565-code lookup is used for source material identity.
- AYFQ q16 and q20 materials and normal arrays are identical. All 1,163 AYFQ front normals match current snapshot normal codes, zero code differences for this current static model. Candidate B's normal error/angle therefore matches A, and is due to weight/interpolated-result quantization here. This does not erase the general ties-even vs legacy floor(+.5) contract difference.
- P remains original double geometry. AYFQ q16/q20 positions are not consumed in this replay, so these results do not test those geometry formats.

## Proven mapping and parity method

`run.py` validates the AYFQ binary with the current pure decoder/CRC checks. It checks all 54 parts, all 1,163 legacy model XYZ and normal rows, all 1,564 triangles, side declarations, material IDs, and identity per-node pose. Each source metre XYZ ×38 rounded to F32 must match the legacy AYNM local coordinate bytes, and each source normal rounded to F32 must match its cold row. Whole-snapshot native XYZ must equal those legacy F32 coordinates promoted to double. Every sample's snapshot node and face vertex set must match the source part; serialized corner order is used for normals because the existing renderer may swap winding.

The first strict `serialized indices == source indices` check correctly failed on renderer-selected winding reversal during setup. Inspection of `mesh_select_sided` showed this is expected. The corrected identity check requires the same three vertices and then follows exact serialized order; no numeric parity comparison was relaxed. All subsequent original P/Ns/rho comparisons are bitwise.

The edge constructor in `edge_extract.h` is a verbatim pure extract from current `ksn_mesh_depth.c`; replay arithmetic follows `ksn_boundary_aa_impl.inc`, including canonical edge orientation, multiplication/addition order, quarter offsets, side-selected fields and native→physical axis conversion. Original `co_read` / vertex / triangle helpers, original C sRGB decode, and `ksn_aa_rho_affine` are reused directly. The C build uses O2, `-ffp-contract=off`, `-fexcess-precision=standard` and original warning exception `-Wno-misleading-indentation`. The initial build stopped on that warning until matching the existing build flag; no source/helper semantics were changed.

`results.json` contains full metrics, node→part→material identity checks and hashes of inputs/helpers/kernel/source/binary. `parity.json` retains the exact baseline parity gate outcome. `build.sh`, `run.py`, `replay.c`, and the frozen edge extract reproduce the test. Only this replay directory was written by this stage; source imports disable Python bytecode writes.

## Strict limitations

This is a frozen-path attribute replay, not a render. It does not call lighting, visibility or transport, recompute winners/coverage, change scene geometry, update admission gates, run on the device, measure actual image errors, or establish performance. It does not reconstruct the 32,400 center samples or other views/scenarios. Normal errors can alter bounce rays/shadows and must still be checked in a properly admitted full render. Source-linear material changes affect secondary transport too; these results do not model that effect.

Angular measurements normalize both original and candidate interpolated Ns and use atan2(norm(cross),dot); near-zero vectors are reported separately. The current trace is not near-zero, but a future candidate must retain explicit near-zero/fallback handling. The scalar fixed kernel is exercised here; this replay does not establish vector hardware speedup or full-render SIMD equivalence.
