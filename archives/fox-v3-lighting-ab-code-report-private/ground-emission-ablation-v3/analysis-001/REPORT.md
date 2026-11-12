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
