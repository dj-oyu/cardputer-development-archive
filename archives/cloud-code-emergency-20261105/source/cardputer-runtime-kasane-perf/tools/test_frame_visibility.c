/* Characterize the real Kasane/QuickJS boundary before enabling direct
 * source-frame entry. This test calls no allocation-failure or IO-failure
 * suite from the shared fixture. A passing test documents a remaining hazard;
 * it does not certify that an interrupted frame is atomically displayed. */
#define main kasane_fixture_unused_main
#include "test_pocket_kasane.c"
#undef main
#include "quickjs-vm.h"
#include "pocket_proc.h"

/* These independent image producers are not used by this fixture. Keep the
 * procedural producer, adapter, core and renderer real. */
esp_err_t pocket_grid_install(JSContext *c,JSValueConst k){(void)c;(void)k;return ESP_OK;}
void pocket_grid_reset(void){}
bool pocket_grid_pending(void){return false;}
void pocket_grid_present_result(ksn_result r){(void)r;}
void pocket_grid_source_invalidated(uint32_t id){(void)id;}
esp_err_t pocket_video_install(JSContext *c,JSValueConst k){(void)c;(void)k;return ESP_OK;}
void pocket_video_reset(void){}
bool pocket_video_pending(void){return false;}
void pocket_video_present_result(ksn_result r){(void)r;}
esp_err_t pocket_pixel_install(JSContext *c,JSValueConst k){(void)c;(void)k;return ESP_OK;}
void pocket_pixel_reset(void){}
bool pocket_pixel_pending(void){return false;}
void pocket_pixel_present_result(ksn_result r){(void)r;}

static JSValue visibility_request_yield(JSContext *context, JSValueConst self,
                                        int argc, JSValueConst *argv) {
    (void)self; (void)argc; (void)argv;
    JS_VMRequestYield(JS_GetRuntime(context));
    return JS_UNDEFINED;
}

static bool visibility_call(bool resume) {
    JSValue value;
    if (resume) value=JS_VMResume(ctx);
    else {
        JSValue global=JS_GetGlobalObject(ctx);
        JSValue frame=JS_GetPropertyStr(ctx,global,"frame");
        value=JS_VMCall(ctx,frame,global,0,NULL);
        JS_FreeValue(ctx,frame); JS_FreeValue(ctx,global);
    }
    /* JS_EXCEPTION is also the parked-call sentinel; it is not an exception
     * to consume until the VM has closed the suspended chain. */
    bool ok=JS_VMSuspended(rt)||!JS_IsException(value);
    if(!ok) {
        JSValue error=JS_GetException(ctx);
        const char *text=JS_ToCString(ctx,error);
        fprintf(stderr,"frame visibility: %s\n",text?text:"exception");
        if(text)JS_FreeCString(ctx,text);
        JS_FreeValue(ctx,error);
    }
    JS_FreeValue(ctx,value);
    return ok;
}

static void visibility_case(bool wrapped, bool before_commit) {
    host_capabilities_clear();
    rt=JS_NewRuntime(); ctx=JS_NewContext(rt);
    check(ctx&&pocket_kasane_install(ctx,NULL)==ESP_OK,"visibility namespace");
    JSValue global=JS_GetGlobalObject(ctx);
    check(JS_SetPropertyStr(ctx,global,"requestYield",
          JS_NewCFunction(ctx,visibility_request_yield,"requestYield",0))>=0,
          "visibility yield function");
    JS_FreeValue(ctx,global);
    check(run("globalThis.P=kasane.procedural;"
              "globalThis.image=P.resource();P.beginFrame(0);P.commit();"
              "kasane.replace(tx=>{tx.background(0x000000ff);"
              "tx.image({bounds:[0,0,240,135],resource:image});"
              "globalThis.badge=tx.rect({bounds:[10,10,30,30],color:0xff0000ff});});"),
          "visibility old image and badge");
    ksn_render_stats stats;
    check(present(&stats)==KSN_OK,"visibility initial display");
    check(panel_pixels[0]==0&&panel_pixels[15*240+15]==0xf800,
          "visibility old picture pixels");
    check(run(before_commit?
        "globalThis.frame=()=>{P.beginFrame(0x001f);requestYield();"
        "for(let i=0;i<2;i++){}P.commit();"
        "kasane.patch(tx=>badge.setColor(tx,0x00ff00ff));};":
        "globalThis.frame=()=>{P.beginFrame(0x001f);P.commit();requestYield();"
        "for(let i=0;i<2;i++){}kasane.patch(tx=>badge.setColor(tx,0x00ff00ff));};"),
        "visibility test frame");
    if(wrapped) check(run("(function(){const f=frame;globalThis.frame=function(){"
                         "return f.apply(this,arguments)}})();"),
                      "visibility production-style apply wrapper");
    check(visibility_call(false),"visibility first frame call");
    bool parked=JS_VMSuspended(rt);
    if(wrapped)check(!parked,"legacy apply control does not park inside the frame");
    if(!wrapped) {
        check(parked,"direct entry parks inside frame body");
        pocket_kasane_park_turn();
        check(present(&stats)==KSN_OK,"visibility between turns");
        if(before_commit) {
            check(panel_pixels[0]==0&&panel_pixels[15*240+15]==0xf800,
                  "uncommitted procedural candidate stays invisible");
        } else {
            check(panel_pixels[0]==0x001f&&panel_pixels[15*240+15]==0xf800,
                  "KNOWN HAZARD: committed new image is combined with old badge");
        }
    }
    unsigned resumes=0;
    while(JS_VMSuspended(rt)) {
        check(++resumes<8,"bounded visibility resumes");
        if(resumes>=8)break;
        check(visibility_call(true),"visibility resume");
    }
    pocket_kasane_end_turn();
    check(present(&stats)==KSN_OK,"visibility completed display");
    check(panel_pixels[0]==0x001f&&panel_pixels[15*240+15]==0x07e0,
          "completed frame combines new image and new badge");
    printf("FRAME_VISIBILITY wrapped=%u before_commit=%u parks=%u resumes=%u\n",
           wrapped,before_commit,parked,resumes);
    check(pocket_kasane_reset(),"visibility session reset");
    JS_FreeContext(ctx); JS_FreeRuntime(rt);
    ctx=NULL; rt=NULL;
}

int main(void) {
    visibility_case(false,true);
    visibility_case(false,false);
    visibility_case(true,false);
    printf("FRAME_VISIBILITY %s: mixed-generation hazard %s; direct source entry remains gated\n",
           failures?"FAIL":"PASS",failures?"not established":"reproduced");
    return failures?1:0;
}
