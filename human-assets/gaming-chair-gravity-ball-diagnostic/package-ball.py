from pathlib import Path
from PIL import Image,ImageDraw,ImageFont
import hashlib,math,json
D=Path(__file__).resolve().parent
q=json.loads((D/'ball-gravity-proof.json').read_text())
fontfile='/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc'
f=ImageFont.truetype(fontfile,19);small=ImageFont.truetype(fontfile,14);tt=ImageFont.truetype(fontfile,21)
s=q['time_s'];sec_ms=s*1e3
def dashed(d,a,b,color):
 vx,vy=b[0]-a[0],b[1]-a[1];length=math.hypot(vx,vy)
 for i in range(0,int(length),11):
  t0=i/length;t1=min(1,(i+5)/length)
  d.line((a[0]+vx*t0,a[1]+vy*t0,a[0]+vx*t1,a[1]+vy*t1),fill=color,width=2)
def tag(tag,num,caption=None,guide=False):
 p=D/'native'/tag/f'{num:03}.png';im=Image.open(p).convert('RGB')
 d=ImageDraw.Draw(im)
 if guide:
  pts=json.loads((D/f'projection-{tag}.json').read_text())
  a,b=pts['ball_origin_bottom'],pts['real_marker']
  dashed(d,a,b,'#f5ce7d')
  d.ellipse((b[0]-3,b[1]-3,b[0]+3,b[1]+3),fill='#f5ce7d',outline='#24272a',width=1)
 if caption:
  d.rounded_rectangle((10,10,151,57),radius=7,fill='#171f25')
  d.text((19,13),caption[0],font=f,fill='#ffffff')
  d.text((19,36),caption[1],font=small,fill='#edd09b')
 return im
def quantize(fs):
 board=Image.new('RGB',(480*2,270*2))
 for i,im in enumerate((fs[0],fs[len(fs)//3],fs[len(fs)//2],fs[-1])):board.paste(im,((i%2)*480,(i//2)*270))
 pal=board.quantize(colors=254,method=Image.Quantize.MEDIANCUT)
 return [im.quantize(palette=pal,dither=Image.Dither.NONE) for im in fs]
def save(path,frames,ds):
 if path.name.endswith('.gif'):
  fs=quantize(frames)
  fs[0].save(path,save_all=True,append_images=fs[1:],duration=ds,loop=0,disposal=1,optimize=False)
 else: frames[0].save(path,save_all=True,append_images=frames[1:],duration=ds,loop=0,disposal=0,blend=0)
 with Image.open(path) as g:
  assert g.size==(480,270)
  t=0
  for i in range(g.n_frames):
   g.seek(i);t+=g.info['duration']
  assert abs(t-sum(ds))<1
def get(i,label):
 return tag('close',i,(label,f'{sec_ms*i/24:05.1f} ms'))
def run_previews():
 # APNG durations 1 ms quantized. GIF using 20 ms or more to avoid common decoder minimum.
 for mode,n,interval,label in [('real',9,1,'実時間 ×1'),('slow6',21,6,'6倍スロー')]:
  for ext in ('apng.png','gif'):
   unit=1 if ext!='gif' else 10
   nn=n if ext!='gif' or interval==6 else 4
   ik=[round(24*i/nn) for i in range(nn+1)]
   fsrc=get(0,label)
   ids=[0]+ik[:-1]+[24]
   ds=[300]+[unit*(round(sec_ms*interval*(i+1)/nn/unit)-round(sec_ms*interval*i/nn/unit)) for i in range(nn)]+[550]
   if ext=='gif' and interval==1:
    ds=[300]+[20]*4+[550]
   ims=[fsrc]+[get(i,label) for i in ids[1:]]
   save(D/f'gravity-ball-{mode}.{ext}',ims,ds)
def poster():
 im=Image.new('RGB',(960,336),'#161d22');d=ImageDraw.Draw(im)
 d.text((12,6),'お尻の高さで手を離す前の位置を再現',font=tt,fill='#f7fbff')
 d.text((497,6),'球が、椅子と同じ高さの受け台に接触',font=tt,fill='#f7fbff')
 im.paste(tag('full',0,guide=True),(0,36)); im.paste(tag('close',24),(480,36))
 d.text((16,307),f'落下距離 {q["fall_height_m"]*100:.2f} cm ｜ 静止から約 {sec_ms:.1f} ms ｜ 9.80665 m/s²  ｜ 身長1.60 mに換算 ｜ 人物は静止',font=small,fill='#c9dae9')
 im.save(D/'gravity-ball-contact-proof.png')
run_previews();poster()
out={}
for p in list(D.glob('gravity-ball-*.gif'))+list(D.glob('gravity-ball-*.apng.png'))+list(D.glob('gravity-ball-contact-proof.png')):
 out[p.name]=hashlib.sha256(p.read_bytes()).hexdigest()
(D/'ball-preview-proof.json').write_text(json.dumps({'visual_files_sha256':out,'approximated_real_gif_motion_ms':80,
'physically_calculated_time_ms':sec_ms,'APNG_actual_motion_ms':round(sec_ms),'scaled_slow_motion_ms':sec_ms*6},indent=2))
