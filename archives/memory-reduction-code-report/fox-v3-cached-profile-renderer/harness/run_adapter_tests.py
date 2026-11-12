"""Small admission/finish/prefix tests, zero physical shader calls."""
from pathlib import Path
import subprocess,json,sys
R=Path(__file__).resolve().parents[1];B=R/'build-adapter';manifest=json.loads((B/'BUILD.json').read_text());san='--sanitize' in sys.argv;D=R/('build-adapter-sanitized' if san else 'build-adapter');D.mkdir(exist_ok=True)
extra=['-fsanitize=address,undefined','-fno-omit-frame-pointer'] if san else []
objects=[]
for cmd0 in manifest['commands'][3:-1]:
 cmd=list(cmd0);old=Path(cmd[cmd.index('-o')+1]);out=D/old.name
 if san:
  cmd[1:1]=extra;cmd[cmd.index('-o')+1]=str(out);cmd[cmd.index('-MF')+1]=str(D/(old.stem+'.d'));subprocess.run(cmd,check=True)
 objects.append(str(out))
# profile is command2; transport bridge is included by test_adapter and separately linked for prefix.
for index in [2,1]:
 cmd=list(manifest['commands'][index]);old=Path(cmd[cmd.index('-o')+1]);out=D/old.name
 if san:
  cmd[1:1]=extra;cmd[cmd.index('-o')+1]=str(out);cmd[cmd.index('-MF')+1]=str(D/(old.stem+'.d'));subprocess.run(cmd,check=True)
 if index==2:objects.append(str(out))
for test,index in [('test_adapter',1),('test_cached_adapter',1),('test_prefix',0)]:
 cmd=list(manifest['commands'][index]);cmd[1:1]=extra;cmd[cmd.index('-c')+1]=str(R/'harness'/f'{test}.c');cmd[cmd.index('-o')+1]=str(D/f'{test}.o');cmd[cmd.index('-MF')+1]=str(D/f'{test}.d');subprocess.run(cmd,check=True)
 objs=objects+([str(D/'row_transport_bridge.o')] if test=='test_prefix' else [])
 subprocess.run(['cc',*extra,str(D/f'{test}.o'),*objs,'-lm','-o',str(D/test)],check=True)
 result=subprocess.run([str(D/test)],capture_output=True,text=True);(D/f'{test}.log').write_text(result.stdout+result.stderr);print(result.stdout+result.stderr);result.check_returncode()
