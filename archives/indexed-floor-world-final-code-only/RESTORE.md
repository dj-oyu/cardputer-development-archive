# Restore the isolated integration

Start from the completed fox-v3-indexed-bvh source tree. This bundle overlays only generic code/tests and aggregate evidence. The four transport files are byte-identical to the completed fox-v3-floor-world-reflection term; visibility.c/h remain the completed indexed v3 code. Preserve all unchanged completed private model/input/profile dependencies at their recorded paths. They are deliberately absent here.

PLAN.md describes the fixed contract. SOURCE_FREEZE.json pins the current91 source/support files. pre-gate-v1 is retained validation history only, not the version to execute. PREREQUISITE_SUMMARY.json records test results before any real-model rendering; actual completion is established only by final output manifests and review, when present.

Build with `python harness/build_adapter.py` for the diagnostic validation renderer, or `python harness/build_adapter.py --no-observer` for the observer-free product candidate. Both are host experiments, not firmware integration or fit proof. Build scripts do not render. Actual run entrypoint requires an independently pinned explicit gate. No permission to publish, push, upload or change devices is supplied by this bundle.

The runner validates exact double HDR/AgX RGB565 against completed floor-world, and depth/mask/snapshot against indexed. Forward world ledgers match completed oldhost. Reverse intermediate shading work differs and must use the corresponding indexed reverse bounds and additive world ledger; only final image/depth/mask/HDR parity is order-independent.

Excluded: source model files, geometry assets/generated headers, LUT payload, reference images, raw output buffers, snapshots, per-sample records, binaries and objects. Reproduction cannot substitute new data or change samples/thresholds to obtain a pass.
