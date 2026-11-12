# AA phase overlay: completed exact validation

Authoritative post-validation report. REPORT.md is preserved unchanged as historical pre-render evidence because it belongs to the 152-file source freeze.

## Result

Fixed40 completed: world OFF20 followed by ON20, canary first in each arm, against completed fox-v3-segmented-model-arena. Independent retained-output audit passed all40 frames,200 raw-stream comparisons,280 report comparisons and80 forward/reverse comparisons without rerendering. All RGB565, float depth, snapshots, target masks and HDR streams match their same-arm/order baseline exactly. Reports match except .aa.json workspaceBytes77312→72512 and the predeclared descriptive timing fields. No model-size or semantic-counter exception.

Source freeze152 files remains unchanged. SHA256 f08fea4fb0aa67fba4422c919a35ced61484f62218a764b9d367c953b6ef80b6. Independent final review SHA256 ac62f960eca5525afa625277b1fa769b17c996a45a2f206f5c74fbc6b54cea71. Completed OFF and ON manifest hashes are pinned in FINAL_RESULT.json.

## Storage and limits

Center IDs occupy4800 bytes after the unchanged5760-byte pending HDR row within the existing13440-byte winner union. Center phase ends before quarter winner initialization. Workspace77312→72512 saves4800 bytes with no additional allocation or admission span. Legacy generic AA stays137312. Product named render/lifecycle peak496184→491384, saving4800. Largest named requested heap allocation is AA72512. Product main83792 is stack, not heap; renderer5008 and background4080/4096 are unchanged. Background margin remains only16 bytes. Observer main83776 unchanged. Product and observer text each increase128 bytes; data/bss unchanged.

Model storage is unchanged: payload81796 plus owner912, total82708 requested bytes across57 allocations; largest model request1760. Allocator metadata/fragmentation, library runtime stack and other previously excluded costs are not included. No firmware integration, target/device-fit, whole-host-fit, speedup or general quality claim.

## Validation and failure semantics

Legacy24 runs, integration48 compile/run steps, model6 modes, each normal/sanitized ring and depth80 exact cases+72 negatives, producer63 negatives, adapter94 negatives+2prefix cases passed. Coverage includes center/quarter phase reuse, wraps, delayed rows7/15, seven-row tail, maximum accepted ID91, forward/reverse order, poisoned/unpoisoned repeat and first/middle/final callback failures. Initial derived depth-oracle test omitted the established admission120→210 difference; final tests assert those exact values and compare every other report field. No product correction was required. LSan was disabled under ptrace; no general leak-clean claim.

Core RGB/depth remain private scratch and can be partially modified on failure. Explicit finish rejection probes preserve candidate bytes during source/identity/budget verification; unchanged native success checks precede final exports. Prefix tests protect prior artifacts. This does not establish whole-core transactionality, atomic multi-file writes or an end-to-end late-render publication-failure injection. Private attempts and completion markers remain required for external acceptance.

Copied private-build product dependency files remain byte-identical; the bounded workspace header/layout assertions are the only renderer implementation changes. No arithmetic, row scheduling, callbacks, packing, budgets or guards changed. Baseline remains intact for rollback; recompile consumers with the matching opt-in header. No raw model/source assets/reference/profile, SDK, device, public repository or PR changes. Final aggregate delivery excludes raw outputs and compiled binaries.
