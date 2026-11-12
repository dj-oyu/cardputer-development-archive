#include "background.h"
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>
_Static_assert(sizeof(KsnSceneQuery)==24,"query ABI");
_Static_assert(sizeof(KsnSceneResult)==40,"compact result ABI");
_Static_assert(sizeof(fox_bg_result)==208,"private result ABI");
struct fox_bg_scene {
 size_t refs,bytes; vis_binding shadow; fox_bg_input in;
 float projection[12]; double inv[9],camera_depth,ray_direction[3],world[3];
};
static const uint64_t slot_fee[BGW_COUNT]={0,0,512,256,768,256,256,0,0,0,0,0,0,0,0};
static const uint64_t floor_fee[BGW_COUNT]={0,0,0,0,0,0,0,768,384,7680,3072,24576,128,128,0};
static const char *const names[BGW_COUNT]={"construct","frameAdmission","slotAdmission","cameraRay","floorTriangles","clipDepthOrder","resultCounterCommit","diskAdmission","diskReceiver","diskKernel","diskSampleControl","shadowBridgeAdmission","diskReduction","floorComposition","worldMiss"};
const char *fox_bg_work_category_name(unsigned k){return k<BGW_COUNT?names[k]:"invalid";}
static int overlap(const void*a,size_t an,const void*b,size_t bn){if(!a||!b||!an||!bn)return 0;uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;if(an-1>UINTPTR_MAX-x||bn-1>UINTPTR_MAX-y)return 1;return x<=y?y-x<an:x-y<bn;}
static int veq(vis_generation a,vis_generation b){return a.geometry==b.geometry&&a.pose==b.pose&&a.light==b.light;}
static int geq(fox_bg_generation a,fox_bg_generation b){return veq(a.visibility,b.visibility)&&a.camera==b.camera&&a.material==b.material&&a.emission==b.emission&&a.illumination==b.illumination;}
static int gvalid(fox_bg_generation a){return a.visibility.geometry&&a.visibility.pose&&a.visibility.light&&a.camera&&a.material&&a.emission&&a.illumination;}
static int gmono(fox_bg_generation a,fox_bg_generation b){return a.visibility.geometry>=b.visibility.geometry&&a.visibility.pose>=b.visibility.pose&&a.visibility.light>=b.visibility.light&&a.camera>=b.camera&&a.material>=b.material&&a.emission>=b.emission&&a.illumination>=b.illumination;}
static int finite3(const double*a){return isfinite(a[0])&&isfinite(a[1])&&isfinite(a[2]);}
static double dot(const double*a,const double*b){return a[0]*b[0]+a[1]*b[1]+a[2]*b[2];}
static void cross(const double*a,const double*b,double*r){r[0]=a[1]*b[2]-a[2]*b[1];r[1]=a[2]*b[0]-a[0]*b[2];r[2]=a[0]*b[1]-a[1]*b[0];}
size_t fox_bg_scene_required_bytes(void){return sizeof(fox_bg_scene);}
size_t fox_bg_scene_bytes(const fox_bg_scene*s){return s?s->bytes:0;}
int fox_bg_scene_overlaps(const fox_bg_scene*s,const void*p,size_t n){return s&&(overlap(s,s->bytes,p,n)||vis_scene_overlaps(s->shadow.scene,p,n));}
fox_bg_generation fox_bg_scene_generation(const fox_bg_scene*s){fox_bg_generation z={0};return s?s->in.generation:z;}
fox_bg_status fox_bg_scene_retain(fox_bg_scene*s){if(!s||s->refs==SIZE_MAX)return FOX_BG_INVALID;s->refs++;return FOX_BG_OK;}
void fox_bg_scene_release(fox_bg_scene*s){if(s&&!--s->refs){vis_binding_clear(&s->shadow);free(s);}}
fox_bg_status fox_bg_binding_set(fox_bg_binding*b,fox_bg_scene*s,fox_bg_generation g){if(!b||!s||fox_bg_scene_overlaps(s,b,sizeof*b)||fox_bg_scene_overlaps(b->scene,b,sizeof*b))return FOX_BG_INVALID;if(!geq(g,s->in.generation))return FOX_BG_GENERATION;fox_bg_status st=fox_bg_scene_retain(s);if(st)return st;fox_bg_scene*old=b->scene;b->scene=s;b->expected=g;fox_bg_scene_release(old);return FOX_BG_OK;}
void fox_bg_binding_clear(fox_bg_binding*b){if(b&&!fox_bg_scene_overlaps(b->scene,b,sizeof*b)){fox_bg_scene*s=b->scene;memset(b,0,sizeof*b);fox_bg_scene_release(s);}}
uint64_t fox_bg_fingerprint(const void*v,size_t n){const unsigned char*p=v;uint64_t h=UINT64_C(14695981039346656037);while(n--){h^=*p++;h*=UINT64_C(1099511628211);}return h;}
static uint64_t category_bound(const fox_bg_work*w,unsigned k){if(k==BGW_CONSTRUCT)return 8192;if(k==BGW_FRAME)return 593920;if(k==BGW_WORLD)return 64*w->shade_limit;return slot_fee[k]*w->slot_limit+floor_fee[k]*w->shade_limit;}
static int work_valid(const fox_bg_work*w){
 if(!w||!w->slot_limit||w->slot_limit>FOX_BG_MAX_SLOTS||w->shade_limit>w->slot_limit||w->slots>w->slot_limit||w->floor_evaluations>w->shade_limit||w->world_misses>w->shade_limit-w->floor_evaluations||w->floor_evaluations+w->world_misses>w->slots||w->limit_total>FOX_BG_WORK_CAP||w->used_total>w->limit_total)return 0;
 uint64_t sum=0;for(unsigned k=0;k<BGW_COUNT;k++){if(w->limit[k]>category_bound(w,k)||w->used[k]>w->limit[k]||UINT64_MAX-sum<w->used[k])return 0;sum+=w->used[k];if(k>=BGW_SLOT&&k<=BGW_COMMIT&&w->used[k]!=slot_fee[k]*w->slots)return 0;if(k>=BGW_DISK_ADMISSION&&k<=BGW_FLOOR_COMPOSITION&&w->used[k]!=floor_fee[k]*w->floor_evaluations)return 0;}
 return sum==w->used_total&&w->used[BGW_WORLD]==64*w->world_misses&&(w->used[BGW_CONSTRUCT]==0||w->used[BGW_CONSTRUCT]==8192)&&(w->used[BGW_FRAME]==0||(w->used[BGW_FRAME]>=4096&&!(w->used[BGW_FRAME]%8)))&&w->limit_total<=8192+593920+2048*w->slot_limit+36736*w->shade_limit;
}
fox_bg_status fox_bg_work_init(fox_bg_work*w,uint64_t slots,uint64_t shades){if(!w||!slots||slots>FOX_BG_MAX_SLOTS||shades>slots)return FOX_BG_INVALID;fox_bg_work t={0};t.slot_limit=slots;t.shade_limit=shades;for(unsigned k=0;k<BGW_COUNT;k++)t.limit[k]=category_bound(&t,k);t.limit_total=8192+593920+2048*slots+36736*shades;*w=t;return FOX_BG_OK;}
/* Called only after entry work_valid, or after our own successful slot charge.
 * No external callback can mutate the ledger between those checks/charges. */
static fox_bg_status pay(fox_bg_work*w,const uint64_t*f,unsigned phase){uint64_t sum=0;for(unsigned k=0;k<BGW_COUNT;k++){if(f[k]>w->limit[k]-w->used[k])return FOX_BG_BUDGET;sum+=f[k];}if(sum>w->limit_total-w->used_total||(phase==1&&w->slots==w->slot_limit)||(phase>=2&&w->floor_evaluations+w->world_misses==w->shade_limit))return FOX_BG_BUDGET;for(unsigned k=0;k<BGW_COUNT;k++)w->used[k]+=f[k];w->used_total+=sum;if(phase==1)w->slots++;else if(phase==2)w->floor_evaluations++;else if(phase==3)w->world_misses++;return FOX_BG_OK;}
static fox_bg_status camera_prepare(fox_bg_scene*s){
 const float*c=s->in.camera;double fx=(double)c[0]-c[3],fy=(double)c[1]-c[4],fz=(double)c[2]-c[5];double len=hypot(hypot(fx,fy),fz);if(!isfinite(len)||!(len>0))return FOX_BG_NUMERIC;fx/=len;fy/=len;fz/=len;
 double rx=fz,rz=-fx,rl=hypot(rx,rz);if(rl<1e-6){rx=1;rz=0;rl=1;}rx/=rl;rz/=rl;
 float b[3][3]={{(float)rx,0,(float)rz},{(float)(fy*rz),(float)(fz*rx-fx*rz),(float)(-fy*rx)},{(float)fx,(float)fy,(float)fz}};
 const float id[12]={1,0,0,0,0,1,0,0,0,0,1,0};
 for(unsigned row=0;row<3;row++){float zoom=row<2?c[6]:1;for(unsigned col=0;col<3;col++)s->projection[4*row+col]=zoom*(b[row][0]*id[col]+b[row][1]*id[4+col]+b[row][2]*id[8+col]);s->projection[4*row+3]=zoom*(b[row][0]*(id[3]-c[3])+b[row][1]*(id[7]-c[4])+b[row][2]*(id[11]-c[5]));if(row<2)s->projection[4*row+3]+=c[7+row];}
 for(unsigned k=0;k<12;k++)if(!isfinite(s->projection[k]))return FOX_BG_NUMERIC;
 double a=s->projection[0],b0=s->projection[1],c0=s->projection[2],d=s->projection[4],e=s->projection[5],f=s->projection[6],g=s->projection[8],h=s->projection[9],i=s->projection[10];double det=a*(e*i-f*h)-b0*(d*i-f*g)+c0*(d*h-e*g);if(!isfinite(det)||det==0)return FOX_BG_NUMERIC;
 double inv[9]={(e*i-f*h)/det,(c0*h-b0*i)/det,(b0*f-c0*e)/det,(f*g-d*i)/det,(a*i-c0*g)/det,(c0*d-a*f)/det,(d*h-e*g)/det,(b0*g-a*h)/det,(a*e-b0*d)/det};memcpy(s->inv,inv,sizeof inv);for(unsigned k=0;k<9;k++)if(!isfinite(inv[k]))return FOX_BG_NUMERIC;
 float dc=s->projection[8]*c[0]+s->projection[9]*c[1]+s->projection[10]*c[2]+s->projection[11];s->camera_depth=dc;if(!isfinite(dc))return FOX_BG_NUMERIC;
 double v[3]={-inv[2]/38,inv[8]/38,inv[5]/38};len=hypot(hypot(v[0],v[1]),v[2]);if(!isfinite(len)||!(len>0))return FOX_BG_NUMERIC;for(unsigned k=0;k<3;k++)s->ray_direction[k]=v[k]/len;return finite3(s->ray_direction)?FOX_BG_OK:FOX_BG_NUMERIC;
}
static int illumination_same(const fox_bg_scene*s,const fox_bg_input*i){return !memcmp(s->in.lights.lights,i->lights.lights,sizeof i->lights.lights)&&!memcmp(s->world,i->lights.world_radiance,sizeof s->world);}
fox_bg_status fox_bg_scene_build(fox_bg_scene**slot,vis_scene*geometry,const fox_bg_input*i,fox_bg_work*w,size_t max_bytes){
 if(!slot||!geometry||!i||!w||sizeof(fox_bg_scene)>max_bytes||sizeof(fox_bg_scene)>FOX_BG_OWNED_CAP)return FOX_BG_INVALID;
 const void*p[3]={slot,i,w};size_t n[3]={sizeof*slot,sizeof*i,sizeof*w};for(unsigned a=0;a<3;a++)for(unsigned b=a+1;b<3;b++)if(overlap(p[a],n[a],p[b],n[b]))return FOX_BG_INVALID;for(unsigned a=0;a<3;a++)if(vis_scene_overlaps(geometry,p[a],n[a])||fox_bg_scene_overlaps(*slot,p[a],n[a]))return FOX_BG_INVALID;
 if(!work_valid(w))return FOX_BG_INVALID;if(w->used[BGW_CONSTRUCT])return FOX_BG_BUDGET;uint64_t fee[BGW_COUNT]={0};fee[BGW_CONSTRUCT]=8192;fox_bg_status st=pay(w,fee,0);if(st)return st;
 if(!gvalid(i->generation)||!i->snapshot_fingerprint||!i->identity_fingerprint)return FOX_BG_INVALID;if(!veq(vis_scene_generation(geometry),i->generation.visibility))return FOX_BG_GENERATION;
 if(*slot){const fox_bg_scene*old=*slot;fox_bg_generation a=i->generation,b=old->in.generation;if(!gmono(a,b)||geq(a,b))return FOX_BG_GENERATION;
  if(i->identity_fingerprint!=old->in.identity_fingerprint&&a.visibility.geometry==b.visibility.geometry&&a.visibility.pose==b.visibility.pose)return FOX_BG_GENERATION;
  if(i->snapshot_fingerprint!=old->in.snapshot_fingerprint&&veq(a.visibility,b.visibility)&&a.camera==b.camera&&a.material==b.material&&a.illumination==b.illumination)return FOX_BG_GENERATION;
  if((memcmp(i->floor,old->in.floor,sizeof i->floor)||memcmp(i->indices,old->in.indices,sizeof i->indices))&&a.visibility.geometry<=b.visibility.geometry)return FOX_BG_GENERATION;
  if((memcmp(i->camera,old->in.camera,sizeof i->camera)||memcmp(i->source_origin,old->in.source_origin,sizeof i->source_origin)||memcmp(i->source_view,old->in.source_view,sizeof i->source_view)||memcmp(i->clip,old->in.clip,sizeof i->clip))&&a.camera<=b.camera)return FOX_BG_GENERATION;
  if(memcmp(i->rho,old->in.rho,sizeof i->rho)&&a.material<=b.material)return FOX_BG_GENERATION;if(memcmp(i->le,old->in.le,sizeof i->le)&&a.emission<=b.emission)return FOX_BG_GENERATION;if(!illumination_same(old,i)&&a.illumination<=b.illumination)return FOX_BG_GENERATION;
 }
 for(unsigned k=0;k<9;k++)if(!isfinite(i->camera[k]))return FOX_BG_INVALID;if(!(i->camera[6]>0)||!finite3(i->source_origin)||!finite3(i->source_view)||fabs(dot(i->source_view,i->source_view)-1)>1e-12||!isfinite(i->clip[0])||!isfinite(i->clip[1])||!(i->clip[0]>0)||!(i->clip[1]>i->clip[0]))return FOX_BG_INVALID;
 for(unsigned a=0;a<4;a++)for(unsigned k=0;k<3;k++)if(!isfinite(i->floor[a][k])||fabs(i->floor[a][k])>1e50)return FOX_BG_INVALID;for(unsigned k=0;k<6;k++)if(i->indices[k]>=4)return FOX_BG_INVALID;
 for(unsigned a=0;a<2;a++){double e1[3],e2[3],n0[3];for(unsigned k=0;k<3;k++){e1[k]=i->floor[i->indices[a*3+1]][k]-i->floor[i->indices[a*3]][k];e2[k]=i->floor[i->indices[a*3+2]][k]-i->floor[i->indices[a*3]][k];}cross(e1,e2,n0);double l=hypot(hypot(n0[0],n0[1]),n0[2]);if(!isfinite(l)||!(l>0))return FOX_BG_INVALID;}
 for(unsigned k=0;k<3;k++)if(!isfinite(i->rho[k])||i->rho[k]<0||i->rho[k]>1||!isfinite(i->le[k])||i->le[k]<0)return FOX_BG_INVALID;if(fox_disk_scene_validate(&i->lights)!=FOX_DISK_OK)return FOX_BG_INVALID;
 fox_bg_scene*s=calloc(1,sizeof*s);if(!s)return FOX_BG_ALLOC;s->refs=1;s->bytes=sizeof*s;s->in=*i;memcpy(s->world,i->lights.world_radiance,sizeof s->world);memset(s->in.lights.world_radiance,0,sizeof s->in.lights.world_radiance);
 st=camera_prepare(s);if(st){free(s);return st;}if(vis_binding_set(&s->shadow,geometry,i->generation.visibility)!=VIS_OK){free(s);return FOX_BG_VISIBILITY;}fox_bg_scene*old=*slot;*slot=s;fox_bg_scene_release(old);return FOX_BG_OK;
}
static int shadow_valid(const vis_budget*b){return b&&b->limit.rays<=FOX_BG_SHADOW_RAYS&&b->limit.node_visits<=FOX_BG_SHADOW_NODES&&b->limit.triangle_tests<=FOX_BG_SHADOW_TRIANGLES&&b->used.rays<=b->limit.rays&&b->used.node_visits<=b->limit.node_visits&&b->used.triangle_tests<=b->limit.triangle_tests;}
static double light_value(const fox_bg_scene*s,unsigned j){if(j>=48)return s->world[j-48];const FoxDiskLight*l=s->in.lights.lights+j/16;unsigned k=j%16;if(k<3)return l->center[k];if(k<6)return l->normal[k-3];if(k<9)return l->axis_u[k-6];if(k<12)return l->axis_v[k-9];if(k<15)return l->power_rgb_over_pi_squared[k-12];return l->radius;}
fox_bg_status fox_bg_context_begin(fox_bg_context*c,fox_bg_scene*s,fox_bg_generation g,uint32_t mode,fox_bg_work*w,vis_budget*b,const void*snap,size_t sn,const void*identity,size_t in){
 if(!c||!s||!w||!b||!snap||!identity||sn<416||sn>65536||!in||in>8192||(mode!=KSN_SCENE_COMPOSITE&&mode!=KSN_SCENE_BACKGROUND_ONLY))return FOX_BG_INVALID;
 const void*p[6]={c,w,b,snap,identity,s};size_t n[6]={sizeof*c,sizeof*w,sizeof*b,sn,in,sizeof*s};for(unsigned a=0;a<5;a++)for(unsigned j=a+1;j<5;j++)if(overlap(p[a],n[a],p[j],n[j]))return FOX_BG_INVALID;for(unsigned a=0;a<5;a++)if(fox_bg_scene_overlaps(s,p[a],n[a])||fox_bg_scene_overlaps(c->binding.scene,p[a],n[a]))return FOX_BG_INVALID;
 if(!work_valid(w)||!shadow_valid(b)||b->used.rays||b->used.node_visits||b->used.triangle_tests)return FOX_BG_INVALID;if(w->used[BGW_FRAME])return FOX_BG_BUDGET;uint64_t fee[BGW_COUNT]={0};fee[BGW_FRAME]=4096+8*(sn+in);fox_bg_status st=pay(w,fee,0);if(st)return st;
 if(!geq(g,s->in.generation)||!veq(g.visibility,vis_scene_generation(s->shadow.scene)))return FOX_BG_GENERATION;if(memcmp(snap,"KSPX\1\0\0\0",8)||fox_bg_fingerprint(snap,sn)!=s->in.snapshot_fingerprint||fox_bg_fingerprint(identity,in)!=s->in.identity_fingerprint)return FOX_BG_GENERATION;
 const unsigned char*q=snap;for(unsigned k=0;k<51;k++){uint64_t u=0;for(unsigned j=0;j<8;j++)u|=(uint64_t)q[8+8*k+j]<<(8*j);double d;memcpy(&d,&u,8);if(d!=light_value(s,k)||!isfinite(d))return FOX_BG_GENERATION;}
 fox_bg_context t={0};st=fox_bg_binding_set(&t.binding,s,g);if(st)return st;t.work=w;t.shadow_budget=b;t.mode=mode;fox_bg_scene*old=c->binding.scene;*c=t;fox_bg_scene_release(old);return FOX_BG_OK;
}
void fox_bg_context_clear(fox_bg_context*c){if(c&&!fox_bg_scene_overlaps(c->binding.scene,c,sizeof*c)){fox_bg_scene*s=c->binding.scene;memset(c,0,sizeof*c);fox_bg_scene_release(s);}}
static fox_bg_status floor_intersection(const fox_bg_scene*s,double x,double y,fox_bg_result*r){
 double q[3]={x-s->projection[3],y-s->projection[7],s->camera_depth-s->projection[11]},on[3],o[3];for(unsigned k=0;k<3;k++)on[k]=s->inv[3*k]*q[0]+s->inv[3*k+1]*q[1]+s->inv[3*k+2]*q[2];o[0]=on[0]/38;o[1]=-on[2]/38;o[2]=-on[1]/38;const double*d=s->ray_direction;if(!finite3(o))return FOX_BG_NUMERIC;
 unsigned found=0,parallel=0,negative=0;double nearest=INFINITY;
 for(unsigned t=0;t<2;t++){const double*v0=s->in.floor[s->in.indices[3*t]],*v1=s->in.floor[s->in.indices[3*t+1]],*v2=s->in.floor[s->in.indices[3*t+2]];double e1[3],e2[3],ng[3],dv[3];for(unsigned k=0;k<3;k++){e1[k]=v1[k]-v0[k];e2[k]=v2[k]-v0[k];dv[k]=v0[k]-o[k];}cross(e1,e2,ng);double nl=hypot(hypot(ng[0],ng[1]),ng[2]);if(!isfinite(nl)||!(nl>0))return FOX_BG_NUMERIC;for(unsigned k=0;k<3;k++)ng[k]/=nl;double denom=dot(ng,d);if(!isfinite(denom))return FOX_BG_NUMERIC;if(denom==0){parallel++;continue;}double dist=dot(ng,dv)/denom;if(!isfinite(dist))return FOX_BG_NUMERIC;if(dist<0){negative++;continue;}
  double point[3],vp[3];for(unsigned k=0;k<3;k++){point[k]=o[k]+dist*d[k];vp[k]=point[k]-v0[k];}if(!finite3(point))return FOX_BG_NUMERIC;double d00=dot(e1,e1),d01=dot(e1,e2),d11=dot(e2,e2),d20=dot(vp,e1),d21=dot(vp,e2),den=d00*d11-d01*d01;if(!isfinite(den)||!(den>0))return FOX_BG_NUMERIC;double b=(d11*d20-d01*d21)/den,cc=(d00*d21-d01*d20)/den;if(!isfinite(b)||!isfinite(cc))return FOX_BG_NUMERIC;if(b<0||cc<0||b+cc>1)continue;
  if(!found||dist<nearest){found=1;nearest=dist;r->triangle=t;memcpy(r->position,point,sizeof point);for(unsigned k=0;k<3;k++)r->normal[k]=denom<0?ng[k]:-ng[k];}
 }
 if(!found){r->miss_reason=parallel==2?FOX_BG_PARALLEL:negative?FOX_BG_NEGATIVE_T:FOX_BG_OUTSIDE;return FOX_BG_OK;}
 double rel[3];for(unsigned k=0;k<3;k++)rel[k]=r->position[k]-s->in.source_origin[k];double axial=dot(rel,s->in.source_view);if(!isfinite(axial))return FOX_BG_NUMERIC;if(axial<s->in.clip[0]||axial>s->in.clip[1]){r->miss_reason=FOX_BG_CLIP;return FOX_BG_OK;}
 float p[3]={(float)(38*r->position[0]),(float)(-38*r->position[2]),(float)(-38*r->position[1])};float z=s->projection[8]*p[0]+s->projection[9]*p[1]+s->projection[10]*p[2]+s->projection[11];if(!isfinite(z))return FOX_BG_NUMERIC;r->floor_depth=z;return FOX_BG_OK;
}
typedef struct {fox_bg_context*c;fox_bg_result*r;fox_bg_status failure;} shadow_context;
static bool visible(void*opaque,const double*p,const double*n,const double*q,bool*out){(void)n;shadow_context*x=opaque;if(x->r->positive_queries==UINT64_MAX){x->failure=FOX_BG_BUDGET;return false;}x->r->positive_queries++;int blocked;vis_status st=vis_segment_occluded(&x->c->binding.scene->shadow,x->c->binding.expected.visibility,p,q,x->c->shadow_budget,&blocked);if(st!=VIS_OK){x->failure=st==VIS_BUDGET?FOX_BG_BUDGET:st==VIS_GENERATION?FOX_BG_GENERATION:FOX_BG_VISIBILITY;return false;}if(blocked)x->r->blocked_queries++;*out=!blocked;return true;}
static fox_bg_status resolve_impl(fox_bg_context*c,const KsnSceneQuery*q,fox_bg_result*out,KsnSceneResult*compact){
 if(!c||!q||(!out&&!compact)||!c->binding.scene||!c->work||!c->shadow_budget)return FOX_BG_INVALID;fox_bg_scene*s=c->binding.scene;
 const void*p[5]={c,q,out,c->work,c->shadow_budget};size_t n[5]={sizeof*c,sizeof*q,sizeof*out,sizeof*c->work,sizeof*c->shadow_budget};for(unsigned i=0;i<5;i++){if(fox_bg_scene_overlaps(s,p[i],n[i]))return FOX_BG_INVALID;for(unsigned j=i+1;j<5;j++)if(overlap(p[i],n[i],p[j],n[j]))return FOX_BG_INVALID;}
 if(compact){if(fox_bg_scene_overlaps(s,compact,sizeof*compact))return FOX_BG_INVALID;for(unsigned i=0;i<5;i++)if(overlap(compact,sizeof*compact,p[i],n[i]))return FOX_BG_INVALID;}
 if(!work_valid(c->work)||!c->work->used[BGW_FRAME]||!shadow_valid(c->shadow_budget))return FOX_BG_INVALID;fox_bg_status st=pay(c->work,slot_fee,1);if(st)return st;
 if(!geq(c->binding.expected,s->in.generation)||!veq(c->binding.expected.visibility,vis_scene_generation(s->shadow.scene)))return FOX_BG_GENERATION;
 if((c->mode!=KSN_SCENE_COMPOSITE&&c->mode!=KSN_SCENE_BACKGROUND_ONLY)||q->x>=240||q->y>=135||(q->sample!=UINT32_MAX&&q->sample>3)||q->character_hit>1||q->mode!=c->mode||(q->character_hit?!isfinite(q->character_depth):(q->character_depth!=0||signbit(q->character_depth))))return FOX_BG_INVALID;
 fox_bg_result r={0};r.x=q->x;r.y=q->y;r.sample=q->sample;r.character_depth=q->character_depth;r.snapshot_fingerprint=s->in.snapshot_fingerprint;r.identity_fingerprint=s->in.identity_fingerprint;
 const double dx[4]={-.25,.25,-.25,.25},dy[4]={-.25,-.25,.25,.25};double x=q->x,y=q->y;if(q->sample!=UINT32_MAX){x+=dx[q->sample];y+=dy[q->sample];}st=floor_intersection(s,x,y,&r);if(st)return st;
 int hit=r.miss_reason==FOX_BG_FLOOR_HIT;int keep=c->mode==KSN_SCENE_COMPOSITE&&q->character_hit&&(!hit||r.floor_depth<=q->character_depth);
 if(keep)r.action=0;
 else if(!hit){uint64_t fee[BGW_COUNT]={0};fee[BGW_WORLD]=64;st=pay(c->work,fee,3);if(st)return st;r.action=2;for(unsigned k=0;k<3;k++)r.world[k]=r.combined[k]=s->world[k];}
 else{st=pay(c->work,floor_fee,2);if(st)return st;r.action=1;shadow_context z={c,&r,FOX_BG_OK};FoxDiskStatus fs=fox_disk_eval16_visible(&s->in.lights,r.position,r.normal,s->in.rho,visible,&z,r.direct);if(fs!=FOX_DISK_OK)return z.failure?z.failure:FOX_BG_LIGHTING;for(unsigned k=0;k<3;k++){r.world[k]=s->in.rho[k]*s->world[k];r.emission[k]=s->in.le[k];r.combined[k]=r.direct[k]+r.world[k]+r.emission[k];if(!isfinite(r.combined[k])||r.combined[k]<0)return FOX_BG_NUMERIC;}}
 fox_bg_counters sum=c->counters;
#define ADD(f,v) do{uint64_t a=(v);if(sum.f>UINT64_MAX-a)return FOX_BG_BUDGET;sum.f+=a;}while(0)
 ADD(slots,1);ADD(keep,r.action==0);ADD(floor,r.action==1);ADD(world,r.action==2);ADD(parallel,r.action==2&&r.miss_reason==FOX_BG_PARALLEL);ADD(negative_t,r.action==2&&r.miss_reason==FOX_BG_NEGATIVE_T);ADD(outside,r.action==2&&r.miss_reason==FOX_BG_OUTSIDE);ADD(clip,r.action==2&&r.miss_reason==FOX_BG_CLIP);ADD(positive_queries,r.positive_queries);ADD(blocked_queries,r.blocked_queries);
#undef ADD
 if(compact){KsnSceneResult k={0};k.action=r.action;k.floor_classification=hit?1:2;k.floor_native_depth=hit?(double)r.floor_depth:0;memcpy(k.linear_rgb,r.combined,sizeof k.linear_rgb);*compact=k;}
 if(out)*out=r;c->last_result=r;c->counters=sum;return FOX_BG_OK;
}
fox_bg_status fox_bg_resolve(fox_bg_context*c,const KsnSceneQuery*q,fox_bg_result*r){return resolve_impl(c,q,r,NULL);}
bool fox_bg_compose(void*opaque,const KsnSceneQuery*q,KsnSceneResult*r){return r&&resolve_impl(opaque,q,NULL,r)==FOX_BG_OK;}
const char *fox_bg_status_string(fox_bg_status s){static const char*const v[]={"ok","invalid","allocation","generation","budget","numeric","visibility","lighting"};return (unsigned)s<sizeof v/sizeof*v?v[s]:"unknown";}

bool fox_bg_context_overlaps(void*opaque,const void*p,size_t n){const fox_bg_context*c=opaque;return c&&(overlap(c,sizeof*c,p,n)||overlap(c->work,sizeof*c->work,p,n)||overlap(c->shadow_budget,sizeof*c->shadow_budget,p,n)||fox_bg_scene_overlaps(c->binding.scene,p,n));}
size_t fox_bg_context_owned_bytes(const fox_bg_context*c){return c&&c->binding.scene?sizeof*c+sizeof*c->work+sizeof*c->shadow_budget+fox_bg_scene_bytes(c->binding.scene):0;}

fox_bg_status fox_bg_context_finish(const fox_bg_context*c){
 if(!c||!c->binding.scene||!c->work||!c->shadow_budget||!work_valid(c->work)||!shadow_valid(c->shadow_budget)||!c->work->used[BGW_FRAME])return FOX_BG_INVALID;
 if(!geq(c->binding.expected,c->binding.scene->in.generation)||!veq(c->binding.expected.visibility,vis_scene_generation(c->binding.scene->shadow.scene)))return FOX_BG_GENERATION;
 const fox_bg_counters*r=&c->counters;const fox_bg_work*w=c->work;
 if(r->slots!=w->slot_limit||r->slots!=w->slots||r->keep>r->slots||r->floor>r->slots-r->keep||r->world!=r->slots-r->keep-r->floor||r->floor!=w->floor_evaluations||r->world!=w->world_misses||r->parallel>r->world||r->negative_t>r->world-r->parallel||r->outside>r->world-r->parallel-r->negative_t||r->clip!=r->world-r->parallel-r->negative_t-r->outside||r->positive_queries!=c->shadow_budget->used.rays||r->blocked_queries>r->positive_queries)return FOX_BG_INVALID;
 return FOX_BG_OK;
}
