/* Synthetic boundary test. Source inserts are verbatim from native caller and
 * arena owner; real visibility v3 builder is included. No model asset, renderer,
 * device, snapshot codec, or frame runs. Synthetic snapshot is memcpy-owned. */
#include <assert.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
typedef struct {void *p; size_t n; int model;} Allocation;
static Allocation slots[64];
static unsigned live, model_live, dispose_calls, model_frees, build_attempts;
static unsigned fail_at, dispose_failure, exports, build_entered;
static const char *reason;
static void *alloc(size_t n,int is_model){
 void *p=malloc(n);assert(p);memset(p,0x39,n);
 for(unsigned i=0;i<64;i++)if(!slots[i].p){slots[i]=(Allocation){p,n,is_model};live++;model_live+=is_model;return p;}abort();
}
static void tracked_free(void *p){if(!p)return;
 for(unsigned i=0;i<64;i++)if(slots[i].p==p){
  if(slots[i].model){model_live--;model_frees++;}
  volatile unsigned char *q=p;for(size_t j=0;j<slots[i].n;j++)q[j]=0xa5;
  slots[i]=(Allocation){0};live--;free(p);return;
 }abort();
}
static void *build_malloc(size_t n){assert(!model_live);build_entered=1;if(++build_attempts==fail_at)return NULL;return alloc(n,0);}
static void *build_calloc(size_t n,size_t z){void*p=build_malloc(n*z);if(p)memset(p,0,n*z);return p;}
#define malloc build_malloc
#define calloc build_calloc
#define free tracked_free
#include "/workspace/scratch/6d8dcdbcdc54/fox-v3-visibility-lifetime-reduction/private-build/visibility/visibility.c"
#undef malloc
#undef calloc
#undef free

typedef struct {void *data;size_t bytes;} NodeStorage;
typedef struct {void *metadata;size_t metadata_bytes,node_count,payload_bytes;NodeStorage slots[];} model_arena_owner;
static void model_arena_owner_release(model_arena_owner **owned,void (*release)(void *)){
 if(!owned||!*owned)return;
 model_arena_owner *o=*owned;*owned=NULL;
 for(size_t j=0;j<o->node_count;j++)if(o->slots[j].data){memset(o->slots[j].data,0xa5,o->slots[j].bytes);release(o->slots[j].data);}
 if(o->metadata){memset(o->metadata,0xa5,o->metadata_bytes);release(o->metadata);}
 release(o);
}
static int ayatsuri_model_instance_dispose(int *ins,int *owner,int gen){
 (void)ins;(void)owner;assert(gen==1);assert(model_live==4);assert(++dispose_calls==1);return dispose_failure;
}
static unsigned long long ns(void){return 1;}
static int fail(const char*s){reason=s;return 2;}
static model_arena_owner *saved_arena;
static unsigned char snapshot[16],expected[16];
static int run_boundary(int before,int visible){
 int ins=0,owner=0;size_t bytes=16;
 uint8_t *data=alloc(bytes,1);memset(data,0x71,bytes);
 model_arena_owner *arena=alloc(sizeof(*arena)+sizeof(NodeStorage),1);
 arena->node_count=1;arena->metadata_bytes=16;arena->metadata=alloc(16,1);
 arena->slots[0].bytes=16;arena->slots[0].data=alloc(16,1);saved_arena=arena;
 memcpy(snapshot,arena->slots[0].data,16);memcpy(expected,snapshot,16);
 vis_scene *occluders=NULL;size_t nv=3,nt=1,occluder_vertices=before?4:3,occluder_triangles=1;
 double *xyz=alloc(9*sizeof(double),0);uint32_t *tri=alloc(3*sizeof(uint32_t),0);
 const double points[9]={0,0,0,1,0,0,0,1,0};const uint32_t indices[3]={0,1,2};
 memcpy(xyz,points,sizeof points);memcpy(tri,indices,sizeof indices);
 void *attributes=alloc(16,0),*attribute_triangles=alloc(16,0);
 vis_generation generation={1,1,1};unsigned long long build_ns=0,begin=0;
#define free tracked_free
 if(visible){
   if(nv!=occluder_vertices||nt!=occluder_triangles){free(xyz);free(tri);free(attributes);free(attribute_triangles);return fail("geometry-count-final");}
   if(ayatsuri_model_instance_dispose(&ins,&owner,1)){free(xyz);free(tri);free(attributes);free(attribute_triangles);return fail("dispose");}
  model_arena_owner_release(&arena,free);memset(data,0xa5,(size_t)bytes);free(data);data=NULL;
  vis_status status=vis_scene_build(&occluders,xyz,nv,tri,nt,generation,(vis_limits){2048,4095,524288});memset(xyz,0xa5,nv*3*sizeof(double));memset(tri,0xa5,nt*3*sizeof(uint32_t));free(xyz);free(tri);if(status!=VIS_OK){free(attributes);free(attribute_triangles);return fail("bvh-build");}build_ns=ns()-begin;
 }else{free(xyz);free(tri);}
  if(arena){if(ayatsuri_model_instance_dispose(&ins,&owner,1))return fail("dispose");model_arena_owner_release(&arena,free);memset(data,0xa5,(size_t)bytes);free(data);data=NULL;}
#undef free
 assert(!arena&&!data&&!model_live&&dispose_calls==1&&model_frees==4);
 assert(memcmp(snapshot,expected,sizeof snapshot)==0);
 /* Surrogate publication gate only; actual output is pinned by source checks. */
 exports++;
 tracked_free(attributes);tracked_free(attribute_triangles);
 if(occluders){assert(vis_scene_triangle_count(occluders)==1);vis_scene_release(occluders);}
 (void)build_ns;return 0;
}
static void cleanup_fixture(void){for(unsigned i=0;i<64;i++)if(slots[i].p)tracked_free(slots[i].p);assert(!live&&!model_live);}
static void reset(void){assert(!live);dispose_calls=model_frees=build_attempts=exports=build_entered=0;reason=NULL;}
int main(void){
 reset();assert(run_boundary(1,1)==2);assert(!strcmp(reason,"geometry-count-final"));assert(!dispose_calls&&!build_entered&&!exports&&model_live==4);cleanup_fixture();
 reset();dispose_failure=1;assert(run_boundary(0,1)==2);assert(!strcmp(reason,"dispose"));assert(dispose_calls==1&&!model_frees&&!build_entered&&!exports&&model_live==4);cleanup_fixture();dispose_failure=0;
 for(fail_at=1;fail_at<=5;fail_at++){
  reset();assert(run_boundary(0,1)==2);assert(!strcmp(reason,"bvh-build"));assert(dispose_calls==1&&model_frees==4&&build_entered&&!exports&&!live);assert(!memcmp(snapshot,expected,16));
 }
 fail_at=0;reset();assert(run_boundary(0,1)==0);assert(exports==1&&build_attempts==5&&!live);
 reset();assert(run_boundary(0,0)==0);assert(exports==1&&!build_entered&&!live);
 /* Actual owner release must also be null-safe without another free. */
 model_arena_owner *empty=NULL;model_arena_owner_release(&empty,tracked_free);assert(!live);
 puts("PASS: before-release count rejection; dispose rejection; 5 real builder allocation failures; success; fallback; poison/owned-copy; single release; publication gate");return 0;
}
