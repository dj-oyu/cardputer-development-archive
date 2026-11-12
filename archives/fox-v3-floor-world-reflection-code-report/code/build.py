from pathlib import Path
import subprocess,json,hashlib,difflib
R=Path(__file__).resolve().parents[1];W=R.parent;D=R/'capture';OLD=W/'fox-v3-floor-display-combination/capture-001';sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
base=json.load(open(R/'BASELINE_PINS.json'));assert all(sha(OLD/p)==h for p,h in base['files'].items())
flags=json.load(open(D/'PREPARED.json'))['flags']+['-DFOX_FLOOR_WORLD_CAPTURE=1','-fstack-usage'];main=D/'product/main';src=['transport/bounce.c','transport/pixel_transport.c','visibility/visibility.c','visibility/pixel_binding.c','physical/fox_disk_lighting.c'];msrc=['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c'];cmd=['cc',*flags,'-I',str(main),'-I',str(D/'physical'),'-I',str(D/'visibility'),'-I',str(D/'transport'),'-I',str(D/'private'),str(D/'code/native_render_v2.c'),*[str(D/p) for p in src],*[str(main/p) for p in msrc],'-lm','-o',str(D/'native-render')]
with (D/'build.log').open('w') as f:subprocess.run(cmd,cwd=D,stdout=f,stderr=subprocess.STDOUT,check=True)
files=[p for folder in ['product','transport','visibility','physical','compiled','inputs','code','private'] for p in (D/folder).rglob('*') if p.is_file() and '__pycache__' not in str(p)]+[D/f'ledger-{v}.txt' for v in ['front','oblique']];pins={str(p.relative_to(D)):sha(p) for p in files}
changes={}
for path,h in pins.items():
 if path in base['files'] and h!=base['files'][path]:changes[path]=''.join(difflib.unified_diff((OLD/path).read_text().splitlines(True),(D/path).read_text().splitlines(True),fromfile='completed/'+path,tofile='floor-world/'+path))
(R/'SOURCE_DIFF.json').write_text(json.dumps(changes,indent=2)+'\n')
obj={'status':'BUILT_NOT_FULL_RENDERED','baselineSourceFreezeSHA256':base['sourceFreezeSHA256'],'files':pins,'binarySHA256':sha(D/'native-render'),'flags':flags,'differences':list(changes),'newFiles':[p for p in pins if p not in base['files']],'baseInputsUnchanged':True};(D/'SOURCE_FREEZE.json').write_text(json.dumps(obj,indent=2)+'\n');print(sha(D/'SOURCE_FREEZE.json'))
