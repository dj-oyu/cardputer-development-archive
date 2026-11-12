# Candidate scorer against frozen reference v3

This directory contains a new read-only scoring wrapper. It does not render, change any v3 artifact, publish, upload, or infer a replacement for missing historical candidate data.

## Run

From the workspace root:

```sh
python -B fox-v3-lighting-ab/scoring/test_score_candidate.py
python -B fox-v3-lighting-ab/scoring/score_candidate.py \
  fox-v3-lighting-ab/linear-on-001/candidate-manifest.json \
  --reference fox-reference-uncertainty-v3 \
  --output fox-v3-lighting-ab/score-linear-on-001
```

The output directory **must not exist**, and its parent must exist. Never reuse or overwrite an earlier score directory. An invalid manifest/input exits with code 2 before output creation. A filesystem failure during writing can leave a partial output directory; only a valid `COMPLETED.json` with matching hashes establishes a completed scoring run. Choose a new output directory after investigating such a failure.

Dependencies: Python 3, NumPy, Pillow. No package installation is performed.

## Candidate manifest

The machine-readable structural schema is `manifest.schema.json`. Runtime validation additionally checks the full cross-record contract:

- `schemaVersion` is `fox-candidate-rgb565-v1`.
- `candidate` has nonempty `label`, `sourceLabel`, `head`, and a nonempty `sourceFiles` array of `{file, sha256}` records. Source/head labels are preserved exactly, not presented as proof that declared source produced the images.
- `reference.version` is `new-reference-uncertainty-v3`; `reference.configSHA256` is `4a9d836a4dae2fc570f5f0fb99690ab0f13fbe394589f785b56e891e0573dc40`.
- `resolution` is `[240,135]`, with width first.
- `rgb565Format` is `RGB565_U16_LE_ROW_MAJOR`.
- `depthFormat` is `FLOAT32_LE_ROW_MAJOR_NEG_INF_BACKGROUND`.
- `frames` contains exactly one row for each `front`/`oblique` × `baseline`/`direction`/`intensity`/`ambient`/`albedo` combination.
- Each frame has `view`, `case`, `rgb565:{file,sha256}`, `depth:{file,sha256}`, and `metadata`.
- Each frame's `metadata` contains `resolution`, `nativeCamera`, `scenario`, `sourceLabel`, `head`, `nativeInput`, and `actual`. The camera array and scenario object must match the corresponding frozen `input/config.json` entries exactly. Source/head labels must match the top-level declaration. Extra metadata is retained.
- `inputs/candidate-config.json` must be included in hashed `sourceFiles`. Its reference/source hashes, cameras, complete unique scenario grid, and reference-scenario fields are validated. Each frame's `nativeInput` must equal its configured native scenario exactly. The renderer echo `metadata.actual.camera` must match the frozen camera with absolute tolerance `1e-5`, and `metadata.actual.light` must match the configured concatenated `nativeDirection + intensity` with absolute tolerance `1e-6`; both use zero relative tolerance and require finite values with exact vector lengths. These are consistency checks on supplied records, not independent proof of execution.
- Every path is normalized, relative to the candidate manifest directory, and contained within it. Absolute paths, `..`, absent files, reused resolved paths, duplicate JSON keys, nonfinite JSON numbers, wrong file hashes, duplicate/unexpected frames, and incomplete grids are rejected.
- RGB565 filenames end in `.u16le` and contain exactly 64,800 bytes. Depth filenames end in `.f32le` and contain exactly 129,600 bytes.
- Depth NaN and positive infinity are rejected. Negative infinity is the only nonfinite background marker. At least one finite foreground pixel must exist per frame.

All raster records are row-major, top-to-bottom, left-to-right. RGB565 words use red bits 15–11, green 10–5, and blue 4–0. Direct float64 decoding is R5/31, G6/63, B5/31. The scorer never expands to uint8 or requantizes candidate colors through PNG.

## Frozen reference contract

`reference-pins.json` pins the existing v3 config, execution freeze, render manifest, artifact manifest, evaluator, pack evaluator, and saved evaluation. The entire pinned artifact manifest is checked, including all reference PNG/metadata/mask files. The original source blend is also hash-checked at its declared path. No rendering is invoked.

The wrapper reproduces the read-only checks in `code/evaluate_pack.py`. It deliberately does **not** import or execute that script, whose top-level CLI writes into the reference directory. It compiles the verified `code/evaluator.py` bytes into a module in memory; this produces no reference `__pycache__` writes. The original evaluator's PNG8 functions are used unchanged.

Each color/response stability array is compared exactly with the corresponding frozen `.npz` file. All 18 stored stability results must replay exactly. Every reference artifact and the original blend are checked again before writing output. The candidate files and manifest are likewise revalidated after calculation.

## Scoring domains and interpretation

- Color and response use **only the fixed source alpha8 > 0 foreground**. Candidate depth never trims that domain. Missing candidate geometry therefore remains visible in these errors.
- Stable response domains retain stable inactive source pixels, so native false-positive brightening/darkening remains in IoU unions.
- The exact reference PNG8 integer luma contract, 2/255 threshold, eight paired seeds, all-seed class consensus, and fixed Student-t mean confidence interval are unchanged.
- Reference color mean-precision masks measure precision, not similarity to a candidate.
- The frozen evaluator's stable-subset `valueStatus` is preserved. It is a conditional metric status, never a global PASS.
- Uncertain subset, full-source pooled, and each-seed full-source scores remain descriptive and cannot establish acceptance. Their complete coverage/counts/uncertain coordinates are retained.
- Empty unions/undefined metrics remain null with N/A semantics, never converted into 100%, PASS, or zero error.
- Shape compares source foreground against finite candidate depth over the **entire frame**, reporting IoU, extra/missing counts and coverage. Candidate extras outside source are retained. Shape masks are saved for exact localization. Shape is descriptive, with no newly invented acceptance gate.
- Overall `sixtyPercentGoal` remains `NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY`. Scoring completion is distinct from goal attainment. No aggregate acceptance rule is invented.

## Output

- `evaluation.json`: complete conditional metrics, per-seed/full-source/uncertain metrics, all source/head labels and candidate metadata, reference input hashes, scorer hashes, coverage, and uncertainty coordinates/frequencies/intervals.
- Ten `*-masks.npz` files: fixed source, candidate shape, extra/missing pixels, color stability/uncertainty, and response class/stability/uncertainty masks.
- `STARTED.json`: a writing-start marker.
- `COMPLETED.json`: final completion marker and SHA256/size records for the evaluation and all ten mask files. The start marker is retained as an audit fact and is not a failure indicator if completion verifies.

## Synthetic checks

Twenty-nine tests currently cover exact little-endian RGB565 decoding without PNG8 conversion; valid depth/background handling; NaN/+inf/all-background rejection; malformed hashes, missing/truncated files, duplicate/unexpected/missing frames, camera/scenario/head/format/resolution mismatch, missing or corrupted actual camera/light echoes, native input mismatch, hashed native-config absence or camera corruption, path traversal/reuse, duplicate JSON keys/nonfinite numbers, full-frame shape extras/missing/empty union, candidate-independent stability, retained stable-inactive false positives, fresh-output rejection, and exact replay against all frozen stability arrays.

Synthetic tests validate the scoring/input machinery, not rendering fidelity. Actual scored outputs must be interpreted with their specific candidate source/head labels and provenance limitations.

## Linear-light A/B metadata extension

Optional `linearLightEnabled` in the hashed `inputs/candidate-config.json` must be an actual JSON boolean. When declared, every frame must contain an exactly matching JSON boolean in `metadata.actual.linearLightEnabled`. Opposite modes, numeric 0/1, omitted echoes, and echoes without a configuration declaration are rejected. Legacy inputs may omit the field in both places. This extension changes validation only; all frozen reference classification, thresholds, confidence intervals, masks and scoring formulas remain unchanged.

## Four-arm physical-disk metadata extension

Optional `physicalDiskEnabled` uses the same strict-boolean/echo contract as `linearLightEnabled`, preserving old snapshots that omit it in both places. When true, hashed `inputs/physical-source.json` is required. Its source/reference identity hashes, complete unique five-case map, three uniquely named source DISK lights per case, finite vectors/positive diameters/nonnegative powers and world values are validated. Key power/location and world strength must also match the frozen reference case metadata within the reference metadata tolerance (1e-5).

Each enabled native scenario must have a `physical` object exactly equal to the corresponding physical-source case, and frame `nativeInput` remains exactly equal to its entire native scenario. Disabled/absent physical mode forbids scenario `physical` fields. Legacy camera/light echoes are still validated as consistency records; the single-light echo is not claimed to be the active shading input in physical mode.

These checks establish consistency of the supplied provenance records, not independent proof of execution or physical validity. Area-only keeps encoded reflectance/output as a diagnostic. Combined mode uses decoded reflectance with the physical lighting implementation and sRGB output; this does not add AgX or make complete renderer fidelity/goal attainment claims. The frozen statistical evaluator is unchanged.

## Physical-source pin hardening

`physical-source-pins.json` freezes the complete trusted `inputs/physical-source.json` bytes (SHA256 and size), source-blend identity/version, frozen-reference identity/version, and exact `code/read_lights.py` plus `code/read_source.py` extractor hashes. Any supplied physical-source file must match this pin, including when present in a physical-disabled snapshot. Extractor files must also be in hashed sourceFiles and match their pins.

This closes a reusable-validator gap: coordinated edits to physical source, native configuration, frame nativeInput, and their manifest hashes are rejected against the external fixed pin. Regression tests exercise Fill power, world RGB and Rim position mutations together with consistent rehashing, plus extractor mutation. This hardening is not evidence that the actual earlier candidate inputs were wrong. Existing outputs are preserved; final reviewed runs use the `four-*-002` snapshots and `score-four-*-002` result directories.

## Opt-in source AgX profile metadata

Optional `agxProfileEnabled` is a strict JSON boolean in hashed candidate config and every actual echo. Declaring it requires config and actual `profile` to be exactly `source-agx-medium-high-contrast-v1`, including OFF. ON requires both `linearLightEnabled` and `physicalDiskEnabled` to be true. Actual `profileEvaluations` and `profileClamped` must be nonnegative JSON integers, never booleans; clamped cannot exceed evaluations. ON must have positive evaluations, OFF must have zero for both counters. Legacy candidates omit all profile fields; orphan/missing/mismatching fields and unknown profile names are rejected.

This profile is applied during vertex shading, before interpolation and RGB565 output. It is not a post-pixel transform of previously quantized RGB565 and is not a claim of full Blender renderer parity. The candidate still supplies original raw RGB565 and float depth records. Profile metadata changes only input validation: no metrics, reference bytes, masks, classifications or thresholds change.

`profile-source-pins.json` independently fixes the SHA256 and byte size of `profile/agx_profile.c`, `agx_profile.h`, `agx_lut.inc`, `frozen.json`, and `generate.py`. All five are required in hashed sourceFiles for either declared profile mode. Any individually supplied pinned profile file is also checked in legacy inputs. Rehashing a modified file in the manifest cannot bypass this fixed pin. The runtime counter/echo checks remain consistency evidence, not independent execution proof. Validation reports are intentionally not part of the frozen implementation pin.

The extended suite contains 38 tests, retaining all original 29 tests plus profile mode, prerequisites, orphan fields, counters, unknown names, missing provenance and coordinated source-rehash mutation checks.
