from pathlib import Path
R=Path(__file__).resolve().parents[1]
s=(R.parent/'fox-v3-aa-phase-overlay/harness/test_adapter.c').read_text().replace('#include "row_transport_bridge.c"','#include "../harness/row_transport_bridge.c"')
pos=' hr.complete=true;sr.complete=true;'
new=r'''
 agx_block_cache *cache=malloc(sizeof *cache);assert(cache);agx_cache_init(cache);assert(agx_cache_bind_profile(cache));
 RowCachedRenderBands ca={.tx=&tx,.snapshot=&snap,.pixels=pixels,.depth=bands.depth,.workspace=w,.identity=&id,.limits=&l,.composition=&bg,.composition_limits=&sl,.composition_report=&sr,.hdr_report=&hr,.background_work=&bw,.verification=&hv,.cache=cache};
 assert(row_cached_validate(&ca));
 agx_block_cache before=*cache;KsnBandHDRReport before_hr=hr;
 const void *aliases[]={&ca,&tx,&db,&tb,&pb,&fw,&snap,storage,pixels,bands.depth.band[0],w,&id,identity_bytes,&l,&bg,&sl,&sr,&hr,context,descriptor,&bb,&bw,&hv,lut,bands.depth.band[1],bands.depth.band[2],bands.depth.band[3],bands.depth.band[4],&ww};
 const size_t sizes[]={sizeof ca,sizeof tx,sizeof db,sizeof tb,sizeof pb,sizeof fw,sizeof snap,sizeof storage,64800,30720,sizeof*w,sizeof id,sizeof identity_bytes,sizeof l,sizeof bg,sizeof sl,sizeof sr,sizeof hr,sizeof context,sizeof descriptor,sizeof bb,sizeof bw,sizeof hv,lutn,30720,30720,30720,6720,sizeof ww};
 unsigned cached_negatives=0;
 tx.floor_world_work=&ww;assert(row_cached_validate(&ca));
 for(unsigned i=0;i<29;i++)for(unsigned side=0;side<3;side++){
  uintptr_t p=(uintptr_t)aliases[i];if(side==1)p+=sizes[i]-1;if(side==2)p-=sizeof *cache-1;
  ca.cache=(agx_block_cache*)p;assert(!row_cached_validate(&ca));assert(!row_transport_render_cached_bands(&ca));cached_negatives++;
  assert(!memcmp(&before,cache,sizeof before)&&!memcmp(&before_hr,&hr,sizeof hr));
 }
 ca.cache=cache;assert(row_cached_validate(&ca));
 ca.cache=NULL;assert(!row_cached_validate(&ca));cached_negatives++;
 ca.cache=(void*)(UINTPTR_MAX-(UINTPTR_MAX%_Alignof(agx_block_cache)));assert(!row_cached_validate(&ca));cached_negatives++;
 ca.cache=cache;agx_cache_clear(cache);assert(!row_cached_validate(&ca));cached_negatives++;
 assert(agx_cache_bind_profile(cache));size_t blobn;const void *blob=row_profile_storage(&blobn);unsigned char *copy=malloc(blobn);assert(copy);memcpy(copy,blob,blobn);assert(agx_cache_bind(cache,copy,blobn));assert(!row_cached_validate(&ca));cached_negatives++;agx_cache_clear(cache);free(copy);
 assert(agx_cache_bind_profile(cache));float input[3]={.1f,.2f,.3f},output[3];assert(agx_cache_profile_eval(cache,input,output)==0);before=*cache;assert(row_cached_validate(&ca)&&!memcmp(&before,cache,sizeof before));
 tx.floor_world_work=NULL;agx_cache_clear(cache);free(cache);
 fprintf(stderr,"independent cached alias/lifetime negatives=%u, physical shader calls=0\n",cached_negatives);
'''
assert s.count(pos)==1
s=s.replace(pos,new+pos)
(R/'review/test_admission.c').write_text(s)
