#include <time.h>
#include <stdio.h>
#include <assert.h>
#ifdef BASELINE
#include "../../fox-v3-visibility-lifetime-reduction/private-build/visibility/visibility.c"
#else
#include "../private-build/visibility/visibility.c"
#endif
int main(void){
 const size_t n=1566,v=1167;double xyz[1167*3];uint32_t idx[1566*3];
 for(size_t i=0;i<v;i++){xyz[3*i]=(double)(i%19);xyz[3*i+1]=(double)((i/19)%17);xyz[3*i+2]=(double)(i/323);}
 for(size_t i=0;i<n;i++){size_t j=(i*37)%(v/3);for(size_t k=0;k<3;k++)idx[3*i+k]=(uint32_t)(3*j+k);}
 /* Ensure non-collinear triangles, preserving randomized original-order centers. */
 for(size_t i=0;i<v/3;i++){xyz[9*i+3]=xyz[9*i]+.5;xyz[9*i+4]=xyz[9*i+1];xyz[9*i+5]=xyz[9*i+2];xyz[9*i+6]=xyz[9*i];xyz[9*i+7]=xyz[9*i+1]+.5;xyz[9*i+8]=xyz[9*i+2];}
 vis_limits lim={n,VIS_MAX_NODES,SIZE_MAX};clock_t begin=clock();
 for(size_t i=0;i<200;i++){vis_scene *s=NULL;assert(vis_scene_build(&s,xyz,v,idx,n,(vis_generation){1,1,1},lim)==VIS_OK);vis_scene_release(s);}
 printf("%.9f\n",(double)(clock()-begin)/CLOCKS_PER_SEC/200);
}
