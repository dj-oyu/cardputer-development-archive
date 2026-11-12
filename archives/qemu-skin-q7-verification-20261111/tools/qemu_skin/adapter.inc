#include "assets.h"
#include "pocket_app_load.h"
#include "app_chunks.h"
#ifdef ESP_PLATFORM
#include "esp_heap_caps.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
/* The default QJS allocator reports usable_size=0 on ESP. Match the
 * production guest's internal, uncached fallback using the IDF size API. */
static void *scene_malloc(void *u,size_t n){(void)u;return n?heap_caps_malloc(n,MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT):NULL;}
static void *scene_calloc(void *u,size_t n,size_t z){if(n&&z>SIZE_MAX/n)return NULL;void *p=scene_malloc(u,n*z);if(p)memset(p,0,n*z);return p;}
static void scene_free(void *u,void *p){(void)u;heap_caps_free(p);}
static void *scene_realloc(void *u,void *p,size_t n){if(!p)return scene_malloc(u,n);if(!n){scene_free(u,p);return NULL;}return heap_caps_realloc(p,n,MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT);}
static size_t scene_usable(const void *p){return p?heap_caps_get_allocated_size((void *)p):0;}
static const JSMallocFunctions SCENE_ALLOC={.js_malloc=scene_malloc,.js_calloc=scene_calloc,.js_realloc=scene_realloc,.js_free=scene_free,.js_malloc_usable_size=scene_usable};
#define scene_new_runtime() JS_NewRuntime2(&SCENE_ALLOC,NULL)

#else
#include <time.h>
#define scene_new_runtime() JS_NewRuntime()
int64_t esp_timer_get_time(void){struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);return (int64_t)t.tv_sec*1000000+t.tv_nsec/1000;}
#endif
static void scene_heap(const char *phase){
#ifdef ESP_PLATFORM
printf("QSCENE_HEAP phase=%s free=%zu largest=%zu minimum=%zu\n",phase,heap_caps_get_free_size(MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT),heap_caps_get_largest_free_block(MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT),heap_caps_get_minimum_free_size(MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT));
#else
printf("QSCENE_HEAP phase=%s host_not_target=1\n",phase);
#endif
}
static const app_chunk_t chunks[]={
{.name="native-scene",.file="ayatsuri_model.js",.start=(const char *)model_js,.end=(const char *)model_js+sizeof model_js},
{.name="motion",.file="ayatsuri_motion.js",.start=(const char *)motion_js,.end=(const char *)motion_js+sizeof motion_js}};
static const app_chunk_set_t chunk_set={.app_id="local.meshbench",.chunks=chunks,.count=2};
const app_chunk_set_t *app_chunks_for(const char *id){return !strcmp(id,"local.meshbench")?&chunk_set:NULL;}
static void eval(JSContext *c,const char *s){JSValue v=JS_Eval(c,s,strlen(s),"scene-embedded",JS_EVAL_TYPE_GLOBAL);if(JS_IsException(v)){JSValue e=JS_GetException(c);const char *m=JS_ToCString(c,e);printf("QSCENE_ERROR %s\n",m?m:"exception");abort();}JS_FreeValue(c,v);pocket_kasane_end_turn();}
static uint32_t reference_hash;
static uint32_t frame_hash(void){uint32_t h=2166136261u;for(unsigned i=0;i<240*135;i++){h^=panel[i];h*=16777619u;}return h;}
static void capture(unsigned frame,double time){
printf("QSCENE_FRAME index=%u time=%.17g hash=%08lx width=240 height=135 format=rgb565le\n",frame,time,(unsigned long)frame_hash());
if(frame!=0&&frame!=2&&frame!=4)return;
for(unsigned y=0;y<135;y++){printf("QSCENE_ROW frame=%u y=%u data=",frame,y);for(unsigned x=0;x<240;x++){uint16_t v=panel[y*240+x];printf("%02x%02x",v&255,v>>8);}putchar('\n');}
}
