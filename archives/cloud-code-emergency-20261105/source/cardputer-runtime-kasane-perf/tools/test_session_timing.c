// Actual app_tick() with a fake wall clock: charge work at the owner ports,
// not at timer reads, so missing or overlapping intervals cannot pass by luck.
#include <assert.h>
#include <stdatomic.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

typedef int esp_err_t;
enum {ESP_OK=0,ESP_FAIL=-1,ESP_ERR_TIMEOUT=-2,KSN_INPUT_APP,KSN_INPUT_BLOCKED};
typedef int ksn_result;
enum {KSN_OK,KSN_BUSY};
typedef struct {size_t struct_size;uint32_t buttons,analog;} pocketjs_guest_frame_t;
typedef struct {int id;} sys_notice;
static void *guest;
static atomic_bool stop_requested;
static bool turn_continued,pending,remain,frame_parks,frame_submits,cont_submits;
static bool need_present,submission;
static unsigned continuation_turns,ticks,pumps,frames,continues,presents,cleanups;
static uint32_t deferred_buttons,delivered,memory_us,pump_us,frame_us,cont_us;
static uint32_t probe_sum,probe_n;
static int64_t now,last_present_us;
static double turn_sum;
#define VM_DISPLAY_PERIOD_MS 33

enum { KSN_P0_APP_TURN };
static void ksn_p0_probe_sample(int which,uint32_t us){
    assert(which==KSN_P0_APP_TURN);probe_sum+=us;probe_n++;
}
#ifdef KASANE_MEGADEMO_TRACE
// Use the production layout, so a new trace field cannot silently be omitted
// from the fixture. Emission is outside the measured interval in production.
#include "session_timing_trace.inc"
static void mdt_emit(void){memset(&mdt,0,sizeof(mdt));now+=137;}
#endif
#ifdef CONFIG_POCKET_VM_PROBE
static uint32_t vm_frame_us,vm_frame_n,vm_cont_n;
static void vmprobe_frame_sample(void *g,int64_t us){(void)g;vm_frame_us+=(uint32_t)us;vm_frame_n++;}
static void vmprobe_continuation_sample(void *g){(void)g;vm_cont_n++;}
#endif
#ifdef CONFIG_POCKET_VM_TURNPERF
static uint32_t turnperf_cont_us,turnperf_cont_n,tp_frame_us,tp_frame_n;
static void turnperf_read(uint32_t *a,uint32_t *b){*a=0;*b=0;}
static void turnperf_add(uint32_t a,uint32_t b,uint32_t us){(void)a;(void)b;tp_frame_us+=us;tp_frame_n++;}
#endif
static int64_t esp_timer_get_time(void){return now;}
static void arm_turn(uint32_t buttons){(void)buttons;now+=127;}
static bool pocketjs_guest_work_pending(void *g){(void)g;return pending;}
static int pocketjs_guest_continue(void *g){
    (void)g;continues++;now+=cont_us;pending=remain;
    if(cont_submits)submission=need_present=true;
    return ESP_OK;
}
static int pocketjs_guest_frame(void *g,const pocketjs_guest_frame_t *f){
    (void)g;assert(f->struct_size==sizeof(*f)&&f->analog==0x8080);
    frames++;delivered=f->buttons;now+=frame_us;pending=frame_parks;
    if(frame_submits)submission=need_present=true;
    return ESP_OK;
}
static void *sys_device_notifications(void){return NULL;}
static bool sys_notify_active(void *n,sys_notice *out){(void)n;(void)out;now+=109;return false;}
static uint16_t pet_hub_selected(void){return 0;}
static ksn_result pocket_kasane_update_notice(const sys_notice *n,uint16_t pet){(void)n;(void)pet;return KSN_OK;}
static bool pocket_kasane_needs_present(void){return need_present;}
static bool pocket_kasane_has_submission(void){return submission;}
static void pocket_kasane_set_animation_time(uint64_t t){(void)t;}
static bool pocket_kasane_animation_pending(void){return false;}
static bool pocket_kasane_system_pending(void){return false;}
static int pocket_kasane_input_scope(bool b){(void)b;return KSN_INPUT_APP;}
static bool pocket_proc_pending(void){return false;}
static void pocket_kasane_end_turn(void){cleanups++;now+=7;}
static void pocket_kasane_park_turn(void){cleanups++;now+=7;}
static void report_oom_if_any(void){now+=131;}
static bool drain_runaway(void){return false;}
static bool pocket_app_exit_requested(void){return false;}
static void app_request_stop(void){atomic_store(&stop_requested,true);}
static void sample_memory_pressure(void){now+=97;}
static ksn_result pocket_kasane_presenter_step(bool *blocked){*blocked=false;now+=113;return KSN_OK;}
#define ESP_LOGE(tag,...) ((void)(tag))
static int present_frame(void){
    now+=17;
    if(need_present){
        now+=5000;presents++;
#ifdef KASANE_MEGADEMO_TRACE
        mdt.render_us+=4000;mdt.send_us+=1000;mdt.presents++;
#endif
    }
    submission=need_present=false;return ESP_OK;
}
static void pocket_memory_pump(bool leaving){(void)leaving;now+=memory_us;}
#define PUMP(name) static void name(void){pumps++;now+=pump_us;}
PUMP(pocket_app_pump) PUMP(pocket_text_pump) PUMP(pocket_imu_pump)
PUMP(pocket_io_pump) PUMP(pocket_bridge_pump) PUMP(pocket_net_pump)
PUMP(pocket_capture_pump) PUMP(pocket_api_pump) PUMP(pocket_fs_pump)
PUMP(pocket_video_sd_stream_reap) PUMP(pocket_av_pump)
static void pocket_input_pump(uint32_t b){delivered=b;pumps++;now+=pump_us;}
#include "session_dispatch_impl.inc"

static void reset(void){
    turn_continued=pending=remain=frame_parks=cont_submits=need_present=submission=false;
    frame_submits=true;atomic_store(&stop_requested,false);
    continuation_turns=ticks=pumps=frames=continues=presents=cleanups=0;
    deferred_buttons=delivered=probe_sum=probe_n=0;
    memory_us=13;pump_us=65;frame_us=2000;cont_us=3000;
    now=40000;last_present_us=0;turn_sum=0;
#ifdef KASANE_MEGADEMO_TRACE
    memset(&mdt,0,sizeof(mdt));
#endif
#ifdef CONFIG_POCKET_VM_PROBE
    vm_frame_us=vm_frame_n=vm_cont_n=0;
#endif
#ifdef CONFIG_POCKET_VM_TURNPERF
    turnperf_cont_us=turnperf_cont_n=tp_frame_us=tp_frame_n=0;
#endif
}
static void measured(unsigned sum,unsigned slices,unsigned pump,unsigned frame,unsigned cont){
    assert(turn_sum==sum&&ticks==slices);
    assert(probe_sum==sum&&probe_n==slices);
#ifdef KASANE_MEGADEMO_TRACE
    assert(mdt.js_us==sum&&mdt.pump_us==pump&&mdt.frame_us==frame&&mdt.cont_us==cont);
#else
    (void)pump;(void)frame;
#endif
#ifdef CONFIG_POCKET_VM_PROBE
    assert(vm_frame_us==frame&&vm_frame_n==frames&&vm_cont_n==continues);
#endif
#ifdef CONFIG_POCKET_VM_TURNPERF
    assert(tp_frame_us==frame&&tp_frame_n==frames);
    assert(turnperf_cont_us==cont&&turnperf_cont_n==continues);
#else
    (void)cont;
#endif
}
int main(void){
    // Normal service = memory 13 + 12 pumps * 65 + cleanup 7 + frame
    // 2000 + cleanup 7. Owner setup, OOM reporting and paint are excluded.
    reset();assert(app_tick(0x4000)==ESP_OK);measured(2807,1,800,2007,0);
    assert(pumps==12&&frames==1&&cleanups==2&&delivered==0x4000&&presents==1);
    assert(now-40000>turn_sum+5000);
#ifdef KASANE_MEGADEMO_TRACE
    assert(mdt.kind=='F'&&mdt.render_us==4000&&mdt.send_us==1000);
#endif
    // Memory listeners alone change the aggregate by their exact elapsed
    // time. Native pump work and synchronous JS callbacks share that scope.
    reset();memory_us=701;assert(app_tick(0)==ESP_OK);measured(3495,1,1488,2007,0);
    reset();pump_us=0;assert(app_tick(0)==ESP_OK);measured(2027,1,20,2007,0);
    // A frame with no damage is still charged; no render/send is invented.
    reset();frame_submits=false;assert(app_tick(0)==ESP_OK);measured(2807,1,800,2007,0);
    assert(!presents);
#ifdef KASANE_MEGADEMO_TRACE
    assert(!mdt.render_us&&!mdt.send_us);
#endif
    // Only a continuation runs, with presentation throttled. No pump or
    // frame cost is attributed to a queue that has not finished.
    reset();now=1000;pending=remain=true;assert(app_tick(0x20)==ESP_OK);
    measured(3007,1,0,0,3007);assert(!pumps&&!frames&&!presents&&turn_continued);
    assert(deferred_buttons==0x20);
#ifdef KASANE_MEGADEMO_TRACE
    assert(mdt.kind=='P');
#endif
    // A continuation may finish and fall through into a fresh frame in ONE
    // app_tick. PAINT counts two nonoverlapping slices; MDT must sum both.
    reset();pending=true;assert(app_tick(0x20)==ESP_OK);measured(5814,2,800,2007,3007);
    assert(pumps==12&&frames==1&&continues==1&&presents==1&&!turn_continued);
    // A completed continuation with a submitted frame returns before pumps.
    reset();pending=cont_submits=true;assert(app_tick(0x20)==ESP_OK);
    measured(3007,1,0,0,3007);assert(!pumps&&!frames&&presents==1&&deferred_buttons==0x20);
#ifdef KASANE_MEGADEMO_TRACE
    assert(mdt.kind=='C');
#endif
    // Back presents a completed parked frame BEFORE the final save frame.
    // Two 5 ms presentations must not leak into or double the service sum.
    reset();pending=cont_submits=true;assert(app_tick(0x2000)==ESP_OK);
    measured(5814,2,800,2007,3007);assert(presents==2&&frames==1&&delivered==0x2000);
#ifdef KASANE_MEGADEMO_TRACE
    assert(mdt.render_us==8000&&mdt.send_us==2000);
#endif
    // Back still reaches frame() when the continuation leaves work queued.
    reset();pending=remain=true;assert(app_tick(0x2000)==ESP_OK);
    measured(5814,2,800,2007,3007);assert(frames==1&&!turn_continued);
    // A parked frame gets the same pump coverage as a completed frame.
    reset();frame_parks=true;frame_submits=false;assert(app_tick(0)==ESP_OK);
    measured(2807,1,800,2007,0);
#ifdef KASANE_MEGADEMO_TRACE
    assert(mdt.kind=='Q');
#endif
    // A dedicated display tick invokes no service at all. It also clears the
    // prior MDT sample, so the previous frame's timing cannot be repeated.
    reset();need_present=submission=true;assert(app_tick(0)==ESP_OK);
    measured(0,0,0,0,0);assert(!pumps&&!frames&&!continues&&presents==1);
#ifdef KASANE_MEGADEMO_TRACE
    assert(mdt.kind=='D'&&mdt.render_us==4000&&mdt.send_us==1000);
#endif
    // Keep the aggregates between ticks, as PAINT does. The next MDT must
    // describe only the next tick; a no-damage turn cannot be recharged by a
    // later dedicated display turn.
    reset();frame_submits=false;assert(app_tick(0)==ESP_OK);
    need_present=submission=true;assert(app_tick(0)==ESP_OK);
    assert(turn_sum==2807&&ticks==1&&probe_sum==2807&&pumps==12&&frames==1);
#ifdef KASANE_MEGADEMO_TRACE
    assert(mdt.kind=='D'&&!mdt.js_us&&!mdt.pump_us&&!mdt.frame_us&&!mdt.cont_us);
#endif
    puts("session timing PASS: memory/pumps, frame-only probes, continuation sum, Back, no-render, display-only");
}
