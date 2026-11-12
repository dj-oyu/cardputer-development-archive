from pathlib import Path
import re,subprocess
D=Path(__file__).resolve().parent;R=D.parents[1];O=D/'generated'
subprocess.run(['node','tools/ayatsuri/skin/batch_fixture.cjs',str(O)],cwd=R,check=True)
a=(O/'scene.c').read_text();a=a[:a.index('#ifdef ESP_PLATFORM\nvoid app_main')]
assets=''
for n,p in [('limit_blob',O/'skin-limit.aynm'),('batch_scenario',R/'tools/ayatsuri/skin/batch_scenario.js')]:
 data=p.read_bytes()+(b'\0' if p.suffix=='.js' else b'');assets+='static const unsigned char '+n+'[]={'+','.join(map(str,data))+'};\n'
a=assets+a;a=a.replace('static int skin_run(', 'static int __attribute__((unused)) skin_run(');a=a.replace('if(!strcmp(name,"holes"))','if(!strcmp(name,"limit")){src=limit_blob;n=sizeof limit_blob;}else if(!strcmp(name,"holes"))')
b=(R/'tools/ayatsuri/skin/test_batch.c').read_text();b=b[b.index('static const float batch_camera'):]
b=b.replace('int main(', 'static int batch_run(').replace('JS_NewRuntime()', 'scene_new_runtime()')
b=re.sub(r'    FILE \*f=fopen\("tools/ayatsuri/skin/batch_scenario.js".*?eval\(ctx,"batchSetup\(\)"\);','    eval(ctx,(const char *)batch_scenario);eval(ctx,"batchSetup()");scene_heap("batch_setup");',b)
b=b.replace('void *arena=malloc(arena_bytes);CHECK(arena);','void *arena_owner=malloc(arena_bytes+7);CHECK(arena_owner);void *arena=(void *)(((uintptr_t)arena_owner+7)&~(uintptr_t)7);').replace('free(arena);','free(arena_owner);')
b=b.replace('!memcmp(panel,reference,sizeof panel)','frame_hash()==reference_hash').replace('memcpy(isolated,panel,sizeof panel)','isolated_hash=frame_hash()').replace('!memcmp(panel,isolated,sizeof panel)','frame_hash()==isolated_hash').replace('memcmp(panel,isolated,sizeof panel)','frame_hash()!=isolated_hash')
b=b.replace('if(visit<120)hashes[frame]=hash;','if(visit<120){hashes[frame]=hash;capture(frame,frame);}')
b=b.replace('batch_oom(rt,ctx);','scene_heap("batch_before_oom");batch_oom(rt,ctx);scene_heap("batch_after_oom");').replace('SKIN_BATCH_HOST rows=','SKIN_BATCH_MEMORY allocation_counters_host_only=1 rows=').replace(' release0',' host_ledger_or_target_heap')
entry='''
#ifdef ESP_PLATFORM
void app_main(void){char *args[]={"qemu-skin-batch","4","1","embedded"};puts("QSKIN_PROFILE scalar_no_PIE real_QuickJS managed_batch hash_oracle no_hardware no_performance_claim");scene_heap("startup");batch_run(4,args);scene_heap("released_first");batch_run(4,args);scene_heap("released_second");puts("QSKIN_DONE");for(;;)vTaskDelay(pdMS_TO_TICKS(1000));}
#else
int main(int argc,char **argv){return batch_run(argc,argv);}
#endif
'''
(O/'batch.c').write_text(a+b+entry)
