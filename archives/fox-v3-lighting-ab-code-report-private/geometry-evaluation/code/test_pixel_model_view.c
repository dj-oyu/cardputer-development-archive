#include "ayatsuri/ayatsuri_model.h"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
static unsigned u16(const unsigned char*p){return p[0]|p[1]<<8;}
static float f32(const unsigned char*p){float x;memcpy(&x,p,4);return x;}
static void parity(ayatsuri_model_instance *i,int *owner,const float scale[3]){
 ayatsuri_model_pixel_mesh_view v;const ayatsuri_model*m=i->model;
 assert(ayatsuri_model_instance_pixel_mesh_view(i,owner,1,1,i->mutation_epoch,&v)==0);
 const unsigned char*d=m->data+m->section[8].offset;
 assert(v.mutation_epoch==i->mutation_epoch);
 for(unsigned j=0;j<v.patch->header.vertices;j++){
  const unsigned char*c=m->data+m->section[9].offset+28*(u16(d)+j);
  const co_pixel_vertex*p=v.vertices+j;double n[3],len;
  for(unsigned r=0;r<3;r++)n[r]=(double)f32(c+12+4*r)/scale[r];
  len=hypot(hypot(n[0],n[1]),n[2]);
  for(unsigned r=0;r<3;r++){
   assert(p->world[r]==(double)scale[r]*f32(c+4*r));
   assert(p->normal_front[r]==(int16_t)floor(n[r]*32767/len+.5));
   assert(p->normal_back[r]==(int16_t)floor(-n[r]*32767/len+.5));
  }
  assert(p->front.color_a==u16(d+14)&&p->front.color_b==u16(d+16));
  assert(p->front.x==v.patch->vertices[j].x&&p->front.y==v.patch->vertices[j].y);
  assert(p->front.mask==f32(c+24)&&p->front.depth==v.depth[j]);
 }
 ayatsuri_model_sided_mesh_view sided;
 if(ayatsuri_model_instance_sided_mesh_view(i,owner,1,1,&sided)==0)assert(!memcmp(v.back_faces,sided.back_faces,8));
 else {unsigned char zero[8]={0};assert(!memcmp(v.back_faces,zero,8));}
}
int main(int argc,char**argv){assert(argc>1);for(int t=1;t<argc;t++){
 FILE*f=fopen(argv[t],"rb");assert(f);fseek(f,0,2);size_t len=ftell(f);rewind(f);unsigned char*b=malloc(len);assert(fread(b,1,len,f)==len);fclose(f);
 ayatsuri_model m;assert(ayatsuri_model_open(b,len,&m)==0);size_t n=ayatsuri_model_instance_bytes(&m);void*a=malloc(n),*saved=malloc(n);int owner=1,wrong=2;ayatsuri_model_instance i;
 assert(ayatsuri_model_instance_init(&m,a,n,&owner,1,&i)==0);
 ayatsuri_model_pixel_mesh_view v,sentinel;memset(&sentinel,0xa5,sizeof sentinel);v=sentinel;
 assert(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,1,1,i.mutation_epoch,&v)==AYATSURI_MODEL_STATE&&!memcmp(&v,&sentinel,sizeof v));
 float camera[9]={0,0,400,0,0,0,1,0,0},light[6]={0,0,1,0,0,0};assert(ayatsuri_model_instance_evaluate(&i,&owner,1,camera,light)==0);
 ayatsuri_model_instance prior=i;memcpy(saved,a,n);
 #define REJECT(call,status) do{assert((call)==(status));assert(!memcmp(&v,&sentinel,sizeof v));assert(!memcmp(&i,&prior,sizeof i));assert(!memcmp(a,saved,n));}while(0)
 REJECT(ayatsuri_model_instance_pixel_mesh_view(&i,&wrong,1,1,i.mutation_epoch,&v),AYATSURI_MODEL_STATE);
 REJECT(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,2,1,i.mutation_epoch,&v),AYATSURI_MODEL_STATE);
 REJECT(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,1,1,i.mutation_epoch+1,&v),AYATSURI_MODEL_STATE);
 REJECT(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,1,0,i.mutation_epoch,&v),AYATSURI_MODEL_INVALID);
 REJECT(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,1,65535,i.mutation_epoch,&v),AYATSURI_MODEL_INVALID);
 REJECT(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,1,1,i.mutation_epoch,NULL),AYATSURI_MODEL_INVALID);
 REJECT(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,1,1,i.mutation_epoch,(void*)a),AYATSURI_MODEL_INVALID);
 i.busy=true;prior=i;REJECT(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,1,1,i.mutation_epoch,&v),AYATSURI_MODEL_BUSY);i.busy=false;prior=i;
 float pose[18]={0};assert(ayatsuri_model_instance_read_pose(&i,&owner,1,1,pose+9)==0);parity(&i,&owner,pose+15);
 assert(!memcmp(&i,&prior,sizeof i)&&!memcmp(a,saved,n));
 assert(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,1,1,i.mutation_epoch,&v)==0);ayatsuri_model_pixel_mesh_view snapshot=v;
 uint8_t dirty[2]={0,AYATSURI_TARGET_SCALE};pose[15]=-pose[15];uint32_t colors[2]={0};double opacity[2]={1,1};ayatsuri_model_targets targets={dirty,pose,colors,opacity,2};
 assert(ayatsuri_model_instance_targets(&i,&owner,1,&targets)==0);assert(!memcmp(v.vertices,snapshot.vertices,sizeof v.vertices));assert(!memcmp(v.back_faces,snapshot.back_faces,8));
 assert(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,1,1,snapshot.mutation_epoch,&v)==AYATSURI_MODEL_STATE);
 assert(ayatsuri_model_instance_evaluate(&i,&owner,1,camera,light)==0);
 assert(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,1,1,snapshot.mutation_epoch,&v)==AYATSURI_MODEL_STATE);
 parity(&i,&owner,pose+15);
 assert(ayatsuri_model_instance_dispose(&i,&owner,1)==0);
 assert(ayatsuri_model_instance_pixel_mesh_view(&i,&owner,1,1,i.mutation_epoch,&v)==AYATSURI_MODEL_STATE);
 free(saved);free(a);free(b);printf("PIXEL_VIEW_PASS %s\n",argv[t]);
 }puts("owner generation busy epoch mutation disposal output/arena atomic rawAB world inverse-scale front/back reflection physical-side palette-equality PASS");}
