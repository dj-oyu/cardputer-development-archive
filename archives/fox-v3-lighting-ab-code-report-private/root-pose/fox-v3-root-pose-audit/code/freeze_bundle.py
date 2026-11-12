"""Explicit allowlist: source/test/aggregate evidence only, no private raw assets."""
from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];W=R.parent;files=set()
for pattern in ['code/*.py','code/*.c','code/*.sh','reviews/*.json']:
 files.update(p for p in R.glob(pattern) if p.is_file())
for n in ['PLAN.md','PLAN-REVIEW-ADDENDUM.md','REPORT.md','SOURCE_FREEZE.json','DEPENDENCY_FREEZE.json','DEPENDENCY_FREEZE-v1.json','CONTROL_FREEZE.json','RESULTS.json','geometry-admission-audit.json','geometry-render-audit.json','fixtures-freeze-v1/FIXTURE_REPORT.json','admission-001/COMPLETED.json','run-001/COMPLETED.json','deps/code/ground_input.h','deps/code/expected_counts.h']:
 files.add(R/n)
assert all(p.is_file() for p in files)
items={str(p.relative_to(W)):{'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'bytes':p.stat().st_size} for p in sorted(files)}
j={'scope':'Private code/tests/aggregate metadata/metrics/lifecycle/memory/cost/pins only. Original models/geometry/raw world arrays/normals/attributes/snapshots/RGB/depth/images/preview excluded. Unchanged production dependencies referenced by hash, not a new product implementation.','files':items,'fileCount':len(items),'totalBytes':sum(x['bytes'] for x in items.values())};(R/'CODE_REPORT_FREEZE.json').write_text(json.dumps(j,indent=2)+'\n');(R/'BUNDLE_ALLOWLIST.txt').write_text('\n'.join(items)+'\n');print(hashlib.sha256((R/'CODE_REPORT_FREEZE.json').read_bytes()).hexdigest(),len(items),j['totalBytes'])
