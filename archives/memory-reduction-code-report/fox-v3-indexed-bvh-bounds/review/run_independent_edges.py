from pathlib import Path
import subprocess,json,os,hashlib
R=Path(__file__).resolve().parent
results=[]
for opt in ['O0','O2']:
 for san in [False,True]:
  mode=opt+('-san' if san else '')
  outputs=[]
  for baseline in [True,False]:
   label='edges-'+mode+('-baseline' if baseline else '-candidate')
   cmd=['cc','-std=c11','-'+opt,'-g','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffp-contract=off','-fexcess-precision=standard']
   if san:cmd+=['-fsanitize=address,undefined','-fno-omit-frame-pointer']
   if baseline:cmd+=['-DBASELINE']
   cmd+=[str(R/'test_independent_edges.c'),'-lm','-o',str(R/label)]
   subprocess.run(cmd,check=True)
   run=subprocess.run([str(R/label)],text=True,capture_output=True,env={**os.environ,'ASAN_OPTIONS':'detect_leaks=0','UBSAN_OPTIONS':'halt_on_error=1'})
   (R/(label+'.log')).write_text(run.stdout+run.stderr);run.check_returncode();outputs.append(run.stdout)
   print(label,run.stdout.strip(),flush=True)
   results.append({'label':label,'command':cmd,'fingerprint':run.stdout.strip(),'status':'PASS'})
  assert outputs[0]==outputs[1],mode+' differential mismatch'
(R/'INDEPENDENT_EDGES.json').write_text(json.dumps({'status':'PASS','scenesPerBuild':25,'invalidCoordinates':63,'invalidIndices':4,'modes':['all8 signedzero permutations on each of3 axes','exact accepted +/-1e50','NaN infinities DBL_MAX and first beyond1e50 rejected with old retained scene unchanged'],'results':results,'testSHA256':hashlib.sha256((R/'test_independent_edges.c').read_bytes()).hexdigest(),'candidateSHA256':hashlib.sha256((R.parent/'private-build/visibility/visibility.c').read_bytes()).hexdigest(),'LSAN':'disabled in ptrace environment; tracked allocation coverage separate'},indent=2)+'\n')
