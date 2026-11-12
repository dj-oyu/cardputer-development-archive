/* Real public app, QuickJS and Kasane compositor. Host cycles are protocol stubs. */
#include "pocket_kasane.h"
#include "pocket_shiki_frame.h"
#include "pocket_shape.h"
#include "pocket_shiki_api.h"
#include "app_registry.h"
#include "shiki_heap.h"
#include "ksn_render.h"
#include "ksn_mesh_depth.h"
#include "ksn_font.h"
#ifdef KSN_MESH_Q7_CERTIFIED_PROTOTYPE
#include "ksn_mesh_q7_certified.h"
extern const ksn_mesh_q7_snapshot *pocket_proc_q7_host_snapshot(unsigned,bool);
extern void pocket_proc_q7_bench_stats(ksn_mesh_q7_stats *);
#endif
#include "pocket_av.h"
#include "system/sys_device.h"
#include "sound.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef ESP_PLATFORM
#include "host_requested_alloc.h"
#else
static size_t live_bytes,peak_bytes,live_blocks,alloc_calls;
#endif

#define CHECK(x) do{if(!(x)){fprintf(stderr,"%s:%d %s\n",__FILE__,__LINE__,#x);exit(1);}}while(0)
void host_capabilities_clear(void);
int32_t pocket_av_ui_current_player(void){return 0;}
bool pocket_av_ui_read(int32_t id,pocket_av_ui_snapshot *o){(void)id;(void)o;return false;}
bool sys_device_clock_read(sys_clock_state *o){(void)o;return false;}
void sound_stream_set_observer(sound_stream_observer_fn o){(void)o;}
void sound_stream_set_observer_interval(sound_stream_observer_fn o,uint32_t n){(void)o;(void)n;}
static uint16_t strip[240*8],panel[240*135];
static unsigned strip_rows,half,presents;
static bool fail_send;
static bool delayed,dma_pending,dma_candidate;
static const uint16_t *dma_loan;
static uint16_t dma_saved[240*8],dma_y,dma_rows;
static unsigned dma_finishes;

static void dma_flush(void){
 if(!dma_pending)return;
 CHECK(!memcmp(dma_loan,dma_saved,(size_t)dma_rows*240*2));
 memcpy(panel+dma_y*240,dma_loan,(size_t)dma_rows*240*2);dma_pending=false;
}
static uint16_t *get_strip(void *u){(void)u;uint16_t *p=strip+(strip_rows==4?(half++&1u)*960u:0);CHECK(!delayed||strip_rows!=4||!dma_pending||p!=dma_loan);for(unsigned i=0;i<strip_rows*240;i++)p[i]=0xdead;return p;}
static ksn_result send_strip(void *u,uint16_t y,uint16_t rows,const uint16_t *p){
 (void)u;
 if(delayed){dma_flush();memcpy(dma_saved,p,(size_t)rows*240*2);dma_loan=strip_rows==4?p:dma_saved;dma_y=y;dma_rows=rows;dma_pending=true;}
 else memcpy(panel+y*240,p,(size_t)rows*240*2);
 if(fail_send){fail_send=false;return KSN_IO;}return KSN_OK;
}
static ksn_result dma_finish(void *u){(void)u;if(dma_candidate)CHECK(pocket_proc_pending());dma_flush();dma_finishes++;return KSN_OK;}
static ksn_result present(void){ksn_display_port p={.strip=get_strip,.present=send_strip,.width=240,.height=135,.strip_rows=strip_rows,.text=&ksn_font_port};ksn_render_stats s;presents++;dma_candidate=pocket_proc_pending();const ksn_display_completion completion={NULL,dma_finish};ksn_result result=delayed?pocket_kasane_present_complete(&p,&completion,&s):pocket_kasane_present(&p,&s);CHECK(!dma_pending);dma_candidate=false;return result;}
#include "assets.h"


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
static void eval(JSContext *c,const char *s){JSValue v=JS_Eval(c,s,strlen(s),"scene-embedded",JS_EVAL_TYPE_GLOBAL);if(JS_IsException(v)){JSValue e=JS_GetException(c);const char *m=JS_ToCString(c,e);printf("QSCENE_ERROR %s\n",m?m:"exception");abort();}JS_FreeValue(c,v);pocket_kasane_end_turn();}
static uint32_t reference_hash;
static uint32_t frame_hash(void){uint32_t h=2166136261u;for(unsigned i=0;i<240*135;i++){h^=panel[i];h*=16777619u;}return h;}
static void capture(unsigned frame,double time){
printf("QSCENE_FRAME index=%u time=%.17g hash=%08lx width=240 height=135 format=rgb565le\n",frame,time,(unsigned long)frame_hash());
if(frame!=0&&frame!=30&&frame!=60)return;
for(unsigned y=0;y<135;y++){printf("QSCENE_ROW frame=%u y=%u data=",frame,y);for(unsigned x=0;x<240;x++){uint16_t v=panel[y*240+x];printf("%02x%02x",v&255,v>>8);}putchar('\n');}
}
#include "ayatsuri/ayatsuri_model_skin.h"
static uint32_t isolated_hash;

static JSValue detach_buffer(JSContext *ctx,JSValueConst self,int argc,JSValueConst *argv){
    (void)self;CHECK(argc==1);JS_DetachArrayBuffer(ctx,argv[0]);return JS_UNDEFINED;
}
static JSValue freeze_buffer(JSContext *ctx,JSValueConst self,int argc,JSValueConst *argv){
    (void)ctx;(void)self;CHECK(argc==1&&JS_SetImmutableArrayBuffer(argv[0],true)==0);return JS_UNDEFINED;
}
static void foreign_free(JSRuntime *rt,void *opaque,void *data){(void)rt;(void)data;free(opaque);}
static void install_foreign(JSContext *ctx,const char *name,size_t n){
    uint8_t *p=malloc(n+1);CHECK(p);memset(p,0,n+1);
    JSValue b=JS_NewArrayBuffer(ctx,p+1,n,foreign_free,p,false);CHECK(!JS_IsException(b));
    JSValue g=JS_GetGlobalObject(ctx);CHECK(JS_SetPropertyStr(ctx,g,name,b)>=0);JS_FreeValue(ctx,g);
}
static uint8_t *load_fixture(const char *dir,const char *name,size_t *bytes){
    (void)dir;const uint8_t *src=plain_blob;size_t n=sizeof plain_blob;
    if(!strcmp(name,"holes")){src=holes_blob;n=sizeof holes_blob;}else if(!strcmp(name,"sided")){src=sided_blob;n=sizeof sided_blob;}
    uint8_t *p=malloc(n);CHECK(p);memcpy(p,src,n);*bytes=n;return p;
}
static void expose_fixture(JSContext *ctx,const char *dir,const char *variant,const char *name){
    size_t n;uint8_t *p=load_fixture(dir,variant,&n);JSValue g=JS_GetGlobalObject(ctx);
    CHECK(JS_SetPropertyStr(ctx,g,name,JS_NewArrayBufferCopy(ctx,p,n))>=0);JS_FreeValue(ctx,g);free(p);
}
static JSValue function(JSContext *ctx,const char *name){
    JSValue g=JS_GetGlobalObject(ctx),f=JS_GetPropertyStr(ctx,g,name);JS_FreeValue(ctx,g);CHECK(JS_IsFunction(ctx,f));return f;
}
static void call(JSContext *ctx,JSValueConst fn,JSValueConst arg){
    JSValue value=JS_Call(ctx,fn,JS_UNDEFINED,1,&arg);
    if(JS_IsException(value)){JSValue e=JS_GetException(ctx);const char *s=JS_ToCString(ctx,e);fprintf(stderr,"call: %s\n",s?s:"exception");CHECK(0);}
    JS_FreeValue(ctx,value);pocket_kasane_end_turn();
}
static void copy_floats(JSContext *ctx,const char *name,void *out,size_t n){
    JSValue g=JS_GetGlobalObject(ctx),v=JS_GetPropertyStr(ctx,g,name);JS_FreeValue(ctx,g);
    size_t offset,bytes,per,size;JSValue ab=JS_GetTypedArrayBuffer(ctx,v,&offset,&bytes,&per);
    uint8_t *p=JS_GetArrayBuffer(ctx,&size,ab);CHECK(p&&bytes==n&&offset<=size&&bytes<=size-offset);memcpy(out,p+offset,n);
    JS_FreeValue(ctx,ab);JS_FreeValue(ctx,v);
}
static void raster_oracle(ayatsuri_model_instance *actor,const void *owner){
    uint8_t bytes[2048];float scratch[240];ksn_mesh_snapshot s={.packets={bytes,sizeof bytes,0,0},.enabled=true,.work_limit=200000};
    uint32_t cursor=0;ayatsuri_model_packet packet;ayatsuri_model_status status;
    while((status=ayatsuri_model_instance_next(actor,owner,1,&cursor,&packet))==AYATSURI_MODEL_OK){
        ayatsuri_model_mesh_view v;CHECK(packet.kind==4&&ayatsuri_model_instance_mesh_view(actor,owner,1,packet.node_id,&v)==AYATSURI_MODEL_OK);
        CHECK(ksn_mesh_append(&s,v.patch,v.depth,v.node_id));
    }
    CHECK(status==AYATSURI_MODEL_DONE);reference_hash=2166136261u;uint16_t row[240];
    for(unsigned y=0;y<135;y++){for(unsigned x=0;x<240;x++)row[x]=17;
    CHECK(ksn_mesh_render(&s,row,y,1,scratch,1));for(unsigned x=0;x<240;x++){reference_hash^=row[x];reference_hash*=16777619u;}}
}
static void second_oracle(ayatsuri_model_instance *actor,const void *owner){
    const ayatsuri_skin_result v[4]={{{-27,-20,9},{0,0,1}},{{43,-20,9},{0,0,1}},{{43,20,9},{0,0,1}},{{-27,20,9},{0,0,1}}};
    const float c[9]={0,0,400,0,0,0,1,120,67},l[6]={0,0,1,1,1,1};const ayatsuri_model_mesh_geometry g={2,4,v};
    CHECK(ayatsuri_model_instance_evaluate_meshes(actor,owner,1,c,l,&g,1)==AYATSURI_MODEL_OK);raster_oracle(actor,owner);
}
static void oracle(JSContext *ctx,ayatsuri_model_instance *actor,const void *owner){
    ayatsuri_transform g[2],bind[2],palette[2];ayatsuri_skin_vertex input[6]={0};ayatsuri_skin_result result[6];
    copy_floats(ctx,"skinGlobals",g,sizeof g);copy_floats(ctx,"skinInverseBind",bind,sizeof bind);
    for(unsigned v=0;v<6;++v){
        input[v].position[0]=(float)((int)(v%3)*30-30);input[v].position[1]=v<3?-15:15;input[v].normal[2]=1;
        input[v].joints[1]=1;input[v].weights[1]=(uint16_t)(v%3==0?0:v%3==1?21845:65535);input[v].weights[0]=(uint16_t)(65535-input[v].weights[1]);
    }
    CHECK(ayatsuri_skin_palette(g,bind,2,palette)==AYATSURI_OK&&ayatsuri_skin_evaluate(palette,2,input,6,result)==AYATSURI_OK);
    const float c[9]={0,0,400,0,0,0,1,120,67},l[6]={0,0,1,1,1,1};const ayatsuri_model_mesh_geometry geometry={1,6,result};
    CHECK(ayatsuri_model_instance_evaluate_meshes(actor,owner,1,c,l,&geometry,1)==AYATSURI_MODEL_OK);
    raster_oracle(actor,owner);
}
static void oom(JSRuntime *rt,JSContext *ctx){
    JSValue attempt=function(ctx,"attemptSkin"),fresh=function(ctx,"freshB"),dispose=function(ctx,"disposeB"),inspect=function(ctx,"inspectB");
    unsigned failures=0,successes=0;
    eval(ctx,"disposeB()");
    for(unsigned spare=0;spare<=1024;spare+=32){
        call(ctx,fresh,JS_UNDEFINED);JS_RunGC(rt);size_t used,limit;JS_GetMemoryCounters(rt,&used,&limit);(void)limit;
        JS_SetMemoryLimit(rt,used+spare);JSValue result=JS_Call(ctx,attempt,JS_UNDEFINED,0,NULL);
        JS_SetMemoryLimit(rt,160*1024);const bool ok=!JS_IsException(result);
        if(!ok){JSValue e=JS_GetException(ctx);JS_FreeValue(ctx,e);failures++;}else successes++;
        JS_FreeValue(ctx,result);call(ctx,inspect,JS_NewBool(ctx,ok));call(ctx,dispose,JS_UNDEFINED);
        eval(ctx,"M.stats(modelStats);check(modelStats.instances===1)");
    }
    CHECK(failures&&successes);call(ctx,fresh,JS_UNDEFINED);
    JS_FreeValue(ctx,attempt);JS_FreeValue(ctx,fresh);JS_FreeValue(ctx,dispose);JS_FreeValue(ctx,inspect);
    eval(ctx,"inspectA(480)");JSValue grow=function(ctx,"attemptGrowth");JS_RunGC(rt);size_t used,limit;JS_GetMemoryCounters(rt,&used,&limit);
    JS_SetMemoryLimit(rt,used);JSValue result=JS_Call(ctx,grow,JS_UNDEFINED,0,NULL);JS_SetMemoryLimit(rt,160*1024);CHECK(JS_IsException(result));
    JSValue e=JS_GetException(ctx);JS_FreeValue(ctx,e);JS_FreeValue(ctx,result);eval(ctx,"inspectA(480)");
    call(ctx,grow,JS_UNDEFINED);eval(ctx,"inspectA(576)");JS_FreeValue(ctx,grow);
    printf("SKIN_JS_OOM_PASS initial_failures=%u successes=%u initial_ready_preserved growth480_preserved recovery576 instances_stable\n",failures,successes);
}
#ifndef SKIN_JS_MAIN
#define SKIN_JS_MAIN main
#endif
static int skin_run(int argc,char **argv){
    CHECK(argc==4);strip_rows=(unsigned)atoi(argv[1]);g_ksn_image_rows=atoi(argv[2]);delayed=true;CHECK(strip_rows==4||strip_rows==8);
    JSRuntime *rt=scene_new_runtime();CHECK(rt);JSContext *ctx=JS_NewContext(rt);CHECK(ctx&&JS_PocketHarden(ctx)==0);JS_SetMemoryLimit(rt,160*1024);
    host_capabilities_clear();CHECK(shiki_heap_begin(0));CHECK(pocket_kasane_install(ctx,NULL)==ESP_OK);CHECK(pocket_shape_install(ctx,NULL)==ESP_OK);
    JSValue g=JS_GetGlobalObject(ctx);CHECK(JS_SetPropertyStr(ctx,g,"detachBuffer",JS_NewCFunction(ctx,detach_buffer,"detachBuffer",1))>=0);
    CHECK(JS_SetPropertyStr(ctx,g,"freezeBuffer",JS_NewCFunction(ctx,freeze_buffer,"freezeBuffer",1))>=0);JS_FreeValue(ctx,g);
    install_foreign(ctx,"foreignJ",48);install_foreign(ctx,"foreignG",96);
    expose_fixture(ctx,argv[3],"plain","fixture");expose_fixture(ctx,argv[3],"holes","holes");expose_fixture(ctx,argv[3],"sided","sided");expose_fixture(ctx,argv[3],"plain","cycleFixture");
    eval(ctx,"globalThis.pocket={kasane,ayatsuri};globalThis.P=kasane.shiki;const resource=P.resource();kasane.replace(tx=>{tx.background(0x000011ff);tx.image({resource,bounds:[0,0,240,135],clip:[0,0,240,135],sourceWidth:240,sourceHeight:135});})");CHECK(present()==KSN_OK);
    eval(ctx,(const char *)scenario);eval(ctx,"setup()");scene_heap("setup");
    size_t blob_bytes;uint8_t *blob=load_fixture(argv[3],"plain",&blob_bytes);ayatsuri_model model;CHECK(ayatsuri_model_open(blob,blob_bytes,&model)==AYATSURI_MODEL_OK);
    size_t arena_bytes=ayatsuri_model_instance_bytes(&model);void *arena_owner=malloc(arena_bytes+7);CHECK(arena_owner);void *arena=(void *)(((uintptr_t)arena_owner+7)&~(uintptr_t)7);unsigned owner=0;ayatsuri_model_instance direct;
    CHECK(ayatsuri_model_instance_init(&model,arena,arena_bytes,&owner,1,&direct)==AYATSURI_MODEL_OK);
    JSValue evaluate=function(ctx,"evaluateOnly"),draw=function(ctx,"drawA"),tick_fn=function(ctx,"tick");
    call(ctx,evaluate,JS_NewInt32(ctx,0));eval(ctx,"inspectA(480)");size_t warm_evaluate=0,warm_submit=0,guest_peak=0;uint32_t hashes[120];
    for(unsigned visit=0;visit<240;++visit){
        unsigned frame=visit<120?visit:239-visit;size_t before=alloc_calls;
        call(ctx,evaluate,JS_NewInt32(ctx,(int)frame));warm_evaluate+=alloc_calls-before;
        oracle(ctx,&direct,&owner);before=alloc_calls;call(ctx,draw,JS_UNDEFINED);
        if(visit==37){fail_send=true;CHECK(present()==KSN_IO&&pocket_proc_pending());}
        CHECK(present()==KSN_OK&&!pocket_proc_pending()&&frame_hash()==reference_hash);warm_submit+=alloc_calls-before;
        uint32_t hash=2166136261u;for(unsigned j=0;j<240*135;++j)hash=(hash^panel[j])*16777619u;
        if(visit<120){hashes[frame]=hash;capture(frame,frame);}else CHECK(hash==hashes[frame]);
        size_t used,limit;JS_GetMemoryCounters(rt,&used,&limit);CHECK(limit==160*1024);if(used>guest_peak)guest_peak=used;
    }
    CHECK(!warm_evaluate&&hashes[0]!=hashes[30]);
    eval(ctx,"drawB()");CHECK(present()==KSN_OK);uint32_t rigid_hash=2166136261u;for(unsigned j=0;j<240*135;++j)rigid_hash=(rigid_hash^panel[j])*16777619u;CHECK(rigid_hash==hashes[0]);
    /* Both actors own separate skin work and cached packets. */
    call(ctx,tick_fn,JS_NewInt32(ctx,30));CHECK(present()==KSN_OK);isolated_hash=frame_hash();
    eval(ctx,"poseAt(60);B.evaluateSkin(C,L,1,G,IB,V,J,W);drawB()");oracle(ctx,&direct,&owner);
    CHECK(present()==KSN_OK&&frame_hash()==reference_hash&&frame_hash()!=isolated_hash);
    eval(ctx,"drawA()");CHECK(present()==KSN_OK&&frame_hash()==isolated_hash);
    eval(ctx,"B.evaluate(C,L)");
    /* JS backing arrays can change after evaluation, before any submission. */
    call(ctx,evaluate,JS_NewInt32(ctx,30));oracle(ctx,&direct,&owner);
    eval(ctx,"G[3]+=100;V[0]+=100;drawA()");CHECK(present()==KSN_OK&&frame_hash()==reference_hash);
    eval(ctx,"G[3]-=100;V[0]-=100;invalidInputs();drawA()");oracle(ctx,&direct,&owner);
    CHECK(present()==KSN_OK&&frame_hash()==reference_hash);
    scene_heap("before_oom");oom(rt,ctx);scene_heap("after_oom");call(ctx,tick_fn,JS_NewInt32(ctx,30));oracle(ctx,&direct,&owner);CHECK(present()==KSN_OK&&frame_hash()==reference_hash);
    eval(ctx,"inspectA(576);overrideSecond()");second_oracle(&direct,&owner);
    CHECK(present()==KSN_OK&&frame_hash()==reference_hash);
    call(ctx,tick_fn,JS_NewInt32(ctx,30));oracle(ctx,&direct,&owner);
    CHECK(present()==KSN_OK&&frame_hash()==reference_hash);eval(ctx,"inspectA(576)");
    puts("SKIN_JS_SCOPE_PASS smaller_reuses576 one_override_only different_node_restores_cold");
    eval(ctx,"A.evaluate(C,L);inspectA(576);drawA()");CHECK(present()==KSN_OK);uint32_t restored=2166136261u;for(unsigned j=0;j<240*135;++j)restored=(restored^panel[j])*16777619u;CHECK(restored==hashes[0]);
    eval(ctx,"closeModel()");call(ctx,evaluate,JS_NewInt32(ctx,30));oracle(ctx,&direct,&owner);
    CHECK(ayatsuri_model_instance_dispose(&direct,&owner,1)==AYATSURI_MODEL_OK);free(arena_owner);free(blob);
    eval(ctx,"pendingThenDispose()");JS_RunGC(rt);CHECK(pocket_proc_pending()&&present()==KSN_OK&&frame_hash()==reference_hash);
    eval(ctx,"implicitRelease();cycleModel.stats(modelStats);check(modelStats.instances===1);cycleModel=null");JS_RunGC(rt);
    pocket_proc_mesh_bytes memory;pocket_proc_mesh_memory(&memory);
    printf("SKIN_JS_MEMORY allocation_counters_host_only=1 oracle_arena_padding=7 rows=%u direct=%d frames=240 warm_evaluate_alloc=%zu submit_present_alloc=%zu guest_frame_peak=%zu requested_live=%zu requested_peak=%zu C_oracle_cold=%zu C_oracle_arena=%zu snapshot_capacity=%zu workspace=%zu\n",strip_rows,g_ksn_image_rows,warm_evaluate,warm_submit,guest_peak,live_bytes,peak_bytes,blob_bytes,arena_bytes,memory.candidate+memory.committed,memory.workspace);
    JS_FreeValue(ctx,evaluate);JS_FreeValue(ctx,draw);JS_FreeValue(ctx,tick_fn);
    pocket_shiki_api_reset();pocket_kasane_reset();JS_FreeContext(ctx);JS_FreeRuntime(rt);shiki_heap_end();host_capabilities_clear();CHECK(!live_bytes&&!live_blocks);
    puts("SKIN_JS_PASS strict_buffers invalid_atomic SAB_detached_alignment immutable_input busy_recovery independent_actor cold_restore IO_retry pending_source_disposal cyclic_GC host_ledger_or_target_heap");return 0;
}

#ifdef ESP_PLATFORM
void app_main(void){char *args[]={"qemu-skin","4","1","embedded"};puts("QSKIN_PROFILE scalar_no_PIE real_QuickJS single_skin hash_oracle no_hardware no_performance_claim");scene_heap("startup");skin_run(4,args);scene_heap("released_first");skin_run(4,args);scene_heap("released_second");puts("QSKIN_DONE");for(;;)vTaskDelay(pdMS_TO_TICKS(1000));}
#else
int main(int argc,char **argv){return skin_run(argc,argv);}
#endif
