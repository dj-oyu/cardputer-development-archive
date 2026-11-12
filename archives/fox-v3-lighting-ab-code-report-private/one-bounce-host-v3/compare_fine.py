from pathlib import Path
import json,numpy as np
R=Path(__file__).resolve().parent
dec=lambda a:np.stack([(a>>11)/31,((a>>5)&63)/63,(a&31)/31],-1)
a=np.fromfile(R/'bounce-001/native-oblique-baseline.u16le','<u2');b=np.fromfile(R/'fine-001/native-oblique-baseline.u16le','<u2');z=np.fromfile(R/'bounce-001/native-oblique-baseline.f32le','<f4');m=np.isfinite(z);d=abs(dec(a)[m]-dec(b)[m]);j={'scope':'outer16 versus64, baseline only; direction fine render failed, no response-convergence estimate','coveragePixels':int(m.sum()),'changed565Pixels':int(((a!=b)&m).sum()),'RGB_MAE':d.mean(0).tolist(),'RGB_max':d.max(0).tolist(),'RGB_RMSE':np.sqrt((d*d).mean(0)).tolist(),'depthExact':(R/'bounce-001/native-oblique-baseline.f32le').read_bytes()==(R/'fine-001/native-oblique-baseline.f32le').read_bytes()};(R/'fine-001/comparison.json').write_text(json.dumps(j,indent=2))
