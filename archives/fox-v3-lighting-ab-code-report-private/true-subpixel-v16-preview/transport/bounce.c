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
static int sameground(const bounce_ground *a,const bounce_ground *b){return a->mode==b->mode && a->object_id==b->object_id && a->first_triangle==b->first_triangle && a->triangle_count==b->triangle_count && a->le[0]==b->le[0] && a->le[1]==b->le[1] && a->le[2]==b->le[2];}
static int isground(const bounce_scene *s,uint32_t ordinal){return s->ground.mode!=BOUNCE_GROUND_OFF && ordinal>=s->ground.first_triangle && ordinal-s->ground.first_triangle<s->ground.triangle_count;}
bounce_status bounce_scene_build(bounce_scene **slot,vis_scene *geometry,const bounce_triangle *a,size_t n,const FoxDiskScene *lights,int sign,bounce_generation g,size_t max_bytes){
 return bounce_scene_build_ground(slot,geometry,a,n,lights,sign,g,max_bytes,NULL);
}
bounce_status bounce_scene_build_ground(bounce_scene **slot,vis_scene *geometry,const bounce_triangle *a,size_t n,const FoxDiskScene *lights,int sign,bounce_generation g,size_t max_bytes,const bounce_ground *ground){
 if(!slot||!geometry||!a||!lights||!validgen(g)||!(sign==1||sign==-1))return BOUNCE_INVALID;
 bounce_ground gr={0};if(ground)gr=*ground;
 if(gr.mode<BOUNCE_GROUND_OFF||gr.mode>BOUNCE_GROUND_PRIMARY_LE)return BOUNCE_INVALID;
 for(int k=0;k<3;k++)if(!isfinite(gr.le[k])||gr.le[k]<0)return BOUNCE_INVALID;
 if(gr.mode==BOUNCE_GROUND_OFF){bounce_ground canonical={0};if(!sameground(&gr,&canonical))return BOUNCE_INVALID;}
 else if(!g.emission||!gr.object_id||!gr.triangle_count||gr.first_triangle>=n||gr.triangle_count>n-gr.first_triangle)return BOUNCE_INVALID;
 if(ground&&overlap(ground,sizeof(*ground),slot,sizeof(*slot)))return BOUNCE_INVALID;
 size_t bytes=bounce_scene_required_bytes(n);if(!bytes||bytes>262144||bytes>max_bytes||n!=vis_scene_triangle_count(geometry))return BOUNCE_INVALID;
 if(owned(*slot,slot,sizeof(*slot))||vis_scene_overlaps(geometry,slot,sizeof(*slot))||overlap(a,n*sizeof(*a),slot,sizeof(*slot))||overlap(lights,sizeof(*lights),slot,sizeof(*slot)))return BOUNCE_INVALID;
 vis_generation vg=vis_scene_generation(geometry);if(vg.geometry!=g.visibility.geometry||vg.pose!=g.visibility.pose||vg.light!=g.visibility.light)return BOUNCE_GENERATION;
 if(*slot){bounce_generation o=(*slot)->generation;if(g.visibility.geometry<o.visibility.geometry||g.visibility.pose<o.visibility.pose||g.visibility.light<o.visibility.light||g.material<o.material||g.emission<o.emission||(!sameground(&gr,&(*slot)->ground)&&g.emission<=o.emission)||eq(g,o))return BOUNCE_GENERATION;}
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
bounce_status bounce_eval(const bounce_binding *b,bounce_generation g,const double p[3],const double normal[3],const double rho[3],bounce_mode mode,unsigned outer,unsigned inner,vis_budget *direct_budget,vis_budget *budget,bounce_result *out){
 if(!b||!b->scene||!p||!normal||!rho||!direct_budget||!budget||!out||mode<BOUNCE_OFF||mode>BOUNCE_ONE||(outer!=16&&outer!=64)||(inner!=16&&inner!=64))return BOUNCE_INVALID;
 const bounce_scene *s=b->scene;if(!eq(g,b->generation)||!eq(g,s->generation))return BOUNCE_GENERATION;
 if(owned(s,out,sizeof(*out))||owned(s,direct_budget,sizeof(*direct_budget))||overlap(out,sizeof(*out),direct_budget,sizeof(*direct_budget))||overlap(direct_budget,sizeof(*direct_budget),budget,sizeof(*budget))||owned(s,budget,sizeof(*budget))||overlap(out,sizeof(*out),budget,sizeof(*budget))||overlap(out,sizeof(*out),b,sizeof(*b)))return BOUNCE_INVALID;
 if(overlap(direct_budget,sizeof(*direct_budget),b,sizeof(*b))||overlap(budget,sizeof(*budget),b,sizeof(*b)))return BOUNCE_INVALID;
 const double *inputs[3]={p,normal,rho};
 for(int i=0;i<3;i++)if(overlap(direct_budget,sizeof(*direct_budget),inputs[i],3*sizeof(double))||overlap(budget,sizeof(*budget),inputs[i],3*sizeof(double)))return BOUNCE_INVALID;
 double n[3];if(!norm(normal,n))return BOUNCE_INVALID;for(int k=0;k<3;k++)if(!isfinite(p[k])||!isfinite(rho[k])||rho[k]<0||rho[k]>1)return BOUNCE_INVALID;
 bounce_result result={0};FoxDiskScene direct=s->lights;memset(direct.world_radiance,0,sizeof(direct.world_radiance));direct_context ctx={s,direct_budget,BOUNCE_OK,&result.counters.primary_direct_queries};
 FoxDiskStatus fs=fox_disk_eval16_visible(&direct,p,n,rho,visible,&ctx,result.direct);if(fs!=FOX_DISK_OK)return ctx.failure?ctx.failure:BOUNCE_LIGHTING;
 if(mode==BOUNCE_OFF){for(int k=0;k<3;k++)result.world[k]=rho[k]*s->lights.world_radiance[k];}
 else for(unsigned j=0;j<outer;j++){
  double d[3];direction(n,outer,j,d);vis_hit h;result.counters.primary_rays++;vis_status v=vis_ray_nearest(&s->geometry,g.visibility,p,d,budget,&h);if(v!=VIS_OK)return vst(v);
  if(!h.found){result.counters.primary_misses++;for(int k=0;k<3;k++)result.world[k]+=rho[k]*s->lights.world_radiance[k]/outer;continue;}result.counters.primary_hits++;
  if(isground(s,h.triangle_ordinal)){
   result.counters.primary_ground_hits++;
   if(s->ground.mode==BOUNCE_GROUND_PRIMARY_LE){result.counters.primary_ground_emission_hits++;for(int k=0;k<3;k++)result.ground[k]+=rho[k]*s->ground.le[k]/outer;}
   continue;
  }
  if(mode!=BOUNCE_ONE)continue;
  double ns[3],ry[3],secondary[3],world[3];int reflect;bounce_status st=hit_material(s,&h,d,ns,ry,&reflect,&result.counters);if(st)return st;if(!reflect)continue;
  ctx.budget=budget;ctx.queries=&result.counters.secondary_direct_queries;fs=fox_disk_eval16_visible(&direct,h.position,ns,ry,visible,&ctx,secondary);if(fs!=FOX_DISK_OK)return ctx.failure?ctx.failure:BOUNCE_LIGHTING;
  st=world_visible(s,h.position,ns,inner,budget,world,&result.counters);if(st)return st;
  for(int k=0;k<3;k++)result.bounce[k]+=rho[k]*(secondary[k]+ry[k]*world[k])/outer;
 }
 for(int k=0;k<3;k++){result.combined[k]=result.direct[k]+result.world[k]+result.bounce[k];if(s->ground.mode!=BOUNCE_GROUND_OFF)result.combined[k]+=result.ground[k];if(!isfinite(result.combined[k])||result.combined[k]<0)return BOUNCE_INVALID;}
 *out=result;return BOUNCE_OK;
}
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
