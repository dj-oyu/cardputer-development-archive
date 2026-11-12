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
