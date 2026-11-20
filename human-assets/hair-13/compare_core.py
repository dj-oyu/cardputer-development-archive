"""Native RGB565 A/B: per-channel nearest rounding, no dithering."""
from PIL import Image,ImageDraw,ImageFont
from pathlib import Path
import numpy as np,json
root=Path(__file__).resolve().parent
font='/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc'
f=lambda n:ImageFont.truetype(font,n,index=0)
bg=(229,221,207,255)
panel=Image.new('RGB',(1330,720),'#1c242c');d=ImageDraw.Draw(panel)
d.text((18,10),'髪の芯影  明面 → 細い最暗部 → 反射光のある影面',font=f(25),fill='#f6eee1')
d.text((18,48),'同一の形状・光・色。右2列は240×135をRGB565に丸め、頭部のみ拡大。',font=f(17),fill='#c5d0d9')
views=('face-front','face-oblique','face-back','native-oblique','native-back')
xs=(18,309,600,891,1104)
proof={}
def flat(im):
 base=Image.new('RGBA',im.size,bg);base.alpha_composite(im);return base.convert('RGB')
def rgb565(im):
 a=np.asarray(im,dtype=np.int32);levels=np.array([31,63,31])
 q=(a*levels+127)//255
 return Image.fromarray(((q*255+levels//2)//levels).astype('uint8'))
for ix,(key,x) in enumerate(zip(views,xs)):
 d.text((x,79),('正面','斜め35°','後ろ','斜め・RGB565','後ろ・RGB565')[ix],font=f(17),fill='#eee5d8')
 ims=[flat(Image.open(root/k/(key+'.png')).convert('RGBA')) for k in ('control','core')]
 if key.startswith('native'):
   for j,i in enumerate(ims):
    rgb565(i).save(root/('control','core')[j]/(key+'-rgb565.png'))
   ims=[rgb565(i).crop((100,4,144,46)) for i in ims]
   a,b=[np.asarray(im).astype(int) for im in ims]
   diff=np.abs(a-b).max(axis=2)
   proof[key]={'crop':[100,4,144,46],'changed_RGB565_pixels':int((diff>0).sum()),'max_sRGB_channel_difference':int(diff.max())}
   ims=[i.resize((198,189),Image.Resampling.NEAREST) for i in ims]
 else:
   ims=[i.resize((278,247),Image.Resampling.LANCZOS) for i in ims]
 for j,(img,y) in enumerate(zip(ims,(107,418))):
  panel.paste(img,(x,y));d.text((x+5,y+5),('芯影なし','芯影あり')[j],font=f(15),fill='#26313a')
d.text((18,682),'比較用のBlenderレンダー。実機の色・速度は未検証。',font=f(15),fill='#c5d0d9')
panel.save(root/'hair-core-private-review.png')
(root/'rgb565-proof.json').write_text(json.dumps(proof,indent=2)+'\n')
