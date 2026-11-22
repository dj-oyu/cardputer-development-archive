"""Same strong lighting, contact AO on/off. 240x135 proof uses RGB565 quantization."""
from PIL import Image,ImageDraw,ImageFont
from pathlib import Path
import numpy as np,json
q=Path(__file__).resolve().parent
font='/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc'
f=lambda n:ImageFont.truetype(font,n,index=0)
panel=Image.new('RGB',(1332,720),'#1b262e');d=ImageDraw.Draw(panel)
d.text((18,10),'栗色一色、影は実際に重なるところだけ',font=f(25),fill='#f7eee0')
d.text((18,48),'同じ直射光・構図で、接触影（AO）だけを切替。面の色分けや描き込みはなし。',font=f(17),fill='#c9d4db')
vals={}
def flatten(i):
 base=Image.new('RGBA',i.size,(228,220,207,255));base.alpha_composite(i);return base.convert('RGB')
def rgb565(i):
 a=np.asarray(i,dtype='int32');lv=np.array([31,63,31]);o=(a*lv+127)//255
 return Image.fromarray(((o*255+lv//2)//lv).astype('uint8'))
xs=(18,309,600,891,1104)
for idx,(key,title,x) in enumerate(zip(('face-front','face-oblique','face-back','native-front','native-oblique'),('正面','斜め35°','後ろ','正面・RGB565','斜め・RGB565'),xs)):
 d.text((x,80),title,font=f(17),fill='#e7dfd2')
 ims=[flatten(Image.open(q/k/(key+'.png')).convert('RGBA')) for k in ('off','on')]
 if idx>=3:
  ims=[rgb565(i).crop((100,4,144,46)) for i in ims]
  a,b=[np.asarray(i,dtype=int) for i in ims]
  diff=np.abs(a-b).max(axis=2)
  vals[key]={'changing_pixels_head_crop':int((diff>0).sum()),'pixels_with_max_channel_delta_ge_16':int((diff>=16).sum()),'max_channel_delta':int(diff.max())}
  ims=[i.resize((198,189),Image.Resampling.NEAREST) for i in ims]
 else:
  ims=[i.resize((278,247),Image.Resampling.LANCZOS) for i in ims]
 for j,(im,y) in enumerate(zip(ims,(107,418))):
   panel.paste(im,(x,y));d.text((x+5,y+5),('AOなし','AOあり')[j],font=f(15),fill='#26313a')
d.text((18,682),'Blender上での見え方。実機でのAO描画・色・速度は未検証。',font=f(15),fill='#c5d0d9')
panel.save(q/'hair-contact-private-review.png')
(q/'rgb565-contact-proof.json').write_text(json.dumps(vals,indent=2)+'\n')
