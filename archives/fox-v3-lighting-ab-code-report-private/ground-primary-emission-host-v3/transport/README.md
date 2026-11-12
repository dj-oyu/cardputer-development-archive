# Ground transport extension (private host experiment)

This isolated copy extends the frozen one-bounce implementation. Public product
sources, cases, reference assets, and the original frozen tree are unchanged.

`bounce_scene_build` remains the legacy constructor and supplies a canonical
GROUND_OFF descriptor. `bounce_scene_build_ground` takes the same arguments plus
an optional `const bounce_ground *` last. It copies that descriptor into the
owned immutable scene. It holds mode, stable nonzero object ID, original triangle
ordinal range, and finite nonnegative linear HDR `le[3]`. Le is never sRGB-decoded.
The object ID is metadata identifying this single tagged range, not a BVH index.
Triangle ordinals are the original input order, independent of BVH sorting.

Modes are `BOUNCE_GROUND_OFF=0`, `BOUNCE_GROUND_CONTROL=1`, and
`BOUNCE_GROUND_PRIMARY_LE=2`. OFF requires an entirely zero descriptor and does
not remove any geometry; the adapter must omit appended floor triangles for a
floor-free legacy arm. CONTROL/PRIMARY_LE require a nonempty in-bounds ordinal
range and nonzero object ID and emission token. No body-specific range constant
is embedded here. Floor placeholder attributes still meet normal build validation,
but no tagged floor hit ever evaluates them as a BSDF.

`bounce_generation` appends `uint64_t emission`; legacy zero-initialized callers
remain emission=0. All generation comparisons include emission. Replacement
cannot regress it, and any change in ground mode, ID, range or Le requires a
strictly increased emission token, even if other tokens advance. Canonical OFF
may carry a later emission token when disabling a previously enabled descriptor.
The caller must supply complete generation identities and the adapter may use
`bounce_scene_matches_ground` for exact descriptor comparison. Old retained
bindings preserve their old descriptor and generation after replacement.

For WORLD_VISIBLE or ONE outer hemisphere samples, first-hit tagged floor is
handled before normal or rho lookup. CONTROL returns zero. PRIMARY_LE adds
rhoX*Le/sampleCount into `bounce_result.ground`. Constant emission is explicitly
two-sided and does not depend on floor normals or placeholder reflectance. A
floor hit replaces the world-miss contribution; it never adds both. Secondary
world rays hitting floor return zero, with no Le or floor reflection. Existing
area visibility sees the opaque floor through the same BVH. `BOUNCE_OFF` transport
mode still bypasses hemisphere sampling entirely, distinct from GROUND_OFF.

Combined HDR is direct + world + bounce + ground. The exact old arithmetic order
is retained for GROUND_OFF, with no extra addition of zero. Counters add
`primary_ground_hits` (subset of primary_hits), `primary_ground_emission_hits`
(PRIMARY_LE hits, including Le=0), and `secondary_ground_hits` (only secondary
world nearest hits, not area visibility queries). CONTROL emission-hit count is
zero. Budgets, ownership, refcounts, failure atomicity and allocation caps remain
as documented below: 2048 triangles, scene cap 262144 bytes, two cumulative
budgets, no quota increase or per-band reset.

## Ground tests

Compile `test_ground.c` with bounce.c, visibility.c, fox_disk_lighting.c and -lm,
using C11 -Wall -Wextra -Werror. This passes finite huge-floor 16/64 exact
rhoX*linearLe, both emission sides, opposing placeholder normals and black rho,
world replacement, CONTROL=0, zero-Le event counts, source-behind-plane area
occlusion, body-to-secondary-floor zero contribution, copied descriptor ownership,
stale/changed emission generation rejection, retained old scene lifetime, invalid
range/ID/NaN and byte-cap failure atomicity. The two frozen legacy tests pass
unchanged with `-Wno-missing-field-initializers` for their positional legacy
generation initializers. Production callers should use designated initializers.
ASan+UBSan ground tests pass with leak detection disabled for the environment's
previously documented LeakSanitizer/ptrace restriction.

---

# Owned host-only one-bounce transport

`bounce.h` is the complete API. `bounce_scene` owns a 64-byte attribute record per
original input triangle and a prepared light snapshot, and retains its visibility
scene. There are no global mutable variables, borrowed material pointers, image
inputs or fitted coefficients. The optional ground extension below adds only
primary-hit constant emission, not a ground BSDF. The scene is
immutable after build. Refcounts and bindings are not thread-safe. Callers must
serialize scene replacement, binding changes and evaluation.

Material generation is an explicit caller-issued token alongside geometry, pose
and light tokens. It must change when masks, colors or normals change. Tokens do
not identify content automatically. The adapter must validate actual snapshots
and lights before evaluation. `bounce_scene_matches_lights` compares prepared
fields exactly. Old retained bindings remain valid after successful replacement.
Build failure leaves the original owned scene in place. Bindings must initially
be zeroed. Invalid/forged pointers are unsupported. Detectable overlaps with owned
scene or geometry storage are rejected, but unrelated scenes cannot be discovered
without a global registry.

Attributes are 20 bytes per vertex: independent front/back signed-normal triplets,
raw float mask and raw RGB565 A/B. Triangle double-sided flag and three zero padding
bytes give exactly 64 bytes. INT16_MIN, zero vertex normals, nonfinite masks,
nonzero padding and flags outside 0/1 reject the build. Interpolated zero normals
reject evaluation. Maximum 2048 triangles means 131072 attribute bytes plus the
control allocation; a hard 262144-byte cap applies. Retained visibility storage is
separately capped by its builder. Caller budgets coexistence of old retained scenes
and newly built scenes. No evaluation heap allocation occurs.

For a nearest hit, multiply raw-cross geometric normal by explicit orientation
sign (+1 standard world winding, -1 the actual mirrored native transform). Select
front/back from its dot with outgoing direction >=0. Single-sided backside hits
reflect zero. Interpolated selected SNORM is normalized, without face-forwarding.
Ns dot outgoing <=0 reflects zero and is counted separately from single-sided
rejection and near-grazing geometric incidence (absolute dot <=1e-12). Interpolate
mask first; nonnegative selects B globally, negative A. Decode selected per-vertex
RGB565 using the existing float sRGB decoder, then barycentrically interpolate in
linear space. Tiny roundoff outside [0,1] is clamped only within 1e-12 tolerance.

Direct lighting remains the fixed visible DISK16 evaluator with world zeroed.
OFF adds unoccluded rhoX*Lworld. WORLD_VISIBLE replaces that term with the outer
cosine sample mean of miss-only world. ONE adds the same miss-only world and, on
outer hits, rhoX times rhoY times (visible area irradiance/pi + secondary visible
world). There is no tertiary surface reflection. The area evaluator already
multiplies by rhoY; the world sample mean multiplies by rhoY once. No extra pi or
second rho multiplication occurs. Direct plus world plus bounce equals combined
linear HDR. OFF is a fixture control; the application retains its legacy path for
strict OFF image byte compatibility.

Hemisphere sample counts 16/64 use m=2/4 rings and 4m azimuths, r=sqrt((ring+.5)/m),
phi=2*pi*(az+.5*(ring%2))/(4m), z=sqrt(1-r*r). A deterministic least-aligned-axis
orthonormal basis is built around normalized Ns. Production is outer16/inner16.
Outer64 is a diagnostic. Inner64 must be limited by the caller to synthetic tests
or the first100 hit-query audit, never a full private render. Area rays use the
exact hit-to-light segment and the visibility module's endpoint exclusion once.

Two cumulative caller-owned budgets must remain distinct and must not be reset
between bands. Primary direct queries use direct_budget. All outer nearest,
secondary area and secondary world queries use transport_budget. Suggested hard
frame transport allowance is 20M rays / 800M nodes / 300M triangles, supplied by
the caller; no automatic quota increases occur. Output (including diagnostics)
is failure-atomic. Budget consumption is retained on failure. A zero-rho receiver
still runs queries, making counter behavior independent of material brightness.

## Tests

From repository root, for each test name `test_bounce` and `test_quadrature`:

    cc -std=c11 -Wall -Wextra -Werror -O2 fox-v3-bounce/transport/TEST.c \
      fox-v3-bounce/transport/bounce.c fox-v3-bounce/visibility/visibility.c \
      fox-v3-bounce/physical/fox_disk_lighting.c -lm -o /tmp/TEST
    /tmp/TEST

Tests cover open uniform world, a finite +/-100 plane at z=1 blocking every declared
outer16/64 ray, known constant-rho reflection (exact rhoX*rhoY*Lworld), zero rho,
side/orientation rules, generations, retained old scene lifetimes, failure-atomic
outputs, exhausted cumulative budgets, and exact secondary area callback results
against an independently evaluated unoccluded-area plane reference. These are
finite synthetic fixtures, not a claim that all arbitrary/infinite configurations
were tested. Primary receiver is intentionally not in the fixture BVH so the
secondary downward hemisphere is unoccluded.

Dense synthetic area reference (red channel): outer16 .0615123913267;
outer64 .059204987905; 1024 .0585083503800; 4096 .0585013682084;
16384 .0585012320650. This exposes remaining outer quadrature error rather than
fitting it away. All area calculations still use the fixed area16 source samples.

Partial square blocker (+/-0.8 at z=1), visible world fractions: 16=.5, 64=.5,
1024=.5625, 4096=.5517578125, 16384=.556396484375. Both coarse resolutions have
absolute error .056396484375 against this dense reference. No claim of monotonic
convergence or a coarse-grid accuracy guarantee is made. The high-density oracle
uses only synthetic geometry and the public nearest-hit API.

ASan+UBSan passed with ASAN_OPTIONS=detect_leaks=0. LeakSanitizer cannot run under
this environment's ptrace configuration; leak detection is not claimed.
