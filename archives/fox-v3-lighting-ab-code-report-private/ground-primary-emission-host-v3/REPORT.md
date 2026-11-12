# Fixed-v3 host ground occlusion / primary emission

Status: NOT_ESTABLISHED, not adopted. This is a host-only transport experiment, not firmware/Pocket integration or a device performance result. Original scene, all fixed reference conditions, domain masks and thresholds remain unchanged.

## Contract and controls
Three arms use identical existing pixel DISK16 + one diffuse bounce outer16/inner16. OFF omits the floor. CONTROL adds only the source finite opaque floor to direct and transport rays. LE adds only primary-hemisphere first-floor-hit rhoX×Le. World misses and floor hits are exclusive; no floor BSDF reflection, secondary floor emission, camera/background floor, AgX, weighted filter, specular or higher bounce is introduced. Thus opaque-black-floor CONTROL is deliberately a component ablation, not a complete physical rendering of the authored ground.

All 60 actual C frames completed under unchanged quotas. OFF all 40 RGB/depth buffers are exact against prior bounce-001. Each arm has exact final forward/reverse colors and depth, and all depth matches the old candidate. These are pixel invariants, not a claim of equal intermediate work/order timing. Input hashes remained unchanged.

Source ground geometry/material was independently read, copied and owned; RGB emission is already linear, strength .25, with no sRGB decode. Auxiliary Blender front/back emission agrees with source Le within 5.96e-8. This fixture was artifact/source audited independently, not independently re-rendered. Floor geometry affects rays only, so reference silhouette omissions and missing background support remain.

## Fixed-domain results
Full metrics, false positives/negatives, pooled/uncertain values and condition masks are in the score folders and metrics.json. Unknown regions never become a PASS. Values below are stable-domain diagnostics; no single average establishes the 60% goal.

front:
- direction off: RGB 72.8134%; bright IoU 64.7215%; response magnitude 72.3422%; delta RGB RMSE 0.1064381.
- direction control: RGB 69.6030%; bright IoU 65.7842%; response magnitude 60.5438%; delta RGB RMSE 0.1257083.
- direction le: RGB 71.7748%; bright IoU 65.1163%; response magnitude 67.9313%; delta RGB RMSE 0.1133148.
- ambient off: RGB 72.8393%; bright IoU 77.0614%; response magnitude 68.8311%; delta RGB RMSE 0.0508341.
- ambient control: RGB 69.7028%; bright IoU 72.3168%; response magnitude 73.1243%; delta RGB RMSE 0.0351464.
- ambient le: RGB 70.9892%; bright IoU 69.2749%; response magnitude 63.7748%; delta RGB RMSE 0.0340184.

oblique:
- direction off: RGB 71.7671%; bright IoU 39.2683%; response magnitude 81.3113%; delta RGB RMSE 0.1129984.
- direction control: RGB 67.8728%; bright IoU 39.9267%; response magnitude 67.7443%; delta RGB RMSE 0.1313620.
- direction le: RGB 70.5042%; bright IoU 39.4125%; response magnitude 76.1872%; delta RGB RMSE 0.1197112.
- ambient off: RGB 72.0129%; bright IoU 78.4812%; response magnitude 63.1318%; delta RGB RMSE 0.0522380.
- ambient control: RGB 68.1067%; bright IoU 71.9945%; response magnitude 79.3809%; delta RGB RMSE 0.0347988.
- ambient le: RGB 69.7255%; bright IoU 69.9533%; response magnitude 68.3652%; delta RGB RMSE 0.0333008.

control versus OFF: stable RGB change -3.9062 to -1.6671 percentage points across all ten conditions. Every condition worsens.
le versus OFF: stable RGB change -2.2873 to -0.5374 percentage points across all ten conditions. Every condition worsens.
LE versus CONTROL recovers 1.1297 to 2.6315 RGB points in every condition, but does not recover the floor-omitted baseline. This identifies a source-derived contribution without claiming overall improvement.

## Source-radiance interpretation
At baseline the original uniform world radiance is (.35,.308,.2415), whereas source floor Le is (.21,.195,.1625). Replacing previously unoccluded downward world misses by floor Le therefore reduces that direct radiance, before any reference comparison. Floor BSDF reflection and secondary emission are deliberately absent, so this is not a complete floor-transport solution and does not prove the authored floor makes the original image darker.

## Numerical limits
The finite-square known fixture has exact cosine fraction .554126424, independent Cartesian512² .554126981. Actual outer16=.5 (−9.77%), outer64=.5625 (+1.51%); dense cosine16384=.554199219. These are one fixture’s errors, not whole-character error bounds. No sample count, light gain, source color or threshold is fitted to pictures. Prior 64-sample budget failure is preserved. Fine tests below are separate, not substituted into the main score.
- Fine oblique baseline: FAILED_NO_QUALITY_RESULT_PARTIAL_FILES_INVALID; return code 2; stderr 'NATIVE_USED_COUNTERS:{"visibilityRays":226631,"visibilityNodeVisits":12301224,"visibilityTriangleTests":3970280,"transportRays":12313448,"transportNodeVisits":788262723,"transportTriangleTests":300000000,"primary_ground_hits":126917,"primary_ground_emission_hits":126917,"secondary_ground_hits":215393}\nNATIVE_GATE:render'.
- Fine oblique direction: FAILED_NO_QUALITY_RESULT_PARTIAL_FILES_INVALID; return code 2; stderr 'NATIVE_USED_COUNTERS:{"visibilityRays":190082,"visibilityNodeVisits":10957258,"visibilityTriangleTests":3619145,"transportRays":11945510,"transportNodeVisits":780649692,"transportTriangleTests":300000000,"primary_ground_hits":117932,"primary_ground_emission_hits":117932,"secondary_ground_hits":200714}\nNATIVE_GATE:render'.

The first fine helper attempt failed before rendering because its generated ground input path omitted inputs/. It is preserved as fine-001.log; fine-002 uses the pinned scenario input path. This is not a renderer/quota failure.

## Ownership, budgets and costs
Snapshot65536B/work8M remain unchanged; snapshot actual52212B/45records, model arena65892B, cold35636B, instance584B. Direct budgets1M rays/100M nodes/50M triangles; transport20M/800M/300M are separate frame-cumulative quotas. Render failure leaves incomplete bands unpublished; partial artifacts are never scored.
Owned BVH OFF326496B/ON327056B. Owned transport OFF75184B/ON75312B. ON sum402368B per generation; two retained generations804736B, excluding allocator overhead, two snapshots and scratch. The two-generation concurrency policy is caller-managed, not globally enforced. Ground increases even OFF transport header by56B; render context272B versus184B old. Input geometry temporary34368→34488B, attributes74624→74752B. Geometry/pose/light/material/emission generations are caller-issued and bound to exact copied inputs, not automatic persistent scene-change detection.
Actual all-case budgets and reverse-order work counters are retained in accounting and native metadata. No new large observer framebuffer is used. These host memory costs are not a claim that the device fits. F64/FPU device timing is unknown.

Controlled unsanitized O2 host CPU: three alternating repetitions per arm/all ten forward cases; reverse functional-run costs are separately retained, not compared as controlled timings.
- off: median raster range 6538.718–7015.937 ms.
- control: median raster range 7422.432–7983.643 ms.
- le: median raster range 7452.306–8107.923 ms.

## Reproduction and verification
Run HONE_GROUND_MODE=0/1/2 python code/run.py <fresh-output>. Score candidate-manifest.json with scoring/score_candidate.py --output <fresh-score>. Run compare_controls.py, summarize.py and the independent tests. All source, compiler flags, binaries and input hashes are recorded in each run. No model, geometry, source images or raw output buffers are placed in the private code/report bundle.
Independent final review passed: 60 O2 ASan/UBSan actual renders, 120 RGB/depth buffers, 4,620 non-timing metadata fields and 4,050 metric values all agree. Core O0/O2 sanitizer fixtures, loader/ownership/generation/budget/alias checks and 34 additional scorer metadata mutations passed. The source/side-emission evidence is artifact/source audited, not an independent Blender rerender. Controlled CPU statistics are separately reviewed. No default adoption, public redistribution, PR, flash or actual-device test.
