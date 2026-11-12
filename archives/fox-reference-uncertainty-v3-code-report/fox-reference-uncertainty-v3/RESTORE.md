# Restore and rerun the new reference-only evaluation

This archive contains code, synthetic tests, fixed configurations, metadata and numeric reports only. No source blend, fox geometry, generated image, or raw renderer buffer is included.

Source asset (already private in Space):
- library_file_id: libfile_006f78add78c8191a32fa05312b1ec34
- file_id: file_00000000df8c8230b54dedd01d987867
- original filename: fox-reference-standing-editable.blend
- recorded initial version: 0
- SHA256 required: 9254eaebdfa61143dfdb9480330bc677ae47acfa710715bbfa31ab2943a16806

Restore the original bytes via the supported Space download workflow. The config's source path is /workspace/scratch/6d8dcdbcdc54/fox-reference-sculpt-private/fox-reference-standing-editable.blend. Exact replay uses that path and Blender 4.3.2, eight render threads, Python with numpy/Pillow/scipy. No new software is installed by these scripts. If relocating the configured absolute source path, retain the original config and record the new config hash as a relocation-only new execution; do not mislabel different metadata bytes as an exact replay.

Place this archive's fox-reference-uncertainty-v3 directory under /workspace/scratch/6d8dcdbcdc54, restore the source, then run:

bash fox-reference-uncertainty-v3/run.sh

The command verifies code/config, runs synthetic tests, renders 80 fixed-seed reference images and two fixed source masks, then evaluates reference-only uncertainty. It does not change the source blend or create a native renderer candidate. Samples/seeds/thresholds must not be changed to seek a passing result.

For existing complete local images, rescore without Blender:

python fox-reference-uncertainty-v3/code/evaluate_pack.py fox-reference-uncertainty-v3

The render-manifest and artifact-manifest retain generated image hashes, but images are intentionally excluded from this small archive. They must be regenerated before rescoring. Saved numeric results alone cannot prove rendering reproducibility on another build/platform. Float transport/render differences across versions/threads must be disclosed, not silently accepted.

Previous late-stage v2-2048/candidate20 artifacts were unavailable. This new version does not restore them, reproduce their scores or establish native 60% fidelity. Historical NOT_MET remains historical. The present result is independent Blender reference uncertainty only.
