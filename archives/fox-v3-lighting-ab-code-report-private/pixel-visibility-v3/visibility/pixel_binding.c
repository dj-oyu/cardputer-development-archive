#include "pixel_binding.h"
#include <math.h>
#include <string.h>
#include <stdint.h>
static uint64_t fingerprint(const ksn_mesh_pixel_snapshot *s){
 uint64_t h=UINT64_C(14695981039346656037);size_t n=416+s->mesh.packets.size;
 for(size_t i=0;i<n;i++){h^=s->storage[i];h*=UINT64_C(1099511628211);}return h;
}
static bool valid(const ksn_mesh_pixel_snapshot *s){return s&&s->storage&&s->capacity>=416&&s->capacity<=65536&&s->mesh.packets.data==s->storage+416&&s->mesh.packets.size<=s->capacity-416;}
static bool overlap(const void *a,size_t an,const void *b,size_t bn){uintptr_t x=(uintptr_t)a,y=(uintptr_t)b;return an&&bn&&(x>UINTPTR_MAX-an||y>UINTPTR_MAX-bn||(x<y+bn&&y<x+an));}
vis_status fox_pixel_bind(fox_pixel_binding *out,vis_scene *scene,vis_generation gen,const ksn_mesh_pixel_snapshot *s){
 if(!out||!valid(s)||vis_scene_overlaps(scene,out,sizeof *out)||overlap(out,sizeof *out,s,sizeof *s)||overlap(out,sizeof *out,s->storage,s->capacity))return VIS_INVALID;
 if(out->scene.scene&&vis_scene_overlaps(out->scene.scene,out,sizeof *out))return VIS_INVALID;
 uint64_t h=fingerprint(s);vis_status status=vis_binding_set(&out->scene,scene,gen);if(status!=VIS_OK)return status;
 out->snapshot_hash=h;out->snapshot_bytes=416+s->mesh.packets.size;return VIS_OK;
}
void fox_pixel_unbind(fox_pixel_binding *b){if(b){if(b->scene.scene&&vis_scene_overlaps(b->scene.scene,b,sizeof *b))return;vis_binding_clear(&b->scene);b->snapshot_hash=0;b->snapshot_bytes=0;}}
typedef struct {const fox_pixel_binding *binding;vis_generation generation;vis_budget *budget;} query;
static bool visible(void *opaque,const double p[3],const double n[3],const double target[3],bool *out){
 query *q=opaque;(void)n; /* Segment kernel excludes epsilon along ray once, not along shading normal. */
 int blocked;vis_status s=vis_segment_occluded(&q->binding->scene,q->generation,p,target,q->budget,&blocked);if(s!=VIS_OK)return false;*out=!blocked;return true;
}
bool fox_pixel_render_bound(const fox_pixel_binding *binding,vis_generation generation,const ksn_mesh_pixel_snapshot *s,uint16_t *pixels,unsigned y,unsigned height,float *scratch,unsigned rows,ksn_mesh_pixel_stats *stats,vis_budget *budget){
 if(!binding||!budget||!valid(s)||height>135||rows>8||binding->snapshot_bytes!=416+s->mesh.packets.size||binding->snapshot_hash!=fingerprint(s))return false;
 if(!binding->scene.scene||generation.geometry!=binding->scene.generation.geometry||generation.pose!=binding->scene.generation.pose||generation.light!=binding->scene.generation.light)return false;
 const void *p[6]={binding,budget,s,s->storage,pixels,scratch};size_t n[6]={sizeof *binding,sizeof *budget,sizeof *s,s->capacity,(size_t)height*240*2,(size_t)rows*240*4};
 for(unsigned i=0;i<6;i++)for(unsigned j=i+1;j<6;j++)if(overlap(p[i],n[i],p[j],n[j]))return false;
 for(unsigned i=0;i<6;i++)if(overlap(stats,sizeof *stats,p[i],n[i]))return false;
 for(unsigned i=0;i<6;i++)if(vis_scene_overlaps(binding->scene.scene,p[i],n[i]))return false;
 if(vis_scene_overlaps(binding->scene.scene,stats,sizeof *stats))return false;
 query q={binding,generation,budget};return ksn_mesh_pixel_render_visible(s,pixels,y,height,scratch,rows,stats,visible,&q);
}
