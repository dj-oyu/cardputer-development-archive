from pathlib import Path
import json,subprocess
r=Path.cwd();p=r/'fox-firmware-budget-20261111';cmd=json.loads((p/'fast-command.json').read_text());cmd=[v for v in cmd if not (v.endswith('.c') and any(x in v for x in ['entry-primary','bridge.c','quickjs-ng/','eye_runtime.c']))]
s=(r/'fox-eye-raster-20261111/test_composite.c').read_text();s='unsigned long budget_fragments,budget_passes,budget_triangles,budget_batches;\n'+s
(p/'test-fast.c').write_text(s);cmd.insert(cmd.index('-o'),str(p/'test-fast.c'));cmd[cmd.index('-o')+1]=str(p/'test-fast');subprocess.run(cmd,check=True);subprocess.run([str(p/'test-fast')],check=True,stdout=(p/'fast-invariants.log').open('w'))
cmd[cmd.index('-O2')]='-O1';cmd+=['-fsanitize=address,undefined','-fno-omit-frame-pointer'];cmd[cmd.index('-o')+1]=str(p/'test-fast-san');subprocess.run(cmd,check=True)
import os
env=dict(os.environ,ASAN_OPTIONS='detect_leaks=0');subprocess.run([str(p/'test-fast-san')],check=True,env=env,stdout=(p/'fast-invariants-san.log').open('w'))
print((p/'fast-invariants.log').read_text(),(p/'fast-invariants-san.log').read_text())
