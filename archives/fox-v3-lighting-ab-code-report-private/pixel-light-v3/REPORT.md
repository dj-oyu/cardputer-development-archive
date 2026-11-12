# Fixed v3 pixel-rate direct lighting experiment

Decision: retain private experiment; do not adopt as default. Goal remains unmet. Actual owned host C rendering, not Pocket/JS/frame/present integration or device execution. Original rich reference, all ten cases and thresholds unchanged. Visibility and AgX are OFF.

## Results
All ten stable-foreground RGB scores regress. Direction bright-region IoU improves, but oblique remains below 60%; all eight response RMSE and sign metrics worsen. Uncertain pixels and inactive false positives remain in evaluation.json, never converted to PASS. Shape/depth unchanged.

|case|RGB OFF|RGB ON|bright IoU OFF/ON|
|---|---:|---:|---|
|front-baseline|75.3097|74.2665|N/A / N/A|
|front-direction|75.7935|74.3797|55.0778816199377 / 60.05121638924456|
|front-intensity|76.4130|75.3155|None / None|
|front-ambient|74.6205|73.9041|81.84427013583317 / 74.51693131815573|
|front-albedo|78.4717|77.5466|None / None|
|oblique-baseline|74.6338|73.4121|N/A / N/A|
|oblique-direction|75.1154|73.5369|29.72972972972973 / 33.8337182448037|
|oblique-intensity|75.6318|74.3752|None / None|
|oblique-ambient|74.1576|73.3813|82.7026092966995 / 76.0768033212247|
|oblique-albedo|77.6917|76.6556|None / None|

Complete parameter-wise results including uncertainties, sign, response magnitude, stable inactive false positives and regressions are in summary.json and both score directories/evaluation.json. No weighted overall score rescues failures.

## Ownership and numerical contract
Mode4 wire: 12-byte header; each vertex56B contains XY/mask/depth F32, raw A/B RGB565, world F64x3, front/back SNORM16x3; indices/sidebits keep face order. Scene is a pointer-free 416B LE prefix (8B magic/version/reserved plus51 doubles). Source model/arena/cold data are poisoned and disposed before rendering. Physical sidebits select front/back normals, not color-palette collapse. Mask chooses raw A/B before sRGB decode; linear rho and world/normal interpolate per pixel, normal normalized without requantization. Same DISK16 integral plus unoccluded colored world, then clamp/sRGB/565 once. No visibility, GI, specular or AgX. Invalid/zero normals or lighting failure reject; caller discards unpublished partial band. Snapshot remains immutable; this is not an implemented failed-present firmware guarantee.
Helper mutation epoch is not evaluation generation: caller must copy synchronously before any next evaluate or mutation. Alias guards cover storage/control/output/scratch/stats. New API is fixed B/38 fox-coordinate host experiment, not a general asset-unit API.

## Capacity and costs
Admission all ten cases: 52212B =416 scene+51796 records, within65536 unchanged;45 records. Work front2766638/oblique2655947 within8M, charged bounding work times49 (coverage plus48 light samples). Cold35636B, arena65892B, instance584B unchanged. Snapshot control64B vs48B (+16). Depth scratch7680B and color band3840B unchanged. Allocation subtotal179232B including fixed65536 capacity but excluding stack; not a guest RAM-fit claim. Caller raw fields2080B. All forward/reverse final RGB/depth match, despite different intermediate winners: front9404/9289, oblique9664/9899. Each update evaluates48 samples.
Compiler O2 no-LTO stack evidence in stack-audit/*.su: helper2384B includes temporary2080B, in addition to caller raw2080B; begin896B; append528B; render560B plus strip896B plus eval wrappers32+352B gives1840B subtotal excluding external math/other calls. This is not a proven whole-program maximum. Existing OFF render now96+shared strip896 versus old512B, so OFF stack also changes. Host main83568B includes payload/bands on stack: test arrangement, not MCU deployment. Scene-header temporary/copies are included in frame measurements, not added again as heap.

Timing: same unsanitized O2 host,11 alternating repeats per case and order; full samples/medians/min/max in timing-002/results.json. F64 target-FPU cost unmeasured; no S3 speed claim. Redundant old vertex-light evaluation still precedes raw-field copy.

|case/order|eval ms OFF/ON|append ms OFF/ON|raster ms OFF/ON|
|---|---|---|---|
|front-baseline/forward|7.259/6.958|0.090/0.195|2.557/22.945|
|front-baseline/reverse|6.982/6.824|0.096/0.194|2.456/23.085|
|front-direction/forward|6.730/6.781|0.089/0.190|2.494/21.956|
|front-direction/reverse|6.858/6.803|0.102/0.193|2.471/22.347|
|front-intensity/forward|7.321/7.436|0.098/0.198|2.720/24.242|
|front-intensity/reverse|7.184/7.163|0.100/0.202|2.486/22.309|
|front-ambient/forward|7.395/7.355|0.099/0.202|2.696/24.224|
|front-ambient/reverse|7.003/7.147|0.100/0.203|2.562/22.664|
|front-albedo/forward|6.963/7.060|0.093/0.192|2.542/23.648|
|front-albedo/reverse|7.494/7.090|0.109/0.205|2.695/24.444|
|oblique-baseline/forward|7.271/7.069|0.097/0.192|2.641/23.877|
|oblique-baseline/reverse|7.355/7.370|0.113/0.211|2.650/26.966|
|oblique-direction/forward|7.462/7.350|0.106/0.209|2.643/25.445|
|oblique-direction/reverse|7.540/7.049|0.131/0.218|2.784/24.048|
|oblique-intensity/forward|7.320/7.505|0.102/0.197|2.631/24.219|
|oblique-intensity/reverse|7.707/8.226|0.114/0.229|2.791/28.123|
|oblique-ambient/forward|8.808/8.490|0.112/0.226|3.033/27.592|
|oblique-ambient/reverse|8.096/7.043|0.108/0.210|2.677/25.610|
|oblique-albedo/forward|7.839/6.854|0.104/0.190|2.697/25.463|
|oblique-albedo/reverse|7.401/7.113|0.111/0.234|2.701/24.649|

## Reproduction and verification
bash test_all.sh /absolute/fresh-test-directory runs codec, model/renderer O0/O2 ASan/UBSan and36 scoring tests. Leak detection disabled because of container constraints; no leak-clean claim. code/run.py produces fresh source snapshots and actual renderer outputs; see its CLI and off/on candidate manifests for fixed configs. Private model/reference inputs are required separately and intentionally not bundled.
OFF40 buffers match prior four-both-002; ON20 depth buffers and all reverse results match. All four previously diagnosed pixel-shade buffers now match actual bounded implementation. Independent final O2 ASan40 renders/80 buffers exact,2700 metrics/20 masks independently recalculated,36 scorer tests and alias/ownership codec/model tests PASS. See independent-review files.

## Remaining scope
No default adoption, public publication, device work or original simplification. Native excludes original area visibility, ground emission, GI, PBR and display profile. Improvements in one conditional metric are not full60% reproduction.
