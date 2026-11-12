import sys,subprocess
from pathlib import Path
R=Path(__file__).resolve().parents[2];sys.path.insert(0,str(R/'tools/kasane_contract'))
from run_meshbench_app import build_harness
batch='--batch' in sys.argv
b,o,e=build_harness('tools/qemu_skin/generated/'+('batch.c' if batch else 'scene.c'),'qemu-skin-batch-host' if batch else 'qemu-skin-host',extra_flags=['-I'+str(R/'tools/qemu_skin/generated')])
e['ASAN_OPTIONS']='detect_leaks=0:abort_on_error=1'
p=subprocess.run([str(b),'4','1','embedded'],cwd=R,env=e,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
(R/('tools/qemu_skin/host-batch.log' if batch else 'tools/qemu_skin/host.log')).write_text(p.stdout);print('host exit',p.returncode);p.check_returncode()
