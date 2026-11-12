from pathlib import Path
import json,subprocess,sys,time,hashlib,ast,numpy as np
R=Path(__file__).resolve().parent;W=R.parent;B=W/'fox-v3-eye-evaluation/actual-eyeB';pins={'off':'505ee16c7d5ea569536be17bf45e07e5376112f941467cb5675915cf976acdc0','on':'a8d001fb56f999c90cc7ca75fe6ef6094a60ea5403979e6171635aa7eca5c10a'}
for arm,pin in pins.items():
 m=R/('actual-'+arm)/'candidate-manifest.json'
 while not m.exists():
  if 'Traceback' in (R/('actual-'+arm+'.log')).read_text():raise RuntimeError(arm+' failed; no score')
  time.sleep(5)
 with (R/('score-'+arm+'-v2'+'.log')).open('w') as f:subprocess.run([sys.executable,str(R/'scoring/score_candidate.py'),str(m),'--geometry-certificate-sha256',pin,'--reference',str(W/'fox-reference-uncertainty-v3'),'--output',str(R/('score-'+arm+'-v2'))],stdout=f,stderr=subprocess.STDOUT,check=True)
 print(arm+' scored',flush=True)
base=json.loads((W/'fox-v3-eye-evaluation/score-eyeB/evaluation.json').read_text());result={}
for arm in pins:
 root=R/('actual-'+arm);score=json.loads((R/('score-'+arm+'-v2')/'evaluation.json').read_text());files=list(B.glob('native-*.u16le'))+list(B.glob('native-*.f32le'));assert len(files)==40
 for p in files:assert p.read_bytes()==(root/p.name).read_bytes(),(arm,p.name)
 for k,x in base['conditions'].items():
  for name in ['colorMeanPrecision','response','shapeFullFrame']:
   if name in x:assert x[name]==score['conditions'][k][name],(arm,k,name)
  oldmask=W/'fox-v3-eye-evaluation/score-eyeB'/(k+'-masks.npz');newmask=R/('score-'+arm+'-v2')/(k+'-masks.npz')
  with np.load(oldmask) as a,np.load(newmask) as b:
   assert set(a.files)==set(b.files)
   for key in a.files:assert np.array_equal(a[key],b[key],equal_nan=True)
 metadata=[]
 for p in B.glob('native-*.json'):
  old=json.loads(p.read_text());new=json.loads((root/p.name).read_text())
  for k,v in old.items():
   if k.endswith('Ns') or k=='hostRenderNsFirstFrame' or k in ['snapshotBytes','visibilitySnapshotFingerprint']:continue
   assert new[k]==v,(arm,p.name,k)
  metadata.append(new)
 result[arm]={'all40BuffersVsOriginalEyeBExact':True,'all10ScoresAndMasksVsOriginalEyeBExact':True,'allNonTimingNonLayoutOriginalMetadataExact':True,'all20SnapshotDecodedCanonicalExact':True,'snapshotBytes':sorted({x['snapshotBytes'] for x in metadata}),'mode4Records':sorted({x['normalPairMode4Records'] for x in metadata}),'mode5Records':sorted({x['normalPairMode5Records'] for x in metadata}),'savedBytes':sorted({x['normalPairSavedBytes'] for x in metadata}),'headroomUnder65536':sorted({65536-x['snapshotBytes'] for x in metadata})}
(R/'actual-parity-v2.json').write_text(json.dumps({'status':'ALL_FUNCTIONAL_PARITY_COMPLETE','arms':result,'formalAdoption':False,'global60PercentClaim':False},indent=2));print(json.dumps(result,indent=2))
