"""Project matched wrist-pin light/shadow, join independent fixed-angle clocks."""
from pathlib import Path
from PIL import Image
import numpy as np,json,hashlib
P=Path(__file__).resolve().parent;root=P.parent;M=root/'chair-engine-v8-56';T=root/'chair-engine-v8-54';L=root/'chair-engine-v8-53c'
def A(path):return np.asarray(Image.open(path).convert('RGBA')).astype(float)
def img(a):return Image.fromarray(np.uint8(np.clip(np.round(a),0,255)))
def add(a,d):
 b=a.copy();b[:,:,:3]+=d
 q=np.asarray(img(b))
 assert np.array_equal(q[:,:,3],a[:,:,3]);return q.astype(float)
def rgb565(a):
 b=a.astype(np.uint16);return ((b[:,:,0]>>3)<<11)+((b[:,:,1]>>2)<<5)+(b[:,:,2]>>3)
epochs=(1,.96,.64,.41,.21,0)
rgba=(1,.74,.43)
lut=[.2126,.7152,.0722]
R=P/'phase-assets';R.mkdir(exist_ok=True)
records={}
for dr in sorted((P/'probe').glob('rear_*')):
 view=dr.name;B=M/'assets'/view;TF=T/'assets'/view
 out=P/'assets'/view;out.mkdir(parents=True,exist_ok=True)
 Aout=R/view;Aout.mkdir(exist_ok=True)
 base=A(B/'base.png')
 source={j:A(B/f'layer_{j:02}.png') for j in (1,2,3,5,6,7,8,9)}
 mask=A(B/'mask.png')[:,:,3]>0
 for pth in B.glob('layer_*.png'):img(A(pth)).save(out/pth.name)
 img(base).save(out/'base.png');img(A(B/'mask.png')).save(out/'mask.png')
 full0={k:A(TF/('layer_05.png' if k=='settled' else f'phase-proxy-{k}.png')) for k in ('settled','left','right')}
 g=full0['settled'];yy,xx=np.mgrid[:g.shape[0],:g.shape[1]]
 guard=(g[:,:,3]>=128)&(yy>=57)&(yy<=67)&mask
 for k,b in full0.items():
  guard&=np.all(g==b,axis=2)
  guard&=A(L/'assets'/view/f'legacy-matte-{k}.png')[:,:,3]==0
 for i in range(6):guard&=np.all(g==A(TF/f'bottle-proxy-{i}.png'),axis=2)
 guard&=A(TF/'phase-proxy-off.png')[:,:,3]==0
 phaseMeta=json.loads((T/'phase-assets/manifest.json').read_text())['flipbook'][view]
 bottleMeta=json.loads((T/'bottle-phase-assets/manifest.json').read_text())['views'][view]
 def merge05(k,idx):
  out0=Image.new('RGBA',(240,135));p=Image.open(T/'bottle-phase-assets'/view/f'{idx}.png');out0.paste(p,tuple(bottleMeta['xy']))
  src=Image.new('RGBA',(240,135))
  src.paste(Image.open(T/'phase-assets'/view/f'{k}.png'),tuple(phaseMeta['originXY']))
  return np.asarray(Image.alpha_composite(out0,src)).astype(float)
 test=merge05('settled',2); assert np.array_equal(test[:,:,3],g[:,:,3]) and np.array_equal(test[g[:,:,3]>0],g[g[:,:,3]>0])
 chroma=[]
 for name in ('left','right'):
  def get(n):return A(dr/f'{n}.png')[:,:,:3]
  actual=get(name)-get('off')
  eng=(get(name+'-open')-get('off-open'))-actual
  direct=actual@lut
  loss=np.clip((eng@lut-5)/60,0,1)
  ww=np.maximum(direct-4,0)*mask*(yy>=45)*(yy<=58)
  xp=float(np.sum(xx*ww)/np.maximum(1,ww.sum()))
  chroma.append((actual,loss,xp))
 def stages(i,k,bottle,enabled=True,ignore_caster=False):
  engine=A(B/f'engine-proxy-{i%6}.png')
  s={**source,4:engine,5:merge05(k,bottle)}
  if not enabled or i%6==5:return s
  e,S,c=chroma[i//6]
  f=epochs[i%6]
  W=np.exp(-.5*((xx-c)/8.7)**2)
  ar=np.maximum(e@lut-3,0)
  exact01=np.exp(-.5*((yy-53)/5)**2)*np.exp(-.5*((xx-c)/7)**2)
  wall=(W*np.exp(-.5*((yy-53)/8.)**2))*mask
  for j,d in ((2,wall*20),(3,wall*14),(4,np.clip(ar*.78,0,47)*exact01+exact01*12),
   (8,np.clip(ar*.52,0,36)*(yy>=54)*(yy<=66)),
   (9,wall*11)):
   s[j]=add(s[j],(d*f*mask*(s[j][:,:,3]>0))[:,:,None]*np.array(rgba))
  # Keep a geometric caster response: a paired engine-shadow toggle locates
  # the dark region; shape is never reused from v60/v62's old hose model.
  direct=W*np.exp(-.5*((yy-64)/4)**2)
  U=np.clip(235+10*W,0,250)[:,:,None]
  hot=np.concatenate([U,U*.924,U*.784],axis=2)
  case=s[5];lift=(hot-case[:,:,:3])*np.clip(direct*1.72,0,1)[:,:,None]
  loss=np.clip(S*2.2,0,1)*direct
  reduce=0 if ignore_caster else loss[:,:,None]*[114,111,102]
  s[5]=add(case,(lift-reduce)*guard[:,:,None]*f)
  return s
 def comp(s):
  q=img(base)
  for j in range(1,10):q=Image.alpha_composite(q,img(s[j]))
  return np.array(q).astype(float)
 exp={}
 for i in range(12):
  off=stages(i,'settled',2,False); on=stages(i,'settled',2)
  for j,n in ((2,'wall'),(3,'clamp'),(4,'engine'),(5,'tank'),(8,'hose'),(9,'cable')):
   img(off[j]).save(out/f'{n}-off-{i}.png');img(on[j]).save(out/f'{n}-on-{i}.png')
   if i%6!=5:
    p=Aout/n;p.mkdir(exist_ok=True)
    dd=on[j][:,:,:3]-off[j][:,:,:3]
    # Transparent outside changed receiver; signed positive minus negative.
    idx=np.any(dd!=0,axis=2);y,x=np.where(idx)
    if len(y):
     bb=(min(x),min(y),max(x)+1,max(y)+1)
     for k,sig in [('plus',1),('minus',-1)]:
      img(np.dstack((np.maximum(dd*sig,0),255*idx))).crop(bb).save(p/f'{i}-{k}.png')
    else:bb=()
    exp.setdefault(str(i),{})[n]={'crop':tuple(map(int,bb))}
  A0,B0=comp(off),comp(on); assert np.array_equal(A0[~mask],B0[~mask])
  img(A0).save(out/f'control-{i}.png');img(B0).save(out/f'effect-{i}.png')
  if i in (0,6):
   alt=stages(i,'settled',2,True,True);C=comp(alt)
   img(alt[5]).save(out/f'tank-unblocked-{i}.png');img(C).save(out/f'no-engine-cast-{i}.png')
   occ=(C-B0)[:,:,:3]@lut; bright=(B0-A0)[:,:,:3]@lut
   exp[str(i)]['native']={'white_peak_luma':round(max(bright[59:68].flat),1),
     'caster_loss_peak_luma':round(max(occ[59:68].flat),1),'caster_loss_ge12':int(np.sum(occ[59:68]>=12)),
     'matches_rgb565':int(np.sum(rgb565(A0)!=rgb565(B0)))}
 records[view]={'capture_centers_x':[round(c[2],2) for c in chroma],'steps':exp}
(R/'manifest.json').write_text(json.dumps({'v56':hashlib.sha256((M/'human-chair-engine-v8-56.blend').read_bytes()).hexdigest(),'source':'Actual wrist pin, matched no-light and engine-caster disabled Cycles. Stylized case retains geometry direction from paired caster toggle.','replaces_slots':[2,3,4,5,8,9],'views':records},indent=2)+'\n')
