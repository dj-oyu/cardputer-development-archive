# Attribution of the fixed scene-composition change

Across all10 cases, every reported covered-interior and opaque-covered-interior color, response, per-seed and uncertainty metric is exactly unchanged. Character raw samples and formal character geometry are also preserved by separate admission gates. The large foreground color gain is concentrated in the predetermined partial-alpha edge and center-missing domains. It is camera scene composition, not demonstrated improvement to interior character lighting or geometry.

## All10 descriptive RGB MAE by original domain

| Case | Partial-alpha OFF→ON | Opaque-alpha OFF→ON | Center-missing OFF→ON | Covered-interior OFF=ON |
|---|---:|---:|---:|---:|
| front-baseline | 0.486361 → 0.153786 | 0.186320 → 0.185925 | 0.653192 → 0.095955 | 0.183531 |
| front-direction | 0.487475 → 0.157815 | 0.191529 → 0.191219 | 0.649025 → 0.095593 | 0.185423 |
| front-intensity | 0.477284 → 0.149727 | 0.165660 → 0.165369 | 0.643854 → 0.094074 | 0.158624 |
| front-ambient | 0.522697 → 0.175006 | 0.195299 → 0.194816 | 0.700838 → 0.124123 | 0.195473 |
| front-albedo | 0.444286 → 0.138526 | 0.146131 → 0.145984 | 0.600048 → 0.086387 | 0.134623 |
| oblique-baseline | 0.509268 → 0.170388 | 0.195736 → 0.194597 | 0.664949 → 0.117331 | 0.197966 |
| oblique-direction | 0.510619 → 0.171206 | 0.188239 → 0.187522 | 0.667599 → 0.118887 | 0.186354 |
| oblique-intensity | 0.499783 → 0.167013 | 0.169472 → 0.168788 | 0.655486 → 0.118313 | 0.167914 |
| oblique-ambient | 0.538845 → 0.188461 | 0.205835 → 0.204553 | 0.704436 → 0.141365 | 0.210232 |
| oblique-albedo | 0.467352 → 0.152871 | 0.146942 → 0.146418 | 0.613230 → 0.107338 | 0.140135 |

## Response trade-off

Direction inactive false positives increase front 89→107 and oblique 98→142. In the fixed center-missing domain they increase front 15→31 and oblique 12→53, accounting for 16 of 18 and 41 of 44 added full-foreground inactive false positives. Full confusion tables retain reverse signs, FP/FN and unknowns for every fixed domain and all8 contrasts. Unknowns are not accepted pixels.

The four worsening color-subset entries are oblique-direction unknown opaque-alpha (+0.000446725) and unknown opaque-covered-boundary (+0.000964480), oblique-intensity unknown opaque-alpha (+0.000367226), and oblique-albedo unknown opaque-alpha (+0.000201620). These are overlapping descriptive domains, not four independent failures. Other formal/response regressions are listed completely in all-comparison-001/REPORT.md.

The synthetic background-only control stays descriptive, outside formal shape. Full-frame gains are not used to claim goal60, old resource cap compliance or device fit.
