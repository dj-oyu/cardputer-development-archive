/* Private diagnostic only: no shader or light evaluation functions are invoked. */
#include <stdint.h>
#include <stddef.h>
#include <math.h>
#include "visibility.h"
#include "bounce_pure_extract.h"
/* Exact original nearest-ray engine; original order geometry includes ground last.
 * Distinct generation tokens bind baseline/q16/q20 through caller manifest.
 * out: rays,nodes,tri-tests,ground-hits,character-hits,misses,events,scene-bytes.
 * Failure retains consumed counters and never certifies a partial count. */
int floor_ray_metadata(const double*xyz,size_t nv,const uint32_t*tri,size_t nt,const double*events,size_t ne,uint64_t generation,uint64_t out[8]){
 if(!xyz||!tri||!events||!out||nv!=1167||nt!=1566||ne<1||ne>17241||!generation)return -1;
 for(int k=0;k<8;k++)out[k]=0;
 vis_scene*s=NULL;vis_binding b={0};vis_generation g={generation,1,1};
 vis_budget budget={.limit={275856,100000000,50000000}};
 int status=vis_scene_build(&s,xyz,nv,tri,nt,g,(vis_limits){2048,4095,524288});if(status)return 10+status;
 out[7]=vis_scene_bytes(s);status=vis_binding_set(&b,s,g);vis_scene_release(s);if(status)return 20+status;
 for(size_t i=0;i<ne;i++){
  const double*p=events+6*i;double n[3];if(!norm(p+3,n)){status=-2;break;}
  for(unsigned j=0;j<16;j++){
   double d[3];direction(n,16,j,d);vis_hit h;status=vis_ray_nearest(&b,g,p,d,&budget,&h);if(status){status+=30;break;}
   if(!h.found)out[5]++;else if(h.triangle_ordinal>=1564&&h.triangle_ordinal<1566)out[3]++;else out[4]++;
  }
  if(status)break;out[6]++;
 }
 out[0]=budget.used.rays;out[1]=budget.used.node_visits;out[2]=budget.used.triangle_tests;vis_binding_clear(&b);return status;
}
