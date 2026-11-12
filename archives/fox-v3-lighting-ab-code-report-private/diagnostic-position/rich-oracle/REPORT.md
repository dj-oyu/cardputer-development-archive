# Rich scene capability oracle on actual1166geometry

With the candidate's1166triangles and decodedSNORM normals carried into the original richscene, direction brightIoU is84.06/84.33%front and71.90/73.24%oblique (fixedseeds11/29). This is evidence that the native46–49%oblique response is not solely a ceiling imposed by this geometry representation. It is not native implementation success, a formal60%achievement, or proof that geometry has no remaining error.

## What changed and what did not

Only visible original character objects were hidden in an in-memory scene copy and replaced with45candidate parts/1166actualworld triangles. Original8material datablocks, ground/world/lights/camera/AgX/filter were kept.2original-render controls passed before8oracle renders. Formalv3reference/masks/thresholds were not replaced;7code/plan and70input hashes remain unchanged.

Positions use[x,-z,-y]/38, normals[nx,-nz,-ny], and globalface reversal[0,2,1] fordet−1. Physicalfront/back was verified on every existingwinner in bothviews; backSNORM exactlynegates front. Blender customnormal storage differs by at most1.183303945e-4vector length and position storage by1.129351164e-7sourceunits, within predeclared1e-3/1e-6 bounds. Not byte-identical fields.21faces have opposing averageNs/Ng, and84corners across67faces have local opposition; none were selectively flipped/repaired. Cycles may correct shading normals differently.

All8character materialgraphs are PrincipledBSDF→Output without textures/attributes/UV dependencies. Fullmaterial socket/node/link/flags and ground/light/camera state were verified unchanged before/after replacement. This oracle retains original linearalbedo and richmaterial properties, whereas native usesdecodedRGB565; maximum nominal linearalbedo component difference is.014396. Oracle image encoding isPNG8 rather thanRGB565. Consequently this tests combined richmaterial/transport/display/filter capability, not a strict renderer-only difference. Background/floorGI and reflections are available in the richscene and remain unsupported in the native fixture.

## Fixed-seed results on existing v3 domains

|View|Seed|BrightIoU%|DarkIoU%|BrightFP|BrightFN|StableforegroundRGB baseline/direction%|
|---|---:|---:|---:|---:|---:|---:|
|Front|11|84.062|89.442|145|103|95.310/94.643|
|Front|29|84.329|88.924|146|98|95.303/94.641|
|Oblique|11|71.903|90.834|195|59|95.637/94.831|
|Oblique|29|73.236|91.292|184|55|95.625/94.838|

Existinguncertain729front/698oblique pixels are retained as descriptive-only results. No2seed stability estimate or newmask was made. Bothseeds are shown, no bestseed selection. Original8seedCI establishes reference-domain stability, not oracle stability. Seed11→29 foregroundRGB MAE is.00572–.00632; even these2renders differ measurably. Same-seed oracle-minus-original stable-domain deltaLumaRMSE is.03977–.04253, separately stored in paired-difference.json. The formal-reference mean comparison is not replaced by this paired diagnostic.

Full-frame descriptiveRGB agreement is98.87–99.04%, largely because original background/floor remain present in this richoracle. Do not use that to claim the native background was repaired or rescue native foreground requirements. Candidategeometry is visibly coarser, especially ears/face/tail edges. Missingnative material/light/GI/display/filter behavior collectively remains a supported explanation, but this experiment does not isolate which individualfeature should be added.

## Control correction and numerical contract

Attempt001 stopped before anyoracle image because rawPNG files included different Date/RenderTime/cycles timings. AllRGBApixels and allotherPNG chunks were independently exact. Preserve that attempt locally. The revisedcontrol excludes exactly5volatile tEXt keys, requires IHDR240×135/RGBA8 and allotherchunks byte-identical. This is metadata separation, not image tolerance relaxation. Bothview controls pass.

PNG8oracle responses use exactinteger2126ΔR+7152ΔG+722ΔB, threshold±20000/denominator2550000; equalityinactive. This is separate from the unchanged nativeRGB565 evaluator. Candidatecontinuousluma/sign/significant/IoU all use the integernumerator. Oraclemetrics have descriptive-only statuses. Independent512synthetic boundary/zeroluma/inactiveFP tests pass; no unspecifiedepsilon was added.

## Cost and reproduction

8oracle render operations total27.023s (3.04–3.69s each), excluding sourceopening/audit and2originalcontrols. CPUtime/OSpeakRSS were not measured by this script; Blender's internalmemory log is not a firmware budget. This remains a Blenderhostoracle, not productruntime.

With matching private inputs, from workspace root:

blender -b -t8 --python fox-v3-position-diagnostic/rich-oracle/render_oracle.py -- /absolute/workspace/fox-v3-position-diagnostic && python3 fox-v3-position-diagnostic/rich-oracle/summarize.py

Use a freshattempt rather than overwrite anyexistingimages. Original source is opened only and never saved. Persistent code/report bundle excludes .blend, images, candidategeometry and rawbuffers. manifest-report.json substitutes groundgeometry hashes/counts for rawcoordinates; full localmanifest remains available privately. Existing oldadvanced2400results are not reconstructed here.

Independent final verification PASS: all736scoringvalues and80materialgapvalues independently agree; all8image hashes, source/input/code pins, controls and reconstruction metadata/geometry contracts verified.512synthetic numericboundary tests pass. This is independent provenance/geometry/metric verification, not a claim of a second fresh8-image render. Exact±2candidate luma boundary cases occur at16–31pixels even in actualstable domains, confirming the integercontract matters.
