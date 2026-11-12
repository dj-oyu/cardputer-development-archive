#include "../code/attributes.h"
#include "../../ayatsuri-fixed-integer-geometry-20261105/geometry.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
int main(void){
 Camera cam={{64<<20,0,0,0,64<<20,0,0,0,1<<20},{120<<10,67<<10,0},16,240,135};
 il_pixel v[3]={{{-32768,-32768,0},{0,0,32767},{32767,20000,12000},{65535,65535,65535}},{{32768,-32768,0},{19660,0,26214},{12000,32767,20000},{65535,65535,65535}},{{0,32768,0},{-19660,0,26214},{20000,12000,32767},{65535,65535,65535}}};
 int32_t positions[9];for(unsigned j=0;j<3;j++)memcpy(positions+j*3,v[j].p,12);Point tri[3],batchtri[3];assert(project_batch(&cam,positions,tri,3,1)==0);for(int width=1;width<=8;width*=2){assert(project_batch(&cam,positions,batchtri,3,width)==0);assert(!memcmp(tri,batchtri,sizeof tri));}
 il_scene scene={0};for(unsigned k=0;k<3;k++)scene.world[k]=167772;for(unsigned l=0;l<3;l++){il_light*a=&scene.light[l];a->center[0]=(int32_t)l*8192-8192;a->center[2]=131072;a->normal[2]=-32767;for(unsigned k=0;k<3;k++)a->power[k]=65536*(l+1);for(unsigned j=0;j<16;j++){a->sample[j][0]=a->center[0]+((int32_t)(j%4)*2-3)*1024;a->sample[j][1]=((int32_t)(j/4)*2-3)*1024;a->sample[j][2]=131072;}}assert(il_scene_valid(&scene));agx_block_cache cache;assert(private_integer_profile_bind(&cache));
 int32_t xy[64];for(unsigned j=0;j<32;j++){xy[j*2]=(96+(j%8)*7)<<10;xy[j*2+1]=(42+(j/8)*14)<<10;}int8_t covered[32],cb[32];int16_t weights[96],wb[96];assert(sample_batch(tri,xy,32,1,covered,weights)==0);for(int width=1;width<=8;width*=2){assert(sample_batch(tri,xy,32,width,cb,wb)==0);assert(!memcmp(covered,cb,sizeof cb)&&!memcmp(weights,wb,sizeof wb));}
 il_pixel points[32];chain_result refs[32];unsigned n=0,rejected=0;for(unsigned j=0;j<32;j++){if(!covered[j])continue;assert(chain_attributes(v,weights+3*j,points+n));assert(chain_block(&scene,points+n,1,&cache,refs+n));assert(refs[n].status==0);n++;}
 for(unsigned width=1;width<=8;width*=2){for(unsigned j=0;j<n;){unsigned count=n-j>=width?width:1;chain_result out[8];assert(chain_block(&scene,points+j,count,&cache,out));for(unsigned k=0;k<count;k++)assert(out[k].status==refs[j+k].status&&out[k].pixel==refs[j+k].pixel&&!memcmp(out[k].hdr24,refs[j+k].hdr24,24));j+=count;}}
 int16_t invalid[3]={16384,16384,0};il_pixel untouched;memset(&untouched,0x5a,sizeof untouched);il_pixel saved=untouched;assert(!chain_attributes(v,invalid,&untouched)&&!memcmp(&saved,&untouched,sizeof saved));rejected++;
 il_pixel opposed[3]={v[0],v[0],v[0]};opposed[1].normal[2]=-32767;int16_t cancel[3]={8192,8192,0};assert(!chain_attributes(opposed,cancel,&untouched)&&!memcmp(&saved,&untouched,sizeof saved));rejected++;
 il_scene edge=scene;il_pixel ep=v[0];ep.p[0]=ep.p[1]=0;ep.p[2]=131072-8389;ep.normal[0]=ep.normal[1]=0;ep.normal[2]=32767;for(unsigned k=0;k<3;k++)ep.rho[k]=32767;
 for(unsigned l=0;l<3;l++){edge.light[l].center[0]=edge.light[l].center[1]=0;for(unsigned j=0;j<16;j++)memcpy(edge.light[l].sample[j],edge.light[l].center,12);for(unsigned k=0;k<3;k++)edge.light[l].power[k]=256u<<16;}chain_result er[8];assert(chain_block(&edge,&ep,1,&cache,er)&&er[0].status==20);printf("synthetic_bright_hdr19_overflow_status=%d\n",er[0].status);
 for(unsigned l=0;l<3;l++)for(unsigned k=0;k<3;k++)edge.light[l].power[k]=40u<<16;assert(chain_block(&edge,&ep,1,&cache,er)&&er[0].status==1);printf("synthetic_profile_high_clamp_status=%d\n",er[0].status);
 ep.p[2]=131072-655;assert(chain_block(&edge,&ep,1,&cache,er)&&er[0].status==12);printf("synthetic_near_plane_fallback_status=%d\n",er[0].status);
 printf("synthetic samples=32 covered=%u 1_2_4_8_mismatch=0 invalid_or_cancelled_normal_rejected=%u first_pixel=%u\n",n,rejected,refs[0].pixel);return 0;
}
