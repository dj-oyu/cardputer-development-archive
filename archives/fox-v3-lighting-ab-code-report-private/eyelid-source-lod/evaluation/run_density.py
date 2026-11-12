from pathlib import Path
import json,hashlib,os,subprocess,sys,numpy as np
from PIL import Image
R=Path(__file__).resolve().parent;sys.path.insert(0,str(R/'code'));from geometry_certificate import verify,runtime,sha
stage=sys.argv[1];pin=sys.argv[2];B=R/('actual-'+stage+'-v2')
if stage=='eyeB':
 B=R.parent/'fox-v3-normal-pair-evaluation/actual-on'
 import importlib.util
 spec=importlib.util.spec_from_file_location('old_geometry_certificate',R.parent/'fox-v3-normal-pair-evaluation/code/geometry_certificate.py');old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old);verify=old.verify
cert=verify(B,pin);assert (B/'candidate-manifest.json').exists();D=R/('density-'+stage);D.mkdir(exist_ok=False)
cfg=json.loads((B/'inputs/candidate-config.json').read_text());cam=next(x for x in cfg['cameras'] if x['name']=='oblique')['nativeCamera'];case=next(x for x in cfg['scenarios'] if x['name']=='baseline');c=list(cam);c[6]*=2;c[7]=2*cam[7]-155.5;c[8]=2*cam[8]-21.5;assert c[7]==83.5 and c[8]==112.5
exe=B/'native-render';model=B/'compiled/model-baseline/model.aynm';ground=B/case['ground']['inputFile'];light=B/'physical-baseline.txt';pins={str(p):sha(p) for p in [Path(__file__),exe,model,ground,light,B/'inputs/candidate-config.json',B/'inputs/geometry-certificate.json']};prefix=D/'density2';args=[str(exe),str(model),str(prefix),'0',*map(str,c),*map(str,case['nativeDirection']+case['intensity'])];env=dict(os.environ,HONE_NORMAL_PAIR_CODEC='1',HONE_LINEAR_LIGHT='1',HONE_PIXEL_LIGHT='1',HONE_PIXEL_VISIBILITY='1',HONE_TRANSPORT_MODE='2',HONE_OUTER_SAMPLES='16',HONE_GROUND_MODE='2',HONE_GROUND_FILE=str(ground),HONE_DISK_FILE=str(light));p=subprocess.run(args,capture_output=True,text=True,env=env);(D/'stdout.json').write_text(p.stdout);(D/'stderr.txt').write_text(p.stderr)
result={'command':args,'returncode':p.returncode,'sourceCamera':cam,'diagnosticCamera':c,'mapping':'q=(2*px-155.5,2*py-21.5)','directFaceCropXYXY':[60,2,180,130],'status':'FAILED_UNSCORED' if p.returncode else 'COMPLETE_DIAGNOSTIC_ONLY','inputHashes':pins,'geometryCertificateSHA256':pin,'formalAdoption':False,'inheritedMuzzleGeometryGate':'FAIL_REMAINS','eyeGeometryGate':'SEE_SEPARATE_AUDIT'}
if p.returncode==0:
 m=json.loads(p.stdout);assert all(abs(a-b)<1e-5 for a,b in zip(c,m['camera']));assert m['groundMode']==2 and m['transportComplete'] and m['visibilityComplete'];runtime(m,cert);assert m['work']<=8000000 and m['snapshotBytes']<=65536
 for group in ['visibility','transport']:
  for used,lim in [('Rays','RayLimit'),('NodeVisits','NodeLimit'),('TriangleTests','TriangleLimit'),('SceneBytes','SceneLimit')]:assert m[group+used]<=m[group+lim]
 result['metadata']=m;u=np.fromfile(str(prefix)+'.u16le','<u2').reshape(135,240);z=np.fromfile(str(prefix)+'.f32le','<f4').reshape(135,240);assert np.all(np.isfinite(z)|np.isneginf(z));rgb=np.stack([((u>>11)&31)/31,((u>>5)&63)/63,(u&31)/31],-1);im=Image.fromarray(np.floor(rgb*255+.5).astype('uint8'));im.save(D/'density2-full.png');im.crop((60,2,180,130)).resize((360,384),Image.Resampling.NEAREST).save(D/'density2-face-nearest3x.png');result['outputHashes']={p.name:sha(p) for p in D.iterdir() if p.is_file()};result['cameraCropNotOriginalFullView']=True
assert all(sha(Path(p))==h for p,h in pins.items());verify(B,pin);(D/'result.json').write_text(json.dumps(result,indent=2));print(result['status'])
