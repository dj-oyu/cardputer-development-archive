#define shade fixture_shade
#include "fixture.h"
#undef shade
#include PIXEL_SOURCE
#ifdef ROW_HDR_OBSERVER
#include "hdr_observer.h"
#endif
static int profile(const float in[3],float out[3]){for(unsigned k=0;k<3;k++)out[k]=in[k]/(1+in[k]);return 0;}
int main(int argc,char**argv){assert(argc==2);fixture f;init(&f);append(&f,1,1,0,0,1);table(&f,1,1);ksn_aa_ledger l=limits();unsigned sh=0;
 assert(ksn_mesh_pixel_render_boundary_experimental(&f.s,f.rgb,f.depth,f.w,&f.id,&l,fixture_shade,&sh,NULL,NULL));uint8_t mask[4050];memcpy(mask,f.w->targets,4050);unsigned targets=f.w->report.targets;
 double xyz[]={1,-100,-100,1,100,-100,1,100,100,1,-100,100};uint32_t ix[]={0,1,2,0,2,3};vis_scene*v=NULL;bounce_generation g={.visibility={1,1,1},.material=1,.emission=1};assert(vis_scene_build(&v,xyz,4,ix,2,g.visibility,(vis_limits){2048,4095,524288})==VIS_OK);
 bounce_triangle attrs[2]={0};for(unsigned i=0;i<2;i++)for(unsigned j=0;j<3;j++){attrs[i].double_sided=1;attrs[i].v[j].front[0]=32767;attrs[i].v[j].back[0]=-32767;}
 FoxDiskScene light=lights();bounce_ground ground={.mode=BOUNCE_GROUND_PRIMARY_LE_DIRECT,.object_id=1,.triangle_count=2,.rho={.8,.7,.6},.le={.2,.3,.4}};bounce_scene*s=NULL;assert(bounce_scene_build_ground(&s,v,attrs,2,&light,1,g,262144,&ground)==BOUNCE_OK);
 vis_budget db={{1000000,100000000,50000000},{0}},tb={{20000000,800000000,300000000},{0}};bounce_floor_work fw;assert(bounce_floor_work_init(&fw,1000,16000)==BOUNCE_OK);fox_pixel_binding pb={0};assert(fox_pixel_bind(&pb,v,g.visibility,&f.s)==VIS_OK);
 fox_transport_context tx={.snapshot_binding=&pb,.expected=g,.ground=ground,.mode=BOUNCE_ONE,.outer=16,.inner=16,.direct_budget=&db,.transport_budget=&tb,.floor_work=&fw};assert(bounce_binding_set(&tx.binding,s,g)==BOUNCE_OK);
#ifdef TEST_WORLD_ON
 bounce_floor_world_work ww;assert(bounce_floor_world_work_init(&ww,1000,16000)==BOUNCE_OK);tx.floor_world_work=&ww;
#endif
 mock m={.mask=mask};uint8_t descriptor[32]={0};uint64_t budget[6]={2000000,200000000,100000000,0,0,0};KsnSceneBinding b={.compose=compose,.overlaps=owned_overlap,.context=&m,.context_bytes=sizeof m,.descriptor=descriptor,.descriptor_bytes=sizeof descriptor,.shadow_budget=budget,.shadow_budget_bytes=sizeof budget,.resolver_owned_bytes=sizeof m+sizeof descriptor+sizeof budget,.snapshot_fingerprint=f.id.snapshot_fingerprint,.identity_fingerprint=f.id.fingerprint,.target_mask_fingerprint=hash(mask,4050),.mode=0,.expected_targets=targets};KsnSceneLedger nl=newlimits(targets,false);KsnSceneReport nr={0};KsnBandHDRReport hr={0};
#ifdef ROW_HDR_OBSERVER
 assert(row_hdr_observer_begin(f.rgb));
#endif
 assert(ksn_mesh_pixel_render_bounded_hdr_experimental(&f.s,f.rgb,64800,f.depth,129600,f.w,sizeof*f.w,&f.id,&l,shade,&tx,sizeof tx,&b,&nl,&nr,profile,&hr));assert(hr.complete&&nr.complete&&f.w->report.complete);assert(tx.counters.primary_ground_reflection_hits>0);
 FILE*out=fopen(argv[1],"wbx");assert(out);
#define WRITE(p,n) assert(fwrite(p,n,1,out)==1)
 WRITE(f.rgb,64800);WRITE(f.depth,129600);WRITE(f.w->targets,4050);WRITE(&f.w->report,sizeof f.w->report);WRITE(&nr,sizeof nr);WRITE(&hr,sizeof hr);WRITE(&tx.counters,sizeof tx.counters);WRITE(&tx.last_result,sizeof tx.last_result);WRITE(&db,sizeof db);WRITE(&tb,sizeof tb);WRITE(&fw,sizeof fw);
#ifdef TEST_WORLD_ON
 WRITE(&ww,sizeof ww);WRITE(&tx.last_floor_world,sizeof tx.last_floor_world);assert(ww.queries==16*tx.counters.primary_ground_reflection_hits);assert(ww.misses==ww.queries);
#endif
 assert(fclose(out)==0);
#ifdef ROW_HDR_OBSERVER
 assert(row_hdr_observer_write(argv[1]));row_hdr_observer_clear();
#endif
 printf("SYNTHETIC_ROW_PARITY_PASS shaders=%llu floorHits=%llu\n",(unsigned long long)tx.counters.primary_rays/16,(unsigned long long)tx.counters.primary_ground_reflection_hits);bounce_binding_clear(&tx.binding);fox_pixel_unbind(&pb);bounce_scene_release(s);vis_scene_release(v);done(&f);return 0;
}
