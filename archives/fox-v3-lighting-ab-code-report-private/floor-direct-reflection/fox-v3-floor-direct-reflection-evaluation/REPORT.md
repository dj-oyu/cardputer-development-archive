# First-floor-hit direct Lambert reflection, separate host experiment

Status: author controls40 + ON20 frames, all sample/position/strict admission and unchanged formal v3 scoring complete. Independent fresh rendering/numeric review is complete; isolated CPU cost and its independent timing check are complete. No default adoption or global60% result. The current lid8 model, source/ref/thresholds, quarter offsets, AA mask, direct lights and original world remain fixed.

## One bounded new path

Only an existing primary cosine ray's first tagged floor hit receives source-linear floor rho times the existing three-DISK16 direct Lambert evaluator. The returned evaluator already includes floor rho and normalization; receiver rho times its result is averaged over outer16. Existing primary floor Le is added exactly once. No new secondary floor emission, floor world reflection, specular/complete Principled, higher bounce, camera background, sample count, gain or exposure change. Original source floor Principled remains untouched. Stored hidden Weight0 is unavailable/unlinked and omitted by Cycles export, not proof of zero BSDF.

Floor receiving normal is raw source-world Ng oriented toward -incoming, independent of mirrored character orientation; exact tangent skips the new term. Existing1e-5 world-unit segment endpoint exclusions and1e-9 disk proximity checks remain. Floor rho is the original float socket value (.8399999737739563,.7799999713897705,.6499999761581421); albedo uses actual source float results (.5040000081062317,.46799999475479126,.38999998569488525). No RGB565 or sRGB decode of this rho. Le is unchanged across scenarios.

## Two different work contracts

A2 AA ledger stays front7923890/oblique7673634, unchanged8M limit. The added48 kernels per floor hit alone exceed the remaining76110/326366 allowance. Combined historical8M admission FAIL is preserved; the new work is not hidden inside old shader charges.

Explicitly authorized separate host floor reservations are shader128, tagged floorhit192, each invoked fixed48-kernel evaluator12000 semantic stages. Global additional cap875970912; percase limits use pinned A2 geometry/snapshot/shader/floorhit counts, never image errors. Validation/setup/normal/loops/callback dispatch/reduction/accumulation and merge are prepaid, no refund on early failure. Libm is a primitive stage, not a machine-instruction bound. Visibility implementation has its own unchanged cumulative20M ray/800M node/300M triangle quota. These two accounts are not claimed as exhaustive scalar machine work or equivalent old8M units.

All20 ON complete. Max actual transport8,007,013 rays /426,877,219 nodes /137,173,296 triangles, within unchanged caps. Geometry/BVH/snapshot remain unchanged, snapshot64208/65536. Floor evaluations max71667, new visibility queries max3246752. Per-frame floor reservations and completed category counters match exactly; failure would leave no quality manifest. Final ray identity adds floor queries to old primary+secondaryworld+nonfloor direct, without reclassifying old counters.

## Ownership and memory

Only four transport source files change. Product, physical disk evaluator and visibility trees are byte-identical to frozen A2. New explicit mode3/experimental evaluator owns rho with the floor descriptor; old evaluator rejects mode3. Rho change requires material generation, mode/identity/range/Le requires emission generation. Copy/poison/retained old scene, mismatch/alias/budget/failure-atomic tests pass. Descriptor comparisons are fieldwise, not padding hashes.

Host64 measured: owned transport100808B (+24), descriptor72, context576, result256, work232. Old/new scene pair adds48 persistent bytes relative to its old equivalent, but complete retained allocation peak is not inferred from that delta. AA workspace137312 and reserve8192 unchanged; named core stack chain4976 fits that reserve. Native main stack81776 and observer272 are separate and include existing fixed snapshot/band buffers; libc/libm/FILE internals and32bit/device memory are not established. Multilib headers unavailable, no32bit fit claim. Per-sample component JSON is diagnostic I/O, not production storage.

## Controls, failures and strict provenance

Initial actual-001 OFF/zero attempt stopped with0 successful published frames: the new wrapper compared unassigned stats before transferring the completed AA report. This was an adapter ordering bug, not a physical or quota failure. Old attempt/source/freeze are retained. Separately frozen native_render_v2 directly compares completed report shade counts, without guard relaxation; actual-002 is the completed run.

OFF and zero each20 frames match original A2 RGB565/depth/snapshot/target masks and old ray/node/triangle counters exactly. Zero uses the new API but skips disk evaluation, new queries and reflected components; separate host descriptor/hit work still counts. Both full controls passed before ON. All60 frames pass forward/reverse RGB/depth equality. ON changes illumination at both AA-target and non-target receivers, so old non-target RGB equality is not incorrectly required; geometry/depth/masks/identities remain exact.

All20 wrong scenario/binding C tests reject before rendering or files. Strict v2 fixed exact sizeof admission; strict v3 additionally rejects bool/nonfinite rho and wrong generations. Earlier validators remain preserved. Every strict negative suite begins with accepted actual templates, including shade/floor bounds±1. Sample audits reconstruct four linear HDR means with black nohit/denominator4 then existing sRGB565, and all observed direct/world/nonfloorbounce/groundLe/newfloor components recompose exactly. Position audit rechecks actual recorded sample geometry at unchanged quarter offsets. Independent fresh core O2/O1ASanUBSan and all legacy suites pass; fresh full-frame review also passes for ON20 and OFF/zero baseline4 each (28 independently rebuilt frames).

## Quality: color improves, response regressions remain

All10 stable color agreements improve2.0695–5.3863 percentage points; all10 pooled fullFG color agreements improve2.7423–6.5894pp. Original uncertain regions and all8 reference seeds remain scored, not masked away.

The critical oblique direction brightening IoU worsens44.4444→43.0147%; inactive false responses98→110 and reverse signs111→127. Front direction improves brightIoU68.7789→71.4381%, inactive89→79, reverse110→108. Direction magnitude improves68.8388→84.3075% front and76.6396→93.0165% oblique, which does not erase the bright-subset regression.

Ambient response worsens in both views: brightIoU73.1777→63.7268% front and73.7416→62.3940% oblique; magnitude65.3657→47.0610% and69.4403→48.4406%. Intensity darkIoU improves78.6162→88.5318% and79.9372→92.2535%, but inactive false responses16→34 and8→26 rise. Albedo magnitude and darkIoU improve. Across all domains/seeds,2333 scalar metrics were compared,1296 changed and153 regressed; these are scalar entries, not153 independent conditions.

Direction unknown729/698 remain unknown, not PASS. Full response FP/FN, inactive, reverse and unknown confusion matrices are in comparison/summary.json. All formal geometry/center-depth missing620/719 and extras11/8 remain unchanged. Fixed AA sample support is also unchanged; adding reflected light is not geometry reconstruction.

Per-component descriptive statistics cover only the fixed AA-target pixels, not every full-frame receiver. The first supplemental component/clipping summaries incorrectly averaged adjacent four rows despite sample-major storage. Their per-pixel maxima, sign/clip counts and response interpretation were withdrawn and replaced by v2 coordinate-keyed reconstruction with independent verification. Formal RGB565 scoring and the original sample audit already use explicit coordinates, so they are unaffected. The old supplemental files remain as superseded evidence; no native input or output changed. This does not attribute all original source GI or every regression to floor reflection or saturation.

The color gain and response losses are both real findings of this fixed surrogate arm. Global acceptance remains NOT_ESTABLISHED, and the default is not adopted. No gain/exposure/sample/secondary-path adjustment follows to rescue it. Camera background remains a separate, unimplemented proposal.

## Host CPU cost

Completed isolated12-frame interleaved OFF/ON × baseline2views ×3 repetitions after independent heavy work. Functional parallel-run times are not used as a speed comparison. Both modes include the same diagnostic component observer design; elapsed measurements include I/O and cannot claim device speed or pure shader cost.

## Supplemental correction and independent closure

V2 explicitly joins (y,x,sample), checks the complete fixed target set and all four unique sample IDs, then adds samples in index order. All794 supplemental values independently match, correcting230 v1 mismatches. Correct baseline AA-target HDR>1 counts are front616→852 and oblique607→803; old534→793/506→704 values are invalid. New floor ambient component difference remains exactly zero, and total averaged linear ambient response differs between modes by at most8.88e−16. These findings apply only to fixed AA-target samples, not whole-frame HDR or source GI attribution. Original558 actual output hashes remain exact and formal score did not change.

Independent numeric review confirms4050 formal values,920 runtime values,573120 sample rows/143280 target encodes, unchanged old four components, OFF/zero old HDR exact and7168 strict negative cases. Independent fresh native build reproduces ON20+OFF4+zero4 complete artifacts and non-timing metadata. Source/input pins unchanged. No independent review blocker remains.

CPU12 byte/pin checks pass with the same native binary in both modes. All raw values are retained. The diagnostic observer writes the same component schema in both modes, but I/O volume and values vary; elapsed times include that I/O. Three repetitions and fixed OFF-before-ON order are host reference evidence, not a device forecast.

- A-front (OFF): render min/median/max 12.170809/12.568924/12.579527 s; evaluate 9.565195/9.824588/11.183888 ms; wall 12.187855/12.586003/12.599367 s.
- A-oblique (OFF): render min/median/max 11.398413/11.695400/11.986408 s; evaluate 9.520661/10.835750/13.485511 ms; wall 11.415577/11.713766/12.009625 s.
- B-front (ON): render min/median/max 14.980104/15.178182/15.462465 s; evaluate 9.305075/9.523624/10.289060 ms; wall 14.997589/15.195123/15.481474 s.
- B-oblique (ON): render min/median/max 14.263425/14.489750/15.522120 s; evaluate 9.151523/10.352562/10.667665 ms; wall 14.282953/14.507272/15.538080 s.
- front ratio of render medians ON/OFF: 1.207596.
- oblique ratio of render medians ON/OFF: 1.238927.

Before/after one-second raw /proc/stat observations are retained, along with namespace-visible PID/command-name/state/CPU/memory lists (no command-line arguments). Busy fractions0.6667% and0.3330%; load averages0.52/1.00/1.25 and0.58/0.89/1.15. Three processes were visible, and parent confirmed no known competing heavy work. This is not proof of globally absent host contention.

Independent cost review verifies12 raw timing rows,72 summary statistics,36 buffer hashes,1044 non-timing metadata values,212 input pins and both before/after raw-jiffy calculations. Ratios of render medians ON/OFF are1.20760 front and1.23893 oblique; medians of paired-repeat ratios are1.20760 and1.27121, respectively. These differ and are not interchangeable. Observed host elapsed cost rises in this small fixed-order measurement, but no device timing or stable universal slowdown is claimed. All source/input/output evidence remains fixed.
