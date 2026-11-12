/* Mechanical specialization of ring orchestration; generic API unchanged. */
/* Called only with final IDs for y and both in-frame vertical neighbors. */
static __attribute__((noinline)) bool db_finish_row(ksn_bounded_ring_workspace*w,unsigned y,const double hdr[240][3],uint16_t*rgb,const KsnDepthBands*depth,const KsnSceneBinding*b,KsnSceneReport*sr,KsnBandProfile profile,KsnBandHDRReport*r){
 if(y>=135||!rrh_charge(r,RH_ROWS,1)||!ring_aa_charge(w,AA_NEIGHBOR_COMPARE,4*240))return false;
 for(unsigned x=0;x<240;x++){
  unsigned p=y*240+x;unsigned row=(y%10)*240;uint16_t c=w->center_id[row+x],u=y?w->center_id[((y-1)%10)*240+x]:65535,l=x?w->center_id[row+x-1]:65535,rr=x<239?w->center_id[row+x+1]:65535,d=y<134?w->center_id[((y+1)%10)*240+x]:65535;
  if(c!=u||c!=l||c!=rr||c!=d){w->targets[p>>3]|=(uint8_t)(1u<<(p&7));w->report.targets++;if(c==65535)w->report.nohit_targets++;else w->report.covered_targets++;continue;}
  if(sr->observed.value[SC_CENTER_STATE]>sr->reserved.value[SC_CENTER_STATE]||sr->reserved.value[SC_CENTER_STATE]-sr->observed.value[SC_CENTER_STATE]<2||sr->observed_total>KSN_SCENE_CORE_CAP-2)return false;
  sr->observed.value[SC_CENTER_STATE]+=2;sr->observed_total+=2;
  bool hit=c!=65535;KsnSceneResult result;
  if(!sc_resolve(b,sr,x,y,UINT32_MAX,hit,hit?depth->band[y/32][(y%32)*240+x]:0,&result))return false;
  const double *chosen=hdr[x];
  if(result.action!=KSN_SCENE_KEEP_CHARACTER){if(!sc_charge(sr,SC_CENTER_ENCODE,8))return false;rgb[p]=sc_encode(result.linear_rgb);chosen=result.linear_rgb;}
  if(!rrh_encode(chosen,rgb+p,profile,r))return false;
 }
 return true;
}
static __attribute__((noinline)) bool db_admission(const ksn_mesh_pixel_snapshot*s,uint16_t*rgb,size_t rgbn,const KsnDepthBands*original,const KsnDepthBands*depth,ksn_bounded_ring_workspace*w,size_t wn,const ksn_aa_identity*t,const ksn_aa_ledger*l,void*context,size_t cn,const KsnSceneBinding*b,const KsnSceneLedger*sl,KsnSceneReport*sr,KsnBandHDRReport*r){
#define RH_ALIGNED(p,T) ((p)&&((uintptr_t)(p)%_Alignof(T)==0))
 if(!RH_ALIGNED(s,ksn_mesh_pixel_snapshot)||!RH_ALIGNED(t,ksn_aa_identity)||!RH_ALIGNED(l,ksn_aa_ledger)||!RH_ALIGNED(b,KsnSceneBinding)||!RH_ALIGNED(sl,KsnSceneLedger)||!RH_ALIGNED(sr,KsnSceneReport)||!RH_ALIGNED(r,KsnBandHDRReport))return false;
#undef RH_ALIGNED
 if(!mesh_span_valid(s,sizeof*s)||!mesh_span_valid(t,sizeof*t)||!mesh_span_valid(l,sizeof*l)||!mesh_span_valid(b,sizeof*b)||!mesh_span_valid(sl,sizeof*sl)||!mesh_span_valid(sr,sizeof*sr)||!mesh_span_valid(r,sizeof*r))return false;
 if(!s||!t||!r||rgbn!=64800||wn!=sizeof*w||(uintptr_t)rgb%_Alignof(uint16_t)||(uintptr_t)w%_Alignof(ksn_bounded_ring_workspace))return false;
 if(!depth||(uintptr_t)depth%_Alignof(KsnDepthBands)||!mesh_span_valid(depth,sizeof*depth))return false;
 for(unsigned i=0;i<5;i++)if(!depth->band[i]||(uintptr_t)depth->band[i]%_Alignof(float)||depth->bytes[i]!=(i<4?30720u:6720u))return false;
 /* Validate report against every declared external and resolver-owned span
  * before initializing it or the old reports. */
 const void*p[]={s,s->storage,rgb,original,w,t,t->bytes,l,context,r,depth->band[0],depth->band[1],depth->band[2],depth->band[3],depth->band[4]};
 const size_t n[]={sizeof*s,s->capacity,rgbn,sizeof*depth,wn,sizeof*t,t->size,sizeof*l,cn,sizeof*r,depth->bytes[0],depth->bytes[1],depth->bytes[2],depth->bytes[3],depth->bytes[4]};
 if(!sc_binding_spans(b,sl,sr,p,n,15,KSN_SCENE_COMPOSITE))return false;
 if(!t->bytes||t->records<1||t->records>54||t->faces<1||t->faces>1564||t->size!=2*(t->records+1)+5*t->faces||t->size>8192||!t->fingerprint||!t->snapshot_fingerprint||b->snapshot_fingerprint!=t->snapshot_fingerprint||b->identity_fingerprint!=t->fingerprint)return false;
 if(!sc_begin(sr,sl))return false;
 /* One complete span scan, not the old admission scan plus another scan.
  * Charge every successful pair check, conservatively including legacy pairs. */
 unsigned live=0;for(unsigned i=0;i<15;i++)if(n[i])live++;
 memset(r,0,sizeof*r);return rrh_charge(r,RH_ADMISSION,15+live*(live-1)/2+6*live);
}
bool ksn_mesh_pixel_render_depth_bands_experimental(const ksn_mesh_pixel_snapshot*s,uint16_t*rgb,size_t rgbn,const KsnDepthBands*depth,ksn_bounded_ring_workspace*w,size_t wn,const ksn_aa_identity*t,const ksn_aa_ledger*limits,FoxPixelShader shader,void*context,size_t context_bytes,const KsnSceneBinding*binding,const KsnSceneLedger*new_limits,KsnSceneReport*new_report,KsnBandProfile profile,KsnBandHDRReport*rd){
 /* Snapshot before any opaque overlap callback. Admission retains the caller
  * descriptor span, while validation and rendering use only this private copy. */
 if(!depth||(uintptr_t)depth%_Alignof(KsnDepthBands)||!mesh_span_valid(depth,sizeof*depth))return false;
 const KsnDepthBands frozen_depth=*depth;const KsnDepthBands*original_depth=depth;depth=&frozen_depth;
 if(!profile||!db_admission(s,rgb,rgbn,original_depth,depth,w,wn,t,limits,context,context_bytes,binding,new_limits,new_report,rd))return false;
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
  bool ok=rrh_center_strip(&s->mesh,rgb+y*240,y,rows,depth->band[y/32]+(y%32)*240,&scene,&stats,NULL,NULL,shader,context,w,rd);w->report.center_shades=stats.shade_updates;if(!ok)return false;
  if(!sc_guard(new_report,SC_CENTER_STATE,0))return false;
  if(y&&!db_finish_row(w,y-1,w->delayed_center_hdr,rgb,depth,binding,new_report,profile,rd))return false;
  for(unsigned row=0;row<rows;row++){
   if(row==rows-1&&y+rows<135){if(!rrh_charge(rd,RH_COPY,720))return false;memcpy(w->delayed_center_hdr,w->reuse.hdr+row*240,sizeof w->delayed_center_hdr);}
   else if(!db_finish_row(w,y+row,w->reuse.hdr+row*240,rgb,depth,binding,new_report,profile,rd))return false;
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
   rgb[y*240+at]=sc_encode(mean);if(!rrh_encode(mean,rgb+y*240+at,profile,rd))return false;
  }
 }
 if(!sc_complete(binding,new_report)||rd->used[RH_PROFILE]!=32400)return false;
 w->report.complete=true;rd->complete=true;return true;
}
