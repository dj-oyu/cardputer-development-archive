# Caller lifetime trial, pre-actual

Snapshot extraction moved before visibility geometry collection without changing its body. Geometry extraction remains in original source-node order. Cold data and segmented arena are disposed only after all copied geometry and transport attributes have been validated and digested, before BVH allocation. Existing snapshot payload is independently serialized; no new storage is allocated. Nonvisibility fallback remains guarded at the original release location. Scene input poison remains late.

Measured product and observer main frames are both83760. Renderer child4944 and background4016 remain unchanged. Named whole peak is373552, down69412 from442964; render now dominates. Visibility build falls to312548. Geometry extraction299316, release296876 and conservative preparation237304 remain below render. No target or whole-process memory-fit claim.

Original process-return error cleanup remains as baseline, not a reusable lifetime/unwind API. New dispose-error branch frees caller geometry/attributes; post-release builder failure returns before final outputs. Tests distinguish exact extracted lifecycle boundaries and real visibility builder from synthetic test publication markers.

No actual frames have run in this trial. Review/freeze and separate fixed42 execution authorization remain required.
