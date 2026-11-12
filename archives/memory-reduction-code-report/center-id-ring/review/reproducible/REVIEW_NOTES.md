# Independent preliminary center-ID ring review

No actual renders performed. Only completed indexed-floor-world base and new center-ID ring source read.

- Symbolic schedule proves 10 rows preserve preceding two rows during 8-row writes, 403 valid row-neighbor references, all16 pending rows,135-row final tail. Nine rows are insufficient.
- Compiled layout test proves generic137312-byte ABI, ring77312 bytes, common8-byte alignment, all trailing offsets shifted down60000.
- Original generic source files unchanged; original bounded full-frame API unchanged. Seven specialized helpers initially matched base verbatim after names/types only.
- New ring stores and five-neighbor accesses are modulo10. Clear only each new band before center work. Every absolute row is cleared once:135*240=32400 uint16 writes. Thus AA_CENTER_ID_INIT32400 remains truthful. New modulo and row-loop instructions are additional CPU work not measured as instructions by semantic counters. No performance or instruction-count equivalence claim.
- Admission checks wn against new workspace sizeof, with overlap span of wn, and preserves original span validation before reports. Initial profile/buffer/report/alias rejection can be atomic; arbitrary runtime failures retain baseline partial-output contract and must not be called globally failure-atomic.
- Binder retains accepted sourceIDs0..91;65535 sentinel distinct. Tests should reject92 and65535, and exercise valid0/91.
- Initial compiler output showed ring entry1552 vs legacy688 and finish176 vs160; inline quarter shading must not be double-counted. Intermediate noinline shading trial produced entry976 plus shading960 giving background4224>4096, a rejected candidate. Await final source/object freeze and exact call graph before stack approval.

## Frozen mechanical product checks

Reverted noinline experiment. Final product object326bcc0e8e04fe399386fd396d9f66ceb560c02dc9109ce81490bc0d1e6af6b2 emits ring entry1552, finish176, no separate ring shading symbol (inlined). All named stack frames and chain sums match emitted files. Background max4016 (quarter3840); renderer5664; main83616 counted separately. Original reserves4096/8192 unchanged. Excludes libc/libm/ABI runtime/allocator/unnamed state, no device-fit claim.

Independent O2 ASan/UBSan exact40 synthetic parity cases and71 rejection cases passed. SourceID0/91 independent variant exact40 also passed. These are synthetic renders only. Reject cases cover six new workspace admission conditions with byte-exact workspace/RGB/depth/reports unchanged, IDs92/65535 before raster writes, profile/shader/resolver failures and reduced original category caps. Runtime false retains partial unpublished-output contract.

Final memory ledger pending: array savings60000, named stack peak grows688 (integrated base4976 to5664) so render total projected568880, saving59312 from628192. Construction stays593184, overall peak improvement35008.
