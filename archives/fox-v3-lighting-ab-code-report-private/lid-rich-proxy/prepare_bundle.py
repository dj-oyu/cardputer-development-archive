"""Explicit aggregate-only bundle; never include source geometry or per-pixel data."""
from pathlib import Path
import json,hashlib,shutil
R=Path(__file__).resolve().parent;D=R/'bundle-metadata';D.mkdir(exist_ok=True)
save=lambda p,v:p.write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
def scrub(v):
 if isinstance(v,dict):return {k:scrub(a) for k,a in v.items() if k not in ['uncertainLocationsYX','uncertainSignFrequencyAtLocations']}
 if isinstance(v,list):return [scrub(x) for x in v]
 return v
save(D/'evaluation-aggregate.json',scrub(json.loads((R/'analysis-001/evaluation.json').read_text())))
# Only per-part counts/error summaries, material scalar metadata/hash, and scene settings; no geometry arrays.
a=json.loads((R/'run-001/proxy-seed11-front-baseline-audit.json').read_text());save(D/'material-storage-audit.json',a)
for name,path in [('geometry-independent.json','/tmp/v3-rich-proxy-review/report.json'),('artifacts-independent.json','/tmp/v3-rich-proxy-review/artifacts.json'),('metrics-independent.json','/tmp/lid-rich-proxy-independent-review.json'),('join-independent.json','/tmp/lid-rich-proxy-join-independent-review.json'),('filtered-direct-independent.json','/tmp/filtered-direct-independent-review.json')]:
 p=Path(path)
 if p.exists():shutil.copyfile(p,D/name)
paths=['PLAN.md','REPORT.md','extract_actual.py','geometry-proof.json','native-rho.json','SOURCE_FREEZE.json','SOURCE_FREEZE-v2.json','analyze.py','join_reverse.py','join_reverse_v2.py','analyze_sign_mechanism.py','check_filtered_direct.py','check_filtered_direct_v2.py','check_filtered_direct_v3.py','prepare_bundle.py','full-domain-regressions.json','test_results.py','test-results.json']
paths += [str(p.relative_to(R)) for p in (R/'code').glob('*') if p.is_file() and p.suffix in ['.py','.c']]
paths += [str(p.relative_to(R)) for p in D.glob('*.json')]
for sub,names in {'run-001':['COMPLETED.json','ORIGINAL_CONTROL_PASS.json','input-hashes-before.json','input-hashes-after.json'],'analysis-001':['COMPLETED.json','brief.json','pass-statistics.json','mixing.json','input-hashes.json'],'reverse-join-002':['summary.json','input-hashes.json'],'sign-mechanism-001':['summary.json','input-hashes.json'],'filtered-direct-003':['summary.json','input-hashes.json']}.items():paths += [sub+'/'+x for x in names]
paths += [str(p.relative_to(R)) for p in (R/'run-001').glob('control-*.json')]
assert all((R/p).is_file() for p in paths)
assert not any(Path(p).suffix in ['.glb','.blend','.npz','.snapshot','.png','.exr','.f64le','.u16le','.f32le'] for p in paths)
save(R/'BUNDLE_ALLOWLIST.json',{'include':sorted(set(paths)),'exclude':['private-actual-geometry.json','all source/model/compiled geometry','all private snapshot/canonical/raw buffers','all images EXRs PNGs','all per-pixel winner/ray/join data','audit-001 and audit-002 temporary outputs','filtered-direct-001/002 superseded incomplete metadata outputs','binary executables'],'scope':'Code, aggregate metrics, audit summaries, metadata and hashes only; no original private data arrays.'})
