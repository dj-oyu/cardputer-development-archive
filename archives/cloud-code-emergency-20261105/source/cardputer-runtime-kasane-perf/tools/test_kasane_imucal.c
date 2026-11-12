/* Run the real IMUCAL app with QuickJS and the real Kasane adapter/renderer.
 * Compare the old per-slot show() with the batched implementation after every
 * settled turn; sensor, storage and audio mocks only replace hardware.
 * The shared fixture's fault controls stay disabled throughout this test. */
#define main kasane_imucal_test_main
#include "test_pocket_kasane.c"
#undef main

/* IMUCAL does not use these image producers. Keep the view adapter, schema,
 * core and renderer real without pulling in SD video or grid assets. */
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

/* Keep the pre-batching implementation independent of the production show().
 * Everything else comes from the current app, so the comparison exercises the
 * same calibration state machine, async callbacks and real native view. */
static const char legacy_show[] =
    "  function show() {\n"
    "    if (got.length < 6) {\n"
    "      say('head', (got.length + 1) + '/6 ' + LABEL[got.length]);\n"
    "      say('foot', armed ? 'HOLD STILL. ESC QUITS' : 'MOVE TO NEXT');\n"
    "    }\n"
    "    if (!now) return;\n"
    "    var a = now.accel, g = now.gyro;\n"
    "    say('live', 'X' + mm(a.x) + ' Y' + mm(a.y) + ' Z' + mm(a.z));\n"
    "    say('stat', 'MAG' + mm(Math.sqrt(a.x * a.x + a.y * a.y + a.z * a.z)) +\n"
    "              (armed ? (still ? ' HOLD ' + (HOLD - still) : ' MOVING') : ' MOVE ON') +\n"
    "              ' DROP ' + now.dropped);\n"
    "    say('spin', g ? 'GYR ' + mm(g.x) + ' ' + mm(g.y) + ' ' + mm(g.z) : 'GYR OFF');\n"
    "  }\n";

static const char fixture[] =
    "globalThis.__logs=[];globalThis.console={log(m){__logs.push(String(m));}};"
    "globalThis.__store={};globalThis.__imuCb=null;globalThis.__slots={};"
    "globalThis.__setCalls=0;globalThis.__tones=[];"
    "globalThis.__closeCalls=0;globalThis.__latestCalls=0;"
    "globalThis.pocket={kasane:{mount(name){const view=kasane.mount(name);"
    "return {set(slots){view.set(slots);Object.assign(__slots,slots);__setCalls++;}};}},"
    "capabilities:{get(n){return {supported:true,available:true,reason:null};}},"
    "sensors:{imu:{latest(){__latestCalls++;return null;},"
    "watch(o,cb){if(o.rateHz!==20)throw Error('unexpected watch rate');"
    "__imuCb=cb;return {close(){__closeCalls++;__imuCb=null;}};}}},"
    "storage:{get(k){return k in __store?Promise.resolve(__store[k]):"
    "Promise.reject({code:'NOT_FOUND'});},"
    "set(k,v){__store[k]=v;return Promise.resolve();}},"
    "audio:{tone(o){__tones.push(o);return Promise.resolve();}},"
    "app:{start(h){globalThis.__hooks=h;},onFrame(f){globalThis.frame=()=>f();}}};"
    /* A closed subscription must stop delivering samples, as on the device. */
    "function setAccel(x,y,z,gyro={x:0.01,y:0,z:0},dropped=0){"
    "if(__imuCb)__imuCb({accel:{x:x,y:y,z:z},gyro:gyro,dropped:dropped});}"
    "function moveSample(i){setAccel((i%2?1:-1)*3,(i%3?1:-1)*3,(i%5?1:-1)*3);}";

static bool open_imucal_runtime(const char *setup) {
    rt=JS_NewRuntime2(&allocator,NULL);ctx=rt?JS_NewContext(rt):NULL;
    if(!ctx)return false;
    host_capabilities_clear();
    /* Unlike open_fault_runtime(), do not create a raw scene: mount() owns
     * the app lease and correctly rejects an already active scene. */
    return pocket_kasane_install(ctx,NULL)==ESP_OK&&run(setup);
}

static bool drain_jobs(void) {
    JSContext *job_ctx;
    while(JS_IsJobPending(rt)) {
        if(JS_ExecutePendingJob(rt,&job_ctx)<0) {
            JSValue error=JS_GetException(job_ctx);
            const char *message=JS_ToCString(job_ctx,error);
            printf("    pending job threw: %s\n",message?message:"?");
            if(message)JS_FreeCString(job_ctx,message);
            JS_FreeValue(job_ctx,error);return false;
        }
    }
    return true;
}

static uint16_t first_pixels[240*135];
static unsigned turn_submissions;
static bool first_differs;

static bool present_settled(void) {
    /* Per-slot updates may leave a newer model behind the submitted bank.
     * Compare complete turn output after both banks have been acknowledged,
     * rather than the baseline's transient partially updated first bank. */
    turn_submissions=0;first_differs=false;
    for(unsigned i=0;i<3;i++) {
        ksn_render_stats stats;bool blocked=false;
        if(pocket_kasane_has_submission())turn_submissions++;
        if(present(&stats)!=KSN_OK||pocket_kasane_presenter_step(&blocked)!=KSN_OK)return false;
        if(i==0)memcpy(first_pixels,panel_pixels,sizeof(first_pixels));
        if(!blocked) {
            first_differs=memcmp(first_pixels,panel_pixels,sizeof(first_pixels))!=0;
            return true;
        }
    }
    return false;
}

/* Exact pixels and untruncated app-visible state, rather than hashes. The
 * baseline lives in a temporary host file, never in firmware or the repo. */
typedef struct {
    uint16_t pixels[240*135];
    char state[8192];
    uint32_t set_calls;
    unsigned submissions;
    bool first_differs;
} frame_record;
static frame_record actual,expected;
static unsigned frame_count,set_call_count,submission_count,intermediate_count;

static bool capture(FILE *baseline,bool reference,const char *command,
                    unsigned before_calls,unsigned after_calls,const char *label) {
    bool ok=run("__setCalls=0;")&&run(command)&&drain_jobs()&&present_settled();
    memset(&actual,0,sizeof(actual));
    actual.submissions=turn_submissions;actual.first_differs=first_differs;
    if(ok) {
        JSValue state=JS_Eval(ctx,
            "JSON.stringify([__slots,__logs,__store,__tones,__closeCalls,__latestCalls,!!__imuCb])",
            sizeof("JSON.stringify([__slots,__logs,__store,__tones,__closeCalls,__latestCalls,!!__imuCb])")-1,
            "<imucal-state>",JS_EVAL_TYPE_GLOBAL);
        size_t size=0;
        const char *text=JS_IsException(state)?NULL:JS_ToCStringLen(ctx,&size,state);
        ok=text&&size<sizeof(actual.state);
        if(ok)memcpy(actual.state,text,size+1);
        if(text)JS_FreeCString(ctx,text);
        JS_FreeValue(ctx,state);
        JSValue global=JS_GetGlobalObject(ctx);
        JSValue calls=JS_GetPropertyStr(ctx,global,"__setCalls");
        ok=JS_ToUint32(ctx,&actual.set_calls,calls)==0&&ok;
        JS_FreeValue(ctx,calls);JS_FreeValue(ctx,global);
    }
    memcpy(actual.pixels,panel_pixels,sizeof(panel_pixels));
    if(ok&&actual.set_calls!=(reference?before_calls:after_calls)) {
        printf("    frame %u %s set calls: got %u, expected %u\n",frame_count,label,
               actual.set_calls,reference?before_calls:after_calls);
        ok=false;
    }
    /* The first sample changes live and stat together. A batched show
     * submits their final values immediately; the old version needs refresh. */
    if(ok&&!strcmp(label,"sample without gyro")&&
       (actual.first_differs!=reference||actual.submissions!=(reference?2u:1u))) {
        printf("    first sample did not exhibit the expected atomic submission\n");
        ok=false;
    }
    if(ok&&reference)ok=fwrite(&actual,sizeof(actual),1,baseline)==1;
    else if(ok) {
        ok=fread(&expected,sizeof(expected),1,baseline)==1;
        if(ok&&strcmp(actual.state,expected.state)) {
            printf("    frame %u %s state mismatch\n    old: %s\n    new: %s\n",
                   frame_count,label,expected.state,actual.state);
            ok=false;
        }
        if(ok&&memcmp(actual.pixels,expected.pixels,sizeof(actual.pixels))) {
            printf("    frame %u %s rendered pixels differ\n",frame_count,label);
            ok=false;
        }
    }
    if(!ok)printf("    %s frame %u failed: %s\n",reference?"baseline":"batched",frame_count,label);
    frame_count++;set_call_count+=actual.set_calls;
    submission_count+=actual.submissions;intermediate_count+=actual.first_differs;
    return ok;
}

static bool orientation(FILE *baseline,bool reference,unsigned index,
                        const char *sample,bool resume) {
    char command[256];
    snprintf(command,sizeof(command),"for(let i=0;i<12;i++){%s}",sample);
    if(!run(command))return false;
    /* Resume after 20 held frames must reset the 45-frame hold, without
     * clearing the sensor window or capturing the next orientation early. */
    if(resume) {
        for(unsigned i=0;i<20;i++) {
            snprintf(command,sizeof(command),"%sframe();",sample);
            if(!capture(baseline,reference,command,5,1,"hold before resume"))return false;
        }
        if(!run("if(!__slots.stat.includes(' HOLD 25'))throw Error('hold did not advance');"))return false;
        if(!capture(baseline,reference,"__hooks.resume({suspendedMs:5000});",0,0,"resume hook"))return false;
    }
    for(unsigned i=0;i<45;i++) {
        snprintf(command,sizeof(command),"%sframe();",sample);
        bool report=index==5&&i==44;
        if(!capture(baseline,reference,command,report?6:5,report?6:1,
                    report?"sixth orientation report and save":"hold orientation"))return false;
        if(resume&&i==0&&!run("if(!__slots.stat.includes(' HOLD 44'))throw Error('resume did not reset hold');"))
            return false;
    }
    snprintf(command,sizeof(command),
        "if(__logs.filter(x=>x.startsWith('IMUCAL_SAMPLE ')).length!==%u)"
        "throw Error('wrong captured orientation count');",index+1);
    if(!run(command))return false;
    if(index==5)return true;
    if(!run("if(__slots.foot!=='MOVE TO NEXT'||!__slots.stat.includes(' MOVE ON'))"
            "throw Error('capture did not request movement');"))return false;
    for(unsigned i=0;i<3;i++) {
        if(!capture(baseline,reference,"frame();",5,1,"still after capture"))return false;
    }
    if(!run("if(__slots.foot!=='MOVE TO NEXT')throw Error('rearmed without movement');"))return false;
    for(unsigned i=0;i<10;i++) {
        snprintf(command,sizeof(command),"moveSample(%u);frame();",i);
        if(!capture(baseline,reference,command,5,1,"move and rearm"))return false;
        if(i==8&&!run("if(__slots.foot!=='MOVE TO NEXT')throw Error('rearmed too soon');"))return false;
    }
    return run("if(__slots.foot!=='HOLD STILL. ESC QUITS'||!__slots.stat.includes(' MOVING'))"
               "throw Error('did not rearm after ten moving frames');");
}

static bool exercise(FILE *baseline,bool reference,const char *source) {
    frame_count=0;set_call_count=0;submission_count=0;intermediate_count=0;
    memset(panel_pixels,0,sizeof(panel_pixels));
    if(!open_imucal_runtime(fixture))return false;
    if(!capture(baseline,reference,source,3,2,"initial no sample"))return false;
    for(unsigned i=0;i<3;i++) {
        if(!capture(baseline,reference,"frame();",2,1,"repeated no sample"))return false;
    }
    if(!run("if(__slots.head!=='1/6 DESK, FACE UP'||__slots.live!=='NO SAMPLE YET'||"
            "__slots.stat!=='WAIT'||__slots.spin!=='GYR OFF')throw Error('no-sample slots changed');"))return false;
    if(!capture(baseline,reference,"setAccel(1.25,-2.5,3.75,null,7);frame();",5,1,"sample without gyro"))return false;
    if(!run("if(__slots.live!=='X+1250 Y-2500 Z+3750'||__slots.spin!=='GYR OFF'||"
            "!__slots.stat.endsWith(' MOVING DROP 7'))throw Error('regular sample formatting changed');"))return false;
    if(!capture(baseline,reference,
                "setAccel(-0.0005,0.0005,-9.8,{x:0.012,y:-0.004,z:0.008},12);frame();",
                5,1,"signed gyro and rounded accel"))return false;
    if(!run("if(__slots.live!=='X+0 Y+1 Z-9800'||__slots.spin!=='GYR +12 -4 +8')"
            "throw Error('rounding or gyro formatting changed');"))return false;
    const char *samples[]={"setAccel(0,0,9.8);","setAccel(0,0,-9.8);",
        "setAccel(0,9.8,0);","setAccel(0,-9.8,0);","setAccel(9.8,0,0);","setAccel(-9.8,0,0);"};
    for(unsigned i=0;i<6;i++) {
        if(!orientation(baseline,reference,i,samples[i],i==0))return false;
    }
    if(!run("if(__logs.indexOf('IMUCAL_OK')===-1||"
            "__logs.indexOf('IMUCAL_MAP #define MAP_X(ax,ay,az) (-ax)')===-1)"
            "throw Error('missing successful mapping');"
            "if(__slots.head!=='DONE'||__slots.live!=='X=-AX Y=AY Z=AZ'||__slots.spin!=='SAVED'||"
            "__slots.foot!=='ESC QUITS')throw Error('report display changed');"
            "if(!__store.axes||!__store.axes.ok||__store.axes.map!==__slots.live||"
            "__store.axes.err!==-0.1)throw Error('saved calibration changed');"
            "if(__closeCalls!==2||__imuCb!==null)throw Error('subscription not closed twice');"
            "if(__tones.length!==12||__tones[11].frequencyHz!==660)throw Error('tone sequence changed');"))return false;
    for(unsigned i=0;i<11;i++) {
        if(!capture(baseline,reference,"setAccel(99,99,99);frame();",0,0,"post-report closed sensor"))return false;
    }
    return run("if(__logs.indexOf('IMUCAL GYRO AFTER null')===-1||__latestCalls!==2)"
               "throw Error('post-report gyro check missing');"
               "if(typeof ui!=='undefined')throw Error('legacy ui global leaked');");
}

static char *baseline_source(const char *source) {
    const char *begin=strstr(source,"  function show() {\n");
    const char *end=begin?strstr(begin,"\n  function step() {"):NULL;
    if(!begin||!end||strstr(begin+1,"  function show() {\n"))return NULL;
    size_t prefix=(size_t)(begin-source),replacement=strlen(legacy_show),tail=strlen(end);
    char *result=malloc(prefix+replacement+tail+1);
    if(result) {
        memcpy(result,source,prefix);
        memcpy(result+prefix,legacy_show,replacement);
        memcpy(result+prefix+replacement,end,tail+1);
    }
    return result;
}

int main(void) {
    FILE *file=fopen("apps/imucal/imucal.js","rb");
    if(!file) { printf("FAIL cannot open apps/imucal/imucal.js\n"); return 2; }
    char source[16384];
    size_t bytes=fread(source,1,sizeof(source)-1,file);
    bool source_ok=!ferror(file)&&feof(file);
    fclose(file);source[bytes]=0;
    if(!source_ok) { printf("FAIL imucal source too large or unreadable\n"); return 2; }

    check(open_imucal_runtime(
        "globalThis.console={log(){}};"
        "globalThis.pocket={kasane:kasane,"
        "capabilities:{get(name){return {supported:true,available:false,reason:'NO_DEVICE'};}}};"),
        "imucal fixture opens with NO_IMU capability");
    check(run(source),"imucal.js runs to completion under NO_IMU capability");
    check(present_settled(),"imucal NO_IMU scene presents");
    check(run("frame();frame();frame();"),"imucal NO_IMU frame() pump does not throw");
    check(present_settled(),"imucal NO_IMU repeated present stays OK");
    check(run("if(typeof ui!=='undefined')throw Error('legacy ui global leaked');"),
          "no legacy ui global observed");
    close_fault_runtime();

    FILE *baseline=tmpfile();
    char *legacy=baseline_source(source);
    check(baseline&&legacy,"independent per-slot show baseline is available");
    if(baseline&&legacy) {
        bool before=exercise(baseline,true,legacy);
        unsigned before_frames=frame_count,before_calls=set_call_count;
        unsigned before_submissions=submission_count,before_intermediate=intermediate_count;
        check(before,"per-slot baseline completes no-sample, hold, resume, rearm and six-orientation walk");
        close_fault_runtime();
        rewind(baseline);
        bool after=before&&exercise(baseline,false,source);
        check(after,"batched show matches every baseline slot snapshot, side effect and settled rendered pixel");
        if(after) {
            check(frame_count==before_frames&&fgetc(baseline)==EOF,
                  "batched walk consumes the entire frame baseline");
            printf("IMUCAL EQUIVALENCE frames=%u view.set=%u->%u (no-sample 2->1, sampled show 5->1)\n",
                   frame_count,before_calls,set_call_count);
            printf("IMUCAL HOST SUBMISSIONS %u->%u intermediate-pictures=%u->%u\n",
                   before_submissions,submission_count,before_intermediate,intermediate_count);
        }
        if(rt)close_fault_runtime();
    }
    if(baseline)fclose(baseline);
    free(legacy);
    check(ksn_runtime_shutdown()==KSN_OK&&live_allocations==0,"imucal test teardown frees memory");
    printf("%s\n",failures?"IMUCAL KASANE TEST FAIL":"IMUCAL KASANE TEST PASS");
    return failures?1:0;
}
