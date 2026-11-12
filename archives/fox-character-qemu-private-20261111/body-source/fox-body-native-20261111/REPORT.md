# Private fox body native rendering slice

This is **body-only actual native renderer output**, not a full fox, full firmware, QuickJS/Hone scene, or physical LCD result. No original asset was edited, no device was used, and no private assets were published.

## Input and implementation

The immutable diagnostic `fox-cardputer-2k-v2.blend` SHA256 is `384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8`. This 1,982-triangle derivative is not the full original `fox-bubble-bold` source. This slice draws only its smooth `Anatomy • continuous nape and shoulder sculpt` mesh: 229 unique vertices and 454 triangles, two source material slots. The source triangle order and per-face material assignments remain, with 23 bounded partitions and 701 scattered vertices. No reduction or welding occurred.

Existing source-local rigid DQ and all-smooth angle-weighted normal reconstruction are reused. Normals are recomputed over the original 229-vertex connectivity **before** partition/scatter. The source rest/pose matrices and U16 quantization preserve the earlier verified adapter contract. No LBS fallback exists.

Blender Z-up coordinates are explicitly mapped to renderer coordinates `(x, -z, -y)`. This basis reverses handedness, so cold triangle winding is reversed exactly once. Both cold and evaluated vertices/normals use the same map. The original mesh world translation is similarly mapped and applied once at the root. Initial diagnostic camera/basis attempts were visually rejected before the final capture; only final `O2`/`asan` outputs are acceptance evidence.

Actual call path: DQ -> reconstructed normals -> `ayatsuri_model_instance_evaluate_meshes` -> `ksn_mesh_append` -> frame-owned compact packets -> production `ksn_mesh_render`, one row at a time. Production native sources are pinned to repository `828baa3af69c55e7884c53557ea39f91190010a0`; the two generic provisional DQ/normal headers are separately hashed in `source-manifest.json`. No production source changed. This does not exercise the higher Kasane compositor or JS bridge.

## Visual contract and comparison

Two orthographic cameras, 240×135 RGB565, explicit ambient/diffuse diagnostic lighting. Both source material slots use their recorded viewport diffuse colors, converted to sRGB/RGB565, not a claimed Principled shader recreation. The native single-sided mesh contract is retained; the source material's double-sided/PBR behavior is not fully transported. No eye, face, eyebrow, morph, transparency or full-character fidelity is claimed.

For each of two views, all 64 source poses were rendered, replayed in reverse and paused/repeated. 128 DQ images were compared against the **same production renderer** driven by Blender evaluated position/corner-normal inputs. This isolates geometry/shading input differences; it is not an independent raster oracle or a Blender beauty render comparison.

Final O2 and ASan/UBSan both passed. All 256 saved RGB565 files (128 candidate + 128 oracle) are byte-identical between O2 and sanitizer builds. Final O2: 126 of 128 images are byte-identical. Two images each have one differing pixel (total 2 of 4,147,200 pixel comparisons), with RGB565 channel step differences recorded in `pixel-differences.json`. No pixel tolerance is claimed as artistic acceptance. Reverse 128 and pause 2 comparisons are hash exact.

A late NaN in the last geometry entry rejects transactionally: the actor and arena are byte unchanged, ready packets remain accessible, the retained snapshot re-renders to its previous hash, and the next valid update succeeds. Source geometry is overwritten after packet append, then the real rasterizer draws only the snapshot. This tests the synchronous copy boundary, not asynchronous DMA lifetime.

`body-native-contact.png` and six `body-v*-p*.png` files were decoded directly from actual RGB565 output and visually inspected, without repainting. They show upright front/oblique body surfaces with the head/body deformation. This body lacks all facial and accessory meshes by design.

## Memory (64-bit host layout, not target heap)

- Cold AYNM: 25,032 B, const.
- Native actor arena: 34,996 B plus 7 alignment bytes, one explicit allocation, disposed/freed at shutdown.
- Mutable skin result 5,496 B; unique positions 2,748 B; unique normals 2,748 B; normal scratch 5,496 B.
- Partition-scatter results: 16,824 B; geometry descriptors: 368 B.
- Snapshot capacity: 32,768 B; measured maximum used: 9,544 B.
- One output row: 480 B; depth row: 960 B.
- Const skin input: 9,160 B; 64 pose palettes: 6,144 B; topology: 5,448 B, plus maps/counts/inverse binds.
- Listed mutable buffers total 67,888 B plus arena and model/actor bookkeeping, palette stack, runtime/library overhead. Host-only oracle and two 64,800-byte comparison panels are excluded from TARGET_BODY builds. No total firmware fit, target alloc-free claim, or FPS conclusion follows.

## Reproduction

Run `python generate.py`, `node pack.cjs`, then `python build_run.py` and `python build_run.py --sanitize` from this private directory (scripts resolve sibling inputs). Run `python preview.py` for the raw-output contact sheet. Commands are persisted per build. LeakSanitizer is explicitly disabled due to the executor environment; ASan/UBSan results do not constitute a leak-check pass. No general allocation ledger is instrumented.

The target adapter uses `TARGET_BODY`, `body_init`, `body_frame`, `body_shutdown`, and an external `body_row` callback. `oracle.h` and host main are excluded. The parent owns separate QEMU evidence and limited target pose selection. Do not infer QEMU completion from this host report.
