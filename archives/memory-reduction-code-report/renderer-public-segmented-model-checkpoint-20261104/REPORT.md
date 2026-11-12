# Segmented model storage public persistence assessment

Status: **PRIVATE_SAVE_ONLY**. No public export was prepared. The public allowlist is empty. This report and local provenance are private audit records, not publication files.

## Public baseline

Read-only GitHub recursive tree inspection of `dj-oyu/cardputer-adv-pocketjs` at pinned commit `aba669858ab8b813b67ce5831f5d86086b3e0ca3` returned 1,918 entries and `truncated=false`. This is the last published checkpoint on `work/renderer-host-kernels-20261104`. A branch search confirms that the branch exists, but does not expose its current SHA; no fresh branch-head equality claim is made.

That complete tree contains none of `ayatsuri_model.c`, `ayatsuri_model.h`, `ayatsuri_transform.h`, `ayatsuri_visibility.c`, `ayatsuri_visibility.h`, `ayatsuri_shade.h`, `fox_disk_lighting.c`, `fox_disk_lighting.h`, `compact_opaque.c`, or `compact_opaque.h`. It contains the earlier public procedural implementation and indexed visibility experiment, which do not provide the missing model API or physical-lighting dependency.

## Why exact export is not a narrow, buildable change

The private candidate model implementation and header total 1,014 lines. They are not present in the pinned public tree. The segmented storage delta is integrated into the existing model instance, work lookup, lifetime and overlap validation; it is not a standalone allocator implementation.

The model header directly includes `fox_disk_lighting.h`, `compact_opaque.h`, and the procedural header. The C implementation also includes transform, visibility, and shade headers and calls `fox_disk_scene_validate` and `fox_disk_eval16`. Copying the exact candidate C/H onto the public branch cannot build against that branch alone. It would require introducing and reviewing a materially broader unpublished model and physical-lighting stack, with further dependency and compatibility checks, rather than merely publishing the verified storage delta.

The actual helper is `fox-v3-segmented-model-arena/harness/model_arena_owner.h`. It depends on the new model API, and its original comment contains a private fixed-model node count and derived allocation size. Therefore the exact helper is not eligible for the requested asset/workload-constant-free public export either.

No geometry, images, originals, source asset constants, rejected owned-context implementation, or unfinished paged BVH content was read or used for this assessment. No generic extraction or alternate implementation was invented. Existing license files and source headers were not modified, and no new license assertion was applied to unpublished code.

## Outcome and evidence

- `LOCAL_PROVENANCE.json` records exact candidate C/H/helper paths, sizes and SHA-256 hashes, plus the indexed-transport base hashes and delta sizes where present.
- `PUBLIC_ALLOWLIST.json` is deliberately empty.
- No export synthetic tests were generated or run because the feasibility gate failed. This does not invalidate or independently verify the private candidate's tests or actual run.
- No original-asset tests, renders, device actions, git fetch/reset, main update, remote write, PR, or merge occurred.
- Parent confirmed the stop decision: retain private saving and do not extract a new implementation solely for publication.

Keep the existing private persistence workflow. An eventual public model-stack export would be a separate scope requiring complete provenance, dependency review and synthetic validation, not a release of this checkpoint as-is.
