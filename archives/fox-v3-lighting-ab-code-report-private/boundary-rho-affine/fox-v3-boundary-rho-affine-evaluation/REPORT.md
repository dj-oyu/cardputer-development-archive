# Separate rho-affine numerical repair and fixed-quartile AB

Status: author and independent A2/B2 full evaluation complete; isolated 12-frame CPU comparison complete with byte and pin checks passing. Fixed-q quality changes are small and include regressions. This is a separate authorized numerical stage following the frozen original BH experiment's first-frame rejection. The earlier failed B remains0complete/unscored, with no CPU comparison; it is not retroactively labeled successful.

## Fixed intervention and original failure

Only experimental final-sample rho interpolation changes to a+u*(b−a), then+v*(c−a), with original float565 decode and original64DBL_EPS finite/range/clamp bounds. All3 barycentrics and9 decoded components explicitly finite-checked. All inputs are read and all3 results validated before output commits. No barycentric normalization, P/Ns/depth/edge/tie/mask/light/material/source/reference/threshold changes. Helper is private; old default paths remain unchanged.

The original B failed because constant red1 interpolated as1.0000000000000204, above old1.0000000000000142 upper bound. Independent original C arithmetic confirmed pre-shader rejection. No normal or quota relaxation was used. q stays0.28820947825813636 (hex0x1.272062ae104d0p-2), equal tensor4weights1/4. A2 stays±.25. Neither approximation equals Cycles full finite-table filtering.

## Extra work is explicit

Checking12extra inputs at all-target upper9540would make front8,066,202 and fail8M. Parent separately authorized host geometry-only exact-hit preflight. Old bound failure is retained, no target reduction. Preflight reads fixed owned snapshots and geometry-derived masks, independently reproduces all40 arm/case/order coverages and checks every covered interpolated depth finite. No image/reference/error selection. It does not shade.

A hits front7678/oblique7365; B7674/7370. Each final hit now costs76stages, prior64+12inputchecks; additional binding/count control64 is charged. New reservations A7,923,890/7,673,634; B7,924,450/7,677,854. Original8M cap, direct1M/100M/50M and transport20M/800M/300M unchanged, single cumulative center+all4samples budgets. These stage units and separate preflight are not equivalent to historical49/bbox work or the earlier all-target reservation contract.

The20-row snapshot binding/count table uses320B plus40Btarget totals, new360B RO separately accounted, in addition to unchanged7930B identity table. Snapshot64208/65536, renderer workspace137312, stack reserve8192, retained RGB/depth194400 are unchanged. Compiled AA function stack1696 versus1632 (+64), within reserve; not device fit. Preflight static scratch130336 plus mainstack560 and decoder stack are separate. Preflight timing explicitly sequences hashes before endclock; wall includes subprocess/I/O/parent pin checks. Old incomplete-timing results retained as v1/v2, final result separately pinned.

Before rendering, current owned snapshot binding must match the pinned table and ledger76×predicted hits. After complete rendering, each of4actual hit counts and target total must match before RGB/depth publication. Total hit overflow exhausts its category; undercount/redistribution/unknownsnapshot reject. Source/model/pose/camera/mask hashes fixed. FNV binding is accidental-mutation detection, not standalone cryptographic authorization; external SHA256 pins remain required. Private partial observer/snapshot files can exist on failure, but no completed quality manifest or image-body publication is allowed.

## Completed controls and fixtures

A2 OFF20 and B2 OFF20 match old renderer RGB/depth/snapshot exactly. A2 ON20 matches frozen v32 RGB/depth/snapshot/target mask in80files. All191040 A2sample P/Ns/depth/winner/side/source fields unchanged exactly; rho maximum difference2.220446049250313e−16 and linearRGB1.7763568394002505e−15, final565unchanged. Those finite-roundoff differences are not hidden by claiming raw HDR equality.

Synthetic helper247722 checks cover decoded constants, convex/mixed endpoint attributes, all6vertex permutations within explicit error, huge finite constant weights (not a weight-validity proof), finite overflow, nonfinite any bary/decoded input, late-channel failure atomicity, alias-safe commit. Independent O2/O1ASan and additional64eps/nextafter fixtures pass. Original quarter-node zero-normal/hidden-failure fixtures remain. Table222checks/arm reject unknownbinding and count up/down/redistribution. Strict report133mutants/arm reject wrongtypes/counts/pins/categories with valid template accepted first.

B2 full20 and all sample/position/score audits complete. Independent fresh A2/B2 reproduction and isolated A2/B2 CPU comparison also complete. No tuning/otherpositions/weights will follow this one AB. All formal domains, unknowns, FP/FN and regressions will be reported; filter support will not replace original center-depth geometry metrics.


## Completed fixed-q quality comparison, independently verified

All20 B2 frames complete within unchanged caps, forward/reverse565/depth exact. Every sample and non-target pixel passes reconstruction/black-divisor/linear-order tests. All10 stable color agreements improve only0.186–0.286percentage points; fullFG0.164–0.252pp. Direction brightIoU front68.7789→69.0586%, oblique44.4444→45.6548%, still below60 in oblique. All applicable stable bright/dark IoUs increase, but this is not uniform metric improvement.

Regressions: front direction brightFP104→108, inactive false89→91, reverse-sign110→111; oblique direction magnitude agreement76.6396→76.4459%, reverse-sign111unchanged. Intensity magnitude front89.6600→89.4013%, oblique96.2219→95.7178%; oblique intensity false-dark/inactive8→11. Oblique direction brightFP110→108 and FN345→336 improve, darkFN649→638 improves while FP99unchanged. Unknown direction729/698 remains excluded from PASS and separately reported. The complete all-domain/all-seed comparison records188 regressing scalar metrics, not188 independent conditions. No subset is promoted into a global success.

Formal centerdepth/geometry metrics remain unchanged: missing620/719, extra11/8. Sample-support missing458→439 /540→507, but extras19→22 /14→16 worsen. These are filter-support changes, not geometry reconstruction improvements or substituted formal masks.

B2 maxima across all20: stage7,804,809; transport4,804,962rays/329,268,277nodes/117,144,963tests; direct441,507/27,546,340/8,858,212. A2 stage7,804,202; transport4,808,773/329,358,214/117,192,737; direct441,552/27,515,446/8,855,248. New geometry-conditioned reservations remain conservative and actual4counts exact for every frame.

The one-shot offset proposal should not be adopted as a renderer-quality breakthrough: improvement is small, regressions remain, the goal is unestablished, and the predetermined no-tuning rule applies. Preserve v32 quality baseline; treat rho constant-preservation as a separately validated bounded numerical correction, not authorization to deploy/default anything. No additional offsets, sample counts or weights are tried.

Preflight final40-process CPU sum0.133239s (includes explicit hash-before-clock, excludes printf/startup); measured wall0.197560355s includes subprocess and loop/pin work after initial setup pins. Static scratch130336B plus mainstack560 and decoder co_read224B/othercallee are separate from renderer runtime. These host figures are not device timing or full production writer costs.

## Independent closure and isolated host cost

Independent fresh O2 A2 20 + B2 20 frames match all buffers, target/sample JSONL, AA reports, non-timing metadata and counters. Independent sample/metric checks cover 95520 target encodes, 1200480 unchanged non-target pixels and 300870 hit reconstructions; strict positive controls and 133 mutations per arm plus six extra negatives pass. Full metric comparison independently confirms the 188 regressing scalar metrics. No remaining functional or quality audit blocker.

CPU schedule: three interleaved repetitions of A2/B2 × baseline front/oblique, 12 serial frames, identical compiler flags and fixed inputs. All 36 RGB/depth/snapshot buffers and all input pins match. Both arms include unbuffered sample-observer JSON I/O. This is a three-sample host comparison, not pure shader cost, device speed or a measurement of the numerical repair against old v32. Timing dispersion and sequential host noise prohibit interpreting small differences as guaranteed speedup. No further trial is planned.

- A-front: render min/median/max 13.095486/14.739288/14.791927 s; evaluate 10.430327/11.376391/12.163416 ms; wall 13.114589/14.761596/14.811983 s.
- A-oblique: render min/median/max 12.551497/13.893813/14.171790 s; evaluate 8.977475/13.945032/14.370855 ms; wall 12.567799/13.918187/14.194981 s.
- B-front: render min/median/max 12.986519/13.756670/14.509455 s; evaluate 9.645090/9.895593/11.256931 ms; wall 13.003563/13.774346/14.530000 s.
- B-oblique: render min/median/max 12.390200/13.331148/13.945645 s; evaluate 9.327044/11.406376/12.491833 ms; wall 12.409518/13.352918/13.971586 s.

All raw timings are retained in cost-001/RESULT.json. Known heavy workers were stopped by parent confirmation before timing. One-second /proc/stat busy observations before/after were 0.3333%/0.1111%, load averages 0.20/0.77/1.28 and 0.13/0.59/1.08; three processes were visible in this namespace. These observations cannot prove absence of all external host contention.

Independent CPU review passes: 12 raw rows, 72 aggregate statistics, 36 buffer hashes, 972 non-timing metadata values and 376 input pins. Ratios of render medians B/A are 0.933333/0.959502, while median within-repeat ratios are 0.980904/0.984043. Fixed A-before-B ordering, only three repetitions and observer I/O mean no speed advantage is established. The after-context file records calculated busyFraction but omits raw jiffies, so its percentage cannot be independently recomputed; the before observation can and did reproduce. This limitation does not affect frame timings, bytes or input pins.
