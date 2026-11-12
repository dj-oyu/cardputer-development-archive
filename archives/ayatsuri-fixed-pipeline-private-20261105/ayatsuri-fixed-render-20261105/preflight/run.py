from pathlib import Path
import json,subprocess,hashlib,numpy as np
W=Path('/workspace/scratch/6d8dcdbcdc54');D=Path(__file__).parent.resolve();B=W/'fox-v3-indexed-bvh-bounds/actual-on-001';A=W/'fox-v3-floor-direct-reflection-evaluation/actual-002';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert not (D/'RESULT.json').exists(), "Fresh output directory required; do not overwrite a completed diagnostic"
rows=[]
for kind in ['baseline','q16','q20']:
 for view in ['front','oblique']:
  saved=B/f'native-{view}-baseline';c=json.loads(Path(str(saved)+'.command.json').read_text());model=A/'compiled/model-baseline/model.aynm' if kind=='baseline' else W/f'ayatsuri-fixed-pipeline-20261105/bridge/private/model-{kind}-geometry.aynm';out=D/f'{kind}-{view}'
  cmd=[str(D/'geometry-preflight'),str(model),str(out),c['environment']['HONE_DISK_FILE'],*c['command'][4:],c['environment']['HONE_GROUND_FILE']]
  assert len(cmd)==20
  (D/f'{kind}-{view}.command.json').write_text(json.dumps({'command':cmd,'modelSHA256':sha(model),'binarySHA256':sha(D/'geometry-preflight')},indent=2))
  subprocess.run(cmd,check=True)
  g=json.loads(Path(str(out)+'.geometry.json').read_text());g.update(kind=kind,view=view)
  if kind=='baseline':
   for suffix,old in [('.snapshot','.snapshot'),('.targets.u8','.targets.u8'),('.center-depth.f32le','.f32le')]:assert Path(str(out)+suffix).read_bytes()==Path(str(saved)+old).read_bytes(),(view,suffix)
   aa=json.loads(Path(str(saved)+'.aa.json').read_text());assert g['targets']==aa['targets'];assert g['hits'][1:]==aa['sampleHits'];assert g['centerUpdates']==aa['centerShades']
   # Compare all final quarter hits with previously saved physical sample evidence.
   sample=W/f'fox-v3-floor-world-reflection/capture/on/native-{view}-baseline.samples.jsonl'
   old={(r['x'],r['y'],r['sample']):r for r in map(json.loads,sample.open()) if r['hit']}
   new=[r for r in map(json.loads,Path(str(out)+'.events.jsonl').open()) if r['phase']]
   assert len(old)==len(new)
   for r in new:
    o=old[(r['x'],r['y'],r['phase']-1)]
    for k in ['recordOffset','node','face','sourceId','back','depth','P','Ns','rho']:assert r[k]==o[k],(view,k,r,o)
   g['exactBaselineSnapshotMaskDepthHitsAndEvents']=True
  for suffix in ['.snapshot','.targets.u8','.center-depth.f32le','.center-source.u16le','.events.jsonl','.world-vertices.f64le','.world-triangles.u32le']:g[suffix+'SHA256']=sha(Path(str(out)+suffix))
  rows.append(g);print(kind,view,'targets',g['targets'],'hits',g['hits'],'updates',g['centerUpdates'],flush=True)
 # Baseline entire validation completes before candidates are attempted.
 (D/'RESULT.json').write_text(json.dumps({'status':'BASELINE_VERIFIED' if kind=='baseline' else 'CANDIDATE_GEOMETRY_DERIVED','rows':rows},indent=2)+'\n')
# Logical winner differences, ignoring depth, and target/coverage changes.
for r in rows[2:]:
 p=D/f"{r['kind']}-{r['view']}";base=D/f"baseline-{r['view']}";r['delta']={}
 for suffix,dtype in [('.targets.u8','u1'),('.center-source.u16le','<u2'),('.winner-records.u16le','<u2'),('.winner-faces.u8','u1')]:
  a=np.fromfile(str(p)+suffix,dtype=dtype);b=np.fromfile(str(base)+suffix,dtype=dtype);r['delta'][suffix]=int(np.count_nonzero(a!=b))
 r['logicalWinnerChangesByPhase']=[]
 a=np.fromfile(str(p)+'.winner-records.u16le',dtype='<u2').reshape(5,-1);b=np.fromfile(str(base)+'.winner-records.u16le',dtype='<u2').reshape(5,-1);af=np.fromfile(str(p)+'.winner-faces.u8',dtype='u1').reshape(5,-1);bf=np.fromfile(str(base)+'.winner-faces.u8',dtype='u1').reshape(5,-1)
 r['logicalWinnerChangesByPhase']=[int(np.count_nonzero((a[i]!=b[i])|(af[i]!=bf[i]))) for i in range(5)]
(D/'RESULT.json').write_text(json.dumps({'status':'CONTROL_EXACT_AND_SIX_GEOMETRY_PREFLIGHTS_COMPLETE','rows':rows},indent=2)+'\n')
