from PIL import Image,ImageDraw,ImageFont
from pathlib import Path
import json,sys,subprocess
p=Path(__file__).resolve().parent
c=[p.parent/'idle-wind-01',p.parent/'cloud-character-idle-drift-01']
old=Path(sys.argv[1]) if len(sys.argv)>1 else next(q for q in c if (q/'frames').is_dir())
fbase='/usr/share/fonts/opentype/noto/NotoSansCJK-{}.ttc'
h=ImageFont.truetype(fbase.format('Bold'),26);f=ImageFont.truetype(fbase.format('Regular'),17);f2=ImageFont.truetype(fbase.format('Regular'),15)
bg='#233149';fg='#F4F8FF';small='#C9D9EF'
def shot(folder,k,scale=1):
 return Image.open(folder/'frames'/f'frame-{k:03d}.png').convert('RGB').resize((240*scale,135*scale),Image.Resampling.NEAREST)
def readmask(file):
 return Image.open(file).convert('L')
def bounds(im):
 pix=im.load()
 return {y:(min(xs),max(xs)) for y in range(im.height) if (xs:=[x for x in range(im.width) if pix[x,y]])}
n=readmask(p/'mask-001.pgm'); q=readmask(old/'mask-001.pgm');dN=bounds(n);dO=bounds(q)
result={}
for fr in (57,93,123,153,184,211):
 def maxshift(new,base):
  live=bounds(new);d=[abs(a-b) for y in live.keys()&base.keys() if live[y][1]-live[y][0]>28 and base[y][1]-base[y][0]>28 for a,b in zip(live[y],base[y])]
  return dict(samples=len(d), max_px=max(d),p90_px=sorted(d)[int(.9*len(d))])
 def mask(dir):return readmask(dir/f'mask-{fr:03d}.pgm')
 result[str(fr)]={'previous':maxshift(mask(old),dO),'new':maxshift(mask(p),dN)}
(p/'idle-wind-02-edge-comparison.json').write_text(json.dumps(result,indent=1))
samples=[(19,57,'左がほどけ、右下へ'),(31,93,'左から右下への受け渡し'),(51,153,'右肩がほどけ、裾へ'),(61,184,'裾がほどけ、左肩へ')]
board=Image.new('RGB',(1000,494),bg);d=ImageDraw.Draw(board)
d.text((12,5),'雲の待機 02｜実寸の輪郭変化を強める',font=h,fill=fg)
d.text((12,43),'固定カメラ・照明・時刻、各240×135px。輪郭差分は下段。',font=f,fill=small)
d.text((12,72),'01　前案',font=f,fill=fg)
d.text((12,229),'02　輪郭変化を強めた案',font=f,fill=fg)
for i,(si,m,label) in enumerate(samples):
 x=8+248*i
 board.paste(shot(old,si),(x,95));board.paste(shot(p,si),(x,252))
 v=readmask(p/f'mask-{m:03}.pgm')
 mask=Image.new('RGB',n.size);mask.putdata([((167,188,210) if b and c else (111,223,208) if c else (247,138,180) if b else (43,61,88)) for b,c in zip(n.getdata(),v.getdata())])
 # Compact 240×70 panel: crop only central region of tall body so widest affected edges remain visible.
 board.paste(mask.crop((0,47,240,117)),(x,392))
 d.text((x,469),f'{si/8:.2f}s　{label}',font=f2,fill=fg)
board.save(p/'idle-wind-02-comparison.png',optimize=True)
tmp=p/'comparison-frames';tmp.mkdir(exist_ok=True)
for i in range(80):
 im=Image.new('RGB',(976,352),bg);dd=ImageDraw.Draw(im)
 dd.text((10,9),'01　以前の静かな待機',font=h,fill=fg);dd.text((501,9),'02　形の受け渡しを強める',font=h,fill=fg)
 im.paste(shot(old,i,2),(4,41));im.paste(shot(p,i,2),(492,41))
 dd.text((11,321),f'{i/8:05.2f}s　同じカメラ・照明・時刻',font=f,fill=small)
 dd.text((502,321),'顔と画角は維持・胴を膨らませず輪郭を変形',font=f,fill=small)
 im.save(tmp/f'{i:03d}.png')
subprocess.run(['ffmpeg','-y','-framerate','8','-i',str(tmp/'%03d.png'),'-c:v','libx264','-threads','3','-crf','17','-pix_fmt','yuv420p','-movflags','+faststart',str(p/'idle-wind-02-ab.mp4')],check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
