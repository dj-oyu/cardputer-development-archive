#include <assert.h>
#include <float.h>
#include <stdio.h>
#include <string.h>
#ifdef BASELINE
#include "../../fox-v3-visibility-lifetime-reduction/private-build/visibility/visibility.c"
#else
#include "../private-build/visibility/visibility.c"
#endif
static uint64_t fingerprint=UINT64_C(1469598103934665603);
static void hash(const void *p,size_t n){const unsigned char *s=p;for(size_t i=0;i<n;i++){fingerprint^=s[i];fingerprint*=UINT64_C(1099511628211);}}
static void scene_hash(vis_scene *s){ static int scene_id=0; scene_id++;
 for(size_t i=0;i<s->nodes;i++){
  double lo[3],hi[3];
#ifdef BASELINE
  memcpy(lo,s->tree[i].lo,sizeof(lo));memcpy(hi,s->tree[i].hi,sizeof(hi));
#else
  for(int k=0;k<3;k++){assert(s->tree[i].lo_vertex[k]<s->vertices);assert(s->tree[i].hi_vertex[k]<s->vertices);lo[k]=bound_value(s,s->tree[i].lo_vertex[k],k);hi[k]=bound_value(s,s->tree[i].hi_vertex[k],k);}
#endif
  printf("NODE %d %zu %a %a %a %a %a %a\n",scene_id,i,lo[0],lo[1],lo[2],hi[0],hi[1],hi[2]); hash(lo,sizeof(lo));hash(hi,sizeof(hi));hash(&s->tree[i].left,4*sizeof(uint32_t));
 }
 hash(s->tri,s->triangles*sizeof(triangle));
}
int main(void){
 double xyz[9*8];uint32_t idx[3*9];vis_generation g={1,1,1},g2={2,1,1};vis_limits lim={2048,4095,1000000};
 for(int axis=0;axis<3;axis++)for(int shift=0;shift<8;shift++){
  int a=(axis+1)%3,b=(axis+2)%3;
  memset(xyz,0,sizeof(xyz));
  for(int t=0;t<8;t++)for(int j=0;j<3;j++){
   xyz[t*9+j*3+axis]=((t+shift)&(1<<j))?-0.0:0.0;
   xyz[t*9+j*3+a]=j==1?1:-1;xyz[t*9+j*3+b]=j==2?1:-1;
  }
  for(int i=0;i<27;i++)idx[i]=(uint32_t)(i%24);
  vis_scene *s=NULL;assert(vis_scene_build(&s,xyz,24,idx,9,g,lim)==VIS_OK);scene_hash(s);vis_scene_release(s);
 }
 double extreme[9]={-1e50,0,-0.0,1e50,0,+0.0,0,1e50,-0.0};uint32_t tri[3]={0,1,2};vis_scene *s=NULL;
 assert(vis_scene_build(&s,extreme,3,tri,1,g,lim)==VIS_OK);scene_hash(s);
 vis_binding binding={0};assert(vis_binding_set(&binding,s,g)==VIS_OK);vis_scene *old=s;assert(old->refs==2);
 double bad[]={NAN,INFINITY,-INFINITY,DBL_MAX,-DBL_MAX,nextafter(1e50,INFINITY),nextafter(-1e50,-INFINITY)};
 for(size_t i=0;i<sizeof(bad)/sizeof(bad[0]);i++)for(int component=0;component<9;component++){
  double copy[9];memcpy(copy,extreme,sizeof(copy));copy[component]=bad[i];
  vis_status status=vis_scene_build(&s,copy,3,tri,1,g2,lim);assert(status==VIS_INVALID && s==old && old->refs==2 && binding.scene==old);hash(&status,sizeof(status));
 }
 uint32_t invalids[]={3,4096,UINT16_MAX,UINT32_MAX};
 for(size_t i=0;i<4;i++){uint32_t copy[3]={0,1,invalids[i]};vis_status status=vis_scene_build(&s,extreme,3,copy,1,g2,lim);assert(status==VIS_INVALID && s==old && old->refs==2);hash(&status,sizeof(status));}
 vis_binding_clear(&binding);vis_scene_release(s);
 printf("%016llx\n",(unsigned long long)fingerprint);return 0;
}
