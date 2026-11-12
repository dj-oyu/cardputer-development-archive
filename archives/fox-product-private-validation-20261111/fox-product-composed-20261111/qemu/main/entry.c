#include "bridge.h"
#include "embedded.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
static void eval(JSContext*c,const char*s){assert(fox_bridge_eval(c,s,strlen(s),"composed-qemu")>=0);}
void app_main(void){JSRuntime*r=JS_NewRuntime();assert(r);JS_SetMaxStackSize(r,16000);JSContext*c=JS_NewContext(r);assert(c);assert(JS_PocketHarden(c)>=0);assert(fox_bridge_install(c)>=0);eval(c,js0);eval(c,js1);eval(c,js2);eval(c,"globalThis.controls=FoxControls.create(privateModelBackend.commit);globalThis.motion=controls.motion([0,0,0,0,1000,1,1,-1],['time','Blink Both','Gaze X','Gaze Up'],{timeUnit:'ms',interpolation:'linear'});");for(unsigned i=0;i<9;i++){char s[128];snprintf(s,sizeof s,"privateModelBackend.testmode(%u);motion.evaluate(%u)",100+i,125*i);eval(c,s);}fox_composed_finish();JS_FreeContext(c);JS_FreeRuntime(r);puts("FOX_EYE_QEMU_DONE composed_frames=9");for(;;)vTaskDelay(pdMS_TO_TICKS(1000));}
