"""Compile-only probe, deliberately requires an already installed S3 toolchain.
No install, link, target execution, firmware build, profile substitution or CI edit.
"""
import argparse,pathlib,subprocess,json,hashlib,os,re,sys
P=pathlib.Path(__file__).resolve().parent
ap=argparse.ArgumentParser(description=__doc__)
ap.add_argument('--compiler',required=True,help='Absolute path to installed xtensa-esp32s3-elf-gcc')
ap.add_argument('--objdump',required=True,help='Absolute path to matching installed Xtensa objdump')
ap.add_argument('--readelf',required=True,help='Absolute path to matching installed Xtensa readelf')
ap.add_argument('--toolchain-evidence',required=True,help='Existing text/JSON identifying S3 core, ABI, compiler package and provenance; recorded, not guessed')
a=ap.parse_args();env=dict(os.environ,LC_ALL='C');commands=[]
def run(cmd):
 p=subprocess.run(cmd,capture_output=True,text=True,env=env);commands.append(dict(argv=cmd,returncode=p.returncode))
 if 'frame_lint.py' in ' '.join(cmd) and p.stderr:raise RuntimeError('Scanner diagnostics cannot be treated as a clean result: '+p.stderr)
 if p.returncode:raise RuntimeError('Command failed: '+repr(cmd)+'\n'+p.stderr)
 return p.stdout
for name in ['compiler','objdump','readelf']:
 f=pathlib.Path(getattr(a,name))
 if not f.is_absolute() or not f.is_file() or not os.access(f,os.X_OK):ap.error(name+' must name an existing absolute executable path; no installation is performed')
evidence=pathlib.Path(a.toolchain_evidence)
if not evidence.is_file():ap.error('missing toolchain provenance/configuration evidence')
# A unified xtensa-esp-elf toolchain may work but needs separately verified S3
# selection flags; this conservative capsule does not invent those flags.
target=run([a.compiler,'-dumpmachine']).strip()
if target!='xtensa-esp32s3-elf':ap.error('expected explicit xtensa-esp32s3-elf target; unified/other target configuration is not verified by this recipe')
manifest=json.loads((P/'capsule-manifest.json').read_text())
for name,h in manifest['copied_sha256'].items():
 if hashlib.sha256((P/'capsule'/name).read_bytes()).hexdigest()!=h:raise RuntimeError('Capsule source changed: '+name)
out=P/'target-results'
if out.exists():ap.error('target-results already exists; preserve it rather than overwriting')
out.mkdir();versions={n:run([getattr(a,n),'--version']) for n in ['compiler','objdump','readelf']}
(out/'toolchain-evidence.txt').write_bytes(evidence.read_bytes())
builtins=run([a.compiler,'-dM','-E','-x','c','/dev/null']);(out/'compiler-builtins.txt').write_text(builtins)
if '__XTENSA_WINDOWED_ABI__' not in builtins:raise RuntimeError('Windowed ABI not confirmed; entry-based scanner contract requires separate ABI review')
(out/'compiler-target-options.txt').write_text(run([a.compiler,'-Q','--help=target']))
# Documented upstream standalone flags + explicit C standard and measurement
# options. Not an ESP-IDF compile command and not asserted firmware-equivalent.
common=['-std=c11','-mlongcalls','-ffunction-sections','-fdata-sections','-fstrict-volatile-bitfields','-fstack-usage','-fno-lto']
rows=[]
for q in [16,20,24]:
 for opt in ['Os','O2']:
  d=out/f'q{q}-{opt}';d.mkdir()
  for name in manifest['units']:
   source=P/'capsule'/name;obj=d/(source.stem+'.o')
   run([a.compiler,*common,'-'+opt,f'-DMBITS={q}','-c',str(source),'-o',str(obj)])
   header=run([a.readelf,'-h',str(obj)]);(obj.with_suffix('.elf-header.txt')).write_text(header)
   if not re.search(r'Machine:\s*.*Xtensa',header,re.I) or not re.search(r'Type:\s*REL\b',header):raise RuntimeError('Not a verified Xtensa relocatable object: '+str(obj))
   dis=run([a.objdump,'-d','--no-show-raw-insn',str(obj)]);(obj.with_suffix('.disassembly.txt')).write_text(dis)
   if not re.search(r'^[0-9a-f]+ <[^>]+>:',dis,re.M) or not re.search(r'^\s*[0-9a-f]+:\s+[a-z]',dis,re.M):raise RuntimeError('No parseable disassembly; refusing an empty clean report')
   # Run upstream separately per object. Do not mix firmware baselines with this
   # standalone capsule, and do not combine Q variants by duplicate function name.
   scan=run([sys.executable,str(P/'scanner/frame_lint.py'),'--objdump',a.objdump,str(obj)])
   if 'SKIPPED' in scan:raise RuntimeError('Scanner skipped; no passing target result')
   obj.with_suffix('.frame-lint.txt').write_text(scan)
   rows.append(dict(bits=q,optimization=opt,translation_unit=name,object_sha256=hashlib.sha256(obj.read_bytes()).hexdigest(),scanner_report=str(obj.with_suffix('.frame-lint.txt').relative_to(P)),stack_usage=str(obj.with_suffix('.su').relative_to(P)),static_object_only=True))
(out/'manifest.json').write_text(json.dumps(dict(target=target,versions=versions,common_flags=common,commands=commands,objects=rows,scanner_sha256=hashlib.sha256((P/'scanner/frame_lint.py').read_bytes()).hexdigest(),not_final_ELF=True,not_cycle_counts=True,not_firmware_flag_parity=True,target_execution=False),indent=2)+'\n')
print('Completed 24 standalone objects. Static reports only; no final ELF, execution, firmware parity or cycle claim.')
