#include "ksn_scene_composition.h"
_Static_assert(sizeof(KsnSceneQuery)==24,"scene query ABI");
_Static_assert(sizeof(KsnSceneResult)==40,"scene result ABI");
_Static_assert(sizeof(KsnSceneLedger)==160,"scene ledger ABI");
static const char *const sc_names[SC_CATEGORY_COUNT]={"bindingValidation","targetMaskCopyBytes","targetMaskFingerprintBytes","nonTargetCharacterStateRead","bandHDRClear","sampleEnumerationAndMaskTest","finalOutputScanAndMaskTest","queryPreparation","localCompositionResultZeroWords","compositionCallbackDispatch","returnedRGBValidation","decisionPrecedenceValidation","compositionEventCounters","selectedReplacementCopy","selectedOriginalMissHDRAccumulation","selectedSampleHDRAccumulation","nonTargetReplacementEncodeWrite","allOutputEncodeWrite","coreGuardDispatches","descriptorFingerprintBytes"};
const char *ksn_scene_category_name(unsigned k){return k<SC_CATEGORY_COUNT?sc_names[k]:"invalid";}
static bool sc_guard(KsnSceneReport*r,unsigned k,uint64_t n){
 if(r->observed.value[SC_GUARDS]>=r->reserved.value[SC_GUARDS]||r->observed_total>=KSN_SCENE_CORE_CAP){r->failed_category=SC_GUARDS;return false;}
 r->observed.value[SC_GUARDS]++;r->observed_total++;
 if(k>=SC_CATEGORY_COUNT||r->observed.value[k]>r->reserved.value[k]||n>r->reserved.value[k]-r->observed.value[k]||n>KSN_SCENE_CORE_CAP-r->observed_total){r->failed_category=k;return false;}return true;
}
static bool sc_charge(KsnSceneReport*r,unsigned k,uint64_t n){if(!sc_guard(r,k,n))return false;r->observed.value[k]+=n;r->observed_total+=n;return true;}
static bool sc_binding_spans(const KsnSceneBinding*b,const KsnSceneLedger*l,KsnSceneReport*r,const void*const*p,const size_t*n,unsigned count,unsigned mode){
 if(!b||!l||!r||!b->compose||!b->overlaps||!b->context||!b->context_bytes||!b->descriptor||!b->descriptor_bytes||!b->shadow_budget||b->shadow_budget_bytes!=48||b->mode!=mode||b->expected_targets>32400||!b->snapshot_fingerprint||!b->identity_fingerprint||!b->target_mask_fingerprint)return false;
 if(b->context_bytes>KSN_SCENE_OWNED_CAP||b->descriptor_bytes>KSN_SCENE_OWNED_CAP||b->resolver_owned_bytes>KSN_SCENE_OWNED_CAP||b->resolver_owned_bytes<b->context_bytes+b->descriptor_bytes+b->shadow_budget_bytes||b->resolver_owned_bytes+sizeof*b+sizeof*l+sizeof*r>KSN_SCENE_OWNED_CAP)return false;
 const void* own[]={b,l,r,b->context,b->descriptor,b->shadow_budget};const size_t sz[]={sizeof*b,sizeof*l,sizeof*r,b->context_bytes,b->descriptor_bytes,b->shadow_budget_bytes};
 for(unsigned i=0;i<6;i++){if(!mesh_span_valid(own[i],sz[i]))return false;for(unsigned j=0;j<i;j++)if(mesh_overlap(own[i],sz[i],own[j],sz[j]))return false;}
 uint64_t bg_budget[6];memcpy(bg_budget,b->shadow_budget,sizeof bg_budget);
 if(bg_budget[0]>2000000||bg_budget[1]>200000000||bg_budget[2]>100000000||bg_budget[3]>bg_budget[0]||bg_budget[4]>bg_budget[1]||bg_budget[5]>bg_budget[2])return false;
 /* The resolver overlap hook includes its context/descriptor/scene/budgets.
  * Its own spans are already validated; only disjoint external spans are queried. */
 for(unsigned i=0;i<count;i++){
  if(!n[i]){if(p[i])return false;continue;}if(!mesh_span_valid(p[i],n[i]))return false;
  for(unsigned j=0;j<i;j++)if(n[j]&&mesh_overlap(p[i],n[i],p[j],n[j]))return false;
  for(unsigned j=0;j<6;j++)if(mesh_overlap(p[i],n[i],own[j],sz[j]))return false;
 }
 /* Reject all declared-span aliases before invoking opaque context code. */
 for(unsigned i=0;i<3;i++)if(b->overlaps(b->context,own[i],sz[i]))return false;
 for(unsigned i=0;i<count;i++)if(n[i]&&b->overlaps(b->context,p[i],n[i]))return false;
 return true;
}
static bool sc_begin(KsnSceneReport*r,const KsnSceneLedger*l){
 memset(r,0,sizeof*r);r->failed_category=SC_CATEGORY_COUNT;r->reserved=*l;
 for(unsigned k=0;k<SC_CATEGORY_COUNT;k++){if(l->value[k]>KSN_SCENE_CORE_CAP-r->reserved_total)return false;r->reserved_total+=l->value[k];}
 /* Optional descriptor serializer is deliberately not executed. Its fixed
  * reservation may remain unused; opaque objects/padding are never hashed. */
 return sc_charge(r,SC_BINDING,512);
}
static bool sc_mask(const KsnSceneBinding*b,const ksn_aa_workspace*w,KsnSceneReport*r){
 return sc_charge(r,SC_MASK_HASH,sizeof w->targets)&&aa_hash(w->targets,sizeof w->targets)==b->target_mask_fingerprint;
}
static bool sc_resolve(const KsnSceneBinding*b,KsnSceneReport*r,unsigned x,unsigned y,unsigned sample,bool hit,float depth,KsnSceneResult*out){
 if(x>=240||y>=135||(sample>3&&sample!=UINT32_MAX)||(hit&&!isfinite(depth)))return false;
 if(!sc_charge(r,SC_QUERY,6)||!sc_charge(r,SC_RESULT_ZERO,5)||!sc_charge(r,SC_DISPATCH,1)||!sc_charge(r,SC_RGB_VALIDATE,3)||!sc_charge(r,SC_DECISION_VALIDATE,3)||!sc_charge(r,SC_EVENTS,2))return false;
 KsnSceneQuery q={x,y,sample,hit?1u:0u,hit?depth:0.0f,b->mode};
 memset(out,0,sizeof*out);r->queries++;if(sample==UINT32_MAX)r->centers++;else r->quarters++;
 if(!b->compose(b->context,&q,out))return false;
 for(unsigned k=0;k<3;k++)if(!isfinite(out->linear_rgb[k])||out->linear_rgb[k]<0)return false;
 if(out->floor_classification==KSN_SCENE_FLOOR_HIT){if(!isfinite(out->floor_native_depth)||!isfinite((float)out->floor_native_depth)||(double)(float)out->floor_native_depth!=out->floor_native_depth)return false;}
 else if(out->floor_classification==KSN_SCENE_SCENE_MISS){if(out->floor_native_depth!=0||signbit(out->floor_native_depth))return false;}
 else return false;
 if(out->action==KSN_SCENE_KEEP_CHARACTER){if(out->linear_rgb[0]!=0||signbit(out->linear_rgb[0])||out->linear_rgb[1]!=0||signbit(out->linear_rgb[1])||out->linear_rgb[2]!=0||signbit(out->linear_rgb[2])||!hit||(out->floor_classification==KSN_SCENE_FLOOR_HIT&&out->floor_native_depth>depth))return false;r->kept++;}
 else if(out->action==KSN_SCENE_REPLACE_FLOOR){if(out->floor_classification!=KSN_SCENE_FLOOR_HIT||(hit&&!(out->floor_native_depth>depth)))return false;r->floor++;if(hit)r->occluded_character++;}
 else if(out->action==KSN_SCENE_REPLACE_WORLD){if(hit||out->floor_classification!=KSN_SCENE_SCENE_MISS)return false;r->world++;}
 else return false;
 return true;
}
static uint16_t sc_encode(const double rgb[3]){
 unsigned q[3];for(unsigned k=0;k<3;k++){float v=ayatsuri_srgb_encode((float)fmin(1,rgb[k]));q[k]=(unsigned)lroundf(v*(k==1?63:31));}return (uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]);
}
static bool sc_complete(const KsnSceneBinding*b,KsnSceneReport*r){
 uint64_t q=32400+3*(uint64_t)b->expected_targets;
 if(r->queries!=q||r->centers!=32400-b->expected_targets||r->quarters!=4*(uint64_t)b->expected_targets||r->kept+r->floor+r->world!=q)return false;
 r->complete=true;return true;
}
static bool sc_shade_final(const ksn_mesh_pixel_snapshot*s,ksn_aa_workspace*w,const FoxDiskScene*scene,unsigned y,unsigned rows,unsigned sample,double dx,double dy,FoxPixelShader shader,void*context,KsnAASampleObserver observer,void*observer_context,const KsnSceneBinding*binding,KsnSceneReport*report){
 unsigned n=rows*240;if(!aa_guard(w,AA_FINAL_SCAN,n))return false;
 for(unsigned at=0;at<n;at++){w->report.observed.value[AA_FINAL_SCAN]++;w->report.observed_total++;
  unsigned p=y*240+at;if(!aa_target(w,p))continue;
  if(w->winner_record[at]==65535){w->report.sample_nohits[sample]++;
   if(observer){ksn_aa_sample event={.x=at%240,.y=y+at/240,.sample=sample,.record_offset=65535,.node=65535,.source_id=65535,.face=255,.depth=-INFINITY};if(!observer(observer_context,&event))return false;}
   KsnSceneResult result;if(!sc_resolve(binding,report,at%240,y+at/240,sample,false,0,&result)||!sc_charge(report,SC_REPLACEMENT_COPY,3)||!sc_charge(report,SC_ORIGINAL_MISS_ACCUM,6))return false;
   double chosen[3];memcpy(chosen,result.linear_rgb,sizeof chosen);for(unsigned k=0;k<3;k++){w->reuse.hdr[at][k]+=chosen[k];if(!isfinite(w->reuse.hdr[at][k]))return false;}continue;}
  if(!aa_charge(w,AA_FINAL_SHADE,76))return false;
  unsigned off=w->winner_record[at],face=w->winner_face[at];if(off>s->mesh.packets.size||s->mesh.packets.size-off<12)return false;
  const uint8_t*d=s->mesh.packets.data+off;unsigned node=aa_u16(d+4);if(node<1||node>w->record_count||w->offsets[node]!=off)return false;
  co_view v={d,aa_u16(d+10),(uint16_t)node,aa_u16(d+8),d[0],d[1],d[2]};
  uint8_t ix[3];co_vertex q[3];co_pixel_vertex fields[3];bool back;if(!co_triangle_at(&v,face,ix)||!co_triangle_side(&v,face,&back))return false;
  for(unsigned j=0;j<3;j++)if(!co_vertex_at_side(&v,ix[j],back,q+j)||!co_pixel_vertex_at(&v,ix[j],fields+j))return false;
  double area=((double)q[1].x-q[0].x)*((double)q[2].y-q[0].y)-((double)q[1].y-q[0].y)*((double)q[2].x-q[0].x),inverse=1/area;
  const gouraud_edge edge[3]={gouraud_make_edge(q+1,q+2),gouraud_make_edge(q+2,q),gouraud_make_edge(q,q+1)};
  double bary[3];for(unsigned k=0;k<3;k++)bary[k]=aa_edge_value(edge+k,(at%240)+dx,y+(at/240)+dy)*inverse;
  bool second=bary[0]*q[0].mask+bary[1]*q[1].mask+bary[2]*q[2].mask>=0;
  double world[3]={0},normal[3]={0},rho[3]={0};float decoded[3][3];
  for(unsigned j=0;j<3;j++){
   uint16_t code=second?q[j].color_b:q[j].color_a;const int16_t*normal_code=back?fields[j].normal_back:fields[j].normal_front;
   decoded[j][0]=ayatsuri_srgb_decode((code>>11)/31.0f);decoded[j][1]=ayatsuri_srgb_decode(((code>>5)&63)/63.0f);decoded[j][2]=ayatsuri_srgb_decode((code&31)/31.0f);
   for(unsigned k=0;k<3;k++){world[k]+=bary[j]*fields[j].world[k];normal[k]+=bary[j]*(normal_code[k]/32767.0);}
  }
  if(!ksn_aa_rho_affine(decoded,bary,rho))return false;
  const double position[3]={world[0]/38,-world[2]/38,-world[1]/38},nn[3]={normal[0],-normal[2],-normal[1]};double rgb[3];
  if(shader){if(!shader(context,scene,position,nn,rho,rgb))return false;}else if(fox_disk_eval16(scene,position,nn,rho,rgb)!=FOX_DISK_OK)return false;
  for(unsigned k=0;k<3;k++)if(!isfinite(rgb[k])||rgb[k]<0)return false;
  w->report.sample_hits[sample]++;w->report.sample_shades++;
  if(observer){ksn_aa_sample event={.x=at%240,.y=y+at/240,.sample=sample,.hit=true,.record_offset=(uint16_t)off,.node=(uint16_t)node,.source_id=w->source[node][face],.face=(uint8_t)face,.back=back,.depth=w->winner_depth[at]};memcpy(event.position,position,sizeof position);memcpy(event.normal,nn,sizeof nn);memcpy(event.rho,rho,sizeof rho);memcpy(event.linear_rgb,rgb,sizeof rgb);if(!observer(observer_context,&event))return false;}
  KsnSceneResult result;if(!sc_resolve(binding,report,at%240,y+at/240,sample,true,w->winner_depth[at],&result))return false;
  if(result.action!=KSN_SCENE_KEEP_CHARACTER){if(!sc_charge(report,SC_REPLACEMENT_COPY,3))return false;memcpy(rgb,result.linear_rgb,sizeof rgb);}
  /* Exactly the original one addition per covered character sample, performed
   * after choosing its camera-visible radiance. KEEP operand is untouched. */
  for(unsigned k=0;k<3;k++){w->reuse.hdr[at][k]+=rgb[k];if(!isfinite(w->reuse.hdr[at][k]))return false;}
 }
 return true;
}
static __attribute__((noinline)) bool sc_composite_admission(const ksn_mesh_pixel_snapshot*s,uint16_t*rgb,float*depth,ksn_aa_workspace*w,const ksn_aa_identity*t,const ksn_aa_ledger*limits,void*context,size_t context_bytes,void*observer_context,size_t observer_bytes,const KsnSceneBinding*binding,const KsnSceneLedger*new_limits,KsnSceneReport*new_report){
 if(!s||!rgb||!depth||!w||!t||!limits||!t->bytes||t->records<1||t->records>54||t->faces<1||t->faces>1564||t->size!=2*(t->records+1)+5*t->faces||t->size>8192||!t->fingerprint||!t->snapshot_fingerprint)return false;
 const void *ptr[]={s,s->storage,rgb,depth,w,t,t->bytes,limits};const size_t size[]={sizeof*s,s->capacity,KSN_AA_PIXELS*2,KSN_AA_PIXELS*4,sizeof*w,sizeof*t,t->size,sizeof*limits};
 for(unsigned i=0;i<8;i++){if(!mesh_span_valid(ptr[i],size[i]))return false;for(unsigned j=0;j<i;j++)if(mesh_overlap(ptr[i],size[i],ptr[j],size[j]))return false;}
 if(context&&(mesh_overlap(w,sizeof*w,context,1)||mesh_overlap(rgb,KSN_AA_PIXELS*2,context,1)||mesh_overlap(depth,KSN_AA_PIXELS*4,context,1)))return false;
 if(observer_context&&(mesh_overlap(w,sizeof*w,observer_context,1)||mesh_overlap(rgb,KSN_AA_PIXELS*2,observer_context,1)||mesh_overlap(depth,KSN_AA_PIXELS*4,observer_context,1)))return false;
 const void* extra[]={s,s->storage,rgb,depth,w,t,t->bytes,limits,context,observer_context};const size_t extra_n[]={sizeof*s,s->capacity,KSN_AA_PIXELS*2,KSN_AA_PIXELS*4,sizeof*w,sizeof*t,t->size,sizeof*limits,context_bytes,observer_bytes};
 if(!sc_binding_spans(binding,new_limits,new_report,extra,extra_n,10,KSN_SCENE_COMPOSITE)||binding->snapshot_fingerprint!=t->snapshot_fingerprint||binding->identity_fingerprint!=t->fingerprint||!sc_begin(new_report,new_limits))return false;
 return true;
}
bool ksn_mesh_pixel_render_scene_composition_experimental(const ksn_mesh_pixel_snapshot*s,uint16_t*rgb,float*depth,ksn_aa_workspace*w,const ksn_aa_identity*t,const ksn_aa_ledger*limits,FoxPixelShader shader,void*context,size_t context_bytes,KsnAASampleObserver observer,void*observer_context,size_t observer_bytes,const KsnSceneBinding*binding,const KsnSceneLedger*new_limits,KsnSceneReport*new_report){
 if(!binding)return ksn_mesh_pixel_render_boundary_experimental(s,rgb,depth,w,t,limits,shader,context,observer,observer_context);
 if(!sc_composite_admission(s,rgb,depth,w,t,limits,context,context_bytes,observer_context,observer_bytes,binding,new_limits,new_report))return false;
 memset(&w->report,0,sizeof w->report);w->report.failed_category=AA_CATEGORY_COUNT;w->report.reserved=*limits;
 for(unsigned k=0;k<AA_CATEGORY_COUNT;k++){if(limits->value[k]>8000000-w->report.reserved_total)return false;w->report.reserved_total+=limits->value[k];}
 FoxDiskScene scene;if(!aa_charge(w,AA_CONTROL,128)||!pixel_scene(s,&scene)||!aa_bind(s,w,t)||!aa_charge(w,AA_LEGACY_CENTER,s->mesh.work)||!aa_charge(w,AA_CENTER_ID_INIT,KSN_AA_PIXELS))return false;
 memset(w->center_id,0xff,sizeof w->center_id);ksn_mesh_pixel_stats stats={0};
 for(unsigned y=0;y<135;y+=8){unsigned rows=135-y;if(rows>8)rows=8;if(!aa_charge(w,AA_CONTROL,1))return false;bool center_ok=aa_center_strip(&s->mesh,rgb+y*240,y,rows,depth+y*240,&scene,&stats,NULL,NULL,shader,context,w);w->report.center_shades=stats.shade_updates;if(!center_ok)return false;}
 if(!aa_select(w)||w->report.targets!=binding->expected_targets||!sc_mask(binding,w,new_report))return false;
 if(new_limits->value[SC_CENTER_STATE]<2u*(KSN_AA_PIXELS-binding->expected_targets)){new_report->failed_category=SC_CENTER_STATE;return false;}
 static const double dx[4]={-.25,.25,-.25,.25},dy[4]={-.25,-.25,.25,.25};
 for(unsigned y=0;y<135;y+=8){unsigned rows=135-y;if(rows>8)rows=8;unsigned n=rows*240;if(!aa_charge(w,AA_CONTROL,1)||!aa_charge(w,AA_HDR_CLEAR,3*n))return false;memset(w->reuse.hdr,0,n*3*sizeof(double));
  for(unsigned sample=0;sample<4;sample++)if(!aa_charge(w,AA_CONTROL,1)||!aa_geometry(s,w,y,rows,dx[sample],dy[sample])||!sc_shade_final(s,w,&scene,y,rows,sample,dx[sample],dy[sample],shader,context,observer,observer_context,binding,new_report))return false;
  if(!aa_guard(w,AA_FINAL_OUTPUT_SCAN,n))return false;
  if(!sc_guard(new_report,SC_CENTER_STATE,0))return false;
  for(unsigned at=0;at<n;at++){w->report.observed.value[AA_FINAL_OUTPUT_SCAN]++;w->report.observed_total++;if(aa_target(w,y*240+at)){
   if(!aa_charge(w,AA_FINAL_ENCODE,8))return false;unsigned q[3];for(unsigned k=0;k<3;k++){double mean=w->reuse.hdr[at][k]/4;float value=ayatsuri_srgb_encode((float)fmin(1,mean));q[k]=(unsigned)lroundf(value*(k==1?63:31));}
   rgb[y*240+at]=(uint16_t)((q[0]<<11)|(q[1]<<5)|q[2]);
  }else{
   new_report->observed.value[SC_CENTER_STATE]+=2;new_report->observed_total+=2;
   bool hit=w->center_id[y*240+at]!=KSN_AA_NOHIT;KsnSceneResult result;
   if(!sc_resolve(binding,new_report,at%240,y+at/240,UINT32_MAX,hit,hit?depth[y*240+at]:0,&result))return false;
   if(result.action!=KSN_SCENE_KEEP_CHARACTER){if(!sc_charge(new_report,SC_CENTER_ENCODE,8))return false;rgb[y*240+at]=sc_encode(result.linear_rgb);}
  }}
 }
 if(!sc_complete(binding,new_report))return false;w->report.complete=true;return true;
}

bool ksn_mesh_pixel_render_background_control_experimental(uint16_t*rgb,ksn_aa_workspace*w,const uint8_t*mask,size_t mask_bytes,const KsnSceneBinding*b,const KsnSceneLedger*l,KsnSceneReport*r){
 if(!rgb||!w||!mask||mask_bytes!=sizeof w->targets)return false;
 const void*p[]={rgb,w,mask};const size_t n[]={64800,sizeof*w,mask_bytes};
 if(!sc_binding_spans(b,l,r,p,n,3,KSN_SCENE_BACKGROUND_ONLY)||b->resolver_owned_bytes+sizeof*b+sizeof*l+sizeof*r+mask_bytes>KSN_SCENE_OWNED_CAP||!sc_begin(r,l)||!sc_charge(r,SC_MASK_COPY,mask_bytes))return false;
 memcpy(w->targets,mask,mask_bytes);if(!sc_mask(b,w,r))return false;
 memset(&w->report,0,sizeof w->report); /* no legacy character work is claimed */
 for(unsigned y=0;y<135;y+=8){unsigned rows=135-y;if(rows>8)rows=8;unsigned count=240*rows;
  if(!sc_charge(r,SC_HDR_CLEAR,3*count))return false;memset(w->reuse.hdr,0,count*3*sizeof(double));
  for(unsigned sample=0;sample<4;sample++){
   if(!sc_guard(r,SC_SAMPLE_SCAN,count))return false;
   for(unsigned at=0;at<count;at++){r->observed.value[SC_SAMPLE_SCAN]++;r->observed_total++;if(!aa_target(w,y*240+at))continue;
    KsnSceneResult result;if(!sc_resolve(b,r,at%240,y+at/240,sample,false,0,&result)||!sc_charge(r,SC_CONTROL_ACCUM,6))return false;
    for(unsigned k=0;k<3;k++){w->reuse.hdr[at][k]+=result.linear_rgb[k];if(!isfinite(w->reuse.hdr[at][k]))return false;}
   }
  }
  if(!sc_guard(r,SC_OUTPUT_SCAN,count))return false;
  for(unsigned at=0;at<count;at++){r->observed.value[SC_OUTPUT_SCAN]++;r->observed_total++;
   if(aa_target(w,y*240+at)){if(!sc_charge(r,SC_CONTROL_ENCODE,8))return false;double mean[3];for(unsigned k=0;k<3;k++)mean[k]=w->reuse.hdr[at][k]/4;rgb[y*240+at]=sc_encode(mean);}
   else{KsnSceneResult result;if(!sc_resolve(b,r,at%240,y+at/240,UINT32_MAX,false,0,&result)||!sc_charge(r,SC_CONTROL_ENCODE,8))return false;rgb[y*240+at]=sc_encode(result.linear_rgb);}
  }
 }
 return sc_complete(b,r);
}
