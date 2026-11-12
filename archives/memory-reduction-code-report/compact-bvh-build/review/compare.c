#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
static int fail_at=-1, calls=0;
static void *fm(size_t n){if(calls++==fail_at)return NULL;return malloc(n);}
static void *fc(size_t n,size_t s){if(calls++==fail_at)return NULL;return calloc(n,s);}
#define malloc fm
#define calloc fc
#include SOURCE
#undef malloc
#undef calloc
static void emit(const void *p,size_t n){assert(fwrite(p,1,n,stdout)==n);}
static void num(size_t n){emit(&n,sizeof(n));}
static void scene(vis_scene*s){num(s->bytes);num(s->triangles);num(s->nodes);num(s->vertices);emit(s->xyz,s->vertices*24);emit(s->tri,s->triangles*sizeof(triangle));emit(s->tree,s->nodes*sizeof(node));}
static void query(vis_binding*b,vis_generation g){
 for(int i=0;i<32;i++){double o[3]={i*.25-3,0,5},d[3]={0,0,-1},to[3]={o[0],0,-5};
 for(int cap=0;cap<4;cap++){vis_budget z={.limit={cap?100:0,cap==1?1:10000,cap==2?1:10000}};vis_hit h;memset(&h,0x5a,sizeof h);int r=vis_ray_nearest(b,g,o,d,&z,&h);num(r);emit(&h,sizeof h);emit(&z.used,sizeof z.used);
 z=(vis_budget){.limit={cap?100:0,cap==1?1:10000,cap==2?1:10000}};int hit=99;r=vis_segment_occluded(b,g,o,to,&z,&hit);num(r);num(hit);emit(&z.used,sizeof z.used);}
 }
}
int main(void){
 size_t counts[]={1,2,4,5,7,8,9,15,17,31,63,127,257,513,1025,1566,2048};
 vis_generation g={1,1,1},g2={2,1,1};vis_limits lim={2048,4095,SIZE_MAX};
 double *xyz=malloc(4096*24);uint32_t *ix=malloc(2048*12);
 for(int mode=0;mode<32;mode++)for(size_t ci=0;ci<sizeof counts/sizeof*counts;ci++){
 size_t n=counts[ci],v=(mode==0||mode>=8)?3:4096;
 for(size_t j=0;j<v;j++){double a=(double)(((j/3)*37)%101)-50+(j%3==1),b=(double)(((j/3)*13)%67)-33+(j%3==2);
 xyz[3*j]=a;xyz[3*j+1]=b;xyz[3*j+2]=(double)((j/3)%11)-5;}
 if(mode==0||mode>=8){double p[]={-1,-1,0,1,-1,-0.,0,1,0};memcpy(xyz,p,sizeof p); if(mode>=8){int bits=(mode-8)%8,axis=(mode-8)/8; for(int j=0;j<3;j++){xyz[j*3+2]=(bits&(1<<j))?-0.:0.; if(axis!=2){double t=xyz[j*3+axis];xyz[j*3+axis]=xyz[j*3+2];xyz[j*3+2]=t;}}}}
 for(size_t j=0;j<n;j++){ix[j*3]=(mode==0||mode>=8)?0:(j*3)%4095;ix[j*3+1]=(mode==0||mode>=8)?1:(j*3+1)%4095;ix[j*3+2]=(mode==0||mode>=8)?2:(j*3+2)%4095;}
 if(mode==1||mode==2)for(size_t j=0;j<v;j++)xyz[3*j+2]=(j%2)?0.:-0.;
 if(mode==3)for(size_t j=0;j<v*3;j++)xyz[j]*=1e48;
 if(mode==4)for(size_t j=0;j<v*3;j++)xyz[j]*=1e-40;
 if(mode==5)for(size_t j=0;j<v;j++)xyz[3*j+2]=0;
 if(mode==6){ix[0]=ix[1]=ix[2]=0;}
 if(mode==7)xyz[0]=1e51;
 vis_scene*s=NULL;calls=0;int r=vis_scene_build(&s,xyz,v,ix,n,g,lim);num(mode);num(n);num(r);if(r!=VIS_OK){assert(!s);continue;}scene(s);
 vis_binding binding={0};assert(vis_binding_set(&binding,s,g)==VIS_OK);query(&binding,g);
 for(int f=0;f<5;f++){vis_scene*old=s;calls=0;fail_at=f;r=vis_scene_build(&s,xyz,v,ix,n,g2,lim);fail_at=-1;assert(r==VIS_ALLOC&&s==old);num(r);scene(s);}
 num(vis_scene_build(&s,xyz,v,ix,n,g,lim));
 num(vis_scene_build((vis_scene**)s->xyz,s->xyz,v,ix,n,g2,lim));
 num(vis_scene_build(&s,s->xyz,v,ix,n,g2,lim));assert(s!=binding.scene);scene(s);scene(binding.scene);query(&binding,g);
 xyz[0]+=3;scene(s);vis_binding_clear(&binding);vis_scene_release(s);
 }
 free(xyz);free(ix);return 0;
}
