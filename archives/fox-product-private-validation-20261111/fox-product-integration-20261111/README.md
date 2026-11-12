# Private product control boundary candidate

## Implemented and verified

`generic/ayatsuri_controls.js` is a model-independent, optional **control companion**, not a new AYNM section or an automatic `AyatsuriNative.scene` skin API. It owns copied channel metadata, validates numeric domains and integral controls, copies motion inputs, guards reentry, and calls an explicitly injected synchronous backend with a fresh Float64Array. State only advances after that callback returns successfully. Callback validation and transactional native publication remain the backend's responsibility; asynchronous callbacks are outside this contract. Disposal disables companion and old motion handles; it does not release a backend or retire presented frames.

`private/fox_controls.js` contains the private source-specific names, ranges and defaults. `private/bridge.c` installs an explicit private backend object with commit/hash/hidden methods instead of a model-specific `foxNativeCommit` global. It still uses the prior synchronous two-slot renderer solely for comparison; it is **not** an asynchronous production retirement implementation. The separate lifetime work owns that design. No private geometry, model names, control names, source materials, graph data or hashes are in the generic module or synthetic test.

The real QuickJS/AyatsuriMotion/native source-color-alpha raster O2 run emits the exact same 34 commits and 9 sweep records as the prior accepted control bridge. The old public sampler is unchanged. Generic synthetic tests cover metadata and packet isolation, ranges, integral channels, callback failure rollback, reentry, copied keys/channels, motion stepping, duplicate-channel rejection and disposal. `validation.json` records exact comparison and sanitizer status.

## Why not put this model into AYNM yet?

Read-only source audit at frozen commit `828baa3af69c55e7884c53557ea39f91190010a0`:

- `apps/lib/ayatsuri_model.js`: scene.evaluate calls instance.targets and instance.evaluate. No automatic skin/control binding exists here.
- Managed instance.evaluateSkin/evaluateSkins and C transient geometry already exist. This work does not describe all Hone paths as missing.
- `main/ayatsuri/ayatsuri_model.c`: known wire sections 1 through 13; required unknown sections fail, optional unknown sections are skipped after bounds checks. No persisted skin table is implemented.
- `tools/ayatsuri/model/pack_model.cjs`: mesh bounds 3–32 vertices and 1–64 triangles per part; degenerate triangles fail; mesh common thickness/opacity/edgeSoftness must be 1/1/0.
- `tools/ayatsuri/asset/import_glb.cjs`: nonempty skins/animations and node skin/weights are rejected; degenerate geometry is rejected.
- The private eye proof intentionally retains source-neutral degenerate triangles, source visibility and fragment alpha/material semantics. Sending it through this static importer would not preserve those semantics.

Consequently no AYNM flags, safety checks, geometry or material rules were weakened. Unchanged synthetic mesh pack tests pass with 31 rejection cases; unchanged GLB import tests pass 91 cases. Existing AYNM backward behavior is unchanged by construction, not evidence of newly supported skin import. Full automatic scene skin evaluation, skin-table import and source-alpha production scene submission remain open, requiring a separately reviewed format/render contract. This candidate makes the control boundary reusable without pretending those gaps are solved.

## Isolation and ownership

This is a NEW private source directory, not a branch or modification to an existing checkout. Inventory (read-only local heads, not current remote-head claims):

- qemu-render-20261111: 828baa3, feat/q7-host-validation-20261107, existing untracked target/QEMU directories preserved.
- cardputer-firmware-main/current: 1b4524e; current has preexisting staged deletions, untouched.
- cardputer-firmware-integrated: 2980d1d, untouched.
- hone-dq-converter-20261106: 55ab9c7, existing untracked skin/DQ files untouched.

No old 52b119ca mapping is assumed. Original fox-bubble-bold and the diagnostic 2k-v2 asset are not conflated; this adapter reuses only the existing private 2k-v2 runtime proof and does not claim original-model delivery. No public commits/pushes/PRs, CI edits, hardware operations, parallel QuickJS dual-core worktree changes, AF_UNIX retry or permission changes occurred. No new QEMU run or full firmware performance/fit claim is made here.

## Replay

From workspace root:

- `node fox-product-integration-20261111/generic/test_controls.cjs`
- `python fox-product-integration-20261111/private/build_test.py o2`
- `python fox-product-integration-20261111/private/build_test.py san`

The private build requires prior private runtime/compositor directories and frozen public QuickJS sources already in this workspace. It is not a self-contained release artifact. LeakSanitizer is disabled as in the accepted host harness; ASan/UBSan passing does not prove leak freedom. `generic/` is the only candidate reusable code/test area; the rest must remain private. Public release is not part of this phase.
