# Same-render contribution analysis with retained residual

Among the3predeclared comparisons, changing AgX to the native clamp-to1/float-sRGB profile causes the largest direction-bright position loss in this richoracle. ObliqueIoU drops71.90/73.24→51.43/51.32%forseeds11/29. Removing directspecular alone gives70.44/70.87%; removing indirectdiffuse gives70.69/72.17%. This identifies profile as the strongest of these tested factors for this response, not a proven native improvement or the sole cause of all rendering error.

## Fixed results on existing v3 domains

|View/seed|AgXcontrol brightIoU%|nativeprofile brightIoU%|minus directspec brightIoU%|minus indirectdiff brightIoU%|
|---|---:|---:|---:|---:|
|Front11|84.06|73.19|81.92|83.43|
|Front29|84.33|73.45|82.84|83.27|
|Oblique11|71.90|51.43|70.44|70.69|
|Oblique29|73.24|51.32|70.87|72.17|

Exactvalues/FP/FN/darkIoU/allseed/color/uncertain results are in summary.json and evaluation.json. Originaloracle and common redisplayedcontrol are identical in all8cases. Existing729front/698oblique uncertain pixels remain descriptive-only;2seeds do not establish new stability. Formalv3scoring/masks/thresholds remain unchanged. No overall60%acceptance or rendererdefault change.

Indirectdiffuse still matters for color: directionforeground agreement drops fromabout94.64front/94.83oblique to88.84/89.16%without it. Directspecular removal gives92.53/93.22%, and nativeprofileabout90.30/90.39%. Some darkIoUs improve when specular is removed, so featureeffects are metric-dependent. This is not evidence to remove specular from the product.

## Exact controls and failed gates retained

Every enabled-pass render CombinedPNG matches its previous richoracleRGBA8 image exactly. The initial generated-image.save_render redisplay differed at21890pixels/max2bytes for the firstcase. That path was not used for finalcomparisons. An Image→Composite-only postprocessing graph (no RenderLayers node, no lightingrerender) produces exact oldCombinedPNG in all8cases. All3arms and redisplayedcontrol use this commonPNG8/dither1 stage. Nativeprofile uses the actualC ayatsuri_srgb_encode after clamp-to1, then Rawview to avoid a second transform; no extraRGB565quantization. Originalscene shading keeps compositorOFF, standalonepostprocessing uses compositorON and is reset by reloading source for eachcase.

The original HDRsum errorgate FAILED for all8cases and remainsFAIL. Color-weighted lightpass sum differs from Combined by max2.8298e-5–3.8003e-5;217channels across8images exceed the predeclared2e-5+5e-6*abs(Combined) bound. No bound was increased to claim success. The firstcase has62violatingpixels, only1inside formalforeground. Float accumulation/Color-division is a plausible source but not proven as the complete cause.

With explicit parent authorization, the limited diagnostic retains unexplained R=Combined−sum. Each removal arm uses Combined−component, preserving R rather than replacing Combined by the imperfect sum. R is saved separately. This is a contribution analysis, NOT exactrecomposition or a physical rerender without thatcomponent. No negativecomponents occurred in Combined or eitherremovalarm, so no flooring/clipping was used to hide residuals. Denoising remainsOFF; original directclamp0/indirectclamp10 remain. Passes alreadycontain clamped contributions and cannot reconstruct unclampedradiance. Combinedalpha is exactly1 in allcases; no premultiplication ambiguity arises.

## Source definitions and numerical provenance

Official Blender v4.3.2 sources:
- https://github.com/blender/blender/blob/v4.3.2/intern/cycles/scene/pass.cpp
- https://github.com/blender/blender/blob/v4.3.2/intern/cycles/kernel/film/read.h
- https://github.com/blender/blender/blob/v4.3.2/intern/cycles/kernel/film/light_passes.h

Direct/indirectDiffuse, Glossy, Transmission need their respectiveColor multiplication. Reconstruction includesVolumeDir/Ind, Emission andEnvironment. Originalgeometry has no shadowcatchers;3LIGHT flags initially triggered an overly broad guard, corrected without changing scene flags. The failedbefore-render attempt is retained. NoAO/shadowcatcherpass specialcase or originalcompositor was enabled. All scene light/material/normal contracts come from the frozen richoracle setup.

Restricted EXR32/NONE reader follows officialOpenEXR single-part scanline layout; finitefloat32/unit sampling only, with16MiB allocation limit. Synthetic Blenderread/write and independentFFmpeg decode agree, malformed inputs rejected. Cencoder is freshlybuilt against actualfour-both shaderheader with command/source/header/binary hashes recorded. Final12code/build pins and74input pins remain unchanged.

Post-hoc descriptive check at the fixednativeclamp threshold1: baselineany-channel saturation affects3285–3288/5307front and3489–3494/5868oblique foregroundpixels.90–91stablebrightoblique locations have all3channels≥1 in BOTHcases and therefore lose their response under clamp+sRGB. This supports a concrete mechanism but is not an additional tuned test or a complete explanation of theIoU gap.

## Scope, cost and reproduction

8same-render captures took25.852s total; wholefinalrun46.392s includingpostprocessing/IO/controls. OSpeakRSS/CPU were not measured by this script. Eachcomparison is on the richoracle's alreadycomputed radiance, not on nativeLambert output; its improvement magnitude cannot be transferred directly to the currentnative renderer. Richmaterial/transport/filter andPNG8 encoding remain different from native. Two baseline/direction views only, not all5conditions.

From workspace root with matching private inputs and freshoutputattempt:

blender -b -t8 --python fox-v3-position-diagnostic/pass-decomposition/run.py -- /absolute/workspace/fox-v3-position-diagnostic && python3 fox-v3-position-diagnostic/pass-decomposition/summarize.py

Oldfailedattempts are retained locally. Persistent bundle contains code/tests/hashes/numericalreports only, excluding images/EXR/geometry/rawbuffers. Original .blend and formalreference remain untouched.

Independent final verification PASS:3756numerical values match, all8original/redisplay controls exact, oldHDRgate8FAIL/217violating channels retained, residualR preserved. FreshCencode rebuild plus8EXR independent reread/recomposition/postprocessing reproduces all32control/armPNG RGBA images exactly. This independent replay does not redo thelighting render. All12code/build and74inputpins remain unchanged. EXR synthetic/26malformed-input checks and allocation guard independently verified.
