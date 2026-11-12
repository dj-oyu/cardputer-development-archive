#include "pixel_transport.h"
#include <string.h>
#include <stdint.h>
static bool overlap(const void *a,size_t an,const void *b,size_t bn){uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;return an&&bn&&(x>UINTPTR_MAX-an||y>UINTPTR_MAX-bn||(x<y+bn&&y<x+an));}
static bool shade(void *opaque,const FoxDiskScene *lights,const double p[3],const double n[3],const double rho[3],double rgb[3]){
 fox_transport_context *c=opaque;if(!bounce_scene_matches_lights(c->binding.scene,lights)||!bounce_scene_matches_ground(c->binding.scene,&c->ground))return false;bounce_result r;
 if(bounce_eval(&c->binding,c->expected,p,n,rho,c->mode,c->outer,c->inner,c->direct_budget,c->transport_budget,&r)!=BOUNCE_OK)return false;
 bounce_counters sum=c->counters;
#define ADD(field) if(sum.field>UINT64_MAX-r.counters.field)return false;sum.field+=r.counters.field;
 ADD(primary_ground_hits) ADD(primary_ground_emission_hits) ADD(secondary_ground_hits)
 ADD(primary_rays) ADD(primary_hits) ADD(primary_misses) ADD(secondary_world_rays) ADD(primary_direct_queries) ADD(secondary_direct_queries) ADD(zero_reflection_ns_v) ADD(back_single_discard) ADD(grazing_ng_v)
#undef ADD
 c->counters=sum;memcpy(rgb,r.combined,3*sizeof(double));return true;
}
bool fox_transport_render(fox_transport_context *c,const ksn_mesh_pixel_snapshot *s,uint16_t *pixels,unsigned y,unsigned height,float *scratch,unsigned rows,ksn_mesh_pixel_stats *stats){
 if(!c||!s||!pixels||!scratch||!stats||height>135||rows>8||!c->direct_budget||!c->transport_budget||!c->binding.scene||!fox_pixel_binding_matches(c->snapshot_binding,c->expected.visibility,s))return false;
 const void *ptrs[]={c,c->direct_budget,c->transport_budget,c->snapshot_binding,s,s->storage,pixels,scratch,stats};
 const size_t sizes[]={sizeof *c,sizeof *c->direct_budget,sizeof *c->transport_budget,sizeof *c->snapshot_binding,sizeof *s,s->capacity,(size_t)height*240*2,(size_t)rows*240*4,sizeof *stats};
 for(unsigned i=0;i<9;i++){if(bounce_scene_overlaps(c->binding.scene,ptrs[i],sizes[i]))return false;for(unsigned j=i+1;j<9;j++)if(overlap(ptrs[i],sizes[i],ptrs[j],sizes[j]))return false;}
 return ksn_mesh_pixel_render_shaded(s,pixels,y,height,scratch,rows,stats,shade,c);
}

/* Narrow opt-in wrapper. Reuses the existing exact shade callback above. */
bool fox_transport_render_boundary_experimental(fox_transport_context *c,const ksn_mesh_pixel_snapshot *s,uint16_t *pixels,float *depth,ksn_aa_workspace *w,const ksn_aa_identity *identity,const ksn_aa_ledger *limits,KsnAASampleObserver observer,void *observer_context){
 if(!c||!s||!pixels||!depth||!w||!identity||!limits||!c->direct_budget||!c->transport_budget||!c->binding.scene||!c->snapshot_binding)return false;
 const fox_pixel_binding *b=c->snapshot_binding;vis_generation g=c->expected.visibility;
 if(!b->scene.scene||b->snapshot_bytes!=416+s->mesh.packets.size||g.geometry!=b->scene.generation.geometry||g.pose!=b->scene.generation.pose||g.light!=b->scene.generation.light)return false;
 const vis_counters dl={1000000,100000000,50000000},tl={20000000,800000000,300000000};
 const vis_budget *budgets[2]={c->direct_budget,c->transport_budget};const vis_counters caps[2]={dl,tl};
 for(unsigned i=0;i<2;i++)if(budgets[i]->limit.rays>caps[i].rays||budgets[i]->limit.node_visits>caps[i].node_visits||budgets[i]->limit.triangle_tests>caps[i].triangle_tests||budgets[i]->used.rays>budgets[i]->limit.rays||budgets[i]->used.node_visits>budgets[i]->limit.node_visits||budgets[i]->used.triangle_tests>budgets[i]->limit.triangle_tests)return false;
 const void *ptrs[]={c,c->direct_budget,c->transport_budget,c->snapshot_binding,s,s->storage,pixels,depth,w,identity,identity->bytes,limits};
 const size_t sizes[]={sizeof*c,sizeof*c->direct_budget,sizeof*c->transport_budget,sizeof*c->snapshot_binding,sizeof*s,s->capacity,KSN_AA_PIXELS*2,KSN_AA_PIXELS*4,sizeof*w,sizeof*identity,identity->size,sizeof*limits};
 for(unsigned i=0;i<12;i++){if(bounce_scene_overlaps(c->binding.scene,ptrs[i],sizes[i]))return false;for(unsigned j=i+1;j<12;j++)if(overlap(ptrs[i],sizes[i],ptrs[j],sizes[j]))return false;}
 ksn_aa_identity bound=*identity;bound.snapshot_fingerprint=b->snapshot_hash;
 return ksn_mesh_pixel_render_boundary_experimental(s,pixels,depth,w,&bound,limits,shade,c,observer,observer_context);
}
