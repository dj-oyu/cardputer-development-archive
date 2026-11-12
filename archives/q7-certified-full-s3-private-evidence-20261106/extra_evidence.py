from pathlib import Path
import json,subprocess,hashlib,shutil,re
r=Path(__file__).resolve().parent;ev=r/'evidence';t=Path('/workspace/.setup/espressif/tools/xtensa-esp-elf/esp-15.2.0_20251204/xtensa-esp-elf/bin');sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for arm in ['off','on']:
 b=r/('build-'+arm);d=ev/arm
 for name in ['toolchain/cflags','specs/picolibc.specs']:
  p=b/name;q=d/name;q.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,q)
 if arm=='on':
  x=next(x for x in json.loads((d/'selected-compile-commands.json').read_text()) if x['file'].endswith('/ksn_mesh_q7_certified.c'))
  a=x['argv'].copy();i=a.index('-o');del a[i:i+2];a.remove('-c');a+=['-E','-dM']
  p=subprocess.run(a,cwd=x['directory'],text=True,capture_output=True);assert p.returncode==0,p.stderr;(d/'actual-preprocessor-macros.txt').write_text(p.stdout);(d/'preprocessor-command.json').write_text(json.dumps(a,indent=2))
  p=b/'esp-idf/main/CMakeFiles/__idf_main.dir/ui/kasane/ksn_mesh_q7_certified.c.obj'
  out=subprocess.check_output([str(t/'xtensa-esp32s3-elf-nm'),'-u',str(p)],text=True);(d/'q7-object-undefined.txt').write_text(out)
  assert not re.search(r'ee\.|\bqacc\b',(d/'ksn_mesh_q7_certified.c.disassembly.txt').read_text(),re.I)
# Trace source context and exact inherited settings; no CP changes in scalar experiment.
refs={'main/main.c':['ui_task','32768'],'main/pocket/pocket_shiki_frame.c':['q7_candidate','q7_owner_workspace','depth_calloc','PROC_SURFACES'],'main/ui/kasane/ksn_mesh_q7_certified.c':['ieee_environment','fegetround','Static_assert']}
out=[]
for name,keys in refs.items():
 lines=(r/'source'/name).read_text().splitlines();numbers=set()
 for i,line in enumerate(lines):
  if any(k in line for k in keys):numbers.update(range(max(0,i-2),min(len(lines),i+5)))
 out.append(name);out.extend(f'{i+1}: {lines[i]}' for i in sorted(numbers))
(ev/'SOURCE_EXCERPTS.txt').write_text('\n'.join(out)+'\n')
print('extra evidence complete')
