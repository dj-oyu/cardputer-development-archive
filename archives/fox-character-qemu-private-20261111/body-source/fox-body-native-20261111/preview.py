from pathlib import Path
from PIL import Image,ImageDraw
import struct,json
D=Path(__file__).resolve().parent
sheet=Image.new('RGB',(720,450),'#ececec');draw=ImageDraw.Draw(sheet)
for v in range(2):
 for j,p in enumerate([0,31,63]):
  data=(D/'O2'/f'frame-v{v}-p{p:02d}-dq.rgb565').read_bytes();im=Image.new('RGB',(240,135));im.putdata([(((x>>11)&31)*255//31,((x>>5)&63)*255//63,(x&31)*255//31) for (x,) in struct.iter_unpack('<H',data)])
  im.save(D/f'body-v{v}-p{p:02d}.png');sheet.paste(im.resize((240,135)),(j*240,v*185+35));draw.text((j*240+8,v*185+15),f'Native body only | view {v} | pose {p}',fill='black')
draw.text((10,405),'2k-v2 body: 454 triangles. Diagnostic diffuse, not full fox / PBR.',fill='black');draw.text((10,425),'Actual native RGB565 output. Images shown 1:1.',fill='black');sheet.save(D/'body-native-contact.png')
