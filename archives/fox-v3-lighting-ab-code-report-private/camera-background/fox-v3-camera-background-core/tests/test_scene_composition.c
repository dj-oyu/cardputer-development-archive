#include "ui/kasane/ksn_scene_composition.h"
#include "ayatsuri/ayatsuri_shade.h"
#include <assert.h>
#include <float.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef struct {uint8_t *owned;ksn_mesh_pixel_snapshot s;uint8_t table[40];ksn_aa_identity id;uint16_t *rgb,*center;float *depth,*olddepth;ksn_aa_workspace*w;} fixture;
static uint64_t hash(const uint8_t*p,size_t n){uint64_t h=UINT64_C(14695981039346656037);while(n--){h^=*p++;h*=UINT64_C(1099511628211);}return h;}
static ksn_aa_ledger limits(void){ksn_aa_ledger l={{2750272,32400,56128,4050,129600,97200,259200,3672,1701632,448136,1246416,129600,610560,19080,32768,9920,8192,65536,4096,310000,32400}};return l;}
static FoxDiskScene lights(void){FoxDiskLightInput l[3]={0};for(unsigned j=0;j<3;j++){l[j].shape=FOX_DISK_SHAPE_DISK;l[j].center[0]=2*j;l[j].center[2]=10;for(unsigned k=0;k<3;k++)l[j].color[k]=1;l[j].diameter=1;l[j].power=1;}FoxDiskScene s;double rgb[3]={1,1,1};assert(fox_disk_scene_init(&s,l,rgb,.1)==0);return s;}
static void init(fixture*f){memset(f,0,sizeof*f);f->owned=malloc(65536);f->rgb=calloc(32400,2);f->center=calloc(32400,2);f->depth=malloc(129600);f->olddepth=malloc(129600);f->w=malloc(sizeof*f->w);assert(f->owned&&f->rgb&&f->center&&f->depth&&f->olddepth&&f->w);FoxDiskScene light=lights();assert(ksn_mesh_pixel_begin(&f->s,f->owned,65536,&light,8000000));}
static void done(fixture*f){free(f->owned);free(f->rgb);free(f->center);free(f->depth);free(f->olddepth);free(f->w);}
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
int main(void){
 fixture f;init(&f);append(&f,1,1,0,0,1);table(&f,1,1);ksn_aa_ledger l=limits();unsigned sh=0;observer_state oldobs={0},obs={0};
 assert(ksn_mesh_pixel_render_boundary_experimental(&f.s,f.rgb,f.depth,f.w,&f.id,&l,shade,&sh,observer,&oldobs));memcpy(f.center,f.rgb,64800);memcpy(f.olddepth,f.depth,129600);ksn_aa_report oldreport=f.w->report;uint8_t mask[4050];memcpy(mask,f.w->targets,sizeof mask);unsigned oldsh=sh;
 mock m={.mask=mask};uint8_t descriptor[32]={0};uint64_t budget[6]={2000000,200000000,100000000,0,0,0};KsnSceneBinding b={.compose=compose,.overlaps=owned_overlap,.context=&m,.context_bytes=sizeof m,.descriptor=descriptor,.descriptor_bytes=sizeof descriptor,.shadow_budget=budget,.shadow_budget_bytes=sizeof budget,.resolver_owned_bytes=sizeof m+sizeof descriptor+sizeof budget,.snapshot_fingerprint=f.id.snapshot_fingerprint,.identity_fingerprint=f.id.fingerprint,.target_mask_fingerprint=hash(mask,sizeof mask),.mode=0,.expected_targets=oldreport.targets};KsnSceneLedger nl=newlimits(b.expected_targets,false);KsnSceneReport nr;
 /* NULL dispatch ignores every new control, including context size metadata. */
 sh=0;assert(ksn_mesh_pixel_render_scene_composition_experimental(&f.s,f.rgb,f.depth,f.w,&f.id,&l,shade,&sh,0,NULL,NULL,123,NULL,NULL,NULL));assert(sh==oldsh&&!memcmp(f.rgb,f.center,64800)&&!memcmp(f.depth,f.olddepth,129600));
 sh=0;assert(composite(&f,&l,&sh,&obs,&b,&nl,&nr));report_ok(&nr);assert(sh==oldsh&&!memcmp(&oldobs,&obs,sizeof obs)&&!memcmp(&f.w->report,&oldreport,sizeof oldreport));assert(!memcmp(f.rgb,f.center,64800)&&!memcmp(f.depth,f.olddepth,129600)&&!memcmp(mask,f.w->targets,4050));assert(m.calls==32400+3*b.expected_targets&&m.quarters==4*b.expected_targets&&m.centers==32400-b.expected_targets&&m.seen_last==240);
 KsnSceneReport good=nr;uint64_t failures=0;
 /* Invalid binding rejects before touching any caller output, including a
  * previously successful report. Return false remains authoritative. */
 KsnSceneBinding invalid=b;invalid.mode=99;assert(!ksn_mesh_pixel_render_scene_composition_experimental(&f.s,f.rgb,f.depth,f.w,&f.id,&l,shade,&sh,sizeof sh,NULL,NULL,0,&invalid,&nl,&nr));assert(!memcmp(f.rgb,f.center,64800)&&!memcmp(f.depth,f.olddepth,129600)&&!memcmp(&good,&nr,sizeof nr)&&nr.complete);failures++;
 for(unsigned k=0;k<SC_CATEGORY_COUNT;k++)if(good.observed.value[k]){KsnSceneLedger low=nl;low.value[k]=good.observed.value[k]-1;assert(!composite(&f,&l,&sh,NULL,&b,&low,&nr));assert(!nr.complete&&nr.failed_category==k);failures++;}
 /* KEEP on tied floor preserves exact encoded centers and exact selected HDR. */
 m.override=2;sh=0;assert(composite(&f,&l,&sh,NULL,&b,&nl,&nr));assert(sh==oldsh&&!memcmp(f.rgb,f.center,64800));
 /* Floor replaces visible radiance only, including covered quarter and center. */
 m.override=1;sh=0;obs=(observer_state){0};assert(composite(&f,&l,&sh,&obs,&b,&nl,&nr));assert(nr.occluded_character&&sh==oldsh&&!memcmp(f.depth,f.olddepth,129600)&&!memcmp(&f.w->report,&oldreport,sizeof oldreport)&&!memcmp(&oldobs,&obs,sizeof obs)&&memcmp(f.rgb,f.center,64800));m.override=0;
 for(int i=1;i<=14;i++){m.mutation=i;assert(!composite(&f,&l,&sh,NULL,&b,&nl,&nr));assert(!nr.complete);if(i==8)assert(f.w->report.center_shades==oldreport.center_shades&&nr.queries);failures++;}m.mutation=0;
 /* Input packet storage was copied from poisoned/freed arrays before baseline.
  * All fingerprints/mask/mode/count controls reject mismatches. */
 for(unsigned k=0;k<5;k++){KsnSceneBinding bad=b;if(k==0)bad.snapshot_fingerprint^=1;if(k==1)bad.identity_fingerprint^=1;if(k==2)bad.target_mask_fingerprint^=1;if(k==3)bad.mode=1;if(k==4)bad.expected_targets++;assert(!composite(&f,&l,&sh,NULL,&bad,&nl,&nr));failures++;}
 for(unsigned k=0;k<6;k++){uint64_t save=budget[k];budget[k]=k<3?save+1:budget[k-3]+1;assert(!composite(&f,&l,&sh,NULL,&b,&nl,&nr));budget[k]=save;failures++;}
 /* Full spans, not first-byte checks, detect crossing into output/workspace. */
 KsnSceneBinding bad=b;bad.context=(char*)f.w-1;bad.context_bytes=2;assert(!composite(&f,&l,&sh,NULL,&bad,&nl,&nr));bad=b;bad.descriptor=(char*)f.rgb+64799;bad.descriptor_bytes=2;assert(!composite(&f,&l,&sh,NULL,&bad,&nl,&nr));bad=b;bad.shadow_budget=f.depth;assert(!composite(&f,&l,&sh,NULL,&bad,&nl,&nr));bad=b;bad.resolver_owned_bytes=16384;assert(!composite(&f,&l,&sh,NULL,&bad,&nl,&nr));m.owned_alias=f.owned+100;m.alias_size=1;assert(!composite(&f,&l,&sh,NULL,&b,&nl,&nr));m.owned_alias=NULL;m.alias_size=0;
 assert(!ksn_mesh_pixel_render_scene_composition_experimental(&f.s,f.rgb,f.depth,f.w,&f.id,&l,shade,(char*)f.rgb-1,2,NULL,NULL,0,&b,&nl,&nr));assert(!ksn_mesh_pixel_render_scene_composition_experimental(&f.s,f.rgb,f.depth,f.w,&f.id,&l,shade,&sh,sizeof sh,observer,(char*)f.depth-1,2,&b,&nl,&nr));
 KsnSceneLedger huge=nl;huge.value[SC_DESCRIPTOR_HASH]=UINT64_MAX;assert(!composite(&f,&l,&sh,NULL,&b,&huge,&nr));failures+=8;
 /* Fixed geometry-bound synthetic masks exercise both approved control domains
  * and selected last-row/last-pixel, without physical/character rendering. */
 for(unsigned t=2385;t<=2391;t+=6){memset(mask,0,sizeof mask);for(unsigned p=0;p<t-1;p++)mask[p/8]|=1u<<(p%8);mask[4049]|=128;b.mode=1;b.expected_targets=t;b.target_mask_fingerprint=hash(mask,4050);nl=newlimits(t,true);m=(mock){.mask=mask};assert(ksn_mesh_pixel_render_background_control_experimental(f.rgb,f.w,mask,4050,&b,&nl,&nr));report_ok(&nr);assert(nr.queries==32400+3*t&&nr.world==nr.queries&&nr.centers==32400-t&&nr.quarters==4*t&&m.seen_last==243);assert(nr.observed_total==(t==2385?1654727:1655363)&&nr.reserved_total==(t==2385?1671112:1671748));for(unsigned p=0;p<32400;p++)assert(!f.rgb[p]);good=nr;
  for(unsigned k=0;k<SC_CATEGORY_COUNT;k++)if(good.observed.value[k]){KsnSceneLedger low=nl;low.value[k]=good.observed.value[k]-1;assert(!ksn_mesh_pixel_render_background_control_experimental(f.rgb,f.w,mask,4050,&b,&low,&nr));assert(!nr.complete&&nr.failed_category==k);failures++;}
  /* Linear HDR four denominator, including scene misses; no per-sample clamp. */
  m.override=3;assert(ksn_mesh_pixel_render_background_control_experimental(f.rgb,f.w,mask,4050,&b,&nl,&nr));unsigned green=(unsigned)lroundf(ayatsuri_srgb_encode(.25f)*63);assert(f.rgb[0]==(31u<<11|green<<5));m.override=0;
  KsnSceneBinding too_much=b;too_much.resolver_owned_bytes=KSN_SCENE_OWNED_CAP-sizeof b-sizeof nl-sizeof nr;assert(!ksn_mesh_pixel_render_background_control_experimental(f.rgb,f.w,mask,4050,&too_much,&nl,&nr));failures++;
  uint8_t saved=mask[1000];mask[1000]^=1;assert(!ksn_mesh_pixel_render_background_control_experimental(f.rgb,f.w,mask,4050,&b,&nl,&nr));mask[1000]=saved;assert(!ksn_mesh_pixel_render_background_control_experimental(f.rgb,f.w,f.w->targets,4050,&b,&nl,&nr));failures+=2;
 }
 printf("{\"status\":\"PASS\",\"negativeCases\":%llu,\"nullLegacyExact\":true,\"keepRGBDepthReportObserverExact\":true,\"floorOverridesRetainCharacterWork\":true,\"poisonFreeBeforeRendering\":true,\"fullSpanAliasRejection\":true,\"invalidAdmissionPreservesPriorSuccessReport\":true,\"allActiveCategoriesExhaustion\":true,\"controlQueries\":[39555,39573],\"controlObserved\":[1654727,1655363],\"controlReserved\":[1671112,1671748],\"lastBandRows\":7,\"queryBytes\":%zu,\"resultBytes\":%zu,\"bindingBytes\":%zu,\"ledgerBytes\":%zu,\"reportBytes\":%zu,\"oldWorkspaceBytes\":%zu}\n",(unsigned long long)failures,sizeof(KsnSceneQuery),sizeof(KsnSceneResult),sizeof(KsnSceneBinding),sizeof(KsnSceneLedger),sizeof(KsnSceneReport),sizeof(ksn_aa_workspace));done(&f);return 0;
}
