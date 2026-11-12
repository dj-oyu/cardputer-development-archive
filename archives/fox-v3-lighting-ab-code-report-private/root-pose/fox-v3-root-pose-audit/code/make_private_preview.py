"""Display-only exact RGB565 decode to PNG8, nearest 3x. Never a scoring input."""
from pathlib import Path
import numpy as np
from PIL import Image,ImageDraw
R=Path(__file__).resolve().parents[1];D=R/'run-001/private';O=R/'private-preview';assert not O.exists();O.mkdir()
for view in ['front','oblique']:
 panels=[]
 for pose,label in [('identity','Identity'),('yaw-plus','Source +Z yaw +15 deg'),('yaw-minus','Source +Z yaw -15 deg')]:
  p=D/f'{view}-forward.{pose}.u16le';v=np.fromfile(p,'<u2').reshape(135,240);rgb=np.stack([(v>>11)*255/31,((v>>5)&63)*255/63,(v&31)*255/31],axis=-1);im=Image.fromarray(np.rint(rgb).astype(np.uint8),'RGB');im.save(O/f'{view}-{pose}.png');im=im.resize((720,405),Image.Resampling.NEAREST);panel=Image.new('RGB',(720,435),(24,24,24));panel.paste(im,(0,30));ImageDraw.Draw(panel).text((12,9),label,fill=(240,240,240));panels.append(panel)
 canvas=Image.new('RGB',(2160,435));
 for i,im in enumerate(panels):canvas.paste(im,(720*i,0))
 canvas.save(O/f'{view}-three-poses-nearest3x.png')
print(O)
