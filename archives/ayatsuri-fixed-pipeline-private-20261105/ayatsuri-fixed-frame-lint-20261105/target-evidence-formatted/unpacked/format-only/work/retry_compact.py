from pathlib import Path
import json,subprocess,shlex,hashlib,re
R=Path(__file__).parent;OLD=Path('/workspace/ayatsuri-s3-fixed-arithmetic-20261105');m=json.loads((OLD/'build-status.json').read_text());CAP=R/'capsule';OLD_CAP=OLD/'source/target-probe/capsule';OUT=Path('/workspace/ayatsuri-s3-fixed-format-objects-20261105');assert not OUT.exists();OUT.mkdir();BIN=Path(m['compiler']['path']).parent
new={'input_evidence_library_id':'libfile_ef77b6a51ff481919ac2dc12d1565ec9','original_status_sha256':hashlib.sha256((OLD/'build-status.json').read_bytes()).hexdigest(),'original_configuration':{k:m[k] for k in ('original_entry','original_argv','compiler','tool_versions','response_specs','configs','environment')},'changes':'two exact formatting-only replacements; same six compact flags and warnings','commands':[],'output_root':str(OUT)}
for c in m['commands']:
 if c['unit']!='compact':continue
 assert c['exit_code']==1
 d=OUT/f"q{c['bits']}-{c['optimization']}";d.mkdir();obj=d/'compact.o';argv=[];changes=[]
 for a in c['argv']:
  b=a.replace(str(OLD_CAP),str(CAP)).replace(str(Path(c['object']).parent),str(d))
  if a!=b:changes.append({'old':a,'new':b})
  argv.append(b)
 source=argv[-1];base=[];skip=False
 for a in argv:
  if skip:skip=False;continue
  if a in ('-o','-MF','-MT','-MQ'):skip=True;continue
  if a in ('-fstack-usage','-MMD','-MD','-MP','-c') or a==source:continue
  base.append(a)
 # Preprocessor comparison uses each source's own complete original/derived paths.
 pp={}
 for label,sr,pa in [('old',c['argv'][-1],base),('format',source,base)]:
  if label=='old':pa=[x.replace(str(CAP),str(OLD_CAP)) for x in pa]
  cmd=pa+['-E','-P',sr];p=subprocess.run(cmd,cwd=c['cwd'],capture_output=True,text=True);assert p.returncode==0,p.stderr;(d/(label+'.preprocessed.c')).write_text(p.stdout);pp[label]={'argv':cmd,'exit_code':p.returncode,'sha256':hashlib.sha256(p.stdout.encode()).hexdigest(),'normalized_token_sha256':hashlib.sha256(re.sub(r'\s+','',p.stdout).encode()).hexdigest()}
 assert pp['old']['normalized_token_sha256']==pp['format']['normalized_token_sha256']
 rec={'bits':c['bits'],'optimization':c['optimization'],'unit':'compact','source':source,'object':str(obj),'argv':argv,'shell_command':shlex.join(argv),'cwd':c['cwd'],'token_changes':changes,'preprocessor_comparison':pp};new['commands'].append(rec)
 with (d/'compact.compile.log').open('w') as f:rc=subprocess.run(argv,cwd=c['cwd'],stdout=f,stderr=subprocess.STDOUT).returncode
 rec['exit_code']=rc;(R/'build-status.json').write_text(json.dumps(new,indent=2)+'\n');print(c['bits'],c['optimization'],'compact exit',rc,flush=True)
 if rc:continue
 rec['object_sha256']=hashlib.sha256(obj.read_bytes()).hexdigest();rec['object_bytes']=obj.stat().st_size
 for suffix,tool,flags in [('elf-header.txt','readelf',['-h','-A']),('symbols.txt','nm',['-S','--size-sort']),('sections.txt','readelf',['-SW']),('relocations.txt','objdump',['-r']),('unresolved.txt','nm',['-u']),('size.txt','size',[])]:
  (d/('compact.'+suffix)).write_text(subprocess.check_output([str(BIN/('xtensa-esp32s3-elf-'+tool)),*flags,str(obj)],text=True))
 head=(d/'compact.elf-header.txt').read_text();assert re.search(r'Machine:\s*.*Xtensa',head,re.I) and re.search(r'Type:\s*REL\b',head)
 proc=subprocess.run([str(BIN/'xtensa-esp32s3-elf-objdump'),'-d','--no-show-raw-insn',str(obj)],capture_output=True,text=True);assert proc.returncode==0 and re.search(r'^[0-9a-f]+ <[^>]+>:',proc.stdout,re.M) and re.search(r'^\s*[0-9a-f]+:\s+[a-z]',proc.stdout,re.M);(d/'compact.scanner-input.txt').write_text(proc.stdout);rec['nonempty_xtensa_disassembly_preflight']=True
 flags=[f for line in (d/'compact.symbols.txt').read_text().splitlines() if len(line.split())==4 and line.split()[2] in ('t','T') for f in ('-j','.text.'+line.split()[3])]
 (d/'compact.instructions.txt').write_text(subprocess.check_output([str(BIN/'xtensa-esp32s3-elf-objdump'),'-dlrwC',*flags,str(obj)],text=True))
 scanner=OLD/'source/target-probe/scanner/frame_lint.py';p=subprocess.run(['python3',str(scanner),'--objdump',str(BIN/'xtensa-esp32s3-elf-objdump'),str(obj)],capture_output=True,text=True);assert p.returncode==0 and not p.stderr and 'SKIPPED' not in p.stdout;(d/'compact.frame-lint.txt').write_text(p.stdout);rec['heuristic_scanner_exit']=p.returncode
 dep=d/'compact.full.d';cmd=base+['-M','-MF',str(dep),'-MT','compact',source];subprocess.run(cmd,cwd=c['cwd'],capture_output=True,check=True);closure={}
 for p in shlex.split(dep.read_text().replace('\\\n',' ').split(':',1)[1]):
  p=Path(p);p=(p if p.is_absolute() else Path(c['cwd'])/p).resolve();assert p.is_file();assert str(OLD_CAP) not in str(p);closure[str(p)]={'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size}
 (d/'compact.dependency-hashes.json').write_text(json.dumps(closure,indent=2)+'\n');rec['dependency_argv']=cmd;rec['dependency_count']=len(closure)
 (R/'build-status.json').write_text(json.dumps(new,indent=2)+'\n')
(R/'build-status.json').write_text(json.dumps(new,indent=2)+'\n')
