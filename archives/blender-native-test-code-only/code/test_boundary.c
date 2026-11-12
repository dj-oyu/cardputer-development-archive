#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <string.h>
#include "ui/kasane/ksn_mesh_depth.h"
int main(void){
 uint8_t bytes[4096];ksn_mesh_snapshot s={.packets={.data=bytes,.capacity=sizeof bytes},.work_limit=8000000,.enabled=true};
 ksn_proc_gouraud_patch p={0};p.header.vertices=3;p.header.triangles=1;p.vertices[0]=(ksn_proc_gouraud_vertex){20,20,-1,0xf800,0x07e0};p.vertices[1]=(ksn_proc_gouraud_vertex){80,20,1,0xf800,0x07e0};p.vertices[2]=(ksn_proc_gouraud_vertex){20,80,-1,0xf800,0x07e0};p.indices[0]=0;p.indices[1]=1;p.indices[2]=2;float depth[3]={1,1,1};assert(ksn_mesh_append(&s,&p,depth,1));uint16_t pixels[240]={0};float z[240];assert(ksn_mesh_render(&s,pixels,30,1,z,1));assert(pixels[49]==0xf800&&pixels[50]==0x07e0&&pixels[51]==0x07e0);assert(z[49]==1);size_t before=s.packets.size;depth[0]=NAN;assert(!ksn_mesh_append(&s,&p,depth,2)&&s.packets.size==before);printf("MATERIAL_BOUNDARY_AND_NAN_PASS\n");return 0;
}
