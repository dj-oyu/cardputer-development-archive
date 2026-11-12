from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent;old=R.parent/'fox-v16-density-preview/fox-v3-lighting-ab-code-report-private.zip';out=R/'fox-v3-lighting-ab-code-report-private.zip';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();assert sha(old)=='aba5145cd499376298440155780b8b9528731460ea6b7c50626df255a7758fae'
files=[R/x for x in ['REPORT.md','setup.py','render_zoom.py','render_narrow.py','black-source-rays.py','package.py','hashes.json','final-artifact-hashes.json','build.json','display-comparison.json','independent-display-review.json']]
for d in ['code','product','physical','visibility','transport']:
 files += [p for p in (R/d).rglob('*') if p.is_file() and '__pycache__' not in p.parts and p.suffix in ['.c','.h','.py','.cjs','.sh','.md']]
files += [R/'zoom/manifest.json',R/'zoom-narrow/manifest.json'];files=sorted(set(files));prefix='black-pixel-geometry-diagnosis-v16/'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for p in files:w.write(p,prefix+str(p.relative_to(R)))
 w.writestr(prefix+'bundle-manifest.json',json.dumps({str(p.relative_to(R)):{'sha256':sha(p),'bytes':p.stat().st_size} for p in files},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()));j={'priorEntries':len(z.namelist()),'addedEntries':len(files)+1,'totalEntries':len(w.namelist()),'bytes':out.stat().st_size,'sha256':sha(out),'priorEntriesByteExact':True,'noModelGeometryImageRawBuffersAdded':True,'rawFindingsAndRayPositionsExcluded':True}
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
