from pathlib import Path
import subprocess,json,hashlib
D=Path(__file__).resolve().parent;S=D.parent.parent/'fox-v3-lighting-ab/four-both-002/product/main';cmd=['cc','-std=c11','-O2','-shared','-fPIC','-ffp-contract=off','-fexcess-precision=standard','-I',str(S),str(D/'native_encode.c'),'-lm','-o',str(D/'native_encode.so')];subprocess.run(cmd,check=True)
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
(D/'build-manifest.json').write_text(json.dumps({'command':cmd,'compilerVersion':subprocess.check_output(['cc','--version'],text=True).splitlines()[0],'sourceSHA256':sha(D/'native_encode.c'),'actualShadeHeaderSHA256':sha(S/'ayatsuri/ayatsuri_shade.h'),'binarySHA256':sha(D/'native_encode.so')},indent=2))
