#ifndef FOX_EYE_RUNTIME_H
#define FOX_EYE_RUNTIME_H
#include <stdbool.h>
#include <stdint.h>
#include "../fox-eye-contract-20261111/eye_color.h"
#include "../fox-eye-contract-20261111/eye_alpha.h"
#define FOX_EYE_RUNTIME_VERTICES 1322
#define FOX_EYE_RUNTIME_OBJECTS 74
typedef struct {
 FoxEyeControls controls;
 float local[FOX_EYE_RUNTIME_VERTICES][3];
 uint8_t hidden[FOX_EYE_RUNTIME_OBJECTS];
} fox_eye_snapshot;
bool fox_eye_controls_valid(const FoxEyeControls *);
/* Transactional on invalid input: dst remains byte-identical. controls may be
 * &dst->controls. This is NOT a concurrent publication primitive. Build into an
 * unpublished snapshot; publish with caller synchronization, retain unchanged
 * until prepare, preflight, ALL bands and callbacks retire. Never mutate the
 * snapshot currently consumed by a renderer. No heap or global mutable state.
 * Only these nine eye controls are supported; body/head/brow/smile stay at the
 * source neutral geometry (existing independent renderer rig still applies). */
bool fox_eye_snapshot_build(fox_eye_snapshot *dst,const FoxEyeControls *controls);
/* Material index is global frozen scene material index [0,11]. */
bool fox_eye_snapshot_surface(const fox_eye_snapshot*,unsigned material,
                             float x,float y,float z,float rgb[3],float *alpha);
#endif
