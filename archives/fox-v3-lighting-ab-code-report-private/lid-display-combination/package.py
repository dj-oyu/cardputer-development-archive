from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent;W=R.parent;sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=W/'fox-v3-lid-save/fox-v3-lighting-ab-code-report-private.zip'
assert sha(old)=='6227c601dae15ff03423e20aa7d3ee0f3c559f1da3e0e9ee10cb37a88b84baf0'
E=W/'fox-v3-lid-display-combination';a=json.loads((E/'BUNDLE_ALLOWLIST.json').read_text());files={'package.py':R/'package.py'}
for n,h in a['files'].items():
 assert sha(E/n)==h,n
 files[n]=E/n
for n in ['BUNDLE_ALLOWLIST.json','CODE_REPORT_FREEZE.json']:files[n]=E/n
out=R/'fox-v3-lighting-ab-code-report-private.zip'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n,p in files.items():w.write(p,'lid-display-combination/'+n)
 w.writestr('lid-display-combination/bundle-manifest.json',json.dumps({n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noModelsImagesRawBuffersAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
