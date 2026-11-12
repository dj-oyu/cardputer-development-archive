#include "ksn_bounded_ring.h"
#include "ayatsuri/ayatsuri_shade.h"
#include <assert.h>
#include <float.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct {uint8_t *owned;ksn_mesh_pixel_snapshot s;uint8_t table[40];ksn_aa_identity id;uint16_t *rgb,*center;float *depth,*olddepth;ksn_aa_workspace*w;ksn_bounded_ring_workspace*rw;} fixture;
static uint64_t hash(const uint8_t*p,size_t n){uint64_t h=UINT64_C(14695981039346656037);while(n--){h^=*p++;h*=UINT64_C(1099511628211);}return h;}
static ksn_aa_ledger limits(void){ksn_aa_ledger l={{2750272,32400,56128,4050,129600,97200,259200,3672,1701632,448136,1246416,129600,610560,19080,32768,9920,8192,65536,4096,310000,32400}};return l;}
static FoxDiskScene lights(void){FoxDiskLightInput l[3]={0};for(unsigned j=0;j<3;j++){l[j].shape=FOX_DISK_SHAPE_DISK;l[j].center[0]=2*j;l[j].center[2]=10;for(unsigned k=0;k<3;k++)l[j].color[k]=1;l[j].diameter=1;l[j].power=1;}FoxDiskScene s;double rgb[3]={1,1,1};assert(fox_disk_scene_init(&s,l,rgb,.1)==0);return s;}
static void init(fixture*f){memset(f,0,sizeof*f);f->owned=malloc(65536);f->rgb=calloc(32400,2);f->center=calloc(32400,2);f->depth=malloc(129600);f->olddepth=malloc(129600);f->w=malloc(sizeof*f->w);f->rw=malloc(sizeof*f->rw);assert(f->rw);assert(f->owned&&f->rgb&&f->center&&f->depth&&f->olddepth&&f->w);FoxDiskScene light=lights();assert(ksn_mesh_pixel_begin(&f->s,f->owned,65536,&light,8000000));}
static void done(fixture*f){free(f->owned);free(f->rgb);free(f->center);free(f->depth);free(f->olddepth);free(f->w);free(f->rw);}
static void append(fixture*f,unsigned node,float depth,int normalcase,int fallback,int square){
 unsigned nv=square?4:3,nt=square?2:1;co_pixel_vertex*v=calloc(nv,sizeof*v);uint16_t*ix=malloc(nt*3*2);uint8_t*bits=calloc(8,1);
 const float xy[4][2]={{0,0},{4,0},{4,4},{0,4}};const float tri[3][2]={{0,0},{4,0},{0,4}};
 for(unsigned j=0;j<nv;j++){const float*pos=square?xy[j]:tri[j];v[j].front=(co_vertex){pos[0],pos[1],1,depth,65535,65535};v[j].world[0]=pos[0];v[j].world[1]=pos[1];v[j].world[2]=node;
 v[j].normal_front[0]=normalcase?(j?-28672:4096):32767;v[j].normal_back[0]=-v[j].normal_front[0];if(fallback)v[j].normal_back[1]=1;}
 uint16_t idx[6]={0,1,2,0,2,3};memcpy(ix,idx,nt*6);co_pixel_input p={v,ix,bits,(uint16_t)node,(uint8_t)nv,(uint8_t)nt};assert(co_append_pixel_normal_pair(&f->s.mesh.packets,&p));
 memset(v,0xa5,nv*sizeof*v);memset(ix,0xa5,nt*6);memset(bits,0xa5,8);free(v);free(ix);free(bits);f->s.mesh.work+=20000;
}
static void table(fixture*f,unsigned records,int square){unsigned nt=square?2:1;memset(f->table,0,sizeof f->table);for(unsigned j=0;j<=records;j++)f->table[2*j]=(uint8_t)(j*nt);
 for(unsigned j=0;j<records;j++)for(unsigned k=0;k<nt;k++){uint8_t*e=f->table+2*(records+1)+5*(j*nt+k);e[0]=0;e[1]=k?2:1;e[2]=k?3:2;e[3]=(uint8_t)j;}
 f->id=(ksn_aa_identity){f->table,2*(records+1)+5*records*nt,records,records*nt,0,0};f->id.fingerprint=hash(f->table,f->id.size);f->id.snapshot_fingerprint=hash(f->s.storage,416+f->s.mesh.packets.size);}
static bool shade(void*p,const FoxDiskScene*s,const double pos[3],const double n[3],const double rho[3],double out[3]){(void)s;(void)n;(void)rho;unsigned*c=p;(*c)++;out[0]=pos[1]>-.04?2:0;out[1]=pos[1]<-.04?1:0;out[2]=0;return true;}
typedef struct {uint64_t calls,hits,misses,centers,quarters,seen_last;int mutation,override;const uint8_t*mask;const void*owned_alias;size_t alias_size;} mock;
static int overlaps(const void*a,size_t an,const void*b,size_t bn){uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;return an&&bn&&(x>UINTPTR_MAX-an||y>UINTPTR_MAX-bn||(x<y+bn&&y<x+an));}
static bool owned_overlap(void*p,const void*q,size_t n){mock*m=p;return overlaps(m,sizeof*m,q,n)||overlaps(m->owned_alias,m->alias_size,q,n);}
static bool compose(void*p,const KsnSceneQuery*q,KsnSceneResult*r){
 mock*m=p;KsnSceneResult zero={0};assert(!memcmp(r,&zero,sizeof*r));assert(q->x<240&&q->y<135&&q->character_hit<=1);assert(q->sample<=3||q->sample==UINT32_MAX);assert(q->mode<=1);assert(q->character_hit||(!q->character_depth&&!signbit(q->character_depth)));if(q->mode)assert(!q->character_hit);
 unsigned at=q->y*240+q->x;bool selected=(m->mask[at/8]>>(at%8))&1;assert(selected==(q->sample!=UINT32_MAX));m->calls++;if(q->character_hit)m->hits++;else m->misses++;if(q->sample==UINT32_MAX)m->centers++;else m->quarters++;if(q->y==134)m->seen_last++;
 r->floor_classification=KSN_SCENE_SCENE_MISS;r->action=q->character_hit?KSN_SCENE_KEEP_CHARACTER:KSN_SCENE_REPLACE_WORLD;
 if(m->override==1&&q->character_hit){r->floor_classification=KSN_SCENE_FLOOR_HIT;r->floor_native_depth=q->character_depth+1.0f;r->action=KSN_SCENE_REPLACE_FLOOR;r->linear_rgb[0]=.25;r->linear_rgb[1]=.5;r->linear_rgb[2]=2;}
 if(m->override==2&&q->character_hit){r->floor_classification=KSN_SCENE_FLOOR_HIT;r->floor_native_depth=q->character_depth;}
 if(m->override==3&&!q->character_hit){r->linear_rgb[0]=q->sample==0?4:0;r->linear_rgb[1]=.25;}
 switch(m->mutation){case 1:r->linear_rgb[0]=NAN;break;case 2:r->linear_rgb[0]=-1;break;case 3:r->floor_classification=0;break;case 4:r->action=99;break;case 5:r->floor_native_depth=-0.0;break;case 6:r->floor_classification=KSN_SCENE_FLOOR_HIT;r->floor_native_depth=1.00000000000001;break;case 7:r->action=KSN_SCENE_KEEP_CHARACTER;r->linear_rgb[0]=1;break;case 8:r->linear_rgb[0]=2;return false;case 9:r->action=KSN_SCENE_REPLACE_WORLD;r->floor_classification=KSN_SCENE_FLOOR_HIT;break;case 10:if(q->character_hit){r->linear_rgb[0]=-0.0;}break;case 11:if(q->character_hit){r->floor_classification=KSN_SCENE_FLOOR_HIT;r->floor_native_depth=q->character_depth+1;}break;case 12:r->linear_rgb[2]=INFINITY;break;case 14:r->linear_rgb[0]=DBL_MAX;break;case 13:if(q->character_hit){r->action=KSN_SCENE_REPLACE_FLOOR;r->floor_classification=KSN_SCENE_FLOOR_HIT;r->floor_native_depth=q->character_depth;}break;}
 return true;
}
typedef struct {uint64_t events,hits,misses;double sum;} observer_state;
static bool observer(void*p,const ksn_aa_sample*s){observer_state*q=p;q->events++;if(s->hit){q->hits++;for(unsigned i=0;i<3;i++)q->sum+=s->linear_rgb[i];}else q->misses++;return true;}
static KsnSceneLedger newlimits(unsigned t,bool control){
 uint64_t q=32400+3*t;KsnSceneLedger l={0};l.value[SC_BINDING]=512;l.value[SC_MASK_HASH]=4050;l.value[SC_QUERY]=6*q;l.value[SC_RESULT_ZERO]=5*q;l.value[SC_DISPATCH]=q;l.value[SC_RGB_VALIDATE]=3*q;l.value[SC_DECISION_VALIDATE]=3*q;l.value[SC_EVENTS]=2*q;l.value[SC_DESCRIPTOR_HASH]=16384;
 if(control){l.value[SC_MASK_COPY]=4050;l.value[SC_HDR_CLEAR]=97200;l.value[SC_SAMPLE_SCAN]=129600;l.value[SC_OUTPUT_SCAN]=32400;l.value[SC_CONTROL_ACCUM]=24*t;l.value[SC_CONTROL_ENCODE]=259200;l.value[SC_GUARDS]=6*q+4*t+32400+106;}
 else{l.value[SC_CENTER_STATE]=2*(32400-t);l.value[SC_REPLACEMENT_COPY]=12*t;l.value[SC_ORIGINAL_MISS_ACCUM]=24*t;l.value[SC_CENTER_ENCODE]=8*(32400-t);l.value[SC_GUARDS]=6*q+8*t+32400-t+20;}
 return l;
}
static void report_ok(const KsnSceneReport*r){assert(r->complete&&r->failed_category==SC_CATEGORY_COUNT&&!r->descriptor_fingerprint_executed);uint64_t sum=0,res=0;for(unsigned k=0;k<SC_CATEGORY_COUNT;k++){assert(r->observed.value[k]<=r->reserved.value[k]);sum+=r->observed.value[k];res+=r->reserved.value[k];assert(strcmp(ksn_scene_category_name(k),"invalid"));}assert(sum==r->observed_total&&res==r->reserved_total&&res<=KSN_SCENE_CORE_CAP);assert(!r->observed.value[SC_DESCRIPTOR_HASH]);}
static bool composite(fixture*f,ksn_aa_ledger*l,unsigned*sh,observer_state*obs,KsnSceneBinding*b,KsnSceneLedger*nl,KsnSceneReport*nr){memset(f->rgb,0,64800);return ksn_mesh_pixel_render_scene_composition_experimental(&f->s,f->rgb,f->depth,f->w,&f->id,l,shade,sh,sizeof*sh,obs?observer:NULL,obs,obs?sizeof*obs:0,b,nl,nr);}
/* New bounded producer oracle: test-only independent full HDR, never production. */
static double oracle_hdr[32400][3];
static uint32_t oracle_slots[32400];
static unsigned shader_calls,shader_fail;static int shader_invalid;
static bool flat_shade(void*p,const FoxDiskScene*s,const double pos[3],const double n[3],const double rho[3],double out[3]){(void)p;(void)s;(void)pos;(void)n;(void)rho;shader_calls++;if(shader_fail&&shader_calls==shader_fail)return false;out[0]=.2;out[1]=.4;out[2]=.8;if(shader_invalid)out[0]=shader_invalid==1?NAN:shader_invalid==2?INFINITY:-1;return true;}
static uint64_t bg_fail;
static bool oracle_compose(void*p,const KsnSceneQuery*q,KsnSceneResult*r){mock*m=p;m->calls++;if(bg_fail&&m->calls==bg_fail)return false;unsigned at=q->y*240+q->x;bool replace=q->sample!=UINT32_MAX&&q->sample<3;double chosen[3]={.2,.4,.8};
 if(q->character_hit&&!replace){r->action=KSN_SCENE_KEEP_CHARACTER;r->floor_classification=KSN_SCENE_SCENE_MISS;}
 else if(replace){r->action=KSN_SCENE_REPLACE_FLOOR;r->floor_classification=KSN_SCENE_FLOOR_HIT;r->floor_native_depth=q->character_hit?q->character_depth+1.0f:1;chosen[0]=.3;chosen[1]=1.5;chosen[2]=2.2;memcpy(r->linear_rgb,chosen,sizeof chosen);}
 else{r->action=KSN_SCENE_REPLACE_WORLD;r->floor_classification=KSN_SCENE_SCENE_MISS;chosen[0]=.7;chosen[1]=.1;chosen[2]=.05;memcpy(r->linear_rgb,chosen,sizeof chosen);}
 oracle_slots[at]++;for(unsigned k=0;k<3;k++)oracle_hdr[at][k]+=chosen[k];return true;}
