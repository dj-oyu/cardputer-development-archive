# Restore and rollback

Rollback is completed fox-v3-cached-profile-renderer, untouched and source-freeze verified. Restore this differential source over a private copy of that complete tree, preserving unchanged generic445248-byte profile asset and all prior private dependencies, then rebuild every ABI consumer. Never mix old/new binaries or manifests. No owned-ray-context or paged-BVH dependency is used.

New files code/ksn_stream_depth.h and code/ksn_stream_depth_impl.inc add the opt-in private core; old full-depth APIs remain unchanged. Harness row_transport_bridge adds RowStreamRender and row_transport_render_stream_depth. Stream allocation is explicit caller-owned two spans plus optional diagnostic capture. Descriptor/report are frozen/admitted and cache remains caller-owned3224bytes.

Build with harness/build_adapter.py for HDR-observer diagnostic binary; HONE_DEPTH_CAPTURE=on (default) or off controls only full-depth capture. Build --no-observer for product candidate, always without full-depth capture or HDR observer. No-depthcapture actual canaries retain HDR observer and are not pure product-memory runs. All render failure output remains private/partial, and final completion checks gate acceptance.

Only comparison/run_fixed40.py is the approved42-condition runner after source/comparison freeze and independent/parent execution gate. Other copied run_*actual.py scripts are historical references only. Private backup excludes pixels, HDR arrays, snapshots, model/geometry assets, generated LUT arrays and compiled binaries. No device or firmware integration is included.
