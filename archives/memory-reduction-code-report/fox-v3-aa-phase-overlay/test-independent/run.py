from pathlib import Path
import subprocess,os,json,hashlib
r=Path(__file__).resolve().parents[1]; t=r/'test-independent'; p=r/'private-build/product/main'; physical=r/'private-build/physical'
sources=[t/'test_segmented.c',p/'ayatsuri/ayatsuri_model.c',p/'ayatsuri/ayatsuri_visibility.c',physical/'fox_disk_lighting.c']
results=[]
for mode in ['O2-N5','O2-asan-ubsan-N5','O2-N55','O2-asan-ubsan-N55','O2-N256','O2-asan-ubsan-N256']:
 flags=['-std=c11','-O2','-g','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffp-contract=off','-fexcess-precision=standard','-I'+str(p),'-I'+str(physical)]
 if 'asan' in mode:flags+=['-fsanitize=address,undefined','-fno-omit-frame-pointer']
 flags+=['-DN='+mode.split('N')[-1]]
 binary=t/mode
 cmd=['cc',*flags,*map(str,sources),'-lm','-o',str(binary)];subprocess.run(cmd,check=True)
 run=subprocess.run([str(binary)],capture_output=True,text=True,env=dict(os.environ,ASAN_OPTIONS='detect_leaks=0:abort_on_error=1',UBSAN_OPTIONS='halt_on_error=1:print_stacktrace=1'));(t/(mode+'.log')).write_text(run.stdout+run.stderr);print(mode,run.stdout+run.stderr,flush=True);run.check_returncode();results.append(dict(mode=mode,output=run.stdout,command=cmd))
(t/'RESULTS.json').write_text(json.dumps(dict(results=results,LSan='disabled; environment restriction, not a leak-clean claim',source_hashes={str(x.relative_to(r)):hashlib.sha256(x.read_bytes()).hexdigest() for x in sources+[t/'run.py',r/'harness/model_arena_owner.h',p/'ui/kasane/ksn_procedural.h']+list((p/'ayatsuri').glob('*.h'))+list(physical.glob('*.h'))}),indent=2)+'\n')
