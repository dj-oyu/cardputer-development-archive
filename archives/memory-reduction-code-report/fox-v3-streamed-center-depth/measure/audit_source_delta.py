"""Pin unchanged baseline dependencies and full old ABI function bodies."""
from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-cached-profile-renderer';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
f=json.loads((B/'SOURCE_FREEZE.json').read_text());assert all(sha(B/p)==h for p,h in f['files'].items())
for path in ['code/ksn_bounded_ring.h','code/ksn_bounded_hdr.h','code/ksn_depth_bands_impl.inc','code/ksn_cached_profile.h','code/ksn_cached_profile_impl.inc','code/ksn_bounded_ring_center.inc','code/ksn_bounded_ring_helpers.inc']:
 assert (R/path).read_bytes()==(B/path).read_bytes(),path
for path in ['private-build/product/main/ui/kasane/ksn_mesh_depth.c','harness/row_transport_bridge.c']:
 assert (R/path).read_bytes().startswith((B/path).read_bytes()),path
for path in ['private-build/visibility','private-build/transport','private-build/background','private-build/physical','cache']:
 for p in (B/path).rglob('*'):
  if p.is_file(): assert (R/p.relative_to(B)).read_bytes()==p.read_bytes(),str(p)
changed=[];new=[]
for d in ['code','harness','private-build','measure','tests','review','comparison']:
 for p in (R/d).rglob('*'):
  if p.is_file() and p.suffix in ['.c','.h','.inc','.py','.sh']:
   q=B/p.relative_to(R)
   if not q.exists():new.append(str(p.relative_to(R)))
   elif sha(p)!=sha(q):changed.append(str(p.relative_to(R)))
x={'status':'PASS_UNCHANGED_LEGACY_BODIES_AND_BASELINE_FREEZE','actualFrames':0,'baseline':'fox-v3-cached-profile-renderer','baseFrozenFilesVerified':len(f['files']),'oldRendererAndAdapterBodiesUnchanged':True,'allBaseFilesStillMatch':True,'changedExisting':sorted(changed),'newSource':sorted(new),'noRejectedExperimentDependency':True,'sharedWorkCapsUnchanged':True}
(R/'SOURCE_DELTA.json').write_text(json.dumps(x,indent=2)+'\n');print(json.dumps({'changed':len(changed),'new':len(new),'baseFrozenFilesVerified':len(f['files'])}))
