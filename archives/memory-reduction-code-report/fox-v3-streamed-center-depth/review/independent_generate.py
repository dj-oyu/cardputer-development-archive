from pathlib import Path
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-cached-profile-renderer'
s=(B/'harness/test_cached_exact.c').read_text().replace('#include "ksn_cached_profile.h"','#include "ksn_stream_depth.h"\n#include "stream_depth_alloc.h"')
a=s.index('static bool depth_render(');e=s.index('\nstatic uint64_t shader_digest',a)
s=s[:a]+'''static unsigned capture_mode;
static bool depth_render(const ksn_mesh_pixel_snapshot*s,uint16_t*rgb,size_t rgbn,float*depth,size_t depthn,ksn_bounded_ring_workspace*w,size_t wn,const ksn_aa_identity*i,const ksn_aa_ledger*l,FoxPixelShader shader,void*ctx,size_t ctxn,const KsnSceneBinding*b,const KsnSceneLedger*nl,KsnSceneReport*nr,KsnBandProfile p,KsnBandHDRReport*rd){
 assert(depthn==129600);(void)p;
 float *strip=malloc(7680),*pending=malloc(960);assert(strip&&pending);
 KsnStreamDepth d={.strip=strip,.strip_bytes=7680,.pending=pending,.pending_bytes=960,.capture=capture_mode?depth:NULL,.capture_bytes=capture_mode?129600:0};
 KsnStreamDepthReport report={0};agx_block_cache *cache=row_profile_cache_create(malloc,free);assert(cache);
 bool ok=ksn_mesh_pixel_render_stream_depth_private(s,rgb,rgbn,&d,w,wn,i,l,shader,ctx,ctxn,b,nl,nr,cache,rd,&report);
 if(ok){assert(report.complete);assert(report.pending_copy_floats==3840);assert(report.capture_copy_floats==(capture_mode?32400:0));assert(cache->hits+cache->misses==129600);}
 else assert(!report.complete);
 if(fail_at)assert(wrapped_calls==fail_at);
 row_profile_cache_release(&cache,free);free(strip);free(pending);return ok;
}
''' + s[e:]
s=s.replace('mode<5','mode<7').replace('unsigned override=iteration/2;','unsigned override=iteration/2;capture_mode=iteration%2;')
s=s.replace('if(mode==4)quad', 'if(mode==5)quad(&f,node,90,0,10,134,node==1?0.0f:-0.0f); /* tie and signed zero */\n  if(mode==6)quad(&f,node,90,0,10,134,3.0f); /* equal-depth ties */\n  if(mode==4)quad')
s=s.replace('assert(rd0.used[RH_ADMISSION]==120&&rd1.used[RH_ADMISSION]==210);rd0.used[RH_ADMISSION]+=90;assert(!memcmp(&nr0,&nr1,sizeof nr0)&&!memcmp(&rd0,&rd1,sizeof rd0));','assert(!memcmp(&nr0,&nr1,sizeof nr0));for(unsigned k=0;k<RH_COUNT;k++)if(k!=RH_ADMISSION&&k!=RH_GUARDS)assert(rd0.used[k]==rd1.used[k]);assert(rd1.used[RH_ADMISSION]==(capture_mode?189:170));assert(rd1.used[RH_GUARDS]==rd0.used[RH_GUARDS]+(capture_mode?33:16));assert(rd1.used[RH_GUARDS]<=100000);')
(R/'review/independent_exact.c').write_text(s)
s=(R/'review/independent_exact.c').read_text()
pos=s.index('static unsigned capture_mode;')
s=s[:pos]+'''static KsnStreamDepth *mutate_descriptor;
static float *mutate_target;
static bool mutating_overlap(void *ctx,const void *p,size_t n){
 if(mutate_descriptor){mutate_descriptor->strip=mutate_target;mutate_descriptor->pending=mutate_target;mutate_descriptor->capture=mutate_target;}
 return owned_overlap(ctx,p,n);
}
static unsigned allocation_calls,allocation_fail,release_calls;
static void *failing_allocate(size_t n){return ++allocation_calls==allocation_fail?NULL:malloc(n);}
static void counting_release(void*p){if(p)release_calls++;free(p);}
static void allocation_negatives(void){
 for(unsigned capture=0;capture<2;capture++)for(unsigned fail=1;fail<=2+capture;fail++){
  allocation_calls=release_calls=0;allocation_fail=fail;KsnStreamDepth d={0},zero={0};
  assert(!depth_stream_allocate(&d,capture,failing_allocate,counting_release));assert(!memcmp(&d,&zero,sizeof d));assert(release_calls==fail-1);
 }
}
''' +s[pos:]
s=s.replace('int main(void){unsigned cases=0;','int main(void){unsigned cases=0;allocation_negatives();')
# Exercise mutation during every successful admission without modifying the persistent binding.
s=s.replace('bool ok=ksn_mesh_pixel_render_stream_depth_private(s,rgb,rgbn,&d,w,wn,i,l,shader,ctx,ctxn,b,nl,nr,cache,rd,&report);','KsnSceneBinding frozen_binding=*b;frozen_binding.overlaps=mutating_overlap;mutate_descriptor=&d;mutate_target=(float*)rgb;\n bool ok=ksn_mesh_pixel_render_stream_depth_private(s,rgb,rgbn,&d,w,wn,i,l,shader,ctx,ctxn,&frozen_binding,nl,nr,cache,rd,&report);mutate_descriptor=NULL;')
(R/'review/independent_exact.c').write_text(s)
s=(R/'review/independent_exact.c').read_text()
s=s.replace('static unsigned capture_mode;','static unsigned capture_mode,negative_cases,negatives_done;')
needle='KsnSceneBinding frozen_binding=*b;'
insert='''if(capture_mode&&!negatives_done){
  negatives_done=1;
  void *rgb_before=malloc(rgbn),*work_before=malloc(wn);assert(rgb_before&&work_before);memcpy(rgb_before,rgb,rgbn);memcpy(work_before,w,wn);
  KsnSceneReport nr_before=*nr;KsnBandHDRReport rd_before=*rd;KsnStreamDepthReport report_before=report;
  const void *alias[]={s,s->storage,rgb,&d,w,i,i->bytes,l,ctx,b,nl,nr,rd,&report,pending,depth};
  for(unsigned k=0;k<sizeof alias/sizeof *alias;k++){
   KsnStreamDepth bad=d;bad.strip=k==3?(float*)&bad:(float*)alias[k];
   assert(!ksn_mesh_pixel_render_stream_depth_private(s,rgb,rgbn,&bad,w,wn,i,l,shader,ctx,ctxn,b,nl,nr,cache,rd,&report));negative_cases++;
   assert(!memcmp(rgb_before,rgb,rgbn)&&!memcmp(work_before,w,wn)&&!memcmp(&nr_before,nr,sizeof *nr)&&!memcmp(&rd_before,rd,sizeof *rd)&&!memcmp(&report_before,&report,sizeof report));
  }
  for(unsigned k=0;k<9;k++){
   KsnStreamDepth bad=d;
   if(k==0)bad.strip_bytes--;if(k==1)bad.pending_bytes--;if(k==2)bad.capture_bytes--;
   if(k==3)bad.strip=NULL;if(k==4)bad.pending=NULL;if(k==5)bad.capture=NULL;
   if(k==6)bad.strip=(float*)((char*)strip+1);if(k==7)bad.pending=(float*)((char*)pending+1);if(k==8)bad.capture=(float*)(UINTPTR_MAX-3);
   assert(!ksn_mesh_pixel_render_stream_depth_private(s,rgb,rgbn,&bad,w,wn,i,l,shader,ctx,ctxn,b,nl,nr,cache,rd,&report));negative_cases++;
   assert(!memcmp(rgb_before,rgb,rgbn)&&!memcmp(work_before,w,wn)&&!memcmp(&nr_before,nr,sizeof *nr)&&!memcmp(&rd_before,rd,sizeof *rd)&&!memcmp(&report_before,&report,sizeof report));
  }
  free(rgb_before);free(work_before);
 }
 '''
s=s.replace(needle,insert+needle)
s=s.replace('printf("{\\"status\\":\\"PASS\\"','assert(negative_cases==25);printf("{\\"status\\":\\"PASS\\"')
(R/'review/independent_exact.c').write_text(s)
s=(R/'review/independent_exact.c').read_text()
s=s.replace('static uint64_t shader_digest,profile_digest,query_digest;','static uint64_t shader_digest,profile_digest,query_digest;\nstatic unsigned tracked_shader_seen,tracked_shader_fail;static uint64_t tracked_query_seen,tracked_query_fail;')
s=s.replace('{mix(&shader_digest,pos,24);','{if(++tracked_shader_seen==tracked_shader_fail)return false;mix(&shader_digest,pos,24);')
s=s.replace('{mix(&query_digest,&q->x,','{if(++tracked_query_seen==tracked_query_fail)return false;mix(&query_digest,&q->x,')
needle='assert(!memcmp(&oldm,&m,sizeof m));cases++;'
insert='''assert(!memcmp(&oldm,&m,sizeof m));cases++;
 if(mode==1&&reverse==0&&iteration==1){
  for(unsigned which=0;which<2;which++)for(unsigned at=0;at<3;at++){
   tracked_shader_seen=0;tracked_query_seen=0;
   if(which==0)tracked_shader_fail=at==0?1:at==1?oldsh/2:oldsh;
   else tracked_query_fail=at==0?1:at==1?oldm.calls/2:oldm.calls;
   m=(mock){.mask=mask,.override=override};sh=0;
   assert(!depth_render(&f.s,f.rgb,64800,f.depth,129600,f.rw,sizeof*f.rw,&f.id,&l,tracked_shade,&sh,sizeof sh,&b,&nl,&nr1,profile,&rd1));assert(!rd1.complete);
   if(which==0)assert(tracked_shader_seen==tracked_shader_fail);else assert(tracked_query_seen==tracked_query_fail);
   tracked_shader_fail=0;tracked_query_fail=0;
  }
 }
'''
s=s.replace(needle,insert)
(R/'review/independent_exact.c').write_text(s)
