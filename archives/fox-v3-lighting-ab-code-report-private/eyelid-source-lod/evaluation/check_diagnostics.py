from pathlib import Path
import json,sys,numpy as np
R=Path(__file__).resolve().parent;sys.path.insert(0,str(R/'code'));from codec_audit import decode_snapshot,sha_bytes,fnv
rows=[]
for arm in ['eyeB','lid8','lid9']:
 b=R.parent/'fox-v3-normal-pair-evaluation/actual-on' if arm=='eyeB' else R/f'actual-{arm}-v2';cert=json.loads((b/'inputs/geometry-certificate.json').read_text());paths=[(R/f'density-{arm}/density2',json.loads((R/f'density-{arm}/stdout.json').read_text()))]
 for row in json.loads((R/'seen2-001/result.json').read_text())['rows']:
  if row['arm']==arm:paths.append((R/'seen2-001'/(row['view']+'-'+arm),row['metadata']))
 for prefix,m in paths:
  raw=Path(str(prefix)+'.snapshot').read_bytes();canonical,counts,nv,nt=decode_snapshot(raw);assert len(raw)==cert['codecSnapshotBytes'] and len(canonical)==cert['counts']['snapshotBytes'];assert nv==cert['counts']['vertices'] and nt==cert['counts']['triangles'];assert counts=={4:0,5:cert['counts']['records']};assert m['normalPairCodecEnabled'] is True and m['normalPairMode4Records']==0 and m['normalPairMode5Records']==counts[5] and m['normalPairSavedBytes']==len(canonical)-len(raw);assert m['visibilitySnapshotFingerprint']==fnv(raw)
  rows.append({'arm':arm,'prefix':str(prefix.relative_to(R)),'snapshotBytes':len(raw),'canonicalBytes':len(canonical),'snapshotSHA256':sha_bytes(raw),'canonicalSHA256':sha_bytes(canonical),'mode4':counts[4],'mode5':counts[5],'work':m['work'],'status':'COMPLETE_DIAGNOSTIC_NOT_REFERENCE_SCORED'})
(R/'diagnostic-accounting.json').write_text(json.dumps(rows,indent=2));assert len(rows)==9
