# Opt-in normal-pair codec integration: actual eye-B

This private host experiment uses the authorized four-file product change frozen in `fox-v3-normal-pair-codec/SOURCE_FREEZE.json`, SHA256 `230140690027b5a775c328c9a50ef9d5c68b44c345539b740eb2d482697b5a4a`. Original append APIs remain default OFF/mode4. New opt-in append APIs choose production mode5 only when all serialized vertices have exact integer-opposite back/front SNORM16 components, otherwise the whole record stays mode4. No quantization asymmetry is removed. Existing invalid inputs, including INT16_MIN, remain rejected by product validation.

The implementation worker's O0/O2 ASan/UBSan suites, old pixel suite, opt-in binding suite, and independent SNORM boundary review are separate implementation evidence in that source directory. This report covers actual model integration. No geometry, materials, lights, source reference, thresholds, quota or precision changes were made.

## Separate geometry and codec contracts

Canonical geometry stays **1066 vertices,1414 triangles,51 records,65216-byte old snapshot**, cold43788 B, arena76324 B. A separate eye-B-specific contract pins all 20 old snapshot SHA256/FNV values and expects OFF mode4×51/65216 B or ON mode5×51/58844 B. All-eligible is an expectation for this fixture, not a general requirement imposed on the codec. General non-opposite records still use mode4 fallback.

The host adapter changes only opt-in dispatch (default OFF), private snapshot dumping, mode-count/saved-byte audit metadata, and evidence validation. It captures the owned snapshot after dispose/poison and binding checks, before rasterization. A candidate manifest is written only after every required render, reverse-order comparison, and validation succeeds. Private snapshots and geometry must not be bundled.

External prepared certificate pins:
- OFF: `505ee16c7d5ea569536be17bf45e07e5376112f941467cb5675915cf976acdc0`
- ON: `a8d001fb56f999c90cc7ca75fe6ef6094a60ea5403979e6171635aa7eca5c10a`

## Full actual-C results

Both modes completed ten formal-v3 conditions and both submission orders: 40 renders total. For each mode:

- All 40 RGB565/depth output buffers match original eye-B exactly.
- All 10 color, response, shape, and mask results match original eye-B exactly.
- All 20 private snapshots decode to the original full canonical bytes/SHA, including scene prefix, record/header order, side bits, triangle order and padding.
- Original non-timing, non-layout metadata is identical: geometry/material generations, all ray/node/triangle counters, work, camera/light settings, disposal proof and all fixed caps.

| Mode | Actual snapshot | Mode4 records | Mode5 records | Saved | Headroom under65536 |
|---|---:|---:|---:|---:|---:|
| OFF | 65216 B | 51 | 0 | 0 B | 320 B |
| ON | 58844 B | 0 | 51 | 6372 B | 6692 B |

This verifies lossless behavior on this all 10 static fixture. It does not adopt new geometry, establish global 60% reproduction, establish device fit, or guarantee the same saving on future assets/poses. Inherited geometry/quality limitations remain unchanged.

Evidence: `actual-parity-v2.json`, each actual run's `functional.json`, and `score-off-v2`/`score-on-v2` evaluation plus COMPLETED files.

## Scorer boundary and validation hardening

The formal score() implementation AST is unchanged. Only geometry snapshot accounting and candidate snapshot/provenance validation are extended. The independent reviewer found that integer metadata fields originally accepted equal-valued floats/bools; strict validator v2 now requires nonnegative exact Python int types for mode4/mode5 record counts and saved bytes, and rejects missing values. Four codec-audit tests pass, including all 20 old/compact canonical checks and float/bool/negative/missing metadata rejection. The 58 pre-existing scorer tests also pass.

The rendering packs/certificates and old scorer results were kept unchanged. New v2 results independently re-score those completed packs and include hashes for both codec_audit.py and geometry_certificate.py plus validation version `normal-pair-validator-v2-strict-integers`. No rendering was repeated for this validator-only correction.

## Performance scope

Functional OFF/ON rendering ran concurrently and is not a controlled speed comparison. The earlier standalone C diagnostic measured byte-codec vs simple copy only; it is not integrated product overhead.

`measure_integrated_cost.py` is prepared for original eye-B / new product OFF / new product ON × baseline front/oblique × three alternating repetitions (18 sequential renders), identical O2 flags, all 36 buffer parity and canonical snapshot checks, evaluation/append/render min/median/max. The owner subsequently confirmed independent heavy work ended and authorized the controlled run below. Private dump IO is outside the native evaluation/append/render timers. Device performance remains unmeasured.

## Controlled integrated host timing

Independent all-40-frame replay ended at 08:37:08 UTC. The owner authorized this isolated sequential 18-render session, approximately 08:37:49–08:40:23 UTC. All 36 RGB565/depth buffers remained exact; every new-codec snapshot restored canonical bytes; pre/post pins and identical O2 flags passed. Three repetitions per arm/view, alternating lead arm.

| Arm/view | Evaluation ms min / median / max | Instrumented append ms min / median / max | Raster+lighting s min / median / max |
|---|---:|---:|---:|
| originalEyeB/front | 8.421770 / 8.517697 / 9.187778 | 3.890942 / 3.989832 / 4.035791 | 8.271264 / 8.453133 / 8.816332 |
| originalEyeB/oblique | 9.532480 / 9.660575 / 10.344334 | 3.975511 / 4.154139 / 4.294522 | 7.969356 / 8.137773 / 8.436978 |
| codecOff/front | 8.362983 / 8.772814 / 10.236191 | 3.898403 / 4.278859 / 4.336226 | 8.301909 / 8.892305 / 9.739666 |
| codecOff/oblique | 9.178966 / 9.260391 / 10.050178 | 4.603019 / 4.622629 / 6.516963 | 8.368534 / 8.440938 / 8.640664 |
| codecOn/front | 8.621344 / 8.624949 / 11.694782 | 3.989982 / 4.780788 / 6.237354 | 8.477595 / 8.677778 / 9.527190 |
| codecOn/oblique | 8.669197 / 9.206638 / 13.156464 | 3.860556 / 4.020619 / 4.563699 | 8.054600 / 8.166772 / 8.387001 |

Observed render-median ratios:
- codecOff-vs-originalEyeB/front: 1.051954x (+5.195%).
- codecOff-vs-originalEyeB/oblique: 1.037254x (+3.725%).
- codecOn-vs-originalEyeB/front: 1.026575x (+2.658%).
- codecOn-vs-originalEyeB/oblique: 1.003563x (+0.356%).
- codecOn-vs-codecOff/front: 0.975875x (-2.413%).
- codecOn-vs-codecOff/oblique: 0.967520x (-3.248%).

Ranges overlap substantially. This small single-host sample does not establish a general speedup or a reliable overhead bound. Do not turn lower ON/OFF medians into a performance promise. The instrumented append timer includes the native snapshot audit scan plus existing scene/binding work; it is not an isolated writer-only timer. Private dump IO is outside evaluation/append/render timers, but this remains an instrumented host adapter. No target-device timing was measured. Full metadata/order/pins: cpu-001/COMPLETED.json and progress.json.

## Independent replay and retained scope

Independent fresh C replay confirmed all 40 OFF/ON frames, 80 image buffers, 40 snapshots and 3240 metadata comparisons. The independent timing review confirmed 54 summary values, 36 buffers and 15 pins. Validation v2 also received independent strict-type/metric review. Default codec behavior remains OFF. No new geometry was adopted here; existing eye-B, muzzle occlusion limitations and global 60% status are unchanged.
