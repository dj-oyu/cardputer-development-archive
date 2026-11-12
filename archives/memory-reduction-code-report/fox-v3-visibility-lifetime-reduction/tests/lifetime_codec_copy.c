/* Real begin/append/read APIs; synthetic triangle only. No model or rendering. */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ui/kasane/ksn_mesh_depth.h"
static void poison_free(void*p,size_t n){volatile unsigned char*q=p;for(size_t i=0;i<n;i++)q[i]=0xa5;free(p);}
static void one(int pair){
 FoxDiskScene *scene=calloc(1,sizeof*scene);ksn_proc_gouraud_patch *patch=calloc(1,sizeof*patch);
 co_pixel_vertex *vertices=calloc(3,sizeof*vertices);uint8_t *bits=calloc(8,1);
 assert(scene&&patch&&vertices&&bits);
 FoxDiskLightInput lights[3]={0};double world[3]={.1,.2,.3};
 for(unsigned i=0;i<3;i++){lights[i].shape=FOX_DISK_SHAPE_DISK;lights[i].center[2]=2+i;lights[i].color[0]=1;lights[i].power=10;lights[i].diameter=1;}
 assert(fox_disk_scene_init(scene,lights,world,1)==FOX_DISK_OK);
 patch->header.vertices=3;patch->header.triangles=1;patch->indices[0]=0;patch->indices[1]=1;patch->indices[2]=2;bits[0]=1;
 float xy[3][2]={{10,10},{20,10},{10,20}};
 for(unsigned i=0;i<3;i++){
  patch->vertices[i].x=xy[i][0];patch->vertices[i].y=xy[i][1];patch->vertices[i].mask=.5f;
  vertices[i].front=(co_vertex){xy[i][0],xy[i][1],.5f,1.f+i,0x1234,0xabcd};
  vertices[i].world[0]=i;vertices[i].world[1]=i*.5;vertices[i].world[2]=-2;
  vertices[i].normal_front[2]=32767;vertices[i].normal_back[2]=-32767;
 }
 uint8_t storage[2048],saved[2048];ksn_mesh_pixel_snapshot px;
 assert(ksn_mesh_pixel_begin(&px,storage,sizeof storage,scene,8000000));
 assert(pair?ksn_mesh_pixel_append_normal_pair(&px,patch,vertices,bits,7):ksn_mesh_pixel_append(&px,patch,vertices,bits,7));
 size_t n=416+px.mesh.packets.size;memcpy(saved,storage,n);
 co_pixel_vertex expected[3];memcpy(expected,vertices,sizeof expected);
 poison_free(scene,sizeof*scene);poison_free(patch,sizeof*patch);poison_free(vertices,3*sizeof*vertices);poison_free(bits,8);
 assert(!memcmp(saved,storage,n));
 co_view v;assert(co_read(px.mesh.packets.data,px.mesh.packets.size,&v));
 assert(v.mode==(pair?5:4)&&v.node==7&&v.vertex_count==3&&v.triangle_count==1);
 for(unsigned i=0;i<3;i++){
  co_pixel_vertex got={0};assert(co_pixel_vertex_at(&v,i,&got));
  assert(got.front.x==expected[i].front.x&&got.front.y==expected[i].front.y&&got.front.depth==expected[i].front.depth&&got.front.mask==expected[i].front.mask);
  assert(got.front.color_a==expected[i].front.color_a&&got.front.color_b==expected[i].front.color_b);
  assert(!memcmp(got.world,expected[i].world,sizeof got.world));
  assert(!memcmp(got.normal_front,expected[i].normal_front,sizeof got.normal_front));assert(!memcmp(got.normal_back,expected[i].normal_back,sizeof got.normal_back));
 }
 uint8_t indices[3];bool back=false;assert(co_triangle_at(&v,0,indices));assert(indices[0]==0&&indices[1]==1&&indices[2]==2);assert(co_triangle_side(&v,0,&back)&&back);
}
int main(void){one(0);one(1);puts("PASS: actual pixel begin + mode4/mode5 append and decoded vertex/index/side reads after all heap inputs poisoned/freed; no rendering");}
