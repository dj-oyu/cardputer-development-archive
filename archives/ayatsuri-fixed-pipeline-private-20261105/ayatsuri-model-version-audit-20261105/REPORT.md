# Model version provenance audit

The Q16/Q20 comparison used an older fox fixture, not the latest user-approved source.

## Latest intended source

- Source: `fox-bubble-bold-private/fox-bubble-bold.blend`, 24,187,852 bytes.
- SHA256: `d15a3316e1be75a9707a92ac44027f713306011dc3adf3fe7a9cc9a538122c1a`.
- Private save receipt: `fox-bubble-bold-private/checkpoint-result.json`, succeeded for `libfile_4dee400f3a7c819184d5fcc2a4953de9` / `file_00000000aae8820c8ffa757c84f7de2a`.
- User asked to thicken the bubble seam at 2026-11-04 08:54 UTC. The result was delivered at 08:59:28 UTC, followed by the user's `ok` at 09:01:23 UTC, message `Sentinel_5e948ebc456c8191a296bb6a555797b6`. Exact retrieved conversation evidence is in `approval-evidence.json`.
- `build.py` derives this file from `fox-bubble-algebra120.blend` and changes the eye seam threshold from 0.0125 to 0.035 with revised area compensation. The source lineage continues through bubble glints, surface eye parts, surface brows and the head/gaze controls model. This is the newer character with expression controls, not the older standing-model reduction.
- No Git commit for this private model was established. Its identity is the exact file hash and successful private save receipt. Do not substitute a renderer-code commit for a model commit.

## Actual comparison fixture

- AYNM: `fox-v3-floor-direct-reflection-evaluation/actual-002/compiled/model-baseline/model.aynm`.
- AYNM SHA256: `68985ce128275a4b50c9bbad791bcd9eff8a41e788e4b5672d65c80755aade9f`.
- Its actual `inputs/geometry-source-sided.glb` is byte-identical to `fox-v3-lid-source-lod/lid-8.glb`, SHA256 `833ac7683872375f9e63f819618e0e25ed40e0ac761a35f7604cd45501207a8e`.
- This actual geometry has 1,564 character triangles. It is a later eye/lid LOD derivative of the older source; it is not simply the untouched 1,200-budget export.
- The copied candidate configuration retains version `new-candidate-v3-rebuilt-4a4d` and the ancestral description: `Preserved earlier 1200-budget reduced mesh. Not lost 2400/2048 candidate. Only authored material sidedness restored.`
- The ancestral source is `fox-reference-sculpt-private/fox-reference-standing-editable.blend`, SHA256 `9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806`, as established by `fox-native-private/export-report.json`. That report explicitly states the visually unaccepted posture is unchanged and only opaque base colors are transferred, with no texture/morph/rig.
- `fox-native-private/reference-provenance.json` records code commit `76796a5c5ae53505de7de4f79b8e205ea1dc9c19`. It identifies the historical import/render code only, not the current approved model.

## Existing preview and its evidence limit

- Preview: `fox-bubble-bold-private/bold-still-01.png`, SHA256 `fff05e2253f1a1d795f98923958fbc29c3d89e2ce3fb7c75ed38277e5098952b`, private file `libfile_f2cc687bbd148191ab8392cf8450ef16`.
- `still.py` explicitly opens `fox-bubble-bold.blend`; `still.log` line 3 records that read and line 130 records this image save. The image was visually inspected during this audit and shows the newer round expressive face with large white bubble glints and a separating dark seam.
- It is a face-close preview at frame 1 with watery eyes, worried brows, stylized highlights on and environment eye reflection off. It is not a neutral full-body renderer parity reference.
- There is no historical source-hash/run manifest in this folder. Therefore the preview is bound by source path, script, log and private save receipt, not by a contemporaneous input SHA. The current source hashes exactly match the official saved source independently downloaded by the parent. Do not overstate this as a historical cryptographic proof of the preview.
- Delivered animation: `bold-loop.gif`, SHA256 `e447a353109d1a3fc187f656dcb18aa71c215f0f9d240d9117caf97b9d389cd7`, private file `libfile_cca8cac7d07c8191afe91980e7d33a84`.

## Native asset availability

A scoped inventory of 65 private fox authoring folders found no GLB/AYNM/bin in the newer expression, head/gaze, face-parts or bubble source folders. Existing native assets were confined to the older `fox-native-private` and packet experiments. Their presence does not establish compatibility with the latest source. No existing native asset bound to the latest source was verified.

Use the latest source hash as the new import/conversion boundary. Do not relabel old fixture images or conclusions as latest-model results. A conversion assessment is needed before any new comparison, especially for procedural eye materials, expression masks, shape keys and the limited rig.

## Scope

Only allowed local source files, existing metadata/logs, image pixels and conversation history were read. No source file or Git state was modified; no new render, ray evaluation, export, hardware action or publication occurred. Excluded directories were not traversed. New audit files were written only in this audit directory. `provenance-audit.json` contains exact file hashes, receipts and the bounded native inventory.
