"""Await complete controls, assert fresh A reproduces v32, then execute sole B arm."""
from pathlib import Path
import json,hashlib,subprocess,time,sys
R=Path(__file__).resolve().parents[1];W=R.parent;A=R/'actual-A2';B=R/'actual-B2';OLD=W/'fox-v3-boundary-aa-evaluation/actual-001';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
while not (A/'on/COMPLETED.json').exists() or not (B/'off/COMPLETED.json').exists():
 for d,arms in [(A,['off','on']),(B,['off'])]:
  for arm in arms:
   assert not (d/arm/'FAILED.json').exists() and not (d/arm/'CONTROL_FAILED.json').exists(),str(d/arm)
 time.sleep(5)
assert sha(A/'native-render')!=sha(OLD/'native-render') # explicit separate numerical stage
checks=[]
for row in json.load(open(A/'on/COMPLETED.json'))['frames']:
 for ext in ['.u16le','.f32le','.snapshot','.targets.u8']:
  a=A/'on'/(row['prefix']+ext);b=OLD/'on'/(row['prefix']+ext);assert a.read_bytes()==b.read_bytes();checks.append({'file':str(a.relative_to(A)),'sha256':sha(a)})
(R/'A2_REPLAY_PROOF.json').write_text(json.dumps({'status':'ALL20_V32_EXACT','binaryExact':False,'oldQuarterRGBDepthSnapshotMaskExact':True,'rhoRoundoffMayDiffer':True,'files':checks},indent=2)+'\n');print('A2_ALL20_BYTE_EXACT_B2_START',flush=True)
with (B/'on-run.log').open('w') as f:subprocess.run([sys.executable,str(R/'code/run_actual.py'),str(B),'on'],stdout=f,stderr=subprocess.STDOUT,check=True)
print('B2_ALL20_COMPLETE',flush=True)
for D in [A,B]:
 subprocess.run([sys.executable,str(R/'code/audit_samples.py'),str(D)],check=True)
 subprocess.run([sys.executable,str(R/'code/audit_sample_positions.py'),str(D),'0x1p-2' if D==A else '0x1.272062ae104d0p-2'],check=True)
 files={}
 for arm in ['off','on']:
  for p in (D/arm).rglob('*'):
   if p.is_file() and (p.suffix in ['.json','.npz','.u16le','.f32le','.snapshot','.u8','.jsonl']):files[str(p.relative_to(D))]=sha(p)
 freeze=D/'ACTUAL_OUTPUT_FREEZE.json';freeze.write_text(json.dumps({'files':files},indent=2)+'\n')
 for arm in ['off','on']:subprocess.run([sys.executable,str(R/'code/score_actual.py'),str(D),arm,sha(freeze)],check=True)
print('AB_AUDIT_SCORE_COMPLETE',flush=True)
