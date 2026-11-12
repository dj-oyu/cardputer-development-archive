"""Explicit aggregate/code-only archive. Private artifacts are never globbed."""
from pathlib import Path
import hashlib,json,shutil
R=Path(__file__).resolve().parents[1];W=R.parent
files=set()
def add(p):
 assert p.is_file(),p
 files.add(p)
for n in ['REPORT.md','INTEGRATION_FREEZE.json','A2_REPLAY_PROOF.json','QUARTER_COMPATIBILITY.json','MEMORY_CODE_COST.json','RUNTIME_SUPPORT_SUMMARY.json','PREFLIGHT_CONTRACT.json','comparison/summary.json','comparison/metric-changes.json','cost-001/RESULT.json','cpu-context/before.json','cpu-context/after.json']:
 add(R/n)
for n in ['prepare_run.py','run_actual.py','close_affine.py','audit_samples.py','audit_sample_positions.py','audit_quarter_compatibility.py','score_actual.py','aa_contract.py','test_admission.py','generate_preflight.py','benchmark_ab.py','summarize_ab.py','compare_metrics.py','runtime_support_summary.py','aa_adapter.h','native_render.c','test_preflight_table.c','encode_control.c','generate_identity.py','freeze_affine_bundle.py']:
 add(R/'code'/n)
for arm in ['A2','B2']:
 d=R/('actual-'+arm)
 for n in ['PREPARED.json','input-hashes.json','ACTUAL_OUTPUT_FREEZE.json','on/SAMPLE_AUDIT.json','on/POSITION_AUDIT.json','on/score-v3/COMPLETED.json','off/score-v3/COMPLETED.json']:
  add(d/n)
 add(R/'tests'/('actual-'+arm+'-admission.json'))
for arm in ['A','B']:
 c=W/('fox-v3-boundary-rho-affine-core-'+arm)
 for n in ['SOURCE_FREEZE.json','RHO_ONLY.diff','product/main/ui/kasane/ksn_aa_rho_affine.h','product/main/ui/kasane/ksn_boundary_aa_impl.inc','tests/test_rho_affine.c','tests/test_rho_affine.json','tests/test_rho_affine_sanitized.json','tests/affine-stack.su','tests/test_boundary_aa.c','tests/test_boundary_aa.json','tests/test_hidden_failure.c','tests/test_hidden_failure.json']:
  add(c/n)
 if arm=='A':add(c/'tests/test_rho_affine_o0.json')
 for p in (R/'tests'/arm).glob('*.json'):add(p)
p=W/'fox-v3-boundary-rho-affine-plan'
for n in ['PLAN.md','PREFLIGHT_ADDENDUM.md','MEMORY_AND_TIMING_ADDENDUM.md','PREIMPLEMENTATION_FREEZE.json']:add(p/n)
p=W/'fox-v3-boundary-rho-affine-preflight'
for n in ['count_hits.c','run.py','RESULT.json','RESULT-v1.json','RESULT-v2.json','ledgers.json']:add(p/n)
for p in (R/'reviews').glob('*.json'):add(p)
# Explicitly excludes evaluation.json uncertain coordinates, models/compiled/identity tables,
# snapshot/RGB/depth/HDR/PNG/masks/support arrays, JSONL samples and all executable binaries.
manifest={str(p.relative_to(W)):{'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size} for p in sorted(files)}
out={'scope':'Private code, tests, aggregate metrics/cost/reviews and provenance hashes only. No geometry, identity tables, per-pixel arrays or images.','files':manifest,'fileCount':len(manifest),'totalBytes':sum(v['bytes'] for v in manifest.values())}
(R/'BUNDLE_ALLOWLIST.txt').write_text('\n'.join(manifest)+'\n')
(R/'CODE_REPORT_FREEZE.json').write_text(json.dumps(out,indent=2)+'\n')
print(out['fileCount'],out['totalBytes'])
for n in ['CODE_REPORT_FREEZE.json','BUNDLE_ALLOWLIST.txt']:print(n,hashlib.sha256((R/n).read_bytes()).hexdigest())
