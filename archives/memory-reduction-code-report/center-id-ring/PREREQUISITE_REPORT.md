# Center-ID ring prerequisite checkpoint
No actual frames executed. Independent review and parent go-ahead remain required before fixed40.

The new bounded-only API retains ten rows of uint16 center IDs (4800 B), leaving the legacy workspace137312 B and APIs unchanged. New workspace77312 B saves60000 B. All seven helper bodies are mechanical specializations; existing generic files remain unchanged except an appended include in the isolated depth translation unit.

O2 synthetic checks pass: legacy63 negative cases, ring71 negative cases,40 exact synthetic comparisons covering nohit, both horizontal edges, all ring wraps, delayed rows,135-row tail, source IDs0/91 and object boundaries, forward/reverse packet order, four composition modes. RGB565, float depth, mask, all reports and shader/profile/query event digests match exactly. Ring memory is poisoned before each comparison. Invalid sourceIDs92/65535 reject. Ring null/misalignment/wrong-size/alias admission checks preserve pixels/depth/workspace/reports.

ASan/UBSan O2 synthetic checks pass with leak detection disabled because LeakSanitizer cannot operate under this environment's ptrace. This is not a leak-check claim. Product and observer adapters build. Adapter91 and prefix2 negatives passed O2; sanitizer adapter results are recorded separately.

Product named stack: background max4016≤4096 (center4016, quarter3840), renderer5664≤8192, main83616 unchanged. Inline quarter specialization increases entry frame but removes separate shade frame; failed noinline trial was reverted. Ring render phase568880 B, down59312 B; unchanged visibility construction dominates overall named RAM593184 B, down35008 from628192 B. These exclude allocator metadata, library/runtime stack, unrelated caller state and unnamed executable/RO as the baseline did. No device-fit claim.

Keep files in CODE_ONLY_ALLOWLIST.json only. No raw frames, assets, publication, PR, SDK, device or reference changes. SOURCE_PINS.json verifies completed source files remain unchanged. SOURCE_FREEZE.json pins the private checkpoint.
