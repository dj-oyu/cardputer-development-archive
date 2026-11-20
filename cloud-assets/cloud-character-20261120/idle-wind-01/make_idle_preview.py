from PIL import Image,ImageDraw,ImageFont
from pathlib import Path
import json,subprocess
p=Path(__file__).resolve().parent
a=json.loads((p/'idle-drift-validation.json').read_text())
fbase='/usr/share/fonts/opentype/noto/NotoSansCJK-{}.ttc'
heavy=ImageFont.truetype(fbase.format('Bold'),25);normal=ImageFont.truetype(fbase.format('Regular'),17);mini=ImageFont.truetype(fbase.format('Regular'),14)
bg='#233149'; light='#F4F8FF'
labels=[(1,'起点'),(93,'左がほどけ、右下に寄る'),(153,'右の肩がほどけ、裾に寄る'),(184,'下がほどけ、左の肩に寄る')]
canvas=Image.new('RGB',(1040,438),bg);d=ImageDraw.Draw(canvas)
d.text((12,11),'雲の待機｜膨らまず、輪郭の形をゆっくり受け渡す',font=heavy,fill=light)
d.text((13,44),'下段の差分：水色＝起点より外へ、桃色＝内へ。背景・光を除いた240×135の胴の輪郭。',font=normal,fill='#CFE0FA')
ref=Image.open(p/'mask-001.pgm').convert('L')
for i,(f,label) in enumerate(labels):
 x=i*260+6;t=(f-1)/24;fidx=round((f-1)/3)
 current=Image.open(p/f'mask-{f:03d}.pgm').convert('L')
 pic=Image.open(p/f'frames/frame-{fidx:03d}.png').convert('RGB').resize((246,138),Image.Resampling.NEAREST)
 d.text((x,76),f'{t:.2f}s　{label}',font=mini,fill=light)
 canvas.paste(pic,(x,102))
 pix=Image.new('RGB',ref.size)
 pix.putdata([((174,188,206) if b and c else (119,221,217) if c else (240,152,187) if b else (43,61,88)) for b,c in zip(ref.getdata(),current.getdata())])
 canvas.paste(pix.resize((246,138),Image.Resampling.NEAREST),(x,250))
 z=a['masks'][str(f)]
 d.text((x,399),f'面積 {z["pixel_area"]:,}px・差分 {z["changed_vs_start"]}px',font=mini,fill=light)
canvas.save(p/'idle-drift-contour.png',optimize=True)
subprocess.run(['ffmpeg','-y','-framerate','8','-i',str(p/'frames/frame-%03d.png'),'-vf','scale=480:270:flags=neighbor','-c:v','libx264','-threads','3','-crf','17','-pix_fmt','yuv420p','-movflags','+faststart',str(p/'idle-drift-preview.mp4')],check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
