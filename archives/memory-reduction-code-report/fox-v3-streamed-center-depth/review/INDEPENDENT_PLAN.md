# Independent streamed-depth review

Scope: private opt-in center depth strip 8x240 floats plus pending 1x240 floats. Preserve old full-depth APIs and exact cached shader/profile ordering, quarter-sample depths, fixed caps, publication guard. No physical renderer frames are owned by this reviewer.

Checks before acceptance:
- Direct optional 129600-byte capture is a separate frozen/admitted span, not a callback sink. Production has null/zero capture. Compare both modes on synthetic wrap, tail, nohit, tie, sign-zero cases.
- Match full-depth baseline RGB, depth capture bytes, target mask, AA/scene counters and shader/query ordering. Verify pending row copies exactly3840 floats (15360bytes), capture32400 floats (129600bytes), old HDR copy unchanged.
- Reject short/null/misaligned/overflow/overlap descriptors before mutation; include descriptor and separate report. Snapshot descriptor before any opaque overlap callback. Subsequent callbacks may not redirect writes.
- Test first/middle/final shader or composition failure; core private scratch may be partial, complete false and final public outputs untouched by native publication.
- Allocation helper releases partial allocations and reports failure; no old frame file is removed, overwritten, or emitted on failed render.
- Recompute named compiled stack chains and guard ledger under original1024 admission,4096 background stack and637599 producer cap. Source-pin every reviewed implementation and test.
