from pathlib import Path
import json,subprocess,hashlib
R=Path(__file__).resolve().parents[2];O=Path(__file__).resolve().parent;G=O/'generated'
s=(R/'tools/kasane_contract/q7/test_row_reuse.c').read_text()
s=s.replace('int main(int argc,char**argv)', 'static int run_profile(int argc,char**argv)').replace('trial<9','trial<1').replace('f<150','f<16').replace('assert(hash==0x924db725u);','assert(stats[1].depth_fast>0 && stats[1].mask_fast>0);')
s=s.replace('ksn_mesh_prepared*p=malloc(pb);ksn_mesh_q7_snapshot*q=malloc(qb);assert(p&&q);','void *pr=malloc(pb+7),*qr=malloc(qb+7);ksn_mesh_prepared*p=(void*)(((uintptr_t)pr+7)&~(uintptr_t)7);ksn_mesh_q7_snapshot*q=(void*)(((uintptr_t)qr+7)&~(uintptr_t)7);assert(pr&&qr);printf("Q7_ALLOC prepared=%zu q7=%zu padding=14 align_p=%u align_q=%u\\n",pb,qb,(unsigned)((uintptr_t)p%8),(unsigned)((uintptr_t)q%8)); heap_report("allocated");')
s=s.replace(',hash,(unsigned long long)', ',(unsigned)hash,(unsigned long long)')
s=s.replace('corner_cases(p,pb,q,qb);', 'corner_cases(p,pb,q,qb); uint16_t sentinel=0xbeef;float zv=77;uint8_t own=99;assert(!ksn_mesh_q7_render(q,&sentinel,136,0,&zv,&own,1,NULL));assert(sentinel==0xbeef&&zv==77&&own==99);unsigned saved=p->capacity;p->capacity=65;assert(ksn_mesh_q7_bytes(p)==0);p->capacity=saved;assert(!ksn_mesh_q7_prepare(p,q,sizeof(*q)-1));puts("Q7_LIMIT_PASS invalid_y capacity65 undersized_snapshot output_sentinel");')
s=s.replace('free(p);free(q);' ,'free(pr);free(qr); heap_report("freed");return 0;')
s=s.replace('assert(!memcmp(image[0],image[1],sizeof image[0]));for', '''assert(!memcmp(image[0],image[1],sizeof image[0]));
   if(trial==0 && rows==8 && (f==0 || f==2 || f==4)){
    capture(f,image[1]);
    for(unsigned i=0;i<240*135;i++)image[0][i]=0x0841;
    for(unsigned yy=0;yy<135;yy+=8){unsigned nn=135-yy<8?135-yy:8;assert(ksn_mesh_render(&s,image[0]+yy*240,yy,nn,z[0],8));}
    unsigned diff=0;for(unsigned i=0;i<240*135;i++)diff+=image[0][i]!=image[1][i];printf("Q7_FLOAT_DIFF frame=%u pixels=%u\\n",f,diff);capture(f+100,image[0]);
   }
   for''')
# Keep startup/reporting separate from production files.
prefix='''#ifdef ESP_PLATFORM
#include "esp_heap_caps.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#endif
#include <stdint.h>
#include <stdio.h>
static void heap_report(const char *phase){
#ifdef ESP_PLATFORM
 printf("Q7_HEAP phase=%s free=%u largest=%u min=%u stack_hwm=%u integrity=%u\\n",phase,(unsigned)heap_caps_get_free_size(MALLOC_CAP_8BIT),(unsigned)heap_caps_get_largest_free_block(MALLOC_CAP_8BIT),(unsigned)heap_caps_get_minimum_free_size(MALLOC_CAP_8BIT),(unsigned)uxTaskGetStackHighWaterMark(NULL),(unsigned)heap_caps_check_integrity_all(true));
#else
 printf("Q7_HEAP phase=%s host_only\\n",phase);
#endif
}
static void capture(unsigned f,const uint16_t *p){for(unsigned y=0;y<135;y++){printf("QSCENE_ROW frame=%u y=%u data=",f,y);for(unsigned x=0;x<240;x++){unsigned v=p[y*240+x];printf("%02x%02x",v&255,v>>8);}puts("");}}
'''
s=prefix+s+'''
int workspace_test(void);int failure_test(void);
static void all_tests(void){puts("Q7_PROFILE PREPARED=ON Q7_CERTIFIED=ON EDGE4=OFF PREFLIGHT=OFF Q7_CERT_MODE=3 public_four_overlapping_quads no_QuickJS no_PIE no_PSRAM no_throughput_claim");heap_report("startup");assert(workspace_test()==0);assert(failure_test()==0);for(unsigned cycle=0;cycle<2;cycle++){printf("Q7_CYCLE %u\\n",cycle);char *a[]={"q7","4","1"};run_profile(3,a);char*b[]={"q7","8","8"};run_profile(3,b);}heap_report("complete");puts("Q7_DONE");}
#ifdef ESP_PLATFORM
void app_main(void){all_tests();for(;;)vTaskDelay(pdMS_TO_TICKS(1000));}
#else
int main(void){all_tests();return 0;}
#endif
'''
# Capture only first cycle to avoid duplicate rows.
s=s.replace('static void capture(unsigned f,const uint16_t *p){','static unsigned captured[200];static void capture(unsigned f,const uint16_t *p){if(captured[f]++)return;')
(G/'profile.c').write_text(s)
for name,entry in [('test_workspace','workspace_test'),('test_row_stats_failure','failure_test')]:
 t=(R/('tools/kasane_contract/q7/'+name+'.c')).read_text().replace('int main(void)',f'int {entry}(void)')
 # Explicit static buffers keep 24KiB target stack bounded; 8-byte aligned heaps.
 t=t.replace('uint16_t pixels[2]', 'static uint16_t pixels[2]').replace('float z[2]', 'static float z[2]').replace('uint8_t owners[2]', 'static uint8_t owners[2]')
 t=t.replace('ksn_mesh_prepared*p=malloc(pb);ksn_mesh_q7_snapshot*q=malloc(qb);assert(p&&q);','void *pr=malloc(pb+7),*qr=malloc(qb+7);ksn_mesh_prepared*p=(void*)(((uintptr_t)pr+7)&~(uintptr_t)7);ksn_mesh_q7_snapshot*q=(void*)(((uintptr_t)qr+7)&~(uintptr_t)7);assert(pr&&qr);').replace('free(p);free(q);','free(pr);free(qr);')
 t=t.replace('ksn_mesh_q7_stats stats[2];', 'memset(pixels,0,sizeof pixels);memset(z,0,sizeof z);memset(owners,0,sizeof owners);ksn_mesh_q7_stats stats[2];')
 t=t.rstrip()[:-1]+'return 0;\n}\n'
 (G/(name+'.c')).write_text(t)
sources=['main/ui/kasane/ksn_mesh_q7_certified.c','main/ui/kasane/ksn_mesh_prepared.c','main/ui/kasane/ksn_mesh_depth.c','main/ui/kasane/ksn_shiki_frame.c','main/ayatsuri/compact_opaque.c','tools/kasane_contract/q7/flat_span_oracle.c']
(G/'sources.cmake').write_text('set(Q7_SOURCES\n'+'\n'.join('"${REPO}/'+p+'"' for p in sources)+'\n)\n')
(O/'manifest.json').write_text(json.dumps({'head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip(),'sha256':{p:hashlib.sha256((R/p).read_bytes()).hexdigest() for p in sources+['tools/kasane_contract/q7/test_row_reuse.c','tools/kasane_contract/q7/test_workspace.c','tools/kasane_contract/q7/test_row_stats_failure.c']}},indent=2))
