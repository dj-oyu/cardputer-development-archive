from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent;old=R.parent/'fox-v3-occlusion-reduction/fox-v3-lighting-ab-code-report-private.zip';out=R/'fox-v3-lighting-ab-code-report-private.zip';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(old)=='54d82a2a1d8091b83bc53f2aaef9684a8e08133138979a60bfded2e72f56f3f2'
files={n:R/n for n in ['CONTRACT.md','REPORT.md','prepare.py','reduce.py','audit.py','ray_families.py','summarize.py','inspect_source_topology.py','audit-contract.json','previous-audit-contract.json','new-validation-views.json','results-summary.json','artifact-hashes.json','package.py']}
files['contact-compile-accounting.json']=R.parent/'fox-v3-occlusion-evaluation/contact-compile-accounting.json'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n,p in files.items():w.write(p,'contact-protected/'+n)
 w.writestr('contact-protected/bundle-manifest.json',json.dumps({n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist()); assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),addedEntries=len(files)+1,sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noImagesGeometrySourceControlPointsOrRawSamplesAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
