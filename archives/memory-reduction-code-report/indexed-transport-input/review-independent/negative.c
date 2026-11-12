#include "../private-build/transport/bounce.c"
#include <stdio.h>
#include <assert.h>
static unsigned checks, evals, failcases;
size_t test_vis_refs(vis_scene *,size_t);
#define CK(x) do { ++checks; if(!(x)){fprintf(stderr,"FAIL line %d: %s\n",__LINE__,#x);abort();}}while(0)
void *__real_calloc(size_t,size_t);
static size_t alloc_calls, fail_at, live;
static void *tracked[1024];
void __real_free(void *);
void *__wrap_calloc(size_t n,size_t z){if(++alloc_calls==fail_at)return NULL;void *p=__real_calloc(n,z);if(p){size_t i=0;while(i<1024&&tracked[i])i++;if(i==1024)abort();tracked[i]=p;live++;}return p;}
void __wrap_free(void *p){if(p)for(size_t i=0;i<1024;i++)if(tracked[i]==p){tracked[i]=NULL;live--;break;}__real_free(p);}
static bounce_generation gen={{1,1,1},1,0};
static bounce_triangle attr(void){bounce_triangle a={0};a.double_sided=1;for(int j=0;j<3;j++){a.v[j].front[2]=32767;a.v[j].back[2]=-32767;a.v[j].a565=0xf800;a.v[j].b565=0x8410;}return a;}
static FoxDiskScene lights(void){FoxDiskLightInput in[3]={0};FoxDiskScene s;for(int i=0;i<3;i++){in[i].shape=FOX_DISK_SHAPE_DISK;in[i].center[0]=i*2;in[i].center[2]=5;in[i].diameter=.2;in[i].power=1;}double w[]={.25,.5,1};CK(fox_disk_scene_init(&s,in,w,1)==FOX_DISK_OK);return s;}
static vis_scene *geometry(size_t count,double z){double xyz[]={-100,-100,z,100,-100,z,100,100,z,-100,100,z};uint32_t *idx=malloc(count*3*sizeof(*idx));CK(idx);for(size_t i=0;i<count;i++){idx[3*i]=0;idx[3*i+1]=i%2?2:1;idx[3*i+2]=i%2?3:2;}vis_scene *s=NULL;CK(vis_scene_build(&s,xyz,4,idx,count,gen.visibility,(vis_limits){2048,4095,524288})==VIS_OK);free(idx);return s;}
static bounce_result evaluate(bounce_scene *s,bounce_generation g,int mode,int samples,vis_counters *used){bounce_binding b={0};CK(bounce_binding_set(&b,s,g)==BOUNCE_OK);double p[]={0,0,0},n[]={0,0,1},rho[]={.3,.6,.9};vis_budget db={{1000000,100000000,50000000},{0}},tb={{20000000,800000000,300000000},{0}};bounce_result r={0};CK(bounce_eval(&b,g,p,n,rho,(bounce_mode)mode,samples,16,&db,&tb,&r)==BOUNCE_OK);used[0]=db.used;used[1]=tb.used;bounce_binding_clear(&b);evals++;return r;}
static void parity(bounce_scene *a,bounce_scene *b,bounce_generation g){for(int m=0;m<3;m++)for(int n=16;n<=64;n*=4){vis_counters au[2],bu[2];bounce_result ar=evaluate(a,g,m,n,au),br=evaluate(b,g,m,n,bu);CK(!memcmp(&ar,&br,sizeof ar));CK(!memcmp(au,bu,sizeof au));}}
static bounce_vertex vv[7];static bounce_indexed_triangle tt[2];
static void reset(void){bounce_triangle a=attr();for(int i=0;i<7;i++){vv[i]=a.v[0];vv[i].a565=(uint16_t)(0xf800+i);}memset(tt,0,sizeof tt);for(int t=0;t<2;t++){tt[t].double_sided=1;for(int j=0;j<3;j++)tt[t].index[j]=(uint16_t)(t*3+j);}}
static bounce_status build(bounce_scene **s,vis_scene*v,bounce_generation g,FoxDiskScene*l){return bounce_scene_build_ground_indexed(s,v,vv,7,tt,2,l,1,g,262144,NULL);}
#define BADQ() CK(bounce_scene_indexed_required_bytes(vv,7,tt,2)==0)
#define BADB() do{bounce_scene*old=s;CK(build(&s,v,next,&l)==BOUNCE_INVALID);CK(s==old);failcases++;}while(0)
int main(void){
 reset();FoxDiskScene l=lights();vis_scene*v=geometry(2,1);bounce_scene*s=NULL;bounce_generation next=gen;next.material++;
 size_t need=bounce_scene_indexed_required_bytes(vv,7,tt,2);CK(need==sizeof(bounce_scene)+16+120);CK(build(&s,v,gen,&l)==BOUNCE_OK);CK(s->bytes==need);
 vv[6].mask=NAN;BADQ();BADB();reset();vv[6].a565=vv[0].a565;CK(bounce_scene_indexed_required_bytes(vv,7,tt,2)==need);
 for(int side=0;side<2;side++)for(int k=0;k<3;k++){reset();(side?vv[6].back:vv[6].front)[k]=INT16_MIN;BADQ();BADB();}
 for(int side=0;side<2;side++){reset();memset(side?vv[6].back:vv[6].front,0,6);BADQ();BADB();}
 reset();tt[1].index[2]=7;BADQ();BADB();reset();tt[1].index[2]=UINT16_MAX;BADQ();BADB();reset();tt[1].padding=1;BADQ();BADB();reset();tt[1].double_sided=2;BADQ();BADB();reset();
 CK(!bounce_scene_indexed_required_bytes(vv,0,tt,2));CK(!bounce_scene_indexed_required_bytes(vv,6145,tt,2));CK(!bounce_scene_indexed_required_bytes(vv,SIZE_MAX,tt,2));CK(!bounce_scene_indexed_required_bytes(vv,7,tt,2049));CK(!bounce_scene_indexed_required_bytes(vv,7,tt,SIZE_MAX));CK(!bounce_scene_indexed_required_bytes(NULL,7,tt,2));CK(!bounce_scene_indexed_required_bytes(vv,7,NULL,2));
 CK(!bounce_scene_indexed_required_bytes((bounce_vertex*)(UINTPTR_MAX-3),7,tt,2));CK(!bounce_scene_indexed_required_bytes(vv,7,(bounce_indexed_triangle*)(UINTPTR_MAX-1),2));
 _Alignas(bounce_vertex) unsigned char vb[sizeof vv+8];_Alignas(bounce_indexed_triangle) unsigned char tb[sizeof tt+8];memcpy(vb+1,vv,sizeof vv);memcpy(tb+1,tt,sizeof tt);
 CK(!bounce_scene_indexed_required_bytes((bounce_vertex*)(vb+1),7,tt,2));CK(!bounce_scene_indexed_required_bytes(vv,7,(bounce_indexed_triangle*)(tb+1),2));
 CK(!bounce_scene_indexed_required_bytes(vv,7,(bounce_indexed_triangle*)vv,2));
 bounce_scene *old=s;CK(bounce_scene_build_ground_indexed(&s,v,vv,7,tt,2,&l,1,next,need-1,NULL)==BOUNCE_INVALID);CK(s==old);
 /* Pair overlap must reject before interpreting either array's content. */
 CK(bounce_scene_build_ground_indexed(&s,v,vv,7,(bounce_indexed_triangle*)vv,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(s==old);
 CK(bounce_scene_build_ground_indexed(&s,v,(bounce_vertex*)&l,7,tt,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(s==old);
 CK(bounce_scene_build_ground_indexed(&s,v,vv,7,(bounce_indexed_triangle*)&l,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(s==old);
 bounce_ground gr={0};CK(bounce_scene_build_ground_indexed(&s,v,(bounce_vertex*)&gr,1,tt,2,&l,1,next,262144,&gr)==BOUNCE_INVALID);CK(s==old);
 CK(bounce_scene_build_ground_indexed(&s,v,vv,7,(bounce_indexed_triangle*)&gr,2,&l,1,next,262144,&gr)==BOUNCE_INVALID);CK(s==old);
 CK(bounce_scene_build_ground_indexed(&s,v,(bounce_vertex*)s->attrs,6,tt,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(s==old);
 CK(bounce_scene_build_ground_indexed(&s,v,vv,7,(bounce_indexed_triangle*)s->attrs,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(s==old);
 CK(bounce_scene_build_ground_indexed(&s,v,(bounce_vertex*)v,7,tt,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(s==old);
 CK(bounce_scene_build_ground_indexed(&s,v,vv,7,(bounce_indexed_triangle*)v,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(s==old);
 union{bounce_vertex a[7];bounce_scene*slot;} va;memset(&va,0,sizeof va);va.slot=s;CK(bounce_scene_build_ground_indexed(&va.slot,v,va.a,7,tt,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(va.slot==s);
 union{bounce_indexed_triangle a[2];bounce_scene*slot;} ta;memset(&ta,0,sizeof ta);ta.slot=s;CK(bounce_scene_build_ground_indexed(&ta.slot,v,vv,7,ta.a,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(ta.slot==s);
 bounce_binding retained={0};CK(bounce_binding_set(&retained,s,gen)==BOUNCE_OK);size_t before=live;alloc_calls=0;fail_at=1;CK(build(&s,v,next,&l)==BOUNCE_ALLOC);fail_at=0;CK(s==old);CK(live==before);
 size_t vr=test_vis_refs(v,SIZE_MAX);CK(build(&s,v,next,&l)==BOUNCE_VISIBILITY);CK(s==old);CK(live==before);CK(test_vis_refs(v,vr)==SIZE_MAX);
 CK(build(&s,v,next,&l)==BOUNCE_OK);vis_counters used[2];CK(evaluate(retained.scene,gen,2,16,used).counters.primary_hits==16);bounce_binding_clear(&retained);bounce_scene_release(s);vis_scene_release(v);
 for(int variant=0;variant<12;variant++){reset();for(int i=0;i<6;i++){vv[i].mask=variant%3==0?-1:variant%3==1?0:1;if(variant==5)vv[i].mask=i%2?-0.0f:0.0f;if(variant==6)vv[i].back[2]=32767;}if(variant==4)tt[0].double_sided=0;bounce_triangle a[2]={0};for(int t=0;t<2;t++){a[t].double_sided=tt[t].double_sided;for(int j=0;j<3;j++)a[t].v[j]=vv[tt[t].index[j]];}v=geometry(2,variant==0?-1:1);bounce_scene*x=NULL,*y=NULL,*z=NULL;CK(bounce_scene_build(&x,v,a,2,&l,1,gen,262144)==BOUNCE_OK);CK(bounce_scene_build_ground_compact(&y,v,a,2,&l,1,gen,262144,NULL)==BOUNCE_OK);CK(build(&z,v,gen,&l)==BOUNCE_OK);CK(z->bytes==y->bytes);CK(!memcmp(z->attrs,y->attrs,z->bytes-sizeof(*z)));memset(vv,0xa5,sizeof vv);memset(tt,0xa5,sizeof tt);vis_scene_release(v);parity(x,z,gen);parity(y,z,gen);bounce_scene_release(x);bounce_scene_release(y);bounce_scene_release(z);}
 /* The maximum6144 distinct referenced vertices; required size must be exact. */
 bounce_vertex *vs=malloc(6144*sizeof(*vs));bounce_indexed_triangle*ts=calloc(2048,sizeof(*ts));CK(vs&&ts);bounce_vertex base=attr().v[0];for(size_t i=0;i<6144;i++){vs[i]=base;vs[i].a565=(uint16_t)i;}for(size_t i=0;i<2048;i++){ts[i].double_sided=1;for(int j=0;j<3;j++)ts[i].index[j]=(uint16_t)(3*i+j);}need=bounce_scene_indexed_required_bytes(vs,6144,ts,2048);CK(need==139848);v=geometry(2048,1);s=NULL;CK(bounce_scene_build_ground_indexed(&s,v,vs,6144,ts,2048,&l,1,gen,need,NULL)==BOUNCE_OK);CK(s->bytes==need);bounce_scene_release(s);vis_scene_release(v);free(vs);free(ts);CK(live==0);
 printf("PASS checks=%u evaluations=%u invalid_atomic_cases=%u live_allocations=0\n",checks,evals,failcases);return 0;
}
