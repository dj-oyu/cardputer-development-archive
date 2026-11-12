"""Explicit code/aggregate-only bundle inventory; never include private inputs or buffers."""
from pathlib import Path
import json,hashlib,sys
R=Path(__file__).resolve().parents[1];W=R.parent;C=W/'fox-v3-camera-background-core';P=W/'fox-v3-camera-background-plan';selected=set()
def add(p):
 p=Path(p);assert p.is_file(),p;selected.add(p)
for sub in ['product','transport','visibility','physical']:
 for p in (C/sub).rglob('*'):
  if p.is_file() and p.suffix in ['.c','.h','.inc']:add(p)
for name in ['CORE_SOURCE_FREEZE.json','INTEGRATION_SOURCE_FREEZE.json','CORE_REPORT.md','CORE_DESIGN.md','CORE_WORK_CONTRACT.json']:add(C/name)
for sub in ['tests','background']:
 for p in (C/sub).rglob('*'):
  if p.is_file() and p.suffix in ['.c','.h','.sh','.py','.json','.md','.su','.log']:add(p)
for p in P.glob('*'):
 if p.is_file() and p.suffix in ['.md','.json']:add(p)
for name in ['test_geometry.c','count_background.c','run_counts.py','diagnostic_positions.c','SOURCE_FREEZE.json','ORDER_DIAGNOSTIC_SUMMARY.json','ORDER_DIAGNOSTIC_FREEZE.json','counts-001/COMPLETED.json','counts-001/INPUT_FREEZE.json','final-overrides-001/SUMMARY.json','final-overrides-001/SOURCE_FREEZE.json','final-overrides-001/run.py']:add(P/'preflight'/name)
code=['native_render.c','scene_transport_bridge.c','scene_transport_bridge.h','background_adapter.h','aa_adapter.h','aa_contract.py','encode_control.c','generate_inputs.py','generate_header.py','generate_core_inputs.py','prepare.py','run_actual.py','run_actual_v2.py','background_contract.py','test_background_contract.py','test_actual_background.py','audit_composition.py','audit_composition_v1.py','audit_composition_v2.py','audit_composition_v3.py','sample_cpu_context.py','benchmark_background.py','summarize_resources.py','make_private_preview.py','freeze_code_reports.py']
for n in code:add(R/'code'/n)
for n in ['REPORT.md','STACK_FIX_REPORT.md','STACK_FIX_FREEZE.json','OUTER_VALIDATION_FREEZE.json','OUTER_VALIDATION_FREEZE_V2.json','CPU_PLAN_FREEZE.json','RESOURCE_SUMMARY.json','CPU_SUMMARY.json','strict-synthetic-test.json']:add(R/n)
for sub in ['memory-v2','history/stack-fail-001','reviews','cpu-context']:
 for p in (R/sub).rglob('*'):
  if p.is_file() and p.suffix in ['.json','.su','.md','.txt','.c','.h']:add(p)
for a in ['cost-001','cost-002']:
 for n in ['RESULT.json','cpu-context-before.json','cpu-context-after.json']:add(R/a/n)
add(R/'cost-001/NOT_PRIMARY_COMPARISON.md')
for arm in ['on','background-control']:
 for n in ['COMPOSITION_AUDIT.json','STRICT_TEST.json']:add(R/'actual-002'/arm/n)
for n in ['PREPARED.json','input-hashes.json','background-run.log']:add(R/'actual-002'/n)
add(R/'actual-001/PREPARED.json')
child=json.load(open(R/'analysis-code/BUNDLE_ALLOWLIST.json'))
for n,pin in child['files'].items():
 p=R/'analysis-code'/n;assert hashlib.sha256(p.read_bytes()).hexdigest()==pin['sha256'];add(p)
add(R/'analysis-code/BUNDLE_ALLOWLIST.json')
for p in selected:
 assert not any(part in ['private','compiled','private-partial','private-preview'] for part in p.relative_to(W).parts),p
 assert p.suffix not in ['.glb','.blend','.aynm','.u16le','.f32le','.snapshot','.jsonl','.npz','.png','.o','.so'],p
files={str(p.relative_to(W)):{'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size} for p in sorted(selected)}
freeze={'scope':'Private code/tests/aggregate reports/metrics/cost/provenance only. No model, source geometry, private input tables, pixels, raw depth/snapshots/observer events or images.','fileCount':len(files),'totalBytes':sum(v['bytes'] for v in files.values()),'files':files}
if '--check-only' in sys.argv:
 print(json.dumps({'files':len(files),'bytes':freeze['totalBytes'],'checkOnly':True}));raise SystemExit(0)
for n in ['CODE_REPORT_FREEZE.json','BUNDLE_ALLOWLIST.txt']:assert not (R/n).exists()
(R/'CODE_REPORT_FREEZE.json').write_text(json.dumps(freeze,indent=2)+'\n');(R/'BUNDLE_ALLOWLIST.txt').write_text('\n'.join(files)+'\n');print(json.dumps({'files':len(files),'bytes':freeze['totalBytes'],'freezeSHA256':hashlib.sha256((R/'CODE_REPORT_FREEZE.json').read_bytes()).hexdigest(),'allowlistSHA256':hashlib.sha256((R/'BUNDLE_ALLOWLIST.txt').read_bytes()).hexdigest()}))
