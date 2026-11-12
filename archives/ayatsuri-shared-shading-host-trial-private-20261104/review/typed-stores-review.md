# Independent typed-store review

2026-11-04. Scope: frozen `candidate-bounded` versus `candidate-typed-stores`, new production comparisons, and new pair-store tests/code generation as available. No product source or supplied test was edited. No assets/images, device operation, installation, or public write was performed.

## Source verdict

No new source-level correctness blocker found for the supported layout, valid typed/allocated storage, and documented strict floating-point configuration. This is not target numerical/performance acceptance.

Independent recursive comparison finds exactly two changed blocks in `main/ayatsuri/ayatsuri_model.c`, at lines 513–515 and 522–524. All other 11 product files, including the entire shade header, are byte-identical to bounded. Candidate model SHA-256: `fb2595f220e47c02efc684fcd0ad4ba0da146eba99fd182e5aa25557eafa752c`. The variant replaces a two-element temporary plus four-byte copy with two scalar temporaries followed by declared-field/uint16-element assignments.

### Arithmetic, order and failure

- Both color computations finish before either output store. Both inputs are read before output mutation; no interleaving of “calculate A, store A, calculate B” was introduced. The isolated new pair harness keeps an array temporary rather than the model's scalar temporaries, but likewise completes both calls before writing.
- There is no shader arithmetic change: normalization, dot/power conditions, channel expression order, clamp, `lroundf`, RGB565 packing, and signed-zero treatment remain in the byte-identical header.
- Front and back still prepare separate terms. Back SNORM still rounds the negated double component rather than negating an already-rounded front short. Thickness conversion and all failure checks stay in place.
- The old aggregate initializer did not promise textual A/B call order. The new scalar declarations do not affect the promised numeric output: calls read their inputs and return independent colors. Observed errno/FP-exception timing, trapping partway through arithmetic, or asynchronous partial-color observation is outside the established API guarantee. Neither spelling promises atomic pair publication.
- No validation, return, publication, counter, allocation, or slot-size operation changed. Later evaluation failures can still leave partial internal work while invalidating publication, exactly as before; exact failed arena-state evidence belongs to the production matrix.

### Type, alignment, bounds and representation

- Front stores use the declared `uint16_t color_a` and `color_b` members. Back stores use two elements of the existing `uint16_t *` color tail. There is no new cast to `uint32_t *`, packed access, restrict promise, or wider-alignment assumption.
- Independent host layout probe (`review/typed-stores/layout.c`, `layout.txt`) reports vertex size/alignment 16/4, patch size/alignment 1040/4, color offsets 12/14, patch vertex offset 8, and uint16 alignment 2. Existing packet-size assertions remain unchanged. Named-field assignments avoid the old front memcpy's adjacency assumption.
- Init requires an 8-byte-aligned arena; node slots are multiples of four and mesh tails are rounded to eight. Thus the existing work/patch addresses retain required four-byte alignment on the supported ABI, and the color tail retains two-byte alignment even after preceding 84-byte group slots. For `v < nv <= 32`, back writes fit within the allocated `4*nv` color bytes, before the eight face-bit bytes.
- Integer values are unchanged uint16 values. Assignment versus copying their native representation introduces no endian conversion. Existing endian validation and declared format layout still apply.
- The existing raw arena implementation already overlays node, float and patch types. This local review does not certify arbitrary caller-declared byte-array arenas as strict-ISO-C storage merely because they are aligned. Production tests use calloc-backed arena storage; the new uint16 writes do not introduce a new incompatible wider access. Sanitizer passes are not a general effective-type proof. This is a pre-existing API/storage-contract limit, not a newly discovered typed-store regression.

## Runtime and code-generation evidence

### New host production and alias evidence

Independently read `results/typed-stores/matrix.json`, compared every saved baseline/candidate BIN and TSV byte-for-byte, checked their recorded SHA-256 values and current product identities, and checked start/end identities. All eight new fixture pairs match: O0/O2 and ASan+UBSan O0/O2, each with mixed and mesh-only fixtures. Total: 676 recorded states and 604 full production raster frames. This includes full arena bytes, status/publication state, native packets, copied frames and production RGB565 pixels. Fixture binary hashes remain `fa6a02b2e4a33bd86721085734e4c83b708d431b6769c7df137e3b1a9f22f2cc` (mixed) and `8dd8a880c333d60da7c3c4784ab3a833cc9cef5f66170bef952c82fab2ec5ee1` (mesh-only). Independent check record: `review/typed-stores/verification.json`.

Read both new alias-test sources, the actual isolated pair source, all recorded commands, source/harness identities, and binary hashes in `results/typed-stores-alias/alias.json`. All four configurations pass. Independently reran the O2 executable: 87,336 inputs, 1,746,720 pair calls, 3,493,440 exact output checks and 24,454,080 nonoutput uint16 canary checks; digest `cb0a1d5fd3f72de5`, zero failures. Both implementations run in each count; it is not 1,746,720 calls per implementation. Half the calls use valid two-byte-but-not-four-byte-aligned outputs.

The test uses real declared uint16 arrays, no invalid cast. It tests identical input/output, partial overlaps in both directions, and disjoint layouts at both address parities. The immutable oracle computes both original albedos before mutation, so the crucial out=albedo+1 case can detect an early output store. Both actual compiled variants use SHARED=1, with only TYPED_STORES=0/1 different. The older repeated-shade branch is not the copy control. The oracle uses the unchanged bounded shader, appropriate for isolating a store change; this is not independent rederivation of the shading formula. All RGB565 albedos appear in each input slot, plus extreme directions, signed zero, 20,000 deterministic random cases and 27 asymmetric SNORM ties.

LSan is explicitly disabled, ASan/UBSan pass, and m32 remains not run due to unavailable multilib headers. No leak or 32-bit-host pass is claimed.

### Host code generation

Independently ran GNU size on all four new objects and read `.su` and disassembly. Fresh bounded `.text` byte-matches the previous host object. Model text-class total is 28,668 bytes in both variants; data/BSS stay zero. Mesh local frame increases 1,504 → 1,520 bytes. Pair text-class grows 1,322 → 1,330 bytes; pair local frame stays 96. Local frames are not whole-call-chain peaks.

With the host build's normal builtin-copy optimization, bounded pair emits one 32-bit destination store at object offset 0x3e3. Typed pair emits two 16-bit destination stores at 0x3e1/0x3e5 after its second color call. Thus this spelling does not reduce host destination-store count. Host object compile flags are not the S3 firmware flags: alias tests explicitly disable builtin memcpy, whereas host static assembly permits it. No target claim follows from the host sequence, and no host speed improvement is established.

### New ESP32-S3 object evidence

Independent verifier: `review/typed-stores/verify_target.py`; concise record: `review/typed-stores/target-verification.json`. All 93 manifest entries match size/SHA-256. All 24 archived product files and the pair harness match the local frozen inputs. All four new objects are little-endian ELF32 Xtensa. Independently parsed ELF section/symbol/RELA tables, verified 25,428 displayed instruction encodings against actual section bytes, and matched every saved ASM_EXPAND call annotation against actual relocations. This checks the supplied disassembly against ELF data, not an independent re-disassembly by host tools.

The fresh control's allocated section bytes and symbol-resolved code/literal/rodata relocations exactly match both its bundled previous-bounded reference and the previously reviewed local bounded target objects. Whole-object hashes differ because debug metadata/path information differs. Thus this is a controlled comparison to the existing bounded implementation, not the older repeated-shade baseline.

Independently reconstructed the preserved original firmware command prefix and compared all four command arrays; shell strings parse back to their arrays, all exit codes are zero, and current objects match build metadata. The actual command retains GNU23, final O2, contraction off, longcalls, picolibc specs, and disabled memcpy builtins. Recorded response contents hash correctly. The complete SDK/toolchain/specs/configuration dependency closure is still not bundled, so this is not a stand-alone replayable environment.

Static target results (control → typed):

- Model text-class 36,896 → 36,788 bytes (−108), mesh section 7,234 → 7,134 (−100), writable static data/BSS zero in both.
- Pair text-class 974 → 953 (−21), pair section 495 → 478 (−17).
- Mesh local frame remains 1,424, pair 80, evaluator 1,072, terms helper 80, and color helper 64. These `.su` values agree with the displayed ENTRY instructions whose bytes were verified.
- Model mesh memcpy sites fall from 13 to 11, while four color-helper and two terms-helper sites remain. Pair memcpy sites fall from one to zero. Existing decoder copies remain untouched.

Actual final destination stores, all after the second color computation:

- **Front model fields:** GCC packs the two values and emits one aligned `s32i.n` at mesh+0x10d8, vertex+12. This wider instruction is the compiler's valid lowering of two typed fields, not source-level uint32 type punning.
- **Back model colors:** two `s16i`, at mesh+0x132e (B, +2) and +0x1331 (A, +0). The optimizer reverses their machine order; neither spelling guarantees atomic pair publication or concurrent observation order.
- **Isolated pair:** output pointer loaded from incoming SP+80, then two `s16i` at pair+0x15e/+0x161 (+0/+2). Only uint16 alignment is required; no forced unaligned 32-bit store appears.

Read the final reload RTL as well as assembly. Typed pair keeps color A in a7 through its second color call; front model keeps it in a7 for packing, back model in a6. The typed pair no longer needs an addressable colors array. Around the pair's first color call, control preserves thin/back/spec in `%sfp` slots +32/+36/+40; typed preserves thin/spec in +16/+20 while front/back remain in caller registers a4/a2. These are actual scalar preservation sites, distinct from outgoing thin at SP+0 and incoming output pointer at SP+80, which are ABI argument slots. Other normalization temporaries and model spills still exist. Removal of a local array does not imply all stack traffic vanishes, and unchanged local frame size does not imply lower peak stack.

Relative to the prior repeated-shade baseline, the known mesh → terms-helper sum remains 1,424+80=1,504 bytes versus 1,424+64=1,488 (+16). Helpers run sequentially and should not all be added together. This remains a selected call-chain sum, excluding external math, register-window and interrupt costs, not a total peak estimate.

### Disposition and remaining limits

The typed spelling removes the specific external final-color copy calls under actual S3 firmware flags and reduces target object text without growing those target local frames. It preserves the new host packet/raster/overlap checks. No source or object-evidence blocker was found. It is a stronger static S3 candidate than bounded-copy, but **not a demonstrated target runtime speedup or release approval**. Host mesh stack grows 16 bytes, so the result is architecture-specific.

Target numerical execution, linked firmware/relaxation, actual cycles/FPS, full peak stack, register-window overflow and hardware behavior remain unmeasured. No device operation, product adoption, source mutation, installation, or publication was performed by this review. No denied operation was retried or bypassed.
