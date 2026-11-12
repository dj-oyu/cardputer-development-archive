from pathlib import Path
import hashlib,json,zipfile
R=Path(__file__).resolve().parent;old=R.parent/'fox-v16-subpixel-preview/fox-v3-lighting-ab-code-report-private.zip';out=R/'fox-v3-lighting-ab-code-report-private.zip';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();assert sha(old)=='0c298490dc16ee14c6d7a8af1703d64d567319391a4f9782a9cc00c6b31ab7a3'
files=[R/x for x in ['PLAN.md','REPORT.md','run.py','package.py','crop-coordinate-check.json','run-001/result.json','run-001/stdout.json','run-001/stderr.txt','independent-review/review.json','independent-review/parity.json']];prefix='twofold-face-density-v16/'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for p in files:w.write(p,prefix+str(p.relative_to(R)))
 w.writestr(prefix+'bundle-manifest.json',json.dumps({str(p.relative_to(R)):{'bytes':p.stat().st_size,'sha256':sha(p)} for p in files},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()));j={'priorEntries':len(z.namelist()),'addedEntries':len(files)+1,'totalEntries':len(w.namelist()),'bytes':out.stat().st_size,'sha256':sha(out),'priorEntriesByteExact':True,'noModelGeometryImageRawBuffersAdded':True}
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
