"""Build only. Never invokes the renderer; build is not execution authorization."""
from pathlib import Path
import subprocess,json,hashlib,datetime,sys
R=Path(__file__).resolve().parents[1];W=R.parent;observe='--no-observer' not in sys.argv;B=R/('build-adapter' if observe else 'build-product');B.mkdir(exist_ok=True)
P=R/'private-build';V37=W/'fox-v3-floor-direct-reflection-evaluation/actual-002';V38=W/'fox-v3-camera-background-evaluation/actual-002';PROFILE=W/'fox-v3-profile-integration-feasibility/build-private'
flags=['-std=c11','-O2','-g','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-Wno-unused-function','-ffp-contract=off','-fexcess-precision=standard','-fstack-usage']
if observe:flags+=['-DROW_HDR_OBSERVER=1']
inc=[R/'harness',R/'code',P/'product/main',P/'product/main/ui/kasane',P/'physical',P/'visibility',P/'transport',P/'background',V37/'private',V37/'code',V38/'private',PROFILE]
sources=[R/'harness/native_render_row.c',R/'harness/row_transport_bridge.c',R/'harness/profile_bridge.c',*[P/p for p in ['background/background.c','transport/bounce.c','visibility/visibility.c','visibility/pixel_binding.c','physical/fox_disk_lighting.c','product/main/ayatsuri/ayatsuri_model.c','product/main/ayatsuri/ayatsuri_visibility.c','product/main/ayatsuri/compact_opaque.c','product/main/ui/kasane/ksn_mesh_depth.c','product/main/ui/kasane/ksn_procedural.c']]]
if observe:sources.append(R/'harness/hdr_observer.c')
commands=[];objects=[];deps=set()
try:
 with (B/'build.log').open('w') as log:
  for i,src in enumerate(sources):
   obj=B/(src.stem+'.o'); dep=B/(src.stem+'.d');objects.append(obj)
   cmd=['cc',*flags,*[x for p in inc for x in ['-I',str(p)]],'-MMD','-MF',str(dep),'-c',str(src),'-o',str(obj)];commands.append(cmd);subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT,check=True)
   deps.update(Path(x) for x in dep.read_text().replace('\\\n',' ').split(':',1)[1].split())
  cmd=['cc',*[str(p) for p in objects],'-lm','-o',str(B/'native-render')];commands.append(cmd);subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT,check=True)
except Exception:
 (B/'commands.json').write_text(json.dumps(commands,indent=2)+'\n');raise
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
manifest={'status':'BUILT_NOT_RENDERED','actualFrames':0,'observedAtUTC':datetime.datetime.now(datetime.timezone.utc).isoformat(),'flags':flags,'commands':commands,'files':{str(p.relative_to(W)):sha(p) for p in sorted(deps)},'binarySHA256':sha(B/'native-render'),'stackFiles':{p.name:sha(p) for p in B.glob('*.su')},'executionGate':'Independent review and full named stack validation REQUIRED'}
(B/'BUILD.json').write_text(json.dumps(manifest,indent=2)+'\n');(B/'commands.json').write_text(json.dumps(commands,indent=2)+'\n');print('BUILT_NOT_RENDERED')
