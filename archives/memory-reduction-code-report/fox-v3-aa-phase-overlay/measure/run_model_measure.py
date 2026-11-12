from pathlib import Path
import json,subprocess,hashlib
R=Path(__file__).resolve().parents[1];B=R/'build-product';m=json.loads((B/'BUILD.json').read_text());cmd=m['commands'][0][:]
cmd[cmd.index('-c')+1]=str(R/'measure/model_storage.c');cmd[cmd.index('-o')+1]=str(R/'measure/model_storage.o');cmd[cmd.index('-MF')+1]=str(R/'measure/model_storage.d');subprocess.run(cmd,check=True)
objs=[str(B/(Path(c[c.index('-c')+1]).stem+'.o')) for c in m['commands'][3:-1]]
link=['cc',str(R/'measure/model_storage.o'),*objs,'-lm','-o',str(R/'measure/model_storage')];subprocess.run(link,check=True)
model=json.loads((R.parent/'fox-v3-indexed-transport-input/actual-off-001/native-front-baseline.command.json').read_text())['command'][1]
s=subprocess.check_output([str(R/'measure/model_storage'),model],text=True);(R/'measure/MODEL_STORAGE.json').write_text(s)
(R/'measure/PROVENANCE.json').write_text(json.dumps({'actualFrames':0,'commands':[cmd,link],'modelPath':model,'modelSHA256':hashlib.sha256(Path(model).read_bytes()).hexdigest(),'buildManifestSHA256':hashlib.sha256((B/'BUILD.json').read_bytes()).hexdigest()},indent=2)+'\n');print(s)
