#include "bounce.h"
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <stdint.h>
_Static_assert(sizeof(bounce_vertex)==20,"vertex ABI");
_Static_assert(sizeof(bounce_triangle)==64,"triangle ABI");
struct bounce_scene {
 size_t refs,bytes,count;
 bounce_generation generation;
 vis_binding geometry;
 FoxDiskScene lights;
 bounce_ground ground;
 int orientation_sign;
 bounce_triangle attrs[];
};
static int eq(bounce_generation a,bounce_generation b){return a.visibility.geometry==b.visibility.geometry && a.visibility.pose==b.visibility.pose && a.visibility.light==b.visibility.light && a.material==b.material && a.emission==b.emission;}
static int validgen(bounce_generation g){return g.visibility.geometry && g.visibility.pose && g.visibility.light && g.material;}
static int overlap(const void *a,size_t an,const void *b,size_t bn){if(!a||!b||!an||!bn)return 0;uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;if(an-1>UINTPTR_MAX-x||bn-1>UINTPTR_MAX-y)return 1;return x<=y?y-x<an:x-y<bn;}
static int owned(const bounce_scene *s,const void *p,size_t n){return s&&(overlap(s,s->bytes,p,n)||vis_scene_overlaps(s->geometry.scene,p,n));}
size_t bounce_scene_required_bytes(size_t n){return !n||n>BOUNCE_MAX_TRIANGLES?0:sizeof(bounce_scene)+n*sizeof(bounce_triangle);}
size_t bounce_scene_bytes(const bounce_scene *s){return s?s->bytes:0;}
bounce_status bounce_scene_retain(bounce_scene *s){if(!s||s->refs==SIZE_MAX)return BOUNCE_INVALID;++s->refs;return BOUNCE_OK;}
void bounce_scene_release(bounce_scene *s){if(s&&!--s->refs){vis_binding_clear(&s->geometry);free(s);}}
static double dot(const double a[3],const double b[3]){return a[0]*b[0]+a[1]*b[1]+a[2]*b[2];}
static int norm(const double n[3],double out[3]){double m=fmax(fabs(n[0]),fmax(fabs(n[1]),fabs(n[2])));if(!isfinite(n[0])||!isfinite(n[1])||!isfinite(n[2])||!(m>0))return 0;double t[3]={n[0]/m,n[1]/m,n[2]/m};double l=sqrt(dot(t,t));for(int k=0;k<3;k++)out[k]=t[k]/l;return 1;}
static double sn(int16_t x){return x==-32768?-1.0:x/32767.0;}
static int sameground_emission(const bounce_ground *a,const bounce_ground *b){return a->mode==b->mode && a->object_id==b->object_id && a->first_triangle==b->first_triangle && a->triangle_count==b->triangle_count && a->le[0]==b->le[0] && a->le[1]==b->le[1] && a->le[2]==b->le[2];}
static int samerho(const bounce_ground *a,const bounce_ground *b){return a->rho[0]==b->rho[0]&&a->rho[1]==b->rho[1]&&a->rho[2]==b->rho[2];}
static int sameground(const bounce_ground *a,const bounce_ground *b){return sameground_emission(a,b)&&samerho(a,b);}
static int isground(const bounce_scene *s,uint32_t ordinal){return s->ground.mode!=BOUNCE_GROUND_OFF && ordinal>=s->ground.first_triangle && ordinal-s->ground.first_triangle<s->ground.triangle_count;}
bounce_status bounce_scene_build(bounce_scene **slot,vis_scene *geometry,const bounce_triangle *a,size_t n,const FoxDiskScene *lights,int sign,bounce_generation g,size_t max_bytes){
 return bounce_scene_build_ground(slot,geometry,a,n,lights,sign,g,max_bytes,NULL);
}
bounce_status bounce_scene_build_ground(bounce_scene **slot,vis_scene *geometry,const bounce_triangle *a,size_t n,const FoxDiskScene *lights,int sign,bounce_generation g,size_t max_bytes,const bounce_ground *ground){
 if(!slot||!geometry||!a||!lights||!validgen(g)||!(sign==1||sign==-1))return BOUNCE_INVALID;
 bounce_ground gr={0};if(ground)gr=*ground;
 if(gr.mode<BOUNCE_GROUND_OFF||gr.mode>BOUNCE_GROUND_PRIMARY_LE_DIRECT)return BOUNCE_INVALID;
 for(int k=0;k<3;k++)if(!isfinite(gr.le[k])||gr.le[k]<0||!isfinite(gr.rho[k])||gr.rho[k]<0||gr.rho[k]>1||(gr.mode!=BOUNCE_GROUND_PRIMARY_LE_DIRECT&&gr.rho[k]!=0))return BOUNCE_INVALID;
 if(gr.mode==BOUNCE_GROUND_OFF){bounce_ground canonical={0};if(!sameground(&gr,&canonical))return BOUNCE_INVALID;}
 else if(!g.emission||!gr.object_id||!gr.triangle_count||gr.first_triangle>=n||gr.triangle_count>n-gr.first_triangle)return BOUNCE_INVALID;
 if(ground&&overlap(ground,sizeof(*ground),slot,sizeof(*slot)))return BOUNCE_INVALID;
 size_t bytes=bounce_scene_required_bytes(n);if(!bytes||bytes>262144||bytes>max_bytes||n!=vis_scene_triangle_count(geometry))return BOUNCE_INVALID;
 if(owned(*slot,slot,sizeof(*slot))||vis_scene_overlaps(geometry,slot,sizeof(*slot))||overlap(a,n*sizeof(*a),slot,sizeof(*slot))||overlap(lights,sizeof(*lights),slot,sizeof(*slot)))return BOUNCE_INVALID;
 vis_generation vg=vis_scene_generation(geometry);if(vg.geometry!=g.visibility.geometry||vg.pose!=g.visibility.pose||vg.light!=g.visibility.light)return BOUNCE_GENERATION;
 if(*slot){bounce_generation o=(*slot)->generation;if(g.visibility.geometry<o.visibility.geometry||g.visibility.pose<o.visibility.pose||g.visibility.light<o.visibility.light||g.material<o.material||g.emission<o.emission||(!sameground_emission(&gr,&(*slot)->ground)&&g.emission<=o.emission)||(!samerho(&gr,&(*slot)->ground)&&g.material<=o.material)||eq(g,o))return BOUNCE_GENERATION;}
 if(fox_disk_scene_validate(lights)!=FOX_DISK_OK)return BOUNCE_INVALID;
 for(size_t i=0;i<n;i++){if(a[i].double_sided>1||a[i].padding[0]||a[i].padding[1]||a[i].padding[2])return BOUNCE_INVALID;for(int v=0;v<3;v++){if(!isfinite(a[i].v[v].mask))return BOUNCE_INVALID;for(int side=0;side<2;side++){const int16_t *q=side?a[i].v[v].back:a[i].v[v].front;if(q[0]==INT16_MIN||q[1]==INT16_MIN||q[2]==INT16_MIN||!(q[0]||q[1]||q[2]))return BOUNCE_INVALID;}}}
 bounce_scene *s=calloc(1,bytes);if(!s)return BOUNCE_ALLOC;
 s->refs=1;s->bytes=bytes;s->count=n;s->generation=g;s->lights=*lights;s->ground=gr;s->orientation_sign=sign;memcpy(s->attrs,a,n*sizeof(*a));
 if(vis_binding_set(&s->geometry,geometry,g.visibility)!=VIS_OK){free(s);return BOUNCE_VISIBILITY;}
 bounce_scene *old=*slot;*slot=s;bounce_scene_release(old);return BOUNCE_OK;
}
bounce_status bounce_binding_set(bounce_binding *b,bounce_scene *s,bounce_generation g){if(!b||!s||owned(s,b,sizeof(*b))||owned(b->scene,b,sizeof(*b)))return BOUNCE_INVALID;if(!eq(g,s->generation))return BOUNCE_GENERATION;bounce_status st=bounce_scene_retain(s);if(st)return st;bounce_scene *old=b->scene;b->scene=s;b->generation=g;bounce_scene_release(old);return BOUNCE_OK;}
void bounce_binding_clear(bounce_binding *b){if(b&&!owned(b->scene,b,sizeof(*b))){bounce_scene *s=b->scene;memset(b,0,sizeof(*b));bounce_scene_release(s);}}
static bounce_status vst(vis_status v){return v==VIS_BUDGET?BOUNCE_BUDGET:v==VIS_GENERATION?BOUNCE_GENERATION:BOUNCE_VISIBILITY;}
typedef struct {const bounce_scene *s;vis_budget *budget; bounce_status failure;uint64_t *queries;} direct_context;
static bool visible(void *ptr,const double p[3],const double normal[3],const double q[3],bool *result){(void)normal;direct_context *c=ptr;int occ;(*c->queries)++;vis_status v=vis_segment_occluded(&c->s->geometry,c->s->generation.visibility,p,q,c->budget,&occ);if(v!=VIS_OK){c->failure=vst(v);return false;}*result=!occ;return true;}
static void cross(const double a[3],const double b[3],double r[3]){r[0]=a[1]*b[2]-a[2]*b[1];r[1]=a[2]*b[0]-a[0]*b[2];r[2]=a[0]*b[1]-a[1]*b[0];}
static void direction(const double n[3],unsigned count,unsigned idx,double d[3]){
 unsigned m=count==16?2:4,az=idx%(4*m),ring=idx/(4*m);double r=sqrt((ring+.5)/m),phi=6.283185307179586476925286766559*(az+.5*(ring%2))/(4*m);
 double ref[3]={0,0,0},u[3],v[3];int axis=0;if(fabs(n[1])<fabs(n[axis]))axis=1;if(fabs(n[2])<fabs(n[axis]))axis=2;ref[axis]=1;cross(ref,n,u);norm(u,u);cross(n,u,v);
 for(int k=0;k<3;k++)d[k]=r*cos(phi)*u[k]+r*sin(phi)*v[k]+sqrt(1-r*r)*n[k];
 norm(d,d);
}
static float decode(float x){return x<=.04045f?x/12.92f:powf((x+.055f)/1.055f,2.4f);}
static bounce_status hit_material(const bounce_scene *s,const vis_hit *hit,const double incoming[3],double ns[3],double rho[3],int *reflect,bounce_counters *c){
 if(hit->triangle_ordinal>=s->count)return BOUNCE_INVALID;
 const bounce_triangle *a=s->attrs+hit->triangle_ordinal;
 double ngv=-s->orientation_sign*dot(hit->geometric_normal,incoming);if(fabs(ngv)<=1e-12)c->grazing_ng_v++;
 int front=ngv>=0;*reflect=0;if(!front&&!a->double_sided){c->back_single_discard++;return BOUNCE_OK;}
 double mask=0,n[3]={0,0,0};for(int j=0;j<3;j++){mask+=hit->bary[j]*a->v[j].mask;const int16_t *nn=front?a->v[j].front:a->v[j].back;for(int k=0;k<3;k++)n[k]+=hit->bary[j]*sn(nn[k]);}
 if(!norm(n,ns))return BOUNCE_INVALID;
 if(-dot(ns,incoming)<=0){c->zero_reflection_ns_v++;return BOUNCE_OK;}
 for(int k=0;k<3;k++)rho[k]=0;
 for(int j=0;j<3;j++){uint16_t q=mask>=0?a->v[j].b565:a->v[j].a565;float rgb[3]={decode((q>>11)/31.0f),decode(((q>>5)&63)/63.0f),decode((q&31)/31.0f)};for(int k=0;k<3;k++)rho[k]+=hit->bary[j]*rgb[k];}
 for(int k=0;k<3;k++){if(!isfinite(rho[k])||rho[k]<-1e-12||rho[k]>1+1e-12)return BOUNCE_INVALID;rho[k]=fmax(0,fmin(1,rho[k]));}*reflect=1;return BOUNCE_OK;
}
static bounce_status world_visible(const bounce_scene *s,const double p[3],const double n[3],unsigned count,vis_budget *budget,double out[3],bounce_counters *c){
 unsigned misses=0;for(unsigned j=0;j<count;j++){double d[3];direction(n,count,j,d);vis_hit h; c->secondary_world_rays++;vis_status v=vis_ray_nearest(&s->geometry,s->generation.visibility,p,d,budget,&h);if(v!=VIS_OK)return vst(v);if(!h.found)misses++;else if(isground(s,h.triangle_ordinal))c->secondary_ground_hits++;}for(int k=0;k<3;k++)out[k]=s->lights.world_radiance[k]*((double)misses/count);return BOUNCE_OK;
}
/* Costs are fixed admitted source-level reservations, never elapsed work or
 * machine instructions. All per-evaluator sample/callback work is prepaid. */
static const uint64_t fw_shader[BOUNCE_FW_COUNT]={64,64,0,0,0,0,0,0,0,0};
static const uint64_t fw_hit[BOUNCE_FW_COUNT]={0,0,128,0,0,0,0,0,0,64};
static const uint64_t fw_eval[BOUNCE_FW_COUNT]={0,0,0,768,288,6144,4608,128,64,0};
static const char *const fw_names[BOUNCE_FW_COUNT]={"shaderDescriptor","shaderResultMerge","floorEligibilityNormal","diskAdmission","diskReceiverSetup","diskSampleKernels","diskSampleControlCallback","diskReductionOutput","floorAccumulationCounters","floorLedgerGuards"};
const char *bounce_floor_work_category_name(unsigned k){return k<BOUNCE_FW_COUNT?fw_names[k]:"invalid";}
size_t bounce_floor_work_bytes(void){return sizeof(bounce_floor_work);}
static int fw_valid(const bounce_floor_work *w){
 if(!w||!w->shader_limit||w->shader_limit>BOUNCE_FLOOR_MAX_SHADERS||w->floor_hit_limit>BOUNCE_FLOOR_MAX_HITS||w->limit_total>BOUNCE_FLOOR_WORK_CAP||w->used_total>w->limit_total||w->shader_calls>w->shader_limit||w->floor_hits>w->floor_hit_limit||w->evaluations>w->floor_hits||w->zero_rho_hits>w->floor_hits||w->tangent_hits>w->floor_hits-w->zero_rho_hits||w->evaluations>w->floor_hits-w->zero_rho_hits-w->tangent_hits)return 0;
 uint64_t sum=0,cap=0;
 for(unsigned k=0;k<BOUNCE_FW_COUNT;k++){uint64_t bound=fw_shader[k]*w->shader_limit+(fw_hit[k]+fw_eval[k])*w->floor_hit_limit;if(w->limit[k]>bound||w->used[k]>w->limit[k])return 0;sum+=w->used[k];cap+=bound;}
 return sum==w->used_total&&w->limit_total<=cap;
}
bounce_status bounce_floor_work_init(bounce_floor_work *w,uint64_t shaders,uint64_t hits){
 if(!w||!shaders||shaders>BOUNCE_FLOOR_MAX_SHADERS||hits>BOUNCE_FLOOR_MAX_HITS)return BOUNCE_INVALID;
 bounce_floor_work v={0};v.shader_limit=shaders;v.floor_hit_limit=hits;
 for(unsigned k=0;k<BOUNCE_FW_COUNT;k++){v.limit[k]=fw_shader[k]*shaders+(fw_hit[k]+fw_eval[k])*hits;v.limit_total+=v.limit[k];}*w=v;return BOUNCE_OK;
}
static bounce_status fw_pay(bounce_floor_work *w,const uint64_t costs[BOUNCE_FW_COUNT],unsigned phase){
 uint64_t total=0;for(unsigned k=0;k<BOUNCE_FW_COUNT;k++){if(costs[k]>w->limit[k]-w->used[k])return BOUNCE_BUDGET;total+=costs[k];}
 if(total>w->limit_total-w->used_total||(phase==0&&w->shader_calls==w->shader_limit)||(phase==1&&w->floor_hits==w->floor_hit_limit))return BOUNCE_BUDGET;
 for(unsigned k=0;k<BOUNCE_FW_COUNT;k++)w->used[k]+=costs[k];
 w->used_total+=total;
 if(phase==0)w->shader_calls++;else if(phase==1)w->floor_hits++;else w->evaluations++;
 return BOUNCE_OK;
}
static int floor_normal(const double ng[3],const double incoming[3],double out[3]){
 for(int k=0;k<3;k++)if(!isfinite(ng[k])||!isfinite(incoming[k]))return -1;
 if(fabs(dot(ng,ng)-1)>1e-10)return -1;
 double incidence=dot(ng,incoming);if(!isfinite(incidence))return -1;
 if(incidence==0)return 0;
 for(int k=0;k<3;k++)out[k]=incidence<0?ng[k]:-ng[k];
 return 1;
}

/* Conservative source-level reservations include math calls as opaque kernels;
 * they do not assert a machine-instruction or old 8M renderer-work admission. */
bounce_status bounce_floor_world_work_init(bounce_floor_world_work *w,uint64_t shaders,uint64_t hits){
 if(!w||!shaders||shaders>BOUNCE_FLOOR_MAX_SHADERS||hits>BOUNCE_FLOOR_MAX_HITS)return BOUNCE_INVALID;
 bounce_floor_world_work v={0};v.shader_limit=shaders;v.hit_limit=hits;
 v.work_limit=shaders*BOUNCE_FLOOR_WORLD_SHADER_WORK+hits*BOUNCE_FLOOR_WORLD_HIT_WORK;*w=v;return BOUNCE_OK;
}
static int fww_valid(const bounce_floor_world_work *w){
 if(!w||!w->shader_limit||w->shader_limit>BOUNCE_FLOOR_MAX_SHADERS||w->hit_limit>BOUNCE_FLOOR_MAX_HITS||w->shader_calls>w->shader_limit||w->evaluations>w->hit_limit)return 0;
 uint64_t cap=w->shader_limit*BOUNCE_FLOOR_WORLD_SHADER_WORK+w->hit_limit*BOUNCE_FLOOR_WORLD_HIT_WORK;
 if(w->work_limit>cap||w->work_used>w->work_limit||w->work_used!=w->shader_calls*BOUNCE_FLOOR_WORLD_SHADER_WORK+w->evaluations*BOUNCE_FLOOR_WORLD_HIT_WORK)return 0;
 if(w->queries>w->evaluations*16||w->visibility_used.rays>w->queries||w->misses>w->visibility_used.rays||w->blocked_floor>w->visibility_used.rays-w->misses||w->blocked_character>w->visibility_used.rays-w->misses-w->blocked_floor)return 0;
 return w->visibility_used.node_visits<=UINT64_C(800000000)&&w->visibility_used.triangle_tests<=UINT64_C(300000000);
}
static bounce_status fww_pay(bounce_floor_world_work *w,int hit){
 uint64_t cost=hit?BOUNCE_FLOOR_WORLD_HIT_WORK:BOUNCE_FLOOR_WORLD_SHADER_WORK;
 if(cost>w->work_limit-w->work_used||(hit?w->evaluations==w->hit_limit:w->shader_calls==w->shader_limit))return BOUNCE_BUDGET;
 w->work_used+=cost;if(hit)w->evaluations++;else w->shader_calls++;return BOUNCE_OK;
}
static int fww_budget_valid(const vis_budget *b,vis_counters cap){
 return b->limit.rays<=cap.rays&&b->limit.node_visits<=cap.node_visits&&b->limit.triangle_tests<=cap.triangle_tests&&b->used.rays<=b->limit.rays&&b->used.node_visits<=b->limit.node_visits&&b->used.triangle_tests<=b->limit.triangle_tests;
}
static bounce_status floor_world_visible(const bounce_scene *s,const double p[3],const double n[3],vis_budget *budget,bounce_floor_world_work *w,double out[3]){
 bounce_status st=fww_pay(w,1);if(st)return st;
 unsigned misses=0;
 for(unsigned j=0;j<BOUNCE_FLOOR_WORLD_SAMPLES;j++){
  double d[3];direction(n,BOUNCE_FLOOR_WORLD_SAMPLES,j,d);vis_hit h;
  vis_counters before=budget->used;w->queries++;
  vis_status v=vis_ray_nearest(&s->geometry,s->generation.visibility,p,d,budget,&h);
  w->visibility_used.rays+=budget->used.rays-before.rays;
  w->visibility_used.node_visits+=budget->used.node_visits-before.node_visits;
  w->visibility_used.triangle_tests+=budget->used.triangle_tests-before.triangle_tests;
  if(v!=VIS_OK)return vst(v);
  if(!h.found){misses++;w->misses++;}else if(isground(s,h.triangle_ordinal))w->blocked_floor++;else w->blocked_character++;
 }
 for(int k=0;k<3;k++)out[k]=s->lights.world_radiance[k]*((double)misses/BOUNCE_FLOOR_WORLD_SAMPLES);
 return BOUNCE_OK;
}
static bounce_status bounce_eval_impl(const bounce_binding *b,bounce_generation g,const double p[3],const double normal[3],const double rho[3],bounce_mode mode,unsigned outer,unsigned inner,vis_budget *direct_budget,vis_budget *budget,bounce_floor_work *work,int experimental,bounce_floor_world_work *ww,bounce_floor_world_result *wo,bounce_result *out){
 if(!b||!b->scene||!p||!normal||!rho||!direct_budget||!budget||!out||mode<BOUNCE_OFF||mode>BOUNCE_ONE||(outer!=16&&outer!=64)||(inner!=16&&inner!=64))return BOUNCE_INVALID;
 const bounce_scene *s=b->scene;if(!eq(g,b->generation)||!eq(g,s->generation))return BOUNCE_GENERATION;
 if(s->ground.mode==BOUNCE_GROUND_PRIMARY_LE_DIRECT&&(!experimental||mode!=BOUNCE_ONE))return BOUNCE_INVALID;
 if(owned(s,out,sizeof(*out))||owned(s,direct_budget,sizeof(*direct_budget))||overlap(out,sizeof(*out),direct_budget,sizeof(*direct_budget))||overlap(direct_budget,sizeof(*direct_budget),budget,sizeof(*budget))||owned(s,budget,sizeof(*budget))||overlap(out,sizeof(*out),budget,sizeof(*budget))||overlap(out,sizeof(*out),b,sizeof(*b)))return BOUNCE_INVALID;
 if(overlap(direct_budget,sizeof(*direct_budget),b,sizeof(*b))||overlap(budget,sizeof(*budget),b,sizeof(*b)))return BOUNCE_INVALID;
 const double *inputs[3]={p,normal,rho};
 for(int i=0;i<3;i++)if(overlap(direct_budget,sizeof(*direct_budget),inputs[i],3*sizeof(double))||overlap(budget,sizeof(*budget),inputs[i],3*sizeof(double)))return BOUNCE_INVALID;
 if(ww||wo){
  if(!ww||!wo||!experimental||!work||s->ground.mode!=BOUNCE_GROUND_PRIMARY_LE_DIRECT||mode!=BOUNCE_ONE||outer!=16||inner!=16)return BOUNCE_INVALID;
  const void *ptrs[]={ww,wo,out,work,b,direct_budget,budget,p,normal,rho};
  const size_t sizes[]={sizeof*ww,sizeof*wo,sizeof*out,sizeof*work,sizeof*b,sizeof*direct_budget,sizeof*budget,3*sizeof(double),3*sizeof(double),3*sizeof(double)};
  for(unsigned i=0;i<2;i++){if(owned(s,ptrs[i],sizes[i]))return BOUNCE_INVALID;for(unsigned j=i+1;j<10;j++)if(overlap(ptrs[i],sizes[i],ptrs[j],sizes[j]))return BOUNCE_INVALID;}
  if(!fww_valid(ww)||!fww_budget_valid(direct_budget,(vis_counters){1000000,100000000,50000000})||!fww_budget_valid(budget,(vis_counters){20000000,800000000,300000000}))return BOUNCE_INVALID;
  bounce_status st=fww_pay(ww,0);if(st)return st;
 }
 if(experimental){
  if(!work||owned(s,work,sizeof(*work))||overlap(work,sizeof(*work),b,sizeof(*b))||overlap(work,sizeof(*work),out,sizeof(*out))||overlap(work,sizeof(*work),direct_budget,sizeof(*direct_budget))||overlap(work,sizeof(*work),budget,sizeof(*budget)))return BOUNCE_INVALID;
  for(int i=0;i<3;i++)if(overlap(work,sizeof(*work),inputs[i],3*sizeof(double)))return BOUNCE_INVALID;
  if(!fw_valid(work))return BOUNCE_INVALID;
  bounce_status st=fw_pay(work,fw_shader,0);if(st)return st;
 }
 double n[3];if(!norm(normal,n))return BOUNCE_INVALID;for(int k=0;k<3;k++)if(!isfinite(p[k])||!isfinite(rho[k])||rho[k]<0||rho[k]>1)return BOUNCE_INVALID;
 bounce_floor_world_result world_result={0};
 bounce_result result={0};FoxDiskScene direct=s->lights;memset(direct.world_radiance,0,sizeof(direct.world_radiance));direct_context ctx={s,direct_budget,BOUNCE_OK,&result.counters.primary_direct_queries};
 FoxDiskStatus fs=fox_disk_eval16_visible(&direct,p,n,rho,visible,&ctx,result.direct);if(fs!=FOX_DISK_OK)return ctx.failure?ctx.failure:BOUNCE_LIGHTING;
 if(mode==BOUNCE_OFF){for(int k=0;k<3;k++)result.world[k]=rho[k]*s->lights.world_radiance[k];}
 else for(unsigned j=0;j<outer;j++){
  double d[3];direction(n,outer,j,d);vis_hit h;result.counters.primary_rays++;vis_status v=vis_ray_nearest(&s->geometry,g.visibility,p,d,budget,&h);if(v!=VIS_OK)return vst(v);
  if(!h.found){result.counters.primary_misses++;for(int k=0;k<3;k++)result.world[k]+=rho[k]*s->lights.world_radiance[k]/outer;continue;}result.counters.primary_hits++;
  if(isground(s,h.triangle_ordinal)){
   if(work){bounce_status st=fw_pay(work,fw_hit,1);if(st)return st;}
   result.counters.primary_ground_hits++;
   if(s->ground.mode==BOUNCE_GROUND_PRIMARY_LE||s->ground.mode==BOUNCE_GROUND_PRIMARY_LE_DIRECT){result.counters.primary_ground_emission_hits++;for(int k=0;k<3;k++)result.ground[k]+=rho[k]*s->ground.le[k]/outer;}
   if(s->ground.mode==BOUNCE_GROUND_PRIMARY_LE_DIRECT){
    if(s->ground.rho[0]==0&&s->ground.rho[1]==0&&s->ground.rho[2]==0){work->zero_rho_hits++;continue;}
    double ng[3],floor_direct[3];int reflects=floor_normal(h.geometric_normal,d,ng);if(reflects<0)return BOUNCE_INVALID;
    if(!reflects){work->tangent_hits++;continue;}
    bounce_status st=fw_pay(work,fw_eval,2);if(st)return st;
    result.counters.primary_ground_reflection_hits++;
    ctx.budget=budget;ctx.queries=&result.counters.primary_ground_direct_queries;
    fs=fox_disk_eval16_visible(&direct,h.position,ng,s->ground.rho,visible,&ctx,floor_direct);if(fs!=FOX_DISK_OK)return ctx.failure?ctx.failure:BOUNCE_LIGHTING;
    for(int k=0;k<3;k++)result.ground_reflected[k]+=rho[k]*floor_direct[k]/outer;
    if(ww){
     double floor_world[3];st=floor_world_visible(s,h.position,ng,budget,ww,floor_world);if(st)return st;
     for(int k=0;k<3;k++)world_result.reflected_world[k]+=rho[k]*s->ground.rho[k]*floor_world[k]/outer;
    }
   }
   continue;
  }
  if(mode!=BOUNCE_ONE)continue;
  double ns[3],ry[3],secondary[3],world[3];int reflect;bounce_status st=hit_material(s,&h,d,ns,ry,&reflect,&result.counters);if(st)return st;if(!reflect)continue;
  ctx.budget=budget;ctx.queries=&result.counters.secondary_direct_queries;fs=fox_disk_eval16_visible(&direct,h.position,ns,ry,visible,&ctx,secondary);if(fs!=FOX_DISK_OK)return ctx.failure?ctx.failure:BOUNCE_LIGHTING;
  st=world_visible(s,h.position,ns,inner,budget,world,&result.counters);if(st)return st;
  for(int k=0;k<3;k++)result.bounce[k]+=rho[k]*(secondary[k]+ry[k]*world[k])/outer;
 }
 for(int k=0;k<3;k++){result.combined[k]=result.direct[k]+result.world[k]+result.bounce[k];if(s->ground.mode!=BOUNCE_GROUND_OFF)result.combined[k]+=result.ground[k];if(result.counters.primary_ground_reflection_hits)result.combined[k]+=result.ground_reflected[k];if(ww)result.combined[k]+=world_result.reflected_world[k];if(!isfinite(result.combined[k])||result.combined[k]<0)return BOUNCE_INVALID;}
 *out=result;if(wo)*wo=world_result;return BOUNCE_OK;
}
bounce_status bounce_eval(const bounce_binding *b,bounce_generation g,const double p[3],const double n[3],const double rho[3],bounce_mode mode,unsigned outer,unsigned inner,vis_budget *db,vis_budget *tb,bounce_result *out){return bounce_eval_impl(b,g,p,n,rho,mode,outer,inner,db,tb,NULL,0,NULL,NULL,out);}
bounce_status bounce_eval_floor_experimental(const bounce_binding *b,bounce_generation g,const double p[3],const double n[3],const double rho[3],bounce_mode mode,unsigned outer,unsigned inner,vis_budget *db,vis_budget *tb,bounce_floor_work *work,bounce_result *out){return bounce_eval_impl(b,g,p,n,rho,mode,outer,inner,db,tb,work,1,NULL,NULL,out);}
const char *bounce_status_string(bounce_status s){switch(s){case BOUNCE_OK:return "ok";case BOUNCE_INVALID:return "invalid";case BOUNCE_ALLOC:return "allocation";case BOUNCE_GENERATION:return "generation";case BOUNCE_BUDGET:return "budget";case BOUNCE_VISIBILITY:return "visibility";case BOUNCE_LIGHTING:return "lighting";default:return "unknown";}}

int bounce_scene_overlaps(const bounce_scene *s,const void *p,size_t n){return owned(s,p,n);}
int bounce_scene_matches_lights(const bounce_scene *s,const FoxDiskScene *l){
 if(!s||!l||fox_disk_scene_validate(l)!=FOX_DISK_OK)return 0;
 for(int k=0;k<3;k++)if(s->lights.world_radiance[k]!=l->world_radiance[k])return 0;
 for(int i=0;i<FOX_DISK_LIGHT_COUNT;i++){
  const FoxDiskLight *a=&s->lights.lights[i],*b=&l->lights[i];
  if(a->radius!=b->radius)return 0;
  for(int k=0;k<3;k++)if(a->center[k]!=b->center[k]||a->normal[k]!=b->normal[k]||a->axis_u[k]!=b->axis_u[k]||a->axis_v[k]!=b->axis_v[k]||a->power_rgb_over_pi_squared[k]!=b->power_rgb_over_pi_squared[k])return 0;
 }return 1;
}

int bounce_scene_matches_ground(const bounce_scene *s,const bounce_ground *g){bounce_ground off={0};return s&&sameground(&s->ground,g?g:&off);}

bounce_status bounce_eval_floor_world_experimental(const bounce_binding *b,bounce_generation g,const double p[3],const double n[3],const double rho[3],bounce_mode mode,unsigned outer,unsigned inner,vis_budget *db,vis_budget *tb,bounce_floor_work *work,bounce_floor_world_work *ww,bounce_result *out,bounce_floor_world_result *wo){
 if(!ww||!wo)return BOUNCE_INVALID;
 return bounce_eval_impl(b,g,p,n,rho,mode,outer,inner,db,tb,work,1,ww,wo,out);
}
