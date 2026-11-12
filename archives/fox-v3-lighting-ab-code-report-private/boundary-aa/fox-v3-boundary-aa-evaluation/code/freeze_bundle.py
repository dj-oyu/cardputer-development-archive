"""Explicit code/report allowlist; never include private inputs or per-pixel artifacts."""
from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];W=R.parent;files=set();add=lambda p:files.add(p)
for pattern in ['code/*.py','code/*.h','code/*.c','tests/*.py','tests/*.json','tests/fixtures/*.json','tests/v2/*.json','tests/v2/*.diff','tests/v3/*.py','tests/v3/*.json','reviews/*.json']:
 for p in R.glob(pattern):add(p)
for n in ['REPORT.md','INTEGRATION_FREEZE.json','identity-proof.json','OUTPUT_PIN.txt','runtime-summary.json']:
 add(R/n)
D=R/'actual-001'
for n in ['PREPARED.json','input-hashes.json','ACTUAL_OUTPUT_FREEZE.json','ledger-front.txt','ledger-oblique.txt','off/OFF_SCORE_CONTROL.json','on/SAMPLE_AUDIT.json','comparison/summary.json','cost-001/RESULT.json']:
 add(D/n)
# Full evaluation contains per-pixel uncertain coordinates; aggregate summary alone is saved.
for arm in ['off','on']:
 for n in ['COMPLETED.json']:
  add(D/arm/'score-v3'/n)
C=W/'fox-v3-boundary-aa-core'
for n in ['CORE-PLAN.md','OFF-source-prefix-proof.json','SOURCE_FREEZE.json','implementation-ledger.json','legacy-source.diff','memory-size.json','product/main/ui/kasane/ksn_boundary_aa.h','product/main/ui/kasane/ksn_boundary_aa_impl.inc','product/main/ui/kasane/ksn_boundary_aa_center.inc','product/main/ui/kasane/ksn_mesh_depth.c','product/main/ui/kasane/ksn_mesh_depth.h','transport/pixel_transport.c','transport/pixel_transport.h','tests/test_boundary_aa.c','tests/test_boundary_aa.json','tests/test_hidden_failure.c','tests/test_hidden_failure.json','tests/hidden-failure-result.json','tests/sanitizer-result.json','tests/geometry-all20.json','tests/run.sh']:
 add(C/n)
P=W/'fox-v3-boundary-aa-plan'
for pattern in ['PLAN*.md','PREIMPLEMENTATION_FREEZE*.json','winner-only-ledger*.json']:
 for p in P.glob(pattern):add(p)
# No estimate arrays, identity header/binary, compiled models, source snapshots,
# JSONL samples, PNG/EXR, pixel tables/masks/support, binaries, or geometry dumps.
assert all(p.is_file() for p in files),[str(p) for p in files if not p.is_file()]
manifest={str(p.relative_to(W)):{'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size} for p in sorted(files)}
result={'scope':'Private code/tests/aggregate reports/metrics/cost/provenance hashes only. No raw model/snapshot/sample/image/mask/identity data.','files':manifest,'fileCount':len(manifest),'totalBytes':sum(v['bytes'] for v in manifest.values())}
(R/'CODE_REPORT_FREEZE.json').write_text(json.dumps(result,indent=2)+'\n');(R/'BUNDLE_ALLOWLIST.txt').write_text('\n'.join(manifest)+'\n');print(hashlib.sha256((R/'CODE_REPORT_FREEZE.json').read_bytes()).hexdigest(),len(manifest),result['totalBytes'])
