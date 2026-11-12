# Runtime resource reuse decision

Read-only audit of validated 373552-byte named host peak. No renderer, original model/reference or firmware changes were made for this audit.

Current remote main 51f5febb753e3f0d0950043af0b579119d6fa0f0 has one3840-byte shared drawing strip and one3840-byte transmission strip, not a full-frame buffer. An older local checkout had two TX strips; that observation is historical only. Presentation is progressive and does not roll back already displayed bands on a later failure. Therefore no64800-byte safe existing framebuffer reuse credit is justified. The old formal-build4a4d commit could not be resolved remotely; current source is not evidence of current flashed firmware or hardware fit.

The live snapshot is also unavailable for output reuse. Its64208 used bytes remain read through quarter sampling and final source verification. Reducing65536 capacity to exactsize would save only1328bytes; moving it from stack to heap alone saves no payload. Folding center depth into the existing AA union would save only2880bytes while increasing its largest allocation to78272bytes, without a validated new admission proof. These are not recommended trials; previous RGB/AA fragmentation proposals are not repeated.

Selected next feasibility trial: reuse the visibility scene's already owned xyz values for exact node bounds. Current bounds are min/max selections of finite input coordinates. Six uint16 vertex references plus the unchanged four uint32 traversal fields would nominally shrink each64-byte node to28bytes, saving36828bytes at1023nodes. No floating-point quantization, new borrowed lifetime or framebuffer exposure is proposed. Exact signed-zero/fmin order, axis selection, traversal/counters, index validation, failure publication, actual compiled stack and byte-exact outputs must pass before accepting this representation. This is a proposal only; code and results belong to the separate fox-v3-indexed-bvh-bounds trial. No memory saving is yet credited.

Detailed evidence: firmware/REPORT.md and SOURCE_PINS.json; renderer/REPORT.md and SOURCE_PINS.sha256. Historical heap observations are not current hard caps. No device or SDK work occurred.
