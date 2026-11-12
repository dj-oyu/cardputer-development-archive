# Physical lighting module validation

Scope: standalone three-DISK direct Lambert module only. No claim that this
matches Blender's complete material/light transport/display pipeline or that
synthetic tests establish image quality. Source `.c/.h` were frozen for the parent
integration after the initial successful checks; subsequent changes were test and
documentation additions only. Exact hashes are in `source-sha256.txt`.

## Completed checks

- Strict C11 build, `-O2 -Wall -Wextra -Wpedantic -Werror`: PASS.
- C synthetic suite: 40,082 checks PASS, including 10,000 deterministic valid
  receiver/material inputs with finite/nonnegative output checks.
- ASan + UBSan: same 40,082 checks PASS, no findings with leak detection disabled.
  Initial LeakSanitizer attempt could not execute under this environment's ptrace
  instrumentation. Leak detection is **not claimed passed**. The module performs
  zero allocations.
- Analytic on-axis formula, fixed16 versus generated16, energy linearity, spectral
  color, material reflectance, three-light addition, world exactly once, source
  backside, receiver backside, fixed-power size change, distance change, and
  explicit local-minus-Z source orientation: PASS.
- Unsupported shape, nonfinite or negative input, zero power/size/normal, invalid
  prepared scene, out-of-range diagnostic quadrature, whole-disk near endpoint,
  geometry overflow, and radiometric overflow rejection with unchanged output:
  PASS.
- Independent Gauss-Legendre/azimuth integration: PASS. No Blender or image inputs.

## Numerical accuracy, not an admission guarantee

R=1, h=2, P=1, rho=1, color=(1,1,1):

- Analytic: 0.020264236728467559.
- Fixed16: 0.020200333749586654, relative error **-0.31534856%**.
- Diagnostic64: relative error **-0.0792780%**.
- Diagnostic262144: relative error **-0.0000194%**.

Selected synthetic holdouts (errors relative to independent integration):

| Case | Fixed16 | Diagnostic64 | Diagnostic262144 |
|---|---:|---:|---:|
| On-axis h/R=1 | -3.34694% | -0.890413% | -0.0002225% |
| Near disk h/R=.25 | **-60.9704%** | **-38.7030%** | -0.0345324% |
| On-axis h/R=10 | -0.0006188% | -0.0001547% | less than 0.0000001% |
| Off-axis x=.9,y=.3,h=2,R=1 | -0.0012665% | -0.0002545% | about -0.0000001% |
| Receiver tilt60,h=2,R=1 | -0.315349% | -0.0792780% | -0.0000194% |
| Receiver grazing85,h=2,R=1 | +2.55292% | +0.299461% | +0.0000140% |
| Source tilt45,h=2,R=1 | +0.159423% | +0.0433118% | +0.0000106% |
| Source general Euler,offset,receiver tilt | +0.127883% | +0.0311791% | +0.0000076% |
| Source/receiver backside | exact zero | exact zero | exact zero |

The hardest h/R=.25 case improves to **-0.00864193%** at 1,048,576 points/light.
This deliberately retained stress case shows the fixed16 midpoint rule is poor
close to an extended source. The 64-point diagnostic is not an accurate universal
oracle either. Increasing only angular samples cannot repair insufficient radial
resolution there. No sample count/rule was optimized against reference pixels.

The selected nonzero h/R>=2 synthetic cases span roughly -0.315% to +2.553% at16;
this is a finite test set, not a bound across arbitrary normals/positions/lights.
For the parent model audit, measure perpendicular plane distance/radius and
projected distance to the disk as well as center distance/radius. A large center
distance can conceal a receiver close to a tilted source plane.

## Exact storage and work on this host

Compiler: Debian GCC 14.2.0-19, x86-64, double=8 bytes.

- `sizeof(FoxDiskLightInput)` = 96 bytes, including enum alignment padding.
- `sizeof(FoxDiskLight)` = 128 bytes.
- `sizeof(FoxDiskScene)` = **408 bytes** for all three lights + world RGB.
- Static fixed quadrature sample payload = **256 bytes**.
- Heap allocation and mutable global/BSS state = **0 bytes**.
- Fixed16 evaluation = **48 sample kernels/receiver**.
- Diagnostic64 evaluation = **192 sample kernels/receiver**.
- Each kernel performs one geometric distance (`hypot(hypot(x,y),z)`), receiver
  and source cosine, inverse-square, and scalar accumulation. Three scene frames
  and whole-disk endpoint distances are validated/evaluated each receiver call.
- Fixed16 uses no per-sample trig. Scene init performs 6 trig functions/light.
  Generic diagnostics generate samples with sqrt/cos/sin per sample.
- GCC `size` for the O2 module object: text/rodata **5,460 bytes**, data0, bss0.
  This includes the module object only, not linked libm or parent integration.
- GCC stack-usage records: init560 bytes; internal eval352 bytes; public eval
  wrapper32 bytes; scene validation8 bytes. These are per-function compiler
  records, **not a measured total stack peak**, and exclude library internals.

No host/device speed equivalence, device timing, shadow rays, visibility query,
geometry change, publication, or full-PBR claim is made.
