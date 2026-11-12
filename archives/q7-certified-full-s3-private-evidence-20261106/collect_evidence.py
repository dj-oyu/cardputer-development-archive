from pathlib import Path
import json,subprocess,hashlib,shlex,re,shutil
r=Path(__file__).resolve().parent;t=Path('/workspace/.setup/espressif/tools/xtensa-esp-elf/esp-15.2.0_20251204/xtensa-esp-elf/bin');ev=r/'evidence';ev.mkdir(exist_ok=True)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for arm in ['off','on']:
 b=r/('build-'+arm)
 if not (b/'cardputer_pocketjs.elf').exists():continue
 d=ev/arm;d.mkdir(exist_ok=True);elf=b/'cardputer_pocketjs.elf'
 for cmd,name in [(['readelf','-hSW'],'elf-header-sections.txt'),(['readelf','-rW'],'elf-relocations.txt'),(['nm','-S','--size-sort'],'symbols-by-size.txt'),(['nm','-n'],'symbols-by-address.txt'),(['nm','-u'],'undefined.txt'),(['objdump','-drwC'],'full-disassembly.txt'),(['size','-A'],'sections-size.txt')]:
  tool,*args=cmd;out=subprocess.run([str(t/('xtensa-esp32s3-elf-'+tool)),*args,str(elf)],capture_output=True,text=True);(d/name).write_text(out.stdout+out.stderr);assert out.returncode==0,(cmd,out.stderr)
 assert re.search(r'^\s*[0-9a-f]+:',(d/'full-disassembly.txt').read_text(),re.M)
 db=json.loads((b/'compile_commands.json').read_text());selected=[];deps={};response={};objects=[]
 for x in db:
  if any(x['file'].endswith(n) for n in ['pocket_shiki_frame.c','ksn_mesh_depth.c','ksn_mesh_prepared.c','pie_edge4.c','pie_edge4_raw.c','ksn_mesh_q7_certified.c']):
   a=x.get('arguments') or shlex.split(x['command']);selected.append({**x,'argv':a})
   out=Path(x['directory'])/a[a.index('-o')+1];objects.append(out)
   for opt in a:
    p=None
    if opt.startswith('@'):p=Path(x['directory'])/opt[1:]
    elif opt.startswith('--specs=') or opt.startswith('-specs='):p=Path(opt.split('=',1)[1]);p=p if p.is_absolute() else Path(x['directory'])/p
    if p and p.is_file():response[str(p.resolve())]={'sha256':sha(p.resolve()),'bytes':p.stat().st_size,'content':p.read_text()}
   dep=subprocess.run(['/workspace/.setup/venv/bin/ninja','-C',str(b),'-t','deps',str(out.relative_to(b))],capture_output=True,text=True)
   (d/(Path(x['file']).name+'.dependencies.txt')).write_text(dep.stdout+dep.stderr)
   for line in dep.stdout.splitlines():
    if line.startswith('    '):
     p=Path(line.strip());p=p if p.is_absolute() else b/p
     if p.is_file():deps[str(p.resolve())]=sha(p.resolve())
 for obj in objects:
  stem=obj.name.removesuffix('.obj');shutil.copy2(obj,d/obj.name)
  for args,suffix in [(['-drwC'],'disassembly.txt'),(['-htr'],'sections-symbols-relocs.txt')]:
   res=subprocess.run([str(t/'xtensa-esp32s3-elf-objdump'),*args,str(obj)],capture_output=True,text=True);assert res.returncode==0;(d/(stem+'.'+suffix)).write_text(res.stdout)
  su=obj.with_suffix('.su')
  if su.exists():shutil.copy2(su,d/su.name)
 for name in ['sdkconfig','config/sdkconfig.h','config/sdkconfig.cmake','compile_commands.json','CMakeCache.txt','build.ninja','flasher_args.json','project_description.json','cardputer_pocketjs.elf','cardputer_pocketjs.bin','cardputer_pocketjs.map','partition_table/partition-table.bin','bootloader/bootloader.bin','esp-idf/esp_system/ld/sections.ld']:
  p=b/name
  if p.exists():dest=d/name;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,dest)
 (d/'selected-compile-commands.json').write_text(json.dumps(selected,indent=2)+'\n');(d/'response-spec-files.json').write_text(json.dumps(response,indent=2)+'\n');(d/'dependency-sha256.json').write_text(json.dumps(deps,indent=2)+'\n')
 print(arm,'selected',len(selected),'dependencies',len(deps),'responses',len(response))
