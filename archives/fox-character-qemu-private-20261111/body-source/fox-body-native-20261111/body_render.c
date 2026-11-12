#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ayatsuri_skin_dq.h"
#include "ayatsuri_smooth_normals.h"
#include "ayatsuri/ayatsuri_model_skin.h"
#include "ui/kasane/ksn_mesh_depth.h"
#include "fixture.h"
#include "model.h"
#ifndef TARGET_BODY
#include "oracle.h"
#endif
#define SNAPSHOT_BYTES 32768
static ayatsuri_model model;
static ayatsuri_model_instance actor;
static void *arena_owner;
static unsigned owner=1;
static ayatsuri_skin_result deformed[229],scattered[TOTAL_VERTICES];
static float positions[229][3],normals[229][3];
static double normal_scratch[229][3];
static ayatsuri_model_mesh_geometry geometry[PARTS];
static uint8_t storage[SNAPSHOT_BYTES];
static size_t max_packet;
static size_t last_packet;
static uint16_t row_pixels[240];
static float depth_scratch[240];
static const float cameras[2][9]={{0,-1.55,8,0,-1.55,0,36,120,67},{4,-3.0,8,0,-1.55,0,36,120,67}};
static const float light[6]={-.3f,-.5f,.8f,1,1,1};
void body_row(unsigned pose,unsigned view,unsigned y,const uint16_t *row);
int body_init(void){
 assert(ayatsuri_model_open(model_blob,sizeof model_blob,&model)==AYATSURI_MODEL_OK);
 size_t n=ayatsuri_model_instance_bytes(&model);arena_owner=malloc(n+7);assert(arena_owner);
 void *arena=(void *)(((uintptr_t)arena_owner+7)&~(uintptr_t)7);
 assert(ayatsuri_model_instance_init(&model,arena,n,&owner,1,&actor)==AYATSURI_MODEL_OK);
 unsigned offset=0;for(unsigned k=0;k<PARTS;k++){geometry[k]=(ayatsuri_model_mesh_geometry){k+1,part_counts[k],scattered+offset};offset+=part_counts[k];}
 printf("BODY_MEMORY cold=%zu arena=%zu arena_padding=7 skin=%zu positions=%zu normals=%zu normal_scratch=%zu scatter=%zu descriptors=%zu snapshot_capacity=%zu row=%zu depth=%zu input_const=%zu globals_const=%zu topology_const=%zu\n",sizeof model_blob,n,sizeof deformed,sizeof positions,sizeof normals,sizeof normal_scratch,sizeof scattered,sizeof geometry,sizeof storage,sizeof row_pixels,sizeof depth_scratch,sizeof rest_input,sizeof globals,sizeof topology);
 return 0;
}
uint32_t body_frame(unsigned pose,unsigned view,int oracle_mode,int capture){
 assert(pose<64&&view<2);ayatsuri_transform palette[2];
 assert(ayatsuri_skin_palette(globals[pose],inverse_bind,2,palette)==AYATSURI_OK);
 assert(ayatsuri_skin_evaluate_method(AYATSURI_SKIN_METHOD_RIGID_DQ,palette,2,rest_input,229,deformed)==AYATSURI_OK);
 for(unsigned i=0;i<229;i++)memcpy(positions[i],deformed[i].position,sizeof positions[i]);
 assert(ayatsuri_recompute_smooth_normals(AYATSURI_NORMAL_ALL_SMOOTH_TRIANGLES,positions,229,topology,454,normal_scratch,normals)==AYATSURI_OK);
#ifndef TARGET_BODY
 if(oracle_mode)for(unsigned i=0;i<229;i++){memcpy(positions[i],oracle[pose][i],12);memcpy(normals[i],oracle[pose][i]+3,12);}
#else
 assert(!oracle_mode);
#endif
 for(unsigned i=0;i<TOTAL_VERTICES;i++){const float *p=positions[scatter[i]],*n=normals[scatter[i]];scattered[i]=(ayatsuri_skin_result){{p[0],-p[2],-p[1]},{n[0],-n[2],-n[1]}};}
 assert(ayatsuri_model_instance_evaluate_meshes(&actor,&owner,1,cameras[view],light,geometry,PARTS)==AYATSURI_MODEL_OK);
 ksn_mesh_snapshot snap={.packets={storage,sizeof storage,0,0},.work_limit=2000000,.enabled=true};
 uint32_t cursor=0;ayatsuri_model_packet packet;ayatsuri_model_status status;
 while((status=ayatsuri_model_instance_next(&actor,&owner,1,&cursor,&packet))==AYATSURI_MODEL_OK){
  assert(packet.kind==4);ayatsuri_model_mesh_view v;
  assert(ayatsuri_model_instance_mesh_view(&actor,&owner,1,packet.node_id,&v)==AYATSURI_MODEL_OK);
  assert(ksn_mesh_append(&snap,v.patch,v.depth,v.node_id));
 }
 assert(status==AYATSURI_MODEL_DONE);if(snap.packets.size>max_packet)max_packet=snap.packets.size;last_packet=snap.packets.size;
 // Renderer sees only frame-owned packets. Poison caller geometry to prove copy boundary.
 memset(scattered,0xa5,sizeof scattered);
 uint32_t hash=2166136261u;unsigned covered=0;
 for(unsigned y=0;y<135;y++){
  for(unsigned x=0;x<240;x++)row_pixels[x]=17;
  assert(ksn_mesh_render(&snap,row_pixels,y,1,depth_scratch,1));
  for(unsigned x=0;x<240;x++){hash=(hash^row_pixels[x])*16777619u;covered+=row_pixels[x]!=17;}
  if(capture)body_row(pose,view,y,row_pixels);
 }
 assert(covered>500);
 printf("BODY_FRAME pose=%u view=%u oracle=%d hash=%08x covered=%u packet=%zu work=%u\n",pose,view,oracle_mode,hash,covered,snap.packets.size,snap.work);
 return hash;
}
void body_shutdown(void){
 printf("BODY_PEAK packet=%zu\n",max_packet);
 assert(ayatsuri_model_instance_dispose(&actor,&owner,1)==AYATSURI_MODEL_OK);free(arena_owner);arena_owner=NULL;
}
#ifndef TARGET_BODY
static FILE *capture_file;
void body_row(unsigned pose,unsigned view,unsigned y,const uint16_t *row){(void)pose;(void)view;(void)y;for(unsigned x=0;x<240;x++){fputc(row[x]&255,capture_file);fputc(row[x]>>8,capture_file);}}
static uint16_t actual[240*135],expected_pixels[240*135];
static void capture(unsigned pose,unsigned view,int mode){char p[128];snprintf(p,sizeof p,"frame-v%u-p%02u-%s.rgb565",view,pose,mode?"oracle":"dq");capture_file=fopen(p,"wb");assert(capture_file);body_frame(pose,view,mode,1);assert(!fclose(capture_file));FILE*f=fopen(p,"rb");assert(f);assert(fread(mode?expected_pixels:actual,2,240*135,f)==240*135);assert(!fclose(f));}
static void rejection_test(void){
 uint32_t before_hash=body_frame(63,0,0,0);
 ayatsuri_model_instance saved=actor;void *copy=malloc(actor.arena_bytes);assert(copy);memcpy(copy,actor.arena,actor.arena_bytes);
 // Restore caller geometry, then poison only the final descriptor: no prefix publish.
 for(unsigned i=0;i<TOTAL_VERTICES;i++){const float *p=positions[scatter[i]],*n=normals[scatter[i]];scattered[i]=(ayatsuri_skin_result){{p[0],-p[2],-p[1]},{n[0],-n[2],-n[1]}};}
 scattered[TOTAL_VERTICES-1].position[0]=NAN;
 assert(ayatsuri_model_instance_evaluate_meshes(&actor,&owner,1,cameras[0],light,geometry,PARTS)==AYATSURI_MODEL_INVALID);
 assert(!memcmp(&saved,&actor,sizeof actor)&&!memcmp(copy,actor.arena,actor.arena_bytes));
 free(copy);
 ksn_mesh_snapshot retained={.packets={storage,sizeof storage,last_packet,0},.work_limit=2000000,.enabled=true};
 uint32_t retained_hash=2166136261u;
 for(unsigned y=0;y<135;y++){for(unsigned x=0;x<240;x++)row_pixels[x]=17;assert(ksn_mesh_render(&retained,row_pixels,y,1,depth_scratch,1));for(unsigned x=0;x<240;x++)retained_hash=(retained_hash^row_pixels[x])*16777619u;}
 assert(retained_hash==before_hash);
 uint32_t cursor=0;ayatsuri_model_packet packet;assert(ayatsuri_model_instance_next(&actor,&owner,1,&cursor,&packet)==AYATSURI_MODEL_OK);
 assert(body_frame(63,0,0,0)==body_frame(63,0,0,0));
 puts("BODY_REJECT_PASS late_nan unchanged_actor unchanged_arena ready_packet retained_snapshot_pixels recovery_repeat");
}
int main(void){body_init();rejection_test();uint32_t hashes[2][64];unsigned differing_total=0,max_diff=0;
 for(unsigned v=0;v<2;v++){
  for(unsigned p=0;p<64;p++)hashes[v][p]=body_frame(p,v,0,0);
  for(unsigned visit=0;visit<64;visit++){unsigned p=63-visit;assert(body_frame(p,v,0,0)==hashes[v][p]);}
  assert(body_frame(63,v,0,0)==hashes[v][63]);
  for(unsigned p=0;p<64;p++){
   capture(p,v,0);capture(p,v,1);unsigned diff=0;for(unsigned x=0;x<240*135;x++)diff+=actual[x]!=expected_pixels[x];if(diff>max_diff)max_diff=diff;differing_total+=diff;
   printf("BODY_COMPARE pose=%u view=%u differing_pixels=%u\n",p,v,diff);
  }
 }
 printf("BODY_PASS views=2 poses=64 reverse=128 pause=2 oracle_frames=128 differing_pixels_total=%u max_per_frame=%u\n",differing_total,max_diff);body_shutdown();return 0;}
#endif
