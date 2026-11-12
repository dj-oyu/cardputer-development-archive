"""Explicit code/aggregate archive, never include model or per-pixel evidence."""
from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];W=R.parent;files=set()
def add(p):assert p.is_file(),p;files.add(p)
for n in ['REPORT.md','README.md','INTEGRATION_FREEZE.json','VALIDATOR_V2_FREEZE.json','ADAPTER_V2_FREEZE.json','QUALITY_V3_FREEZE.json','SUPPLEMENT_V2_FREEZE.json','comparison/summary.json','comparison/metric-changes.json','memory/SCOPE.json','memory/native-stack.su','cost-001/RESULT.json','cpu-context/before.json','cpu-context/after.json','cpu-context/processes-before.txt','cpu-context/processes-after.txt','binding-negatives-001/RESULT.json']:
 add(R/n)
for n in ['prepare_floor.py','prepare_floor_v2.py','native_render.c','native_render_v2.c','aa_adapter.h','floor_adapter.h','floor_contract.py','floor_contract_v2.py','floor_contract_v3.py','run_floor.py','run_floor_v2.py','score_floor.py','score_floor_v2.py','score_floor_v3.py','test_floor_contract.py','test_floor_contract_v2.py','test_floor_contract_v3.py','test_floor_workload_gate.py','test_floor_input_binding.py','aa_contract.py','encode_control.c','audit_floor_samples.py','audit_floor_positions.py','close_floor_controls.py','close_floor_quality.py','summarize_floor.py','compare_floor_metrics.py','summarize_floor_components.py','audit_floor_clipping.py','target_samples.py','summarize_floor_components_v2.py','audit_floor_clipping_v2.py','sample_cpu_context.py','benchmark_floor.py','freeze_floor_bundle.py']:
 add(R/'code'/n)
add(R/'private/floor_input.h') # Only source floor constants, snapshot hashes and aggregate workload bounds; no geometry/identity table.
D=R/'actual-002'
for n in ['PREPARED.json','input-hashes.json','ACTUAL_OUTPUT_FREEZE.json','SOURCE_RHO.json','WORKLOAD_BOUNDS.json','FLOOR_COMPONENT_SUMMARY.json','FLOOR_CLIPPING_SUMMARY.json','FLOOR_COMPONENT_SUMMARY_V2.json','FLOOR_CLIPPING_SUMMARY_V2.json','ledger-contract.json','PREFLIGHT_CONTRACT.json']:add(D/n)
for arm in ['off','zero','on']:
 for n in ['SAMPLE_AUDIT.json','POSITION_AUDIT.json','ADMISSION_TESTS.json','ADMISSION_TESTS_V3.json','WORKLOAD_GATE_TESTS.json','score-v3/COMPLETED.json']:add(D/arm/n)
for arm in ['off','zero']:add(R/'actual-001'/arm/'FAILED.json')
P=W/'fox-v3-floor-direct-reflection-plan'
for p in P.iterdir():
 if p.suffix in ['.md','.json']:add(p)
C=W/'fox-v3-floor-direct-reflection-core';add(C/'SOURCE_FREEZE.json')
for n in ['bounce.c','bounce.h','pixel_transport.c','pixel_transport.h']:add(C/'transport'/n)
for n in ['test_floor.c','test_pixel_floor.c','REPORT.md','SIZES.json','BYTE_PROOF.json','run.sh','run.log','bounce.su','pixel_transport.su']:add(C/'floor-tests'/n)
for p in (R/'reviews').glob('*.json'):add(p)
# No original blend/GLB/AYNM, compiled models, raw source mapping/identity headers,
# executable binaries, snapshot/image/HDR/depth/mask/target/support arrays,
# sample JSONL or evaluation uncertain-coordinate tables.
m={str(p.relative_to(W)):{'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size} for p in sorted(files)}
out={'scope':'Private code/tests/aggregate report/metrics/cost/provenance only; no models, raw geometry, pixels or source identity table.','fileCount':len(m),'totalBytes':sum(x['bytes'] for x in m.values()),'files':m}
(R/'BUNDLE_ALLOWLIST.txt').write_text('\n'.join(m)+'\n');(R/'CODE_REPORT_FREEZE.json').write_text(json.dumps(out,indent=2)+'\n')
print(out['fileCount'],out['totalBytes'])
for n in ['CODE_REPORT_FREEZE.json','BUNDLE_ALLOWLIST.txt']:print(n,hashlib.sha256((R/n).read_bytes()).hexdigest())
