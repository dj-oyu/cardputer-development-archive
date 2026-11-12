from pathlib import Path
import json,hashlib,shutil,sys
R=Path(__file__).resolve().parents[1];W=R.parent;B=W/'fox-v3-lid-evaluation/actual-lid8-v2';D=R/'deps';assert not D.exists();sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
sys.path.insert(0,str(B/'code'));from geometry_certificate import verify
m=json.load(open(B/'candidate-manifest.json'));c=verify(B,m['geometryCertificateSHA256']);assert c['counts']['triangles']==1564
D.mkdir()
for name in ['product','physical','visibility','transport']:
 shutil.copytree(B/name,D/name,ignore=shutil.ignore_patterns('__pycache__'))
(D/'code').mkdir();shutil.copy2(B/'code/expected_counts.h',D/'code/expected_counts.h');shutil.copy2(B/'code/ground_input.h',D/'code/ground_input.h')
(D/'compiled').mkdir();shutil.copytree(B/'compiled/model-baseline',D/'compiled/model-baseline')
(D/'inputs').mkdir()
for name in ['candidate-config.json','ground-baseline.txt','geometry-certificate.json','codec-contract.json']:shutil.copy2(B/'inputs'/name,D/'inputs'/name)
shutil.copy2(B/'physical-baseline.txt',D/'inputs/physical-baseline.txt')
pins={str(p.relative_to(D)):sha(p) for p in D.rglob('*') if p.is_file()};(R/'DEPENDENCY_FREEZE.json').write_text(json.dumps({'baselineGeometryCertificateSHA256':m['geometryCertificateSHA256'],'actualModelSHA256':sha(D/'compiled/model-baseline/model.aynm'),'dependencyFiles':pins,'scope':'Immutable baseline code/assets copied. No production changes; static config historical geometry labels are not the current certificate.'},indent=2)+'\n');print(len(pins),sha(R/'DEPENDENCY_FREEZE.json'))
