/* Semantic trace: v2/v3 sorted triangles, node fields, exact query values/work. */
#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#ifdef BASELINE
#include "../../fox-v3-visibility-lifetime-reduction/private-build/visibility/visibility.c"
#else
#include "../private-build/visibility/visibility.c"
#endif
static uint64_t fingerprint=UINT64_C(1469598103934665603);
static void hash(const void *data,size_t n){const unsigned char *p=data;for(size_t i=0;i<n;i++){fingerprint^=p[i];fingerprint*=UINT64_C(1099511628211);}}
#define HASH(x) hash(&(x),sizeof(x))
static void canonical(const vis_scene *s,size_t i,const uint32_t *indices){
 double p[3][3],lo[3],hi[3],center[3];uint32_t ordinal=s->tri[i].ordinal;
 triangle_points(s,&s->tri[i],p);
 for(size_t j=0;j<3;j++)assert(s->tri[i].vertex[j]==indices[3*(size_t)ordinal+j]);
 for(int k=0;k<3;k++){lo[k]=fmin(p[0][k],fmin(p[1][k],p[2][k]));hi[k]=fmax(p[0][k],fmax(p[1][k],p[2][k]));center[k]=(lo[k]+hi[k])*0.5;}

 HASH(p);HASH(lo);HASH(hi);HASH(center);HASH(ordinal);
}
int main(void){
 double xyz[3*4096];uint32_t indices[3*2048];
 size_t ns[]={1,2,3,4,5,7,8,9,15,16,17,31,32,33,511,512,513,1023,1024,1025,1166,1566,2048};
 for(int mode=0;mode<6;mode++){
  size_t vertices=mode==2?4096:300,groups=vertices/3;
  for(size_t t=0;t<groups;t++){
   /* Mode1 supplies separate vertex identities at identical positions/ties,
    * including signed zero bits; mode2 exercises the maximum vertex count. */
   size_t key=mode==1?t/2:t;
   double x=(double)((key*17)%23)-11,y=(double)((key*29)%19)-9,z=(double)((key*7)%13)-6;
   if(mode==1 && key%3==0)z=(t%2)?-0.0:0.0;
   double v[9]={x,y,z,x+0.8,y,z+0.125,x,y+0.9,z+0.25};
   if(mode==3)for(int j=0;j<3;j++)v[3*j+2]=(t&(1u<<j))?-0.0:0.0;
   if(mode==4)for(int j=0;j<9;j++)v[j]*=1e48;
   if(mode==5)for(int j=0;j<3;j++)v[3*j+2]=(t&(1u<<j))?-0x1p-1074:0x1p-1074;
   memcpy(xyz+9*t,v,sizeof(v));
  }
  if(vertices%3){xyz[3*(vertices-1)]=-0.0;xyz[3*(vertices-1)+1]=0.0;xyz[3*(vertices-1)+2]=-0.0;}
  for(size_t t=0;t<2048;t++){size_t base=((t*37)%groups)*3;for(size_t k=0;k<3;k++)indices[t*3+k]=(uint32_t)(base+k);}
  for(size_t ni=0;ni<sizeof(ns)/sizeof(ns[0]);ni++){
   size_t n=ns[ni];vis_scene *s=NULL;vis_binding b={0};vis_generation g={1,1,1};vis_limits lim={2048,4095,1000000};assert(vis_scene_build(&s,xyz,vertices,indices,n,g,lim)==VIS_OK);assert(vis_binding_set(&b,s,g)==VIS_OK);HASH(mode);HASH(n);HASH(s->nodes);
   for(size_t i=0;i<n;i++)canonical(s,i,indices);
   for(size_t i=0;i<s->nodes;i++){double lo[3],hi[3];
#ifdef BASELINE
    memcpy(lo,s->tree[i].lo,sizeof(lo));memcpy(hi,s->tree[i].hi,sizeof(hi));
#else
    for(int k=0;k<3;k++){assert(s->tree[i].lo_vertex[k]<vertices && s->tree[i].hi_vertex[k]<vertices);lo[k]=bound_value(s,s->tree[i].lo_vertex[k],k);hi[k]=bound_value(s,s->tree[i].hi_vertex[k],k);}
#endif
    printf("NODE %d %zu %zu %a %a %a %a %a %a %u %u %u %u\n",mode,n,i,lo[0],lo[1],lo[2],hi[0],hi[1],hi[2],s->tree[i].left,s->tree[i].right,s->tree[i].start,s->tree[i].count);HASH(lo);HASH(hi);HASH(s->tree[i].left);HASH(s->tree[i].right);HASH(s->tree[i].start);HASH(s->tree[i].count);}
   for(int q=0;q<512;q++){
    double from[3]={((q*13)%57-28)*0.5,((q*17)%49-24)*0.5,-20},to[3]={from[0],from[1],20},dir[3]={0,0,1};
    if(q%3==1){dir[0]=0.6;dir[2]=0.8;to[0]=from[0]+24;to[2]=from[2]+32;}
    if(q%3==2){double swap[3];memcpy(swap,from,sizeof(swap));memcpy(from,to,sizeof(from));memcpy(to,swap,sizeof(to));for(int k=0;k<3;k++)dir[k]=-dir[k];}
    if(mode==4)for(int k=0;k<3;k++){from[k]*=1e48;to[k]*=1e48;}
    if(q%7==0 && dir[0]==0)dir[0]=-0.0;
    if(q%11==0 && dir[1]==0)dir[1]=-0.0;
    vis_budget budget={{100,100000,100000},{0,0,0}};int occluded=71;
    if(q%23==0)budget.limit.node_visits=2;
    if(q%29==0)budget.limit.triangle_tests=1;
    if(q%31==0)budget.limit.rays=1;
    vis_status status=vis_segment_occluded(&b,g,from,to,&budget,&occluded);HASH(status);HASH(occluded);HASH(budget.used);
    vis_hit hit;memset(&hit,0x55,sizeof(hit));status=vis_ray_nearest(&b,g,from,dir,&budget,&hit);HASH(status);HASH(hit.found);HASH(hit.triangle_ordinal);HASH(hit.distance);HASH(hit.bary);HASH(hit.position);HASH(hit.geometric_normal);HASH(budget.used);
   }
   vis_binding_clear(&b);vis_scene_release(s);
  }
 }
 printf("%016llx\n",(unsigned long long)fingerprint);
}
