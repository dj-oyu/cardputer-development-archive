from pathlib import Path
import json,subprocess,os
R=Path(__file__).resolve().parents[1];D=R/'review/build';D.mkdir(exist_ok=True);m=json.loads((R/'build-product/BUILD.json').read_text())
compile=next(c for c in m['commands'] if '-c' in c and c[c.index('-c')+1].endswith('/row_transport_bridge.c'))
cmd=compile.copy();cmd[cmd.index('-c')+1]=str(R/'review/test_admission.c');cmd[cmd.index('-o')+1]=str(D/'test_admission.o');cmd[cmd.index('-MF')+1]=str(D/'test_admission.d');subprocess.run(cmd,check=True)
link=m['commands'][-1].copy();link=[str(D/'test_admission.o') if s.endswith('/row_transport_bridge.o') else s for s in link if not s.endswith('/native_render_row.o')];link[-1]=str(D/'test_admission');subprocess.run(link,check=True)
r=subprocess.run([str(D/'test_admission')],text=True,capture_output=True);(R/'review/ADMISSION_TEST.log').write_text(r.stdout+r.stderr);print(r.stdout+r.stderr);r.check_returncode()
