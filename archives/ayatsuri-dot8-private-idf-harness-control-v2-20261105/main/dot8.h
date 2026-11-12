#ifndef DOT8_H
#define DOT8_H
#include <stdint.h>
#include <stdbool.h>
/* n: arbitrary signed16. d: each component [-16385,16385].
 * Eight independent 3D dots, structure-of-arrays. No normalized-length
 * assumption, rounding or clamp. Inputs/output must not overlap.
 * All three arrays passed to raw PIE must be 16-byte aligned.
 * Hardware caller owns exclusive PIE state for the duration of the call. */
typedef struct { _Alignas(16) int16_t v[3][8]; } dot8_input;
typedef struct { _Alignas(16) uint8_t low[32]; uint8_t high[32]; } dot8_packed;
bool dot8_scalar(const dot8_input *, const dot8_input *, int32_t out[8]);
void dot8_unpack(const dot8_packed *, int32_t out[8]);
void dot8_pie_raw(const dot8_input *, const dot8_input *, dot8_packed *);
#endif
