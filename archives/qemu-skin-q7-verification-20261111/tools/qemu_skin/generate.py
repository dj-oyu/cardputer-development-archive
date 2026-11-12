from pathlib import Path
import subprocess,re,json,hashlib
R=Path(__file__).resolve().parents[2]; D=Path(__file__).resolve().parent;O=D/'generated';O.mkdir(exist_ok=True)
subprocess.run(['node','tools/ayatsuri/skin/render_fixture.cjs',str(O)],cwd=R,check=True)
inputs=['tools/kasane_contract/test_meshbench_app.c','tools/ayatsuri/skin/test_js.c','tools/ayatsuri/skin/js_scenario.js']
with (O/'assets.h').open('w') as f:
 for name,path in [('scenario',R/inputs[2])]+[(v+'_blob',O/('skin-'+v+'.aynm')) for v in ['plain','holes','sided']]:
  b=path.read_bytes()+(b'\0' if path.suffix=='.js' else b'');f.write('static const unsigned char '+name+'[]={'+','.join(map(str,b))+'};\n')
a=(R/inputs[0]).read_text();a=a[:a.index('static JSValue log_line')]
a=a.replace('#include "host_requested_alloc.h"','#ifndef ESP_PLATFORM\n#include "host_requested_alloc.h"\n#else\nstatic size_t live_bytes,peak_bytes,live_blocks,alloc_calls;\n#endif').replace('#include "meshbench_eval_alloc.h"','').replace(',reference[240*135]','').replace(',ready,start,ends,samples,presents',',presents').replace('static uint32_t clock_value=0xffffff00u;','')
ad=(D/'adapter.inc').read_text(); ad=ad[:ad.index('static const app_chunk_t chunks[]')]+ad[ad.index('static void eval('):];ad=ad.replace('#include "pocket_app_load.h"','').replace('#include "app_chunks.h"','').replace('frame!=0&&frame!=2&&frame!=4','frame!=0&&frame!=30&&frame!=60')
b=(R/inputs[1]).read_text();b=b[b.index('#include "ayatsuri/ayatsuri_model_skin.h"'):];b=b.replace('static uint16_t isolated[240*135];','static uint32_t isolated_hash;')
start=b.index('    char path[1024]');end=b.index('\n}',start)
b=b[:start]+'''    (void)dir;const uint8_t *src=plain_blob;size_t n=sizeof plain_blob;
    if(!strcmp(name,"holes")){src=holes_blob;n=sizeof holes_blob;}else if(!strcmp(name,"sided")){src=sided_blob;n=sizeof sided_blob;}
    uint8_t *p=malloc(n);CHECK(p);memcpy(p,src,n);*bytes=n;return p;'''+b[end:]
b=b.replace('for(unsigned j=0;j<240*135;++j)reference[j]=17;\n    CHECK(ksn_mesh_render(&s,reference,0,135,scratch,1));','''reference_hash=2166136261u;uint16_t row[240];
    for(unsigned y=0;y<135;y++){for(unsigned x=0;x<240;x++)row[x]=17;
    CHECK(ksn_mesh_render(&s,row,y,1,scratch,1));for(unsigned x=0;x<240;x++){reference_hash^=row[x];reference_hash*=16777619u;}}''')
b=b.replace('JS_NewRuntime()', 'scene_new_runtime()').replace('int SKIN_JS_MAIN(', 'static int skin_run(')
b=re.sub(r'    FILE \*f=fopen\("tools/ayatsuri/skin/js_scenario.js".*?eval\(ctx,"setup\(\)"\);','    eval(ctx,(const char *)scenario);eval(ctx,"setup()");scene_heap("setup");',b)
b=b.replace('void *arena=malloc(arena_bytes);CHECK(arena);','void *arena_owner=malloc(arena_bytes+7);CHECK(arena_owner);void *arena=(void *)(((uintptr_t)arena_owner+7)&~(uintptr_t)7);').replace('free(arena);','free(arena_owner);')
b=b.replace('!memcmp(panel,reference,sizeof panel)','frame_hash()==reference_hash').replace('memcpy(isolated,panel,sizeof panel)','isolated_hash=frame_hash()').replace('!memcmp(panel,isolated,sizeof panel)','frame_hash()==isolated_hash').replace('memcmp(panel,isolated,sizeof panel)','frame_hash()!=isolated_hash')
b=b.replace('if(visit<120)hashes[frame]=hash;','if(visit<120){hashes[frame]=hash;capture(frame,frame);}')
b=b.replace('oom(rt,ctx);','scene_heap("before_oom");oom(rt,ctx);scene_heap("after_oom");')
b=b.replace('SKIN_JS_HOST rows=','SKIN_JS_MEMORY allocation_counters_host_only=1 oracle_arena_padding=7 rows=').replace(' release0',' host_ledger_or_target_heap')
entry='''
#ifdef ESP_PLATFORM
void app_main(void){char *args[]={"qemu-skin","4","1","embedded"};puts("QSKIN_PROFILE scalar_no_PIE real_QuickJS single_skin hash_oracle no_hardware no_performance_claim");scene_heap("startup");skin_run(4,args);scene_heap("released_first");skin_run(4,args);scene_heap("released_second");puts("QSKIN_DONE");for(;;)vTaskDelay(pdMS_TO_TICKS(1000));}
#else
int main(int argc,char **argv){return skin_run(argc,argv);}
#endif
'''
(O/'scene.c').write_text(a+ad+b+entry)
subprocess.run(['python3','tools/make_font.py',str(O)],cwd=R,check=True,stdout=subprocess.DEVNULL)
(O/'kasane_pet_test_data.h').write_text('static const uint8_t pet_test_data[]={'+','.join(map(str,(R/'apps/pet/assets/pets-compact.bin').read_bytes()))+'};\n')
(O/'rom.c').write_text('#include "ksn_shiki.h"\nconst ksn_shiki_rom_entry *ksn_shiki_rom_table(unsigned *n){*n=0;return 0;}\n')
sources=list(dict.fromkeys(re.findall(r'(?:main|tools)/[\w/]+\.c',(R/'tools/build_kasane_test.sh').read_text())))
sources=[s for s in sources if s!='tools/test_pocket_kasane.c']+['main/pocket/pocket_shape.c','main/pocket/pocket_shiki_api.c','main/pocket/app_registry.c']
(O/'sources.cmake').write_text('set(SCENE_SOURCES\n'+'\n'.join(' "${REPO}/'+s+'"' for s in sources)+'\n)\n')
(O/'manifest.json').write_text(json.dumps({'head':subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip(),'inputs':{p:hashlib.sha256((R/p).read_bytes()).hexdigest() for p in inputs+sources}},indent=2)+'\n')
