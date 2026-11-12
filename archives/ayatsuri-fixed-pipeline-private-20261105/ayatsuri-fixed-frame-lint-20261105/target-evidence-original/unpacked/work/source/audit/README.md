# Independent contract audit of `frame_lint.py`

## Result

Use the pinned tool as an **advisory static pattern scanner**, not a sound lower-bound proof, stack-safety test, performance measurement, or fail-closed CI gate. Its documented “never invents an access / lower bound” guarantee is false for the implementation. Synthetic, device-free tests reproduce false positives, false negatives, an `--check` fail-open path, and ambiguous baseline identity.

Nothing in this audit establishes an ESP32-S3 frame size or cycle count for an ayatsuri prototype. In particular, a host-reported 592-byte figure must not be relabeled as an S3 frame. No prototype, renderer, firmware, real ELF/object, device, existing CI, or public repository was modified or executed. No upstream source was changed.

## Scope, provenance, and reproduction

Pinned repository: `dj-oyu/cardputer-adv-pocketjs`.

Pinned commit: `5898ac4e311d2e48d915b89fd11276b586d72447`.

Inputs were the exact five files recorded in `../SOURCE_MANIFEST.json`. Line references below are to those local files and the same pinned GitHub versions:

- [Scanner](https://github.com/dj-oyu/cardputer-adv-pocketjs/blob/5898ac4e311d2e48d915b89fd11276b586d72447/tools/frame_lint.py)
- [Canned test](https://github.com/dj-oyu/cardputer-adv-pocketjs/blob/5898ac4e311d2e48d915b89fd11276b586d72447/tools/test_frame_lint.py)
- [CMake](https://github.com/dj-oyu/cardputer-adv-pocketjs/blob/5898ac4e311d2e48d915b89fd11276b586d72447/CMakeLists.txt)
- [Performance document](https://github.com/dj-oyu/cardputer-adv-pocketjs/blob/5898ac4e311d2e48d915b89fd11276b586d72447/docs/perf/o2-machine-code.md)

From `ayatsuri-fixed-frame-lint-20261105/`:

```sh
PYTHONDONTWRITEBYTECODE=1 python -B audit/test_frame_lint_contract.py
PYTHONDONTWRITEBYTECODE=1 python -B upstream/tools/test_frame_lint.py
```

Results: **36/36 independent characterization tests pass**, and the original test reports `FRAME_LINT_TEST PASS`. A passing characterization test means the documented limitation was reproduced, not that the scanner is correct. `audit/test_results.txt` and `audit/upstream_canned_results.txt` contain the outputs. All subprocess calls in the independent CLI tests are mocked. The scanner receives synthetic objdump strings only. The test suite also verifies all five upstream source lengths and SHA-256 hashes against the manifest.

## 1. Counts are not guaranteed lower bounds

The claim is in scanner lines 23–26 and performance-document line 93. The counterexample below needs no ambiguity about call ABI or branch formatting:

```text
00000000 <near_after_addi>:
 0: entry a1, 1200
 3: addmi a9, a1, 1024
 6: addi a9, a9, -128
 9: l32i a2, a9, 0
```

The actual effective offset is **896**, within the 1,020-byte word reach. The scanner reports **one far access, deepest 896**. It admits an initial base only when `K > limit` (lines 115–123), but then retains the “far” tag through `addi` even if the result becomes near (124–125). It counts any memory operation using that tagged base without comparing the final effective offset against the limit (108–110).

A “far” result can therefore be a false positive; a zero result can also be a false negative. It is not a safe bound in either direction over all input programs.

## 2. Calls and clobbers

- Ordinary recognized first-operand writes discard the tracked constant/address (111, 126–131). The existing canned test and the independent `test_regular_explicit_clobber_is_handled` verify this.
- Every `call0/4/8/12` and `callx0/4/8/12` is in `NO_DEST` (46–48). There is **no ABI-specific call-clobber invalidation**, and calls do not create target resets (94–97). Far pointers and constants survive calls in the scanner even when the callee may overwrite them.
- The suite includes a synthetic `call0` callee explicitly setting `a2` to zero. A later caller `l32i ..., a2, 0` is still counted as stack+1024. In the windowed ABI, the caller's `a10` is a return-value register for a `call8` callee's `a2`; tracking `a10` unchanged across `call8/callx8` is likewise unsound. No real call was executed.
- Modifying `a1` only invalidates a fact associated with `a1`, not all derived addresses. With an initial pointer `old_a1+1024`, then `addi a1,a1,32`, the access is actually `current_a1+992`; the scanner still reports 1024.
- The first-destination heuristic is not a complete Xtensa instruction-effects model. This audit tests explicit writes, calls, and stack-pointer movement; it does not claim exhaustive coverage of implicit, multi-register, or postincrement effects.

## 3. Derived addresses, offsets, control flow, and widths

The recognized roots are `movi[.n]` plus `add[.n]` with `a1`, and `addmi dest,a1,K`; propagation is only `addi[.n]` on a tracked far base (113–125).

Proven omissions:

- `addmi a9,a1,768; l32i a2,a9,256` accesses offset 1024 but reports zero, because the base was not already greater than the limit.
- `mov.n` aliases, `addmi` from a derived base, and constants loaded by `l32r` are not propagated.
- A symbolic branch target clears all facts, including ones that remain valid on every incoming path (102–103). That is a real source of undercounting.
- Target discovery requires the address-plus-symbol form of `TARGET_RE` (41, 94–97); a bare target address is not recognized. Such synthetic input can retain a fact across a merge where it is not valid on every path. This is a parser-format limitation, not a claim that the requested Xtensa objdump normally emits bare targets.
- The analysis is linear, not a CFG/dataflow analysis. It does not prove reachability, dominance, or address provenance across control transfers.

The tool uses one default **1020-byte word threshold** for all `MEM_OPS` (36, 43–44, 108–125). That is not the direct-offset reach for every listed operation:

- Ordinary `l16ui/l16si/s16i` have maximum unsigned scaled offset 510; `l8ui/s8i` have maximum 255. A halfword at 512 or byte at 256 can need address setup yet is omitted by the default word-focused metric. This is a scope limitation, even when not a false negative for the narrower “greater than 1020” definition.
- Compact `.n` and exception-access opcodes also have their own encoding constraints; the scanner does not validate encoding, alignment, or instruction-specific legal immediate ranges. A compact access may have a single-instruction full-width alternative, so its shorter encoding reach alone does not imply an extra setup instruction is necessary.
- `deepest` is the largest **effective starting offset of recognized sites**, not the highest byte touched. A 4-byte access starting at 1024 reports 1024, not 1027 (110). It is not a stack extent or memory-safety bound.
- No verification checks whether a computed address is actually inside the function's frame. Caller-stack arguments and other `a1`-relative uses are not classified by ownership.

## 4. Missing or failed disassembly and `--check`

Scanner lines 147–153 return an empty list when objdump exits nonzero; main does not propagate that failure (186–190). With no counted violations, `--check` exits **0** (212–218).

Reproduced outcomes:

| Situation | Outcome |
| --- | --- |
| No objdump found, reporting mode | Exit 0 with `FRAME_LINT SKIPPED` |
| No objdump found, `--check` | Exit 1 |
| Objdump exits nonzero, `--check` | Error on stderr, **exit 0** if remaining rows do not exceed baseline |
| Objdump exits 0 with empty or unrecognized text | **Exit 0** |
| Input set empty, or filter excludes all files | **Exit 0**, no disassembly attempted |
| Required baseline function absent from all scanned input | **Exit 0**; baseline is an allowance list, not a coverage inventory |
| Subprocess cannot launch at all | Uncaught OS exception, not a silent success |
| Frame grows to 3904 with zero recognized far sites | **Exit 0**; frame size is not a checked budget |

An explicit nonexistent `--objdump` can also fall back to a PATH tool (56–63). There is no architecture, expected-symbol, input-count, parsed-instruction-count, or parse-coverage validation. A success code alone is not evidence that the intended S3 artifact was analyzed.

The current **CMake target is intentionally report-only**: lines 27–32 use `--baseline` and `--far-only`, but no `--check`. `NEW` or `GREW` therefore does not stop this target. `--far-only` hides displayed rows with a large frame but zero recognized sites; it does not turn the frame into a gate. The audit leaves that integration unchanged.

## 5. Duplicate function names break identity

Rows retain `src`, but baseline keys are only `func` (156–164, 198–201, 209–218). File/section/address is not part of the key. Display even reduces the source to its basename (203).

Two translation units containing a static function named `same` reproduce both failure modes:

1. Current sites: `a.o:same = 2`, `b.o:same = 1`.
2. Baseline writer emits `same 2` followed by `same 1`.
3. Loader overwrites the first entry with the second: `{"same": 1}`.
4. The **unchanged** inputs now fail with `same: 2 far accesses (baseline 1)`.

Conversely, a newly introduced `same` in an unrelated object inherits an existing `same 2` allowance, is not marked `NEW`, and may pass `--check`.

A safe comparison needs artifact/source and symbol identity, plus a deliberate policy for compiler clones and LTO. Summing, maxing, or overwriting duplicate names silently is not adequate provenance.

## 6. What the output actually means

- **`far` / `accesses`:** number of recognized static memory-instruction sites carrying the scanner's far tag. Not dynamic execution count, guaranteed lower bound, per-frame work, or cost.
- **`computes`:** number of recognized root address constructions. It is not printed in the normal table.
- **`+insn` / `extra`:** weighted root-pattern count, adding 2 for `movi+add` and 1 for `addmi` (119, 123). It is not an exact instruction census or measured overhead. One shared `movi` followed by two `add` instructions reports **4**, despite only **3** static setup instructions. Root computations never used by any memory instruction still count. A propagated `addi` contributes no extra count. One setup reused by two memory sites is counted once, not twice.
- **`frame`:** maximum parsed `entry a1,N` immediate (105–106). It is not maximum dynamic stack usage, caller/callee cumulative stack, recursion depth, interrupt/window-spill demand, or task stack high-water mark. Missing `entry` yields 0 even if a recognized access is reported. Later stack adjustments are not added.
- **`deepest`:** maximum start offset for recognized sites, with the limitations above.
- **Cycles:** not measured or bounded by any of these fields. Loop trip counts, branch outcomes, hotness, spills/calls, cache/stalls, and target configuration require separate evidence.

The performance document explicitly distinguishes measured/coded/inferred evidence at lines 5–8 and static sites from execution count at lines 102 and 117. Its single-file disassemblies use Xtensa GCC plus host stubs and are explicitly **not the firmware ELF** (7), and it says baselines should come from a real build (117). Those caveats must travel with any reused numbers. The doc's blanket “all spills become 3x” statement at line 87 is too broad: near stack accesses remain directly encodable even in a large frame, and `addmi` or shared setups change the cost. The original canned test itself has a large frame with no counted far accesses.

## 7. Safe application to fixed-point prototypes

Without changing upstream or CI, an independent future evaluation should:

1. Preserve compiler, flags, target ABI, source/artifact hashes, build configuration, and exact disassembly. Use the actual S3 artifact for S3 claims; keep host-only numbers labeled host-only.
2. Verify every expected input disassembled successfully and contains expected target symbols/instructions. Treat missing, failed, empty, filtered-away, or wrong-architecture input as **inconclusive/failure**, never zero.
3. Report scanner results as advisory pattern counts. Manually inspect relevant bodies around calls, address mutations, branches, aliases, and mixed-width accesses. Do not claim the existing algorithm is a sound lower bound.
4. Keep stable source/symbol identity for comparisons; explicitly reject ambiguous duplicate names. Do not reuse an unrelated global baseline as a prototype budget.
5. Record `entry` frame and other stack evidence separately from far-site counts. An S3 frame budget needs actual S3 build evidence; a host 592-byte observation cannot satisfy it.
6. Treat unchanged/zero static counts as **not a performance verdict**. Any speed or cycle claim needs an authorized target measurement under matched conditions. This audit does not authorize or perform one.
7. If this is later promoted into a strict gate, fix fail-open error/coverage handling and the dataflow/identity contract in an explicitly reviewed tool change first. No such fix is included here.

## Source hashes verified

```text
6be4b15d41f3da5fb4489384d11577ebdc11241447b7521b2635dd1cfdf6aa27  upstream/tools/frame_lint.py
8c4c9521204c62b49ac8801229ad7144f9fd9e98b3a078751fb024a6a1bb7fa1  upstream/tools/test_frame_lint.py
dabb33327c56cb168e853f1517a2d897ab91e341f9cc0cee298cd8be6ba2d566  upstream/tools/frame_lint_baseline.txt
440b6a19a81526a96d494dce8e1f1398031923b6fd5ebc652616bfa83dbd55ab  upstream/docs/perf/o2-machine-code.md
12b9f991f5afb536ffb84df8db73ecd2c60adf8cb98daef18dee6578373a28e1  upstream/CMakeLists.txt
```
