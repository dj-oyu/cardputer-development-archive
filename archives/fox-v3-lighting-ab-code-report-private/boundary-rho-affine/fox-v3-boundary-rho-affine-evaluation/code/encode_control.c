#include <stdint.h>
#include <math.h>
#include "ayatsuri/ayatsuri_shade.h"
void encode_control(const double *rgb,uint16_t *out,unsigned n){for(unsigned i=0;i<n;i++){unsigned q[3];for(unsigned k=0;k<3;k++){float value=ayatsuri_srgb_encode((float)fmin(1,rgb[3*i+k]));q[k]=(unsigned)lroundf(value*(k==1?63:31));}out[i]=(uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]);}}
