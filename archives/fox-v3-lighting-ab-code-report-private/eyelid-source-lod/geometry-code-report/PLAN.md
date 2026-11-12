# Final source-ring upper-eyelid LOD plan: 8 and9 stations

**No candidate GLB or scene object has been generated.** Read-only source measurements support a finite8/9station plan. Generation awaits the parent after independent contract review. No image, pixel or previously observed ray participates in station selection.

Same source and eyeB pins/target scope as CONTRACT.md. Only two Upper eyelid objects may change. Use exact evaluated source positions and unique corner normals from selected original rings; keep source frame phase and open ends. Do not mirror the asymmetric curves. All eyeB ellipsoids, cheek/Smile geometry, sockets, glints, materials and unrelated streams remain unchanged.

## Fixed source-only measurements

| Stations | Vertices/triangles per lid | Max centerline chord error | Max sampled bidirectional surface distance | Surface max / radius | Standalone compiled vertices per lid |
|---|---:|---:|---:|---:|---:|
| 8 | 48 / 84 | 0.01071716 | 0.01313777 | 1.0106 | 56 |
| 9 | 54 / 96 | 0.00461028 | 0.00662709 | 0.5098 | 62 |
| 10 | 60 / 108 | 0.00426761 | 0.00621784 | 0.4783 | 76 |

Both sides agree to floating-point source-coordinate accuracy.9station directed surface maxima: source→template0.00662709, template→source0.00623654; corresponding finite-sample means0.00156794/0.00127725.8station maxima0.01313777/0.01164544 and means0.00224923/0.00157560. Source samples include all1164vertices plus2304triangle centroids; reverse templates use a fixed degree4 barycentric lattice. These are finite sampled distances, not continuous Hausdorff guarantees.

Greedy selection is explicitly driven by maximum sampled CENTERLINE chord error, not by global surface error. Full-surface metrics are independent diagnostics. The6 original alternating cross-section vertices retain original radius/positions/normals; direction-dependent thickness still decreases. Minimum width≈0.02251658 compared with original12-sided tube≈0.0251139 (89.66%) and analytic circular diameter0.026 (86.60%). No cross-section phase search.

All four8/9-side preflight templates pass consistent winding, positive Ng·sourceNs (min0.78142/0.83931), nondegenerate faces, connected cylinder Euler characteristic0, no nonmanifold edges, and exactly two6-edge open boundary loops. Source vertex/normal correspondence and selected endpoint coordinates are exact. Every source vertex has a single corner normal; no arbitrary split-normal choice is needed. No cap/ribbon substitute is introduced.

## Budget rationale and fixed scope

8stations:48V84T per lid, standalone partitions32V50T +24V34T,56compiled vertex occurrences.9stations:54V96T, partitions32V50T +30V46T,62compiled occurrences. The resulting character would have1564 or1588triangles respectively, replacing the existing18lid triangles.

10stations was examined before any candidate image existed and is retained as a planning rejection:60V108T per lid needs three standalone parts and76compiled vertices, compact4180B per lid versus3428B for9. It buys little additional surface accuracy (0.006218 versus0.006627) while its nominal total66372B exceeds65536. The approved8/9plan is therefore a source-error/partition-cost decision, not image fitting. No third variant will be tuned after candidate results.

Conditional total snapshot forecasts from codec baseline58844B:8compact64196B,9compact64868B. If both new lids require legacy56B-vertex fallback, forecasts become64868/65612B respectively, so9may fail. These assume replacing isolated old-lid records; real material-group mixing/partitioning can differ. Actual compile/prepare, per-record codec eligibility, all-condition snapshot/work/visibility/transport caps are mandatory. Do not change codec or triangle ordering to rescue a failed candidate within this task.

Parent owns actual evaluation. Full geometric agreement is not an absolute prohibition on already-authorized experimental rendering; report raw shape/ordering mismatches separately from practical visual improvement and regressions. Choose only among the two fixed resource-admissible candidates, considering complete source-shape error and full eye-unit evaluation rather than a selected pixel.

Evidence: CONTRACT.md, final-plan-summary.json, preflight-topology.json, source-normal-audit.json, cross-section-widths.json, original8/10 planning results and9 full results. Source raw coordinates/normals/control points and per-vertex maps remain private, excluded from report/code bundles.
