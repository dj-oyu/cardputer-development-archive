# Independent segmented-model PLAN review

Status: approved for implementation, not rendering. Reviewed PLAN.md and baseline VIEW_LIFETIME.md / STREAMING_OPTION.md on 2026-11-04.

Stable independent per-node storage preserves random access and simultaneous borrows. State metadata plus copied pointer-only table is coherent; no streaming or ownership transfer is implied. Caller must keep all used storage alive and not modify table/state/work outside API operations. Source descriptors may expire after initialization; copied pointers are not a corruption-proof capability. All consumers must recompile; host padding is not ABI or target32 proof.

Required implementation review gates:
- Before descriptor dereference, validate count, array address range and alignment. Before writes, validate metadata, output, model/cold, every used slot range, all pairwise writable overlaps and source-descriptor aliases.
- Copy table into protected metadata only after complete validation. No fallible commit steps. Preserve old init path and its contiguous used-byte coverage.
- Each previous arena guard must use metadata plus all immutable-model-derived node lengths, including hidden/group nodes. No contiguous envelope approximation.
- Preserve nonzero generation, owner identity, busy behavior, no-op mutations, failed-evaluation invalidation, conservative borrow lifetime and owned world view.
- Independently own harness allocation handles across instance disposal. Unwind all 56 possible partial allocation failures without publication/leaks. Account for owner bookkeeping and stack.
- Test mixed kinds, ellipse/blend regions, double-sided meshes, source descriptor poisoning, cross-node borrows, aliases in metadata/first/last slots, owner/generation/busy, mutation/reevaluation/disposal. Existing model tests remain necessary.
- Fresh observer/product builds, dependency manifests, source allowlist, stack chains and input freezes are required before parent render approval. Main and background stack limits cannot be hidden in payload-only accounting.

Expected host-only figures: states1320 + pointers440 = metadata1760; node payload80036; total81796. This changes the maximum model allocation, not necessarily lifecycle peak. Global77312 AA allocation and prior render peak496152 remain separate issues.

No source implementation edits, renders, public writes, device/SDK actions, model asset or profile changes were performed by this reviewer.
