"""Generate synchronized before/after board and MP4 from paired 4 fps samples."""
from PIL import Image,ImageDraw,ImageFont
import json, pathlib, subprocess, sys
root=pathlib.Path(__file__).resolve().parent
new=root/'wave-frames';base=root.parent/'cloud-character-model'/'delivery'
archive=root.parent/'v1'/'cloud-motion-10s.gif'
source=Image.open(pathlib.Path(sys.argv[1]) if len(sys.argv)>1 else (archive if archive.is_file() else base/'cloud-motion-10s.gif'))
notes=json.load(open(root/'amorphous-validation.json'))
font='/usr/share/fonts/opentype/noto/NotoSansCJK-{}.ttc'
bold=ImageFont.truetype(font.format('Bold'),26)
small=ImageFont.truetype(font.format('Regular'),18)
small2=ImageFont.truetype(font.format('Regular'),15)
regions=['左上','左肩','左下','底の左','底の右','右下','右肩','右上','背面']
def photos(i,size):
 source.seek(i);left=source.convert('RGB').resize(size,Image.Resampling.NEAREST)
 right=Image.open(new/f'frame-{i:03d}.png').convert('RGB').resize(size,Image.Resampling.NEAREST)
 return left,right
indices=[0,3,7,11,15]
board=Image.new('RGB',(1200,404),'#253349');bd=ImageDraw.Draw(board)
bd.text((18,14),'同じカメラ・照明｜重心で演技する旧版 → 膨張と収縮が伝わる新版',font=bold,fill='#F0F5FE')
bd.text((18,56),'旧版　傾き・伸縮',font=small,fill='#F0F5FE')
bd.text((18,211),'新版　局所の膨張・収縮',font=small,fill='#F0F5FE')
for col,i in enumerate(indices):
 a,b=photos(i,(232,130));x=4+col*240
 board.paste(a,(x,80));board.paste(b,(x,231))
 w=notes['phase_weights_stride_6'][i];high=regions[max(range(9),key=w.__getitem__)];low=regions[min(range(9),key=w.__getitem__)]
 bd.text((x+8,367),f'{i/4:.2f}s　膨張：{high}　収縮：{low}',font=small2,fill='#F4FAFF')
board.save(root/'cloud-motion-ab-contact.png',optimize=True)
dst=root/'ab-video-frames';dst.mkdir(exist_ok=True)
for i in range(40):
 a,b=photos(i,(480,270));canvas=Image.new('RGB',(976,358),'#253349');d=ImageDraw.Draw(canvas)
 d.text((14,10),'前：全身の傾き・伸縮',font=bold,fill='#F0F5FE')
 d.text((502,10),'後：局所の膨張・収縮が波及',font=bold,fill='#F0F5FE')
 canvas.paste(a,(4,44));canvas.paste(b,(492,44))
 w=notes['phase_weights_stride_6'][i];high=regions[max(range(9),key=w.__getitem__)];low=regions[min(range(9),key=w.__getitem__)]
 d.text((14,323),f'同期 {i/4:05.2f}s',font=small,fill='#F0F5FE')
 d.text((502,323),f'膨張中心：{high}　　収縮中心：{low}',font=small,fill='#F0F5FE')
 canvas.save(dst/f'{i:03d}.png')
subprocess.run(['ffmpeg','-y','-framerate','4','-i',str(dst/'%03d.png'),'-c:v','libx264','-crf','17','-pix_fmt','yuv420p','-movflags','+faststart',str(root/'cloud-motion-ab.mp4')],check=True,stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL)
