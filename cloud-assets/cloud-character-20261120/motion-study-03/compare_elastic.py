from PIL import Image,ImageDraw,ImageFont
from pathlib import Path
import json,subprocess
p=Path(__file__).resolve().parent
s=json.loads((p/'elastic-validation.json').read_text());track=s['track'];rest=s['rest_width']
fbase='/usr/share/fonts/opentype/noto/NotoSansCJK-{}.ttc'
title=ImageFont.truetype(fbase.format('Bold'),24);note=ImageFont.truetype(fbase.format('Regular'),19);mini=ImageFont.truetype(fbase.format('Regular'),16)
bg='#253349';fg='#F0F6FF';sel='#B6DCFF'
def pair(i,sz):
 return [Image.open(p/d/f'frame-{i:03d}.png').convert('RGB').resize(sz,Image.Resampling.NEAREST) for d in ('prior-frames','frames')]
def tag(f):
 if f in range(25,36):return '全体が縮む'
 if f in range(36,41):return '解放'
 if f in range(41,51):return '反対側に行き過ぎる'
 if f in range(51,75):return '小さく戻りながら収まる'
 if f>=75:return '収まった姿勢'
 return '待機 → 波及が始まる'
board=Image.new('RGB',(1200,383),bg);d=ImageDraw.Draw(board)
d.text((12,8),'同じ画角｜局所だけの波から、全体が縮んで跳ね返る動きへ',font=title,fill=fg)
d.text((12,48),'02　局所が順に変形',font=note,fill=fg)
d.text((12,200),'03　全体の変形 ＋ 内側の時間差',font=note,fill=fg)
for c,i in enumerate((0,8,11,15,19)):
 x=4+240*c; a,b=pair(i,(232,130))
 board.paste(a,(x,69));board.paste(b,(x,223))
 fr=track[3*i];d.text((x+5,349),f'{i/8:.2f}s  幅 {fr["width"]:.0f}px',font=mini,fill=fg)
board.save(p/'elastic-ab-contact.png',optimize=True)
d0=p/'compare-frames';d0.mkdir(exist_ok=True)
for i in range(48):
 fr=track[3*i];a,b=pair(i,(480,270))
 canvas=Image.new('RGB',(976,364),bg);d=ImageDraw.Draw(canvas)
 d.text((10,9),'02　局所が順に変形',font=title,fill=fg);d.text((499,9),'03　全体の弾性 ＋ 内側の時間差',font=title,fill=fg)
 canvas.paste(a,(4,41));canvas.paste(b,(492,41))
 d.text((10,328),f'{i/8:04.2f}s　固定カメラ・照明',font=note,fill=fg)
 d.text((500,328),f'{tag(fr["frame"])}　幅 {fr["width"]:.0f}px',font=note,fill=sel)
 canvas.save(d0/f'{i:03d}.png')
subprocess.run(['ffmpeg','-y','-framerate','8','-i',str(d0/'%03d.png'),'-c:v','libx264','-crf','18','-pix_fmt','yuv420p','-movflags','+faststart',str(p/'elastic-ab.mp4')],check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
