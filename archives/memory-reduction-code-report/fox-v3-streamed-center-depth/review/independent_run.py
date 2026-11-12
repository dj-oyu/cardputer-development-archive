from pathlib import Path
import subprocess,os,json,hashlib
R=Path(__file__).resolve().parents[1];W=R.parent;P=R/'private-build';D=R/'review/independent-build';D.mkdir(exist_ok=True)
records=[]
for san in [False,True]:
 flags=['-std=c11','-O2','-g','-ffp-contract=off','-fexcess-precision=standard','-DFAST_BITS=0','-DGATHER=1','-ffunction-sections','-fdata-sections']+(['-fsanitize=address,undefined','-fno-omit-frame-pointer'] if san else [])
 inc=[R/'cache',R/'harness',R/'code',P/'product/main',P/'product/main/ui/kasane',P/'physical',W/'fox-v3-lossless-profile-lut/profile/private']
 tag='san' if san else 'normal';oracle=D/('raw-'+tag+'.o')
 def run(name,cmd):
  e={**os.environ,'ASAN_OPTIONS':'detect_leaks=0','UBSAN_OPTIONS':'halt_on_error=1'}
  p=subprocess.run(list(map(str,cmd)),capture_output=True,text=True,env=e);(D/(name+'.log')).write_text(p.stdout+p.stderr);records.append({'name':name,'command':list(map(str,cmd)),'returncode':p.returncode,'output':p.stdout});print(name,p.returncode,flush=True);p.check_returncode()
 run('oracle-'+tag,['cc',*flags,'-Dagx_profile_eval=raw_profile_eval','-c',W/'fox-v3-profile-integration-feasibility/build-private/agx_profile.c','-o',oracle])
 out=D/('independent-exact-'+tag)
 sources=[R/'review/independent_exact.c',P/'product/main/ui/kasane/ksn_mesh_depth.c',P/'product/main/ayatsuri/compact_opaque.c',P/'physical/fox_disk_lighting.c',R/'harness/profile_bridge.c',R/'cache/block_cache.c',R/'cache/block_decoder.c']
 run('build-'+out.name,['cc',*flags,*['-I'+str(p) for p in inc],*sources,oracle,'-Wl,--gc-sections','-Wl,--wrap=agx_cache_profile_eval','-lm','-o',out]);run(out.name,[out])
files=[R/'review/independent_exact.c',R/'review/independent_generate.py',Path(__file__),*sources[1:],R/'code/ksn_stream_depth.h',R/'code/ksn_stream_depth_impl.inc',R/'harness/stream_depth_alloc.h']
(R/'review/INDEPENDENT_SYNTHETIC.json').write_text(json.dumps({'status':'PASS','actualFrames':0,'records':records,'sourcePins':{str(p.relative_to(R)):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}},indent=2)+'\n')
