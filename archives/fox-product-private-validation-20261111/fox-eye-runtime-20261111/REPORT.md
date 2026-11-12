# Compact source-exact eye runtime

Private implementation only. No source Blender save, repository changes, upload, hardware access, or QEMU run was performed here.

## Result

- `eye_runtime.h` / `eye_runtime.c` replace thirteen full pose arrays with one immutable neutral basis and 32 sparse eyelid deltas generated in `eye_geometry.inc`.
- All 13 prior fixtures and 52 fresh Blender evaluated oracle samples match runtime geometry exactly on the tested host (maximum error 0 metres). Samples cover intermediate, independent left/right, combined controls, gaze/style/highlights/reflection/bubble, pause and reversal.
- Only global vertices 909–924 and 929–944 move. The other 1,290 vertices, all 74 matrices, 1,982 triangle indices and material slots remain exact. Topology includes the neutral degenerate eyelid triangles; nothing is discarded.
- Visibility at max(both, side) >= .98 affects object IDs 35/37/50 and 36/38/51. All oracle visibility flags match.
- Source base color and alpha use the same accepted snapshot controls. Non-eye global material IDs map to exact source RGB constants by material name.
- Original immutable source SHA256 remains `384ada0c37da16d625b1e6612a0d2f7ca538c29fe0d8dff43a929841ec63fba8`. Oracle uses `open_mainfile(use_scripts=False)` and no save, with factory startup and disabled autoexecution.

## Integration

Link `eye_runtime.c` and `-lm`. Existing contract headers are relative includes. `fox_eye_snapshot_build(dst, controls)` validates finite values and source UI ranges before touching destination. Eye style must be integer 0/1/2; highlights must be 0/1. No clamping or silent repair. Null or invalid controls return false with unchanged destination. `&dst->controls` is supported.

Each immutable `fox_eye_snapshot` contains accepted `FoxEyeControls`, local[1322][3], hidden[74]. Pass the same snapshot.local to prepare, preflight, and every band. The fragment callback first returns alpha zero for snapshot.hidden[object], otherwise uses `fox_eye_snapshot_surface(snapshot, global_material, local_x, local_y, local_z, rgb, alpha)`.

The builder is not a concurrent publication primitive. Build an unpublished snapshot, publish with caller synchronization, and retain it until all frame operations/callbacks have retired. Never build into the currently consumed snapshot. Two caller-owned slots are sufficient only with an enforced frame-retirement handoff; blindly toggling slots is unsafe. No hidden mutable state, allocation, or accumulation exists in this runtime.

Supported scope is the nine eye controls only. Smile, brow and head shape controls remain neutral here; the existing independent renderer body/head rig still applies. This is source Base Color/alpha, not a physical BSDF/reflection renderer.

## Memory and tests

Cold geometry plus indices/masks: 16,330 bytes, versus 206,232 bytes for old thirteen geometry arrays (92.1% smaller). Source non-eye RGB constants add 144 bytes. One snapshot is 15,976 bytes on the tested host, no heap required.

- `validation.json`: 13 fixture + 52 fresh oracle cases; exact topology/material/matrix/visibility; 47 bad-input rollback cases; repeated forward/reverse/alias and recovery determinism.
- `test-o2.log`, `test-san.log`: 1,001 native update/repeat/alias/invalid rollback/recovery cases, all material callback smoke checks; O2 and AddressSanitizer/UndefinedBehaviorSanitizer passed.
- `oracle.json`, `oracle.py`, `oracle.log`: fresh Blender evidence and source Basis/Blink keys.
- `generate.py`: reproducibly generates sparse data from immutable verified inputs.
- `validate.py`: ctypes validation against both evaluated oracles. Rebuild runtime.so with `cc -std=c11 -O2 -fPIC -shared eye_runtime.c -lm -o runtime.so` before running.

This component report does not claim QEMU or QuickJS integration by itself; see the later composed validation for completed integration results.

## Precision boundary follow-up

`boundary-oracle.json` records 42 fresh live Blender evaluations: 14 double/float32-neighbor values around .98 and .02, applied to both, negative-side and positive-side controls. All 84 side visibility checks and shader driver float32 values match the accepted runtime snapshot. Although Blender retains the custom property's double value, `.97999999` and `.979999999` already cause source hide_render=true and shader Blink=.9800000190734863. The float32 predecessor .9799999594688416 stays visible. There is no precision boundary mismatch and no need for a separate double-based visibility threshold.

168 runtime alpha comparisons against the source float32 node interpreter also match exactly, using the freshly observed live shader Blink values. Outside-eye alpha at float32(.02) is zero; at the preceding float32 value .019999997690320015 it is 1.1920928955078125e-7, exactly matching the source node arithmetic. These alpha checks are source-node interpretation, not rendered GPU alpha measurements. Bridge validation should reject invalid doubles before narrowing, then use the runtime float32 snapshot. Original source SHA remains unchanged. Details: `boundary-validation.json`, `probe_boundary.py`, `validate_boundary.py`.
