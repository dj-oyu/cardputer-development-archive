from pathlib import Path
import sys,time,json,hashlib,subprocess
R=Path(__file__).resolve().parents[1];D=R/'actual-002';C=R/'code';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
while not (D/'on/POSITION_AUDIT.json').exists():
 assert not (D/'on/FAILED.json').exists(),'ON failed; no quality manifest'
 time.sleep(5)
for arm in ['off','zero','on']:
 subprocess.run([sys.executable,str(C/'test_floor_contract_v3.py'),str(D),arm],check=True)
files=[]
for arm in ['off','zero','on']:
 O=D/arm;done=json.load(open(O/'COMPLETED.json'));assert len(done['frames'])==20
 for row in done['frames']:
  for ext in ['.u16le','.f32le','.snapshot','.targets.u8','.json','.aa.json','.floor.json','.samples.jsonl','.support.npz']:files.append(Path(str(O/row['prefix'])+ext))
 for n in ['COMPLETED.json','SAMPLE_AUDIT.json','POSITION_AUDIT.json','ADMISSION_TESTS.json','ADMISSION_TESTS_V3.json','WORKLOAD_GATE_TESTS.json']:files.append(O/n)
op={'scope':'Complete all60 actual controls and experimental arm; private output hashes only.','files':{str(p.relative_to(D)):sha(p) for p in files}};(D/'ACTUAL_OUTPUT_FREEZE.json').write_text(json.dumps(op,indent=2)+'\n');h=sha(D/'ACTUAL_OUTPUT_FREEZE.json');ph=sha(D/'PREPARED.json');print('OUTPUT_FREEZE',h,'PREPARED',ph,flush=True)
for arm in ['off','zero','on']:subprocess.run([sys.executable,str(C/'score_floor_v3.py'),str(D),arm,h,ph],check=True)
subprocess.run([sys.executable,str(C/'summarize_floor.py'),str(R)],check=True)
subprocess.run([sys.executable,str(C/'compare_floor_metrics.py'),str(R)],check=True)
subprocess.run([sys.executable,str(C/'summarize_floor_components.py'),str(D)],check=True)
print('ALL_QUALITY_COMPLETE',flush=True)
