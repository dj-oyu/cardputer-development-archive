#include "agx_profile.h"
#include <stddef.h>
#include <stdint.h>
#include <math.h>
#include "ayatsuri/ayatsuri_shade.h"
/* Independent postpixel diagnostic, not product snapshot storage. */
int profile_buffer(const double *raw,uint16_t *out,size_t pixels,unsigned enabled,unsigned long *clamped){
 if(!raw||!out||!clamped||enabled>1||pixels!=32400)return 0;
 for(size_t i=0;i<3*pixels;i++)if(!isfinite(raw[i])||raw[i]<0||!isfinite((float)raw[i]))return 0;
 unsigned long count=0;
 for(size_t i=0;i<pixels;i++){
  float input[3]={(float)raw[3*i],(float)raw[3*i+1],(float)raw[3*i+2]},display[3];
  if(enabled){int s=agx_profile_eval(input,display);if(s==AGX_PROFILE_INVALID)return 0;count+=(s&AGX_PROFILE_CLAMP_HIGH)!=0;}
  else for(unsigned k=0;k<3;k++)display[k]=ayatsuri_srgb_encode((float)fmin(1.0,raw[3*i+k]));
  unsigned q[3];for(unsigned k=0;k<3;k++)q[k]=(unsigned)lroundf(display[k]*(k==1?63:31));out[i]=(uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]);
 }
 *clamped=count;return 1;
}
