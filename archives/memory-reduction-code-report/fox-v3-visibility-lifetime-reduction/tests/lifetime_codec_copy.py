from pathlib import Path
import subprocess,os,json
R=Path(__file__).resolve().parents[1];D=R/'tests/lifetime-results';D.mkdir(exist_ok=True)
P=R/'private-build';main=P/'product/main'
sources=[R/'tests/lifetime_codec_copy.c',main/'ui/kasane/ksn_mesh_depth.c',main/'ui/kasane/ksn_procedural.c',main/'ayatsuri/compact_opaque.c',P/'physical/fox_disk_lighting.c']
results=[]
for opt in ['O0','O2']:
 for san in [False,True]:
  mode='codec-'+opt+('-asan-ubsan' if san else '')
  cmd=['cc','-std=c11','-'+opt,'-g','-DFAST_BITS=0','-DGATHER=1','-ffunction-sections','-fdata-sections','-I'+str(main),'-I'+str(main/'ui/kasane'),'-I'+str(R/'code'),'-I'+str(P/'physical'),*map(str,sources),'-Wl,--gc-sections','-lm','-o',str(D/mode)]
  if san:cmd+=['-fsanitize=address,undefined','-fno-omit-frame-pointer']
  p=subprocess.run(cmd,capture_output=True,text=True);(D/(mode+'-build.log')).write_text(p.stdout+p.stderr);p.check_returncode()
  run=subprocess.run([str(D/mode)],capture_output=True,text=True,env={**os.environ,'ASAN_OPTIONS':'detect_leaks=0:halt_on_error=1','UBSAN_OPTIONS':'halt_on_error=1'})
  (D/(mode+'.log')).write_text(run.stdout+run.stderr);run.check_returncode()
  results.append({'mode':mode,'command':cmd,'result':run.stdout.strip()});print(mode,run.stdout.strip(),flush=True)
(D/'codec-results.json').write_text(json.dumps({'status':'PASS','actual_frames':0,'results':results},indent=2)+'\n')
