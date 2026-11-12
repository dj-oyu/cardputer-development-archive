# Blender ↔ actual native C host evaluation (local, not published)

## Reproduce private baseline

```
python3 fox-render-test/v2/code/run.py --config fox-render-test/v2/private-config.json --out fox-render-test/v2/NEW_OUTPUT_DIRECTORY
```

Requires installed Blender 4.3.2, C11 compiler, Node, Python + NumPy/Pillow. No installs/network/device. Output directory must not exist. Baseline completes with exit **2** because the preserved two-sided original does not fully reproduce in the one-sided native path. Exit 3 means functional gates passed but art quality is still unaccepted. Exit 0 is not an aesthetic acceptance mode. Interrupted/invalid runs do not reuse another output report.

`run-005` is the reviewed candidate execution, not earlier exploratory runs. Product files are untouched Git blobs from `a426f7a356c2d84074c3d546a3bfc7e73faa21ee`. Importer/partitioner are separately pinned to `76796a5c5ae53505de7de4f79b8e205ea1dc9c19` (not present in product main). `input-hashes-start.json`, `provenance.json`, `output-hashes.json`, `blender-metadata.json` identify inputs and outputs. Runner checks input equality at completion and immutable source hash. Native framebuffer is produced by the production evaluator, owned compact append and raster, not Python or Blender.

## Interpretation

Primary rich reference retains original materials, lights, world, AgX, samples and pose, only same-camera 240×135 framing. Direct rich→native error includes all pixels (background/shadows included), with foreground separately labeled. Do not call an arbitrary MAE-derived number an overall aesthetic quality grade.

Loss decomposition: source→reduced diagnostic geometry/material loss; reduced→native renderer compatibility; source→native total diagnostic loss. Eye/tail fixed ROIs remain UNACCEPTED. A separate raw diffuse lighting sweep varies direction/intensity/ambient/albedo independently. This simpler shader is for bug diagnosis, never a replacement for the rich reference or evidence that unsupported expression is reproduced.

Fixed metrics/normalization are documented in report.json. No per-image exposure, min/max, alignment or tuned acceptance. Masks use original alpha and native unlit finite-depth coverage, fixed across lighting cases. Synthetic tests validate sensitivity to missing parts, wrong lighting, missing response, RGB swaps and same-color depth changes. Reference Blender depth oracle, rich-light parameter sweep, specular/backlighting and universal near-tie correctness are NOT implemented. Old auxiliary depth 12/36 failure remains unresolved.

Exact coplanar different colors intentionally first-wins: reversal is not universally invariant. This asset's 24 framebuffer comparisons are an observation, not such a universal claim.

## Privacy / integration

`code`, `importer`, product sources, provenance and synthetic fixtures are reusable code. `private-config.json`, source model, GLB/AYNM/IR, any output image or actual fox report/geometry must NEVER be published. No draft PR was created. No firmware, physical device, or Pocket JS lifecycle is tested here.

The asset adapter currently forces single-sided export because the pinned importer rejects glTF doubleSided. It records this loss; it is NOT a fidelity-preserving conversion. Diagnostic Cycles backface culling eliminates the 7/5 interior mismatches, while the unchanged original comparison remains failed. Product sidedness work must be coordinated separately, not hidden by altering this reference.

## Version 2 rich capacity sweep

Final v2/run-001 adds rich original baseline/direction/key-energy/world-strength/albedo cases in addition to the common diffuse diagnostics. Original rich baseline pixels are identical to v1/005. All original fill/rim lights, PBR materials and AgX remain present. Source material sidedness is restored before every rich render.

The private config declares richMapping.keyLightName/keyTarget and an explicit capacity projection: native single direction comes from area-key center, native RGB from key color × relative energy, scalar ambient from world strength, fixed diffuse .65. This is not physical-unit equivalence, and no coefficient fitting was performed. Full-frame and fixed-source-foreground response scores remain separate because background can dominate full-image amplitude.

20 synthetic/negative checks now include malformed depth artifact rejection. Empty, short, NaN, positive infinity and all-background depth inputs cannot pass the exact comparator. This does not add a Blender depth oracle.

The ZIP contains code and tiny synthetic source only. Product head is unchanged a426; v2 is a wider evaluation baseline, not a renderer improvement. Any future implementation comparison must rerun both heads under this same v2 config/metrics and preserve all regressions/costs.
