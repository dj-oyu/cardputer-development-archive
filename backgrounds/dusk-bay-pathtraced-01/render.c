/* Standalone host harness using firmware's actual AYatsuri and Kasane code. */
#include "ayatsuri/ayatsuri_model.h"
#include "ui/kasane/ksn_mesh_depth.h"
#include "ayatsuri/ayatsuri_raster_test.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef SNAPSHOT_BUDGET
#define SNAPSHOT_BUDGET 65536
#endif
int main(int argc,char **argv){
 assert(argc==16);
 FILE *f=fopen(argv[1],"rb"); assert(f&&!fseek(f,0,SEEK_END));
 long len=ftell(f); assert(len>0&&len<=512*1024); rewind(f);
 void *bytes=malloc((size_t)len); assert(bytes&&fread(bytes,1,(size_t)len,f)==(size_t)len); assert(!fclose(f));
 ayatsuri_model m; assert(ayatsuri_model_open(bytes,(size_t)len,&m)==AYATSURI_MODEL_OK);
 size_t size=ayatsuri_model_instance_bytes(&m);void *arena=malloc(size);unsigned owner=1;ayatsuri_model_instance i;
 assert(arena&&ayatsuri_model_instance_init(&m,arena,size,&owner,1,&i)==AYATSURI_MODEL_OK);
 float camera[9],light[6]={0,0,0,1,1,1};
 for(int j=0;j<12;j++){char *end=NULL;float v=strtof(argv[3+j],&end);assert(end&&!*end&&end!=argv[3+j]&&isfinite(v));if(j<9)camera[j]=v;else light[j-9]=v;}
 assert(ayatsuri_model_instance_evaluate(&i,&owner,1,camera,light)==AYATSURI_MODEL_OK);
 static uint8_t storage[SNAPSHOT_BUDGET];
 ksn_mesh_snapshot s={.packets={storage,sizeof storage,0,0},.work_limit=8000000,.enabled=true};
 ayatsuri_model_packet p;uint32_t cur=0;ayatsuri_model_status v;
 while((v=ayatsuri_model_instance_next(&i,&owner,1,&cur,&p))==AYATSURI_MODEL_OK){
  if(p.kind==5){
   ayatsuri_model_sided_mesh_view mesh;
   assert(ayatsuri_model_instance_sided_mesh_view(&i,&owner,1,p.node_id,&mesh)==AYATSURI_MODEL_OK);
   if(!ksn_mesh_append_sided(&s,mesh.patch,mesh.depth,mesh.back_colors,mesh.back_faces,mesh.node_id)) {
    int l=0,t=0,r=0,b=0; unsigned cost=0;
    int valid=ksn_proc_gouraud_bounds(mesh.patch,&l,&t,&r,&b,&cost);
    fprintf(stderr,"append sided failed: node %u; bounds valid=%d box=%d,%d,%d,%d; cost=%u total=%u/%u packets=%u bytes=%zu cap=%zu verts=%u tris=%u holes=%u\n",
      mesh.node_id,valid,l,t,r,b,cost,s.work,s.work_limit,s.packets.packets,s.packets.size,sizeof storage,
      ((const ksn_proc_gouraud_patch*)mesh.patch)->header.vertices,((const ksn_proc_gouraud_patch*)mesh.patch)->header.triangles,((const ksn_proc_gouraud_patch*)mesh.patch)->header.holes);
    break;
   }
  }else{
   ayatsuri_model_mesh_view mesh;
   assert(p.kind==4&&ayatsuri_model_instance_mesh_view(&i,&owner,1,p.node_id,&mesh)==AYATSURI_MODEL_OK);
   assert(ksn_mesh_append(&s,mesh.patch,mesh.depth,mesh.node_id));
  }
 }
 assert(v==AYATSURI_MODEL_DONE&&s.packets.packets);
 assert(ayatsuri_model_instance_dispose(&i,&owner,1)==AYATSURI_MODEL_OK);free(arena);free(bytes);
 static uint16_t one[240*135],eight[240*135];static float scratch[240*8];
 assert(ksn_mesh_render(&s,one,0,135,scratch,1)&&ksn_mesh_render(&s,eight,0,135,scratch,8));
 assert(!memcmp(one,eight,sizeof one));unsigned coverage=0;int l=240,t=135,r=-1,b=-1;
 static uint16_t bg[240*135];
 f=fopen(argv[15],"rb");assert(f);
 for(int j=0;j<240*135;j++){int lo=fgetc(f),hi=fgetc(f);assert(lo!=EOF&&hi!=EOF);bg[j]=lo|(hi<<8);}
 assert(fgetc(f)==EOF&&!ferror(f)&&!fclose(f));
 f=fopen(argv[2],"wb");assert(f);for(int y=0;y<135;y++){
  ay_raster_composite(eight+y*240,bg+y*240,(ay_damage_span){0,240},-1);
  for(int x=0;x<240;x++){
  uint16_t a=one[y*240+x]; uint16_t out=eight[y*240+x];assert(fputc(out&255,f)!=EOF&&fputc(out>>8,f)!=EOF);
  if(a){coverage++;if(x<l)l=x;if(x>r)r=x;if(y<t)t=y;if(y>b)b=y;}
 }
 }
 assert(!fclose(f));assert(coverage&&l>0&&t>0&&r<239&&b<134);
 printf("{\"actorArenaBytes\":%zu,\"snapshotBytes\":%zu,\"packets\":%u,\"work\":%u,\"coverage\":%u,\"bbox\":[%d,%d,%d,%d],\"row1Row8Exact\":true}\n",size,s.packets.size,s.packets.packets,s.work,coverage,l,t,r,b);
 return 0;
}
