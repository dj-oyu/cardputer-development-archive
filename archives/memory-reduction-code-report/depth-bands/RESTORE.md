# Restore checkpoint

Use completed fox-v3-compact-bvh-build as the sole baseline. Apply allowlisted new/changed core and harness sources. Append #include "ksn_depth_bands_impl.inc" after existing ring implementation include in private-build/product/main/ui/kasane/ksn_mesh_depth.c. No other private-build source changes are required.

Current SOURCE_FREEZE and independent review supersede superseded-pre-descriptor-snapshot/ and checkpoint-prerequisite-pending/. Those earlier checkpoints lack the final two descriptor captures and must not be used as final implementation.

Build with harness/build_adapter.py and --no-observer; run test-depth scripts and review mutation/wrapper scripts. Fresh actual execution requires a newly reviewed explicit gate and fresh output paths, never reuse completed attempts. Existing actual-off/on completion markers and retained audit are evidence, not permission for new runs. No device-fit claim; background stack16-byte headroom requires exact-build remeasurement.

Only AGGREGATE_CODE_ALLOWLIST items are approved for private checkpoint packaging by this task. It excludes model/assets, raw frames, build binaries and input pins. No public push authority is implied.
