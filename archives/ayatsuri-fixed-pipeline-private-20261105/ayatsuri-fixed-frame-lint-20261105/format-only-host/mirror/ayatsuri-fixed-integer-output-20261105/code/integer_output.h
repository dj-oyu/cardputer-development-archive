#ifndef INTEGER_OUTPUT_H
#define INTEGER_OUTPUT_H
#include "block_cache.h"
/* All inputs are nonnegative UQ13.19. Configuration/table lifetime exceeds calls.
 * Table has 257 low-code nodes then 24 exponent bands, 257 nodes each.
 * Configuration trusted: generated/validated offline, not untrusted runtime data.
 * No overlapping cache/config/input/output storage. Outputs untouched on failure. */
typedef struct { uint32_t high_code; const uint32_t *shape; } integer_profile;
uint32_t integer_shape(const integer_profile *, uint32_t code);
int integer_output(agx_block_cache *, const integer_profile *, const uint32_t rgb[3], uint16_t *pixel);
#endif
