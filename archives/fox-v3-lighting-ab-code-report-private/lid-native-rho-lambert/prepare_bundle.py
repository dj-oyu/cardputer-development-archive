from pathlib import Path
import json,shutil
R=Path(__file__).resolve().parent;D=R/'bundle-metadata';D.mkdir(exist_ok=True)
def save(p,v):p.write_text(json.dumps(v,indent=2)+'\n')
def scrub(v):
 if isinstance(v,dict):return {k:scrub(a) for k,a in v.items() if k not in ['uncertainLocationsYX','uncertainSignFrequencyAtLocations']}
 if isinstance(v,list):return [scrub(a) for a in v]
 return v
save(D/'evaluation-aggregate.json',scrub(json.loads((R/'analysis-001/evaluation.json').read_text())))
for p in (Path('/tmp/v3-lambert-review')).glob('*.json'):shutil.copyfile(p,D/('independent-'+p.name))
for p in Path('/tmp').glob('lid-native-rho-lambert*review.json'):shutil.copyfile(p,D/('independent-'+p.name))
paths=['PLAN.md','REPORT.md','audit_rho.py','rho-proof.json','SOURCE_FREEZE.json','render-source.diff','analyze.py','test_results.py','test-results.json','prepare_bundle.py','code/render.py','code/exr_io.py']
for sub in ['audit-002','run-001']:paths += [str(p.relative_to(R)) for p in (R/sub).glob('*.json')]
paths += [str(p.relative_to(R)) for p in (R/'analysis-001').glob('*.json') if p.name!='evaluation.json']
paths += [str(p.relative_to(R)) for p in D.glob('*.json')]
assert all((R/p).is_file() for p in paths)
save(R/'BUNDLE_ALLOWLIST.json',{'include':sorted(paths),'exclude':['all source/model/geometry files','all snapshots/canonical buffers','all per-pixel/ray/winner/private joins','all images PNG/EXR/raw buffers','unsanitized evaluation with per-location arrays','binary executables'],'scope':'Only code, reports, aggregate metrics, audit summaries and hashes; no original geometry/image/private point payloads.'})
