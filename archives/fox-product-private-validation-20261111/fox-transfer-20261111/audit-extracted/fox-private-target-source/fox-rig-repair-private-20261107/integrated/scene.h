#ifndef PRIVATE_SCENE_H
#define PRIVATE_SCENE_H
#include "ksn_mesh_prepared.h"
#include "ayatsuri_skin_dq.h"
#include "ayatsuri_smooth_normals.h"
typedef struct {float x,y,z;uint16_t object;} scene_vertex;
typedef struct {uint16_t v[3],material;} scene_triangle;
#define SCENE_VERTICES 1322
#define SCENE_TRIANGLES 1982
#define SCENE_WORDS 31
#define SCENE_BANDS 34
typedef struct {float projected[SCENE_VERTICES][3];uint64_t bins[SCENE_BANDS][SCENE_WORDS];unsigned zero_area,tiny_area,active;int pose;unsigned camera;bool valid;} scene_frame;
typedef union {
 struct {union{ayatsuri_skin_result dq[229];double sum[229][3];} temp;float pos[229][3],normals[229][3];ayatsuri_transform palette[2];} rig;
 struct {_Alignas(16)unsigned char prep[sizeof(ksn_mesh_prepared)+32*sizeof(ksn_prepared_triangle)];float depth[240*4];uint16_t pixels[240*4];unsigned char packets[2048];co_vertex vertices[30];uint16_t indices[30];} raster;
} scene_workspace;
typedef struct {double rig_ms,project_ms,index_ms;} scene_times;
bool scene_prepare(const scene_frame*,scene_frame*,scene_workspace*,int,unsigned,int,scene_times*);
bool scene_band(const scene_frame*,uint16_t*,unsigned,unsigned,unsigned,scene_workspace*,int);
bool scene_reference(const scene_frame*,ksn_mesh_snapshot*);
size_t scene_constant_bytes(void);size_t scene_pose_fixture_bytes(void);
#endif
