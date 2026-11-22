"""Warm bounce on the phase-invariant rim of the main white tank only."""
from pathlib import Path
from shutil import copyfile
from PIL import Image
import numpy as np,json,hashlib
P=Path(__file__).resolve().parent
V58=P.parent/'chair-engine-v8-58';V59=P.parent/'chair-engine-v8-59';L05=P.parent/'chair-engine-v8-54';S=P.parent/'chair-engine-v8-56';LIQ=P.parent/'chair-engine-v8-53c'
read=lambda f:Image.open(f).convert('RGBA')
def a(im):return np.array(im).astype(np.int16)
def q(im):
 m=np.asarray(im).astype(np.uint16);return ((m[:,:,0]>>3)<<11)+((m[:,:,1]>>2)<<5)+(m[:,:,2]>>3)
def edit(img,d):
 z=a(img);z[:,:,:3]=np.clip(np.rint(z[:,:,:3]+d),0,255);out=Image.fromarray(z.astype(np.uint8));assert out.getchannel('A').tobytes()==img.getchannel('A').tobytes()
 return out
root=P/'tank-reflection-crops';root.mkdir(exist_ok=True)
rec={'v58_sha':hashlib.sha256((V58/'human-chair-engine-v8-58.blend').read_bytes()).hexdigest(),
 'slots':{'clamp':3,'case':5,'cable':9},'v61_predecessor':'4187865f73b5a11726a90ecfcaea439ffcaf15f3a492aaa7bb40d50c2742ca62','v60_predecessor':'666192ff33c5546e6ee0c0a643e92378c7457a727e834565658766f61e5eacf1','predecessor_sha':'0613e4fdd006ed19f0d92bf72ff75142b4ca6e7da09a4f6629e1f4107894542e','views':{},'steps':'Every step chooses the same rotating base as v58. This independent color delta applies to every allowed main slosh and bottle frame; 5,11 exact quiet. Shared local field restricted to phase-invariant case, nearest stationary clamp and cable bend. No liquid or bottle exposure.'}
K=(1,.97,.62,.40,.20,0)
for src in sorted((V58/'assets').glob('rear_*')):
 d=P/'assets'/src.name;d.mkdir(parents=True,exist_ok=True);s=src.name

 for f in src.glob('*.png'):copyfile(f,d/f.name)
 a05=L05/'assets'/s
 phases={k:read(a05/('layer_05.png' if k=='settled' else f'phase-proxy-{k}.png')) for k in ('settled','left','right')}
 b=a(phases['settled']);yy,xx=np.mgrid[:b.shape[0],:b.shape[1]]
 c=np.ones(b.shape[:2],dtype=bool)
 for k,im in phases.items():
  c&=np.all(a(im)==b,axis=2)
  c&=a(read(LIQ/'assets'/s/f'legacy-matte-{k}.png'))[:,:,3]==0
 # Below the top of the plate and above the phase-dependent meniscus. No spill to fittings.
 c&=(yy>=56)&(yy<=68)&(b[:,:,3]>=128)
 c&=a(read(a05/'phase-proxy-off.png'))[:,:,3]==0
 for k in range(6):
  c&=np.all(a(read(a05/f'bottle-proxy-{k}.png'))==b,axis=2)
 c&=a(read(src/'mask.png'))[:,:,3]>0
 stat={i:read(src/f'layer_{i:02}.png') for i in (1,2,3,6,7,8,9)}
 base=read(src/'base.png')
 def full(i,plate,near=False):
  ps=read(S/'assets'/s/f'engine-proxy-{i%6}.png')
  attrs={j:read(src/f'{k}-on-{i}.png') if i%6!=5 else (ps if j==4 else stat[j]) for j,k in ((2,'wall'),(4,'engine'),(8,'hose'))}
  attrs[5]=plate;f=base
  if near:
   attrs[2]=edit(attrs[2],frame_spill(i))
   for j,asset in ((3,'clamp'),(9,'cable')):attrs[j]=edit(stat[j],receiver(i,j))
  for j in range(1,10):f=Image.alpha_composite(f,attrs[j] if j in attrs else stat[j])
  return f
 def fieldx(i):
  return {'rear_+00':(129,110),'rear_+35':(115.5,108.5),'rear_-35':(132,122.2)}[s][i//6]
 def receiver(i,j):
  x=fieldx(i);raw=a(stat[j]);z=57.1 if j==3 else 62.5
  r=((xx-x)/6.0)**2+((yy-z)/3.3)**2
  W=np.exp(-.5*r)*(r<5.2)*(raw[:,:,3]>=70)*(a(read(src/'mask.png'))[:,:,3]>0)
  # Narrow passive metal rim and nearest copper cable bend. Both cooler/dimmer than ignition edge.
  maximum=np.max(raw[:,:,:3],axis=2)
  w=.26+.74*np.clip((maximum-39)/113,0,1)
  peak=37 if j==3 else 30
  return (W*w*K[i%6])[:,:,None]*np.array([peak,peak*.43,peak*.11])
 # Art-direction at native size. The penumbra widens a silhouette thrown
 # by the existing hose across the fixed neutral case shoulder (not liquid).
 # Use bank/readability at oblique to clip rather than to shift anatomy.
 masks={}
 def frame_spill(i):
  around={'rear_+00':(129,110),'rear_+35':(117,107),'rear_-35':(132,121)}[s][i//6]
  W=np.exp(-.5*(((xx-around)/9.)**2+((yy-62)/7.2)**2))
  W*=(abs(xx-around)<14)&(yy>=51)&(yy<=72)&(a(read(src/'mask.png'))[:,:,3]>0)&(a(read(src/'layer_02.png'))[:,:,3]>32)
  return W[:,:,None]*K[i%6]*[33,20,8]
 def delta(i,unoccluded=False):
  k=i//6
  bank=fieldx(i)
  center={'rear_+00':(119.8,112.1),'rear_+35':(115.0,111.2),'rear_-35':(128.7,124.3)}[s][k]
  slope=(-.14 if k==0 else .21)
  if s=='rear_+35':slope*=.76
  if s=='rear_-35':slope*=1.09
  # Entire rigid case face is a single high-value graphic mass. A crisp,
  # camera-masked charcoal diagonal interrupts that face by several rows.
  xc={'rear_+00':(121,115),'rear_+35':(114,111),'rear_-35':(128,124)}[s][k]
  zc=64.8
  diag=zc+(-.32 if k==0 else .34)*(xx-xc)
  shade=(abs(xx-xc)<=6.5)&(abs(yy-diag)<=1.77)&c
  hot=np.empty_like(b[:,:,:3]);hot[:]=[250,231,189]
  cold=np.empty_like(hot);cold[:]=[77,68,63]
  flat=np.where(shade[:,:,None],cold,hot) if not unoccluded else hot
  masks[i]=(shade,c)
  return (flat-b[:,:,:3])*c[:,:,None]*K[i%6]
 pack=root/s;pack.mkdir(exist_ok=True)
 coords=np.zeros_like(c);out={};nearcoords={3:np.zeros_like(c),9:np.zeros_like(c)}
 for i in range(12):
  D=delta(i);Dd=np.int16(np.round(D));coords|=np.any(Dd,axis=2)
  elapsed={}
  for k,img in phases.items():
   new=edit(img,D)
   if k=='settled' and i%6!=5:
    img.save(d/f'tank-off-{i}.png');new.save(d/f'tank-on-{i}.png')
   if k!='settled' and i%6!=5:
    new.save(d/f'tank-{k}-on-{i}.png')
   orig=full(i,img);on=full(i,new,near=True)
   if k=='settled':
    assert a(orig).tobytes()==a(read(src/f'effect-{i}.png')).tobytes()
    orig.save(d/f'no-tank-glint-{i}.png');on.save(d/f'tank-glint-{i}.png')
    if i in (0,6):
     sh,lit=masks[i]
     U=edit(img,delta(i,True));U.save(d/f'tank-unblocked-{i}.png');Un=full(i,U,near=True);Un.save(d/f'no-hose-cast-{i}.png')
     # Measurable difference on truly visible pixels in full composite.
     oc=(a(Un)[:,:,0]-a(on)[:,:,0])
     ix=np.uint8(np.clip(oc*4,0,255));Image.fromarray(ix).save(d/f'visible-cast-matte-{i}.png')
     real=a(read(src/f'control-{i}.png')); change=(a(on)[:,:,0]-real[:,:,0]); np.save(d/f'cast-stats-array-{i}.npy',np.stack((oc,change),axis=2))
   elapsed[k]=int(np.sum(q(orig)!=q(on)))
  out[str(i)]={'rgb565_full_incremental_by_slosh':elapsed,
   'case_only_settled':int(np.sum(q(full(i,phases['settled']))!=q(full(i,edit(phases['settled'],D)))))}
  if i%6!=5:
   prior=read(src/f'wall-on-{i}.png')
   edited=edit(prior,frame_spill(i))
   prior.save(d/f'wall-v58-{i}.png');edited.save(d/f'wall-v62-{i}.png')
   for j,asset in ((3,'clamp'),(9,'cable')):
    dR=receiver(i,j);post=edit(stat[j],dR)
    cR=np.any(a(post)[:,:,:3]!=a(stat[j])[:,:,:3],axis=2);nearcoords[j]|=cR
    stat[j].save(d/f'{asset}-off-{i}.png');post.save(d/f'{asset}-on-{i}.png')
   # RGB outside aperture must stay untouched even after receiver order interplay.
   gate=a(read(src/'mask.png'))[:,:,3]==0;onA=a(full(i,edit(phases['settled'],D),near=True));offA=a(full(i,phases['settled']))
   assert np.array_equal(onA[gate],offA[gate])

 yi,xi=np.where(coords); bounds=(int(xi.min()),int(yi.min()),int(xi.max()+1),int(yi.max()+1))
 for i in range(12):
  if i%6==5:continue
  DD=np.int16(np.round(delta(i)));alpha=np.uint8(np.any(DD,axis=2))*255
  for pol in (-1,1):
   plane=np.uint8(np.clip(pol*DD,0,255))
   Image.fromarray(np.dstack((plane,alpha))).crop(bounds).save(pack/f'{"plus" if pol==1 else "minus"}-{i}.png')
 extras={}
 for j,asset in ((3,'clamp'),(9,'cable')):
  xys=np.where(nearcoords[j]);iy,ix=xys
  curb=(int(ix.min()),int(iy.min()),int(ix.max()+1),int(iy.max()+1)) if len(ix) else (0,0,1,1)
  extra=pack/asset;extra.mkdir(exist_ok=True)
  for i in range(12):
   if i%6==5:continue
   Dd=np.uint8(np.round(receiver(i,j))); Al=np.uint8(np.any(Dd,axis=2))*255
   Image.fromarray(np.dstack((Dd,Al))).crop(curb).save(extra/f'delta-{i}.png')
  extras[asset]={'originXY':curb[:2],'sizeWH':[curb[2]-curb[0],curb[3]-curb[1]]}
 rec['views'][s]={'case':{'originXY':bounds[:2],'sizeWH':[bounds[2]-bounds[0],bounds[3]-bounds[1]]},'adjacent':extras,'steps':out}
(root/'manifest.json').write_text(json.dumps(rec,indent=2)+'\n')
