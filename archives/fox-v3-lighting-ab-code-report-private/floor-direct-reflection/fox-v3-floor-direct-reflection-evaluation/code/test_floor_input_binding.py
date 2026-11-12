from pathlib import Path
import json,sys,subprocess,os
D=Path(sys.argv[1]).resolve();O=Path(sys.argv[2]).resolve();assert not O.exists();O.mkdir();cfg=json.load(open(D/'inputs/candidate-config.json'));rows=[]
for ci,s in enumerate(cfg['scenarios']):
 values=[]
 for l in s['physical']['lights']:values+=l['position']+l['eulerXYZ']+l['color']+[l['power'],l['diameter']]
 values+=s['physical']['worldRGB']+[s['physical']['worldStrength']];f=O/f'{s["name"]}.txt';f.write_text('FOXDISK1\n'+' '.join(format(x,'.17g') for x in values)+'\n')
 for c in cfg['cameras']:
  for rev in [False,True]:
   name=f'{c["name"]}-{s["name"]}-{int(rev)}';p=O/name;env={**os.environ,'HONE_NORMAL_PAIR_CODEC':'1','HONE_LINEAR_LIGHT':'1','HONE_PIXEL_LIGHT':'1','HONE_PIXEL_VISIBILITY':'1','HONE_TRANSPORT_MODE':'2','HONE_OUTER_SAMPLES':'16','HONE_GROUND_MODE':'2','HONE_GROUND_FILE':str(D/'inputs'/f'ground-{s["name"]}.txt'),'HONE_DISK_FILE':str(f),'HONE_BOUNDARY_AA':'1','HONE_AA_LEDGER':str(D/f'ledger-{c["name"]}.txt'),'HONE_FLOOR_REFLECTION':'on','HONE_FLOOR_CASE':str((ci+1)%5)}
   cmd=[str(D/'native-render'),str(D/'compiled'/f'model-{s["name"]}/model.aynm'),str(p),str(int(rev)),*map(str,c['nativeCamera']),*map(str,s['nativeDirection']+s['intensity'])];z=subprocess.run(cmd,env=env,capture_output=True);assert z.returncode==2 and b'NATIVE_GATE:floor-input-binding' in z.stderr;assert not list(O.glob(name+'.*'));rows.append({'case':s['name'],'view':c['name'],'reverse':rev,'wrongCase':(ci+1)%5,'exit':z.returncode,'gate':'floor-input-binding','noOutputFiles':True})
(O/'RESULT.json').write_text(json.dumps({'status':'ALL20_WRONG_CASE_BINDINGS_REJECT_BEFORE_RENDER','rows':rows},indent=2)+'\n');print('ALL20_WRONG_CASE_BINDINGS_REJECT_BEFORE_RENDER')
