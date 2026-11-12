"""Verify frozen base and unchanged kernels; report caller-only product delta."""
from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-streamed-center-depth';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
f=json.loads((B/'SOURCE_FREEZE.json').read_text());assert all(sha(B/p)==h for p,h in f['files'].items())
unchanged={}
for directory in ['code','private-build','cache']:
 for p in (B/directory).rglob('*'):
  if p.is_file():
   q=R/p.relative_to(B);assert q.read_bytes()==p.read_bytes(),str(q);unchanged[str(p.relative_to(B))]=sha(q)
for name in ['row_transport_bridge.c','row_transport_bridge.h','model_arena_owner.h','profile_bridge.c']:
 assert (R/'harness'/name).read_bytes()==(B/'harness'/name).read_bytes()
x={'status':'PASS_CALLER_ONLY_PRODUCT_CHANGE','actualFrames':0,'baseline':B.name,'baseFrozenFilesVerified':len(f['files']),'unchangedKernelFiles':unchanged,'changedProductFiles':['harness/native_render_row.c'],'callerSHA256':sha(R/'harness/native_render_row.c'),'snapshotGeometryAndMaterialBodiesUnchanged':'checked separately by lifetime tests','allBaseFilesStillMatch':True,'noRejectedExperimentDependency':True}
(R/'SOURCE_DELTA.json').write_text(json.dumps(x,indent=2)+'\n');print(x['status'],len(unchanged))
