import pathlib,json,subprocess,hashlib,shlex,re,shutil
r=pathlib.Path(__file__).parent;b=r/'build';e=r/'evidence';e.mkdir(exist_ok=True)
prefix='/workspace/.setup/espressif/tools/xtensa-esp-elf/esp-15.2.0_20251204/xtensa-esp-elf/bin/xtensa-esp32s3-elf-'
elf=b/'private_dot8_control_validation.elf';cmds=json.loads((b/'compile_commands.json').read_text());(e/'compile_commands.json').write_text(json.dumps(cmds,indent=2)+'\n')
for n,args in [('raw',['objdump','-drwC','--disassemble=dot8_pie_raw']),('cp-handler',['objdump','-drwC','--disassemble=_xt_coproc_exc']),('worker',['objdump','-drwC','--disassemble=worker']),('supervisor',['objdump','-drwC','--disassemble=supervisor']),('symbols',['nm','-Sn']),('sections',['size','-A']),('elf-header',['readelf','-hSW']),('disassembly',['objdump','-drwC'])]:
 (e/(n+'.txt')).write_bytes(subprocess.check_output([prefix+args[0],*args[1:],str(elf)]))
assert len(re.findall(r'\tee\.',(e/'raw.txt').read_text()))==14
obj=b/'esp-idf/main/CMakeFiles/__idf_main.dir/dot8.c.obj'
sec=subprocess.check_output([prefix+'readelf','-SW',str(obj)]).decode();assert '.gnu.lto' not in sec;(e/'raw-object-sections.txt').write_text(sec)
for name,src in [('new',obj),('old',pathlib.Path('/workspace/build/esp-idf/main/CMakeFiles/__idf_main.dir/dot8.c.obj'))]:
 subprocess.check_call([prefix+'objcopy','-O','binary','--only-section=.text.dot8_pie_raw',str(src),str(e/(name+'-raw-code.bin'))])
assert (e/'new-raw-code.bin').read_bytes()==(e/'old-raw-code.bin').read_bytes()
for p in (b/'esp-idf/main/CMakeFiles/__idf_main.dir').glob('*.su'):shutil.copyfile(p,e/p.name)
for n in ['private_dot8_control_validation.elf','private_dot8_control_validation.bin','private_dot8_control_validation.map','project_description.json','CMakeCache.txt','build.ninja','flash_args','flasher_args.json','partition_table/partition-table.bin','bootloader/bootloader.bin','toolchain/cflags','specs/picolibc.specs']:
 p=e/n;p.parent.mkdir(parents=True,exist_ok=True);shutil.copyfile(b/n,p)
for name in ['compiler','objdump']:
 (e/(name+'-version.txt')).write_bytes(subprocess.check_output([prefix+('gcc' if name=='compiler' else name),'--version']))
for p in ['/tmp/dot8-control-build.log','/tmp/dot8-control-build-final.log','/tmp/dot8-control-export-final.log']:shutil.copyfile(p,e/pathlib.Path(p).name)
patterns=re.compile(r'\bCPENABLE\b|\bcpenable\b|\bee\.(?:zero|vld|vmulas|st|ld)|\b(st|ld)\.qr\b');hits=[];deps={}
for c in cmds:
 p=pathlib.Path(c['file']);data=p.read_bytes();deps[str(p)]={'bytes':len(data),'sha256':hashlib.sha256(data).hexdigest()}
 for line,s in enumerate(data.decode(errors='replace').splitlines(),1):
  if patterns.search(s):hits.append({'file':str(p),'line':line,'text':s.strip()})
(e/'active-source-cp-audit.json').write_text(json.dumps({'scope':'actual compile TU source text; not all includes/ROM/prebuilt or runtime handlers','hits':hits},indent=2)+'\n')
(e/'translation-unit-hashes.json').write_text(json.dumps(deps,indent=2)+'\n')
# Record every sdkconfig semantic difference from the retained prior build.
def kv(p):
 d={}
 for s in p.read_text().splitlines():
  m=re.match(r'(# )?(CONFIG_\w+)(?:=(.*)| is not set)',s)
  if m:d[m[2]]='n' if m[1] else m[3]
 return d
old=kv(pathlib.Path('/workspace/private-dot8-idf-harness-20261105/sdkconfig'));new=kv(r/'sdkconfig')
(e/'sdkconfig-diff.json').write_text(json.dumps({k:{'old':old.get(k),'new':new.get(k)} for k in sorted(old.keys()|new.keys()) if old.get(k)!=new.get(k)},indent=2)+'\n')
# Stop-related IDF excerpts, read only, for reconciliation.
sdk=pathlib.Path('/workspace/.setup/esp-idf');refs=[('components/freertos/FreeRTOS-Kernel/tasks.c',1964,2058),('components/freertos/FreeRTOS-Kernel/portable/xtensa/portasm.S',637,750),('components/xtensa/esp32s3/include/xtensa/config/tie-asm.h',280,409)]
text=''
for rel,first,last in refs:
 p=sdk/rel;text+='\n'+str(p)+'\n'+'\n'.join(f'{i}: {s}' for i,s in enumerate(p.read_text().splitlines(),1) if first<=i<=last)+'\n'
(e/'idf-source-excerpts.txt').write_text(text)
assert hashlib.sha256((r/'main/dot8.c').read_bytes()).hexdigest()=='d1d321916966b3632a258aad130356459dd502123819ea8b2b0c66fced41b09d'
assert hashlib.sha256((r/'main/dot8.h').read_bytes()).hexdigest()=='6c187ebf6fe5847b00e16eacc5942bd57d34294e8df52afeddc1f9a06480c0de'
for n in ['private_dot8_control_validation.bin','private_dot8_control_validation.elf','partition_table/partition-table.bin']:
 p=e/n;print(n,p.stat().st_size,hashlib.sha256(p.read_bytes()).hexdigest())
a=next(c for c in cmds if c['file'].endswith('/main/dot8.c'));print('BUILD ID',[v for v in shlex.split(a['command']) if 'DOT8_BUILD_ID' in v]);assert '-fno-lto' in shlex.split(a['command'])
identity='dot8-control-v2'
for n in ['CMakeLists.txt','dot8.c','dot8.h','checked.c','checked.h','corpus.c','corpus.h','control.c','control.h','harness.c']:identity+=hashlib.sha256((r/'main'/n).read_bytes()).hexdigest()
identity+=hashlib.sha256((r/'sdkconfig.defaults').read_bytes()).hexdigest()
expected=hashlib.sha256(identity.encode()).hexdigest()[:16]
assert any(expected in v for v in shlex.split(a['command']) if 'DOT8_BUILD_ID' in v)
print('raw50 code-identical;14PIE; source CP hits',len(hits),'source fingerprint verified',expected)
