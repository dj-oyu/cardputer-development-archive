import json,subprocess,sys,os
from pathlib import Path
p=Path(__file__).resolve().parent
root=p.parent.parent
qjs=root/'qemu-render-20261111/components/quickjs-ng/quickjs-ng'
base=json.loads((root/'fox-eye-qemu-20261111/composite-final/host-command.json').read_text())
flags=base[:base.index(next(x for x in base if x.endswith('/main/entry.c')))]+['-I'+str(qjs),'-DQUICKJS_NG_BUILD','-D_GNU_SOURCE','-g']
src=[str(p/x) for x in ['main.c','bridge.c','render.c']]+[str(root/'fox-eye-runtime-20261111/eye_runtime.c')]+[str(qjs/(x+'.c')) for x in ['dtoa','libregexp','libunicode','quickjs','quickjs-vm']]+[x for x in base if x.endswith(('/scene_alpha.c','/prepared_alpha.c','/composite.c','/compact_opaque.c'))]
mode=sys.argv[1] if len(sys.argv)>1 else 'o2'
extra=['-O1','-g','-fsanitize=address,undefined','-fno-omit-frame-pointer'] if mode=='san' else []
cmd=flags+extra+src+['-lm','-o',str(p/('test-'+mode))]
(p/('command-'+mode+'.json')).write_text(json.dumps(cmd,indent=2));subprocess.run(cmd,check=True)
run=subprocess.run([str(p/('test-'+mode)),str(root/'qemu-render-20261111/apps/lib/ayatsuri_motion.js'),str(p.parent/'generic/ayatsuri_controls.js'),str(p/'fox_controls.js'),str(p/'scenario.js')],capture_output=True,text=True,env={**os.environ,'ASAN_OPTIONS':os.environ.get('ASAN_OPTIONS','detect_leaks=0')})
(p/('test-'+mode+'.log')).write_text(run.stdout+run.stderr);print(run.stdout+run.stderr);run.check_returncode()
