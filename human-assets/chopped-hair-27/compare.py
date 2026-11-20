"""Generate one private matched comparison with exact close and 240×135 views."""
from pathlib import Path
from PIL import Image,ImageDraw,ImageFont
import numpy as np
q=Path(__file__).resolve().parent
font='/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc'
f=lambda n:ImageFont.truetype(font,n,index=0)
P=Image.new('RGB',(1268,768),'#202a30');d=ImageDraw.Draw(P)
d.text((20,12),'後ろ髪の丸い裾を、ざん切りの面に',font=f(26),fill='#f3eee8')
d.text((20,52),'大きな切り口をいくつか作り、前髪は山だけ少しシャープに。',font=f(17),fill='#c7d3d8')
def flatten(i):
 i=i.convert('RGBA');bg=Image.new('RGBA',i.size,(226,218,204,255));bg.alpha_composite(i);return bg.convert('RGB')
def rgb565(i):
 a=np.asarray(i,dtype='int32');l=np.array([31,63,31]);b=(a*l+127)//255
 return Image.fromarray(((b*255+l//2)//l).astype('uint8'))
for j,(k,label) in enumerate((('rear','真後ろ'),('rear35','後ろ斜め'),('profile-right','真横'),('high-left','斜め上'))):
 x=20+311*j;d.text((x,84),label,font=f(18),fill='#eadfd3')
 for r,(folder,tag) in enumerate((('before','前'),('final','後'))):
  y=110+310*r
  hi=flatten(Image.open(q/folder/('close-'+k+'.png'))).resize((297,264),Image.Resampling.LANCZOS)
  P.paste(hi,(x,y));d.text((x+8,y+5),tag,font=f(15),fill='#faf1db' if k=='high-left' else '#25313a')
  raw=rgb565(flatten(Image.open(q/folder/('native-'+k+'.png'))))
  raw=raw.crop((96,4,146,42)).resize((100,76),Image.Resampling.NEAREST)
  P.paste(raw,(x+194,y+184))
 d.text((x,737),'右下：240×135の頭部拡大（RGB565）',font=f(13),fill='#c2cdd4')
P.save(q/'hair-cut-private-review.png')
