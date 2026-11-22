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
 'slots':{'clamp':3,'case':5,'cable':9},'predecessor_sha':'0613e4fdd006ed19f0d92bf72ff75142b4ca6e7da09a4f6629e1f4107894542e','views':{},'steps':'Every step chooses the same rotating base as v58. This independent color delta applies to every allowed main slosh and bottle frame; 5,11 exact quiet. Shared local field restricted to phase-invariant case, nearest stationary clamp and cable bend. No liquid or bottle exposure.'}
K=(1,.84,.65,.46,.25,0)
for src in sorted((V58/'assets').glob('rear_*')):
 d=P/'assets'/src.name;d.mkdir(parents=True,exist_ok=True);s=src.name
 raw=P/'probe'/s
 for f in src.glob('*.png'):copyfile(f,d/f.name)
 a05=L05/'assets'/s
 phases={k:read(a05/('layer_05.png' if k=='settled' else f'phase-proxy-{k}.png')) for k in ('settled','left','right')}
 b=a(phases['settled']);yy,xx=np.mgrid[:b.shape[0],:b.shape[1]]
 c=np.ones(b.shape[:2],dtype=bool)
 for k,im in phases.items():
  c&=np.all(a(im)==b,axis=2)
  c&=a(read(LIQ/'assets'/s/f'legacy-matte-{k}.png'))[:,:,3]==0
 # Below the top of the plate and above the phase-dependent meniscus. No spill to fittings.
 c&=(yy>=59)&(yy<=66)&(b[:,:,3]>=128)
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
 # Cycles pair: same proxy camera and light, with only hose shadow rays disabled
 # in the control, to extract a registered receiver-specific shadow loss field.
 def rawp(st):
  on=a(read(raw/f'{st}.png'))[:,:,:3].astype(float)
  off=a(read(raw/'off.png'))[:,:,:3].astype(float)
  u=a(read(raw/f'{st}-unblocked.png'))[:,:,:3].astype(float)
  noff=a(read(raw/'off-unblocked.png'))[:,:,:3].astype(float)
  direct=np.maximum(on-off-3,0)
  unblocked=np.maximum(u-noff-3,0)
  return direct,unblocked
 maps=[rawp('left'),rawp('right')]
 masks={}
 def delta(i,unoccluded=False):
  x=fieldx(i)
  D,U=maps[i//6]
  f=np.exp(-.5*((xx-x)/8.2)**2)*np.exp(-.5*((yy-64.2)/2.9)**2)
  f*=c
  # AO-free bounce from the same light path fills the existing dark band.
  # Then actual paired source response cuts the redirect into two parts.
  path=np.clip((U[:,:,0]-9)/40,0,1)*f
  shade=np.clip((U[:,:,0]-D[:,:,0]-4)/37,0,1)
  occl=path*shade
  exterior=path*(1-shade)
  # Retain at least cool-grey unlit shadow, with a modest same-source bounce.
  a0=np.min(b[:,:,:3],axis=2)
  maxlift=np.clip(240-a0,0,80)
  f0=np.clip(f*(26 if unoccluded else 28-13*shade)+71*(path if unoccluded else exterior),0,maxlift)
  if not unoccluded:masks[i]=(occl,exterior)
  return (f0*K[i%6])[:,:,None]*np.array([1,.77,.49])
 pack=root/s;pack.mkdir(exist_ok=True)
 coords=np.zeros_like(c);out={};nearcoords={3:np.zeros_like(c),9:np.zeros_like(c)}
 for i in range(12):
  D=delta(i);Dd=np.uint8(np.round(D));coords|=np.any(Dd,axis=2)
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
  DD=np.uint8(np.round(delta(i))); alpha=np.uint8(np.any(DD,axis=2))*255
  # Color deltas use additive semantics, not source-over.
  Image.fromarray(np.dstack((DD,alpha))).crop(bounds).save(pack/f'delta-{i}.png')
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
