from pathlib import Path
import subprocess,sys,time
R=Path(__file__).resolve().parent
pins={'lid8':'a18011982c6e2338368a9e5bafacec6af5a5bad1c1206d05640cb075fcdb62c3','lid9':'4d5ece2a49f9111f8c881d4f0787db8595e8afaaef178839c9bd7a8f4ee5727b','eyeB':'a8d001fb56f999c90cc7ca75fe6ef6094a60ea5403979e6171635aa7eca5c10a'}
while not all((R/f'actual-{s}-v2/candidate-manifest.json').exists() for s in ['lid8','lid9']):
 for s in ['lid8','lid9']:assert 'Traceback' not in (R/f'actual-{s}-v2.log').read_text()
 time.sleep(5)
for s,pin in pins.items():
 with (R/f'density-{s}.log').open('w') as f:subprocess.run([sys.executable,str(R/'run_density.py'),s,pin],stdout=f,stderr=subprocess.STDOUT,check=True)
 print('density complete',s,flush=True)
with (R/'seen2.log').open('w') as f:subprocess.run([sys.executable,str(R/'run_seen2.py')],stdout=f,stderr=subprocess.STDOUT,check=True)
print('all diagnostics complete',flush=True)
