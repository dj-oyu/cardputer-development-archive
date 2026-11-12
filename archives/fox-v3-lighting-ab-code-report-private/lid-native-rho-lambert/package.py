from pathlib import Path
import json,hashlib,zipfile
R=Path(__file__).resolve().parent;W=R.parent;sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
old=W/'fox-v3-rich-proxy-save/fox-v3-lighting-ab-code-report-private.zip'
assert sha(old)=='c4cab6eb1f442d6218ca576c6be1ba8232c9a9d0bd9c162f67b928fe91204d3d'
E=W/'fox-v3-lid-native-rho-lambert';a=json.loads((E/'BUNDLE_ALLOWLIST.json').read_text());files={'package.py':R/'package.py'}
for n in a['include']:files[n]=E/n
for n in ['BUNDLE_ALLOWLIST.json','CODE_REPORT_FREEZE.json']:files[n]=E/n
out=R/'fox-v3-lighting-ab-code-report-private.zip'
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as w:
 for n in z.namelist():w.writestr(n,z.read(n))
 for n,p in files.items():w.write(p,'lid-native-rho-lambert/'+n)
 w.writestr('lid-native-rho-lambert/bundle-manifest.json',json.dumps({n:{'sha256':sha(p),'bytes':p.stat().st_size} for n,p in files.items()},indent=2))
with zipfile.ZipFile(old) as z,zipfile.ZipFile(out) as w:
 assert all(z.read(n)==w.read(n) for n in z.namelist());assert len(w.namelist())==len(set(w.namelist()))
 j=dict(priorEntries=len(z.namelist()),totalEntries=len(w.namelist()),sha256=sha(out),bytes=out.stat().st_size,priorEntriesByteExact=True,noModelsImagesRawBuffersAdded=True)
(R/'package-result.json').write_text(json.dumps(j,indent=2));print(json.dumps(j))
