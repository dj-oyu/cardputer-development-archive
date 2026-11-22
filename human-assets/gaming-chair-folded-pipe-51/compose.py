"""Create view-specific host layers from real pipe geometry clipped through the real chair aperture."""
import numpy as np
from PIL import Image, ImageChops
from pathlib import Path
from shutil import copyfile
P=Path(__file__).resolve().parent
old=P.parent/'chair-nine-50'/'assets'
for d in sorted((P/'assets').glob('rear_*')):
 src=old/d.name
 if not src.exists():continue
 for key in ['base']+[f'layer_{k:02}' for k in [1,2,3,4,5,7,9]]:
    copyfile(src/f'{key}.png',d/f'{key}.png')
 pipe=Image.open(d/'tube.png').convert('RGBA')
 mask=Image.open(d/'mask.png').convert('RGBA').getchannel('A')
 pipe.putalpha(ImageChops.multiply(mask,pipe.getchannel('A')))
 Image.new('RGBA',pipe.size).save(d/'layer_06.png')
 pipe.save(d/'layer_08.png')
 full=Image.open(d/'base.png').convert('RGBA')
 for k in range(1,10):
    full=Image.alpha_composite(full,Image.open(d/f'layer_{k:02}.png').convert('RGBA'))
 full.save(d/'full.png')
 print(d.name, 'pipe masked pixels',sum(np.asarray(pipe.getchannel('A')).ravel()>0), 'full image is RGBA composite, not a monolithic Blender render')

for d in sorted((P/'detail').glob('rear_*')):
    path=P/'assets'/d.name
    tube=Image.open(path/'tube-720.png').convert('RGBA')
    mask=Image.open(d/'mask.png').convert('RGBA').getchannel('A')
    tube.putalpha(ImageChops.multiply(mask,tube.getchannel('A')))
    full=Image.open(d/'base.png').convert('RGBA')
    for k in (1,2,3,4,5,7):full=Image.alpha_composite(full,Image.open(d/f'layer_{k:02}.png').convert('RGBA'))
    full=Image.alpha_composite(full,tube)
    full=Image.alpha_composite(full,Image.open(d/'layer_09.png').convert('RGBA'))
    full.save(d/'full.png')
