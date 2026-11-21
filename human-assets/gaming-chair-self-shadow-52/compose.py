"""Same scene and masks as v51, upgraded sampled intensity. No runtime allocation increase."""
from pathlib import Path
from PIL import Image, ImageChops
import numpy as np
from shutil import copyfile
P=Path(__file__).resolve().parent
old=P.parent/'chair-pipe-51'/'assets'
for size in ('assets','detail'):
 for d in sorted((P/size).glob('rear_*')):
    if not (d/"layer_09.png").exists() or not (d/"mask.png").exists(): continue
    pipe=Image.open(d/'tube.png').convert('RGBA')
    a=ImageChops.multiply(Image.open(d/'mask.png').convert('RGBA').getchannel('A'),pipe.getchannel('A'))
    if size=='assets':
     for tile in ['base','mask']+[f'layer_{i:02}' for i in (1,2,3,4,5,7,9)]:
      copyfile(old/d.name/f'{tile}.png',d/f'{tile}.png')
     # Preserve the approved native alpha footprint exactly; the color bakes are new.
     before=np.asarray(Image.open(old/d.name/'layer_08.png').convert('RGBA'))
     p=np.array(pipe);new=np.asarray(a)
     edge=(before[:,:,3]>0)&(new==0)
     p[edge,:3]=before[edge,:3]
     p[:,:,3]=before[:,:,3];pipe=Image.fromarray(p)
    else:pipe.putalpha(a)
    Image.new('RGBA',pipe.size).save(d/'layer_06.png')
    pipe.save(d/'layer_08.png')
    full=Image.open(d/'base.png').convert('RGBA')
    for k in range(1,10):
       full=Image.alpha_composite(full,Image.open(d/f'layer_{k:02}.png').convert('RGBA'))
    full.save(d/'full.png')
    print(d.name,size,'new tube area',int(np.count_nonzero(np.array(pipe)[:,:,3])))
