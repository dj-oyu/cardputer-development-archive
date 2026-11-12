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
static void rejected(bounce_scene **slot,vis_scene *v,bounce_triangle *a,FoxDiskScene *l,bounce_generation g,bounce_status want){bounce_scene *old=*slot;CK(bounce_scene_build_ground_compact(slot,v,a,2,l,1,g,262144,NULL)==want);CK(*slot==old);failcases++;}
int main(void){
 FoxDiskScene l=lights();bounce_triangle a[2]={attr(),attr()};vis_scene *v=geometry(2,1);bounce_scene *s=NULL;
 size_t one=bounce_scene_compact_required_bytes(a,2);CK(one>0);CK(one==sizeof(bounce_scene)+16+20);CK(!bounce_scene_compact_required_bytes(NULL,2));CK(!bounce_scene_compact_required_bytes(a,0));CK(!bounce_scene_compact_required_bytes(a,2049));
 a[1].v[2].mask=-0.0f;CK(bounce_scene_compact_required_bytes(a,2)==one+20);a[1].v[2]=a[0].v[0];a[1].v[2].back[0]=1;CK(bounce_scene_compact_required_bytes(a,2)==one+20);a[1].v[2]=a[0].v[0];a[1].v[2].a565++;CK(bounce_scene_compact_required_bytes(a,2)==one+20);a[1]=a[0];a[1].double_sided=0;CK(bounce_scene_compact_required_bytes(a,2)==one);a[1]=a[0];
 CK(bounce_scene_build_ground_compact(&s,v,a,2,&l,1,gen,one-1,NULL)==BOUNCE_INVALID);CK(!s);CK(bounce_scene_build_ground_compact(&s,v,a,2,&l,1,gen,one,NULL)==BOUNCE_OK);CK(bounce_scene_bytes(s)==one);
 bounce_generation next=gen;next.material++;rejected(&s,v,a,&l,gen,BOUNCE_GENERATION);bounce_generation bad=next;bad.visibility.pose++;rejected(&s,v,a,&l,bad,BOUNCE_GENERATION);bad=next;bad.material=0;rejected(&s,v,a,&l,bad,BOUNCE_INVALID);
 for(int k=0;k<3;k++){a[0].padding[k]=1;CK(!bounce_scene_compact_required_bytes(a,2));rejected(&s,v,a,&l,next,BOUNCE_INVALID);a[0]=attr();}
 a[0].double_sided=2;CK(!bounce_scene_compact_required_bytes(a,2));rejected(&s,v,a,&l,next,BOUNCE_INVALID);a[0]=attr();
 float masks[]={NAN,INFINITY,-INFINITY};for(int i=0;i<3;i++){a[0].v[0].mask=masks[i];CK(!bounce_scene_compact_required_bytes(a,2));rejected(&s,v,a,&l,next,BOUNCE_INVALID);}a[0]=attr();
 for(int side=0;side<2;side++)for(int k=0;k<3;k++){int16_t *nn=side?a[0].v[0].back:a[0].v[0].front;nn[k]=INT16_MIN;CK(!bounce_scene_compact_required_bytes(a,2));rejected(&s,v,a,&l,next,BOUNCE_INVALID);a[0]=attr();}
 for(int side=0;side<2;side++){memset(side?a[0].v[0].back:a[0].v[0].front,0,6);CK(!bounce_scene_compact_required_bytes(a,2));rejected(&s,v,a,&l,next,BOUNCE_INVALID);a[0]=attr();}
 _Alignas(bounce_triangle) unsigned char unaligned[sizeof(a)+8];memcpy(unaligned+1,a,sizeof a);CK(!bounce_scene_compact_required_bytes((bounce_triangle*)(unaligned+1),2));rejected(&s,v,(bounce_triangle*)(unaligned+1),&l,next,BOUNCE_INVALID);
 bounce_scene *old=s;CK(bounce_scene_build_ground_compact(NULL,v,a,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(bounce_scene_build_ground_compact(&s,NULL,a,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(bounce_scene_build_ground_compact(&s,v,a,2,NULL,1,next,262144,NULL)==BOUNCE_INVALID);CK(bounce_scene_build_ground_compact(&s,v,a,2,&l,0,next,262144,NULL)==BOUNCE_INVALID);CK(s==old);
 /* Deliberate aliases use valid allocated objects and initialized scene slots. */
 union {bounce_triangle a[2];bounce_scene *slot;} alias;memset(&alias,0,sizeof alias);alias.slot=s;CK(bounce_scene_build_ground_compact(&alias.slot,v,alias.a,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(alias.slot==s);
 unsigned char saved[sizeof(void*)];memcpy(saved,&s->ground.le[0],sizeof saved);memcpy(&s->ground.le[0],&s,sizeof s);bounce_scene **ownedslot=(bounce_scene **)&s->ground.le[0];CK(bounce_scene_build_ground_compact(ownedslot,v,a,2,&l,1,next,262144,NULL)==BOUNCE_INVALID);CK(*ownedslot==s);memcpy(&s->ground.le[0],saved,sizeof saved);
 size_t vr=test_vis_refs(v,SIZE_MAX);rejected(&s,v,a,&l,next,BOUNCE_VISIBILITY);CK(test_vis_refs(v,vr)==SIZE_MAX);
 size_t br=s->refs;s->refs=SIZE_MAX;bounce_binding overflow={0};CK(bounce_binding_set(&overflow,s,gen)==BOUNCE_INVALID);CK(!overflow.scene);s->refs=br;
 bounce_binding retained={0};CK(bounce_binding_set(&retained,s,gen)==BOUNCE_OK);bounce_scene *probe=NULL;alloc_calls=0;CK(bounce_scene_build_ground_compact(&probe,v,a,2,&l,1,gen,262144,NULL)==BOUNCE_OK);size_t allocations=alloc_calls;bounce_scene_release(probe);CK(allocations>0);
 for(size_t i=1;i<=allocations;i++){alloc_calls=0;fail_at=i;rejected(&s,v,a,&l,next,BOUNCE_ALLOC);fail_at=0;vis_counters u[2];bounce_result r=evaluate(retained.scene,gen,2,16,u);CK(r.counters.primary_hits==16);}
 CK(bounce_scene_build_ground_compact(&s,v,a,2,&l,1,next,262144,NULL)==BOUNCE_OK);vis_counters u[2];bounce_result r=evaluate(retained.scene,gen,2,16,u);CK(r.counters.primary_hits==16);bounce_binding_clear(&retained);bounce_scene_release(s);vis_scene_release(v);
 /* Full 6144 unique vertices fit uint16 without accidental legacy byte admission. */
 size_t count=2048;bounce_triangle *large=malloc(count*sizeof(*large));CK(large);for(size_t i=0;i<count;i++){large[i]=attr();for(int j=0;j<3;j++)large[i].v[j].a565=(uint16_t)(i*3+j);}size_t need=bounce_scene_compact_required_bytes(large,count);CK(need==sizeof(bounce_scene)+count*8+count*3*20);CK(need>bounce_scene_required_bytes(count));v=geometry(count,1);s=NULL;CK(bounce_scene_build_ground_compact(&s,v,large,count,&l,1,gen,need-1,NULL)==BOUNCE_INVALID);CK(!s);CK(bounce_scene_build_ground_compact(&s,v,large,count,&l,1,gen,need,NULL)==BOUNCE_OK);CK(bounce_scene_bytes(s)==need);bounce_scene_release(s);vis_scene_release(v);free(large);
 /* Exact same-opt full result bytes and traversal counters across synthetic variants. */
 for(int variant=0;variant<12;variant++){v=geometry(2,variant==0?-1:1);a[0]=a[1]=attr();for(int t=0;t<2;t++)for(int j=0;j<3;j++){a[t].v[j].mask=variant%3==0?-1:variant%3==1?0:1;a[t].v[j].a565=(uint16_t)(0x0400+j*0x1000+t*3);a[t].v[j].b565=(uint16_t)(0x8000+j*0x0030+t*7);if(variant==4)a[t].v[j].back[2]=32767;if(variant==5)a[t].v[j].front[2]=-32767;if(variant==6)a[t].v[j].mask=j==0?-0.0f:0.0f;}if(variant==3)a[0].double_sided=a[1].double_sided=0;int sign=variant==5?-1:1;FoxDiskScene inputlights=l;bounce_scene *legacy=NULL,*compact=NULL;CK(bounce_scene_build(&legacy,v,a,2,&inputlights,sign,gen,262144)==BOUNCE_OK);CK(bounce_scene_build_ground_compact(&compact,v,a,2,&inputlights,sign,gen,262144,NULL)==BOUNCE_OK);memset(&inputlights,0xa5,sizeof inputlights);parity(legacy,compact,gen);memset(a,0xa5,sizeof a);vis_scene_release(v);parity(legacy,compact,gen);bounce_scene_release(legacy);bounce_scene_release(compact);}

 /* Ground descriptor ownership and mode 3 exact shading/work ledger parity. */
 for(int groundmode=1;groundmode<=3;groundmode++){
  v=geometry(2,1);a[0]=a[1]=attr();bounce_ground ground={0};ground.mode=(bounce_ground_mode)groundmode;ground.object_id=7;ground.triangle_count=2;ground.le[0]=.2;ground.le[1]=.4;ground.le[2]=.8;if(groundmode==3){ground.rho[0]=.3;ground.rho[1]=.5;ground.rho[2]=.7;}bounce_generation gg=gen;gg.emission=1;
  bounce_scene *ss[2]={0};CK(bounce_scene_build_ground(&ss[0],v,a,2,&l,1,gg,262144,&ground)==BOUNCE_OK);CK(bounce_scene_build_ground_compact(&ss[1],v,a,2,&l,1,gg,262144,&ground)==BOUNCE_OK);memset(&ground,0xa5,sizeof ground);memset(a,0xa5,sizeof a);vis_scene_release(v);
  if(groundmode<3)parity(ss[0],ss[1],gg);
  else {bounce_result rr[2];bounce_floor_world_result wr[2];bounce_floor_work fw[2];bounce_floor_world_work ww[2];vis_counters consumed[2][2];for(int x=0;x<2;x++){bounce_binding b={0};CK(bounce_binding_set(&b,ss[x],gg)==BOUNCE_OK);double p[]={0,0,0},nn[]={0,0,1},rho[]={.3,.6,.9};vis_budget db={{1000000,100000000,50000000},{0}},tb={{20000000,800000000,300000000},{0}};CK(bounce_floor_work_init(&fw[x],1,16)==BOUNCE_OK);CK(bounce_floor_world_work_init(&ww[x],1,16)==BOUNCE_OK);CK(bounce_eval_floor_world_experimental(&b,gg,p,nn,rho,BOUNCE_ONE,16,16,&db,&tb,&fw[x],&ww[x],&rr[x],&wr[x])==BOUNCE_OK);consumed[x][0]=db.used;consumed[x][1]=tb.used;bounce_binding_clear(&b);evals++;}CK(!memcmp(rr,rr+1,sizeof rr[0]));CK(!memcmp(wr,wr+1,sizeof wr[0]));CK(!memcmp(fw,fw+1,sizeof fw[0]));CK(!memcmp(ww,ww+1,sizeof ww[0]));CK(!memcmp(consumed,consumed+1,sizeof consumed[0]));CK(rr[0].counters.primary_ground_hits==16);}
  bounce_scene_release(ss[0]);bounce_scene_release(ss[1]);
 }
 CK(live==0);
 printf("PASS checks=%u evaluations=%u rejected_cases=%u calloc_failure_sites=%zu synthetic_variants=15 parity_pairs=157 calloc_live=0\n",checks,evals,failcases,allocations);return 0;
}
