from pathlib import Path
import subprocess,json,sys,os
R=Path(__file__).resolve().parents[1];B=R/'build-adapter';manifest=json.loads((B/'BUILD.json').read_text());san='--sanitize' in sys.argv;D=R/'review'/('build-wrapper-san' if san else 'build-wrapper');D.mkdir(exist_ok=True)
extra=['-fsanitize=address,undefined','-fno-omit-frame-pointer'] if san else []
objects=[]
for index in [*range(3,len(manifest['commands'])-1),2]:
 cmd=list(manifest['commands'][index]);old=Path(cmd[cmd.index('-o')+1]);out=D/old.name
 cmd[1:1]=extra;cmd[cmd.index('-o')+1]=str(out);cmd[cmd.index('-MF')+1]=str(D/(old.stem+'.d'));subprocess.run(cmd,check=True);objects.append(str(out))
cmd=list(manifest['commands'][1]);cmd[1:1]=extra+['-I',str(R/'harness')];cmd[cmd.index('-c')+1]=str(R/'review/test_wrapper_final_gate.c');cmd[cmd.index('-o')+1]=str(D/'test.o');cmd[cmd.index('-MF')+1]=str(D/'test.d');subprocess.run(cmd,check=True)
subprocess.run(['cc',*extra,str(D/'test.o'),*objects,'-lm','-o',str(D/'test_wrapper_final_gate')],check=True)
result=subprocess.run([str(D/'test_wrapper_final_gate')],capture_output=True,text=True);(D/'result.log').write_text(result.stdout+result.stderr);print(result.stdout+result.stderr);result.check_returncode()
