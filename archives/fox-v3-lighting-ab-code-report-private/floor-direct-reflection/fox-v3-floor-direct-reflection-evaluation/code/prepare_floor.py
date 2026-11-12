"""Fresh input/code snapshot only; compile after externally pinned core freeze."""
from pathlib import Path
import sys,json,hashlib,shutil,subprocess
R=Path(__file__).resolve().parents[1];W=R.parent;B=W/'fox-v3-lid-evaluation/actual-lid8-v2';arm='A';CORE=W/'fox-v3-floor-direct-reflection-core';P=W/'fox-v3-boundary-rho-affine-plan'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert len(sys.argv)==3;D=Path(sys.argv[1]).resolve();assert D.parent==R and not D.exists();freeze=CORE/'SOURCE_FREEZE.json';assert sha(freeze)==sys.argv[2];cf=json.loads(freeze.read_text());assert all(sha(CORE/k)==h for k,h in {**cf['productionFiles'],**cf['evidenceFiles']}.items())
oldmanifest=json.loads((B/'candidate-manifest.json').read_text());sys.path.insert(0,str(B/'code'));from geometry_certificate import verify
cert=verify(B,oldmanifest['geometryCertificateSHA256']);assert cert['counts']['triangles']==1564
D.mkdir();
for name in ['product','transport','visibility','physical','compiled','inputs','scoring']:
 shutil.copytree(B/name,D/name,ignore=shutil.ignore_patterns('__pycache__','*.log'))
for name in ['product','transport','visibility']:
 if (CORE/name).exists():shutil.copytree(CORE/name,D/name,dirs_exist_ok=True,ignore=shutil.ignore_patterns('__pycache__','*.log'))
shutil.copytree(B/'code',D/'code',ignore=shutil.ignore_patterns('__pycache__','*.log'))
for p in (R/'code').glob('*'):
 if p.is_file():shutil.copyfile(p,D/'code'/p.name)
shutil.copytree(R/'private',D/'private');shutil.copyfile(R/'private'/f'preflight-{arm}.h',D/'private/preflight.h');shutil.copyfile(R/'PREFLIGHT_CONTRACT.json',D/'PREFLIGHT_CONTRACT.json');shutil.copyfile(freeze,D/'CORE_SOURCE_FREEZE.json');shutil.copyfile(P/'PREIMPLEMENTATION_FREEZE.json',D/'PLAN_FREEZE.json');shutil.copyfile(W/'fox-v3-floor-direct-reflection-plan/PREIMPLEMENTATION_FREEZE.json',D/'FLOOR_PLAN_FREEZE.json')
ledgers=json.loads((W/'fox-v3-boundary-rho-affine-preflight/ledgers.json').read_text())[arm];keys=['legacyCenterReservation','centerIDInitialization','centerIDUpdateUpper','maskBytesClear','maskNeighborComparisons','bandHDRClear','sampleDepthWinnerClear','recordVisits','faceSetupAndVertexDecodeStages','bboxVisitAndMaskTest','targetEdgeDepthWinnerStages','finalSampleScan','finalHitShadingAndInterpolationUpper','finalPixelAverageEncodeWrite','sourceIdentityBindingValidationUpper','identityCombinadicMapClear','identityTableHashUpper','snapshotBindingHashUpper','controlUpper','counterGuardDispatchUpper','finalOutputPixelScan']
for view,z in ledgers.items():
 values=[z['ledger'][k] for k in keys];assert sum(values)==z['totalUpper']<=8000000;(D/f'ledger-{view}.txt').write_text(' '.join(map(str,values))+'\n')
shutil.copyfile(R/'identity-proof.json',D/'identity-proof.json');shutil.copyfile(W/'fox-v3-floor-direct-reflection-plan/SOURCE_RHO.json',D/'SOURCE_RHO.json');shutil.copyfile(W/'fox-v3-floor-direct-reflection-plan/WORKLOAD_BOUNDS.json',D/'WORKLOAD_BOUNDS.json');(D/'ledger-contract.json').write_text(json.dumps(ledgers,indent=2)+'\n')
files=[p for folder in ['code','product','transport','visibility','physical','compiled','inputs','scoring','private'] for p in (D/folder).rglob('*') if p.is_file()]+[D/f'ledger-{v}.txt' for v in ['front','oblique']]+[D/'FLOOR_PLAN_FREEZE.json',D/'SOURCE_RHO.json',D/'WORKLOAD_BOUNDS.json',D/'CORE_SOURCE_FREEZE.json',D/'PLAN_FREEZE.json',D/'identity-proof.json',D/'ledger-contract.json',D/'PREFLIGHT_CONTRACT.json']
pins={str(p.relative_to(D)):sha(p) for p in files};(D/'input-hashes.json').write_text(json.dumps(pins,indent=2)+'\n');main=D/'product/main';flags=['-std=c11','-O2','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffp-contract=off','-fexcess-precision=standard'];cmd=['cc',*flags,'-I',str(main),'-I',str(D/'physical'),'-I',str(D/'visibility'),'-I',str(D/'transport'),'-I',str(D/'private'),str(D/'code/native_render.c'),*[str(D/p) for p in ['transport/bounce.c','transport/pixel_transport.c','visibility/visibility.c','visibility/pixel_binding.c','physical/fox_disk_lighting.c']],*[str(main/p) for p in ['ayatsuri/ayatsuri_model.c','ayatsuri/ayatsuri_visibility.c','ayatsuri/compact_opaque.c','ui/kasane/ksn_mesh_depth.c','ui/kasane/ksn_procedural.c']],'-lm','-o',str(D/'native-render')]
with (D/'build.log').open('w') as f:subprocess.run(cmd,stdout=f,stderr=subprocess.STDOUT,check=True)
assert all(sha(D/p)==h for p,h in pins.items());(D/'PREPARED.json').write_text(json.dumps({'coreFreezeSHA256':sys.argv[2],'baselineGeometryCertificateSHA256':oldmanifest['geometryCertificateSHA256'],'flags':flags,'binarySHA256':sha(D/'native-render'),'inputsSHA256':sha(D/'input-hashes.json'),'status':'BUILT_NOT_RENDERED'},indent=2)+'\n');print(D)
