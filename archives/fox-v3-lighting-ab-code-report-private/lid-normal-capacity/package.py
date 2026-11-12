from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent;W=R.parent;old=W/'fox-v3-eye-evaluation/fox-v3-lighting-ab-code-report-private.zip';out=R/'fox-v3-lighting-ab-code-report-private.zip';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
assert sha(old)=='3c7e0fc2600c8935f4406c87e6ff5b2da14fa28a9c01f7fa2d0e8d8207617034'
D=W/'fox-v3-normal-pair-capacity';f=json.loads((D/'CODE_REPORT_FREEZE.json').read_text());files={'normal-pair-diagnostic/'+n:D/n for n in f['files']};files['normal-pair-diagnostic/CODE_REPORT_FREEZE.json']=D/'CODE_REPORT_FREEZE.json'
for n,h in f['files'].items():assert sha(D/n)==h
D=W/'fox-v3-lid-design';allow=json.loads((D/'bundle-allowlist.json').read_text());files.update({'lid-source-feasibility/'+n:D/n for n in allow['include']});files['lid-source-feasibility/bundle-allowlist.json']=D/'bundle-allowlist.json'
D=W/'fox-v3-eye-diagnostic/lid-residual';files.update({'lid-residual/'+n:D/n for n in ['REPORT.md','summary.json','read_curve.py','analyze.py','artifact-hashes.json','independent-review.json']});files['package.py']=R/'package.py'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n,p in files.items():w.write(p,'lid-normal-capacity/'+n)
 w.writestr('lid-normal-capacity/bundle-manifest.json',json.dumps({n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),addedEntries=len(files)+1,sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noGeometrySourceControlPointsImagesRawSnapshotsAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
