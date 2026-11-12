#!/usr/bin/env python3
"""Rebuild only a new local copy; leave archived source and proof unchanged."""
from pathlib import Path
import hashlib,json,re,shutil,subprocess
root=Path(__file__).resolve().parent
work=root/'replay-composed-work'
if work.exists():raise SystemExit('Replay directory exists; preserve it and use a fresh archive for another run.')
old='/workspace/scratch/6d8dcdbcdc54'
for f in list(root.rglob('*')):
    rel=f.relative_to(root)
    if not f.is_file() or any(x in {'build','replay-composed-work','__pycache__'} for x in rel.parts):continue
    if f.suffix not in {'.c','.h','.inc','.js','.cjs','.json'} and f.name not in {'LICENSE','COPYING'}:continue
    p=work/rel;p.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,p)
    if p.suffix in {'.c','.h','.inc','.js','.cjs'}:
        s=p.read_text();p.write_text(s.replace(old,str(work)))
base='fox-product-composed-20261111'
cmd=json.loads((root/base/'private/command-o2.json').read_text())
cmd=[s.replace(old,str(work)) for s in cmd]
subprocess.run(cmd,cwd=work,check=True)
argv=[work/base/'private/test-o2',work/'qemu-render-20261111/apps/lib/ayatsuri_motion.js',work/base/'generic/ayatsuri_controls.js',work/base/'private/fox_controls.js',work/base/'private/scenario.js']
log=work/'host-composed-replay.log'
with log.open('w') as f:subprocess.run([str(p) for p in argv],cwd=work,stdout=f,stderr=subprocess.STDOUT,check=True)
result={'host_replay_pass':True,'images':{},'command':cmd}
for t in range(0,1001,125):
    data=(work/base/f'motion-{t}ms.rgb565').read_bytes()
    refs=[root/base/f'motion-{t}ms.rgb565',root/base/f'qemu-motion-{t}ms.rgb565',root/'fox-eye-runtime-qemu-20261111/motion/captures'/f'motion-{t}ms.rgb565']
    assert len(data)==64800 and all(data==p.read_bytes() for p in refs)
    result['images'][t]={'bytes':len(data),'all_three_references_equal':True,'sha256':hashlib.sha256(data).hexdigest()}
expected=(root/base/'private/test-o2.log').read_text()
actual=log.read_text()
records=lambda s:[x for x in s.splitlines() if x.startswith(('PASS ','COMPOSED_','FOX_CONTROL_SWEEP '))]
assert records(expected)==records(actual)
result['scenario_records_equal']=True
result['log_sha256']=hashlib.sha256(log.read_bytes()).hexdigest()
node=subprocess.run(['node',str(work/base/'generic/test_controls.cjs')],cwd=work,capture_output=True,text=True,check=True)
(work/'generic-replay.log').write_text(node.stdout+node.stderr)
(root/'relocation-replay-result.json').write_text(json.dumps(result,indent=2)+'\n')
print('PASS relocated composition, nine exact host/QEMU/prior images, scenario records and generic controls')
