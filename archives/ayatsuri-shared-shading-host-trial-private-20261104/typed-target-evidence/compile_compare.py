from pathlib import Path
import json,subprocess,shlex,hashlib
ROOT=Path(__file__).resolve().parent
DB=Path('/workspace/cardputer-mesh-pr117-20261103/build-pr117/compile_commands.json')
row=next(x for x in json.loads(DB.read_text()) if x['file'].endswith('/main/ayatsuri/ayatsuri_model.c'))
original=shlex.split(row['command']);source_root='/workspace/cardputer-pr117-mesh-fw-20261103'
BIN=Path(original[0]).parent
commands=[];metadata={'original':row,'tool_versions':{},'response_files':{},'variants':{}}
for name in ['gcc','objdump','size']:
 tool=BIN/('xtensa-esp32s3-elf-'+name)
 metadata['tool_versions'][name]=subprocess.check_output([str(tool),'--version'],text=True).splitlines()[0]
for arg in original:
 if arg.startswith('@'):
  p=Path(arg[1:]);metadata['response_files'][str(p)]={'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'content':p.read_text()}
  # A specs file named inside the response is preserved, not rewritten.
  for flag in shlex.split(p.read_text()):
   if flag.startswith('-specs='):
    spec=Path(flag.split('=',1)[1]);metadata['response_files'][str(spec)]={'sha256':hashlib.sha256(spec.read_bytes()).hexdigest()}
for variant in ['control','candidate-typed-stores']:
 dest=ROOT/'results'/variant;dest.mkdir()
 args=[];skip=False
 for k,arg in enumerate(original):
  if skip:skip=False;continue
  if arg=='-o':skip=True;continue
  if arg=='-c' or arg==row['file']:continue
  if arg in ['-MF','-MT','-MQ']:skip=True;continue
  if arg in ['-MD','-MMD','-MP']:continue
  if arg.startswith('-I'+source_root+'/main'):arg='-I'+str(ROOT/variant)+arg[len('-I'+source_root):]
  args.append(arg)
 metadata['variants'][variant]={}
 for unit,source,extra in [('model',ROOT/variant/'main/ayatsuri/ayatsuri_model.c',[]),('shade_pair',ROOT/'shade_pair.c',['-DSHARED=1','-DTYPED_STORES='+str(int(variant=='candidate-typed-stores'))])]:
  obj=dest/(unit+'.o')
  cmd=[*args,*extra,'-fstack-usage','-fdump-rtl-ira-details='+str(dest/(unit+'.ira')),'-fdump-rtl-reload-details='+str(dest/(unit+'.reload')),'-MMD','-MF',str(dest/(unit+'.d')),'-MT',str(obj),'-o',str(obj),'-c',str(source)]
  record={'variant':variant,'unit':unit,'cwd':str(dest),'argv':cmd,'shell_command':shlex.join(cmd)};commands.append(record)
  with (dest/(unit+'.compile.log')).open('w') as log:
   result=subprocess.run(cmd,cwd=dest,stdout=log,stderr=subprocess.STDOUT)
  record['exit_code']=result.returncode
  (ROOT/'results/commands.json').write_text(json.dumps(commands,indent=2)+'\n')
  assert result.returncode==0,(variant,unit,'compile failed, see log')
  for suffix,flags in [('disassembly.txt',['-drwCl']),('symbols.txt',['-t']),('sections.txt',['-h'])]:
   with (dest/(unit+'.'+suffix)).open('w') as f:subprocess.run([str(BIN/'xtensa-esp32s3-elf-objdump'),*flags,str(obj)],stdout=f,check=True)
  with (dest/(unit+'.size.txt')).open('w') as f:subprocess.run([str(BIN/'xtensa-esp32s3-elf-size'),'-A',str(obj)],stdout=f,check=True)
  metadata['variants'][variant][unit]={'object_bytes':obj.stat().st_size,'object_sha256':hashlib.sha256(obj.read_bytes()).hexdigest(),'su':(dest/(unit+'.su')).read_text()}
  print(variant,unit,'PASS',obj.stat().st_size,flush=True)
(ROOT/'results/build-metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
print('FOUR_S3_OBJECTS_PASS')
