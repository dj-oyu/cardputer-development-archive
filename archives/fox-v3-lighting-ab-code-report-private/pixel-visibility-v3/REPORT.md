# Bounded host BVH direct visibility, fixed v3

Decision: retain as private causal experiment, not default/product adoption. Original rich reference and thresholds unchanged. Goal remains unmet.

## Full-condition result
Direction bright IoU improves front60.05→63.25%, oblique33.83→39.22%. All ten stable-foreground RGB scores regress. Direction response magnitude regresses, ambient magnitude drops below60% both views. Other metrics have mixed changes; no aggregate score hides them. Uncertain classifications and stable inactive false positives remain unchanged in scope and reported separately. Shape/depth remain identical.

|view/case|RGB OFF/ON|bright IoU OFF/ON|dark IoU OFF/ON|magnitude OFF/ON|sign OFF/ON|
|---|---|---|---|---|---|
|front-baseline|74.2665/73.7381|N/A|N/A|N/A|N/A|
|front-direction|74.3797/73.3744|60.0512/63.2530|71.9525/77.6808|93.6245/76.5043|76.0301/79.3315|
|front-intensity|75.3155/74.8803|N/A|71.9433/72.7294|87.6518/99.0023|79.4514/77.0144|
|front-ambient|73.9041/73.5929|74.5169/78.6111|N/A|67.0962/57.9098|83.2983/85.7662|
|front-albedo|77.5466/77.2760|N/A|87.1254/87.3327|80.5726/83.7984|87.7663/87.9925|
|oblique-baseline|73.4121/72.6074|N/A|N/A|N/A|N/A|
|oblique-direction|73.5369/72.5273|33.8337/39.2231|73.9518/77.0934|98.5976/85.9873|74.5822/76.6646|
|oblique-intensity|74.3752/73.8107|N/A|74.1701/74.5972|82.9228/92.1540|80.2396/78.4676|
|oblique-ambient|73.3813/72.8713|76.0768/79.7959|N/A|63.1387/54.1554|83.8955/86.0232|
|oblique-albedo|76.6556/76.2940|N/A|86.9565/87.0759|73.9288/76.3465|87.3828/87.4510|

Full metrics (including deltaRGB/deltaLuma RMSE/correlation, uncertainty and FP/FN) are preserved in both score-*-004/evaluation.json and summary.json. Candidate never determines reference stability masks.

## Causal and ownership contract
Same existing pixel16 DISK lighting; shadow only affects positive direct-light sample kernels. World remains uniform/unoccluded. No ground occluder, ground emission, GI, PBR, AgX or image-derived illumination. All1166 original character faces/849 vertices collected from actual evaluated model before camera culling; full world-field parity with pixel mesh asserted. Full source geometry is owned, opaque two-sided, including edge-on/offscreen faces. Sample coordinates/weights and color semantics unchanged.
Ray starts at exact surface P and ends at source sample; traversal excludes1e-5 Blenderworld distance at each endpoint exactly once along the ray. No shading-normal offset or self-face exclusion. Preliminary001 had normal-offset contamination and is superseded. Corrected002 and final004 produce identical40 buffers.003/004 alias hardening does not alter successful images.
Scene is independently allocated immutable BVH, retained by binding. Source arrays/model/cold/arena are poisoned/disposed before rendering. Generation tokens geometry/pose/light must be monotonic on replacement; mismatches reject, old snapshots retain old scenes. Actual adapter collects scene and snapshot synchronously from one evaluate and binds snapshot byte fingerprint including light header. Tokens are caller-issued, FNV64 fingerprints detect accidental changes only; not cryptographic authentication or a general self-proving pose registry. Runtime snapshot mutation rejects. This is a host integration, not Pocket/JS/failed-present firmware implementation.

## Bounded costs
Snapshot52212/65536B remains unchanged,45records, workmax2766638/8M. Work×49 remains raster+48sample allowance; additional tracing has separately enforced frame-wide limits:1M rays,100M node visits,50M triangle tests. Failure rejects completion, keeps snapshot/scene immutable and requires caller to discard partial band. Counters include consumed work and cannot reset per band.
Scene326496B=80Bcontrol+1166×152Btriangles+2331×64Breserved nodes;795 nodes used.512KiB cap per scene,2048 nominaltrianglecap may fail bytecap (tested). Two actual generations652992B, versus maximum caller allowance1MiB. Module permits reference retention, not a global two-generation quota manager. This harness runs one generation; two-generation lifecycle is synthetic-tested. Additional input geometry temporary34368B (849×24+1166×12), binding48B, cumulative budget48B. Allocator bookkeeping excluded.
One render resident subtotal403712B =scene326496+snapshot capacity65536+snapshot control64+binding48+budget48+color3840+depth7680, excluding model/evaluator stack and allocator overhead. Build overlaps source cold35636+arena65892+instance584+inputtemp34368 with those allocations:540192B accounting envelope. Two simultaneously retained snapshots add2×65536 plus scene generations and individual control/scratch; no MCU RAM-fit claim. Instance584/cold35636/arena65892 are otherwise unchanged.
Intermediate depth winners are shaded, so ray count/order costs differ although final pixels match. Counts below cover all forward/reverse cases.
- visibilityRays: 210740 .. 258311
- visibilityNodeVisits: 9841252 .. 11514509
- visibilityTriangleTests: 3703931 .. 4258457
- shadeUpdates: 9289 .. 9899
- diskSamples: 445872 .. 475152

## Host CPU
11 alternating unsanitized O2 repetitions per condition/order, serial with other heavy work paused. Build time is also included in append time, so do not add it twice. Old vertex-light evaluation remains redundant prior to raw collection. Full timing samples/min/max are retained. F64 target FPU performance is unmeasured; no S3 speed claim.

|case/order|eval ms OFF/ON|append ms OFF/ON|raster ms OFF/ON|BVH build ms ON|
|---|---|---|---|---|
|front-baseline/forward|6.910/6.859|0.200/2.500|22.072/320.910|2.257|
|front-baseline/reverse|6.860/6.665|0.202/2.378|22.208/299.382|2.133|
|front-direction/forward|7.030/6.956|0.194/2.561|22.684/322.412|2.205|
|front-direction/reverse|6.770/6.886|0.201/2.523|22.463/319.841|2.285|
|front-intensity/forward|6.843/6.733|0.199/2.344|22.378/310.265|2.111|
|front-intensity/reverse|6.920/6.860|0.205/2.548|22.616/307.184|2.304|
|front-ambient/forward|7.006/6.870|0.190/2.489|22.797/314.261|2.252|
|front-ambient/reverse|7.051/6.608|0.213/2.442|22.432/306.764|2.200|
|front-albedo/forward|7.119/6.895|0.198/2.409|23.591/315.887|2.179|
|front-albedo/reverse|6.843/7.060|0.208/2.531|22.363/309.778|2.291|
|oblique-baseline/forward|6.902/6.960|0.204/2.434|24.024/317.107|2.193|
|oblique-baseline/reverse|7.077/7.219|0.203/2.506|24.181/325.766|2.199|
|oblique-direction/forward|7.243/6.969|0.199/2.590|23.900/279.982|2.309|
|oblique-direction/reverse|6.932/6.881|0.217/2.399|23.915/296.619|2.154|
|oblique-intensity/forward|6.930/6.813|0.192/2.486|23.084/306.941|2.208|
|oblique-intensity/reverse|7.258/6.808|0.206/2.458|23.260/321.009|2.195|
|oblique-ambient/forward|7.352/7.452|0.199/2.648|25.029/328.315|2.380|
|oblique-ambient/reverse|7.223/6.977|0.240/2.409|25.618/327.136|2.158|
|oblique-albedo/forward|7.425/6.988|0.210/2.381|24.017/329.551|2.134|
|oblique-albedo/reverse|7.083/7.130|0.215/2.633|23.954/334.431|2.341|

## Verification
OFF40buffers match previous pixel002; allON20depth buffers unchanged; forward/reverse RGB/depth exact all ten cases. Synthetic model whole-face helper includes edge-on/back/offscreen cases. O0/O2 ASan/UBSan codec/model/BVH/binding/callback tests pass, ownership/source poison/old generations/capacity failure/allocation failure/budget exhaustion/alias mutation cases included. Independent long-double brute-force oracle:64 transformed triangles,1000 nonborderline segments,584blocked/416clear,zero mismatches.45 scorer mutation/regression tests pass. LeakSanitizer unavailable under ptrace; explicit allocation balance ends zero in tested module paths.
Independent final evidence is stored separately when complete; do not infer full production lifecycle from host tests. See REPRODUCE.md.

No default/public/PR/device action. The visibility result isolates direct occlusion only; missing original energy transport/display/material remains, so increasing shadow fidelity need not improve total RGB. No next implementation selected automatically.

### Additional stack audit
O2 no-LTO static compiler frames: bound-render272B + callback64B + segment traversal432B, in addition to existing pixel render/strip/lighting frames. Scene build208B plus recursive median build256B per level (bounded geometry count), not a whole-program peak proof. Host main83776B still places test payload/bands on stack; this is not product stack layout. Dynamic heap figures above do not silently absorb these frames.

Manifest wording note: the inherited pixel mapping sentence says “no AgX/visibility” for the base path, then ON appends the bounded-BVH clause. For ON the latter is the active visibility capability; AgX remains OFF. The explicit visibilityEnabled flag, unsupported list and this report define the arm. Do not interpret the inherited base sentence as absence of ON visibility.
Final summary provenance: summarize.py now reads score-off-004 and score-on-004, not intermediate002. Metrics are unchanged because final buffer contents are identical; frozen004 files remain untouched.
Independent final004 replay: O2ASan/UBSan40renders/80buffers and440 runtime accounting fields exact. O0/O2 core tests pass ownership/allocation failures/alias/old-generation lifetime/frame-cumulative exhaustion and all9 uncull geometry fixtures. Separate callback endpoint probe confirms0.5epsilon excluded/1.5epsilon blocked and no shading-normal dependency. No unresolved core defect found. CPU median raster ratio11.71–14.54×, build medians2.11–2.38ms; whole timing run80.59s.

Final independent2700 metric values match. All8 response RGB RMSE values regress; ambient magnitude falls to57.91/54.16%, below60. Independent review complete with no unresolved core defect; private preservation permitted, not adoption.
