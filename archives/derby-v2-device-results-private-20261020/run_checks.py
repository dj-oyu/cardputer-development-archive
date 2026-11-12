from pathlib import Path
import json,subprocess,sys,shutil,os,hashlib,time
v=sys.argv[1];root=Path('/workspace/derby-controller-'+v);out=Path('/workspace/derby-evidence/controller-split-20261020')/v
out.mkdir(parents=True,exist_ok=True)
for mode in ['fast','asan']:
 for detail in [False,True]:
  case=mode+('-on' if detail else '-off');d=out/case;cache=d/('build-'+mode+('-detail' if detail else '-off'));cache.mkdir(parents=True,exist_ok=True)
  prior=Path('/workspace/derby-evidence/exit-fix-'+mode)/(v+('-on' if detail else '-off'))/cache.name
  for name in ['dtoa','libregexp','libunicode','quickjs','quickjs-vm']:
   src=prior/(name+'.o')
   if not src.exists():raise FileNotFoundError(src)
   dest=cache/src.name;shutil.copy2(src,dest);os.utime(dest,None)
commands=[('lint',['git','diff','--check']),('fixed-integration',[sys.executable,'-B','tools/test_derby_fixed_integration.py']),('generation',[sys.executable,'-B','tools/test_derby_detail_generation.py']),('detail-accounting',[sys.executable,'-B','tools/test_derby_detail.py']),('detail-board',[sys.executable,'-B','tools/test_derby_detail_board.py']),('detail-proof',[sys.executable,'-B','tools/test_derby_detail_proof.py']),('diagnostic-proof',[sys.executable,'-B','tools/test_diagnostic_build.py']),('fixed-protocol',[sys.executable,'-B','tools/test_derby_fixed_protocol.py']),('fixed-controller',[sys.executable,'-B','tools/test_derby_fixed_workload.py'])]
for mode in ['fast','asan']:
 for detail in [False,True]:
  case=mode+('-on' if detail else '-off')
  cmd=[sys.executable,'-B','tools/games/run_derby_fixed.py','--out',str(out/case)]
  if mode=='fast':cmd+=['--detail-fast']
  if detail:cmd+=['--detail']
  commands.append((case,cmd))
 commands.append((mode+'-pair',[sys.executable,'-B','tools/games/check_derby_detail_pair.py','--off',str(out/(mode+'-off')),'--on',str(out/(mode+'-on')),'--out',str(out/(mode+'-pair.json'))]))
commands.append(('normal-host',[sys.executable,'-B','tools/games/run_derby.py','--heap-limit','524288']))
receipt={'variant':v,'root':str(root),'staged_tree':subprocess.check_output(['git','write-tree'],cwd=root,text=True).strip(),'hardware_operations':False,'checks':[],'all_pass':False}
for name,cmd in commands:
 start=time.time()
 with (out/(name+'.log')).open('wb') as f:r=subprocess.run(cmd,cwd=root,stdout=f,stderr=subprocess.STDOUT)
 receipt['checks'].append({'name':name,'command':cmd,'exit_code':r.returncode,'seconds':round(time.time()-start,3),'log_sha256':hashlib.sha256((out/(name+'.log')).read_bytes()).hexdigest()})
 (out/'HOST-CHECKS.json').write_text(json.dumps(receipt,indent=2)+'\n')
 print(json.dumps({'variant':v,'check':name,'exit_code':r.returncode}),flush=True)
 if r.returncode:raise SystemExit(r.returncode)
receipt['all_pass']=True;(out/'HOST-CHECKS.json').write_text(json.dumps(receipt,indent=2)+'\n')
