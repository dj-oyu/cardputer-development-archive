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
