# Ground emission-only paired ablation

Two seeds (11, 29), front/oblique × baseline/direction. Signed ON−OFF linear effects are retained without clipping or energy fit. No confidence interval, new stability mask, acceptance, or native input modification.

| View / seed / case | FG signed mean Y | FG mean abs Y | Common signed mean Y | Interior signed mean Y |
|---|---:|---:|---:|---:|
| front/11/baseline | 0.04584436 | 0.04592432 | 0.02895459 | 0.02824586 |
| front/11/direction | 0.04590227 | 0.04597799 | 0.02900543 | 0.02821617 |
| front/29/baseline | 0.04584822 | 0.04590125 | 0.02902082 | 0.02836624 |
| front/29/direction | 0.04573774 | 0.04577977 | 0.02891182 | 0.02824488 |
| oblique/11/baseline | 0.04626626 | 0.04637479 | 0.02842104 | 0.02646633 |
| oblique/11/direction | 0.04636691 | 0.04640488 | 0.02855023 | 0.02648741 |
| oblique/29/baseline | 0.04628096 | 0.04632357 | 0.02841397 | 0.02651446 |
| oblique/29/direction | 0.04626742 | 0.04631293 | 0.02844429 | 0.02650339 |

## Does estimated floor contribution change with direction?

| View / seed | FG interaction signed Y | FG interaction abs Y | Interior interaction signed Y | Interior interaction abs Y | PNG direction-effect RMSE Y (FG) |
|---|---:|---:|---:|---:|---:|
| front/11 | 0.00005791 | 0.00337509 | -0.00002969 | 0.00301560 | 0.00982589 |
| front/29 | -0.00011048 | 0.00305858 | -0.00012137 | 0.00284333 | 0.00967481 |
| oblique/11 | 0.00010064 | 0.00298822 | 0.00002109 | 0.00229161 | 0.01032630 |
| oblique/29 | -0.00001354 | 0.00329763 | -0.00001107 | 0.00258253 | 0.01042897 |

ON−OFF is a paired rerender difference including path/MIS/Monte Carlo changes, not a directly isolated emission light-group contribution from a single render. Emission is fixed at the source. Expected linear transport from that source should not depend on another light direction when geometry/materials stay fixed. Observed two-seed difference-of-differences is an estimator diagnostic, not proof of a physical dependence: Monte Carlo, adaptive sampling and MIS changes are not causally separated. Nonlinear AgX display response may change even with constant additive linear radiance.

analysis.json contains all signed components, positive/negative/nonzero area, RGB/Y moments, cross-case interactions and integer-PNG direction transitions for each fixed domain. two-seed-spread.json gives descriptive min/max/range, never a CI. RemainingResidual includes transmission/volume plus recomposition error; both are separately recorded.

Original foreground includes boundary/native-missing pixels that can expose the floor directly. Emit differences must not be confused with character illumination; inspect Emit and common/interior domains separately. No component-to-Combined fraction establishes native repair rate.
Native common coverage is only an analysis domain, never a replacement reference or input to native rendering. Radius2 interior removes all common-mask pixels lacking any of 25 Chebyshev neighbors. Display direction masks are per-seed ON/OFF classifications, not reference stable masks.

# Ground-emission ablation compact domain summary

All values are signed mean linear Y of paired ON−OFF rerenders. They are not isolated light-group values. Full signed effects, negative area and two-seed spread: analysis-001/analysis.json and two-seed-spread.json.

| View/seed/case | Emit FG | Emit common | Emit interior | Combined interior | DirectDiffuse interior | IndirectDiffuse interior |
|---|---:|---:|---:|---:|---:|---:|
| front/11/baseline | 0.023172280 | 0.003768005 | 0.000000000 | 0.028245857 | 0.023077919 | 0.002238005 |
| front/11/direction | 0.023160615 | 0.003764117 | 0.000000000 | 0.028216165 | 0.023071532 | 0.002218313 |
| front/29/baseline | 0.023163279 | 0.003765346 | 0.000000000 | 0.028366245 | 0.023161555 | 0.002251873 |
| front/29/direction | 0.023164002 | 0.003766432 | 0.000000000 | 0.028244876 | 0.023091037 | 0.002226472 |
| oblique/11/baseline | 0.024410453 | 0.004012287 | 0.000000074 | 0.026466326 | 0.021220630 | 0.001977293 |
| oblique/11/direction | 0.024410049 | 0.004015714 | 0.000000128 | 0.026487414 | 0.021286012 | 0.001932969 |
| oblique/29/baseline | 0.024394826 | 0.004002331 | 0.000000078 | 0.026514456 | 0.021276517 | 0.001974629 |
| oblique/29/direction | 0.024398568 | 0.004002305 | 0.000000042 | 0.026503388 | 0.021303283 | 0.001933069 |

Original foreground includes directly visible floor at missing/boundary pixels. Common depth reduces that contamination; the radius-2 interior almost removes Emit while retaining nonzero transport differences. Do not interpret full-FG Emit as character illumination. No component/Combined ratio establishes a native repair fraction.

Baseline→direction difference-of-differences remains signed and nonzero pixelwise. Tiny mean change does not imply pixelwise constancy; two seeds do not establish causal separation, convergence, a confidence interval or acceptance. AgX display response differences are separately reported through exact per-seed integer-luma classes.


## Interpretation correction: fixed indirect clamp

Original sample_clamp_indirect=10 remains unchanged. Ideal linear transport additivity does not automatically hold for the actual clamped Cycles estimator. Direction interactions may contain not only Monte Carlo/MIS/adaptive changes but also indirect-clamp nonlinear bias. These effects are not separated by two seeds. No parameter or reference was changed to enforce additivity.

## Implementation decision

The interior direct-diffuse difference around0.0212–0.0232 linear Y establishes a source-ground-emission omission worth a separate physical implementation experiment. It does not predict an image-score improvement or60% achievement. Combined interior difference is0.0265–0.0284; the full-foreground directly visible Emit contribution is a separate phenomenon, not character irradiation.

Do not simply add ground radiance to current world misses. Current native geometry omits the floor, so some rays through that missing boundary already receive world radiance. A future experiment would first introduce a black ground boundary as a separate world-occlusion control, then add only first-hit source-ground emission seen directly by the primary character receiver. Secondary-hit ground emission and reflected ground light should remain separately disabled until an explicitly separate indirect arm. Ground BSDF reflection is another component, not part of direct emission. Source geometry/normal and radiance must come from the scene, never these image differences. No such native implementation was made here.

## Controls, provenance and cost

Actual source ground: Warm studio backdrop, Principled Emission Strength0.25 and scene-linear color approximately(.84,.78,.65), corresponding source socket product approximately(.21,.195,.1625). Only the copied Strength socket was set to0. Original blend hash9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806 is unchanged. Geometry, surface BSDF, all node links/other sockets, world,3lights, shadow settings, camera, sample settings and profile remain fixed. ON control used the same material-copy/slot path and matches all43 old EXR channels bit-exact plus PNG pixels. Eight OFF renders completed; wall91.47seconds includes exhaustive scene audits, not a renderer performance benchmark.

Full before/after scene audits contain private geometry and remain local-only. The saved compact audit-summary contains only hashes, source-ground node/scalar parameters, the unique changed socket path and SHA references. No original meshes, images or HDR buffers are included in the code/report bundle.

Independent verification compares all eight scene-state changes, source/input pins, ON control and component math. It is a source/artifact/numerical audit, not an independent fresh Blender replay of the eight OFF frames. Evidence is under independent-review/. Formal reference and native inputs are untouched. No public release, PR, device operation, default change or global acceptance.

Independent numerical review:16EXRs decoded by another reader;8,166 aggregate values,23,256 descriptive-spread values and144 signed arrays/masks agree. Interior negative-difference pixels13–24 are retained, not clipped. These validate calculation/source consistency, not a two-seed statistical-confidence or native-quality guarantee.
