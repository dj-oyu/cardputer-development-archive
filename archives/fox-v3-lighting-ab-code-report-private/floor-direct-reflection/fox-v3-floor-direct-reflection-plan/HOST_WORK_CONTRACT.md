# Separate host floor-work contract proposed for review

Parent explicitly authorized a separately named host diagnostic budget after the old8M admission failure. This does not increase or reinterpret the existing AA8M ledger. Transport20M/800M/300M and owned-byte caps stay unchanged.

Fixed source-level semantic reservations (not machine instruction counts, CPU equivalence or device-fit proof):
- Every shader invocation:128 = descriptor validation/comparison64 + new result/counter merge64.
- Every primary tagged floor hit:192 = eligibility/finite/unit/dot/normal selection128 + ledger/guard dispatch64, even if tangent/zero-rho skips evaluation.
- Each invoked floor DISK evaluator:12000 = input/scene validation768 + three disk proximity/setup96 each +48 kernel128 each +48 sample/loop/callback-overhead96 each + light reduction/rho/output128 + floorRGB accumulation/counters64.

The full evaluator reservation is charged before invoking it, with no refund for early failure or nonpositive kernels. Callback reserve includes non-BVH callback dispatch and query counting; vis_segment_occluded admission and traversal are independently accounted by existing ray/node/triangle budgets, not claimed as scalar internals measured by this ledger. Fixed upper sample count48 is charged even when fewer visibility queries fire. All integer overflow/budget checks precede work; exhausted budget aborts, output result remains unchanged, consumed work remains visible.

Max existing complete A2 all20 workload:17241 shader invocations,71667 primary floor hits (WORKLOAD_BOUNDS.json pins exact percase/order). Fixed host-only upper875970912 =128*17241 +12192*71667. Enforce per-frame corresponding exact call/hit upper bounds as well, derived from unchanged geometry and current successful A2 replay, not images. Changed binding or excess fails without publishing quality manifest. Runtime evaluation count may be lower for exact-zero-rho or tangent skips; each skip is counted. New evaluator kernels =48*floorEvaluations after successful completion. New floor visibility callbacks<=kernels. New transport rays=old primary+secondaryworld+nonfloordirect+floordirectqueries.

Zero-rho compatibility: new floor illumination evaluation/query/component counters are zero and RGB/depth/snapshot plus old transport counters remain byte/value exact. Separate experimental admission/descriptor-check work may be nonzero and is reported separately; do not claim all new host-work is zero. Disabled old API does not consume a floor-work budget. New mode uses explicit experimental evaluator; old evaluator rejects unsupported new nonzero reflection mode rather than silently ignoring reflection.

Require finite three-component rho in[0,1], exact actual source float values, descriptor copy ownership, changed rho material generation, changed mode/Le/range emission generation. New32/64-bit sizeof/stack and total scene bytes measured in fixtures. All legacy ground struct callers must zero-init added rho fields, compare fieldwise and never hash padding.

No code implementation until reviewer confirms this contract. All later quality success must be labeled separate-host-floor-budget, not old8M frame admission. Predetermined negative result stops; no gain/rho/sample/epsilon tuning.

Source anchors: physical/fox_disk_lighting.c54–68 and156–170 for validation;121–135 and171–177 for proximity;137–153 for kernel;178–201 plus transport/bounce.c55–56 for sample/callback overhead excluding visibility implementation;202–213 for reduction/output. libm operations count as primitive stages, not implementation instructions. Contract therefore never equates875970912 with CPU instructions or historic AA stages.
