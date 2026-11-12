from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent;W=R.parent;old=W/'fox-v3-occlusion-evaluation/fox-v3-lighting-ab-code-report-private.zip';out=R/'fox-v3-lighting-ab-code-report-private.zip';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(old)=='d9c61eee5c4a20d3c93eae30c2fa4927ef557363de7a01d537fc6a945106e3b2'
f=json.loads((R/'CODE_REPORT_FREEZE.json').read_text());files={'evaluation/'+n:R/n for n in f['files']};files['evaluation/CODE_REPORT_FREEZE.json']=R/'CODE_REPORT_FREEZE.json';files['evaluation/package.py']=R/'package.py'
for n,h in f['files'].items():assert sha(R/n)==h
for run in ['actual-eyeA','actual-eyeB']:
 for n in ['candidate-manifest.json','functional.json','inputs/geometry-certificate.json','code/expected_counts.h']:files['evaluation/'+run+'/'+n]=R/run/n
for run in ['score-eyeA','score-eyeB']:
 for n in ['evaluation.json','COMPLETED.json']:files['evaluation/'+run+'/'+n]=R/run/n
for run in ['density-eyeA','density-eyeB','holdout-002']:
 files['evaluation/'+run+'/result.json']=R/run/'result.json'
for n in ['CONTRACT.md','REPORT.md','build.py','build-report.json','artifact-hashes.json','independent-construction-review.json']:files['construction/'+n]=W/'fox-v3-eye-local-lod'/n
for n in ['REPORT.md','geometry.py','summary.json','manifest.json','independent-summary.json','eye-material-independent.json']:files['original-eye-diagnosis/'+n]=W/'fox-v3-eye-diagnostic'/n
for n in ['PLAN.json','base-geometry.py','compare_geometry.py','summarize.py','summary.json','REPORT.md','pre-execution.sha256','artifact-hashes.json','independent-review.json']:files['geometry-comparison/'+n]=W/'fox-v3-eye-diagnostic/ab'/n
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n,p in files.items():w.write(p,'eye-local-lod/'+n)
 w.writestr('eye-local-lod/bundle-manifest.json',json.dumps({n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),addedEntries=len(files)+1,sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noGeometrySourceParametersImagesRawBuffersAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
