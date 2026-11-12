/* Mechanically specialized pinned workspace-dependent helpers. */
static bool ring_aa_guard(ksn_bounded_ring_workspace *w,unsigned k,uint64_t n){
 if(w->report.observed.value[AA_COUNTER_GUARDS]>=w->report.reserved.value[AA_COUNTER_GUARDS]||w->report.observed_total>=8000000){w->report.failed_category=AA_COUNTER_GUARDS;return false;}
 w->report.observed.value[AA_COUNTER_GUARDS]++;w->report.observed_total++;
 if(k>=AA_CATEGORY_COUNT||w->report.observed.value[k]>w->report.reserved.value[k]||n>w->report.reserved.value[k]-w->report.observed.value[k]||n>8000000-w->report.observed_total){w->report.failed_category=k;return false;}
 return true;
}
static bool ring_aa_charge(ksn_bounded_ring_workspace *w,unsigned k,uint64_t n){
 if(!ring_aa_guard(w,k,n))return false;w->report.observed.value[k]+=n;w->report.observed_total+=n;return true;
}
static bool ring_aa_bind(const ksn_mesh_pixel_snapshot*s,ksn_bounded_ring_workspace*w,const ksn_aa_identity*t){
 if(!ring_aa_charge(w,AA_IDENTITY_HASH,t->size)||!ring_aa_charge(w,AA_SNAPSHOT_BINDING_HASH,416+s->mesh.packets.size))return false;
 w->report.source_fingerprint=aa_hash(t->bytes,t->size);w->report.snapshot_fingerprint=aa_hash(s->storage,416+s->mesh.packets.size);
 if(w->report.source_fingerprint!=t->fingerprint||w->report.snapshot_fingerprint!=t->snapshot_fingerprint)return false;
 if(aa_u16(t->bytes)||aa_u16(t->bytes+2*t->records)!=t->faces)return false;
 if(!ring_aa_charge(w,AA_SOURCE_VALIDATE,(KSN_AA_MAX_RECORDS+1)*64+(KSN_AA_MAX_RECORDS+1)))return false;
 memset(w->source,0xff,sizeof w->source);memset(w->offsets,0xff,sizeof w->offsets);
 if(!ring_aa_charge(w,AA_IDENTITY_KEY_CLEAR,sizeof w->reuse.identity_key))return false;memset(w->reuse.identity_key,0,sizeof w->reuse.identity_key);
 size_t off=0;uint64_t seen=0;unsigned total=0;w->record_count=0;
 while(off<s->mesh.packets.size){
  if(!ring_aa_charge(w,AA_CONTROL,1)||!ring_aa_charge(w,AA_SOURCE_VALIDATE,16))return false;
  if(w->record_count>=t->records||off>UINT16_MAX)return false;
  co_view *v=&w->records[w->record_count];
  if(!co_read(s->mesh.packets.data+off,s->mesh.packets.size-off,v)||(v->mode!=4&&v->mode!=5)||v->node<1||v->node>t->records)return false;
  if(seen&(UINT64_C(1)<<(v->node-1)))return false;seen|=UINT64_C(1)<<(v->node-1);
  unsigned first=aa_u16(t->bytes+2*(v->node-1)),end=aa_u16(t->bytes+2*v->node);
  if(first>end||end>t->faces||end-first!=v->triangle_count)return false;
  for(unsigned j=first;j<end;j++){
   if(!ring_aa_charge(w,AA_SOURCE_VALIDATE,8))return false;
   const uint8_t *e=t->bytes+2*(t->records+1)+5*j;
   if(e[0]>=v->vertex_count||e[1]>=v->vertex_count||e[2]>=v->vertex_count||e[0]==e[1]||e[0]==e[2]||e[1]==e[2]||aa_u16(e+3)>91)return false;
   unsigned key=aa_key(e);if(key>=4960||(w->reuse.identity_key[key]>>8)==v->node)return false;w->reuse.identity_key[key]=(uint16_t)((v->node<<8)|(j-first+1));
  }
  uint64_t matched=0;
  for(unsigned f=0;f<v->triangle_count;f++){
   if(!ring_aa_charge(w,AA_SOURCE_VALIDATE,8))return false;
   uint8_t ix[3];bool back;if(!co_triangle_at(v,f,ix)||!co_triangle_side(v,f,&back))return false;
   unsigned key=aa_key(ix),slot=key<4960?w->reuse.identity_key[key]:0;
   if((slot>>8)!=v->node)return false;unsigned local=(slot&255)-1;
   if(local>=end-first||(matched&(UINT64_C(1)<<local)))return false;matched|=UINT64_C(1)<<local;
   const uint8_t *e=t->bytes+2*(t->records+1)+5*(first+local);
   if((aa_parity(ix)^aa_parity(e))!=(unsigned)back)return false;
   /* co_read validates every owned field, including hidden/non-target vertices.
    * Area is also unconditional, never deferred until a selected sample. */
   co_vertex q[3];for(unsigned j=0;j<3;j++)if(!co_vertex_at(v,ix[j],q+j))return false;
   double a=((double)q[1].x-q[0].x)*((double)q[2].y-q[0].y)-((double)q[1].y-q[0].y)*((double)q[2].x-q[0].x);
   if(!(a>1e-5)||!isfinite(a))return false;
   w->source[v->node][f]=aa_u16(e+3);
  }
  w->offsets[v->node]=(uint16_t)off;total+=v->triangle_count;w->record_count++;off+=v->size;
 }
 return off==s->mesh.packets.size&&w->record_count==t->records&&total==t->faces&&s->mesh.packets.packets==t->records;
}
static bool ring_aa_target(const ksn_bounded_ring_workspace*w,unsigned p){return (w->targets[p>>3]>>(p&7))&1u;}
static bool ring_aa_geometry(const ksn_mesh_pixel_snapshot*s,ksn_bounded_ring_workspace*w,unsigned y,unsigned rows,double dx,double dy){
 unsigned n=240*rows;if(!ring_aa_charge(w,AA_SAMPLE_CLEAR,2*n))return false;
 for(unsigned p=0;p<n;p++){w->winner_record[p]=65535;w->winner_face[p]=255;w->winner_depth[p]=-INFINITY;}
 for(unsigned ri=0;ri<w->record_count;ri++){
  if(!ring_aa_charge(w,AA_RECORD_VISIT,1))return false;const co_view*v=&w->records[ri];
  for(unsigned f=0;f<v->triangle_count;f++){
   if(!ring_aa_charge(w,AA_FACE_SETUP,16))return false;
   uint8_t ix[3];co_vertex q[3];bool back;if(!co_triangle_at(v,f,ix)||!co_triangle_side(v,f,&back))return false;
   for(unsigned j=0;j<3;j++)if(!co_vertex_at_side(v,ix[j],back,q+j))return false;
   const double area=((double)q[1].x-q[0].x)*((double)q[2].y-q[0].y)-((double)q[1].y-q[0].y)*((double)q[2].x-q[0].x),inverse=1/area;
   if(!(area>1e-5)||!isfinite(area))return false;
   int l=(int)ceil(fmin(q[0].x,fmin(q[1].x,q[2].x))-dx),r=(int)floor(fmax(q[0].x,fmax(q[1].x,q[2].x))-dx);
   int t=(int)ceil(fmin(q[0].y,fmin(q[1].y,q[2].y))-dy),b=(int)floor(fmax(q[0].y,fmax(q[1].y,q[2].y))-dy);
   if(l<0)l=0;if(r>239)r=239;if(t<(int)y)t=(int)y;if(b>=(int)(y+rows))b=(int)(y+rows)-1;
   gouraud_edge edge[3]={gouraud_make_edge(q+1,q+2),gouraud_make_edge(q+2,q),gouraud_make_edge(q,q+1)};
   if(l<=r&&t<=b&&!ring_aa_guard(w,AA_BBOX_MASK,2u*(unsigned)(r-l+1)*(unsigned)(b-t+1)))return false;
   for(int yy=t;yy<=b;yy++)for(int x=l;x<=r;x++){
    w->report.observed.value[AA_BBOX_MASK]+=2;w->report.observed_total+=2;unsigned p=(unsigned)yy*240+(unsigned)x;if(!ring_aa_target(w,p))continue;
    if(!ring_aa_charge(w,AA_TARGET_GEOMETRY,12))return false;
    double bary[3];bool inside=true;for(unsigned k=0;k<3;k++){bary[k]=aa_edge_value(edge+k,x+dx,yy+dy);if(bary[k]<0||(bary[k]==0&&!edge[k].closed))inside=false;}
    if(!inside)continue;for(unsigned k=0;k<3;k++)bary[k]*=inverse;
    float depth=(float)(bary[0]*q[0].depth+bary[1]*q[1].depth+bary[2]*q[2].depth);if(!isfinite(depth))return false;
    unsigned at=((unsigned)yy-y)*240+(unsigned)x;if(depth<=w->winner_depth[at])continue;
    w->winner_depth[at]=depth;w->winner_record[at]=(uint16_t)(v->data-s->mesh.packets.data);w->winner_face[at]=(uint8_t)f;
   }
  }
 }
 return true;
}
static bool ring_sc_mask(const KsnSceneBinding*b,const ksn_bounded_ring_workspace*w,KsnSceneReport*r){
 return sc_charge(r,SC_MASK_HASH,sizeof w->targets)&&aa_hash(w->targets,sizeof w->targets)==b->target_mask_fingerprint;
}
static bool ring_sc_shade_final(const ksn_mesh_pixel_snapshot*s,ksn_bounded_ring_workspace*w,const FoxDiskScene*scene,unsigned y,unsigned rows,unsigned sample,double dx,double dy,FoxPixelShader shader,void*context,KsnAASampleObserver observer,void*observer_context,const KsnSceneBinding*binding,KsnSceneReport*report){
 unsigned n=rows*240;if(!ring_aa_guard(w,AA_FINAL_SCAN,n))return false;
 for(unsigned at=0;at<n;at++){w->report.observed.value[AA_FINAL_SCAN]++;w->report.observed_total++;
  unsigned p=y*240+at;if(!ring_aa_target(w,p))continue;
  if(w->winner_record[at]==65535){w->report.sample_nohits[sample]++;
   if(observer){ksn_aa_sample event={.x=at%240,.y=y+at/240,.sample=sample,.record_offset=65535,.node=65535,.source_id=65535,.face=255,.depth=-INFINITY};if(!observer(observer_context,&event))return false;}
   KsnSceneResult result;if(!sc_resolve(binding,report,at%240,y+at/240,sample,false,0,&result)||!sc_charge(report,SC_REPLACEMENT_COPY,3)||!sc_charge(report,SC_ORIGINAL_MISS_ACCUM,6))return false;
   double chosen[3];memcpy(chosen,result.linear_rgb,sizeof chosen);for(unsigned k=0;k<3;k++){w->reuse.hdr[at][k]+=chosen[k];if(!isfinite(w->reuse.hdr[at][k]))return false;}continue;}
  if(!ring_aa_charge(w,AA_FINAL_SHADE,76))return false;
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
