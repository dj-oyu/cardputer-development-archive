# Fixed v3 world visibility / one-bounce host experiment

This records the contract agreed before image scoring. Formal reference, source, five scenarios, two views, stable/uncertain classification and thresholds are unchanged. No reference pixels or passes enter lighting. The prior owned direct visibility experiment is retained as OFF. This is a private host experiment, not a firmware implementation or default adoption.

## Three separate arms

- OFF: exact old visible DISK16 pixel direct lighting plus unoccluded colored world.
- WORLD_VISIBLE: same direct term, replacing the world term by cosine-weighted miss radiance only.
- ONE_BOUNCE: same world-visible term, plus rhoX times cosine-weighted mean of hit reflected radiance rhoY times (visible DISK16 irradiance/pi + visible uniform-world mean). No emission at hit, no ground, no higher bounce, no specular. Existing world is replaced, never added twice.

Source base colors travel through the existing linear-factor to sRGB565 encoding, then explicit decoding. Hit masks choose B when nonnegative, otherwise A; per-vertex selected linear rho is barycentrically interpolated. Front/back SNORM values remain independently quantized. Native reflection transform has determinant -1, hence physical front geometric normal is minus raw cross. Ng selects physical side; interpolated selected Ns is not face-forwarded. Ns dot outgoing <=0 returns zero reflection with an explicit counter, not world radiance. Invalid/zero/nonfinite interpolated Ns rejects.

## Sampling and ray contracts

Outer cosine hemisphere: 16 fixed samples (2 radial equal-area rings, 8 azimuths), secondary-world 16. The fixed fine diagnostic is outer64/inner16 for oblique baseline and direction. A separate first100 reflected secondary-world queries in forward oblique baseline compares inner16/64 without changing the rendered result. Neither subset nor coarse/fine agreement establishes global convergence. Analytic and dense synthetic fixtures precede actual scoring.

Nearest hit is used for transport, not any-hit. Ray far distance derives conservatively from the complete character BVH bounds. Equal-distance ties select original triangle ordinal. Origin/endpoint epsilon is 1e-5 Blender units along ray, once. No source-triangle exclusion. All original1166 faces, including back-facing/offscreen faces, are copied before model disposal. Ground is absent, explicitly unsupported.

## Ownership and bounded work

Geometry/pose/light and material tokens are caller-issued, not automatic content proofs. The synchronous adapter binds owned full geometry/attributes and copied prepared lights to the actual snapshot fingerprint. Later mutation requires a new generation; old retained bindings remain valid. Build/bind failure is atomic. No eval heap allocation. Refcounts are not thread-safe.

Existing snapshot capacity65536 and work8M remain unchanged. Primary direct visibility keeps 1M rays/100M node visits/50M triangle tests. Additional transport is separately capped per frame across all bands:20M rays/800M nodes/300M triangle tests. Reaching a limit rejects the render; unfinished bands/files are not accepted. The old work charge does not account for the new transport CPU.

BVH cap512KiB per generation; owned transport/material cap256KiB per generation. Two coexisting generations are caller-budgeted, not a global allocator restriction. Actual allocations and build temporaries are reported separately. Firmware RAM/F64-FPU cost is unmeasured. AgX remains OFF; shade linear HDR, clamp, encode sRGB, quantize565 once. No simultaneous visibility/profile/BRDF changes beyond these declared arms.
