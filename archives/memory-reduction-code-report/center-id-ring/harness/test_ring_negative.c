#include "fixture.h"
static unsigned profile_calls,profile_fail;
static int profile(const float in[3],float out[3]){profile_calls++;if(profile_calls==profile_fail)return 2;for(unsigned k=0;k<3;k++)out[k]=in[k]/(1+in[k]);return 0;}
static bool run(fixture*f,ksn_aa_ledger*l,unsigned*sh,KsnSceneBinding*b,KsnSceneLedger*nl,KsnSceneReport*nr,KsnBandHDRReport*rd){profile_calls=0;return ksn_mesh_pixel_render_bounded_ring_experimental(&f->s,f->rgb,64800,f->depth,129600,f->rw,sizeof*f->rw,&f->id,l,shade,sh,sizeof*sh,b,nl,nr,profile,rd);}
int main(void){
 fixture f;init(&f);append(&f,1,1,0,0,1);table(&f,1,1);ksn_aa_ledger l=limits();unsigned sh=0;
 /* Small synthetic legacy run supplies independent mask/depth/control, not an actual frame. */
 assert(ksn_mesh_pixel_render_boundary_experimental(&f.s,f.rgb,f.depth,f.w,&f.id,&l,shade,&sh,NULL,NULL));
 memcpy(f.olddepth,f.depth,129600);memcpy(f.center,f.rgb,64800);uint8_t mask[4050];memcpy(mask,f.w->targets,4050);ksn_aa_report old=f.w->report;
 mock m={.mask=mask};uint8_t descriptor[32]={0};uint64_t budget[6]={2000000,200000000,100000000,0,0,0};
 KsnSceneBinding b={.compose=compose,.overlaps=owned_overlap,.context=&m,.context_bytes=sizeof m,.descriptor=descriptor,.descriptor_bytes=sizeof descriptor,.shadow_budget=budget,.shadow_budget_bytes=sizeof budget,.resolver_owned_bytes=sizeof m+sizeof descriptor+sizeof budget,.snapshot_fingerprint=f.id.snapshot_fingerprint,.identity_fingerprint=f.id.fingerprint,.target_mask_fingerprint=hash(mask,4050),.mode=0,.expected_targets=old.targets};
 KsnSceneLedger nl=newlimits(b.expected_targets,false);KsnSceneReport nr;KsnBandHDRReport rd;
 assert(run(&f,&l,&sh,&b,&nl,&nr,&rd));assert(rd.complete&&profile_calls==32400&&rd.used[RH_PROFILE]==32400);assert(!memcmp(mask,f.rw->targets,4050)&&!memcmp(f.olddepth,f.depth,129600));assert(f.rw->report.center_shades==old.center_shades&&f.rw->report.sample_shades==old.sample_shades);for(unsigned k=0;k<AA_CATEGORY_COUNT;k++)assert(f.rw->report.observed.value[k]==old.observed.value[k]+(k==AA_COUNTER_GUARDS?134:0));assert(f.rw->report.observed_total==old.observed_total+134);assert(rd.used[RH_COPY]==11520&&rd.used[RH_CLEAR]==97200&&rd.used[RH_ROWS]==135);report_ok(&nr);
 /* Exactly one profile after linear mean, not averaging display values. */
 m.override=1;assert(run(&f,&l,&sh,&b,&nl,&nr,&rd));assert(!memcmp(f.olddepth,f.depth,129600));assert(nr.occluded_character>0);
 unsigned failures=0;
 for(unsigned i=1;i<=3;i++){profile_fail=i==1?1:i==2?16000:32400;assert(!run(&f,&l,&sh,&b,&nl,&nr,&rd));assert(!rd.complete&&profile_calls==profile_fail);failures++;}profile_fail=0;m.override=0;
 for(int i=1;i<=14;i++){m.mutation=i;assert(!run(&f,&l,&sh,&b,&nl,&nr,&rd));assert(!rd.complete);failures++;}m.mutation=0;
 for(unsigned k=0;k<5;k++){KsnSceneBinding bad=b;if(k==0)bad.snapshot_fingerprint^=1;if(k==1)bad.identity_fingerprint^=1;if(k==2)bad.target_mask_fingerprint^=1;if(k==3)bad.mode=1;if(k==4)bad.expected_targets++;assert(!run(&f,&l,&sh,&bad,&nl,&nr,&rd));failures++;}
 assert(!ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64799,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,shade,&sh,sizeof sh,&b,&nl,&nr,profile,&rd));failures++;
 assert(!ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,shade,&sh,sizeof sh,&b,&nl,&nr,profile,(KsnBandHDRReport*)f.rgb));failures++;
 /* Misaligned typed reports reject before mutation or dereference. */
 assert(!ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,shade,&sh,sizeof sh,&b,&nl,&nr,profile,(KsnBandHDRReport*)((char*)&rd+1)));failures++;
 assert(!ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,shade,&sh,sizeof sh,&b,&nl,(KsnSceneReport*)((char*)&nr+1),profile,&rd));failures++;
 KsnSceneReport nr_before=nr;KsnBandHDRReport rd_before=rd;
 assert(!ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,shade,&sh,sizeof sh,&b,&nl,&nr,profile,(KsnBandHDRReport*)f.rgb));assert(!memcmp(&nr,&nr_before,sizeof nr)&&!memcmp(&rd,&rd_before,sizeof rd));failures++;
 /* Three floor winners per quarter group, ordered linear mean, depth untouched. */
 b.compose=oracle_compose;memset(oracle_hdr,0,sizeof oracle_hdr);memset(oracle_slots,0,sizeof oracle_slots);profile_calls=0;shader_calls=0;
 assert(ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,flat_shade,&sh,sizeof sh,&b,&nl,&nr,profile,&rd));
 assert(!memcmp(f.olddepth,f.depth,129600));
 for(unsigned at=0;at<32400;at++){unsigned slots=(mask[at/8]>>(at%8)&1)?4:1;assert(oracle_slots[at]==slots);unsigned q[3];for(unsigned k=0;k<3;k++){float in=(float)(oracle_hdr[at][k]/slots),v=in/(1+in);q[k]=(unsigned)lroundf(v*(k==1?63:31));}assert(f.rgb[at]==(uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]));}
 unsigned totalsh=shader_calls;
 for(unsigned i=0;i<3;i++){shader_calls=0;shader_fail=i==0?1:i==1?totalsh/2:totalsh;assert(!ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,flat_shade,&sh,sizeof sh,&b,&nl,&nr,profile,&rd));assert(shader_calls==shader_fail&&!rd.complete);failures++;}shader_fail=0;
 for(int i=1;i<=3;i++){shader_invalid=i;assert(!ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,flat_shade,&sh,sizeof sh,&b,&nl,&nr,profile,&rd));failures++;}shader_invalid=0;
 /* Background failure at first/middle/final query, with cumulative state. */
 uint64_t fullqueries=32400+3*b.expected_targets;
 for(unsigned i=0;i<3;i++){m.calls=0;bg_fail=i==0?1:i==1?fullqueries/2:fullqueries;assert(!ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,flat_shade,&sh,sizeof sh,&b,&nl,&nr,profile,&rd));assert(m.calls==bg_fail&&!rd.complete);failures++;}
 m.calls=500;bg_fail=510;assert(!ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,flat_shade,&sh,sizeof sh,&b,&nl,&nr,profile,&rd));assert(m.calls==510&&nr.queries==10);failures++;bg_fail=0;
 /* Every active original AA category is still enforced without a cap increase. */
 assert(ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,flat_shade,&sh,sizeof sh,&b,&nl,&nr,profile,&rd));
 ksn_aa_report goodaa=f.rw->report;
 for(unsigned k=0;k<AA_CATEGORY_COUNT;k++)if(goodaa.observed.value[k]){ksn_aa_ledger low=l;low.value[k]=goodaa.observed.value[k]-1;assert(!ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&low,flat_shade,&sh,sizeof sh,&b,&nl,&nr,profile,&rd));assert(!rd.complete);failures++;}
 /* Full declared crossing ranges and integer-overflow rejection. */
 KsnSceneBinding bad=b;bad.context=(char*)f.rw-1;bad.context_bytes=2;assert(!run(&f,&l,&sh,&bad,&nl,&nr,&rd));failures++;
 bad=b;bad.descriptor=(char*)f.rgb+64799;bad.descriptor_bytes=2;assert(!run(&f,&l,&sh,&bad,&nl,&nr,&rd));failures++;
 m.owned_alias=f.owned+400;m.alias_size=8;assert(!run(&f,&l,&sh,&b,&nl,&nr,&rd));m.owned_alias=NULL;m.alias_size=0;failures++;
 bad=b;bad.context=(void*)(UINTPTR_MAX-7);bad.context_bytes=16;assert(!run(&f,&l,&sh,&bad,&nl,&nr,&rd));failures++;
 assert(!ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,flat_shade,(char*)f.rgb-1,2,&b,&nl,&nr,profile,&rd));failures++;
 /* Ring-specific admission sizes, alignment, null and overlap remain atomic. */
 ksn_bounded_ring_workspace *saved=malloc(sizeof *saved);assert(saved);
 memcpy(saved,f.rw,sizeof *saved);memcpy(f.center,f.rgb,64800);memcpy(f.olddepth,f.depth,129600);nr_before=nr;rd_before=rd;
 for(unsigned badcase=0;badcase<6;badcase++){
  ksn_bounded_ring_workspace *w=f.rw;size_t wn=sizeof *w;
  if(badcase==0)wn=137312;if(badcase==1)wn=77311;if(badcase==2)w=NULL;
  if(badcase==3)w=(ksn_bounded_ring_workspace*)((char*)f.rw+1);
  if(badcase==4)w=(ksn_bounded_ring_workspace*)f.rgb;
  if(badcase==5)wn=0;
  assert(!ksn_mesh_pixel_render_bounded_ring_experimental(&f.s,f.rgb,64800,f.depth,129600,w,wn,&f.id,&l,flat_shade,&sh,sizeof sh,&b,&nl,&nr,profile,&rd));
  assert(!memcmp(saved,f.rw,sizeof *saved)&&!memcmp(f.center,f.rgb,64800)&&!memcmp(f.olddepth,f.depth,129600)&&!memcmp(&nr,&nr_before,sizeof nr)&&!memcmp(&rd,&rd_before,sizeof rd));failures++;
 }
 free(saved);
 /* The unchanged binder accepts source IDs0..91, rejects92 and sentinel65535. */
 for(unsigned invalid=0;invalid<2;invalid++){
  unsigned id=invalid?65535:92;f.table[7]=id&255;f.table[8]=id>>8;f.id.fingerprint=hash(f.table,f.id.size);b.identity_fingerprint=f.id.fingerprint;
  assert(!run(&f,&l,&sh,&b,&nl,&nr,&rd));assert(!rd.complete);assert(!memcmp(f.center,f.rgb,64800)&&!memcmp(f.olddepth,f.depth,129600));failures++;
 }
 printf("{\"status\":\"PASS\",\"smallSyntheticOnly\":true,\"profileOnce\":32400,\"negativeCases\":%u,\"maskDepthRetained\":true,\"actualFrames\":0}\n",failures);done(&f);
}
