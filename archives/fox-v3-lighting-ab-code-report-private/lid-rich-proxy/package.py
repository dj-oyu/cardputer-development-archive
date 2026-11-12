from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent;W=R.parent;sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=W/'fox-v3-point-audit-save/fox-v3-lighting-ab-code-report-private.zip'
assert sha(old)=='4cd8e995c08fe2520bb2de2db0f1f4a315c29e0313951eff40eb6234379941c4'
E=W/'fox-v3-lid-rich-proxy';a=json.loads((E/'BUNDLE_ALLOWLIST.json').read_text());files={'package.py':R/'package.py'}
for n in a['include']:files[n]=E/n
for n in ['BUNDLE_ALLOWLIST.json','CODE_REPORT_FREEZE.json']:files[n]=E/n
C=W/'fox-v3-lid-response-correspondence'
c=json.loads((C/'BUNDLE_ALLOWLIST.json').read_text())
for n in c['include']+['BUNDLE_ALLOWLIST.json']:files['correspondence/'+n]=C/n
out=R/'fox-v3-lighting-ab-code-report-private.zip'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n,p in files.items():w.write(p,'lid-rich-proxy/'+n)
 w.writestr('lid-rich-proxy/bundle-manifest.json',json.dumps({n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noModelsImagesRawBuffersAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
