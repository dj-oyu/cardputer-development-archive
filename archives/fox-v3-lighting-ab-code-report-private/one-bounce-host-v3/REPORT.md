# World visibility and one-bounce diffuse: fixed v3 host experiment



**Not adopted. Goal NOT_ESTABLISHED.** All ten stable RGB agreements are below the previous direct-visibility OFF baseline. One bounce partly recovers the loss from world visibility alone, but does not materially fix oblique direction bright-position disagreement. No source/reference/threshold/default changes.



## Results



| Metric | OFF | World-visible | One-bounce |

|---|---:|---:|---:|

| front direction brightIoU | 63.2530 | 63.1719 | 64.7215 |

| front direction darkIoU | 77.6808 | 79.3706 | 80.5313 |

| front direction responseMagnitudeAgreementPercent | 76.5043 | 70.5252 | 72.3422 |

| front ambient responseMagnitudeAgreementPercent | 57.9098 | 67.5726 | 68.8311 |

| oblique direction brightIoU | 39.2231 | 38.6781 | 39.2683 |

| oblique direction darkIoU | 77.0934 | 78.7981 | 79.6924 |

| oblique direction responseMagnitudeAgreementPercent | 85.9873 | 79.4765 | 81.3113 |

| oblique ambient responseMagnitudeAgreementPercent | 54.1554 | 62.6807 | 63.1318 |



Full ten-color/eight-response comparisons, stable inactive false positives, uncertain counts, pooled and per-seed descriptions are retained in score-*-002, metrics.json and quality-review/. No averaging rescues a failed requirement. Shape/depth are unchanged. Missing native silhouette pixels remain in the full reference foreground error; native extra coverage is reported.



## Transport meaning and limitations

Primary visible DISK16 direct illumination is unchanged. World visibility replaces rhoX*world with miss-only cosine integration. One bounce adds rhoX times average reflected radiance at nearest hits: rhoY times visible DISK16 irradiance/pi plus visible world. No duplicated world, rho or pi. Ground geometry, direct ground emission, ground reflection, higher bounces, specular, AgX, bump/safe-normal correction and general animation support remain absent.

Hit physical side is selected by mirrored geometric winding and incoming direction; front/back SNORM values are independently preserved. Interpolated Ns dot outgoing <=0 is counted and reflects zero, not a world miss. 7,511–8,849 such events occur per full frame/order. This is an explicit approximation, not proof of a Cycles-equivalent normal contract.

Owned immutable BVH/attributes/lights survive model/source disposal and scene replacement. Generation tokens are caller-issued, not self-verifying. Synchronous full geometry capture and snapshot/light fingerprints provide the current host binding; reevaluation invalidation is caller-managed. No Pocket/JS present lifecycle integration or product RAM claim.



## Numerical accuracy

Fixed outer16/inner16 is a low-sample approximation. Analytic white/black plane and world fixtures validate units and double-count avoidance. Dense area plane response16=.06151239,64=.05920499,16384=.05850123 (about5.15% and1.20% high). A partial-square visibility fixture gives16=64=.5 but16384=.55639648, demonstrating coarse/fine agreement is not convergence.

Fixed fine outer64/inner16 oblique baseline completes with292,461,967 triangle tests of300M. Direction fails at y112 with exactly300,000,000 triangle tests; rays13,385,776/20M and nodes719,907,955/800M. Separate failure-001 instrument records the cause without changing the frozen renderer. Partial output is invalid, no direction response convergence score is available, and no quota was raised.

Baseline16 versus64 changes1,512 of5,156 covered RGB565 pixels. Per-channel MAE is .005080/.003112/.001514; maximum .129032/.095238/.064516. Depth is exact. First100 deterministic secondary-world queries compare16/64:46 differ, mean absolute visibility fraction difference.01703125, maximum.125. This subset does not bound whole-frame error.



## Capacity and runtime

Existing snapshot52,212/65,536B,45records, cold35,636B, model arena65,892B, instance584B and work2,655,947–2,766,638/8M are unchanged. Old work charges do not cover additional transport CPU.

Actual owned BVH326,496B plus transport scene75,128B (504control +1,166×64 attributes)=401,624B per generation. Two retained generations803,248B, excluding allocator overhead. Separate caps512KiB BVH +256KiB transport per generation; two-generation coexistence is a caller policy, not a global allocator guarantee. Build input temporaries34,368B geometry +74,624B attributes; context184B +transport budget48B. Existing two snapshots can add2×65,536B, plus depth/color scratch7,680/3,840B and existing controls/call stacks. Host main stack placement is not a firmware layout.

Primary direct budgets remain1M rays/100M nodes/50M triangles. Added frame-cumulative transport is capped20M rays/800M nodes/300M triangles. Full20 one-bounce renders use3.185–3.537M rays,173.970–192.416M nodes,72.487–79.591M triangle tests. Budget failure rejects render; partial bands are not published. Forward/reverse final pixels are exact, but intermediate depth winners and cost differ.

Controlled timing in timing-001/results.json: median raster OFF291.83–356.30ms, world639.28–758.19ms (1.965–2.319x OFF), bounce6436.14–7042.13ms (18.765–22.867x OFF). Measurement wall231.76sec; three alternating repetitions per arm and all ten forward cases, median/min/max, small-sample host-only. First-run reverse costs/counters remain in accounting and admission-summary; they are not a controlled speed benchmark. F64/FPU/device speed is unmeasured.



## Verification and reproducibility

Core nearest-hit, owned lifetime, source poison, atomic build/bind/failure, generation, alias, cumulative quota, cosine analytic/dense fixtures and pixel transport tests are included. Existing OFF buffers and all arm reverse-order RGB/depth are compared byte-exact. Independent O2 ASan/UBSan replay of all60 frames matches all120 RGB/depth buffers;4,050 independent metric values and14 metadata corruption negatives pass. Independent core O0/O2 ownership/budget/alias/nearest-hit tests pass. Evidence is saved under independent-review/.

Run tests/run.sh FRESH_TEST_DIR. For each arm use HONE_LINEAR_LIGHT=1 HONE_PHYSICAL_LIGHT=1 HONE_PIXEL_LIGHT=1 HONE_PIXEL_VISIBILITY=1 HONE_TRANSPORT_MODE=0/1/2 HONE_OUTER_SAMPLES=16 python code/run.py FRESH_RUN_DIR from this task root; original/private GLB input is required separately. Then python scoring/score_candidate.py FRESH_RUN_DIR/candidate-manifest.json --output FRESH_SCORE_DIR. Frozen v3 reference and private model are deliberately excluded from the code/report bundle.

001 inherited config prose is corrected in SCOPE_CORRECTION.md; frozen results are not rewritten. Score002 hardens exact reflected-hit/secondary-ray accounting without changing any metric or rendered byte. No publication, PR, flash, default adoption or claim of overall60% achievement.
