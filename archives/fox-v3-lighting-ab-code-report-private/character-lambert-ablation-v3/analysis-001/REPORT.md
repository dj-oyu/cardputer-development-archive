# Character rich-minus-Lambert paired ablation

Two seeds (11, 29), front/oblique × baseline/direction. Signed ON−OFF linear effects are retained without clipping or energy fit. No confidence interval, new stability mask, acceptance, or native input modification.

| View / seed / case | FG signed mean Y | FG mean abs Y | Common signed mean Y | Interior signed mean Y |
|---|---:|---:|---:|---:|
| front/11/baseline | 0.03848052 | 0.04138479 | 0.04158365 | 0.03264428 |
| front/11/direction | 0.03849785 | 0.04086273 | 0.04159986 | 0.03204919 |
| front/29/baseline | 0.03843422 | 0.04143677 | 0.04156524 | 0.03277353 |
| front/29/direction | 0.03838438 | 0.04082935 | 0.04151305 | 0.03204346 |
| oblique/11/baseline | 0.04090707 | 0.04334135 | 0.04485452 | 0.03976455 |
| oblique/11/direction | 0.03947926 | 0.04174495 | 0.04319366 | 0.03725530 |
| oblique/29/baseline | 0.04096646 | 0.04332331 | 0.04481647 | 0.03973334 |
| oblique/29/direction | 0.03956345 | 0.04175411 | 0.04315471 | 0.03740467 |

## Does the material response change with light direction?

| View / seed | FG interaction signed Y | FG interaction abs Y | Interior interaction signed Y | Interior interaction abs Y | PNG direction-effect RMSE Y (FG) |
|---|---:|---:|---:|---:|---:|
| front/11 | 0.00001734 | 0.01227500 | -0.00059510 | 0.01350356 | 0.01557840 |
| front/29 | -0.00004984 | 0.01218623 | -0.00073007 | 0.01337117 | 0.01552476 |
| oblique/11 | -0.00142781 | 0.01181659 | -0.00250925 | 0.01281123 | 0.01798807 |
| oblique/29 | -0.00140301 | 0.01182972 | -0.00232867 | 0.01258727 | 0.01794085 |

Rich-minus-Lambert changes the character BSDF, diffuse weight and specular transport jointly, in both direct and indirect paths. It is not a pure specular removal or a native implementation result. The paired difference includes path/MIS/Monte Carlo changes and fixed indirect clamp10 nonlinear bias. Two seeds are descriptive only. Ground BSDF/emission, world, geometry, lights, original profile and filter are unchanged.

analysis.json contains all signed components, positive/negative/nonzero area, RGB/Y moments, cross-case interactions and integer-PNG direction transitions for each fixed domain. two-seed-spread.json gives descriptive min/max/range, never a CI. RemainingResidual includes transmission/volume plus recomposition error; both are separately recorded.

Original foreground includes boundary/native-missing pixels; full foreground is retained and conditional common/interior masks never replace it. No component-to-Combined fraction establishes native repair rate.
Native common coverage is only an analysis domain, never a replacement reference or input to native rendering. Radius2 interior removes all common-mask pixels lacking any of 25 Chebyshev neighbors. Display direction masks are per-seed ON/OFF classifications, not reference stable masks.
