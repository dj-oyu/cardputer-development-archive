from pathlib import Path
import subprocess,os,json,hashlib
R=Path(__file__).resolve().parents[1];D=R/'test-results';D.mkdir(exist_ok=True);rows=[]
env={**os.environ,'ASAN_OPTIONS':'detect_leaks=0','UBSAN_OPTIONS':'halt_on_error=1'}
for opt in ['O0','O2']:
 for san in [False,True]:
  mode=opt+('-asan-ubsan' if san else '');d=D/mode;d.mkdir(exist_ok=True)
  for name in ['capacity','visibility','nearest','bruteforce']:
   src=R/('tests/test_capacity.c' if name=='capacity' else 'private-build/visibility/test_'+name+'.c');extra=[] if name in ['capacity','visibility'] else [R/'private-build/visibility/visibility.c']
   flags=['-std=c11','-'+opt,'-g','-ffp-contract=off','-fexcess-precision=standard']+(['-fsanitize=address,undefined','-fno-omit-frame-pointer'] if san else [])
   cmd=['cc',*flags,str(src),*map(str,extra),'-lm','-o',str(d/name)];subprocess.run(cmd,check=True)
   p=subprocess.run([str(d/name)],capture_output=True,text=True,env=env);(d/(name+'.log')).write_text(p.stdout+p.stderr);p.check_returncode();rows.append({'mode':mode,'test':name,'status':'PASS','command':cmd});print(mode,name,'PASS',flush=True)
(D/'RESULTS.json').write_text(json.dumps({'status':'PASS','actualFrames':0,'results':rows,'LSAN':'Disabled due unsupported ptrace environment; explicit allocation/poison/free accounting remains active.','sourceHashes':{str(p.relative_to(R)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [R/'private-build/visibility/visibility.c',R/'private-build/visibility/visibility.h',*sorted((R/'tests').glob('*'))] if p.is_file()}},indent=2)+'\n')
