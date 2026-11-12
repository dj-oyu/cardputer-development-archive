# Center HDR reuse proof

This private audit supports reusing the existing current-lid8 forward center HDR
capture for matching non-target KEEP pixels of the frozen camera-background scene.
It does not authorize changes to geometry, lighting, filtering, references,
exposure, model inputs, quarter samples, or floor/world replacements.

Run from any directory:

```sh
python -B /workspace/scratch/6d8dcdbcdc54/fox-v3-camera-display-comparison/center-proof/audit_center_reuse.py
```

The script reads existing files and prints deterministic aggregate JSON to stdout.
It does not write files, invoke a compiler, render a scene, or generate a profile.
The only native computation is ten calls to the pinned, already-existing buffer
encoder with its profile disabled. The authorized `proof.json` records one run.
To verify it without creating files:

```sh
python -B /workspace/scratch/6d8dcdbcdc54/fox-v3-camera-display-comparison/center-proof/audit_center_reuse.py | cmp - /workspace/scratch/6d8dcdbcdc54/fox-v3-camera-display-comparison/center-proof/proof.json
```

Checks include capture hashes and frozen input manifests; exact center arithmetic
after two count-checked, verbatim instrumentation removals; source line anchors;
identical physical shader, model, lighting, ground, snapshots, depth and metadata;
and independent disabled-profile RGB565 controls for all ten forward frames.
The JSON records hashes and aggregate outcomes, not raw HDR, geometry or images.

**Qualification:** no independently recorded current center-f64 buffer exists.
This is source/input-derived equivalence, not a direct comparison of newly captured
current HDR against prior HDR. RGB565 agreement alone would be insufficient.
The fixed size-65 profile remains private-only; its provenance does not clear
publication of the bundled color-management assets.
