from pathlib import Path
import subprocess,json,os
R=Path(__file__).resolve().parents[1];D=R/'review/sanitized';D.mkdir(exist_ok=True);m=json.loads((R/'build-product/BUILD.json').read_text());objects=[]
with (R/'review/SANITIZED_BUILD.log').open('w') as log:
 for original in m['commands']:
  if '-c' not in original:continue
  cmd=original.copy();source=cmd[cmd.index('-c')+1]
  if source.endswith('/native_render_row.c'):continue
  name=Path(source).stem
  if name=='row_transport_bridge':cmd[cmd.index('-c')+1]=str(R/'review/test_admission.c');name='test_admission'
  cmd[1:1]=['-fsanitize=address,undefined','-fno-omit-frame-pointer'];out=D/(name+'.o');objects.append(str(out));cmd[cmd.index('-o')+1]=str(out);cmd[cmd.index('-MF')+1]=str(D/(name+'.d'));subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT,check=True)
 subprocess.run(['cc','-fsanitize=address,undefined',*objects,'-lm','-o',str(D/'test_admission')],stdout=log,stderr=subprocess.STDOUT,check=True)
r=subprocess.run([str(D/'test_admission')],env={**os.environ,'ASAN_OPTIONS':'detect_leaks=0'},text=True,capture_output=True);(R/'review/SANITIZED_TEST.log').write_text(r.stdout+r.stderr);print(r.stdout+r.stderr);r.check_returncode()
