#include <time.h>
unsigned long budget_fragments,budget_passes,budget_triangles,budget_batches;
#include "alpha_raster.h"
#include "composite.h"
#include "eye_runtime.h"
#include "bridge.h"
#include "embedded_js.h"
#include "reference_controls.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <inttypes.h>
#ifdef ESP_PLATFORM
#include "esp_heap_caps.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#endif
static scene_frame frame;
static scene_workspace workspace;
static fox_composite_workspace composite;
static uint16_t rows[960];
static const fox_eye_snapshot *current;
#define snapshot (*current)
static unsigned requested_sample=99,requested_visit=9;
static uint32_t last_hash;
static unsigned calls,fractional,max_layers;
static bool surface(void*u,const fox_fragment*f,float rgb[3],float *alpha){
 const fox_eye_snapshot *s=u;calls++;
 if(s->hidden[f->object]){*alpha=0;rgb[0]=rgb[1]=rgb[2]=0;return true;}
 bool ok=fox_eye_snapshot_surface(s,f->material,f->local[0],f->local[1],f->local[2],rgb,alpha);
 if(ok&&*alpha>0&&*alpha<1)fractional++;return ok;
}
static void mem(const char*p){
#ifdef ESP_PLATFORM
 printf("FOX_EYE_HEAP phase=%s free=%u largest=%u minimum=%u stack_hwm=%u\n",p,(unsigned)heap_caps_get_free_size(MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT),(unsigned)heap_caps_get_largest_free_block(MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT),(unsigned)heap_caps_get_minimum_free_size(MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT),(unsigned)uxTaskGetStackHighWaterMark(NULL));
#else
 (void)p;
#endif
}
/* adapter added once native control bridge is frozen */
static JSContext *ctx;
static void eval(const char *s,const char *name){JSValue v=JS_Eval(ctx,s,strlen(s),name,JS_EVAL_TYPE_GLOBAL);if(JS_IsException(v)){JSValue e=JS_GetException(ctx);const char *m=JS_ToCString(ctx,e);printf("FOX_EYE_ERROR %s: %s\n",name,m?m:"exception");JS_FreeCString(ctx,m);JS_FreeValue(ctx,e);assert(0);}JS_FreeValue(ctx,v);}
static void accept_controls(const FoxEyeControls *c){char script[700];snprintf(script,sizeof script,"ref.update({\"Blink Both\":%.9g,\"Blink -X\":%.9g,\"Blink +X\":%.9g,\"Gaze X\":%.9g,\"Gaze Up\":%.9g,\"Eye Style\":%.9g,\"Show Highlights\":%.9g,\"Environment Reflection\":%.9g,\"Bubble Pressure\":%.9g})",c->blink_both,c->blink_neg,c->blink_pos,c->gaze_x,c->gaze_up,c->eye_style,c->show_highlights,c->environment_reflection,c->bubble_pressure);eval(script,"reference-controls");}
static uint32_t render(unsigned sample,unsigned visit,bool capture){
 scene_times t;calls=fractional=max_layers=0; budget_fragments=budget_passes=budget_triangles=budget_batches=0; clock_t budget_start=clock();
 assert(fox_scene_prepare_local(NULL,&frame,&workspace,-1,3,-1,&t,snapshot.local));
 assert(fox_scene_composite_preflight(&frame,&workspace,snapshot.local,surface,(void*)current,16,&composite));
 uint32_t hash=2166136261u;
 for(unsigned y=0;y<135;y+=4){unsigned h=135-y<4?135-y:4;memset(rows,0,sizeof rows);
 assert(fox_scene_composite(&frame,rows,y,h,30,&workspace,snapshot.local,surface,(void*)current,16,&composite));
 if(composite.max_observed_layers>max_layers)max_layers=composite.max_observed_layers;
 for(unsigned r=0;r<h;r++){if(capture)printf("FOX_EYE_ROW sample=%u view=3 y=%u ",sample,y+r);
 for(unsigned x=0;x<240;x++){uint16_t c=rows[r*240+x];hash=(hash^c)*16777619u;if(capture)printf("%02x%02x",c&255,c>>8);}if(capture)putchar('\n');}
#ifdef ESP_PLATFORM
 if(visit==2&&y==64)vTaskDelay(pdMS_TO_TICKS(10));
#endif
 }
 printf("BUDGET sample=%u visit=%u passes=%lu fragments=%lu triangle_visits=%lu batches=%lu host_cpu_ms=%.3f\n",sample,visit,budget_passes,budget_fragments,budget_triangles,budget_batches,1000.0*(clock()-budget_start)/CLOCKS_PER_SEC);
 printf("FOX_EYE_FRAME visit=%u sample=%u view=3 hash=%08"PRIx32" calls=%u fractional=%u max_layers=%u\n",visit,sample,hash,calls,fractional,max_layers);return hash;
}
bool fox_bridge_render(const fox_eye_snapshot *s,uint32_t *hash){current=s;*hash=last_hash=render(requested_sample,requested_visit,requested_visit==0);return true;}
static void run(void){
 JSRuntime *rt=JS_NewRuntime();assert(rt);JS_SetMaxStackSize(rt,16000);ctx=JS_NewContext(rt);assert(ctx);assert(fox_bridge_install(ctx)>=0);eval(js_motion,"ayatsuri_motion.js");eval(js_controls,"fox_controls.js");eval("globalThis.ref=FoxControls.create(foxNativeCommit)","init");
 mem("before");printf("FOX_EYE_MEMORY frame=%zu workspace=%zu rows=%zu composite=%zu snapshot=%zu\n",sizeof frame,sizeof workspace,sizeof rows,sizeof composite,sizeof snapshot);
 uint32_t hashes[19];
 for(unsigned visit=0;visit<3;visit++)for(unsigned i=0;i<19;i++){
 unsigned id=visit==1?18-i:i;FoxEyeControls c={0,0,0,0,0,0,1,.5f,0};
 if(id<13){const fox_eye_fixture_control*f=&fox_eye_fixture_controls[id];c=(FoxEyeControls){f->both,f->minus,f->plus,f->gaze_x,f->gaze_up,f->eye_style,f->highlights,f->reflection,f->bubble};}
 else{float q=(id-12)/7.0f;c.blink_both=q;c.blink_neg=q*.3f;c.blink_pos=fminf(1,q+.12f);c.gaze_x=2*q-1;c.gaze_up=1-2*q;c.environment_reflection=q;c.bubble_pressure=2*q-1;}
 requested_sample=id;requested_visit=visit;accept_controls(&c);uint32_t h=last_hash;if(!visit)hashes[id]=h;else assert(hashes[id]==h);
 }
 requested_sample=99;requested_visit=9;eval(js_scenario,"scenario.js");mem("after");JS_FreeContext(ctx);JS_FreeRuntime(rt);mem("released");puts("FOX_EYE_QEMU_DONE frames=57 captures=19 reverse_repeat_pause_pass");
}
#ifdef ESP_PLATFORM
void app_main(void){run();for(;;)vTaskDelay(pdMS_TO_TICKS(1000));}
#else
int main(void){run();return 0;}
#endif
