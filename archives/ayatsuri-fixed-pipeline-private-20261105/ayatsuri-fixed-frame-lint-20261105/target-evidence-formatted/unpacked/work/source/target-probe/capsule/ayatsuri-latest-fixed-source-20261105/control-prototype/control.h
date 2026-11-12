#ifndef CONTROL_H
#define CONTROL_H
#include <stdint.h>
/* Input Q24: both,left,right,gazeX,gazeUp,style,highlights,reflection,pressure.
 Output Qbits: blink,cx,cz,style,highlights,clampedPressure,quartic,reflection. */
int cp_eval(const int32_t in[9], int side, unsigned bits, int diagnostic_style, int32_t out[8]);
int cp_block(const int32_t *in,int side,unsigned bits,int diagnostic_style,unsigned width,int32_t *out);
#endif
