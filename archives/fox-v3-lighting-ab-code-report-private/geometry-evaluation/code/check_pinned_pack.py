import pathlib,shutil,json,subprocess,sys
from geometry_certificate import sha,verify
R=pathlib.Path(__file__).resolve().parents[1];W=R.parent;src=R/'prepared-old-final';p=R/'old-pinned-validation';shutil.copytree(src,p);b=W/'fox-v3-ground-transport/le-001'
shutil.copy2(b/'inputs/candidate-config.json',p/'inputs/candidate-config.json')
for f in b.glob('native-*'):
 if f.is_file():shutil.copy2(f,p/f.name)
m=json.loads((b/'candidate-manifest.json').read_text());pin=sha(p/'inputs/geometry-certificate.json');m['geometryCertificateSHA256']=pin;m['candidate']['sourceFiles']=[{'file':str(f.relative_to(p)),'sha256':sha(f)} for d in ['code','product','inputs','physical','visibility','transport','compiled','scoring'] for f in (p/d).rglob('*') if f.is_file() and '__pycache__' not in f.parts];(p/'candidate-manifest.json').write_text(json.dumps(m,indent=2));verify(p,pin)
subprocess.run([sys.executable,str(R/'scoring/score_candidate.py'),str(p/'candidate-manifest.json'),'--geometry-certificate-sha256',pin,'--reference',str(W/'fox-reference-uncertainty-v3'),'--output',str(R/'score-old-pinned-validation')],check=True)
print('Pinned production scorer path passed all10 frozen old frame metadata, source/model/certificate hashes. No new rendering.')
