# Final-only supplied-input chain compaction

This is an independent storage-only variant of the frozen kernel-chain-prototype. It changes neither rendering nor scene integration. Same latest-source tuples, synthetic lighting/visibility and existing frozen output profile apply. No scene/ray/visibility query, frame/render, device, public action, source model, existing kernel, renderer or CI change is involved.

## Change and interface

The distinct `kcc_block` API takes exactly the audit API's frame, scene and supplied `kc_input` structs, but returns only `aa_result`: averaged HDR Q19, RGB565 and high-clamp flag. Its output ABI must not be confused with `kc_output`. Widths1/2/4/8 and caller-owned nonoverlapping buffers are unchanged.

One slot's material, world/local point, raw/unit normal, rho and Q24 radiance storage is reused for all four slots; only the integer accumulator survives across slots. The final-only result is staged for every lane and all published outputs commit together. Cache warming may still happen before a later rejection; there is no cache rollback promise.

All arithmetic and error predicates execute in the same order: canonical Q20 corner interpolation; explicit Q20→world Q16/local material Q16/20/24 conversion; material evaluation; exact opaque-Mix admission; checked linear rho conversion; world-normal normalization; diffuse lighting; four-slot accumulation; exact sum/128 RNE Q19 conversion; one profile/RGB565 call. No intermediate tone-map, RGB565 or mean rounding is introduced. No double world/rho term is added. `storage-transform-proof.json` verifies compact.c equals frozen chain.c after only the listed storage/name/output-type substitutions; it is not a rewritten numerical algorithm.

The compact runtime library excludes the audit chain and test helpers. Combined audit/compact libraries are built separately only for testing, using one shared copy of each dependency.

## Exact validation

The full frozen verifier is retained with a checked-call adapter. Each audit call also runs the compact API and compares status, all final-result bytes on success and unchanged final-only output on failure. The unchanged independent wide-integer oracle still validates the audit intermediate values and final result. Thus compact results are compared to both the frozen final output and the already-independent numeric oracle; no new physical lighting equivalence is asserted.

Per Q16/Q20/Q24:

- 155 latest eye-white triangles ×12 controls ×3 explicit visibility patterns:5,580 four-slot groups.4,473 accepted;1,107 nonopaque rejected.
- 22,320 point evaluations:18,162 opaque,4,158 nonopaque. Opaque points inside a rejected group do not make that whole group accepted.
- All accepted final HDR/RGB565/clamp fields match exactly; all rejected outputs remain unchanged.
-512 width1/2/4/8 grouping and final-lane invalid-input checks, plus8 final-lane nonopaque checks, remain intact.
- Original rho bound/tie/exhaustive-Q16/random-Q20/Q24 tests, sum/128 ties and double-rounding counterexample, normal/material rejection, Q19 overflow and empty-cache failure tests remain intact.
- All six O0/O2 ASan+UBSan builds run the complete latest tuple corpus and boundary tests, comparing the compact and frozen final outputs. All pass. Leak checks are disabled for the same environment restriction; the standalone compact runtime has no heap dependency.

The standalone runtime's full disassembly has no floating arithmetic/conversion and no libm dependency. This is scalar C batching, not a SIMD or target-speed result. `admissions.json`, `results.json`, six raw logs and disassembly are retained. All111 hashed frozen audit artifacts verify unchanged.

## Coordinate rounding diagnostic, no adopted change

The latest155 triangle fixtures ×4 declared points were checked once, without multiplying identical coordinates by control states or visibility patterns. Adopted world conversion is explicitly RNE(RNE(weighted Q20 sum/16384)/16), fixing the canonical Q20 interpolated point first. A diagnostic direct RNE(weighted sum/(16384*16)) differs on50 of1,860 world components (50 of620 supplied points), maximum1 Q16 code =1/65536m. Local XZ Q16 conversion differs on37 of1,240 components (37 of620 points), also maximum1 code. Shared source vertices can occur in more than one declared tuple.

Relative to the exact weighted coordinate of the canonical Q20 corners, the largest observed adopted rounding error is17/32 Q16 code, versus1/2 code for the direct diagnostic alternative. This excludes the earlier source→canonical-Q20 quantization error. All differing tuple IDs and integer numerators are retained in coordinate-rounding-diagnostic.json. **The direct alternative is not adopted**; compact and audit remain identical. This coordinate diagnostic is separate from radiance accumulation, whose exact sum/128 single RNE rule is unchanged.

## Storage: separate quantities

- Published output:496B audit record →16B final-only record per lane; width8 caller output3968B →128B.
- Atomic lane staging:3968B →128B for eight lanes. This staging is separate from caller output.
- Reused one-slot named buffers: material64B, world12B, localXZ8B, unit normal6B, rho6B, radiance24B, raw normal6B, light pixel32B:158B logical declared storage before compiler lifetime reuse/alignment. Accumulator32B and per-lane final16B are separate. Scalar loop/light internals are not included in this logical-buffer count.
- Unchanged compact material frame208B, material spatial scratch232B, uniform scratch192B; input368B per group; synthetic scene684B; caller-owned output-profile cache3224B.
- Host GCC14.2 O2 chain own frame:4848B →592B at each Q. This is the function's own static frame, not peak nested stack, target SRAM, runtime allocation, latency or FPS. Nested mc_eval/output/cache frames still exist. Raw .su reports are retained.
- Q20 chain object text4089B →3837B. The new compact object adds no readonly/data/BSS object. Whole standalone libraries contain exactly one3084B selected-Q material LUT, one445248B existing encoded profile and one25700B shaper. Neither a second material/profile table nor a second frozen chain is present in the runtime library. Test combined libraries intentionally include both chain functions, sharing the same dependencies.

These numbers do not prove that all tables fit target SRAM, establish an S3 ABI, or constitute target performance measurements.

## Remaining scope limits

The parent audit's three provenances remain separate: latest eye-white numeric geometry/material inputs, explicitly supplied synthetic light/visibility fixtures, and an older frozen display-profile mapping. No agreement with the latest .blend view transform/Look is established. Canonical Q20→Q24 scaling does not restore coordinate detail. Four supplied triangle points are not actual pixel AA. Geometry is neutral under varied material controls, not a posed animation result.

Transparency/background, contour/corner/face-mask recipes, full Principled roughness/IOR/specular/reflection transport, animation, real scene visibility/lighting, actual pixel coverage, renderer fallback/integration, latest-source display equivalence and target memory/speed remain unfinished. The reduction changes storage only; it does not close these semantic gaps.

All linked binaries retain the private profile and are unsuitable for public distribution. For a report/source-only package, omit .so, .o and sanitizer executables. Source-only reproduction requires the frozen private dependencies locally.

## Reproduce

Run `python check_transform.py`, `sh build.sh`, `python verify.py > verify.log`, and `python audit.py` in this directory. Scripts read frozen dependencies and write only here. `build.sh` emits standalone compact libraries and separate combined comparison libraries. dependency-manifest.json pins the complete frozen provenance plus the exact audit fixtures, code, verifier and original results; SHA256SUMS binds this variant's deliverables.
