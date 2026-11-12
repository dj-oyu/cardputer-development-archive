# Private fixed-point stack analysis: source-bound static investigation

## Scope and identities

The referenced tool is `dj-oyu/cardputer-adv-pocketjs` at `5898ac4e311d2e48d915b89fd11276b586d72447`, branch `claude/vigilant-einstein-capnag`. Five fetched files were verified against both their Git blob SHA and local SHA256 (`SOURCE_MANIFEST.json`). The upstream scanner remains unchanged. Its SHA256 is `6be4b15d41f3da5fb4489384d11577ebdc11241447b7521b2635dd1cfdf6aa27`.

The investigated fixed-point sources are independently frozen prototypes, not that branch's renderer or an integrated firmware HEAD. Material constants are derived from the latest approved model and remain private. The exact 19 source/header dependency hashes are in `target-probe/capsule-manifest.json`. No model geometry, image, private profile blob or fabricated profile definition is included in the compile capsule. All existing renderer, visibility, admission, CI and source files remain unchanged.

The earlier host GCC14.2 own frame of 592 B for `kcc_block` is host-only. It is neither an ESP32-S3 frame estimate nor a total stack peak.

## What was verified locally

- Original upstream canned scanner test passes.
- 36 independent characterization tests reproduce ordinary behavior and limitations without a target toolchain or device. Full source references, exact synthetic counterexamples and test logs are in `audit/`.
- Seven hash-verified retained generic PIE transfer objects were inspected through their saved Xtensa disassembly. Their object headers are ELF32 little-endian Xtensa ET_REL. The saved `entry` values are 32 B for six C functions and 16 B for the assembly leaf. Normalization removes only raw instruction bytes and relocation annotations before the upstream parser. No default-limit rows appear. This is parser sanity on older generic transfer kernels, not a fixed-point renderer result or proof of total stack safety (`retained-target-sanity/`).
- The local VM has no discoverable existing Xtensa compiler/binutils in the bounded locations checked. A private source-only capsule and explicit compile-only plan were prepared instead of installing a toolchain or pretending host objects were target objects.

## Scanner caveats that affect adoption

The scanner is useful for locating possible far-stack address sequences, but its advertised guaranteed lower-bound interpretation does not hold universally:

- A tracked `a1+1024` base followed by `addi -128` still produces a far-access report at effective offset896. Calls do not invalidate potentially clobbered register facts.
- Aliases, literal-based addresses, near bases with crossing offsets, branch-target resets and narrower byte/halfword addressing can miss accesses. A single1020-byte threshold does not describe every memory opcode's immediate encoding.
- Failed objdump can become empty output and `--check` exit0. Empty, filtered or unrecognized input can also look clean.
- Baselines key only on function name, so duplicate static names across objects/configurations can collide. Do not combine Q variants or import an unrelated firmware baseline.
- `+insn` is heuristic address-construction bookkeeping, not an exact dynamic extra-instruction count. Shared setup can be double-counted.
- The branch's CMake integration is explicitly report-only, not an existing mandatory CI gate.

The original documentation's observed XTPERF/IPC/branch costs concern another workload and firmware. They must not be transferred to these integer kernels. Even a final Xtensa ELF establishes static code and placement, not measured execution counts, cycles, FPS or PIE acceleration.

## Safe application plan

1. Pin exact source/configuration/compiler, response/spec files, standard-library headers and target ABI. Preserve all existing diagnostics and admission checks.
2. Compile the independent numeric TUs only at Q16/Q20/Q24 with final Os/O2, retaining each variant separately. Do not link or execute them. Profile API calls remain unresolved intentionally.
3. Require successful readelf identification and nonempty successful Xtensa objdump before interpreting any scanner output. A skipped or failed scan is unavailable evidence, not zero accesses.
4. Compare `.su` own frames with `entry` immediates and manually verify every proposed far-access site in full disassembly. Record source/object/function/configuration together. Do not flatten by function name.
5. Record literal/text size, calls, 64-bit helper dependencies and unresolved externals separately. Q storage choice does not eliminate the checked64-bit arithmetic used by the current material and lighting kernels.
6. Treat object findings as optimization candidates. A later separately authorized actual firmware build would need final ELF inspection, complete call-chain/window/task-stack analysis and workload measurements. No such integration or device measurement is performed here.

## Target continuation

The already authorized compile-only S3 environment was located and confirmed unchanged: ESP-IDF6.0.1, Xtensa GCC15.2.0, matching binutils2.45, formal component compile database, clean checkout HEAD `1c615380f5946f93fc7c210e89390ad99129164c`. The private capsule was provided for the same independent compile scope. Static compilation is complete and its returned evidence has been read back and independently checked, as recorded below.

Private input: `libfile_8063b7f1f1a88191a01caed0980c0dbf`, version0, 67,931 bytes, SHA256 `4337dce0117279e68ade0b1fa7279c9738436c0661740cd09abdf9bd1c68c04b`. This is a source capsule, not a target result. Its caller-supplied branch radiance and diffuse-only numerical contracts are unchanged by compilation.

## Completed target-object results

The original capsule produced 18 successful objects and six compact-connector failures. The failures were solely the two reported misleading-indentation diagnostics in `normal_bridge.h` and `compact.c`. The original failed logs and all successful objects are preserved. A separately authorized, private formatting-only derivative splits those statements across lines; no C token, predicate, operation order, compiler diagnostic, ABI assertion or resource check changes. All six compact variants then compile successfully under the same formal configuration.

Across the resulting 24 successful objects, Q16/Q20/Q24 each have Os and O2 variants. Independent verification checks the original 358 manifest payload entries and the 133 added payload entries, their ELF32/Xtensa/ET_REL headers, and all129 function-instance prologues against `.su` and the recorded tables. The updated archive preserves every original359 ZIP entry byte-for-byte. These are object results, not a final firmware ELF.

Selected own frames (Os / O2, same across Q unless specified):
- Final-only connector `kcc_block`:496 /528 B. The host592 B observation is a different build, not an estimate used here.
- Material evaluation body:528 /416 B; material batch:544 /560 B.
- Control batch:304 /304 B.
- Conditional branch-radiance batch:240 /240 B.

No heuristic far site was reported. Manual prologue/body review and complete disassembly are retained, but the scanner limitations remain: zero is not proof of no far/derived access or a stack-safety gate. These own frames exclude nested library/helper frames, register-window exception space, task/interrupt stacks and dynamic paths.

The O2 choice is not uniformly cheaper. At Q20, material instruction bytes rise from6712 to15641; connector text plus literals rise from2759 to3913. Connector own frame rises496 to528, while the material evaluation body's own frame decreases. Material retains two static unsigned64 division helper sites and one remainder site. The connector has one division and one remainder helper site at Os, five of each at O2 because code layout/inlining changes. Static site multiplicity is not dynamic call count. No automatic PIE `ee.*` arithmetic instruction was observed in these objects. No cycles, FPS, cache-miss rate, or speedup follows from these facts.

The safe next use of frame_lint is as one diagnostic beside exact `.su`, entry, disassembly, code-size and unresolved-call evidence. It does not justify replacing the current warning policy or integrating a branch's baseline into this independent experiment. Final linked-layout and measured performance remain future separate work.

## Formatting equivalence and preservation

`format-only-host/` reruns the unchanged full oracle corpus, all six sanitizer builds, width1/2/4/8 and rejection/atomicity checks. Results, admissions, examples and all three standalone host libraries match the frozen originals byte-for-byte. Additional strict misleading-indentation syntax checks pass without suppression.

The target derivative's `compact.c` differs from the tested host derivative only by leading spaces on the two new lines. Both literal transformations were independently verified against the original and their non-whitespace sequences are equal (`format-only-host-target-proof.json`). The target header is byte-identical to the tested host derivative. All six target preprocessing comparisons preserve the original non-whitespace sequence under their actual configuration. This is formatting/host-equivalence evidence, not target execution.

Target evidence is privately saved as `libfile_ef77b6a51ff481919ac2dc12d1565ec9`, version1, file `file_00000000af6c81f593a2c33c3f73175e`, 2,414,183 bytes, SHA256 `be7a49561c39f9b6229956cad5f6dbb620ef24f5f1709b60f925838a787287d7`. Readback ZIP hash/CRC, original-entry preservation and both payload manifests pass. See `target-evidence-original/` and `target-evidence-formatted/` for the verified artifacts.
