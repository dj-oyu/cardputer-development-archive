from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent; E=R.parent/'fox-v3-occlusion-evaluation'; old=R.parent/'fox-v16-black-pixel-diagnostic/fox-v3-lighting-ab-code-report-private.zip';out=R/'fox-v3-lighting-ab-code-report-private.zip'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(old)=='ca27c29519af906c52a11d5876c521b15926d369711ef9eeb02e77793094e1e2'
files={}
for n in ['PLAN.md','REPORT.md','audit-contract.json','build-report.json','results-summary.json','oracle-validation.json','independent-oracle-review.json','artifact-hashes.json','build.py','audit.py','ray_families.py','summarize.py','validate_oracle.py','package.py']:
 files['occlusion-ladder/'+n]=R/n
for d in ['code','scoring','product','physical','visibility','transport']:
 for p in (E/d).rglob('*'):
  if p.is_file() and p.suffix in ['.c','.h','.py','.cjs','.sh','.md'] and '__pycache__' not in p.parts:files['geometry-evaluation/'+str(p.relative_to(E))]=p
for n in ['README.md','ladder-compile-accounting.json','scorer-boundary.json','tests-geometry.log','tests-scorer-002.log','pinned-pack-validation.log','source-pin-negative.log']:files['geometry-evaluation/'+n]=E/n
manifest={n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()}
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n,p in files.items():w.write(p,n)
 w.writestr('occlusion-ladder/bundle-manifest.json',json.dumps(manifest,indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist()); assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),addedEntries=len(files)+1,sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noImagesGeometryOrRawSamplesAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
