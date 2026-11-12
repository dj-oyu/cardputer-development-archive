# Independent physical-term review

PASS for the bounded fixed10 OFF/ON experiment on the pinned source. No full physical renders were executed by this reviewer.

## Scope and identity

Only the new receiver → first-floor → uniform-world terminal contribution was inspected. Comparison was against completed floor-display capture-001 and its equal original transport/visibility source in floor-direct-reflection-core. No stopped context-review code or operation was read, used, or retried. This is not a general security/API-ownership certification.

## Findings

- The source accumulates receiver rho × floor rho × uniform world radiance × fixed16 miss fraction / outer16 exactly once per eligible first-floor hit. No extra pi, second receiver/floor rho, fitted coefficient, or recursive blocker bounce was introduced.
- Both floor sides reuse floor_normal; hemisphere directions reuse direction; queries reuse unchanged nearest-hit visibility epsilon/far/two-sided behavior. Blocked character and floor hits contribute zero world and are separately counted.
- Original direct evaluators still receive zero world radiance. Le, original world, original reflected floor direct, bounce, old counters and old work ledger remain numerically separate.
- New rays consume the same cumulative 20M/800M/300M transport quotas; no increased cap. The direct 1M/100M/50M cap is unchanged. Explicit host reservations are 64/shader + 6272/eligible floor hit, maximum 450598848. This is separate from legacy 8M admission.
- Outputs commit only after successful evaluation in tested invalid/budget cases. Consumed traversal and prepaid semantic work remain charged on failure.
- Background centers remain zero and component capture attaches only to successfully committed hit samples in the synthetic AA fixture.

## Reproduced tests

Frozen supplied tests pass under O2 and ASan/UBSan, plus the original bounce/ground/quadrature regressions. Synthetic OFF is byte-identical to old floor-ON over samples, RGB565, depth, HDR centers, counters, results, direct/transport budgets and old work ledger: 977824 bytes, SHA256 ebedf5d8c8f4346edea6cfef32ce5f02e953c4817a543bd35ac7906a6533e05c.

The independently written 41-case suite also passes under O2 and ASan/UBSan. Its separate Cartesian half-plane oracle predicts 130/256 unblocked paths and verifies the component, both signs/windings, character/floor blocker classification, each rho/world scaling separately, unchanged original components, epsilon exclusion, far occlusion and retained outputs under ray/node/triangle exhaustion.

## Gate limitations

Full-frame fixed10 OFF parity still must pass before ON; this synthetic review does not establish it. Runtime retained outputs and completion artifacts must stay subject to frozen capture.py checks. LeakSanitizer was disabled as in the supplied tests; no leak-certified claim. Changed context-size and observer/work memory metadata are real and must not be labeled whole-ABI parity. This review does not claim device performance, legacy 8M work admission, dense-quadrature accuracy, or comprehensive security.

All frozen source/test files and baseline source/output pins were reverified after tests. No implementation or baseline was edited. Only isolated test outputs and this review were written.
