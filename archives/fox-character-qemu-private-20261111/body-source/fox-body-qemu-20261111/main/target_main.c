#include <assert.h>
#include <stdint.h>
#include <stdio.h>
#include "esp_heap_caps.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
int body_init(void);
uint32_t body_frame(unsigned pose,unsigned view,int oracle_mode,int capture);
void body_shutdown(void);
static unsigned lifecycle;
static void heap(const char *phase){
 printf("FOX_BODY_HEAP lifecycle=%u phase=%s free=%u largest=%u minimum=%u stack_hwm=%u\n",lifecycle,phase,
 (unsigned)heap_caps_get_free_size(MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT),
 (unsigned)heap_caps_get_largest_free_block(MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT),
 (unsigned)heap_caps_get_minimum_free_size(MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT),
 (unsigned)uxTaskGetStackHighWaterMark(NULL));
}
void body_row(unsigned pose,unsigned view,unsigned y,const uint16_t *row){
 printf("FOX_BODY_ROW lifecycle=%u pose=%u view=%u y=%u ",lifecycle,pose,view,y);
 for(unsigned x=0;x<240;x++)printf("%02x%02x",row[x]&255,row[x]>>8);
 putchar('\n');
}
void app_main(void){
 puts("FOX_BODY_PROFILE private_2kv2_body_454triangles_native_C_DQ_recomputed_normals_no_QuickJS_no_LCD_no_FPS_claim");
 heap("startup");
 for(lifecycle=0;lifecycle<2;lifecycle++){
  assert(body_init()==0);heap("initialized");
  uint32_t hashes[2][3];const unsigned poses[3]={0,31,63};
  for(unsigned visit=0;visit<6;visit++){
   unsigned at=visit<3?visit:5-visit;unsigned pose=poses[at];
   for(unsigned view=0;view<2;view++){
    int capture=lifecycle==0&&visit<3;
    uint32_t h=body_frame(pose,view,0,capture);
    printf("FOX_BODY_FRAME lifecycle=%u visit=%u pose=%u view=%u hash=%08lx\n",lifecycle,visit,pose,view,(unsigned long)h);
    if(visit<3)hashes[view][at]=h;else assert(hashes[view][at]==h);
    if(pose==31)assert(body_frame(pose,view,0,0)==h);
   }
  }
  heap("rendered");body_shutdown();heap("released");
 }
 puts("FOX_BODY_QEMU_DONE lifecycles=2 visits_per_lifecycle=12 reverse_and_pause_hashes_pass");
 for(;;)vTaskDelay(pdMS_TO_TICKS(1000));
}
