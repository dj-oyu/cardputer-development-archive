# ESP32-S3 code-generation result

2026-11-04. Actual Xtensa object generation succeeded for three frozen variants and the isolated two-albedo kernel. This is static target-code evidence, not target numerical execution, cycles, linked-firmware performance or production acceptance.

## Integrity and build

The private S3 archive was downloaded through the official transfer helper. Its SHA256 is dbbd584e0be6133e8378bd34cd9fdb9618ab8615953f06b6051d14679960e312. All 140 manifest entries were read and verified. All 36 generic source files and shade_pair.c byte-match this experiment's frozen inputs. All six generated objects identify as Tensilica Xtensa ELF. Independent review also matched 38,614 displayed instruction encodings and all saved call-relocation annotations against actual ELF data. Object sizes were independently read using local readelf/size, not copied only from the report.

Toolchain: ESP-IDF 6.0.1, Xtensa GCC15.2.0 esp-15.2.0_20251204, objdump2.45. The actual firmware command retained -std=gnu23, final -O2, -ffp-contract=off, -mlongcalls, picolibc specs, and -fno-builtin-memcpy/memset/bzero. Only isolated input/include/output roots and diagnostic outputs changed. The archive includes source, exact command records and response-file contents, but not the entire SDK/toolchain/configuration dependency closure; it is not independently replayable without that environment. The original checkout remains clean; there was no install, configuration change, public push, CI injection or device operation.

## Results

| Static metric, bytes | Baseline | Shared/default inline | Shared/bounded color helper |
|---|---:|---:|---:|
| model size text-class, including literal/rodata | 36790 | 38179 | 36896 |
| mesh_packet text section | 7170 | 8868 | 7234 |
| mesh_packet individual .su frame | 1424 | 1472 | 1424 |
| evaluator individual .su frame | 1072 | 1072 | 1072 |
| pair-kernel size text-class | 942 | 974 | 974 |
| pair-kernel individual .su frame | 48 | 80 | 80 |

Every object's .data/.bss is zero. Persistent model/instance/arena layouts are unchanged. Helper frames still nest: the bounded model's terms helper is 80 bytes and color helper 64, versus the baseline sample helper 64. The known mesh-to-normal-helper frame sum is 1,424 + 80 = 1,504 bytes, compared with baseline 1,424 + 64 = 1,488, a 16-byte increase before libm/window effects. This is not a whole-call-chain or interrupt-aware peak-stack measurement. Equal mesh caller size does not establish stack neutrality.

Sharing removes duplicated normal-dependent work between color A/B. The emitted pair has one normal normalization/conditional powf path followed by two color helper calls, versus two complete sample calls. There are still sqrtf and __divsf3 helper calls; FPU availability does not make these whole normalized-shading operations one instruction. Their linked implementations and runtime cycle costs were not measured.

Default inlining expands channel arithmetic inside mesh_packet, increasing object text by1389 bytes and the caller frame by48. Outlining the color helper limits object growth to106 bytes and restores the caller's1424-byte frame. This makes bounded the better of these two static target candidates, not an adopted faster implementation.

## The bulk-store hypothesis did not carry over to S3

On host, the paired color copy became one32-bit store. Under actual S3 firmware flags it remains an external memcpy(destination, colors, 4) call. The pair first writes two16-bit values into its stack-local colors array, prepares destination/source/length arguments, then calls memcpy through a relocation. The model adds two such copy sites for front/back color pairs. Original decoder memcpy sites are separate and must not be credited to this change.

Therefore the current C formulation has not achieved minimal final-store traffic on the target. The smallest next experiment is two type-correct direct color assignments after both colors are computed, keeping all shading arithmetic unchanged. It should be tested as a separate variant rather than globally re-enabling compiler builtins or type-punning a uint32 store into uint16 fields. A wider store must respect alignment, effective type and supported format layout.

## Registers, ABI slots and actual preservation traffic

The S3 windowed-call convention moves argument registers across call windows; additional values also use outgoing stack slots. In this object, scalar-replaced front/back/spec terms use argument registers, while thin is an outgoing stack argument. Those ABI slots are not automatically spills. The addressable colors array is intentional local storage. Reload RTL separately marks preservation of thin/back/spec across the first color call, confirming actual call-clobber/register-pressure traffic. The baseline similarly preserves the material pointer between its two calls.

Naively counting stack accesses or C locals does not answer the register question. We now have concrete register/stack locations, helper boundaries and relocation evidence. Total peak stack and cycles still require linked-path/runtime evidence. No approximate formula, relaxed precision, FMA reassociation or assembly rewrite was adopted.

## Preserved evidence

Full target inputs, patches, compile arguments and response/spec hashes, objects, .su, section/relocation listings, disassembly and IRA/reload diagnostics are privately saved as:

- Library ID libfile_9f16ea3093748191bde8d831225b5255, file_00000000518481f7b8a637bbd5d86dba, version0.
- Filename ayatsuri-shared-shading-s3-objects-private-20261104.zip; 14,768,531 bytes.
- Local verification receipt: delivery/S3_EVIDENCE_VERIFIED.json.

The host source/verification archive is separate and excludes original assets, images and character geometry. Host exactness is established by the model/raster and shader stress matrices; S3 numerical runtime equality, actual cycles/FPS, final link relaxation and total stack remain unmeasured.
