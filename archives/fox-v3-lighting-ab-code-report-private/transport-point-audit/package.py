from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent;W=R.parent;sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=W/'fox-v3-lid-display-save/fox-v3-lighting-ab-code-report-private.zip'
assert sha(old)=='45e8766da3e738d70bd41733138d48b6a5f7a84e7f48443a86e4ff2c1ce99bc5'
E=W/'fox-v3-lid-transport-point-audit';a=json.loads((E/'BUNDLE_ALLOWLIST.json').read_text());files={'package.py':R/'package.py'}
for n,h in a['files'].items():
 assert sha(E/n)==h,n
 files[n]=E/n
for n in ['BUNDLE_ALLOWLIST.json','CODE_REPORT_FREEZE.json']:files[n]=E/n
S=W/'fox-v3-transport-point-selection'
for n in ['PLAN.json','REPORT.md','artifact-hashes.json','independent-review.json','label_after_selection.py','post-selection-labels.json','select.py','selection-frozen.sha256','selection.json']:files['selection/'+n]=S/n
out=R/'fox-v3-lighting-ab-code-report-private.zip'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n,p in files.items():w.write(p,'transport-point-audit/'+n)
 w.writestr('transport-point-audit/bundle-manifest.json',json.dumps({n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noModelsImagesRawBuffersAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
