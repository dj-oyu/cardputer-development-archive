from pathlib import Path
import json,subprocess,sys,time
R=Path(__file__).resolve().parent;W=R.parent
pins={8:'a18011982c6e2338368a9e5bafacec6af5a5bad1c1206d05640cb075fcdb62c3',9:'4d5ece2a49f9111f8c881d4f0787db8595e8afaaef178839c9bd7a8f4ee5727b'}
for s,pin in pins.items():
 m=R/f'actual-lid{s}-v2/candidate-manifest.json'
 while not m.exists():
  assert 'Traceback' not in (R/f'actual-lid{s}-v2.log').read_text(),'run failure; not scored'
  time.sleep(5)
 with (R/f'score-lid{s}.log').open('w') as f:subprocess.run([sys.executable,str(R/'scoring/score_candidate.py'),str(m),'--geometry-certificate-sha256',pin,'--reference',str(W/'fox-reference-uncertainty-v3'),'--output',str(R/f'score-lid{s}')],stdout=f,stderr=subprocess.STDOUT,check=True)
 print('SCORED',s,flush=True)
for name in ['compare_actual.py','compare_face.py']:subprocess.run([sys.executable,str(R/name)],check=True)
