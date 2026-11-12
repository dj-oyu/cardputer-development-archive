from pathlib import Path
import subprocess,os,json,hashlib,datetime
R=Path(__file__).resolve().parents[1];D=R/'test-results';D.mkdir(exist_ok=True);env={**os.environ,'ASAN_OPTIONS':'detect_leaks=0','UBSAN_OPTIONS':'halt_on_error=1'};results=[]
for opt in ['O0','O2']:
 for san in [False,True]:
  mode=opt+('-asan-ubsan' if san else '');folder=D/mode;folder.mkdir(exist_ok=True)
  flags=['-std=c11','-'+opt,'-g','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffp-contract=off','-fexcess-precision=standard']+(['-fsanitize=address,undefined','-fno-omit-frame-pointer'] if san else [])
  tests=[('capacity',R/'tests/test_capacity.c',[]),('visibility',R/'private-build/visibility/test_visibility.c',[]),('nearest',R/'private-build/visibility/test_nearest.c',[R/'private-build/visibility/visibility.c']),('bruteforce',R/'private-build/visibility/test_bruteforce.c',[R/'private-build/visibility/visibility.c']),('semantics-v3',R/'tests/test_semantics.c',[]),('semantics-v2',R/'tests/test_semantics.c',['-DBASELINE'])]
  for name,source,extra in tests:
   binary=folder/name;cmd=['cc',*flags,str(source),*map(str,extra),'-lm','-o',str(binary)];subprocess.run(cmd,check=True);p=subprocess.run([str(binary)],env=env,capture_output=True,text=True);(folder/(name+'.log')).write_text(p.stdout+p.stderr);p.check_returncode();results.append({'mode':mode,'name':name,'status':'PASS','command':cmd,'output':p.stdout.strip()});print(mode,name,'PASS',flush=True)
  assert (folder/'semantics-v2.log').read_bytes()==(folder/'semantics-v3.log').read_bytes()
  (D/'CHECKPOINT.json').write_text(json.dumps({'status':'RUNNING','results':results},indent=2)+'\n')
(D/'RESULTS.json').write_text(json.dumps({'status':'ALL_PASS','observedAtUTC':datetime.datetime.now(datetime.timezone.utc).isoformat(),'results':results,'semanticFingerprintExactAllModes':True,'LSAN':'Disabled because ptrace environment unsupported; capacity and original ownership tests independently assert zero live allocation balance.','sourceHashes':{str(p.relative_to(R)):hashlib.sha256(p.read_bytes()).hexdigest() for p in [R/'private-build/visibility/visibility.c',R/'private-build/visibility/visibility.h',*sorted((R/'tests').glob('*'))] if p.is_file()}},indent=2)+'\n')
