#include "ksn_stream_depth.h"
static bool stream_depth_valid(const KsnStreamDepth*d){
 if(!d->strip||!d->pending||(uintptr_t)d->strip%_Alignof(float)||(uintptr_t)d->pending%_Alignof(float)||d->strip_bytes!=7680||d->pending_bytes!=960)return false;
 return d->capture ? (uintptr_t)d->capture%_Alignof(float)==0&&d->capture_bytes==129600 : d->capture_bytes==0;
}
/* Extra copy units are float elements, never hidden in HDR copy accounting.
 * These fixed per-frame limits do not increase the existing producer cap. */
static bool stream_copy_charge(KsnStreamDepthReport*d,KsnBandHDRReport*r,bool capture,uint64_t count){
 if(!rrh_charge(r,RH_GUARDS,0))return false;
 uint64_t *used=capture?&d->capture_copy_floats:&d->pending_copy_floats;
 uint64_t cap=capture?32400:3840;
 if(*used>cap||count>cap-*used)return false;*used+=count;return true;
}
static __attribute__((noinline)) bool stream_admission(const ksn_mesh_pixel_snapshot*s,uint16_t*rgb,size_t rgbn,const KsnStreamDepth*original,const KsnStreamDepth*depth,ksn_bounded_ring_workspace*w,size_t wn,const ksn_aa_identity*t,const ksn_aa_ledger*l,void*context,size_t cn,const KsnSceneBinding*b,const KsnSceneLedger*sl,KsnSceneReport*sr,KsnBandHDRReport*r,KsnStreamDepthReport*dr){
#define RH_ALIGNED(p,T) ((p)&&((uintptr_t)(p)%_Alignof(T)==0))
 if(!RH_ALIGNED(s,ksn_mesh_pixel_snapshot)||!RH_ALIGNED(t,ksn_aa_identity)||!RH_ALIGNED(l,ksn_aa_ledger)||!RH_ALIGNED(b,KsnSceneBinding)||!RH_ALIGNED(sl,KsnSceneLedger)||!RH_ALIGNED(sr,KsnSceneReport)||!RH_ALIGNED(r,KsnBandHDRReport))return false;
#undef RH_ALIGNED
 if(!mesh_span_valid(s,sizeof*s)||!mesh_span_valid(t,sizeof*t)||!mesh_span_valid(l,sizeof*l)||!mesh_span_valid(b,sizeof*b)||!mesh_span_valid(sl,sizeof*sl)||!mesh_span_valid(sr,sizeof*sr)||!mesh_span_valid(r,sizeof*r))return false;
 if(!s||!t||!r||rgbn!=64800||wn!=sizeof*w||(uintptr_t)rgb%_Alignof(uint16_t)||(uintptr_t)w%_Alignof(ksn_bounded_ring_workspace))return false;
 if(!depth||(uintptr_t)depth%_Alignof(KsnStreamDepth)||!mesh_span_valid(depth,sizeof*depth))return false;
 if(!stream_depth_valid(depth)||!dr||(uintptr_t)dr%_Alignof(KsnStreamDepthReport)||!mesh_span_valid(dr,sizeof*dr))return false;
 /* Validate report against every declared external and resolver-owned span
  * before initializing it or the old reports. */
 const void*p[]={s,s->storage,rgb,original,w,t,t->bytes,l,context,r,depth->strip,depth->pending,depth->capture,dr};
 const size_t n[]={sizeof*s,s->capacity,rgbn,sizeof*depth,wn,sizeof*t,t->size,sizeof*l,cn,sizeof*r,depth->strip_bytes,depth->pending_bytes,depth->capture_bytes,sizeof*dr};
 if(!sc_binding_spans(b,sl,sr,p,n,14,KSN_SCENE_COMPOSITE))return false;
 if(!t->bytes||t->records<1||t->records>54||t->faces<1||t->faces>1564||t->size!=2*(t->records+1)+5*t->faces||t->size>8192||!t->fingerprint||!t->snapshot_fingerprint||b->snapshot_fingerprint!=t->snapshot_fingerprint||b->identity_fingerprint!=t->fingerprint)return false;
 if(!sc_begin(sr,sl))return false;
 /* One complete span scan, not the old admission scan plus another scan.
  * Charge every successful pair check, conservatively including legacy pairs. */
 unsigned live=0;for(unsigned i=0;i<14;i++)if(n[i])live++;
 memset(r,0,sizeof*r);return rrh_charge(r,RH_ADMISSION,14+live*(live-1)/2+6*live);
}
static __attribute__((noinline)) bool stream_finish_row(ksn_bounded_ring_workspace*w,unsigned y,const double hdr[240][3],uint16_t*rgb,const float*depth,const KsnSceneBinding*b,KsnSceneReport*sr,agx_block_cache *profile,KsnBandHDRReport*r){
 if(y>=135||!rrh_charge(r,RH_ROWS,1)||!ring_aa_charge(w,AA_NEIGHBOR_COMPARE,4*240))return false;
 for(unsigned x=0;x<240;x++){
  unsigned p=y*240+x;unsigned row=(y%10)*240;uint16_t c=w->center_id[row+x],u=y?w->center_id[((y-1)%10)*240+x]:65535,l=x?w->center_id[row+x-1]:65535,rr=x<239?w->center_id[row+x+1]:65535,d=y<134?w->center_id[((y+1)%10)*240+x]:65535;
  if(c!=u||c!=l||c!=rr||c!=d){w->targets[p>>3]|=(uint8_t)(1u<<(p&7));w->report.targets++;if(c==65535)w->report.nohit_targets++;else w->report.covered_targets++;continue;}
  if(sr->observed.value[SC_CENTER_STATE]>sr->reserved.value[SC_CENTER_STATE]||sr->reserved.value[SC_CENTER_STATE]-sr->observed.value[SC_CENTER_STATE]<2||sr->observed_total>KSN_SCENE_CORE_CAP-2)return false;
  sr->observed.value[SC_CENTER_STATE]+=2;sr->observed_total+=2;
  bool hit=c!=65535;KsnSceneResult result;
  if(!sc_resolve(b,sr,x,y,UINT32_MAX,hit,hit?depth[x]:0,&result))return false;
  const double *chosen=hdr[x];
  if(result.action!=KSN_SCENE_KEEP_CHARACTER){if(!sc_charge(sr,SC_CENTER_ENCODE,8))return false;rgb[p]=sc_encode(result.linear_rgb);chosen=result.linear_rgb;}
  if(!cached_encode(chosen,rgb+p,profile,r))return false;
 }
 return true;
}

bool ksn_mesh_pixel_render_stream_depth_private(const ksn_mesh_pixel_snapshot*s,uint16_t*rgb,size_t rgbn,const KsnStreamDepth*depth,ksn_bounded_ring_workspace*w,size_t wn,const ksn_aa_identity*t,const ksn_aa_ledger*limits,FoxPixelShader shader,void*context,size_t context_bytes,const KsnSceneBinding*binding,const KsnSceneLedger*new_limits,KsnSceneReport*new_report,agx_block_cache *profile,KsnBandHDRReport*rd,KsnStreamDepthReport*dr){
 /* Snapshot before any opaque overlap callback. Admission retains the caller
  * descriptor span, while validation and rendering use only this private copy. */
 if(!depth||(uintptr_t)depth%_Alignof(KsnStreamDepth)||!mesh_span_valid(depth,sizeof*depth))return false;
 const KsnStreamDepth frozen_depth=*depth;const KsnStreamDepth*original_depth=depth;depth=&frozen_depth;
 if(!profile||!stream_admission(s,rgb,rgbn,original_depth,depth,w,wn,t,limits,context,context_bytes,binding,new_limits,new_report,rd,dr))return false;
 memset(dr,0,sizeof*dr);
 memset(&w->report,0,sizeof w->report);w->report.failed_category=AA_CATEGORY_COUNT;w->report.reserved=*limits;
 for(unsigned k=0;k<AA_CATEGORY_COUNT;k++){if(limits->value[k]>8000000-w->report.reserved_total)return false;w->report.reserved_total+=limits->value[k];}
 FoxDiskScene scene;if(!ring_aa_charge(w,AA_CONTROL,128)||!pixel_scene(s,&scene)||!ring_aa_bind(s,w,t)||!ring_aa_charge(w,AA_LEGACY_CENTER,s->mesh.work)||!ring_aa_charge(w,AA_CENTER_ID_INIT,KSN_AA_PIXELS)||!ring_aa_charge(w,AA_MASK_CLEAR,sizeof w->targets))return false;
 if(new_limits->value[SC_CENTER_STATE]<2u*(32400-binding->expected_targets))return false;
 memset(w->targets,0,sizeof w->targets);ksn_mesh_pixel_stats stats={0};
 for(unsigned y=0;y<135;y+=8){
  unsigned rows=135-y;if(rows>8)rows=8;
  if(!rrh_charge(rd,RH_SCHEDULE,1)||!rrh_charge(rd,RH_CLEAR,rows*240*3)||!ring_aa_charge(w,AA_CONTROL,1))return false;
  /* Keep y-2 and y-1 alive until pending y-1 is finished. */
  for(unsigned row=0;row<rows;row++)memset(w->center_id+((y+row)%10)*240,0xff,240*sizeof(uint16_t));
  memset(w->reuse.hdr,0,rows*240*3*sizeof(double));
  bool ok=rrh_center_strip(&s->mesh,rgb+y*240,y,rows,depth->strip,&scene,&stats,NULL,NULL,shader,context,w,rd);w->report.center_shades=stats.shade_updates;if(!ok)return false;
  if(depth->capture){if(!stream_copy_charge(dr,rd,true,rows*240))return false;memcpy(depth->capture+y*240,depth->strip,rows*240*sizeof(float));}
  if(!sc_guard(new_report,SC_CENTER_STATE,0))return false;
  if(y&&!stream_finish_row(w,y-1,w->delayed_center_hdr,rgb,depth->pending,binding,new_report,profile,rd))return false;
  for(unsigned row=0;row<rows;row++){
   if(row==rows-1&&y+rows<135){if(!rrh_charge(rd,RH_COPY,720))return false;memcpy(w->delayed_center_hdr,w->reuse.hdr+row*240,sizeof w->delayed_center_hdr);if(!stream_copy_charge(dr,rd,false,240))return false;memcpy(depth->pending,depth->strip+row*240,960);}
   else if(!stream_finish_row(w,y+row,w->reuse.hdr+row*240,rgb,depth->strip+row*240,binding,new_report,profile,rd))return false;
  }
 }
 if(w->report.targets!=binding->expected_targets||!ring_sc_mask(binding,w,new_report))return false;
 static const double dx[4]={-.25,.25,-.25,.25},dy[4]={-.25,-.25,.25,.25};
 for(unsigned y=0;y<135;y+=8){unsigned rows=135-y;if(rows>8)rows=8;unsigned n=rows*240;
  if(!rrh_charge(rd,RH_SCHEDULE,1)||!ring_aa_charge(w,AA_CONTROL,1)||!ring_aa_charge(w,AA_HDR_CLEAR,3*n))return false;memset(w->reuse.hdr,0,n*3*sizeof(double));
  for(unsigned sample=0;sample<4;sample++)if(!rrh_charge(rd,RH_SCHEDULE,1)||!ring_aa_charge(w,AA_CONTROL,1)||!ring_aa_geometry(s,w,y,rows,dx[sample],dy[sample])||!ring_sc_shade_final(s,w,&scene,y,rows,sample,dx[sample],dy[sample],shader,context,NULL,NULL,binding,new_report))return false;
  if(!ring_aa_guard(w,AA_FINAL_OUTPUT_SCAN,n))return false;
  for(unsigned at=0;at<n;at++){w->report.observed.value[AA_FINAL_OUTPUT_SCAN]++;w->report.observed_total++;if(!ring_aa_target(w,y*240+at))continue;
   if(!ring_aa_charge(w,AA_FINAL_ENCODE,8))return false;
   double mean[3];for(unsigned k=0;k<3;k++)mean[k]=w->reuse.hdr[at][k]/4;
   rgb[y*240+at]=sc_encode(mean);if(!cached_encode(mean,rgb+y*240+at,profile,rd))return false;
  }
 }
 if(!sc_complete(binding,new_report)||rd->used[RH_PROFILE]!=32400)return false;
 if(dr->pending_copy_floats!=3840||dr->capture_copy_floats!=(depth->capture?32400u:0u))return false;
 uint64_t total=dr->pending_copy_floats+dr->capture_copy_floats;for(unsigned k=0;k<RH_COUNT;k++)total+=rd->used[k];if(total>637599)return false;
 w->report.complete=true;rd->complete=true;dr->complete=true;return true;
}
