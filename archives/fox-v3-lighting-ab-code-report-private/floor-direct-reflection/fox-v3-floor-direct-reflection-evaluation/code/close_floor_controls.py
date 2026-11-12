from pathlib import Path
import sys,time,subprocess,json
R=Path(__file__).resolve().parents[1];D=R/'actual-002';C=R/'code'
while not all((D/a/'COMPLETED.json').exists() for a in ['off','zero']):
 for a in ['off','zero']:
  assert not (D/a/'FAILED.json').exists(),('CONTROL_FAILURE',a)
 time.sleep(5)
for a in ['off','zero']:
 for script in ['test_floor_contract_v2.py','test_floor_workload_gate.py','audit_floor_samples.py','audit_floor_positions.py']:
  subprocess.run([sys.executable,str(C/script),str(D),a],check=True)
print('ALL40_CONTROLS_AND_SAMPLE_AUDITS_PASS; START_ON',flush=True)
subprocess.run([sys.executable,str(C/'run_floor_v2.py'),str(D),'on'],check=True)
for script in ['test_floor_contract_v2.py','test_floor_workload_gate.py','audit_floor_samples.py','audit_floor_positions.py']:
 subprocess.run([sys.executable,str(C/script),str(D),'on'],check=True)
print('ALL60_FUNCTIONAL_AND_SAMPLE_AUDITS_PASS',flush=True)
