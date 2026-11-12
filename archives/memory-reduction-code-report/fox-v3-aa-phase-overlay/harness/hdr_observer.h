#ifndef ROW_HDR_OBSERVER_H
#define ROW_HDR_OBSERVER_H
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
/* Diagnostic-only storage. Never used to calculate shading or encoded pixels. */
bool row_hdr_observer_begin(uint16_t *pixels);
bool row_hdr_observe(const double rgb[3], const uint16_t *pixel);
bool row_hdr_observer_write(const char *prefix);
void row_hdr_observer_clear(void);
#endif
