#define main previous_pixel_tests
#include "test_pixel_renderer.c"
#undef main
#include "pixel_binding.h"
int main(void){
 uint8_t data[65536];ksn_mesh_pixel_snapshot px;FoxDiskScene lights=scene(1);ksn_proc_gouraud_patch patch;co_pixel_vertex v[3];uint8_t bits[8]={0};setup(&patch,v);
 assert(ksn_mesh_pixel_begin(&px,data,sizeof data,&lights,8000000));assert(ksn_mesh_pixel_append(&px,&patch,v,bits,1));
 double xyz[]={-10,-10,2,10,-10,2,0,10,2};uint32_t tri[]={0,1,2};vis_scene *s=NULL;vis_generation g={1,1,1},g2={1,2,1};vis_limits lim={2048,4095,524288};assert(vis_scene_build(&s,xyz,3,tri,1,g,lim)==VIS_OK);
 fox_pixel_binding b={0};assert(fox_pixel_bind(&b,s,g,&px)==VIS_OK);uint16_t pix[240*16]={0};float z[240*8];ksn_mesh_pixel_stats stats={0};vis_budget budget={{1000000,100000000,50000000},{0}};
 assert(fox_pixel_render_bound(&b,g,&px,pix,0,16,z,8,&stats,&budget));assert(stats.shade_updates&&budget.used.rays);for(unsigned i=0;i<240*16;i++)assert(pix[i]==0);
 ksn_mesh_pixel_stats saved=stats;vis_counters consumed=budget.used;
 assert(!fox_pixel_render_bound(&b,g2,&px,pix,0,16,z,8,&stats,&budget)&&!memcmp(&stats,&saved,sizeof saved)&&!memcmp(&budget.used,&consumed,sizeof consumed));
 data[8]^=1;assert(!fox_pixel_render_bound(&b,g,&px,pix,0,16,z,8,&stats,&budget));data[8]^=1;
 for(unsigned i=0;i<3;i++){vis_budget shortb={{1000000,100000000,50000000},{0}};if(i==0)shortb.limit.rays=0;if(i==1)shortb.limit.node_visits=0;if(i==2)shortb.limit.triangle_tests=0;stats=(ksn_mesh_pixel_stats){0};assert(!fox_pixel_render_bound(&b,g,&px,pix,0,16,z,8,&stats,&shortb));assert(!stats.shade_updates&&!stats.disk_samples);}
 budget.limit=budget.used;stats=(ksn_mesh_pixel_stats){0};assert(!fox_pixel_render_bound(&b,g,&px,pix,0,16,z,8,&stats,&budget));assert(!stats.shade_updates); /* cumulative across calls */
 for(unsigned j=0;j<3;j++)xyz[3*j]+=100;assert(vis_scene_build(&s,xyz,3,tri,1,g2,lim)==VIS_OK);fox_pixel_binding newer={0};assert(fox_pixel_bind(&newer,s,g2,&px)==VIS_OK);vis_scene_release(s);s=NULL;
 budget=(vis_budget){{1000000,100000000,50000000},{0}};stats=(ksn_mesh_pixel_stats){0};memset(pix,0,sizeof pix);assert(fox_pixel_render_bound(&b,g,&px,pix,0,16,z,8,&stats,&budget));for(unsigned i=0;i<240*16;i++)assert(!pix[i]);
 budget=(vis_budget){{1000000,100000000,50000000},{0}};stats=(ksn_mesh_pixel_stats){0};assert(fox_pixel_render_bound(&newer,g2,&px,pix,0,16,z,8,&stats,&budget));assert(pix[11*240+11]);
 assert(!fox_pixel_render_bound(&newer,g2,&px,(uint16_t*)&newer,0,1,z,8,&stats,&budget));assert(!fox_pixel_render_bound(&newer,g2,&px,pix,0,1,z,8,(ksn_mesh_pixel_stats*)&budget,&budget));
 fox_pixel_binding prior=newer;assert(fox_pixel_bind(&newer,b.scene.scene,g2,&px)==VIS_GENERATION);assert(!memcmp(&prior,&newer,sizeof prior));
 fox_pixel_unbind(&b);fox_pixel_unbind(&b);fox_pixel_unbind(&newer);puts("BINDING_PASS immutable snapshot/generation rejection, old retained scene, cumulative budgets, no partial success, alias and atomic bind");return 0;
}
