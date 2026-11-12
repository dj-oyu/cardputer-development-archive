#include "ayatsuri/ayatsuri_model.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static unsigned u16(const unsigned char*p){return p[0]|p[1]<<8;}
int main(int argc,char**argv){assert(argc>1);for(int t=1;t<argc;t++){
 FILE*f=fopen(argv[t],"rb");assert(f);fseek(f,0,2);size_t len=ftell(f);rewind(f);unsigned char*b=malloc(len);assert(fread(b,1,len,f)==len);fclose(f);
 ayatsuri_model m;assert(ayatsuri_model_open(b,len,&m)==0);size_t n=ayatsuri_model_instance_bytes(&m);void*a=malloc(n),*saved=malloc(n);int owner=1,wrong=2;ayatsuri_model_instance i;
 assert(ayatsuri_model_instance_init(&m,a,n,&owner,1,&i)==0);
 ayatsuri_model_world_mesh_view v,sentinel,front;memset(&sentinel,0xa5,sizeof sentinel);v=sentinel;
 assert(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,1,i.mutation_epoch,&v)==AYATSURI_MODEL_STATE&&!memcmp(&v,&sentinel,sizeof v));
 float camera[9]={0,0,400,0,0,0,1,0,0},light[6]={0,0,1,0,0,0};assert(ayatsuri_model_instance_evaluate(&i,&owner,1,camera,light)==0);
 ayatsuri_model_instance prior=i;memcpy(saved,a,n);
 #define REJECT(call,status) do{assert((call)==(status));assert(!memcmp(&v,&sentinel,sizeof v));assert(!memcmp(&i,&prior,sizeof i));assert(!memcmp(a,saved,n));}while(0)
 REJECT(ayatsuri_model_instance_world_mesh_view(&i,&wrong,1,1,i.mutation_epoch,&v),AYATSURI_MODEL_STATE);
 REJECT(ayatsuri_model_instance_world_mesh_view(&i,&owner,2,1,i.mutation_epoch,&v),AYATSURI_MODEL_STATE);
 REJECT(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,1,i.mutation_epoch+1,&v),AYATSURI_MODEL_STATE);
 REJECT(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,0,i.mutation_epoch,&v),AYATSURI_MODEL_INVALID);
 REJECT(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,65535,i.mutation_epoch,&v),AYATSURI_MODEL_INVALID);
 REJECT(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,1,i.mutation_epoch,NULL),AYATSURI_MODEL_INVALID);
 REJECT(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,1,i.mutation_epoch,(void*)a),AYATSURI_MODEL_INVALID);
 i.busy=true;prior=i;REJECT(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,1,i.mutation_epoch,&v),AYATSURI_MODEL_BUSY);i.busy=false;prior=i;
 assert(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,1,i.mutation_epoch,&front)==0);assert(!memcmp(&i,&prior,sizeof i)&&!memcmp(a,saved,n));
 unsigned empty=0;
 for(unsigned view=0;view<4;view++){
  camera[0]=view==2?400:0;camera[2]=view==2?0:view==1?-400:400;camera[7]=view==3?1000:0;
  assert(ayatsuri_model_instance_evaluate(&i,&owner,1,camera,light)==0);
  assert(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,1,i.mutation_epoch,&v)==0);
  assert(!memcmp(&v,&front,sizeof v));
  ayatsuri_model_pixel_mesh_view pixel;assert(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,1,1,i.mutation_epoch,&pixel)==0);
  if(!pixel.patch->header.triangles)empty++;
  for(unsigned j=0;j<v.vertex_count;j++)assert(!memcmp(v.world[j],pixel.vertices[j].world,3*sizeof(double)));
  const unsigned char*d=b+m.section[8].offset;
  assert(v.node_id==1&&v.vertex_count==u16(d+2)&&v.triangle_count==u16(d+6));
  for(unsigned j=0;j<3*v.triangle_count;j++)assert(v.indices[j]==u16(b+m.section[10].offset+6*u16(d+4)+2*j));
 }
 assert(empty); /* Every fixture is a planar XY sheet, therefore edge-on is culled. */
 float pose[18]={0};uint8_t dirty[2]={0,AYATSURI_TARGET_SCALE};uint32_t colors[2]={0};double opacity[2]={1,1};assert(ayatsuri_model_instance_read_pose(&i,&owner,1,1,pose+9)==0);pose[15]=-pose[15];ayatsuri_model_targets targets={dirty,pose,colors,opacity,2};
 assert(ayatsuri_model_instance_targets(&i,&owner,1,&targets)==0);
 assert(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,1,front.mutation_epoch,&v)==AYATSURI_MODEL_STATE);
 assert(ayatsuri_model_instance_evaluate(&i,&owner,1,camera,light)==0);
 assert(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,1,front.mutation_epoch,&v)==AYATSURI_MODEL_STATE);
 assert(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,1,i.mutation_epoch,&v)==0);
 assert(!memcmp(v.indices,front.indices,sizeof v.indices));for(unsigned j=0;j<v.vertex_count;j++){assert(v.world[j][0]==-front.world[j][0]);assert(v.world[j][1]==front.world[j][1]);assert(v.world[j][2]==front.world[j][2]);}
 assert(ayatsuri_model_instance_dispose(&i,&owner,1)==0);assert(ayatsuri_model_instance_world_mesh_view(&i,&owner,1,1,i.mutation_epoch,&v)==AYATSURI_MODEL_STATE);
 free(saved);free(a);free(b);printf("WORLD_VIEW_PASS %s\n",argv[t]);
 }puts("owned full geometry camera-front/back/edge-on/offscreen index+world parity reflection epoch and error atomicity PASS");}
