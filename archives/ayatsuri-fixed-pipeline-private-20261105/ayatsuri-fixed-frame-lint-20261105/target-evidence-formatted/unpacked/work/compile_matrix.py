from pathlib import Path
import subprocess,json,shlex,hashlib,re,os
R=Path(__file__).resolve().parent;S=R/'source';CAP=S/'target-probe/capsule';OUT=Path('/workspace/ayatsuri-s3-fixed-arithmetic-objects-20261105');assert not OUT.exists();OUT.mkdir()
h=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
for p,x in json.loads((S/'INPUT_MANIFEST.json').read_text()).items():assert (S/p).stat().st_size==x['bytes'] and h(S/p)==x['sha256']
cm=json.loads((S/'target-probe/capsule-manifest.json').read_text());DB=Path('/workspace/cardputer-mesh-pr117-20261103/build-pr117/compile_commands.json');row=next(x for x in json.loads(DB.read_text()) if x['file'].endswith('/main/ui/kasane/ksn_mesh_depth.c'));original=shlex.split(row['command']);BIN=Path(original[0]).parent
m={'classification':'PRIVATE_STANDALONE_ARITHMETIC_COMPONENT_CONFIG_NOT_FIRMWARE_BUILD','original_entry':row,'original_argv':original,'db_sha256':h(DB),'output_root':str(OUT),'compiler':{'path':original[0],'sha256':h(original[0]),'version':subprocess.check_output([original[0],'--version'],text=True).splitlines()[0],'dumpmachine':subprocess.check_output([original[0],'-dumpmachine'],text=True).strip()},'tool_versions':{},'response_specs':{},'changes':[],'commands':[],'configs':{},'environment':{k:os.environ.get(k) for k in ('CPATH','C_INCLUDE_PATH','CPLUS_INCLUDE_PATH','GCC_EXEC_PREFIX','COMPILER_PATH','LIBRARY_PATH')}}
assert not any(m['environment'].values())
for n in ('objdump','readelf','size','nm'):
 p=BIN/('xtensa-esp32s3-elf-'+n);m['tool_versions'][n]={'path':str(p),'version':subprocess.check_output([str(p),'--version'],text=True).splitlines()[0]}
for a in original:
 if a.startswith('@'):
  p=Path(a[1:]);assert h(p)=='847551aa2ebe5c24d6320c5cd0f18b090bab7461f3dff954fec167e34ea92cbe';m['response_specs'][str(p)]={'sha256':h(p),'content':p.read_text()}
  for f in shlex.split(p.read_text()):
   if f.startswith('-specs='):
    p=Path(f.split('=',1)[1]);assert h(p)=='abf36c1f57d16d1244ee064ca9ec82180a167fac34c3dbc281ba470703a556fc';m['response_specs'][str(p)]={'sha256':h(p),'content':p.read_text()}
for p in [Path('/workspace/cardputer-mesh-pr117-20261103/build-pr117/config/sdkconfig.h'),Path('/workspace/.setup/esp-idf/components/xtensa/esp32s3/include/xtensa/config/core-isa.h')]:m['configs'][str(p)]={'sha256':h(p),'identity_lines':[x for x in p.read_text().splitlines() if any(k in x for k in ('CONFIG_IDF_TARGET','XCHAL_CORE_ID'))]}
args=[];skip=False
for a in original:
 if skip:skip=False;continue
 if a in ('-o','-MF','-MT','-MQ'):skip=True;m['changes'].append({'output_token':a});continue
 if a in ('-c','-MD','-MMD','-MP') or a==row['file']:m['changes'].append({'io_token':a});continue
 if a.startswith('-I/workspace/cardputer-pr117-mesh-fw-20261103/main'):
  new='-I'+str(CAP);m['changes'].append({'old':a,'new':new});a=new
 args.append(a)
assert '-std=gnu23' in args and '-ffp-contract=off' in args and not any(x.startswith('-flto') for x in args)
m['experimental_controls']={'Q':'-DMBITS=16/20/24','optimization':'original flags retained; explicit final -Os or -O2 appended identically for corresponding variants','stack':'-fstack-usage','no_source_edits':True,'no_warning_change':True,'no_fabricated_externals':True}
for q in (16,20,24):
 for opt in ('Os','O2'):
  common=args+['-'+opt,f'-DMBITS={q}'];d=OUT/f'q{q}-{opt}';d.mkdir()
  pp=common+['-dM','-E','-x','c','/dev/null'];p=subprocess.run(pp,cwd=row['directory'],capture_output=True,text=True);assert p.returncode==0 and '#define __XTENSA_WINDOWED_ABI__ 1' in p.stdout;(d/'predefines.txt').write_text(p.stdout)
  for name in cm['units']:
   source=CAP/name;stem=source.stem;obj=d/(stem+'.o');cmd=common+['-fstack-usage','-MMD','-MF',str(d/(stem+'.d')),'-MT',str(obj),'-o',str(obj),'-c',str(source)]
   rec={'bits':q,'optimization':opt,'source':name,'unit':stem,'object':str(obj),'argv':cmd,'shell_command':shlex.join(cmd),'cwd':row['directory']};m['commands'].append(rec)
   with (d/(stem+'.compile.log')).open('w') as f:rc=subprocess.run(cmd,cwd=row['directory'],stdout=f,stderr=subprocess.STDOUT).returncode
   rec['exit_code']=rc;rec['status']='COMPILE_FAILED_NO_RETRY' if rc else 'COMPILE_PASS';print(q,opt,stem,'exit',rc,flush=True)
   (R/'build-status.json').write_text(json.dumps(m,indent=2)+'\n')
   if rc:continue
   rec['object_sha256']=h(obj);rec['object_bytes']=obj.stat().st_size
   for suffix,tool,flags in [('elf-header.txt','readelf',['-h','-A']),('symbols.txt','nm',['-S','--size-sort']),('sections.txt','readelf',['-SW']),('relocations.txt','objdump',['-r']),('size.txt','size',[])]:
    (d/(stem+'.'+suffix)).write_text(subprocess.check_output([str(BIN/('xtensa-esp32s3-elf-'+tool)),*flags,str(obj)],text=True))
   header=(d/(stem+'.elf-header.txt')).read_text();assert re.search(r'Machine:\s*.*Xtensa',header,re.I) and re.search(r'Type:\s*REL\b',header)
   proc=subprocess.run([str(BIN/'xtensa-esp32s3-elf-objdump'),'-d','--no-show-raw-insn',str(obj)],capture_output=True,text=True);assert proc.returncode==0 and re.search(r'^[0-9a-f]+ <[^>]+>:',proc.stdout,re.M) and re.search(r'^\s*[0-9a-f]+:\s+[a-z]',proc.stdout,re.M);(d/(stem+'.scanner-input.txt')).write_text(proc.stdout);rec['nonempty_xtensa_disassembly_preflight']=True
   flags=[f for line in (d/(stem+'.symbols.txt')).read_text().splitlines() if len(line.split())==4 and line.split()[2] in ('t','T') for f in ('-j','.text.'+line.split()[3])]
   (d/(stem+'.instructions.txt')).write_text(subprocess.check_output([str(BIN/'xtensa-esp32s3-elf-objdump'),'-dlrwC',*flags,str(obj)],text=True))
   scan=subprocess.run(['python3',str(S/'target-probe/scanner/frame_lint.py'),'--objdump',str(BIN/'xtensa-esp32s3-elf-objdump'),str(obj)],capture_output=True,text=True);assert scan.returncode==0 and not scan.stderr and 'SKIPPED' not in scan.stdout;(d/(stem+'.frame-lint.txt')).write_text(scan.stdout);rec['heuristic_scanner_exit']=scan.returncode
   dep=d/(stem+'.full.d');dcmd=common+['-M','-MF',str(dep),'-MT',stem,str(source)];subprocess.run(dcmd,cwd=row['directory'],capture_output=True,check=True);closure={}
   for p in shlex.split(dep.read_text().replace('\\\n',' ').split(':',1)[1]):
    p=Path(p);p=(p if p.is_absolute() else Path(row['directory'])/p).resolve();assert p.is_file();assert '/workspace/cardputer-pr117-mesh-fw-20261103/' not in str(p);closure[str(p)]={'sha256':h(p),'bytes':p.stat().st_size}
   (d/(stem+'.dependency-hashes.json')).write_text(json.dumps(closure,indent=2)+'\n');rec['dependency_count']=len(closure);rec['dependency_argv']=dcmd
   (R/'build-status.json').write_text(json.dumps(m,indent=2)+'\n')
(R/'build-status.json').write_text(json.dumps(m,indent=2)+'\n')
