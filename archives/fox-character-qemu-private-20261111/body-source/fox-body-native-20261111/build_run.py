from pathlib import Path
import subprocess,json,os,sys
D=Path(__file__).resolve().parent;R=D.parent/'qemu-render-20261111';H=D.parent/'hone-dq-converter-20261106/main/ayatsuri';san='--sanitize' in sys.argv
sources=['main/ayatsuri/ayatsuri_model.c','main/ayatsuri/ayatsuri_visibility.c','main/ayatsuri/compact_opaque.c','main/ui/kasane/ksn_shiki_frame.c','main/ui/kasane/ksn_mesh_depth.c']
name='asan' if san else 'O2';out=D/name;out.mkdir(exist_ok=True)
cmd=['cc','-std=gnu11','-O2','-g','-Wall','-Wextra','-Werror','-ffp-contract=off','-fno-fast-math','-I'+str(R/'main'),'-I'+str(R/'tools/hostshim'),'-I'+str(H),*[str(R/s) for s in sources],str(D/'body_render.c'),'-lm','-o',str(out/'body')]
if san:cmd[1:1]=['-fsanitize=address,undefined','-fno-omit-frame-pointer']
(out/'command.json').write_text(json.dumps(cmd,indent=2));subprocess.run(cmd,check=True)
env=os.environ.copy();env['ASAN_OPTIONS']='detect_leaks=0';env['UBSAN_OPTIONS']='halt_on_error=1'
with open(out/'run.log','w') as f:subprocess.run([str(out/'body')],cwd=out,stdout=f,stderr=subprocess.STDOUT,env=env,check=True)
print((out/'run.log').read_text().splitlines()[-2:])
