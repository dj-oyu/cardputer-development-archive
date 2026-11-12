/* Reuse the v37 shader verbatim; do not separately link pixel_transport.c. */
#include "../private-build/transport/pixel_transport.c"
#include "row_transport_bridge.h"
#include "agx_profile.h"
extern const void *row_profile_storage(size_t *);
static __attribute__((noinline)) bool row_validate(const RowRender *a){
 if(!a||!a->tx||!a->snapshot||!a->identity||!a->composition||!a->composition->overlaps||!a->composition->context||!a->background_work||!a->verification)return false;
 fox_transport_context*c=a->tx;const ksn_mesh_pixel_snapshot*s=a->snapshot;
 if(!c->direct_budget||!c->transport_budget||!c->floor_work||!c->binding.scene||!c->snapshot_binding||!c->snapshot_binding->scene.scene||!a->identity->bytes)return false;
 /* aa_bind performs both byte hashes before first shade; retain cheap metadata gates here. */
 const fox_pixel_binding*pb=c->snapshot_binding;vis_generation g=c->expected.visibility;
 if(pb->snapshot_bytes!=416+s->mesh.packets.size||a->identity->snapshot_fingerprint!=pb->snapshot_hash||g.geometry!=pb->scene.generation.geometry||g.pose!=pb->scene.generation.pose||g.light!=pb->scene.generation.light)return false;
 const vis_counters caps[2]={{1000000,100000000,50000000},{20000000,800000000,300000000}};
 const vis_budget*budgets[2]={c->direct_budget,c->transport_budget};
 for(unsigned i=0;i<2;i++)if(budgets[i]->limit.rays>caps[i].rays||budgets[i]->limit.node_visits>caps[i].node_visits||budgets[i]->limit.triangle_tests>caps[i].triangle_tests||budgets[i]->used.rays>budgets[i]->limit.rays||budgets[i]->used.node_visits>budgets[i]->limit.node_visits||budgets[i]->used.triangle_tests>budgets[i]->limit.triangle_tests)return false;
 const KsnSceneBinding*b=a->composition;
 const vis_budget*bb=b->shadow_budget;
 if(!bb||b->shadow_budget_bytes!=sizeof*bb||bb->limit.rays>FOX_BG_SHADOW_RAYS||bb->limit.node_visits>FOX_BG_SHADOW_NODES||bb->limit.triangle_tests>FOX_BG_SHADOW_TRIANGLES||bb->used.rays>bb->limit.rays||bb->used.node_visits>bb->limit.node_visits||bb->used.triangle_tests>bb->limit.triangle_tests||a->background_work->used_total>a->background_work->limit_total)return false;
 size_t lut_bytes=0;const void*lut=row_profile_storage(&lut_bytes);
 const void*p[]={a,c,c->direct_budget,c->transport_budget,c->snapshot_binding,c->floor_work,s,s->storage,a->pixels,a->depth,a->workspace,a->identity,a->identity->bytes,a->limits,b,a->composition_limits,a->composition_report,a->hdr_report,b->context,b->descriptor,b->shadow_budget,a->background_work,lut,a->verification};
 const size_t n[]={sizeof*a,sizeof*c,sizeof*c->direct_budget,sizeof*c->transport_budget,sizeof*c->snapshot_binding,sizeof*c->floor_work,sizeof*s,s->capacity,64800,129600,sizeof*a->workspace,sizeof*a->identity,a->identity->size,sizeof*a->limits,sizeof*b,sizeof*a->composition_limits,sizeof*a->composition_report,sizeof*a->hdr_report,b->context_bytes,b->descriptor_bytes,b->shadow_budget_bytes,sizeof*a->background_work,lut_bytes,sizeof*a->verification};
 /* World work is external mutable state and must not alias any live span. */
 if(c->floor_world_work){
  const void *q=c->floor_world_work;size_t qn=sizeof*c->floor_world_work;
  if((uintptr_t)q>UINTPTR_MAX-qn||bounce_scene_overlaps(c->binding.scene,q,qn)||vis_scene_overlaps(c->snapshot_binding->scene.scene,q,qn)||b->overlaps(b->context,q,qn))return false;
  for(unsigned i=0;i<24;i++)if(overlap(q,qn,p[i],n[i]))return false;
 }
 for(unsigned i=0;i<24;i++){
  if(!p[i]||!n[i]||(uintptr_t)p[i]>UINTPTR_MAX-n[i]||bounce_scene_overlaps(c->binding.scene,p[i],n[i])||vis_scene_overlaps(c->snapshot_binding->scene.scene,p[i],n[i]))return false;
  for(unsigned j=0;j<i;j++)if(overlap(p[i],n[i],p[j],n[j]))return false;
  if((i<18||i>=22)&&b->overlaps(b->context,p[i],n[i]))return false;
 }
 return true;
}
static bool row_hash_prepay(RowHostVerification*v,size_t snapshot,size_t identity){
 if(!v||!v->limit||v->limit>73728||v->used>v->limit||snapshot>v->limit-v->used||identity>v->limit-v->used-snapshot)return false;
 v->used+=snapshot+identity;return true;
}
static bool row_verify_sources(const RowRender*a){
 fox_transport_context*c=a->tx;bounce_binding verified={0};
 if(!row_hash_prepay(a->verification,416+a->snapshot->mesh.packets.size,a->identity->size))return false;
 if(!fox_pixel_binding_matches(c->snapshot_binding,c->expected.visibility,a->snapshot)||!bounce_scene_matches_ground(c->binding.scene,&c->ground)||bounce_binding_set(&verified,c->binding.scene,c->expected)!=BOUNCE_OK)return false;
 bounce_binding_clear(&verified);
 if(fox_bg_fingerprint(a->identity->bytes,a->identity->size)!=a->identity->fingerprint)return false;
 return true;
}
static __attribute__((noinline)) bool row_finish(const RowRender*a){
 return row_verify_sources(a)&&fox_bg_context_finish(a->composition->context)==FOX_BG_OK&&a->hdr_report->complete&&a->composition_report->complete;
}
bool row_transport_render(const RowRender*a){
 if(!row_validate(a))return false;
 if(!ksn_mesh_pixel_render_bounded_ring_experimental(a->snapshot,a->pixels,64800,a->depth,129600,a->workspace,sizeof*a->workspace,a->identity,a->limits,shade,a->tx,sizeof*a->tx,a->composition,a->composition_limits,a->composition_report,agx_profile_eval,a->hdr_report))return false;
 /* Adapter successful-path upper bounds:276 original pairs, +24 when world ON,1024 guards.
  * Sum with core usage under unchanged frozen producer categories/cap. */
 unsigned pairs=a->tx->floor_world_work?300u:276u;
 if(a->hdr_report->used[RH_ADMISSION]>1024-pairs||a->hdr_report->used[RH_GUARDS]>100000-1024){a->hdr_report->complete=false;return false;}
 a->hdr_report->used[RH_ADMISSION]+=pairs;a->hdr_report->used[RH_GUARDS]+=1024;
 uint64_t total=0;for(unsigned i=0;i<RH_COUNT;i++)total+=a->hdr_report->used[i];if(total>637599){a->hdr_report->complete=false;return false;}
 if(!row_finish(a)){a->hdr_report->complete=false;return false;}return true;
}

/* Opt-in segmented depth adapter. */
static __attribute__((noinline)) bool row_bands_validate_depth(const RowRenderBands *a,const KsnDepthBands *depth){
 if(!a||(uintptr_t)a%_Alignof(RowRenderBands)||(uintptr_t)a>UINTPTR_MAX-sizeof*a||!a->tx||!a->snapshot||!a->identity||!a->composition||!a->composition->overlaps||!a->composition->context||!a->background_work||!a->verification)return false;
 for(unsigned i=0;i<5;i++)if(!depth->band[i]||(uintptr_t)depth->band[i]%_Alignof(float)||depth->bytes[i]!=(i<4?30720u:6720u))return false;
 fox_transport_context*c=a->tx;const ksn_mesh_pixel_snapshot*s=a->snapshot;
 if(!c->direct_budget||!c->transport_budget||!c->floor_work||!c->binding.scene||!c->snapshot_binding||!c->snapshot_binding->scene.scene||!a->identity->bytes)return false;
 /* aa_bind performs both byte hashes before first shade; retain cheap metadata gates here. */
 const fox_pixel_binding*pb=c->snapshot_binding;vis_generation g=c->expected.visibility;
 if(pb->snapshot_bytes!=416+s->mesh.packets.size||a->identity->snapshot_fingerprint!=pb->snapshot_hash||g.geometry!=pb->scene.generation.geometry||g.pose!=pb->scene.generation.pose||g.light!=pb->scene.generation.light)return false;
 const vis_counters caps[2]={{1000000,100000000,50000000},{20000000,800000000,300000000}};
 const vis_budget*budgets[2]={c->direct_budget,c->transport_budget};
 for(unsigned i=0;i<2;i++)if(budgets[i]->limit.rays>caps[i].rays||budgets[i]->limit.node_visits>caps[i].node_visits||budgets[i]->limit.triangle_tests>caps[i].triangle_tests||budgets[i]->used.rays>budgets[i]->limit.rays||budgets[i]->used.node_visits>budgets[i]->limit.node_visits||budgets[i]->used.triangle_tests>budgets[i]->limit.triangle_tests)return false;
 const KsnSceneBinding*b=a->composition;
 const vis_budget*bb=b->shadow_budget;
 if(!bb||b->shadow_budget_bytes!=sizeof*bb||bb->limit.rays>FOX_BG_SHADOW_RAYS||bb->limit.node_visits>FOX_BG_SHADOW_NODES||bb->limit.triangle_tests>FOX_BG_SHADOW_TRIANGLES||bb->used.rays>bb->limit.rays||bb->used.node_visits>bb->limit.node_visits||bb->used.triangle_tests>bb->limit.triangle_tests||a->background_work->used_total>a->background_work->limit_total)return false;
 size_t lut_bytes=0;const void*lut=row_profile_storage(&lut_bytes);
 const void*p[]={a,c,c->direct_budget,c->transport_budget,c->snapshot_binding,c->floor_work,s,s->storage,a->pixels,depth->band[0],a->workspace,a->identity,a->identity->bytes,a->limits,b,a->composition_limits,a->composition_report,a->hdr_report,b->context,b->descriptor,b->shadow_budget,a->background_work,lut,a->verification,depth->band[1],depth->band[2],depth->band[3],depth->band[4]};
 const size_t n[]={sizeof*a,sizeof*c,sizeof*c->direct_budget,sizeof*c->transport_budget,sizeof*c->snapshot_binding,sizeof*c->floor_work,sizeof*s,s->capacity,64800,30720,sizeof*a->workspace,sizeof*a->identity,a->identity->size,sizeof*a->limits,sizeof*b,sizeof*a->composition_limits,sizeof*a->composition_report,sizeof*a->hdr_report,b->context_bytes,b->descriptor_bytes,b->shadow_budget_bytes,sizeof*a->background_work,lut_bytes,sizeof*a->verification,30720,30720,30720,6720};
 /* World work is external mutable state and must not alias any live span. */
 if(c->floor_world_work){
  const void *q=c->floor_world_work;size_t qn=sizeof*c->floor_world_work;
  if((uintptr_t)q>UINTPTR_MAX-qn||bounce_scene_overlaps(c->binding.scene,q,qn)||vis_scene_overlaps(c->snapshot_binding->scene.scene,q,qn)||b->overlaps(b->context,q,qn))return false;
  for(unsigned i=0;i<28;i++)if(overlap(q,qn,p[i],n[i]))return false;
 }
 for(unsigned i=0;i<28;i++){
  if(!p[i]||!n[i]||(uintptr_t)p[i]>UINTPTR_MAX-n[i]||bounce_scene_overlaps(c->binding.scene,p[i],n[i])||vis_scene_overlaps(c->snapshot_binding->scene.scene,p[i],n[i]))return false;
  for(unsigned j=0;j<i;j++)if(overlap(p[i],n[i],p[j],n[j]))return false;
  if((i<18||i>=22)&&b->overlaps(b->context,p[i],n[i]))return false;
 }
 return true;
}
/* Test-compatible direct admission entry; real render captures once below. */
static bool row_bands_validate(const RowRenderBands*a){
 if(!a||(uintptr_t)a%_Alignof(RowRenderBands)||(uintptr_t)a>UINTPTR_MAX-sizeof*a)return false;
 const KsnDepthBands depth=a->depth;return row_bands_validate_depth(a,&depth);
}
static bool row_bands_hash_prepay(RowHostVerification*v,size_t snapshot,size_t identity){
 if(!v||!v->limit||v->limit>73728||v->used>v->limit||snapshot>v->limit-v->used||identity>v->limit-v->used-snapshot)return false;
 v->used+=snapshot+identity;return true;
}
static bool row_bands_verify_sources(const RowRenderBands*a){
 fox_transport_context*c=a->tx;bounce_binding verified={0};
 if(!row_bands_hash_prepay(a->verification,416+a->snapshot->mesh.packets.size,a->identity->size))return false;
 if(!fox_pixel_binding_matches(c->snapshot_binding,c->expected.visibility,a->snapshot)||!bounce_scene_matches_ground(c->binding.scene,&c->ground)||bounce_binding_set(&verified,c->binding.scene,c->expected)!=BOUNCE_OK)return false;
 bounce_binding_clear(&verified);
 if(fox_bg_fingerprint(a->identity->bytes,a->identity->size)!=a->identity->fingerprint)return false;
 return true;
}
static __attribute__((noinline)) bool row_bands_finish(const RowRenderBands*a){
 return row_bands_verify_sources(a)&&fox_bg_context_finish(a->composition->context)==FOX_BG_OK&&a->hdr_report->complete&&a->composition_report->complete;
}
bool row_transport_render_bands(const RowRenderBands*a){
 if(!a||(uintptr_t)a%_Alignof(RowRenderBands)||(uintptr_t)a>UINTPTR_MAX-sizeof*a)return false;
 const KsnDepthBands depth=a->depth;
 if(!row_bands_validate_depth(a,&depth))return false;
 if(!ksn_mesh_pixel_render_depth_bands_experimental(a->snapshot,a->pixels,64800,&depth,a->workspace,sizeof*a->workspace,a->identity,a->limits,shade,a->tx,sizeof*a->tx,a->composition,a->composition_limits,a->composition_report,agx_profile_eval,a->hdr_report))return false;
 /* Adapter successful-path upper bounds:378 original pairs, +28 when world ON,1024 guards.
  * Sum with core usage under unchanged frozen producer categories/cap. */
 unsigned pairs=a->tx->floor_world_work?406u:378u;
 if(a->hdr_report->used[RH_ADMISSION]>1024-pairs||a->hdr_report->used[RH_GUARDS]>100000-1024){a->hdr_report->complete=false;return false;}
 a->hdr_report->used[RH_ADMISSION]+=pairs;a->hdr_report->used[RH_GUARDS]+=1024;
 uint64_t total=0;for(unsigned i=0;i<RH_COUNT;i++)total+=a->hdr_report->used[i];if(total>637599){a->hdr_report->complete=false;return false;}
 if(!row_bands_finish(a)){a->hdr_report->complete=false;return false;}return true;
}

/* Explicit cache lifetime, caller-owned synchronous private adapter. */
extern int row_profile_is_bound(const agx_block_cache *);
#include "ksn_cached_profile.h"
static __attribute__((noinline)) bool row_cached_validate_depth(const RowCachedRenderBands *a,const KsnDepthBands *depth){
 if(!a||(uintptr_t)a%_Alignof(RowCachedRenderBands)||(uintptr_t)a>UINTPTR_MAX-sizeof*a||!a->tx||!a->snapshot||!a->identity||!a->composition||!a->composition->overlaps||!a->composition->context||!a->background_work||!a->verification)return false;
 for(unsigned i=0;i<5;i++)if(!depth->band[i]||(uintptr_t)depth->band[i]%_Alignof(float)||depth->bytes[i]!=(i<4?30720u:6720u))return false;
 fox_transport_context*c=a->tx;const ksn_mesh_pixel_snapshot*s=a->snapshot;
 if(!c->direct_budget||!c->transport_budget||!c->floor_work||!c->binding.scene||!c->snapshot_binding||!c->snapshot_binding->scene.scene||!a->identity->bytes)return false;
 /* aa_bind performs both byte hashes before first shade; retain cheap metadata gates here. */
 const fox_pixel_binding*pb=c->snapshot_binding;vis_generation g=c->expected.visibility;
 if(pb->snapshot_bytes!=416+s->mesh.packets.size||a->identity->snapshot_fingerprint!=pb->snapshot_hash||g.geometry!=pb->scene.generation.geometry||g.pose!=pb->scene.generation.pose||g.light!=pb->scene.generation.light)return false;
 const vis_counters caps[2]={{1000000,100000000,50000000},{20000000,800000000,300000000}};
 const vis_budget*budgets[2]={c->direct_budget,c->transport_budget};
 for(unsigned i=0;i<2;i++)if(budgets[i]->limit.rays>caps[i].rays||budgets[i]->limit.node_visits>caps[i].node_visits||budgets[i]->limit.triangle_tests>caps[i].triangle_tests||budgets[i]->used.rays>budgets[i]->limit.rays||budgets[i]->used.node_visits>budgets[i]->limit.node_visits||budgets[i]->used.triangle_tests>budgets[i]->limit.triangle_tests)return false;
 const KsnSceneBinding*b=a->composition;
 const vis_budget*bb=b->shadow_budget;
 if(!bb||b->shadow_budget_bytes!=sizeof*bb||bb->limit.rays>FOX_BG_SHADOW_RAYS||bb->limit.node_visits>FOX_BG_SHADOW_NODES||bb->limit.triangle_tests>FOX_BG_SHADOW_TRIANGLES||bb->used.rays>bb->limit.rays||bb->used.node_visits>bb->limit.node_visits||bb->used.triangle_tests>bb->limit.triangle_tests||a->background_work->used_total>a->background_work->limit_total)return false;
 if(!a->cache||(uintptr_t)a->cache%_Alignof(agx_block_cache))return false;
 size_t lut_bytes=0;const void*lut=row_profile_storage(&lut_bytes);
 const void*p[]={a,c,c->direct_budget,c->transport_budget,c->snapshot_binding,c->floor_work,s,s->storage,a->pixels,depth->band[0],a->workspace,a->identity,a->identity->bytes,a->limits,b,a->composition_limits,a->composition_report,a->hdr_report,b->context,b->descriptor,b->shadow_budget,a->background_work,lut,a->verification,depth->band[1],depth->band[2],depth->band[3],depth->band[4],a->cache};
 const size_t n[]={sizeof*a,sizeof*c,sizeof*c->direct_budget,sizeof*c->transport_budget,sizeof*c->snapshot_binding,sizeof*c->floor_work,sizeof*s,s->capacity,64800,30720,sizeof*a->workspace,sizeof*a->identity,a->identity->size,sizeof*a->limits,sizeof*b,sizeof*a->composition_limits,sizeof*a->composition_report,sizeof*a->hdr_report,b->context_bytes,b->descriptor_bytes,b->shadow_budget_bytes,sizeof*a->background_work,lut_bytes,sizeof*a->verification,30720,30720,30720,6720,sizeof*a->cache};
 /* World work is external mutable state and must not alias any live span. */
 if(c->floor_world_work){
  const void *q=c->floor_world_work;size_t qn=sizeof*c->floor_world_work;
  if((uintptr_t)q>UINTPTR_MAX-qn||bounce_scene_overlaps(c->binding.scene,q,qn)||vis_scene_overlaps(c->snapshot_binding->scene.scene,q,qn)||b->overlaps(b->context,q,qn))return false;
  for(unsigned i=0;i<29;i++)if(overlap(q,qn,p[i],n[i]))return false;
 }
 for(unsigned i=0;i<29;i++){
  if(!p[i]||!n[i]||(uintptr_t)p[i]>UINTPTR_MAX-n[i]||bounce_scene_overlaps(c->binding.scene,p[i],n[i])||vis_scene_overlaps(c->snapshot_binding->scene.scene,p[i],n[i]))return false;
  for(unsigned j=0;j<i;j++)if(overlap(p[i],n[i],p[j],n[j]))return false;
  if((i<18||i>=22)&&b->overlaps(b->context,p[i],n[i]))return false;
 }
 return row_profile_is_bound(a->cache);
}
/* Test-compatible direct admission entry; real render captures once below. */
static bool row_cached_validate(const RowCachedRenderBands*a){
 if(!a||(uintptr_t)a%_Alignof(RowCachedRenderBands)||(uintptr_t)a>UINTPTR_MAX-sizeof*a)return false;
 const KsnDepthBands depth=a->depth;return row_cached_validate_depth(a,&depth);
}
static bool row_cached_hash_prepay(RowHostVerification*v,size_t snapshot,size_t identity){
 if(!v||!v->limit||v->limit>73728||v->used>v->limit||snapshot>v->limit-v->used||identity>v->limit-v->used-snapshot)return false;
 v->used+=snapshot+identity;return true;
}
static bool row_cached_verify_sources(const RowCachedRenderBands*a){
 fox_transport_context*c=a->tx;bounce_binding verified={0};
 if(!row_cached_hash_prepay(a->verification,416+a->snapshot->mesh.packets.size,a->identity->size))return false;
 if(!fox_pixel_binding_matches(c->snapshot_binding,c->expected.visibility,a->snapshot)||!bounce_scene_matches_ground(c->binding.scene,&c->ground)||bounce_binding_set(&verified,c->binding.scene,c->expected)!=BOUNCE_OK)return false;
 bounce_binding_clear(&verified);
 if(fox_bg_fingerprint(a->identity->bytes,a->identity->size)!=a->identity->fingerprint)return false;
 return true;
}
static __attribute__((noinline)) bool row_cached_finish(const RowCachedRenderBands*a){
 return row_profile_is_bound(a->cache)&&row_cached_verify_sources(a)&&fox_bg_context_finish(a->composition->context)==FOX_BG_OK&&a->hdr_report->complete&&a->composition_report->complete;
}
bool row_transport_render_cached_bands(const RowCachedRenderBands*a){
 if(!a||(uintptr_t)a%_Alignof(RowCachedRenderBands)||(uintptr_t)a>UINTPTR_MAX-sizeof*a)return false;
 const KsnDepthBands depth=a->depth;
 if(!row_cached_validate_depth(a,&depth))return false;
 if(!ksn_mesh_pixel_render_cached_depth_bands_private(a->snapshot,a->pixels,64800,&depth,a->workspace,sizeof*a->workspace,a->identity,a->limits,shade,a->tx,sizeof*a->tx,a->composition,a->composition_limits,a->composition_report,a->cache,a->hdr_report))return false;
 /* Adapter successful-path upper bounds:406 original pairs, +29 when world ON,1024 guards.
  * Sum with core usage under unchanged frozen producer categories/cap. */
 unsigned pairs=a->tx->floor_world_work?435u:406u;
 if(a->hdr_report->used[RH_ADMISSION]>1024-pairs||a->hdr_report->used[RH_GUARDS]>100000-1024){a->hdr_report->complete=false;return false;}
 a->hdr_report->used[RH_ADMISSION]+=pairs;a->hdr_report->used[RH_GUARDS]+=1024;
 uint64_t total=0;for(unsigned i=0;i<RH_COUNT;i++)total+=a->hdr_report->used[i];if(total>637599){a->hdr_report->complete=false;return false;}
 if(!row_cached_finish(a)){a->hdr_report->complete=false;return false;}return true;
}
