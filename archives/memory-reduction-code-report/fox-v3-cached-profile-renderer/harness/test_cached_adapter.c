#include "profile_cache_owner.h"
static void *fail_allocate(size_t n){(void)n;return NULL;}
/* Small synthetic adapter admission/finish tests. No physical shader runs. */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "row_transport_bridge.c"
static bool mock_owned(void*p,const void*q,size_t n){return overlap(p,32,q,n);}
int main(void){
 RowHostVerification hv={73728,0};assert(row_hash_prepay(&hv,64208,7930)&&hv.used==72138);hv.used=1591;assert(!row_hash_prepay(&hv,64208,7930)&&hv.used==1591);hv.limit=73729;hv.used=0;assert(!row_hash_prepay(&hv,1,1)&&!hv.used);hv=(RowHostVerification){73728,0};assert(!row_hash_prepay(&hv,SIZE_MAX,1)&&!hv.used);
 FoxDiskLightInput light[3]={0};for(unsigned j=0;j<3;j++){light[j].shape=FOX_DISK_SHAPE_DISK;light[j].diameter=1;light[j].power=1;light[j].center[2]=10;for(unsigned k=0;k<3;k++)light[j].color[k]=1;}FoxDiskScene disks;double world[3]={1,1,1};assert(fox_disk_scene_init(&disks,light,world,1)==FOX_DISK_OK);
 double xyz[9]={0,0,0,1,0,0,0,1,0};uint32_t ix[3]={0,1,2};vis_scene*vs=NULL;vis_generation vg={1,1,1};assert(vis_scene_build(&vs,xyz,3,ix,1,vg,(vis_limits){2048,4095,524288})==VIS_OK);
 uint8_t storage[1024];ksn_mesh_pixel_snapshot snap;assert(ksn_mesh_pixel_begin(&snap,storage,sizeof storage,&disks,8000000));fox_pixel_binding pb={0};assert(fox_pixel_bind(&pb,vs,vg,&snap)==VIS_OK);
 bounce_triangle attr={0};for(unsigned j=0;j<3;j++){attr.v[j].front[2]=32767;attr.v[j].back[2]=-32767;}bounce_scene*bs=NULL;bounce_generation gen={vg,1,0};assert(bounce_scene_build(&bs,vs,&attr,1,&disks,1,gen,262144)==BOUNCE_OK);
 vis_budget db={{1000000,100000000,50000000},{0}},tb={{20000000,800000000,300000000},{0}},bb={{FOX_BG_SHADOW_RAYS,FOX_BG_SHADOW_NODES,FOX_BG_SHADOW_TRIANGLES},{0}};bounce_floor_work fw={0};fox_transport_context tx={.snapshot_binding=&pb,.expected=gen,.direct_budget=&db,.transport_budget=&tb,.floor_work=&fw};assert(bounce_binding_set(&tx.binding,bs,gen)==BOUNCE_OK);
 uint8_t identity_bytes[9]={0};ksn_aa_identity id={identity_bytes,9,1,1,fox_bg_fingerprint(identity_bytes,9),pb.snapshot_hash};ksn_aa_ledger l={0};KsnSceneLedger sl={0};KsnSceneReport sr={0};KsnBandHDRReport hr={0};fox_bg_work bw={0};char context[32]={0},descriptor[32]={0};KsnSceneBinding bg={.overlaps=mock_owned,.context=context,.context_bytes=sizeof context,.descriptor=descriptor,.descriptor_bytes=sizeof descriptor,.shadow_budget=&bb,.shadow_budget_bytes=sizeof bb};
 uint16_t*pixels=malloc(64800),*old=malloc(64800);float*depth=malloc(129600),*olddepth=malloc(129600);ksn_bounded_ring_workspace*w=calloc(1,sizeof*w);assert(pixels&&old&&depth&&olddepth&&w);memset(pixels,0x5a,64800);memset(depth,0xa5,129600);memcpy(old,pixels,64800);memcpy(olddepth,depth,129600);
 RowRender a={&tx,&snap,pixels,depth,w,&id,&l,&bg,&sl,&sr,&hr,&bw,&hv};assert(row_validate(&a));unsigned negatives=3;
 bounce_floor_world_work ww={0};tx.floor_world_work=&ww;assert(row_validate(&a));
 size_t lutn=0;const void*lut=row_profile_storage(&lutn);
 const void*world_aliases[]={&a,&tx,&db,&tb,&pb,&fw,&snap,storage,pixels,depth,w,&id,identity_bytes,&l,&bg,&sl,&sr,&hr,context,descriptor,&bb,&bw,&hv,lut};
 for(unsigned i=0;i<sizeof world_aliases/sizeof*world_aliases;i++){tx.floor_world_work=(void*)world_aliases[i];assert(!row_validate(&a));negatives++;}
 const size_t world_alias_sizes[]={sizeof a,sizeof tx,sizeof db,sizeof tb,sizeof pb,sizeof fw,sizeof snap,sizeof storage,64800,129600,sizeof*w,sizeof id,sizeof identity_bytes,sizeof l,sizeof bg,sizeof sl,sizeof sr,sizeof hr,sizeof context,sizeof descriptor,sizeof bb,sizeof bw,sizeof hv,lutn};
 for(unsigned i=0;i<24;i++){tx.floor_world_work=(void*)((uintptr_t)world_aliases[i]+world_alias_sizes[i]-1);assert(!row_validate(&a));negatives++;tx.floor_world_work=(void*)((uintptr_t)world_aliases[i]-1);assert(!row_validate(&a));negatives++;}
 tx.floor_world_work=(void*)vs;assert(!row_validate(&a));negatives++;tx.floor_world_work=(void*)bs;assert(!row_validate(&a));negatives++;
 tx.floor_world_work=(void*)(UINTPTR_MAX-7);assert(!row_validate(&a));negatives++;
 tx.floor_world_work=NULL;
 tx.expected.visibility.geometry++;assert(!row_validate(&a));tx.expected.visibility.geometry--;negatives++;
 pb.snapshot_bytes++;assert(!row_validate(&a));pb.snapshot_bytes--;negatives++;
 id.snapshot_fingerprint++;assert(!row_validate(&a));id.snapshot_fingerprint--;negatives++;
 db.used.rays=db.limit.rays+1;assert(!row_validate(&a));db.used.rays=0;negatives++;
 tb.used.triangle_tests=tb.limit.triangle_tests+1;assert(!row_validate(&a));tb.used.triangle_tests=0;negatives++;
 bb.used.rays=bb.limit.rays+1;assert(!row_validate(&a));bb.used.rays=0;negatives++;
 bw.used_total=1;assert(!row_validate(&a));bw.used_total=0;negatives++;
 db.used.rays=17;tb.used.rays=19;bb.used.rays=23;assert(row_validate(&a)&&db.used.rays==17&&tb.used.rays==19&&bb.used.rays==23);db.used.rays=tb.used.rays=bb.used.rays=0;
 void*save=a.pixels;a.pixels=(void*)&tx;assert(!row_validate(&a));a.pixels=save;negatives++;
 save=a.verification;a.verification=(void*)&bw;assert(!row_validate(&a));a.verification=save;negatives++;
 hv.used=0;assert(row_verify_sources(&a)&&hv.used==425);
 storage[10]^=1;hv.used=0;assert(!row_verify_sources(&a)&&hv.used==425);storage[10]^=1;negatives++;
 identity_bytes[3]^=1;hv.used=0;assert(!row_verify_sources(&a)&&hv.used==425);identity_bytes[3]^=1;negatives++;
 tx.expected.material++;hv.used=0;assert(!row_verify_sources(&a)&&hv.used==425);tx.expected.material--;negatives++;
 hv.used=73728;assert(!row_verify_sources(&a)&&hv.used==73728);negatives++;

 /* Completed scratch is not published by verification. Force each finish
  * failure before the deliberately dummy background context is consulted. */
 RowRenderBands bands={.tx=&tx,.snapshot=&snap,.pixels=pixels,.workspace=w,.identity=&id,.limits=&l,.composition=&bg,.composition_limits=&sl,.composition_report=&sr,.hdr_report=&hr,.background_work=&bw,.verification=&hv};
 for(unsigned j=0;j<5;j++){bands.depth.band[j]=depth+j*32*240;bands.depth.bytes[j]=(j<4?32:7)*240*sizeof(float);}
 hr.complete=true;sr.complete=true;
 hv.used=0;assert(row_bands_verify_sources(&bands)&&hv.used==425);
 storage[10]^=1;hv.used=0;assert(!row_bands_finish(&bands)&&hv.used==425);storage[10]^=1;negatives++;
 identity_bytes[3]^=1;hv.used=0;assert(!row_bands_finish(&bands)&&hv.used==425);identity_bytes[3]^=1;negatives++;
 hv.used=73728;assert(!row_bands_finish(&bands)&&hv.used==73728);negatives++;

 /* New descriptor and cache are independent caller allocations. */
 agx_block_cache *cache=row_profile_cache_create(malloc,free);assert(cache);
 RowCachedRenderBands ca={.tx=&tx,.snapshot=&snap,.pixels=pixels,.depth=bands.depth,.workspace=w,.identity=&id,.limits=&l,.composition=&bg,.composition_limits=&sl,.composition_report=&sr,.hdr_report=&hr,.background_work=&bw,.verification=&hv,.cache=cache};
 hv.used=0;assert(row_cached_validate_depth(&ca,&ca.depth));
 const void*cache_aliases[]={&ca,&tx,&db,&tb,&pb,&fw,&snap,storage,pixels,depth,w,&id,identity_bytes,&l,&bg,&sl,&sr,&hr,context,descriptor,&bb,&bw,&hv,lut,vs,bs};
 for(unsigned i=0;i<sizeof cache_aliases/sizeof*cache_aliases;i++){ca.cache=(void*)cache_aliases[i];assert(!row_cached_validate_depth(&ca,&ca.depth));negatives++;}ca.cache=cache;
 tx.floor_world_work=&ww;assert(row_cached_validate_depth(&ca,&ca.depth));ca.cache=(void*)&ww;assert(!row_cached_validate_depth(&ca,&ca.depth));ca.cache=cache;tx.floor_world_work=NULL;
 agx_cache_clear(cache);assert(!row_cached_validate_depth(&ca,&ca.depth));assert(agx_cache_bind_profile(cache));
 cache->length--;assert(!row_cached_validate_depth(&ca,&ca.depth));assert(agx_cache_bind_profile(cache));
 const float in[3]={.1f,.2f,.3f};float out[3];assert(agx_cache_profile_eval(cache,in,out)==0);assert(cache->hits+cache->misses==4);
 assert(agx_cache_bind_profile(cache)&&!cache->hits&&!cache->misses&&!cache->invalidations);
 agx_cache_clear(cache);hr.complete=true;assert(!row_cached_finish(&ca));assert(agx_cache_bind_profile(cache));
 assert(!row_profile_cache_create(fail_allocate,free));assert(!row_profile_cache_create(NULL,free));assert(!row_profile_cache_create(malloc,NULL));
 row_profile_cache_release(&cache,free);assert(!cache);row_profile_cache_release(&cache,free);
 assert(!memcmp(old,pixels,64800)&&!memcmp(olddepth,depth,129600));assert(!db.used.rays&&!tb.used.rays);free(pixels);free(old);free(depth);free(olddepth);free(w);bounce_binding_clear(&tx.binding);bounce_scene_release(bs);fox_pixel_unbind(&pb);vis_scene_release(vs);
 printf("{\"status\":\"PASS\",\"negativeCases\":%u,\"physicalShaderCalls\":0,\"actualFrames\":0,\"priorPixelsDepthUnchanged\":true}\n",negatives);
}
