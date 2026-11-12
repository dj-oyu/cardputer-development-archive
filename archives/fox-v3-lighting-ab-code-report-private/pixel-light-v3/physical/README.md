# Isolated three-DISK direct Lambert experiment

This directory owns only a host C lighting module and synthetic tests. It does not
modify the frozen reference, product, model, camera, foreground, scoring, renderer,
or original Blender file. It does not read images or call Blender. It is not a
full PBR, Cycles, AgX, visibility, shadow, or GI implementation.

## API and integration

Include `fox_disk_lighting.h`, compile `fox_disk_lighting.c`, link `-lm`.

```c
FoxDiskLightInput inputs[FOX_DISK_LIGHT_COUNT]; /* exactly three source lights */
FoxDiskScene owned_scene;
FoxDiskStatus status = fox_disk_scene_init(
    &owned_scene, inputs, world_linear_rgb, world_strength);
/* Check status before publishing/storing the scene. Keep it immutable. */
status = fox_disk_eval16(&owned_scene, position_blender_world,
    normal_blender_world, rho, linear_hdr_out);
/* Check status; only FOX_DISK_OK writes linear_hdr_out. */
```

`FoxDiskLightInput` contains shape, center, Euler XYZ rotation, RGB color, total
power, and diameter. Set shape to `FOX_DISK_SHAPE_DISK` only after the source shape
has been verified as `DISK`; map/reject unknown source strings at the caller.
Shape values other than DISK are rejected, not silently approximated. Each input
must have finite center and rotation, finite positive power/diameter, and finite
nonnegative color. Zero color channels are admitted, including an all-black light.
World RGB and strength must be finite/nonnegative. This module has no config-file
loader: the caller extracts source settings once and owns the resulting scene.
Nothing here guesses source size/color/world RGB values omitted from old settings.

The result is unclipped linear HDR RGB. `rho` is an RGB scalar field supplied by
the caller, with every component finite in [0,1]. Physical meaning requires linear
material reflectance. Passing encoded RGB is permitted numerically but is a
nonphysical factor-isolation diagnostic. The module does not encode/decode RGB,
tone map, RGB565-pack, apply exposure, or multiply by the legacy artist gain .65.
The caller does not multiply the result by diffuse gain or world strength again.

## Coordinates and source orientation

Everything in the API is in Blender world units, not native scale-38 coordinates.
Given native positions `38 B(p)` with `B(x,y,z)=(x,-z,-y)`, the caller recovers
`p=(native_x,-native_z,-native_y)/38`. Authored normals transformed by B recover
with `n=(native_nx,-native_nz,-native_ny)`; normalization occurs inside evaluation.
A normal computed from transformed triangle edges needs its separate winding
convention handled by the caller, because det(B)=-1.

Euler XYZ is implemented as `Rz(z) Ry(y) Rx(x)`. Disk tangents are `R*(1,0,0)` and
`R*(0,1,0)`, and emitted normal is explicitly `R*(0,0,-1)`. The emitting normal is
never inferred from a transformed tangent cross product. Disk diameter is the
source AREA size; radius=diameter/2. Source and receiver are both one-sided for
the direct-light dot products.

## Fixed radiometric mapping

For source area `A=pi radius^2`, power P, linear source color C, and diffuse
reflectance rho:

- Source emitted radiance: `Le = C P / (pi A)`.
- Receiver Lambert BRDF: `rho/pi`.
- Direct outgoing radiance: `rho C P / pi^2 * mean_area(cosSource cosReceiver / distance^2)`.
- Uniform world outgoing radiance: `rho worldRGB worldStrength`, exactly once.

The source area cancels against equal-area integration weights. Radius still
changes sample positions, solid angle, and irradiance; fixed total power does not
mean fixed source radiance. The source power is used once. There is no constant
650 gain, scene-specific calibration, image fitting, learned LUT, or oracle input.
If the original key power is 650, that supplied source value is used as P.

For an on-axis receiver at height h, facing a disk of radius R, the analytic
outgoing radiance is `rho C P/[pi^2 (h^2+R^2)]`. The tests use this independently of
the implementation and also integrate synthetic tilted/off-axis cases separately.

## Deterministic quadrature

For m equal-area radial bands and 4m azimuths per band, samples are:

- `radius_fraction = sqrt((ring+0.5)/m)` for ring=0..m-1.
- `phi = 2 pi (azimuth+0.5*(ring mod 2))/(4m)` for azimuth=0..4m-1.
- Disk coordinates `(u,v)=radius_fraction*(cos(phi),sin(phi))`.
- Every point has area-average weight `1/(4m^2)`.

The fixed production call uses m=2, 16 samples/light, with the 16 two-dimensional
points stored as a 256-byte constant table. Diagnostic m=4 gives 64/light.
`fox_disk_eval_diagnostic` supports m=1..512 and generates points arithmetically.
The fixed16 and diagnostic m=2 paths agree within floating-point roundoff.
No sample positions, counts, or weights depend on image metrics.

## Atomic failure and numerical policy

Initialization and evaluation use private temporary results and commit output
only on success. Every successful RGB output is finite/nonnegative. Invalid
arguments, unsupported shapes, nonfinite inputs, zero normals, out-of-range rho,
and invalid prepared scenes fail explicitly. All public evaluation calls validate
the prepared scene as well as the receiver. Normal normalization is scale-safe,
including very small and very large finite magnitudes.

A receiver within **1e-9 Blender units of any complete disk surface** is rejected
with `FOX_DISK_NEAR_ENDPOINT`. The test is distance to the whole geometric disk,
not only the quadrature samples. This applies to dark/back-facing disks too,
before contribution culling. A near-zero sample distance is also rejected.
There is no silent distance clamp or epsilon energy injection. Finite extreme
inputs that overflow intermediate geometry/radiometry return
`FOX_DISK_NUMERIC_RANGE`; output remains byte-for-byte unchanged. Benign
underflow can yield zero. These are conservative admission rules, not support
for every representable geometry or an extension across coincident surfaces.

## Build and test

```sh
cd fox-v3-lighting-ab/physical
./run_tests.sh
cc -std=c11 -O1 -g -Wall -Wextra -Wpedantic -Werror \
  -fsanitize=address,undefined -fno-omit-frame-pointer \
  fox_disk_lighting.c test_disk_lighting.c -lm -o test_disk_lighting_sanitized
ASAN_OPTIONS=detect_leaks=0 ./test_disk_lighting_sanitized
```

The convergence test requires Python3 and NumPy. It compares against an independent
256-point Gauss-Legendre integration in squared radius and 2048 azimuth samples,
checked against a 128x1024 rule. It uses synthetic geometry only. See `REPORT.md`,
`synthetic-report.json`, and `convergence-report.json` for exact evidence and limits.
