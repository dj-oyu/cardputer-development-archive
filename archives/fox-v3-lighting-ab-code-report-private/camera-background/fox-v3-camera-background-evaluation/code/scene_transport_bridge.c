/* Old source included unchanged to reuse its private shader; do not also link pixel_transport.c. */
#include "../transport/pixel_transport.c"
#include "scene_transport_bridge.h"
static __attribute__((noinline)) bool scene_validate(fox_transport_context *c,const ksn_mesh_pixel_snapshot *s,uint16_t *pixels,float *depth,ksn_aa_workspace *w,const ksn_aa_identity *identity,const ksn_aa_ledger *limits,KsnAASampleObserver observer,void *observer_context,size_t observer_bytes,const KsnSceneBinding *composition,const KsnSceneLedger *composition_limits,KsnSceneReport *composition_report){
 (void)observer;
 if(!c||!s||!pixels||!depth||!w||!identity||!limits||!c->direct_budget||!c->transport_budget||!c->binding.scene||!c->snapshot_binding)return false;
 const fox_pixel_binding *b=c->snapshot_binding;vis_generation g=c->expected.visibility;
 if(!b->scene.scene||b->snapshot_bytes!=416+s->mesh.packets.size||g.geometry!=b->scene.generation.geometry||g.pose!=b->scene.generation.pose||g.light!=b->scene.generation.light)return false;
 const vis_counters dl={1000000,100000000,50000000},tl={20000000,800000000,300000000};
 const vis_budget *budgets[2]={c->direct_budget,c->transport_budget};const vis_counters caps[2]={dl,tl};
 for(unsigned i=0;i<2;i++)if(budgets[i]->limit.rays>caps[i].rays||budgets[i]->limit.node_visits>caps[i].node_visits||budgets[i]->limit.triangle_tests>caps[i].triangle_tests||budgets[i]->used.rays>budgets[i]->limit.rays||budgets[i]->used.node_visits>budgets[i]->limit.node_visits||budgets[i]->used.triangle_tests>budgets[i]->limit.triangle_tests)return false;
 const void *ptrs[]={c,c->direct_budget,c->transport_budget,c->snapshot_binding,s,s->storage,pixels,depth,w,identity,identity->bytes,limits};
 const size_t sizes[]={sizeof*c,sizeof*c->direct_budget,sizeof*c->transport_budget,sizeof*c->snapshot_binding,sizeof*s,s->capacity,KSN_AA_PIXELS*2,KSN_AA_PIXELS*4,sizeof*w,sizeof*identity,identity->size,sizeof*limits};
 for(unsigned i=0;i<12;i++){if(bounce_scene_overlaps(c->binding.scene,ptrs[i],sizes[i]))return false;for(unsigned j=i+1;j<12;j++)if(overlap(ptrs[i],sizes[i],ptrs[j],sizes[j]))return false;}
 if(composition){
  if(!composition_limits||!composition_report||!composition->overlaps||!composition->context||!composition->context_bytes||!composition->descriptor||!composition->descriptor_bytes||!composition->shadow_budget||!composition->shadow_budget_bytes)return false;
  const void *extra[]={composition,composition_limits,composition_report,composition->context,composition->descriptor,composition->shadow_budget,observer_context};
  const size_t en[]={sizeof *composition,sizeof *composition_limits,sizeof *composition_report,composition->context_bytes,composition->descriptor_bytes,composition->shadow_budget_bytes,observer_bytes};
  for(unsigned i=0;i<7;i++){if(!en[i]){if(extra[i])return false;continue;}if(!extra[i]||bounce_scene_overlaps(c->binding.scene,extra[i],en[i]))return false;for(unsigned j=0;j<12;j++)if(overlap(extra[i],en[i],ptrs[j],sizes[j]))return false;for(unsigned j=0;j<i;j++)if(en[j]&&overlap(extra[i],en[i],extra[j],en[j]))return false;}
  for(unsigned j=0;j<12;j++)if(composition->overlaps(composition->context,ptrs[j],sizes[j]))return false;
 }
 return true;
}
bool fox_transport_render_scene_composition_experimental(fox_transport_context *c,const ksn_mesh_pixel_snapshot *s,uint16_t *pixels,float *depth,ksn_aa_workspace *w,const ksn_aa_identity *identity,const ksn_aa_ledger *limits,KsnAASampleObserver observer,void *observer_context,size_t observer_bytes,const KsnSceneBinding *composition,const KsnSceneLedger *composition_limits,KsnSceneReport *composition_report){
 if(!scene_validate(c,s,pixels,depth,w,identity,limits,observer,observer_context,observer_bytes,composition,composition_limits,composition_report))return false;
 ksn_aa_identity bound=*identity;bound.snapshot_fingerprint=c->snapshot_binding->snapshot_hash;
 return ksn_mesh_pixel_render_scene_composition_experimental(s,pixels,depth,w,&bound,limits,shade,c,sizeof *c,observer,observer_context,observer_bytes,composition,composition_limits,composition_report);
}
