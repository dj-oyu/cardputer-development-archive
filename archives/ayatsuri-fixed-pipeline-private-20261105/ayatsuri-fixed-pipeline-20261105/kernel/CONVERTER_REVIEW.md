# Independent read-only converter review

## Fix verification

Latest reviewed converter SHA-256: `b127e829cf4062cbd0364018e66af0c8281bd7f74e457f7a6e5d31a400bc530e`. Historical findings below retain their original snapshot context.

- Finding 1 resolved: all five explicit schema/unit/basis/scale/static markers are required. Missing-marker regressions pass. Source adapter source was spot-checked to emit these markers and source/importer/batcher/adapter/scenario hashes; this is not a new full adapter audit.
- Finding 3 resolved: decoder requires integer squared normal length within 32762²..32772². Source norm tolerance contributes at most 3.2767 codes and three-axis rounding at most sqrt(3)/2 codes, less than five, so this envelope admits encoder output. CRC-valid [32767,32767,32767] is rejected.
- Finding 4 resolved for ordinary reported failures: CLI rejects existing output/sidecar; exclusive pair writer removes only newly opened matching-inode files on failure. Tested existing sidecar, injected write failure, and successful write. Existing sidecar preserved and no new orphan remains. Crash atomicity is explicitly not claimed.
- Finding 2 remains a documented architecture boundary, not a converter bug: signed32 positions stay outside the signed16 MAC kernel.

Cross-language bridge (`python3 test_bridge.py`): O0/O2 ASan/UBSan each pass 639 actual AYFQ normal components, 639 actual AYFQ linear-color components and 12 scaled half-tie/endpoint cases; 1290 matches, zero mismatches. Identical binary64 values transported by Python float.hex and C scanf %la. FE_TONEAREST is required for floating preparation; integer MAC rounding alone is fenv-independent. See bridge-results.txt.

## Historical review


Reviewed snapshot SHA-256: `3f6ef86ce28092b8a3b72cfb67279d419f626fc2895adbfcc37a70d40bc2526a`.

Reproduction: `python3 review_converter.py`. This imports neighboring converter without bytecode writes; synthetic temporary files are within kernel and removed afterward. An initial import before disabling bytecode may have created/updated neighboring __pycache__; parent notified. No converter source edits.

## Priority fixes before integration

1. **Provenance/coordinate contract (high).** `compile_report` accepts parts.positions and labels the result metres/pre-scale without checking a schema/version/coordinate-space marker. A structurally compatible report in legacy scale-38 coordinates is accepted and silently mislabeled. Enforce a recognized producer schema plus explicit native-basis/pre-scale-metres marker, or require that declaration in trusted CLI/API input and persist it in provenance. Sidecar hashes are useful provenance, but do not establish units or stage. Source schema tags are absent in the successful minimal reproduction.
2. **32-bit position / 16-bit kernel mismatch (high integration risk).** AYFQ blocks hold signed32 positions. The proposed signed16 multiplication fast path is directly usable only for normals/rho, not those positions. Use double/int64 position interpolation, or an explicitly versioned local-origin signed16 format with range checks. Do not implicitly narrow the 32-bit position vectors or claim full color/disk-light SIMD from this interpolation prototype.
3. **Decoder normal contract (medium).** Decoder checks nonzero and excludes -32768 but accepts CRC-valid [32767,32767,32767], length sqrt(3). Encoder requires source unit length within 1e-4. If decoded blobs are intended to satisfy the compiler's normalized-input contract, enforce the corresponding post-quantization length envelope (source tolerance plus at most sqrt(3)/(2*32767) norm perturbation), preferably via integer squared-norm bounds. If decoder is intentionally structural-only, document that and require semantic validation before shading. Reproduction confirms acceptance.
4. **Partial output on failure (medium).** CLI exclusively creates the binary, then exclusively creates its JSON sidecar. Preexisting sidecar produces exit=1 after leaving a new binary. Check both destinations before writing and make failure cleanup/commit semantics explicit; do not overwrite or delete an existing sidecar. A temporary-file strategy should avoid claiming success until both artifacts commit. Reproduction confirms binary exists and old sidecar unchanged after failure.

## Lower-priority robustness

- Very large Python integer inputs can make `math.isfinite` raise OverflowError before the intended ValueError; malformed unhashable materialId can raise TypeError. This fails closed, but error typing/message should be consistent if used as a library.
- CLI reads the whole input before its 32 MiB cap; a pre-read stat plus bounded read avoids avoidable memory pressure.
- Positive old/new cross-product dot rejects collapse and >90-degree reversal, not arbitrary normal-direction changes or near-degenerate shape distortion. The report's wording should say collapse/flip checks, not preserved geometry or bounded image error.
- Source IDs/part names are not in the binary; preserve an explicit source-to-part/triangle mapping in provenance if audits depend on identities, not only order. Triangle order itself is preserved.

## Positive findings

Format/version is separate from AYNM; explicit little endian; bounded counts; exact section offsets and contiguous totals; padded lanes/section padding validated; checksum checked before parsing variable payload; material reserved bits and triangle indices checked; Python arbitrary precision protects geometric integer cross products from machine overflow; float input range and normal-length checks occur before packing; no silent saturation; renderer integration is explicitly false.
