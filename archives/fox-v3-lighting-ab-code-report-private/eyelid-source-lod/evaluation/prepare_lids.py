from pathlib import Path
import shutil,json,subprocess,sys,ast
R=Path(__file__).resolve().parent;W=R.parent;S=W/'fox-v3-normal-pair-evaluation'
for name in ['code','product','inputs','physical','visibility','transport','scoring']:shutil.copytree(S/name,R/name,ignore=shutil.ignore_patterns('__pycache__'))
p=R/'code/codec_audit.py';s=p.read_text().replace("assert nv==1066 and nt==1414","assert nv==contract['counts']['vertices'] and nt==contract['counts']['triangles'];assert len(old)==contract['counts']['snapshotBytes'];assert sha_bytes(data)==contract['wireSnapshots'][key]['sha256']");p.write_text(s)
p=R/'code/geometry_certificate.py';s=p.read_text().replace("assert c['counts']['snapshotBytes']<=65536 and c['counts']['triangles']+2<=2048","assert c['counts']==contract['counts'];assert c['codecMode']==1;assert 416<=c['codecSnapshotBytes']<=65536 and c['counts']['triangles']+2<=2048\n assert len(contract['oldSnapshots'])==len(contract['wireSnapshots'])==20;assert contract['actualAppendAll20Passed'] is True\n assert contract['version']=='geometry-normal-pair-actual-append-v1'");p.write_text(s)
p=R/'scoring/score_candidate.py';s=p.read_text().replace('normal-pair-validator-v2-strict-integers','geometry-normal-pair-validator-v3-strict-integers');p.write_text(s)
getscore=lambda p:ast.dump(next(n for n in ast.parse(p.read_text()).body if isinstance(n,ast.FunctionDef) and n.name=='score'))
assert getscore(p)==getscore(S/'scoring/score_candidate.py')
from hashlib import sha256
sha=lambda p:sha256(p.read_bytes()).hexdigest()
for stage in [8,9]:
 result=json.loads((R/f'capacity-lid{stage}.json').read_text());assert result['all20AppendPass'];rows=result['rows'];counts=result['counts'];sizes={x['snapshotBytes'] for x in rows};m4={x['mode4'] for x in rows};m5={x['mode5'] for x in rows};assert len(sizes)==len(m4)==len(m5)==1
 contract={'version':'geometry-normal-pair-actual-append-v1','glbSHA256':result['glbSHA256'],'counts':counts,'actualAppendAll20Passed':True,'appendEvidenceSHA256':sha(R/f'capacity-lid{stage}.json'),'modes':{'1':{'snapshotBytes':sizes.pop(),'mode4Records':m4.pop(),'mode5Records':m5.pop()}},'oldSnapshots':{x['key']:{'sha256':x['sha256'],'fnv':x['fnv']} for x in rows},'wireSnapshots':{x['key']:{'sha256':x['wireSHA256']} for x in rows},'canonicalBytesAreDiagnosticOnly':True,'productFreezeSHA256':'230140690027b5a775c328c9a50ef9d5c68b44c345539b740eb2d482697b5a4a'}
 (R/'inputs/codec-contract.json').write_text(json.dumps(contract,indent=2))
 subprocess.run([sys.executable,str(R/'code/prepare_geometry.py'),'--glb',str(W/f'fox-v3-lid-source-lod/lid-{stage}.glb'),'--glb-sha256',result['glbSHA256'],'--codec-mode','1','--output',str(R/f'prepared-lid{stage}')],check=True)
 print('PIN',stage,sha(R/f'prepared-lid{stage}/inputs/geometry-certificate.json'),flush=True)
