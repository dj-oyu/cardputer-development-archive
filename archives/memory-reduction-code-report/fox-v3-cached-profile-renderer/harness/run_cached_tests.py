"""Synthetic only. Original u16 profile is linked solely into test binaries."""
from pathlib import Path
import subprocess,os,json
R=Path(__file__).resolve().parents[1];W=R.parent;P=R/'private-build';D=R/'cache-tests';D.mkdir(exist_ok=True)
records=[]
for san in [False,True]:
 flags=['-std=c11','-O2','-g','-ffp-contract=off','-fexcess-precision=standard','-DFAST_BITS=0','-DGATHER=1','-ffunction-sections','-fdata-sections']+(['-fsanitize=address,undefined','-fno-omit-frame-pointer'] if san else [])
 inc=[R/'cache',R/'harness',R/'code',P/'product/main',P/'product/main/ui/kasane',P/'physical',W/'fox-v3-lossless-profile-lut/profile/private']
 tag='san' if san else 'normal';oracle=D/('raw-'+tag+'.o')
 def run(name,cmd):
  e={**os.environ,'ASAN_OPTIONS':'detect_leaks=0','UBSAN_OPTIONS':'halt_on_error=1'}
  p=subprocess.run(list(map(str,cmd)),capture_output=True,text=True,env=e);(D/(name+'.log')).write_text(p.stdout+p.stderr);records.append({'name':name,'command':list(map(str,cmd)),'returncode':p.returncode,'output':p.stdout});print(name,p.returncode,flush=True);p.check_returncode()
 run('oracle-'+tag,['cc',*flags,'-Dagx_profile_eval=raw_profile_eval','-c',W/'fox-v3-profile-integration-feasibility/build-private/agx_profile.c','-o',oracle])
 for test in ['test_cached_exact','test_cache_contract']:
  out=D/(test+'-'+tag)
  sources=[R/'harness'/f'{test}.c',P/'product/main/ui/kasane/ksn_mesh_depth.c',P/'product/main/ayatsuri/compact_opaque.c',P/'physical/fox_disk_lighting.c',R/'harness/profile_bridge.c',R/'cache/block_cache.c',R/'cache/block_decoder.c']
  run('build-'+out.name,['cc',*flags,*['-I'+str(p) for p in inc],*sources,oracle,'-Wl,--gc-sections',*(['-Wl,--wrap=agx_cache_profile_eval'] if test=='test_cached_exact' else []),'-lm','-o',out]);run(out.name,[out])
(R/'CACHED_SYNTHETIC_RESULTS.json').write_text(json.dumps({'status':'PASS','actualFrames':0,'records':records},indent=2)+'\n')
