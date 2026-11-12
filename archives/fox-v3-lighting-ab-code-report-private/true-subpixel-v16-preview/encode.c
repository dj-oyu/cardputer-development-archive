#include <math.h>
#include <stdint.h>
#include <stddef.h>
#include "ayatsuri/ayatsuri_shade.h"
int encode(const double *p,uint16_t *out,size_t count){if(!p||!out||count!=32400)return 0;for(size_t i=0;i<count*3;i++)if(!isfinite(p[i])||p[i]<0)return 0;for(size_t i=0;i<count;i++){unsigned q[3];for(unsigned k=0;k<3;k++){float v=ayatsuri_srgb_encode((float)fmin(1,p[3*i+k]));q[k]=(unsigned)lroundf(v*(k==1?63:31));}out[i]=(uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]);}return 1;}
