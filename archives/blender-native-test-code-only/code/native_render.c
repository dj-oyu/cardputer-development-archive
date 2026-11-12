#define _POSIX_C_SOURCE 200809L
/* Host adapter only: production model evaluator, owned snapshot and raster unchanged. */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
#include <time.h>
static unsigned long long ns(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return (unsigned long long)t.tv_sec*1000000000ull+t.tv_nsec;}
#include "ayatsuri/ayatsuri_model.h"
#include "ui/kasane/ksn_mesh_depth.h"
static int fail(const char *s){fprintf(stderr,"NATIVE_GATE:%s\n",s);return 2;}
int main(int argc,char **argv){
 if(argc!=19)return fail("arguments: model color depth reverse camera9 light6");
 float cam[9],light[6];for(int i=0;i<9;i++)cam[i]=strtof(argv[4+i],NULL);for(int i=0;i<6;i++)light[i]=strtof(argv[13+i],NULL);
 FILE *f=fopen(argv[1],"rb");if(!f)return fail("input");fseek(f,0,SEEK_END);long bytes=ftell(f);rewind(f);if(bytes<1||bytes>1048576)return fail("size");
 uint8_t *data=malloc((size_t)bytes);if(!data||fread(data,1,(size_t)bytes,f)!=(size_t)bytes)return fail("read");fclose(f);
 ayatsuri_model m;if(ayatsuri_model_open(data,(size_t)bytes,&m))return fail("model");
 size_t ab=ayatsuri_model_instance_bytes(&m);void *arena=malloc(ab);int owner=0;ayatsuri_model_instance ins;
 if(!arena||ayatsuri_model_instance_init(&m,arena,ab,&owner,1,&ins)||ayatsuri_model_instance_evaluate(&ins,&owner,1,cam,light))return fail("evaluate");
 uint8_t payload[65536];ksn_mesh_snapshot s={.packets={.data=payload,.capacity=sizeof payload},.work_limit=8000000,.enabled=true};
 uint16_t ids[256];unsigned count=0;uint32_t cursor=0;ayatsuri_model_packet p;ayatsuri_model_status rc;
 while((rc=ayatsuri_model_instance_next(&ins,&owner,1,&cursor,&p))==AYATSURI_MODEL_OK){if(count==256||p.kind!=4)return fail("mesh-only");ids[count++]=p.node_id;}
 if(rc!=AYATSURI_MODEL_DONE||!count)return fail("empty");
 int reverse=atoi(argv[3]);
 for(unsigned at=0;at<count;at++){
  ayatsuri_model_mesh_view v;if(ayatsuri_model_instance_mesh_view(&ins,&owner,1,ids[reverse?count-1-at:at],&v))return fail("view");
  ksn_proc_gouraud_patch patch;memcpy(&patch,v.patch,sizeof patch);
  if(reverse)for(unsigned a=0,b=patch.header.triangles-1;a<b;a++,b--)for(unsigned k=0;k<3;k++){uint16_t q=patch.indices[3*a+k];patch.indices[3*a+k]=patch.indices[3*b+k];patch.indices[3*b+k]=q;}
  if(!ksn_mesh_append(&s,&patch,v.depth,v.node_id))return fail("append");
 }
 if(ayatsuri_model_instance_dispose(&ins,&owner,1))return fail("dispose");memset(arena,0xa5,ab);memset(data,0xa5,(size_t)bytes);free(arena);free(data);
 char path[4096];snprintf(path,sizeof path,"%s.u16le",argv[2]);FILE *c=fopen(path,"wb");snprintf(path,sizeof path,"%s.f32le",argv[2]);FILE *d=fopen(path,"wb");if(!c||!d)return fail("output");
 uint16_t color[240*8];float z[240*8];unsigned long long render_ns=0;
 for(unsigned y=0;y<135;y+=8){unsigned h=135-y<8?135-y:8;memset(color,0,sizeof color);unsigned long long begin=ns();if(!ksn_mesh_render(&s,color,y,h,z,8))return fail("render");render_ns+=ns()-begin;for(unsigned j=0;j<240*h;j++)if(isnan(z[j])||z[j]==INFINITY)return fail("nonfinite-depth");if(fwrite(color,2,240*h,c)!=240*h||fwrite(z,4,240*h,d)!=240*h)return fail("write");}fclose(c);fclose(d);
 printf("{\"camera\":[");for(int i=0;i<9;i++)printf("%s%.9g",i?",":"",cam[i]);printf("],\"light\":[");for(int i=0;i<6;i++)printf("%s%.9g",i?",":"",light[i]);printf("],\"coldBytes\":%ld,\"arenaBytes64bit\":%zu,\"snapshotBytes\":%zu,\"work\":%u,\"hostRenderNsFirstFrame\":%llu,\"depthScratchBytes\":7680,\"colorBandBytes\":3840,\"snapshotCapacity\":65536,\"disposedBeforeRender\":true,\"reverse\":%s}\n",bytes,ab,s.packets.size,s.work,render_ns,reverse?"true":"false");return 0;
}
