from pathlib import Path
import json
r=Path.cwd();p=r/'fox-product-composed-20261111';q=p/'qemu';(q/'main').mkdir(parents=True,exist_ok=True)
(q/'CMakeLists.txt').write_text((r/'fox-eye-runtime-qemu-20261111/CMakeLists.txt').read_text())
(q/'sdkconfig.defaults').write_text((r/'fox-eye-runtime-qemu-20261111/sdkconfig.defaults').read_text())
c=json.loads((p/'private/command-o2.json').read_text());src=[x for x in c if x.endswith('.c') and not x.endswith('/private/main.c')]+[str(q/'main/entry.c')];inc=[x[2:] for x in c if x.startswith('-I')]+[str(p/'private'),str(q/'main')]
(q/'main/CMakeLists.txt').write_text('idf_component_register(SRCS '+' '.join('"'+x+'"' for x in src)+' INCLUDE_DIRS '+' '.join('"'+x+'"' for x in inc)+' REQUIRES heap esp_driver_spi)\ntarget_compile_options(${COMPONENT_LIB} PRIVATE -ffp-contract=off -fno-fast-math -UNDEBUG -Wno-error -Wno-format)\ntarget_compile_definitions(${COMPONENT_LIB} PRIVATE QUICKJS_NG_BUILD QJS_DISABLE_DUMPS _GNU_SOURCE)\n')
js=[r/'qemu-render-20261111/apps/lib/ayatsuri_motion.js',p/'generic/ayatsuri_controls.js',p/'private/fox_controls.js']
(q/'main/embedded.h').write_text('\n'.join('static const char js%d[]=%s;'%(i,json.dumps(x.read_text())) for i,x in enumerate(js)))
(q/'main/entry.c').write_text('''#include "bridge.h"
#include "embedded.h"
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
static void eval(JSContext*c,const char*s){assert(fox_bridge_eval(c,s,strlen(s),"composed-qemu")>=0);}
void app_main(void){JSRuntime*r=JS_NewRuntime();assert(r);JS_SetMaxStackSize(r,16000);JSContext*c=JS_NewContext(r);assert(c);assert(JS_PocketHarden(c)>=0);assert(fox_bridge_install(c)>=0);eval(c,js0);eval(c,js1);eval(c,js2);eval(c,"globalThis.controls=FoxControls.create(privateModelBackend.commit);globalThis.motion=controls.motion([0,0,0,0,1000,1,1,-1],['time','Blink Both','Gaze X','Gaze Up'],{timeUnit:'ms',interpolation:'linear'});");for(unsigned i=0;i<9;i++){char s[128];snprintf(s,sizeof s,"privateModelBackend.testmode(%u);motion.evaluate(%u)",100+i,125*i);eval(c,s);}fox_composed_finish();JS_FreeContext(c);JS_FreeRuntime(r);puts("FOX_EYE_QEMU_DONE composed_frames=9");for(;;)vTaskDelay(pdMS_TO_TICKS(1000));}
''')
