from pathlib import Path
import json,subprocess,sys,os
p=Path(__file__).resolve().parent;r=p.parent
base=json.loads((r/'fox-eye-qemu-20261111/composite-final/host-command.json').read_text())
flags=base[:base.index(next(x for x in base if x.endswith('/main/entry.c')))]+['-pthread']
sources=[str(p/x) for x in ['lease.c','render_adapter.c','test_render.c']]+[str(r/'fox-eye-runtime-20261111/eye_runtime.c')]+[x for x in base if x.endswith(('/scene_alpha.c','/prepared_alpha.c','/composite.c','/compact_opaque.c'))]
mode=sys.argv[1] if len(sys.argv)>1 else 'o2'
if mode=='san':flags+=['-O1','-g','-fsanitize=address,undefined','-fno-omit-frame-pointer']
cmd=flags+sources+['-lm','-o',str(p/('render-'+mode))]
(p/('command-'+mode+'.json')).write_text(json.dumps(cmd,indent=2));subprocess.run(cmd,check=True)
with (p/('render-'+mode+'.log')).open('w') as f:subprocess.run([str(p/('render-'+mode))],stdout=f,stderr=subprocess.STDOUT,check=True,env={**os.environ,"ASAN_OPTIONS":os.environ.get("ASAN_OPTIONS","detect_leaks=0")})
print((p/('render-'+mode+'.log')).read_text())
