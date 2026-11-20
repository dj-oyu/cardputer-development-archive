"""Extract the three linked poses and generate a 12 fps proof."""
from PIL import Image,ImageDraw,ImageFont
from pathlib import Path
import subprocess
p=Path(__file__).resolve().parent
f='/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc'
font=ImageFont.truetype(f,16)
header=ImageFont.truetype(f,27)
im=Image.new('RGB',(984,390),'#243144')
d=ImageDraw.Draw(im)
d.text((10,12),'雲キャラクター   3回つながる弾み',font=header,fill='#f6f5ef')
pairs=[(0,'待機'),(4,'1回目・圧縮'),(7,'1回目・反発 → 次へ'),(10,'2回目・圧縮'),(13,'2回目・反発 → 次へ'),(18,'3回目・圧縮'),(22,'3回目・反発'),(34,'余韻の後に静止')]
for i,(index,label) in enumerate(pairs):
 x=6+245*(i%4);y=54+167*(i//4)
 shot=Image.open(p/'frames'/f'frame-{index:03}.png').convert('RGB')
 im.paste(shot,(x,y));d.text((x+3,y+138),f'{index/12:.2f}s  {label}',font=font,fill='#f6f5ef')
im.save(p/'pop-chain-contact.png',optimize=True)
subprocess.run(['ffmpeg','-v','error','-y','-framerate','12','-i',str(p/'frames/frame-%03d.png'),'-vf','scale=480:270:flags=neighbor','-c:v','libx264','-pix_fmt','yuv420p','-crf','19','-movflags','+faststart',str(p/'cloud-pop-chain.mp4')],check=True)
