#include "corpus.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_timer.h"
#include "esp_attr.h"
#include <stdio.h>
#include <inttypes.h>
#define STACK_BYTES 4096
#define CORE 0
_Alignas(16) static StackType_t worker_stack[STACK_BYTES/sizeof(StackType_t)];
_Alignas(16) static StackType_t supervisor_stack[STACK_BYTES/sizeof(StackType_t)];
static StaticTask_t worker_tcb,supervisor_tcb;
static TaskHandle_t worker_handle,supervisor_handle,setup_handle;
static bool setup_done;
static Dot8Workspace workspace;
static Dot8Suite suite;
static Dot8Control control;
static portMUX_TYPE mux=portMUX_INITIALIZER_UNLOCKED;
RTC_NOINIT_ATTR static uint32_t boot_guard[2];
volatile Dot8Terminal dot8_terminal_result;
_Static_assert(configMAX_PRIORITIES>6,"supervisor priority available");
_Static_assert(sizeof worker_stack==STACK_BYTES && sizeof supervisor_stack==STACK_BYTES,"stack budgets bytes");
static void park(void) { for(;;) vTaskSuspend(NULL); }
static void emit_terminal(void) {
    Dot8Terminal result;portENTER_CRITICAL(&mux);bool emit=dot8_control_take(&control,&result);
    if(emit) dot8_terminal_result=result;
    portEXIT_CRITICAL(&mux);
    if(emit) {
        printf("DOT8 {\"event\":\"%s\",\"harness\":\"dot8-control-v2\",\"build\":\"%s\",\"cases\":%u,\"passed\":%"PRIu32",\"failed\":%"PRIu32",\"invalid\":%"PRIu32",\"first_error\":%u,\"first_case\":%"PRId32",\"elapsed_us\":%"PRId64",\"event_us\":%"PRId64"}\n",dot8_status_name(result.status),DOT8_BUILD_ID,DOT8_CASES,result.passed,result.failed,result.invalid_rejected,(unsigned)result.error,result.first_case,result.elapsed_us,result.event_us);
        fflush(stdout);
    }
}
static void worker(void *arg) {
    (void)arg;ulTaskNotifyTake(pdTRUE,portMAX_DELAY);dot8_suite_init(&suite);
    for(;;) {
        portENTER_CRITICAL(&mux);bool go=dot8_control_permit(&control,esp_timer_get_time());portEXIT_CRITICAL(&mux);
        if(!go) {xTaskNotifyGive(supervisor_handle);park();}
        dot8_suite_step(&workspace,&suite,dot8_checked);
        portENTER_CRITICAL(&mux);dot8_control_progress(&control,&suite.progress,esp_timer_get_time());bool done=control.pending_done;portEXIT_CRITICAL(&mux);
        if(done) {xTaskNotifyGive(supervisor_handle);park();}
        /* Keep idle/system tasks schedulable; this is not a timing benchmark. */
        if(suite.progress.next_case%16==0) vTaskDelay(1);
    }
}
static void supervisor(void *arg) {
    (void)arg;
    /* Arm immediately once supervisor exists, including remaining setup. */
    for(;;) {
        portENTER_CRITICAL(&mux);bool ready=dot8_control_ready(&control,esp_timer_get_time());
        TaskHandle_t stop_worker=worker_handle,stop_setup=setup_done?NULL:setup_handle;portEXIT_CRITICAL(&mux);
        if(ready) {
            /* Both tasks are core0-pinned; this higher-priority task is running,
             * so worker cannot execute concurrently. Suspend it BEFORE commit. */
            if(stop_worker) vTaskSuspend(stop_worker);
            if(stop_setup) vTaskSuspend(stop_setup);
            portENTER_CRITICAL(&mux);dot8_control_commit(&control,esp_timer_get_time());portEXIT_CRITICAL(&mux);
            emit_terminal();park();
        }
        TickType_t poll=pdMS_TO_TICKS(10);if(poll==0) poll=1;
        ulTaskNotifyTake(pdTRUE,poll);
    }
}
void app_main(void) {
    dot8_control_start(&control,esp_timer_get_time());
    printf("DOT8 {\"event\":\"START\",\"harness\":\"dot8-control-v2\",\"build\":\"%s\",\"cases\":%u,\"deadline_us\":%"PRId64"}\n",DOT8_BUILD_ID,DOT8_CASES,DOT8_DEADLINE_US);fflush(stdout);
    if(!dot8_claim_boot(boot_guard)) {dot8_control_setup_error(&control,DOT8_REENTRY,esp_timer_get_time());emit_terminal();return;}
    /* Each newly created task blocks on a private start notification. */
    setup_handle=xTaskGetCurrentTaskHandle();
    supervisor_handle=xTaskCreateStaticPinnedToCore(supervisor,"dot8_supervise",STACK_BYTES,NULL,6,supervisor_stack,&supervisor_tcb,CORE);
    if(!supervisor_handle) {dot8_control_setup_error(&control,DOT8_CREATE_SUPERVISOR,esp_timer_get_time());emit_terminal();return;}
    TaskHandle_t created_worker=xTaskCreateStaticPinnedToCore(worker,"dot8_worker",STACK_BYTES,NULL,5,worker_stack,&worker_tcb,CORE);
    portENTER_CRITICAL(&mux);worker_handle=created_worker;portEXIT_CRITICAL(&mux);
    if(!worker_handle) {vTaskSuspend(supervisor_handle);dot8_control_setup_error(&control,DOT8_CREATE_WORKER,esp_timer_get_time());emit_terminal();return;}
    portENTER_CRITICAL(&mux);setup_done=true;bool go=!control.terminal;portEXIT_CRITICAL(&mux);
    if(go) {xTaskNotifyGive(supervisor_handle);xTaskNotifyGive(worker_handle);}
}
