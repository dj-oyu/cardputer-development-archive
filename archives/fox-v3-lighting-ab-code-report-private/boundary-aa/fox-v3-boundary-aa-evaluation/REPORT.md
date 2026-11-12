# Selected center-boundary true subpixel AA (host experiment)

## Contract and limits
This is a new, explicitly approved host-only final-visible-surface API. It is not the old renderer's error contract: hidden intermediate shader failures are not evaluated on additional samples. The old FAIL/new SUCCESS fixture is retained. The center pass and OFF path retain the old API. Every packet still undergoes memory-safety/finite/index/identity validation; a final shader failure, observer failure, or cumulative budget failure aborts the frame. No failed/partial frame is scored.

The original 49-per-bbox approach fails the front 8M reservation (8,199,728). This failure is retained. ON uses a separately approved 21-category stage ledger, not a claim that the same numeric 8M means the same old work unit. Final conservative reservations are front 7,950,858 and oblique 7,725,926; all category counters must fit their individual reservations. Center direct and transport budgets are shared cumulatively with all additional samples, with unchanged limits. No shrinking targets or adjusting reservation rates after failure.

Selection is frozen from center coverage and actual source-object ID, with nohit and screen-outside sentinel 65535. A pixel is selected if any of four axial neighbor IDs differs. Both foreground and adjacent nohit pixels are included. It is not a guarantee of all geometric boundaries: thin geometry missed by all centers and same-object overlaps can be missed. No RGB, reference, error, or resulting AA mask is used to choose/rechoose pixels. Front 2385 and oblique 2391 targets; source ID is not packet/node ID.

Each target receives four actual geometry queries at (+/-0.25,+/-0.25), final depth winner only, actual world P / front-back SNORM / rho / lighting. Nohit contributes linear black with fixed denominator four. The four linear HDR colors are averaged before the existing sRGB and RGB565 encoding. Non-target bytes remain OFF exact. This is true selected subpixel sampling, not an integer blur. Formal depth remains original center depth; sample coverage is a separate support diagnostic and is not geometry improvement.

## Memory and provenance
Actual workspace 137312 B plus explicit new transient stack reserve 8192 B totals 145504 B within the 147456 B workspace allowance. Retained full RGB/depth outputs are separately 194400 B. Source identity RO is 7930 B. These are host-only costs, not device fit. Snapshot remains 64208 B within original 65536. Band HDR storage is reused only after identity validation and is completely cleared; last band has seven valid rows. Private identity tables, sample JSON, geometry, snapshots, images and pixel masks are not distributable bundle artifacts.

Core freeze: f962f10f50dff7ea34ca7dd0632a577a4a125122d924cd62f76c6c29b12a6607.
Integration freeze: 786a2c49ac104079e849f54048ec0532f3402fb15f4ea6ccaf6b942301b49e1e.
Actual binary: 9d62fb7205ec6dd8c3b6e5ac0fbad8a7008e894b0f7cd77f2e003b0172c246c8.
Source GLB/reference/lighting/materials/profile/thresholds are unchanged. The formal score function is imported directly from the frozen lid8 evaluator, with a new strict provenance/sample-output admission loader. The legacy no-color-outside-center-depth loader is not used because selected subpixel coverage can legitimately reach center-nohit pixels; sample-support and output controls replace that assumption explicitly.

## Controls and execution
OFF all20 actual C frames complete: every RGB/depth/snapshot byte and non-timing native metadata matches frozen lid8. Formal numeric results and all ten mask arrays are exact, excluding only candidate/provenance metadata and scoring-implementation annotations. See actual-001/off/OFF_SCORE_CONTROL.json.

Core independent O0/O2 ASan/UBSan, 21-category exhaustion, mixed mode4/mode5, generation-map ambiguity and source-ID checks passed. Geometry constant-shader all20 controls passed. LSan was not available under the environment's ptrace conditions and is not claimed.

ON all20 actual C, forward/reverse equality, complete per-sample controls, strict v3 formal scoring and independent fresh-C verification are complete. Timing remains a separately labeled host measurement below.

The executable entrypoint accepts only fixed pinned ledger files, verified by input hashes before execution and after all frames; arbitrary standalone native ledger text is not a verified interface. The native numeric parser is not claimed hardened for untrusted arbitrary input.

## Timing plan
After independent heavy work ends: serial OFF/ON x baseline front/oblique x three repetitions = 12 frames, same frozen binary and flags, output bytes and input pins checked. Retain all raw elapsed values and min/median/max. ON unbuffered per-sample JSON observer I/O is included in render/wall timing; this is an instrumented host comparison, not isolated kernel overhead or device performance. This intentional limitation avoids changing the currently controlled executable solely for a different measurement.

## Completed actual results (author run)
All ON20 frames completed within every cumulative cap, with forward/reverse RGB/depth exact. Center depth and snapshot remain old exact. Sample controls are checked per actual target/sample, not estimated: 9540 selected samples/front frame (7678 hits), 9564/oblique (7365 hits). Across every case/order, all target colors independently reconstruct exactly from four recorded linear colors; all non-target bytes remain OFF exact; nohit is black with denominator four. See SAMPLE_AUDIT.json for exact per-frame sample counts (no sample truncation).

Observed stage totals are front 7,712,002 and oblique 7,459,590; reservation rather than observed usage governs pre-admission. Front baseline cumulative transport uses 4,557,877 rays, 321,144,551 node visits, 112,171,671 triangle tests. All actual counters and unchanged caps are retained in comparison/summary.json.

All ten stable and all-foreground descriptive color agreements increase. Stable color increases by 1.2002–1.8438 percentage points; full-FG increases by 1.0099–1.6734 points. Direction stable bright IoU improves front 65.4050→68.7789%, oblique 39.2374→44.4444%; oblique remains below60. Every applicable stable bright/dark IoU improves, but this does not establish global acceptance or resolve unknown pixels.

There are regressions: direction inactive false responses front69→89, oblique85→98. Bright FP within stable increases95→104 /104→110, dark FP85→95 /94→99. Bright FN declines426→369 /390→345 and dark FN445→374 /714→649, explaining improved IoU despite more false positives. Reverse signs change only111→110 /113→111. Direction unknown remains729/698 and is never counted PASS. Intensity inactive false responses also rise10→16 /7→8. Ambient/albedo stable inactive false responses remain zero. Full eight response conditions, all foreground/uncertain metrics and all seeds are retained without adding thresholds.

Sample support adds170 front pixels with no loss; oblique adds186 and loses1 center-covered pixel (net +185). This is AA footprint support, not a geometry change. Oblique support extras increase8→14 and missing pixels decrease719→540; formal center-depth shape remains missing719 and extras8. The original geometry gaps and selection limitations remain.

## Admission revisions and audit provenance
The initial report validator accepted underreported workspace/stack, an incorrect success failedCategory, and floating expected reservations. Actual recorded values were normal. The frozen runner and original validator are preserved; no renderer changed. Strict outer v2 fixes exact workspace137312/stack8192, success sentinel21 and integer expected reservations; 387 regression cases pass while original failures remain explicitly recorded.

A further v3 loader checks exact complete20 keyset, boolean reverse, row metadata against the actual JSON, strict fixed direct/transport caps again, and every output including support.npz against an externally pinned output-freeze SHA supplied at admission. Its formal results match v2 exactly except provenance. ACTUAL_OUTPUT_FREEZE SHA b7bf9126d854008ca413233287ce3d1460b5fa50ca8eeaafd7741b77afa96df2. Old v2 score/code are retained; final score-v3 is authoritative.

Observed host ELF sections (same toolchain, not isolated product-only ROM): new executable text162012/data1192/bss16 vs old135143/968/16, increases26869/224/0 B. This includes the new experimental API, source identity RO table, adapter and diagnostic strings. It is not a device link/map or a claim that all bytes are incremental deployable product code. Private generated identity content is not included in the saved code bundle.

Independent formal v3 recomputation matches 2980 values, all20 reference/center mask sets and163 output pins. It identifies148 regressing metrics across full/uncertain domains and individual seeds; these are retained in reviews/metrics-independent-summary.json, not suppressed by favorable color/IoU summaries. In particular intensity stable response-magnitude agreement declines front91.8717→89.6600% and oblique98.2263→96.2219%, despite slightly lower luma RMSE. Formal geometry missing remains620/719, while AA-support missing458/540 is a distinct footprint diagnostic.

## Isolated host timing complete
All12 serial frames completed with36 RGB/depth/snapshot buffers byteexact and all input pins unchanged. All18 ON observer/sample-mask/report auxiliary outputs also match functional runs exactly. Raw three repetitions for each arm/view and min/median/max are in cost-001/RESULT.json. ON includes unbuffered JSON sample observer I/O; OFF does not, so these numbers are instrumented host execution costs, not a clean product-kernel overhead estimate.

- front off: render min/median/max 8606.326/9148.620/9185.184 ms; evaluate 10.209/10.649/12.385 ms.
- front on: render min/median/max 12587.083/12747.058/13014.296 ms; evaluate 10.109/10.521/10.617 ms.
- front instrumented median render ratio ON/OFF: 1.3933x.
- oblique off: render min/median/max 7979.238/8264.164/8398.531 ms; evaluate 9.411/10.217/11.296 ms.
- oblique on: render min/median/max 11868.892/11953.173/12351.990 ms; evaluate 10.985/11.464/21.148 ms.
- oblique instrumented median render ratio ON/OFF: 1.4464x.

No public/default/device change, no source/reference/threshold edit, no geometry mutation, and no global60% acceptance is claimed. All results are this fixed host experiment and frozen scenes.
Independent timing review matches all36 statistics,36 buffer hashes and168 input pins. Independent fresh C reproduced ON20 and OFF baseline2, with image/snapshot bytes and non-timing metadata exact. Independent core/admission/sample/metric/timing review reports no remaining blocker. These checks do not turn the host experiment into a production/device-fit implementation.
