"""Native true turntable composites and exact same-frame 00/10/11 ignition controls."""
from PIL import Image,ImageChops
import numpy as np,json
from pathlib import Path
from timeline import N,FPS,state
P=Path(__file__).resolve().parent;prior=P.parent/'chair-depth-rotation'
pro=json.loads((P/'projection.json').read_text());load=lambda p:Image.open(p).convert('RGBA')
Y,X=np.mgrid[:135,:240].astype(float);X+=.5;Y+=.5
profile=(1,.96,.64,.41,.21,0)
def img(a):return Image.fromarray(np.uint8(np.round(np.clip(a,0,255))))
def q(m):
 t=np.asarray(m,dtype=np.uint16);return (t[:,:,0]>>3)*2048+(t[:,:,1]>>2)*32+(t[:,:,2]>>3)
out=P/'output';out.mkdir(exist_ok=True);proof=P/'controls';proof.mkdir(exist_ok=True)
record=[]
def pearl(a,f,visible,anchor,crank,amp):
 x,y=anchor;allowed=(a[:,:,3]>75)&visible&(f>.3)
 S=(X-x)**2+(Y-y)**2
 j=np.argmin(np.where(allowed&(S<=1.65**2),S+.35*(1-f),10000))
 if S.flat[j]>1.65**2 or not allowed.flat[j] or amp==0:return a.copy(),None
 yi,xi=np.unravel_index(j,S.shape);cx=X[yi,xi];cy=Y[yi,xi]
 vx,vy=np.array(crank)-np.array((cx,cy));length=np.hypot(vx,vy)
 if length<.1:return a.copy(),None
 vx,vy=np.array((vx,vy))/length*min(length,3.8)
 t=np.clip(((X-cx)*vx+(Y-cy)*vy)/(vx*vx+vy*vy),0,1)
 dist=np.sqrt((X-cx-t*vx)**2+(Y-cy-t*vy)**2)
 w=np.clip(1-dist/1.1,0,1)*(1-t*.72)*amp*allowed
 core=np.clip(1-(abs(X-cx)+abs(Y-cy))*.65,0,1)
 target=np.array([255,119,22])[None,None,:]+core[:,:,None]*[0,132,188]
 p=a.copy();p[:,:,:3]=np.clip(a[:,:,:3]*(1-w[:,:,None])+target*w[:,:,None],0,255)
 return p,(int(xi),int(yi))
frames=[]
for i in range(N):
 d=P/'frames'/f'{i:03}';r=pro[str(i)]
 mask=load(d/'mask.png').getchannel('A');m=np.asarray(mask)/255
 def clip(k):
    p=load(d/f'{k}.png');p.putalpha(ImageChops.multiply(p.getchannel('A'),mask));return p
 def alpha(p):return np.asarray(p.getchannel('A'))/255.
 base=load(d/'base.png');engine=clip('engine');tube=clip('pipe');cables=clip('layer_09')
 a=np.asarray(engine,dtype=float)
 foreground=(1-alpha(tube))*(1-alpha(cables))
 bank=r['crank']//6;amp=profile[r['crank']%6]
 e,pick=pearl(a,foreground,m>.10,r['pins'][bank],r['crankpin'],amp)
 stage=np.asarray(base,dtype=float).copy();rr=np.zeros(m.shape)
 if pick is not None:
    xx,yy=pick
    ds=(X-(xx+.5))**2+(Y-(yy+.5))**2
    wall=alpha(clip('layer_02'))
    case=alpha(clip('layer_04'));bottle=alpha(clip('layer_05'))
    # Only a nearby authored inner-metal receiver; completely exclude every
    # tank/bottle, engine, tube, cable and exterior alpha footprint.
    strict=(case<.03)&(bottle<.03)&(alpha(engine)<.18)&(alpha(tube)<.03)&(alpha(cables)<.03)&(m>.25)
    rr=np.exp(-ds/(2*1.9**2))*amp*wall*strict*(ds<4.6**2)
    stage[:,:,:3]+=rr[:,:,None]*[22,12,2]
 def comp(b,z):
    for lay in (z,tube,cables):b=Image.alpha_composite(b,lay)
    return b
 off=comp(base,engine);root=comp(base,img(e));yes=comp(img(stage),img(e))
 assert np.array_equal(np.asarray(off)[m==0],np.asarray(yes)[m==0])
 s1=q(off)!=q(root);s2=q(root)!=q(yes)
 assert not np.any(s1&(alpha(engine)==0))
 assert not np.any(s2&(rr==0))
 assert not np.any(s2&((alpha(tube)>=.03)|(alpha(cables)>=.03)))
 rec={'i':i,'yaw':r['yaw'],'crank':r['crank'],'bottle':r['bottle'],'tank':r['tank'],'pin':r['pins'][bank],'pin_lit_pixel':pick,
      'core_rgb565':int(np.count_nonzero(s1)),'inner_reflection_rgb565':int(np.count_nonzero(s2))}
 record.append(rec)
 if r['crank']%6==0:
    off.save(proof/f'{i:03}-off.png');root.save(proof/f'{i:03}-root.png');yes.save(proof/f'{i:03}-with-inner-spill.png')
 yes.save(out/f'{i:03}.png');frames.append(yes.convert('RGB'))
frames[0].save(P/'chair-swivel-fixed-foot-native.gif',save_all=True,append_images=frames[1:],loop=0,duration=100,disposal=2,optimize=False)
(P/'ignition-receipt.json').write_text(json.dumps(record,indent=2)+'\n')
assert all(max(x['core_rgb565'] for x in record if x['crank']//6==b)>=7 for b in (0,1))
assert any(x['inner_reflection_rgb565'] for x in record)
(P/'motion-proof.json').write_text(json.dumps({'frames':N,'fps':FPS,'resolution':[240,135],'yaw_degrees':[r['yaw'] for r in record]},indent=2)+'\n')
print('Peak core A/B',[(b,max(x['core_rgb565'] for x in record if x['crank']//6==b),max(x['inner_reflection_rgb565'] for x in record if x['crank']//6==b)) for b in (0,1)])
