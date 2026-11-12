from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent;W=R.parent;sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=W/'fox-v3-normal-pair-save/fox-v3-lighting-ab-code-report-private.zip'
assert sha(old)=='0399fadb87d5a3c686f1691d4578b6f1493c0dec8e17004e5ec8e98aee4f21ee'
files={'package.py':R/'package.py'}
G=W/'fox-v3-lid-source-lod/code-report-frozen'
a=json.loads((G/'bundle-allowlist.json').read_text())
for n in a['include']+['bundle-allowlist.json','code-report-hashes.json']:files['geometry-code-report/'+n]=G/n
D=W/'fox-v3-eye-diagnostic/lid-ab'
for n in ['PLAN.json','compare_geometry.py','summarize.py','summary.json','REPORT.md','pre-execution.json','artifact-hashes.json','independent-review.json']:files['ray-diagnostic/'+n]=D/n
E=W/'fox-v3-lid-evaluation';a=json.loads((E/'BUNDLE_ALLOWLIST.json').read_text())
for n,h in a['files'].items():
 assert sha(E/n)==h,n
 files['evaluation/'+n]=E/n
for n in ['BUNDLE_ALLOWLIST.json','CODE_REPORT_FREEZE.json']:files['evaluation/'+n]=E/n
out=R/'fox-v3-lighting-ab-code-report-private.zip'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n,p in files.items():w.write(p,'eyelid-source-lod/'+n)
 w.writestr('eyelid-source-lod/bundle-manifest.json',json.dumps({n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noModelsImagesRawBuffersAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
