# First-floor-hit direct Lambert reflection: preimplementation contract

Status: planning only. No new implementation or physical rendering. Base is frozen rho-affine A2, quarter offsets and fixed v32 geometry-only mask; current lid8 geometry, original source/reference and all thresholds remain immutable. Original failed BH and rejected fixed-BH quality proposal remain separate.

## Exactly one new path

When an existing primary cosine hemisphere ray first hits either tagged floor triangle, retain current floor Le once. In new explicit opt-in mode, evaluate the existing three-DISK/16-point visible direct Lambert evaluator at that floor hit using source linear BaseColor, world radiance zero. Accumulate receiver rhoX * floorDirect / outer16 as a separately observable floor_reflected component. The evaluator already includes floor rho/pi and light normalization: no extra floor rho/pi. No secondary-floor Le, world reflection, tertiary ray, extra sampling, floor specular, camera-background shading or change to other hits. This is a Lambert surrogate, not the original Principled floor BSDF.

OFF and all-zero floor rho take the old arithmetic path and reproduce old buffers and counters. ON nonzero rho is a new host arm. Do not replace the original API/default with it.

## Immutable source material and geometry

SOURCE_RHO.json pins existing source metadata and original blend/config hashes. Baseline/direction/intensity/ambient rho is (0.8399999737739563,0.7799999713897705,0.6499999761581421). Albedo uses the actual source float results (0.5040000081062317,0.46799999475479126,0.38999998569488525), not double-times-.6 or RGB565 decoding. Original floor Le is unchanged in every scenario. Roughness .65 and dielectric specular are not reproduced by Lambert. Source Principled internal Weight socket=0 semantics require source-code review; do not infer that floor reflection is zero from a hidden socket value.

Transport coordinates are the owned physical source-world positions. Use the floor geometric normal, orienting to oppose the incoming primary ray: n = Ng if dot(Ng,d)<0, else -Ng; exact tangent zero contributes no reflected term. Validate finite/unit Ng and tagged ordinal. This is a two-sided planar Lambert surrogate, not a camera-facing normal. Floor geometry and orientation are unchanged. Existing visibility segment epsilon 1e-5 world units at both start and light end remains; no extra normal displacement, exclusion mask or epsilon tuning. Test both sides explicitly.

## Ownership, generations and atomicity

Proposed new opt-in scene-build entrypoint copies a bounded floor-reflection descriptor into immutable owned transport scene: enabled plus three doubles rho. Existing build wrappers use canonical disabled descriptor. Preserve existing snapshot/vis/light/ground binding and add exact descriptor match; descriptor change requires increasing material generation, Le change still requires emission generation. Scene count/geometry/BVH are unchanged. Copy input then poison/free fixture, retained old scene replay after new scene and caller destruction, mismatched descriptor/generation refusal and failure-atomic replace/output are mandatory. Exact sizeof/owned bytes/stack/old+new peak measured before actual renders, not assumed product fit.

## Admission before implementation

All extra floor visibility callbacks consume the same cumulative transport budget as existing secondary light queries, never primary-direct quota and never reset per hit/band/sample. Caps remain 20M rays/800M node visits/300M triangle tests; direct remains 1M/100M/50M; snapshot65536, vis524288, transport262144, renderer ledger8M unchanged. No geometry/snapshot growth is expected, but owned descriptor growth is measured. Baseline primary-floor hits from current A2 are at most70342 front/71667 oblique; 48 kernel evaluations each give3376416/3440016 additional kernels and at most that many visibility segments. Node/triangle ceilings are NOT yet proved; worst full-BVH traversal is much larger than the caps, so ray count alone cannot admit the arm.

Critical pending contract: A2 stage reservation front7923890/oblique7673634 leaves76110/326366. Even a minimal one-stage-per-added-disk-kernel charge gives over3.3M new stages, beyond that margin; evaluator validation, normals, accumulations and counters cost more. Existing opaque shader charge is NOT reused to label the new light evaluation free. A full explicit new work ledger must precede implementation. Current 8M frame-fit is NOT established and this unoptimized bounded path is expected to fail that reservation. Do not reduce targets, rates, light count, samples or charges to rescue it. Ask parent whether to stop at infeasibility or authorize a separately named host diagnostic work budget; a diagnostic success must not be called old-frame-cap success. Transport ray/node/triangle caps remain unchanged unless separately decided, and failure yields no completed quality manifest.

## Required fixtures and actual gates if a work contract is authorized

Analytic black rho/zero lights, parallel and tilted floor, both physical sides, blocker/no blocker, inverse-square and Lambert scaling/units; no double Le; invariance of unrelated components; finite bounds/NaN/Inf, atomic late failure and budget exhaustion; old API and zero-rho byteexact. New source freezes independently reviewed before physical execution.

Then existing A2 control and opt-in ON all10 conditions × forward/reverse, all original stable/uncertain/fullFG/per-seed metrics and FP/FN/unknown, no clipping or threshold fit. New component absolutes and condition deltas reported separately; no claim that proxy indirect energy is floor-derived. All counters/ownership limits checked before publication. CPU only after independent heavy work stops, same flags/interleaved3 repetitions with raw times, observer I/O scope and separate memory/preparation accounting. Original model/geometry/raw/images excluded from code/report bundle. Negative or infeasible result is preserved; no extra paths or gain tuning appended.
