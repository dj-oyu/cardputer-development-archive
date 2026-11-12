from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parent;old=R.parent/'fox-v3-bounce/bounce-001';checks={}
for arm in ['off','control','le']:
 d=R/f'{arm}-001';m=json.loads((d/'candidate-manifest.json').read_text());n=0
 for frame in m['frames']:
  stem='native-'+frame['view']+'-'+frame['case']
  for ext in ['.u16le','.f32le']:
   assert (d/(stem+ext)).read_bytes()==(d/(stem+'-reverse'+ext)).read_bytes()
   if arm=='off':
    for suf in ['', '-reverse']:
     assert (d/(stem+suf+ext)).read_bytes()==(old/(stem+suf+ext)).read_bytes()
   if ext=='.f32le': assert (d/(stem+ext)).read_bytes()==(old/(stem+ext)).read_bytes()
   n+=1
 checks[arm]={'forwardReverseBufferPairsExact':n,'oldDepthAll10Exact':True,'oldRGBAndDepth40Exact':True if arm=='off' else 'NOT_REQUIRED_NEW_LIGHTING'}
 checks[arm]['inputsUnchanged']=all(hashlib.sha256((d/p).read_bytes()).hexdigest()==h for p,h in json.loads((d/'input-hashes-start.json').read_text()).items())
 assert checks[arm]['inputsUnchanged']
(R/'control-parity.json').write_text(json.dumps(checks,indent=2));print(json.dumps(checks))
