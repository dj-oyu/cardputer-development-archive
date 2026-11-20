from pathlib import Path
from PIL import Image,ImageDraw,ImageFont
import json,subprocess,sys,math
p=Path(__file__).resolve().parent
q=p.parent/'cloud-character-study-03'/'frames'
old=Path(sys.argv[1]) if len(sys.argv)>1 else q
s=json.loads((p/'variable-center-validation.json').read_text()); rows=s['timeline'];ev=s['events']
fbase='/usr/share/fonts/opentype/noto/NotoSansCJK-{}.ttc'
title=ImageFont.truetype(fbase.format('Bold'),23);note=ImageFont.truetype(fbase.format('Regular'),17); mini=ImageFont.truetype(fbase.format('Regular'),15)
bg='#253349';fg='#F0F6FF';sel='#B6DCFF'
def image(d,i,sz):
 return Image.open(d/f'frame-{i:03d}.png').convert('RGB').resize(sz,Image.Resampling.NEAREST)
def text(d,x,y,label,f=title,c=fg):d.text((x,y),label,font=f,fill=c,anchor='lt')
def near(r):
 return min(95,max(0,round((r['frame']-1)/3)))
letters=['左上を支点に','右下を支点に','左下を支点に']
board=Image.new('RGB',(972,490),bg);d=ImageDraw.Draw(board)
text(d,14,10,'3回の収縮・反発｜支点とタイミングをずらした12秒の試作')
for c,(label,e) in enumerate(zip(letters,ev)):
 x=c*324+6;text(d,x+5,47,label,note)
 for k,field in enumerate(('pressure_pose','rebound_pose')):
  r=e[field];idx=near(r);r=rows[3*idx]
  y=75+k*205
  board.paste(image(p/'frames',idx,(312,175)),(x,y))
  text(d,x+5,y+177,f'{r["seconds"]:.2f}s　{"収縮" if k==0 else "反発"}・幅 {r["body_width_px"]:.0f}px',mini,'#FFFFFF')
board.save(p/'variable-center-contact.png',optimize=True)
temp=p/'comparison-frames';temp.mkdir(exist_ok=True)
for i in range(96):
 r=rows[3*i]
 canvas=Image.new('RGB',(976,363),bg);d=ImageDraw.Draw(canvas)
 text(d,10,10,'03　中心がそろった6秒 × 2回');text(d,499,10,'04　3回の起点・向き・間を変える')
 canvas.paste(image(old,i%48,(480,270)),(4,39));canvas.paste(image(p/'frames',i,(480,270)),(492,39))
 text(d,11,323,f'{r["seconds"]:05.2f}s　同じ画角・照明',note)
 biggest=max(range(3),key=lambda n:abs(r['springs'][n]))
 active=r['springs'][biggest]
 caption='漂い・間' if abs(active)<.05 else letters[biggest]+('縮む' if active>0 else '反発')
 text(d,502,323,f'{caption}　幅 {r["body_width_px"]:.0f}px',note,sel)
 canvas.save(temp/f'{i:03d}.png')
subprocess.run(['ffmpeg','-y','-framerate','8','-i',str(temp/'%03d.png'),'-c:v','libx264','-crf','18','-pix_fmt','yuv420p','-movflags','+faststart',str(p/'variable-center-ab.mp4')],check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
