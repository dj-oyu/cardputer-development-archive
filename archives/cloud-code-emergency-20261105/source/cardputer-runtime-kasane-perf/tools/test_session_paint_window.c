// A new app cannot inherit the previous app's partial 30-paint window.
#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "session_paint_prof.inc"

static double render_sum,present_sum,turn_sum;
static unsigned painted,ticks,band_count_last,band_runs_last,band_mask_last;
static ksn_render_prof prof_sum,unreported_prof;
static unsigned profile_reads;
#if KASANE_STRESS_GRAD_AB
static unsigned grad_ab_bytes;
#endif
static void ksn_render_prof_read(ksn_render_prof *out){
    *out=unreported_prof;unreported_prof=(ksn_render_prof){0};profile_reads++;
}
#include "session_paint_window.inc"

static void assert_clear(void){
    const ksn_render_prof empty={0};
    assert(!render_sum&&!present_sum&&!turn_sum&&!painted&&!ticks);
    assert(!band_count_last&&!band_runs_last&&!band_mask_last);
    assert(!memcmp(&prof_sum,&empty,sizeof(empty)));
    assert(!memcmp(&unreported_prof,&empty,sizeof(empty)));
#if KASANE_STRESS_GRAD_AB
    assert(!grad_ab_bytes);
#endif
}
int main(void){
    // Twenty-nine old paints, including both aggregated and not-yet-read
    // renderer work. The first paint of the next app must not close this.
    render_sum=29*4000;present_sum=29*1000;turn_sum=41*2807;
    painted=29;ticks=41;band_count_last=17;band_runs_last=1;band_mask_last=0x1ffff;
    memset(&prof_sum,0xa5,sizeof(prof_sum));
    memset(&unreported_prof,0x3c,sizeof(unreported_prof));
#if KASANE_STRESS_GRAD_AB
    grad_ab_bytes=29*64800;
#endif
    reset_paint_window();assert_clear();assert(profile_reads==1);
    for(unsigned i=1;i<=30;i++){
        painted++;ticks++;turn_sum+=2807;render_sum+=4000;present_sum+=1000;
        assert(painted==i&&ticks==i);
        if(i<30)assert(painted<30);
    }
    assert(painted==30&&turn_sum/ticks==2807);
    assert(render_sum/30==4000&&present_sum/30==1000);
    // The same production helper closes a full window. It is idempotent,
    // so repeated start attempts do not retain any residual partial data.
    reset_paint_window();assert_clear();assert(profile_reads==2);
    reset_paint_window();assert_clear();assert(profile_reads==3);
    puts("session paint window PASS: partial session reset, renderer counters, fresh 30-paint window");
}
