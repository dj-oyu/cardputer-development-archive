# Private geometry-only actual-C evaluation adapter

Changes only host geometry admission/accounting and scorer provenance. The product, physical, visibility and transport source trees are byte-identical to frozen `fox-v3-ground-transport/le-001`. All image metrics, frozen masks, thresholds and numeric precision are unchanged. Actual C host execution, not GPU or Blender simulation. No new model or media publication.

## Prepare, independently review/pin, run, score

From workspace root, replacing uppercase values:

    python fox-v3-occlusion-evaluation/code/prepare_geometry.py --glb GLB_PATH --glb-sha256 APPROVED_GLB_SHA --output PREPARED_ABSOLUTE_PATH

Preparation compiles five scenarios with the unchanged compiler, records exact partition counts, compact snapshot bytes, model/compile/material-trace hashes, independently opens the model through C for arena size, creates `code/expected_counts.h`, and prints certificate SHA. Preparation rejects snapshot >65536 and geometry+ground >2048 triangles. No renderer admission limits are raised. Parent must approve/pin the resulting certificate SHA independently of the candidate manifest; do not read that pin from an untrusted candidate manifest.

    HONE_REFERENCE=/workspace/scratch/6d8dcdbcdc54/fox-reference-uncertainty-v3 HONE_GROUND_MODE=2 python PREPARED_ABSOLUTE_PATH/code/run.py FRESH_RUN_ABSOLUTE_PATH APPROVED_CERTIFICATE_SHA
    python PREPARED_ABSOLUTE_PATH/scoring/score_candidate.py FRESH_RUN_ABSOLUTE_PATH/candidate-manifest.json --geometry-certificate-sha256 APPROVED_CERTIFICATE_SHA --reference /workspace/scratch/6d8dcdbcdc54/fox-reference-uncertainty-v3 --output FRESH_SCORE_ABSOLUTE_PATH

Runner copies frozen prepared inputs; certificate verification protects all compiled models and renderer sources. Runs all 10 views/scenarios and reverse order. Ground begins at exact compiled character triangle count. All admission/work/transport/direct caps are unchanged. A failed run has no candidate manifest and must not be scored. HONE_SMOKE_ONLY=1 renders only first baseline front forward/reverse and deliberately produces no quality manifest. Use only for parity smoke checks.

## Regression evidence

- `smoke-old-002`: actual-C first baseline front and reverse RGB565/depth byte-exact against frozen le-001 (four files).
- `tests-geometry.log`: 3 tests pass, altered counts/accounting, compile artifact, and coordinated GLB/certificate rehash rejected against externally supplied pin.
- `tests-scorer-002.log`: frozen scorer regression suite; only CLI freshness test updated to supply the newly mandatory certificate argument.
- `metric-parity.log`: direct exact comparison of old/new score results and masks on frozen old all10 frames, without new rendering.
- Candidate/full all10 rendering and full cost/admission regression remain coordinator responsibilities after candidate selection.

Implementation changes: `code/native_render.c` (include generated constants and replace three literal checks/offsets), `code/run.py`, `code/prepare_geometry.py`, `code/geometry_certificate.py`, `scoring/score_candidate.py`; test additions and one CLI test update. `code/compile.cjs` unchanged. Source, reference, floor emission and material semantics remain unchanged.

## Initial four-stage compile-only comparison

| Geometry | Vertices | Triangles | Parts | Cold B | Arena B (C parser) | Snapshot B (compile-derived) | Fits 65536 |
|---|---:|---:|---:|---:|---:|---:|---|
| Old | 849 | 1166 | 45 | 35636 | 65892 | 52212 | yes |
| Stage 1 | 874 | 1210 | 46 | 36700 | 67452 | 53760 | yes |
| Stage 2 | 1016 | 1314 | 51 | 41788 | 75524 | 62104 | yes |
| Stage 3 | 1354 | 1520 | 62 | 53580 | 93692 | 81832 | no |
| Stage 4 | 2035 | 1938 | 83 | 77236 | 128948 | 121564 | no |

No stage had actual append or rendering executed. Snapshot is calculated from unchanged compact wire serialization and actual compiler partitions; it is not a measured append admission result. Stage 3/4 are rejected during preparation. Stage 1/2 passing preparation says nothing about geometry correctness or actual runtime admission. Certificate files in rejected prepare directories are diagnostic artifacts only; verification rejects them and no accepted SHA is printed.
