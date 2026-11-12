"""Fresh immutable inputs plus external core/contract pins. No rendering."""
from pathlib import Path
import sys,json,hashlib,shutil,subprocess
R=Path(__file__).resolve().parents[1];W=R.parent;B=W/'fox-v3-lid-evaluation/actual-lid8-v2';A=W/'fox-v3-boundary-rho-affine-evaluation/actual-A2';CORE=W/'fox-v3-camera-background-core';P=W/'fox-v3-camera-background-plan'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert len(sys.argv)==4;D=Path(sys.argv[1]).resolve();assert D.parent==R and not D.exists();assert sha(CORE/'INTEGRATION_SOURCE_FREEZE.json')==sys.argv[2];cf=json.load(open(CORE/'INTEGRATION_SOURCE_FREEZE.json'));assert all(sha(CORE/k)==h for k,h in cf['files'].items());assert sha(P/'PREIMPLEMENTATION_FREEZE.json')==sys.argv[3];pf=json.load(open(P/'PREIMPLEMENTATION_FREEZE.json'));assert all(sha(P/k)==h for k,h in pf['files'].items())
sys.path.insert(0,str(B/'code'));from geometry_certificate import verify
oldmanifest=json.load(open(B/'candidate-manifest.json'));cert=verify(B,oldmanifest['geometryCertificateSHA256']);assert cert['counts']['triangles']==1564
D.mkdir()
for name in ['compiled','inputs','scoring']:
 shutil.copytree(B/name,D/name,ignore=shutil.ignore_patterns('__pycache__','*.log'))
for name in ['product','transport','visibility','physical','background']:
 shutil.copytree(CORE/name,D/name,ignore=shutil.ignore_patterns('__pycache__','*.log','*.o','*.su'))
shutil.copytree(B/'code',D/'code',ignore=shutil.ignore_patterns('__pycache__','*.log'))
for p in (R/'code').glob('*'):
 if p.is_file():shutil.copyfile(p,D/'code'/p.name)
shutil.copytree(R/'private',D/'private')
for name in ['identity-proof.json','ledger-contract.json','PREFLIGHT_CONTRACT.json','ledger-front.txt','ledger-oblique.txt']:
 shutil.copyfile(A/name,D/name)
shutil.copyfile(P/'CORE-WORK-DESIGN.json',D/'CORE-WORK-DESIGN.json');shutil.copyfile(CORE/'INTEGRATION_SOURCE_FREEZE.json',D/'CORE_SOURCE_FREEZE.json');shutil.copyfile(P/'PREIMPLEMENTATION_FREEZE.json',D/'PLAN_FREEZE.json')
folders=['code','product','transport','visibility','physical','background','compiled','inputs','scoring','private'];files=[p for name in folders for p in (D/name).rglob('*') if p.is_file()]+[p for p in D.glob('*') if p.is_file()];pins={str(p.relative_to(D)):sha(p) for p in files};(D/'input-hashes.json').write_text(json.dumps(pins,indent=2)+'\n')
main=D/'product/main';flags=['-std=c11','-O2','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffp-contract=off','-fexcess-precision=standard'];sources=['code/native_render.c','code/scene_transport_bridge.c','background/background.c','transport/bounce.c','visibility/visibility.c','visibility/pixel_binding.c','physical/fox_disk_lighting.c'];cmd=['cc',*flags,'-I',str(main),*[x for name in ['physical','visibility','transport','background','private','code'] for x in ['-I',str(D/name)]],*[str(D/p) for p in sources],*[str(main/p) for p in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',str(D/'native-render')]
with (D/'build.log').open('w') as f:subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,check=True)
assert all(sha(D/p)==h for p,h in pins.items());(D/'PREPARED.json').write_text(json.dumps({'coreFreezeSHA256':sys.argv[2],'planFreezeSHA256':sys.argv[3],'baselineGeometryCertificateSHA256':oldmanifest['geometryCertificateSHA256'],'flags':flags,'binarySHA256':sha(D/'native-render'),'inputsSHA256':sha(D/'input-hashes.json'),'status':'BUILT_NOT_RENDERED','oldWork8MFit':False,'oldDirect1MFit':False,'geometryAndFormalReferenceUnchanged':True},indent=2)+'\n');print(D)
