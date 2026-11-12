from pathlib import Path
import json,hashlib,os,subprocess,sys,math,numpy as np
from PIL import Image
R=Path(__file__).resolve().parent;W=R.parent;sys.path.insert(0,str(R/'code'));from geometry_certificate import verify,runtime,sha
O=R/'holdout-002';O.mkdir(exist_ok=False);target=[-.28,.25,1.8];dist=8;ortho=4.8
B=lambda p:[38*p[0],-38*p[2],-38*p[1]]
views=[]
for az,el in [(247.5,12.5),(292.5,27.5)]:
 a,e=math.radians(az),math.radians(el);direction=[math.cos(e)*math.cos(a),math.cos(e)*math.sin(a),math.sin(e)];location=[t+dist*d for t,d in zip(target,direction)];views.append({'name':f'az{az}-el{el}','sourceAzimuthDegrees':az,'sourceElevationDegrees':el,'sourceLocation':location,'sourceTarget':target,'distance':dist,'verticalOrtho':ortho,'nativeCamera':B(location)+B(target)+[135/(ortho*38),119.5,67]})
plan={'scope':'Prospective native functional holdout views only; no reference fitting or reference score; separate from formal all10 and geometry audit','directionConvention':'XY azimuth from +X toward +Y, Z elevation','mapping':'[38*x,-38*z,-38*y]','views':views};(O/'camera-plan.json').write_text(json.dumps(plan,indent=2));planpin=sha(O/'camera-plan.json');rows=[]
arms={'stage2':(W/'fox-v3-occlusion-evaluation/actual-stage2','810bab6469f8973efefdb6d490aca5619fcecf9e126fd11d85aa14555bbde1e2'),'eyeB':(R/'actual-eyeB','a8b9778f4915b6bab4a9c2312397f361280c4ef787353a466082fe87e803b116')}
for view in views:
 for arm,(root,pin) in arms.items():
  c=verify(root,pin);cfg=json.loads((root/'inputs/candidate-config.json').read_text());case=next(x for x in cfg['scenarios'] if x['name']=='baseline');exe=root/'native-render';model=root/'compiled/model-baseline/model.aynm';ground=root/case['ground']['inputFile'];light=root/'physical-baseline.txt';pins={str(p):sha(p) for p in [Path(__file__),O/'camera-plan.json',exe,model,ground,light,root/'inputs/candidate-config.json',root/'inputs/geometry-certificate.json']};prefix=O/(view['name']+'-'+arm);cam=view['nativeCamera'];cmd=[str(exe),str(model),str(prefix),'0',*map(str,cam),*map(str,case['nativeDirection']+case['intensity'])];env=dict(os.environ,HONE_LINEAR_LIGHT='1',HONE_PIXEL_LIGHT='1',HONE_PIXEL_VISIBILITY='1',HONE_TRANSPORT_MODE='2',HONE_OUTER_SAMPLES='16',HONE_GROUND_MODE='2',HONE_GROUND_FILE=str(ground),HONE_DISK_FILE=str(light));p=subprocess.run(cmd,capture_output=True,text=True,env=env);Path(str(prefix)+'.stdout').write_text(p.stdout);Path(str(prefix)+'.stderr').write_text(p.stderr);row={'arm':arm,'view':view['name'],'command':cmd,'returncode':p.returncode,'inputHashes':pins,'certificateSHA256':pin,'status':'FAILED_UNSCORED' if p.returncode else 'COMPLETE_DIAGNOSTIC_ONLY'}
  if p.returncode==0:
   m=json.loads(p.stdout);assert all(abs(float(np.float32(a))-b)<1e-6 for a,b in zip(cam,m['camera']));assert m['groundMode']==2 and m['transportComplete'] and m['visibilityComplete'];runtime(m,c);assert m['work']<=8000000
   for group in ['visibility','transport']:
    for used,limit in [('Rays','RayLimit'),('NodeVisits','NodeLimit'),('TriangleTests','TriangleLimit'),('SceneBytes','SceneLimit')]:assert m[group+used]<=m[group+limit]
   row['metadata']=m;row['expectedNativeCameraFloat32']=[float(np.float32(v)) for v in cam];u=np.fromfile(str(prefix)+'.u16le','<u2').reshape(135,240);z=np.fromfile(str(prefix)+'.f32le','<f4').reshape(135,240);assert np.all(np.isfinite(z)|np.isneginf(z));rgb=np.stack([((u>>11)&31)/31,((u>>5)&63)/63,(u&31)/31],-1);im=Image.fromarray(np.floor(rgb*255+.5).astype('uint8'));im.save(str(prefix)+'.png');im.resize((720,405),Image.Resampling.NEAREST).save(str(prefix)+'-nearest3x.png');row['outputHashes']={str(Path(str(prefix)+ext).name):sha(Path(str(prefix)+ext)) for ext in ['.u16le','.f32le','.png','-nearest3x.png']}
  assert all(sha(Path(p))==h for p,h in pins.items());verify(root,pin);rows.append(row);(O/'progress.json').write_text(json.dumps(rows,indent=2));print(arm,view['name'],row['status'],flush=True)
assert sha(O/'camera-plan.json')==planpin;(O/'result.json').write_text(json.dumps({'status':'COMPLETE_DIAGNOSTIC_ONLY' if all(x['returncode']==0 for x in rows) else 'INCOMPLETE_UNSCORED','referenceScore':False,'cameraPlanSHA256':planpin,'rows':rows},indent=2))
