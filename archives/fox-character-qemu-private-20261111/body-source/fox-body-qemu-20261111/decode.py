"""Decode complete target row captures and compare actual RGB565 bytes with host."""
from pathlib import Path
import argparse,collections,hashlib,json,re
import numpy as np
from PIL import Image,ImageDraw
p=argparse.ArgumentParser();p.add_argument('uart',type=Path);p.add_argument('host',type=Path);p.add_argument('output',type=Path);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=False)
text=a.uart.read_text();assert 'FOX_BODY_QEMU_DONE' in text
rows=collections.defaultdict(dict)
for m in re.finditer(r'FOX_BODY_ROW lifecycle=(\d+) pose=(\d+) view=(\d+) y=(\d+) ([a-f0-9]+)',text):
 life,pose,view,y=map(int,m.group(1,2,3,4));key=(life,pose,view);assert y not in rows[key];b=bytes.fromhex(m[5]);assert len(b)==480;rows[key][y]=b
results=[];imgs=[]
for (life,pose,view),r in sorted(rows.items()):
 assert set(r)==set(range(135));data=b''.join(r[y] for y in range(135));host=a.host/f'frame-v{view}-p{pose:02d}-dq.rgb565';expected=host.read_bytes();assert len(data)==len(expected)==64800
 pix=np.frombuffer(data,dtype='<u2').reshape(135,240);ref=np.frombuffer(expected,dtype='<u2');diff=int(np.count_nonzero(pix.ravel()!=ref));rgb=np.stack([((pix>>11)*255//31),(((pix>>5)&63)*255//63),((pix&31)*255//31)],axis=-1).astype('uint8');im=Image.fromarray(rgb);name=f'body-target-v{view}-p{pose:02d}';im.save(a.output/(name+'.png'));(a.output/(name+'.rgb565')).write_bytes(data);imgs.append((f'view {view} / pose {pose} / host diff {diff}',im));results.append({'lifecycle':life,'pose':pose,'view':view,'differing_pixels':diff,'sha256':hashlib.sha256(data).hexdigest()})
hosthash={}
for m in re.finditer(r'BODY_FRAME pose=(\d+) view=(\d+) oracle=0 hash=([0-9a-f]+)',(a.host/'run.log').read_text()):
 key=(int(m[1]),int(m[2]));h=m[3];assert key not in hosthash or hosthash[key]==h;hosthash[key]=h
frames=[]
for m in re.finditer(r'FOX_BODY_FRAME lifecycle=(\d+) visit=(\d+) pose=(\d+) view=(\d+) hash=([0-9a-f]+)',text):
 life,visit,pose,view=map(int,m.group(1,2,3,4));frames.append({'lifecycle':life,'visit':visit,'pose':pose,'view':view,'hash':m[5],'host_equal':hosthash[(pose,view)]==m[5]})
assert len(frames)==24 and len(results)==6
meta={'scope':'2k-v2 body only; native C DQ + normal recomputation + AYNM geometry override + production mesh raster; not full character, QuickJS, Kasane compositor, original BSDF or physical display','captures':results,'frames':frames,'all_hashes_equal':all(x['host_equal'] for x in frames),'heap_lines':[x for x in text.splitlines() if x.startswith('FOX_BODY_HEAP')],'memory_lines':[x for x in text.splitlines() if x.startswith('BODY_MEMORY')]}
(a.output/'results.json').write_text(json.dumps(meta,indent=2)+'\n')
canvas=Image.new('RGB',(1440,650),'#121925');d=ImageDraw.Draw(canvas);d.text((12,10),'Actual ESP32-S3 QEMU body-only native renders | 454 triangles | diagnostic diffuse materials',fill='white')
for k,(label,im) in enumerate(imgs):
 x=(k//2)*480;y=40+(k%2)*300;d.text((x+12,y),label,fill='white');canvas.paste(im.resize((480,270),Image.Resampling.NEAREST),(x,y+25))
d.text((12,635),'No head attachments or facial features. Not full character, original BSDF, physical display or FPS evidence.',fill='white')
canvas.save(a.output/'fox-body-qemu-contact.png');print(json.dumps({'captures':results,'frame_count':len(frames),'all_hashes_equal':meta['all_hashes_equal']},indent=2))
assert meta['all_hashes_equal'] and all(x['differing_pixels']==0 for x in results)
