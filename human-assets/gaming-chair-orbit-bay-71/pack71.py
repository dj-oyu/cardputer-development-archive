from pathlib import Path
from PIL import Image
import numpy as np,json
P=Path(__file__).resolve().parent;d=P/'bakes';atlas=P/'optics';atlas.mkdir(exist_ok=True)
engine_pos=json.loads((P/'pin-ortho.json').read_text());bank_table=[1,.96,.64,.41,.21,0]
st=P.parent/'chair-engine-v8-54'/'textures'
def stack(name,images):
 w,h=images[0].size;m=Image.new('RGBA',(w*len(images),h))
 for i,im in enumerate(images):m.paste(im,(w*i,0))
 m.save(atlas/f'{name}.png')
eng=[];ref=[]
X,Y=np.meshgrid(np.arange(256)+.5,np.arange(300)+.5)
for i in range(12):
 phase=i%6;b=i//6
 a=np.array(Image.open(d/f'engine-{phase}.png').convert('RGBA'),dtype=float)
 px,py=engine_pos[phase]['pins'][b]
 end=np.array(engine_pos[phase]['crank']);u=end-np.array((px,py));u=u/np.linalg.norm(u)*13
 tx=np.clip(((X-px)*u[0]+(Y-py)*u[1])/(u@u),0,1)
 sq=(X-px-tx*u[0])**2+(Y-py-tx*u[1])**2
 amp=bank_table[phase]
 k=np.maximum(0,1-np.sqrt(sq)/6.2)*(1-.72*tx)*amp*(a[:,:,3]>75)
 core=np.exp(-((X-px)**2+(Y-py)**2)/11)
 target=np.array([255,119,25])+core[:,:,None]*[0,131,186]
 a[:,:,:3]=a[:,:,:3]*(1-k[:,:,None])+target*k[:,:,None]
 eng.append(Image.fromarray(np.uint8(np.round(np.clip(a,0,255)))))
 # A weak field at the same engine-plane coordinates, applied only to the masked
 # radiator layer in Blender and behind engine/tube/tank as normal depth ordering.
 d2=(X-px)**2+(Y-py)**2
 l=np.exp(-d2/(2*10**2))*amp*(d2<26**2)
 m=np.zeros_like(a);m[:,:,:3]=255;m[:,:,3]=np.round(l*255)
 ref.append(Image.fromarray(np.uint8(m)))
stack('engine-phases-12',eng);stack('near-local-falloff-12',ref)
load=lambda n:Image.open(st/(n+'.png')).convert('RGBA')
stack('blue-bottle-6',[load(f'bottle{i}') for i in range(6)])
stack('neutral-tank-3',[load(i) for i in ('settled','left','right')])
Image.open(d/'pipe-0.png').save(atlas/'tube-static.png')
