#include "ayatsuri/ayatsuri_model.h"
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc,char **argv){
 assert(argc==2);FILE*f=fopen(argv[1],"rb");assert(f);fseek(f,0,SEEK_END);size_t size=ftell(f);rewind(f);void*b=malloc(size);assert(b&&fread(b,1,size,f)==size);fclose(f);
 ayatsuri_model m;assert(!ayatsuri_model_open(b,size,&m));size_t n=ayatsuri_model_instance_bytes(&m);void*a=malloc(n);int owner=1,wrong=2;ayatsuri_model_instance i;assert(!ayatsuri_model_instance_init(&m,a,n,&owner,1,&i));assert(!i.agx_profile);
 float cam[9]={-3.8f,-114,304,-15.2f,-69.16f,-6.84f,.740131579f,119.5f,67},light[6]={-3,-4.3f,4,1,.83f,.65f};
 ayatsuri_model_instance old=i;assert(ayatsuri_model_instance_agx_profile(&i,&owner,1,1)==AYATSURI_MODEL_INVALID&&!memcmp(&i,&old,sizeof i));
 FoxDiskLightInput ls[3]={0};for(unsigned j=0;j<3;j++){ls[j].shape=FOX_DISK_SHAPE_DISK;ls[j].center[2]=6;ls[j].center[1]=-4;ls[j].power=100;ls[j].diameter=3;for(unsigned k=0;k<3;k++)ls[j].color[k]=1;}double world[3]={1,.88,.69};FoxDiskScene s;assert(fox_disk_scene_init(&s,ls,world,.35)==FOX_DISK_OK);
 assert(!ayatsuri_model_instance_disk_scene(&i,&owner,1,&s));old=i;assert(ayatsuri_model_instance_agx_profile(&i,&owner,1,1)==AYATSURI_MODEL_INVALID&&!memcmp(&i,&old,sizeof i));
 assert(!ayatsuri_model_instance_linear_light(&i,&owner,1,1));assert(!ayatsuri_model_instance_evaluate(&i,&owner,1,cam,light));void*before=malloc(n);memcpy(before,a,n);old=i;
 assert(ayatsuri_model_instance_agx_profile(&i,&owner,1,2)==AYATSURI_MODEL_INVALID&&!memcmp(&i,&old,sizeof i));assert(ayatsuri_model_instance_agx_profile(&i,&wrong,1,1)==AYATSURI_MODEL_STATE&&!memcmp(&i,&old,sizeof i));assert(ayatsuri_model_instance_agx_profile(&i,&owner,2,1)==AYATSURI_MODEL_STATE);i.busy=true;assert(ayatsuri_model_instance_agx_profile(&i,&owner,1,1)==AYATSURI_MODEL_BUSY);i.busy=false;
 assert(!ayatsuri_model_instance_agx_profile(&i,&owner,1,0)&&!memcmp(&i,&old,sizeof i));assert(!ayatsuri_model_instance_agx_profile(&i,&owner,1,1));assert(!i.evaluated&&i.mutation_epoch==old.mutation_epoch+1);old=i;
 assert(ayatsuri_model_instance_linear_light(&i,&owner,1,0)==AYATSURI_MODEL_INVALID&&!memcmp(&i,&old,sizeof i));assert(ayatsuri_model_instance_disk_scene(&i,&owner,1,NULL)==AYATSURI_MODEL_INVALID&&!memcmp(&i,&old,sizeof i));
 uint32_t cursor=0;ayatsuri_model_packet p;assert(ayatsuri_model_instance_next(&i,&owner,1,&cursor,&p)==AYATSURI_MODEL_STATE);assert(!ayatsuri_model_instance_evaluate(&i,&owner,1,cam,light));assert(i.profile_evaluations>0);old=i;assert(!ayatsuri_model_instance_agx_profile(&i,&owner,1,1)&&!memcmp(&i,&old,sizeof i));
 assert(!ayatsuri_model_instance_agx_profile(&i,&owner,1,0)&&!i.evaluated);assert(!ayatsuri_model_instance_evaluate(&i,&owner,1,cam,light));assert(!memcmp(before,a,n));
 assert(!ayatsuri_model_instance_dispose(&i,&owner,1));assert(ayatsuri_model_instance_agx_profile(&i,&owner,1,1)==AYATSURI_MODEL_STATE);
 printf("PROFILE_API_PASS owner generation busy invalid atomic dependency noop epoch borrowed-view invalidation OFF arena exact dispose control=%zu\n",sizeof i);free(before);free(a);free(b);return 0;
}
