"""All negative image fixtures are rendered by real product C, not patched PNGs."""
import pathlib,sys,subprocess,json,hashlib
import numpy as np
from analyze import rgb565,geometry,metrics,response,read
root=pathlib.Path(__file__).resolve().parents[1];out=pathlib.Path(sys.argv[1]);out.mkdir(exist_ok=False);binary=pathlib.Path(sys.argv[2]).resolve()
def run(args):return subprocess.run(list(map(str,args)),capture_output=True,text=True,check=True)
run(['node',root/'code/fixtures.cjs',root/'product/tools/ayatsuri/model/pack_model.cjs',out])
cam=[0,0,200,0,0,0,1,119.5,67]
images={};depths={};hashes={}
for name,model,light in [('base','base',[.6,0,.8,1,1,1]),('missingEye','missingEye',[.6,0,.8,1,1,1]),('missingTail','missingTail',[.6,0,.8,1,1,1]),('depth0','depth0',[0,0,1,1,1,1]),('depth1','depth1',[0,0,1,1,1,1]),('direction','base',[-.6,0,-.8,1,1,1]),('intensity','base',[.6,0,.8,.4,.4,.4]),('red','base',[.6,0,.8,1,.4,.2]),('blue','base',[.6,0,.8,.2,.4,1])]:
 prefix=out/name;m=run([binary,out/(model+'.aynm'),prefix,0,*cam,*light]);(out/(name+'.json')).write_text(m.stdout)
 images[name]=rgb565(str(prefix)+'.u16le');depths[name]=np.fromfile(str(prefix)+'.f32le',dtype='<f4');hashes[name]=hashlib.sha256(pathlib.Path(str(prefix)+'.u16le').read_bytes()).hexdigest()
checks=[]
def check(name,condition):
 checks.append({'test':name,'pass':bool(condition)});assert condition,name
base=images['base'];mask=base.max(2)>0
# Independently declared reference feature ROIs, not selected from faulty candidate.
eye=np.zeros(mask.shape,bool);eye[47:60,104:117]=True;eye&=mask
tail=np.zeros(mask.shape,bool);tail[72:92,39:75]=True;tail&=mask
check('missing-eye color gate rejects valid new render',metrics(base,images['missingEye'],eye)['rgbMAE']>.02)
check('missing-tail geometry gate rejects valid new render',not geometry(base,images['missingTail'])['pass'])
check('same-color depth mutation keeps RGB',np.array_equal(images['depth0'],images['depth1']))
check('same-color depth mutation rejected by depth gate',np.any(depths['depth0']!=depths['depth1']))
check('wrong-direction color gate rejects',metrics(base,images['direction'],mask)['rgbMAE']>.1)
r=response(base,images['intensity'],base,base,mask);check('ignored-intensity one-side-unresponsive gate',r['oneSideUnresponsive'] and r['responseMagnitudeAgreementPercent']==0)
check('RGB-swapped light color gate rejects',metrics(images['red'],images['blue'],mask)['rgbMAE']>.1)
check('empty image rejected',not geometry(base,np.zeros_like(base))['pass'])
# Authentic fresh hashes validate; intentionally corrupt manifest hash is rejected separately.
check('fresh render hashes validate',all(hashes[n]==hashlib.sha256((out/(n+'.u16le')).read_bytes()).hexdigest() for n in images))
def mismatch(mode,ref,cand,*extra):
 proc=subprocess.run([sys.executable,str(root/'code/check_images.py'),mode,str(ref),str(cand),*map(str,extra)],capture_output=True,text=True)
 return proc.returncode==3 and json.loads(proc.stdout)=={'gate':mode,'pass':False}
check('hash corruption rejected by verifier',mismatch('hash','0'*64,out/'base.u16le'))
check('missing eye exits 3 with color gate',mismatch('color',out/'base.u16le',out/'missingEye.u16le',104,47,13,13))
check('missing tail exits 3 with geometry gate',mismatch('geometry',out/'base.u16le',out/'missingTail.u16le'))
check('depth only mutation exits 3 with depth gate',mismatch('depth',out/'depth0.f32le',out/'depth1.f32le'))
check('wrong direction exits 3 with color gate',mismatch('color',out/'base.u16le',out/'direction.u16le'))
check('swapped RGB exits 3 with color gate',mismatch('color',out/'red.u16le',out/'blue.u16le'))
for label,values in [('empty',[]),('short',[1]),('positiveInfinity',[np.inf]*32400),('allBackground',[-np.inf]*32400),('nan',[np.nan]*32400)]:
 invalid=out/(label+'.f32le');np.asarray(values,dtype='<f4').tofile(invalid)
 check('malformed depth '+label+' rejected',mismatch('depth',invalid,invalid))
(out/'detector-results.json').write_text(json.dumps({'checks':checks,'sha256':hashes,'scope':'real product renderer synthetic mutations; positive control + targeted image/depth diagnostics'},indent=2));print(json.dumps(checks))
