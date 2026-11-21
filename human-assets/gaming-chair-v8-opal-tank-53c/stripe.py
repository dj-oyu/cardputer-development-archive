"""Reassign the old silver case as an opal sight window, preserving silhouette and fittings."""
from pathlib import Path
from PIL import Image
import numpy as n
P=Path(__file__).resolve().parent/'textures'
im=n.array(Image.open(P/'legacy-case.png').convert('RGBA'))
h,w,_=im.shape
y,x=n.mgrid[:h,:w]+.5
wa=n.clip(n.minimum(n.minimum(x-73,205-x),n.minimum(y-155,194-y)),0,2)/2
fallback=n.minimum(1,n.maximum(0,(x-73)/8))*n.minimum(1,n.maximum(0,(205-x)/8))
wa*=fallback
for name,slope in (('settled',0),('left',.245),('right',-.245)):
 center=174+slope*(x-139)
 rgb=im[:,:,:3].copy().astype(float)
 # Opal/polymer catches broad pale bounce above an internal dark fluid body.
 # One edge, fixed case shell and hardware. Turquoise is a hint, not glowing glass.
 da=n.clip((y-center+.45)*.8,0,1)
 haze=n.clip(1-((y-172)/21)**2,0,1)
 wet=n.stack([77+10*haze,111+15*haze,109+15*haze],axis=-1)
 head=n.stack([195+12*haze,198+12*haze,185+13*haze],axis=-1)
 color=head*(1-da[:,:,None])+wet*da[:,:,None]
 thin=n.clip(1-n.abs(y-center)/1.70,0,1)*.58
 color=color*(1-thin[:,:,None])+n.array([37,72,69])*thin[:,:,None]
 color=color*.90+rgb*.10
 rgb=rgb*(1-wa[:,:,None])+color*wa[:,:,None]
 out=im.copy();out[:,:,:3]=n.uint8(n.clip(rgb,0,255))
 Image.fromarray(out).save(P/f'{name}.png')
 # QA fixture: identical case-wide mapping but white liquid fill in the stripe only.
 mask=im.copy(); mask[:,:,:3]=255; mask[:,:,3]=n.uint8(wa*da*(im[:,:,3]))
 Image.fromarray(mask).save(P/f'matte-{name}.png')
reservoir=n.array(Image.open(P/'original-reservoir.png').convert('RGBA'))
rgb=reservoir[:,:,:3].astype(float)
cy=n.clip((y-271)*.44,0,1)*n.clip((311-y)*.35,0,1)*n.clip((x-20)/6,0,1)*n.clip((66-x)/6,0,1)
cy*=.75
tint=n.stack([38+.16*rgb[:,:,0],96+.20*rgb[:,:,1],134+.20*rgb[:,:,2]],axis=-1)
rgb=rgb*(1-cy[:,:,None])+tint*cy[:,:,None]
spot=n.clip(1-n.sqrt(((x-40)/6)**2+((y-278)/7)**2),0,1)*.72
rgb=rgb*(1-spot[:,:,None])+n.array([168,227,244])*spot[:,:,None]
reservoir[:,:,:3]=n.uint8(n.clip(rgb,0,255))
Image.fromarray(reservoir).save(P/'bottle.png')
