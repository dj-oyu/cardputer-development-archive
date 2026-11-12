from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent;old=R.parent/'fox-v3-contact-protected/fox-v3-lighting-ab-code-report-private.zip';out=R/'fox-v3-lighting-ab-code-report-private.zip';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(old)=='88fb4b25409fda4ab6c50b9e3043329fc4999180b8296c89d5556e37d79139e6'
f=json.loads((R/'CODE_REPORT_FREEZE.json').read_text()); files={n:R/n for n in f['files']};files['CODE_REPORT_FREEZE.json']=R/'CODE_REPORT_FREEZE.json';files['package_actual.py']=R/'package_actual.py'
for n,p in files.items():
 if n in f['files']:assert sha(p)==f['files'][n]
for run in ['actual-old-control','actual-stage1','actual-stage2']:
 for n in ['candidate-manifest.json','functional.json','inputs/geometry-certificate.json','code/expected_counts.h']:
  if (R/run/n).exists():files[run+'/'+n]=R/run/n
for run in ['score-old-control','score-stage1','score-stage2']:
 for n in ['evaluation.json','COMPLETED.json']:
  if (R/run/n).exists():files[run+'/'+n]=R/run/n
for run in ['density-stage1','density-stage2']:
 files[run+'/result.json']=R/run/'result.json'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n,p in files.items():w.write(p,'occlusion-actual-comparison/'+n)
 w.writestr('occlusion-actual-comparison/bundle-manifest.json',json.dumps({n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),addedEntries=len(files)+1,sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noGeometryImagesRawBuffersAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
