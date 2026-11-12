/* Isolated review-only mock core + real bridge final-verification gate. */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "row_transport_bridge.h"
static bool mock_core(const ksn_mesh_pixel_snapshot*,uint16_t*,size_t,const KsnDepthBands*,ksn_bounded_ring_workspace*,size_t,const ksn_aa_identity*,const ksn_aa_ledger*,FoxPixelShader,void*,size_t,const KsnSceneBinding*,const KsnSceneLedger*,KsnSceneReport*,KsnBandProfile,KsnBandHDRReport*);
#define ksn_mesh_pixel_render_depth_bands_experimental mock_core
#include "row_transport_bridge.c"
#undef ksn_mesh_pixel_render_depth_bands_experimental
#include "depth_band_alloc.h"
static unsigned mode,calls;static RowHostVerification *verify;static uint8_t *identity;
static bool mock_core(const ksn_mesh_pixel_snapshot*s,uint16_t*rgb,size_t rgbn,const KsnDepthBands*d,ksn_bounded_ring_workspace*w,size_t wn,const ksn_aa_identity*t,const ksn_aa_ledger*l,FoxPixelShader shader,void*context,size_t cn,const KsnSceneBinding*b,const KsnSceneLedger*sl,KsnSceneReport*sr,KsnBandProfile profile,KsnBandHDRReport*hr){
 (void)rgbn;(void)w;(void)wn;(void)t;(void)l;(void)shader;(void)cn;(void)b;(void)sl;(void)profile;
 calls++;memset(hr,0,sizeof*hr);memset(sr,0,sizeof*sr);hr->complete=sr->complete=true;hr->used[RH_ADMISSION]=210;
 memset(rgb,0x23,64800);for(unsigned k=0;k<5;k++)memset(d->band[k],0x24,d->bytes[k]);
 if(mode==0)((uint8_t*)s->storage)[10]^=1;if(mode==1)identity[3]^=1;if(mode==2)((fox_transport_context*)context)->expected.material++;if(mode==3)verify->used=verify->limit;
 return true;
}
static bool mock_owned(void*p,const void*q,size_t n){return overlap(p,32,q,n);}
int main(void){
 RowHostVerification hv={73728,0};assert(row_bands_hash_prepay(&hv,64208,7930)&&hv.used==72138);hv.used=1591;assert(!row_bands_hash_prepay(&hv,64208,7930)&&hv.used==1591);hv.limit=73729;hv.used=0;assert(!row_bands_hash_prepay(&hv,1,1)&&!hv.used);hv=(RowHostVerification){73728,0};assert(!row_bands_hash_prepay(&hv,SIZE_MAX,1)&&!hv.used);
 FoxDiskLightInput light[3]={0};for(unsigned j=0;j<3;j++){light[j].shape=FOX_DISK_SHAPE_DISK;light[j].diameter=1;light[j].power=1;light[j].center[2]=10;for(unsigned k=0;k<3;k++)light[j].color[k]=1;}FoxDiskScene disks;double world[3]={1,1,1};assert(fox_disk_scene_init(&disks,light,world,1)==FOX_DISK_OK);
 double xyz[9]={0,0,0,1,0,0,0,1,0};uint32_t ix[3]={0,1,2};vis_scene*vs=NULL;vis_generation vg={1,1,1};assert(vis_scene_build(&vs,xyz,3,ix,1,vg,(vis_limits){2048,4095,524288})==VIS_OK);
 uint8_t storage[1024];ksn_mesh_pixel_snapshot snap;assert(ksn_mesh_pixel_begin(&snap,storage,sizeof storage,&disks,8000000));fox_pixel_binding pb={0};assert(fox_pixel_bind(&pb,vs,vg,&snap)==VIS_OK);
 bounce_triangle attr={0};for(unsigned j=0;j<3;j++){attr.v[j].front[2]=32767;attr.v[j].back[2]=-32767;}bounce_scene*bs=NULL;bounce_generation gen={vg,1,0};assert(bounce_scene_build(&bs,vs,&attr,1,&disks,1,gen,262144)==BOUNCE_OK);
 vis_budget db={{1000000,100000000,50000000},{0}},tb={{20000000,800000000,300000000},{0}},bb={{FOX_BG_SHADOW_RAYS,FOX_BG_SHADOW_NODES,FOX_BG_SHADOW_TRIANGLES},{0}};bounce_floor_work fw={0};fox_transport_context tx={.snapshot_binding=&pb,.expected=gen,.direct_budget=&db,.transport_budget=&tb,.floor_work=&fw};assert(bounce_binding_set(&tx.binding,bs,gen)==BOUNCE_OK);
 uint8_t identity_bytes[9]={0};ksn_aa_identity id={identity_bytes,9,1,1,fox_bg_fingerprint(identity_bytes,9),pb.snapshot_hash};ksn_aa_ledger l={0};KsnSceneLedger sl={0};KsnSceneReport sr={0};KsnBandHDRReport hr={0};fox_bg_work bw={0};char context[32]={0},descriptor[32]={0};KsnSceneBinding bg={.overlaps=mock_owned,.context=context,.context_bytes=sizeof context,.descriptor=descriptor,.descriptor_bytes=sizeof descriptor,.shadow_budget=&bb,.shadow_budget_bytes=sizeof bb};
 uint16_t*pixels=malloc(64800),*old=malloc(64800);float*depth=malloc(129600),*olddepth=malloc(129600);ksn_bounded_ring_workspace*w=calloc(1,sizeof*w);assert(pixels&&old&&depth&&olddepth&&w);memset(pixels,0x5a,64800);memset(depth,0xa5,129600);memcpy(old,pixels,64800);memcpy(olddepth,depth,129600);
 KsnDepthBands bands;assert(depth_bands_allocate(&bands,malloc));for(unsigned k=0;k<5;k++)memset(bands.band[k],0xa5,bands.bytes[k]);
 RowRenderBands a={&tx,&snap,pixels,bands,w,&id,&l,&bg,&sl,&sr,&hr,&bw,&hv};assert(row_bands_validate(&a));unsigned negatives=0;
 uint16_t *committed=malloc(64800);assert(committed);memcpy(committed,pixels,64800);unsigned published=0;
 for(unsigned world=0;world<2;world++)for(unsigned fault=0;fault<4;fault++){
  bounce_floor_world_work ww={0};tx.floor_world_work=world?&ww:NULL;hv.used=0;mode=fault;calls=0;verify=&hv;identity=identity_bytes;assert(row_bands_validate(&a));
  bool ok=row_transport_render_bands(&a);
  if(ok){memcpy(committed,pixels,64800);for(unsigned k=0;k<5;k++)memcpy((char*)depth+k*30720,bands.band[k],bands.bytes[k]);published++;}
  assert(!ok&&calls==1&&!hr.complete&&sr.complete&&!published);assert(!memcmp(committed,old,64800));assert(!memcmp(depth,olddepth,129600));
  assert(hr.used[RH_ADMISSION]==(world?616:588));assert(hr.used[RH_GUARDS]==1024);
  if(fault==0)storage[10]^=1;if(fault==1)identity_bytes[3]^=1;if(fault==2)tx.expected.material--;if(fault==3)hv.used=0;
  negatives++;
 }
 printf("{\"status\":\"PASS\",\"realWrapperLateFailureCases\":%u,\"mockCoreCallsPerCase\":1,\"publicationBranchCalls\":%u,\"physicalShaderCalls\":0,\"actualFrames\":0}\n",negatives,published);
 depth_bands_release(&bands);free(committed);free(pixels);free(old);free(depth);free(olddepth);free(w);bounce_binding_clear(&tx.binding);bounce_scene_release(bs);fox_pixel_unbind(&pb);vis_scene_release(vs);return 0;
}
