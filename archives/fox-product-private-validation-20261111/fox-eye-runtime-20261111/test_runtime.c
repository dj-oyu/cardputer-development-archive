#include "eye_runtime.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
static fox_eye_snapshot s,prior,direct;
int main(void){
 FoxEyeControls c=fox_eye_default_controls();assert(fox_eye_snapshot_build(&s,&c));prior=s;
 for(unsigned i=0;i<1001;i++){
  c.blink_both=(float)(i%101)/100;c.blink_neg=1-c.blink_both;c.blink_pos=.731f;
  assert(fox_eye_snapshot_build(&s,&c));assert(fox_eye_snapshot_build(&direct,&c));assert(!memcmp(&s,&direct,sizeof(s)));
  assert(fox_eye_snapshot_build(&s,&s.controls));assert(!memcmp(&s,&direct,sizeof(s)));
  for(unsigned m=0;m<12;m++){float rgb[3],a;assert(fox_eye_snapshot_surface(&s,m,.28f,-.4f,2.55f,rgb,&a));assert(a>=0&&a<=1);for(unsigned k=0;k<3;k++)assert(isfinite(rgb[k])&&rgb[k]>=0);}
  prior=s;c.gaze_up=NAN;assert(!fox_eye_snapshot_build(&s,&c));assert(!memcmp(&s,&prior,sizeof(s)));c.gaze_up=0;
 }
 c=fox_eye_default_controls();assert(fox_eye_snapshot_build(&s,&c));assert(!fox_eye_snapshot_build(NULL,&c));assert(!fox_eye_snapshot_build(&s,NULL));
 printf("PASS runtime 1001 forward/reverse/alias/rollback/recovery cases; snapshot=%zu bytes\n",sizeof(s));return 0;
}
