# Independent S3 code-generation review

2026-11-04. Scope: read-only review of `target-evidence`, supplementing `shared-shading-review.md`. No target recompilation/execution, installation, device access, source changes, firmware link, or network publication occurred.

## Verdict and limits

**The supplied objects support the reported S3 code-generation findings.** Bounded avoids most ordinary-candidate code growth and restores the baseline **local mesh frame**, but does not establish unchanged peak stack or improved speed.

Two important qualifications are confirmed:

- Both shared variants retain external four-byte `memcpy` calls for final color pairs. There is **no generated single 32-bit final destination store** in these objects.
- Baseline mesh → sample compiler frames total **1,424 + 64 = 1,488 bytes**. Bounded mesh → terms preparation totals **1,424 + 80 = 1,504 bytes**, a known **+16-byte nested-frame sum** before external math/window effects. Bounded mesh → color helper is 1,424 + 64. The two bounded helpers run sequentially; do not sum both together. These are particular call chains, **not whole-program peak measurements**.

Target numerical execution, linked layout/relaxation, cycles, maximum stack, register-window overflow and interrupt effects remain unmeasured. Missing target-object evidence is no longer a blocker; numerical/runtime adoption evidence remains open. No integrity or code-generation evidence blocker was found.

## Independent checks

- All **140 MANIFEST entries** match file length and SHA-256. The only unlisted file is MANIFEST itself. Rechecked after review; unchanged.
- All **36 archived product files** match the three local frozen trees byte-for-byte. Archived `shade_pair.c` also matches the local host-analysis harness; SHA-256 `8ba2c1e41904cc1302a2994674efd22a8dfe6d92962533d8665fae50ab781862`.
- All six object hashes/lengths and `.su` contents match `build-metadata.json`.
- Host `readelf` independently identifies actual **ELF32 little-endian Xtensa relocatable objects**. `.comment` corroborates GCC `(crosstool-NG esp-15.2.0_20251204) 15.2.0`.
- Independently parsed section tables and symbol-resolved RELA records. Every saved `.text` ASM_EXPAND call annotation matches actual ELF relocations.
- **38,614 displayed `.text` instruction encodings** match actual ELF section bytes with zero mismatches. ENTRY frame immediates also match encoded fields across all 73 functions. This verifies saved disassembly bytes, not a claim that host tools regenerated Xtensa disassembly.
- Candidate and bounded pair objects have identical allocated section bytes **and symbol-resolved code/literal/rodata relocations**. Whole object hashes differ because metadata differs.

The parent verified ZIP SHA-256 `dbbd584e0be6133e8378bd34cd9fdb9618ab8615953f06b6051d14679960e312`. This review independently verified extracted files, not the parent transfer or ZIP bytes.

## Commands and configuration

All six recorded compile exit codes are zero; compile logs are empty. Each recorded shell command parses back to its argv. Independently reconstructing substitutions from the saved original compile-command row reproduces the preserved argv prefix for all six commands: variant main include roots/source/output/dependency paths change, diagnostics are added, and the pair receives SHARED=0/1.

The original option order retains **-Os followed later by -O2**, `-std=gnu23`, `-ffp-contract=off`, target options and the response-file reference. Embedded response contents hash correctly to `847551aa2ebe5c24d6320c5cd0f18b090bab7461f3dff954fec167e34ea92cbe` and retain `-mlongcalls`, `-fno-builtin-memcpy`, `-fno-builtin-memset`, `-fno-builtin-bzero`, and the original picolibc specs path.

The specs file hash is recorded (`abf36c1f57d16d1244ee064ca9ec82180a167fac34c3dbc281ba470703a556fc`), but its contents, compiler/SDK binaries and complete configuration are not bundled. This is a command/evidence record, **not a complete independently replayable toolchain closure**. No local recompile was attempted. GNU C23/GCC15 target codegen also does not transfer the C11/GCC14 host numerical verdict to target libm execution.

## Actual object sizes and local frames

Host GNU `size`, independent section parsing, `.su` and ENTRY encodings agree. Bytes:

| Metric | Baseline | Candidate | Bounded |
| --- | ---: | ---: | ---: |
| Model size text-class total | 36,790 | 38,179 | 36,896 |
| Model aggregate `.text.*` | 32,669 | 34,022 | 32,755 |
| Model aggregate `.literal.*` | 4,064 | 4,100 | 4,084 |
| Other allocated read-only bytes | 57 | 57 | 57 |
| Model data/BSS | 0/0 | 0/0 | 0/0 |
| `.text.mesh_packet` | 7,170 | 8,868 | 7,234 |
| Mesh local frame | 1,424 | 1,472 | 1,424 |
| Evaluator local frame | 1,072 | 1,072 | 1,072 |
| Sample helper frame | 64 | absent | absent |
| Terms helper frame | absent | 80 | 80 |
| Color helper frame in model | absent | inlined | 64 |
| Pair text-class total | 942 | 974 | 974 |
| Pair caller frame | 48 | 80 | 80 |
| Pair color/sample helper frame | 64 | 64 | 64 |

Ordinary candidate adds **1,389 text-class bytes and 48 local mesh-frame bytes**; bounded adds **106 text-class bytes and zero local mesh-frame bytes**. Actual model `.text.*` deltas are +1,353/+86; remaining growth is literals. These are isolated objects, not final linked flash/RAM totals.

The small pair TU already outlines ordinary candidate's color helper despite source `inline`, so its identical candidate/bounded code cannot establish the benefit of `noinline` in the large model TU. Its caller-plus-helper frames are 48+64=112 baseline versus 80+64=144 shared, excluding external callees.

## Reuse survives target compilation

Actual relocations show:

- Baseline pair calls sample twice; sample has one normal sqrtf site, one conditional powf site, six normalization divide-helper sites and three lroundf sites.
- Shared pair has one such normal computation, two calls to the three-lroundf color helper, and one final memcpy.
- Baseline mesh has four sample call sites. Ordinary candidate has two terms-helper sites and twelve inlined lroundf sites. Bounded has two terms-helper and four color-helper sites.

These are **static conditional sites**, not execution/cycle counts. Unchanged basis preparation and transformed-normal work remain; do not say all mesh sqrt/divide work halves. Long-call expansion and external library implementations also require linked/runtime assessment.

## Exact attribution of added final-color memcpy calls

The mesh has 11 baseline versus 13 shared memcpy sites. DWARF/source-annotated disassembly, actual ELF relocations and final reload RTL all identify the two new sites:

| Variant | Front, model.c:515 | Back, model.c:524 |
| --- | --- | --- |
| Candidate | mesh+0x1452 | mesh+0x19ef |
| Bounded | mesh+0x1117 | mesh+0x1391 |

At each, **a12=4**, a11 addresses the local color array, and a10 is vertex+12 or the back-color destination, followed by `callx8`. Bounded ELF relocation pairs specifically map 0x1117 to literal+0x218 and 0x1391 to literal+0x244, both with ASM_EXPAND memcpy. Reload RTL names source lines 515/524 and argument uses. The other eleven existing four-byte decoder copies must not be attributed to the optimization.

Pair assembly is equally clear: baseline uses two `s16i` destination stores at +0/+2. Shared uses stack-local `s16i` at SP+16/+18, then a10=destination, a11=SP+16, a12=4 and external memcpy relocation at pair+0x16f (`callx8` at 0x172). Thus “paired C copy” is accurate; **single target store, atomic pair, or fewer physical stores is not established**. The unlinked memcpy implementation was not inspected or executed.

## ABI slots versus locals versus scalar preservation

Final reload RTL, not just provisional IRA diagnostics, distinguishes:

- **Arguments:** scalarized front/back/spec are passed in the register argument sequence. Thin is written to outgoing SP+0 and read by the 64-byte helper at incoming SP+64. Pair's seventh incoming argument, out, is loaded at SP+80. These are ABI argument slots, not allocator spill evidence.
- **Local source array:** SP+16/+18 are explicitly `colors[0]`/`colors[1]` in reload RTL, backing external memcpy.
- **Preservation across calls:** baseline preserves material pointer m at `%sfp+0` between sample calls. Shared pair preserves thin/back/spec at `%sfp+32/+36/+40` over its first color call and reloads them for the second. Those are actual scalar call-clobber/register-pressure save/reload sites.

SP+32/+36/+40 are reused earlier for normal components. Slot lifetimes matter; every SP access, debug variable location, or IRA “Spill” line must not be counted as an additional spill or dynamic memory operation. No total runtime spill count is claimed.

## Disposition

Bounded is the better **code-size/local-caller-frame** option among the two current shared candidates. It is not yet a demonstrated target speed win or peak-stack-neutral replacement. Persistent arena/heap/static writable storage remains unchanged, while transient call/stack traffic changes. No further variant was made or requested by this review. The earlier README issue was resolved by the parent's later update; it is not an open blocker here.
