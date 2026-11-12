#define main previous_pixel_tests
#include "test_pixel_renderer.c"
#undef main
#include "../transport/pixel_transport.h"
static vis_budget ample(void){vis_budget b={{20000000,800000000,300000000},{0,0,0}};return b;}
int main(void){
 uint8_t data[65536],saved[65536],other[65536];
 ksn_mesh_pixel_snapshot px,changed;FoxDiskScene lights=scene(1),original;
 for(unsigned j=0;j<3;j++){lights.world_radiance[j]=.1*(j+1);for(unsigned k=0;k<3;k++)lights.lights[j].power_rgb_over_pi_squared[k]=0;}
 original=lights;
 ksn_proc_gouraud_patch patch;co_pixel_vertex v[3];uint8_t bits[8]={0};setup(&patch,v);
 for(unsigned j=0;j<3;j++){v[j].front.color_a=v[j].front.color_b=0xffff;v[j].front.mask=-1;patch.vertices[j].mask=-1;}
 assert(ksn_mesh_pixel_begin(&px,data,sizeof data,&lights,8000000));assert(ksn_mesh_pixel_append(&px,&patch,v,bits,1));
 memcpy(saved,data,sizeof data);ksn_mesh_pixel_snapshot saved_px=px;
 double xyz[]={-100,-100,2,100,-100,2,100,100,2,-100,100,2};uint32_t ix[]={0,1,2,0,2,3};
 vis_generation vg={1,1,1};bounce_generation bg={vg,1};vis_limits lim={2048,4095,524288};vis_scene *geometry=NULL;
 assert(vis_scene_build(&geometry,xyz,4,ix,2,vg,lim)==VIS_OK);
 bounce_triangle attributes[2]={0};for(unsigned t=0;t<2;t++)for(unsigned j=0;j<3;j++){
  attributes[t].v[j].front[2]=-32767;attributes[t].v[j].back[2]=32767;attributes[t].v[j].a565=attributes[t].v[j].b565=0xffff;
 }
 bounce_scene *owned=NULL;assert(bounce_scene_build(&owned,geometry,attributes,2,&lights,-1,bg,262144)==BOUNCE_OK);
 fox_pixel_binding snapshot={0};assert(fox_pixel_bind(&snapshot,geometry,vg,&px)==VIS_OK);
 vis_budget direct=ample(),transport=ample();fox_transport_context context={0};context.snapshot_binding=&snapshot;context.expected=bg;context.mode=BOUNCE_OFF;context.outer=context.inner=16;context.direct_budget=&direct;context.transport_budget=&transport;
 assert(bounce_binding_set(&context.binding,owned,bg)==BOUNCE_OK);
 /* Replace the owned scene, preserving the old binding, then dispose both source owners. */
 bounce_generation next=bg;next.material++;assert(bounce_scene_build(&owned,geometry,attributes,2,&lights,-1,next,262144)==BOUNCE_OK);
 bounce_scene_release(owned);vis_scene_release(geometry);
 memset(xyz,0xa5,sizeof xyz);memset(ix,0xa5,sizeof ix);memset(attributes,0xa5,sizeof attributes);memset(&lights,0xa5,sizeof lights);
 uint16_t control[240*16]={0},pixels[240*16]={0},bands[240*16]={0};float z[240*8];ksn_mesh_pixel_stats stats={0},oldstats={0};
 vis_budget oldbudget=ample();assert(fox_pixel_render_bound(&snapshot,vg,&px,control,0,16,z,8,&oldstats,&oldbudget));
 assert(fox_transport_render(&context,&px,pixels,0,16,z,8,&stats));
 assert(stats.shade_updates>0 && !memcmp(control,pixels,sizeof pixels));
 assert(!memcmp(&stats,&oldstats,sizeof stats));assert(!context.counters.primary_rays && !transport.used.rays);
 for(unsigned i=0;i<240*16;i++)if(control[i])assert(control[i]==expected(&original,v,i%240,i/240));
 direct=ample();transport=ample();context.mode=BOUNCE_WORLD_VISIBLE;context.counters=(bounce_counters){0};stats=(ksn_mesh_pixel_stats){0};memset(pixels,0,sizeof pixels);
 assert(fox_transport_render(&context,&px,pixels,0,16,z,8,&stats));assert(stats.shade_updates>0);
 for(unsigned i=0;i<240*16;i++)assert(pixels[i]==0);
 assert(context.counters.primary_hits==16*stats.shade_updates && !context.counters.primary_misses);
 direct=ample();transport=ample();context.mode=BOUNCE_ONE;context.counters=(bounce_counters){0};stats=(ksn_mesh_pixel_stats){0};
 assert(fox_transport_render(&context,&px,pixels,0,16,z,8,&stats));assert(!memcmp(control,pixels,sizeof pixels));
 assert(context.counters.primary_hits==16*stats.shade_updates && context.counters.secondary_world_rays==256*stats.shade_updates);
 assert(!memcmp(saved,data,sizeof data)&&!memcmp(&saved_px,&px,sizeof px));
 /* Two externally submitted bands share the exact same budgets and counters. */
 uint64_t rays=transport.used.rays,drays=direct.used.rays,hits=context.counters.primary_hits;
 direct=ample();transport=ample();context.counters=(bounce_counters){0};stats=(ksn_mesh_pixel_stats){0};
 assert(fox_transport_render(&context,&px,bands,0,12,z,8,&stats));uint64_t first=transport.used.rays;assert(first>0);
 assert(fox_transport_render(&context,&px,bands+240*12,12,4,z,8,&stats));
 assert(transport.used.rays>first && transport.used.rays==rays && direct.used.rays==drays && context.counters.primary_hits==hits && !memcmp(control,bands,sizeof bands));
 /* Material mismatch rejects without publishing successful stats. */
 context.expected.material++;stats=(ksn_mesh_pixel_stats){0};assert(!fox_transport_render(&context,&px,pixels,0,16,z,8,&stats));assert(!stats.shade_updates&&!stats.disk_samples);context.expected=bg;
 /* Changed snapshot is rejected by original hash; fresh hash still cannot pair mismatched lights. */
 FoxDiskScene altered=original;altered.world_radiance[0]+=.05;
 assert(ksn_mesh_pixel_begin(&changed,other,sizeof other,&altered,8000000));assert(ksn_mesh_pixel_append(&changed,&patch,v,bits,1));
 assert(!fox_transport_render(&context,&changed,pixels,0,16,z,8,&stats));
 fox_pixel_binding changed_binding={0};assert(fox_pixel_bind(&changed_binding,snapshot.scene.scene,vg,&changed)==VIS_OK);
 assert(!bounce_scene_matches_lights(context.binding.scene,&altered));context.snapshot_binding=&changed_binding;
 assert(!fox_transport_render(&context,&changed,pixels,0,16,z,8,&stats));context.snapshot_binding=&snapshot;fox_pixel_unbind(&changed_binding);
 /* A failed band may have scratch output, but stats and snapshot stay unpublished/unchanged. */
 direct=ample();transport=ample();transport.limit.rays=2;stats=(ksn_mesh_pixel_stats){0};
 assert(!fox_transport_render(&context,&px,pixels,0,16,z,8,&stats));assert(!stats.shade_updates&&!stats.disk_samples&&transport.used.rays==2);
 assert(!memcmp(saved,data,sizeof data)&&!memcmp(&saved_px,&px,sizeof px));
 direct=ample();transport=ample();direct.limit.rays=0;
 assert(!fox_transport_render(&context,&px,pixels,0,16,z,8,&stats));assert(!stats.shade_updates&&!stats.disk_samples);direct=ample();
 /* Pairwise alias rejections happen before rendering or budget consumption. */
 vis_budget before=direct;fox_transport_context beforectx=context;
 assert(!fox_transport_render(&context,&px,(uint16_t*)&context,0,1,z,8,&stats));
 assert(!fox_transport_render(&context,&px,(uint16_t*)&direct,0,1,z,8,&stats));
 assert(!fox_transport_render(&context,&px,pixels,0,16,(float*)&context,8,&stats));
 assert(!fox_transport_render(&context,&px,pixels,0,16,z,8,(ksn_mesh_pixel_stats*)&context));
 assert(!fox_transport_render(&context,&px,pixels,0,16,z,8,(ksn_mesh_pixel_stats*)pixels));
 assert(!fox_transport_render(&context,&px,pixels,0,16,(float*)pixels,8,&stats));
 assert(!memcmp(&beforectx,&context,sizeof context)&&!memcmp(&before,&direct,sizeof direct));
 context.transport_budget=&direct;assert(!fox_transport_render(&context,&px,pixels,0,16,z,8,&stats));context.transport_budget=&transport;
 context.direct_budget=(vis_budget*)&context;assert(!fox_transport_render(&context,&px,pixels,0,16,z,8,&stats));context.direct_budget=&direct;
 assert(!memcmp(saved,data,sizeof data)&&!memcmp(&saved_px,&px,sizeof px));
 bounce_binding_clear(&context.binding);fox_pixel_unbind(&snapshot);
 printf("PIXEL_TRANSPORT_PASS OFF byte-exact world-only blocked one-bounce white plane source poison retained old binding material/light mismatch budget failure atomic aliases cumulative bands transport_rays=%llu direct_rays=%llu\n",(unsigned long long)rays,(unsigned long long)drays);
 return 0;
}
