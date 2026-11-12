#ifndef FOX_DISK_LIGHTING_H
#define FOX_DISK_LIGHTING_H

#include <stddef.h>
#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

#define FOX_DISK_LIGHT_COUNT 3
#define FOX_DISK_SAMPLES 16
#define FOX_DISK_ENDPOINT_EPSILON 1e-9 /* Blender world units */

typedef enum {
    FOX_DISK_OK = 0,
    FOX_DISK_BAD_ARGUMENT = 1,
    FOX_DISK_UNSUPPORTED_SHAPE = 2,
    FOX_DISK_INVALID_INPUT = 3,
    FOX_DISK_NEAR_ENDPOINT = 4,
    FOX_DISK_NUMERIC_RANGE = 5,
    FOX_DISK_VISIBILITY_FAILURE = 6
} FoxDiskStatus;

typedef enum { FOX_DISK_SHAPE_DISK = 1 } FoxDiskShape;

/* Source numbers, not encoded display RGB. Blender AREA size is diameter.
 * Euler XYZ has world rotation Rz(z) Ry(y) Rx(x); emission is local -Z.
 * Only DISK is admitted. Power and diameter must be > 0; RGB >= 0.
 */
typedef struct {
    FoxDiskShape shape;
    double center[3];
    double rotation_xyz[3];
    double color[3];
    double power;
    double diameter;
} FoxDiskLightInput;

/* Owned prepared data: no pointers, allocation, mutable globals, image inputs,
 * or reference-image lookup. Caller keeps the scene immutable after init.
 */
typedef struct {
    double center[3];
    double normal[3];
    double axis_u[3];
    double axis_v[3];
    double power_rgb_over_pi_squared[3];
    double radius;
} FoxDiskLight;

typedef struct {
    FoxDiskLight lights[FOX_DISK_LIGHT_COUNT];
    double world_radiance[3];
} FoxDiskScene;

/* All APIs commit their output only on success. RGB output is finite,
 * nonnegative, unclipped linear HDR. No artist diffuse gain is applied.
 */
FoxDiskStatus fox_disk_scene_init(
    FoxDiskScene *out,
    const FoxDiskLightInput lights[FOX_DISK_LIGHT_COUNT],
    const double world_rgb[3], double world_strength);

FoxDiskStatus fox_disk_scene_validate(const FoxDiskScene *scene);

/* Position and normal are Blender-world, NOT native scale-38 coordinates.
 * Normal is normalized internally. rho is linear RGB, each component [0,1].
 * Receiver within epsilon of any disk surface -> NEAR_ENDPOINT, unchanged out.
 * Back-facing source/receiver contributions are zero (one-sided emission).
 */
FoxDiskStatus fox_disk_eval16(
    const FoxDiskScene *scene, const double position[3],
    const double normal[3], const double rho[3], double out_rgb[3]);

/* Return true on query success and write *visible; false aborts evaluation.
 * Arguments are Blender-world coordinates and the normalized receiver normal.
 * Pointers are borrowed only for the duration of the callback. Callbacks must
 * not mutate the scene or evaluation inputs. No global callback state is used.
 */
typedef bool (*FoxDiskVisibilityCallback)(void *context,
    const double position[3], const double receiver_normal[3],
    const double light_sample[3], bool *visible);

/* Fixed, unchanged 16-point quadrature with binary direct-light visibility.
 * NULL callback is BAD_ARGUMENT. Only strictly positive geometric kernels
 * trigger a query. The world term is unoccluded. False callback return gives
 * VISIBILITY_FAILURE and leaves out_rgb unchanged (callback side effects are
 * not rolled back). All-visible queries reproduce fox_disk_eval16 exactly.
 */
FoxDiskStatus fox_disk_eval16_visible(
    const FoxDiskScene *scene, const double position[3],
    const double normal[3], const double rho[3],
    FoxDiskVisibilityCallback callback, void *context, double out_rgb[3]);

/* Diagnostic quadrature: radial_bands m, 4m azimuths, 4m^2 total points/light.
 * m=2 is the fixed 16-point evaluator, m=4 is 64 points.
 * Allowed m=1..512. Formula is documented in README.md.
 */
FoxDiskStatus fox_disk_eval_diagnostic(
    const FoxDiskScene *scene, const double position[3],
    const double normal[3], const double rho[3],
    unsigned radial_bands, double out_rgb[3]);

const char *fox_disk_status_string(FoxDiskStatus status);

#ifdef __cplusplus
}
#endif
#endif
