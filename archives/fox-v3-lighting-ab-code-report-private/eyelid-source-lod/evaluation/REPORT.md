# Fixed source eyelid 8/9 actual-C evaluation

Private diagnostic, no formal adoption or global 60% claim. Baseline is frozen eyeB with normal-pair codec ON. Original source/reference, lighting, material, production renderer, transport, precision, caps and v3 scoring thresholds unchanged. Only the two Upper eyelid meshes differ; separate source-geometry audit establishes correspondence. The inherited muzzle complete-occlusion-preservation guarantee remains failed and separate from these image results.

## Capacity contract and admission

Five scenarios compile independently with identical counts. Selector 1 means codec opt-in; serialized record wire mode is 5, not 1. Product storage remains 65,536 bytes.

- lid8: 1,163 compiled vertices, 1,564 triangles, 54 records, cold 47,708 B, arena 81,356 B. Canonical old-format diagnostic length 71,168 B; actual 64,208 B, saving 6,960 B, headroom 1,328 B.
- lid9: 1,175 compiled vertices, 1,588 triangles, 55 records, cold 48,284 B, arena 82,708 B. Canonical 71,920 B; actual 64,892 B, saving 7,028 B, headroom 644 B.

Each candidate passed all 20 actual appends (five conditions, two cameras, forward/reverse) before image rendering. Every record is eligible mode5 for these tested inputs; no mode4 fallback occurs. Earlier lid9 fallback-overflow forecasts did not occur in these actual groupings. This is not an all-pose capacity guarantee: worst whole-format fallback is 71,168/71,920 B and exceeds the existing cap. Future asymmetric records must retain mode4 and may fail admission.

Canonical bytes are diagnostic file/Python data, never a widened production snapshot. A second independent host harness invokes the unchanged old API separately per record with only 4,096 bytes scratch, streams its output to a file, and confirms full byte equality with decoding the mode5 snapshot across all 40 snapshots, including scene prefix, side bits, ordering and padding. Product code is unchanged. `capacity-lid*.json`, `canonical-proof-lid*.json` provide summaries; raw geometry/snapshots remain private.

Fresh certificates bind exact source GLB, compile counts, code, canonical counts, actual compact length and each of 20 wire/canonical hashes. Canonical >65,536 is permitted only under this externally pinned opt-in contract whose actual wire length fits; it does not relax any runtime quota. Scorer score() AST remains identical. Tests: dedicated lid contract 6/6 and existing scorer 58/58. Old copied eyeB tests are historical, not claimed as lid coverage.

## Actual runs and formal v3 metrics

`actual-lid8-v2` / `actual-lid9-v2`: all 10 conditions forward/reverse complete; manifests only after full completion. Initial `actual-lid8`/`actual-lid9` attempts stopped before compilation/render because the default relative reference path was not supplied. They remain incomplete/unscored. v2 supplies the explicit unchanged reference path without code/certificate changes.

Compared with eyeB ON:
- Stable RGB agreement improves all 10: lid8 +0.025861 to +0.112671 percentage points; lid9 +0.031196 to +0.111480.
- Fixed oblique face crop (x108:168, y12:76) descriptive RGB MAE improves all five for both. lid8 improves more than lid9 on all five. Baseline delta -0.000666905 / -0.000572677.
- Response magnitude agreement regresses 4/8 for each (worst -0.446188 / -0.448048 pp). Direction agreement regresses 1/8 each. Signed correlation regresses 6/8 for lid8 and 7/8 for lid9. Delta RGB RMSE regresses 7/8 each. Full per-condition metrics are retained, with no new acceptance threshold or fitted mask.
- Front silhouette unchanged. Oblique missing pixels reduce by one, extras unchanged. Source foreground/boundary and every color/response stable/uncertain mask remain byte-identical; only candidate foreground and missing mask change by one pixel.
- No dedicated eye mask exists; unchanged unrelated geometry does not rule out eye/occlusion regressions. Face visuals and strict geometry diagnostics are reported separately.

Max actual counters: lid8 work2,750,272; direct rays246,781/nodes15,005,922/tri4,781,938; transport rays3,340,780/nodes228,528,365/tri81,476,856. lid9 work2,746,744; direct246,759/15,213,622/5,199,769; transport3,341,516/230,835,409/87,830,236. All unchanged limits pass (work8M, direct1M/100M/50M, transport20M/800M/300M). BVH/transport scene storage and geometry are also checked per frame. Parallel functional timings are not performance comparisons.

## Additional diagnostic views

Density uses the existing exact doubled projection (cx83.5, cy112.5), crop60:180/2:130 and nearest3x. eyeB ON/lid8/lid9 are compared at identical camera. Seen2 uses the previously seen directions az247.5/elev12.5 and az292.5/elev27.5 with unchanged target[-.28,.25,1.8], distance8, verticalOrtho4.8 and native mapping. These views are not new holdouts and not reference-scored or fitted. Each retains original quotas and records camera echo/input hashes; additional snapshot accounting is separate from the formal 20-input contract.

Independent reviewer rebuilt all 40 formal frames and all nine diagnostics: 98 image buffers, 49 snapshots and 3,969 metadata fields matched exactly. Independent heavy work ended 08:58:26 UTC before controlled CPU execution.

## Controlled host CPU

Eighteen sequential renders: eyeB codec ON / lid8 / lid9 × baseline front/oblique × three alternating repetitions. Same O2 flags and binaries, all 36 RGB/depth buffers match each candidate's functional output, all snapshot evidence matches, and all 15 input pins remain unchanged. Native evaluation/append/render minimum, median and maximum nanoseconds are below. Raw samples and execution order are retained in cpu-001/progress.json and COMPLETED.json.



eyeB
- front: evaluateNs 8842966/9450755/10185394, appendNs 3929019/4340120/4698443, renderNs 8377643532/8452016931/8932424104 ns (min/median/max).
- oblique: evaluateNs 8290941/8728574/10005620, appendNs 4117283/4207403/4441704, renderNs 8184042646/8398921949/8833439192 ns (min/median/max).

lid8
- front: evaluateNs 10146798/10760034/11020478, appendNs 4884693/5205148/5423759, renderNs 8475168856/8492247588/8751936481 ns (min/median/max).
- oblique: evaluateNs 9774610/10632022/13265942, appendNs 4627316/6342897/8211632, renderNs 8441338346/8555575215/8838846888 ns (min/median/max).

lid9
- front: evaluateNs 9065994/9343163/10115940, appendNs 4874277/5577891/5624932, renderNs 8556309972/9092834196/9579789437 ns (min/median/max).
- oblique: evaluateNs 9601538/10164204/10951054, appendNs 4706444/4767288/4874338, renderNs 8192769840/8247219535/8368666569 ns (min/median/max).

Median render ratios vs eyeB ON: {"lid8": {"front": 1.0047598883590074, "oblique": 1.0186515920675572}, "lid9": {"front": 1.075818265655578, "oblique": 0.9819378707266041}}. Three samples on this host are descriptive only; ranges may overlap and do not establish speed guarantees or real-device speed. Native private dump IO is outside these timers. Append timing includes adapter scan/binding, not isolated product writer incremental cost.

All additional density/seen2 snapshots fit the same actual sizes and remain mode5-only; their cameras are independently pinned and no reference scores are claimed. CPU and diagnostics do not establish all-pose capacity.
