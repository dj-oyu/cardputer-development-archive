"""Decode tagged UART RGB565LE captures; optional exact host/target comparison."""
from pathlib import Path
import argparse,re,json,hashlib
p=argparse.ArgumentParser();p.add_argument('log',type=Path);p.add_argument('output',type=Path);p.add_argument('--reference',type=Path);a=p.parse_args()
a.output.mkdir(parents=True,exist_ok=True);rows={}
text=a.log.read_text(errors='replace')
for m in re.finditer(r'QSCENE_ROW frame=(\d+) y=(\d+) data=([0-9a-f]+)',text):
 frame,y=int(m[1]),int(m[2]);b=bytes.fromhex(m[3]);assert len(b)==480
 assert y not in rows.setdefault(frame,{}),'duplicate capture row'
 rows[frame][y]=b
summary={'complete':'Q7_DONE' in text,'frames':[]}
for frame,rr in sorted(rows.items()):
 assert set(rr)==set(range(135)),'incomplete frame'
 raw=b''.join(rr[y] for y in range(135));name=f'frame-{frame}.rgb565';(a.output/name).write_bytes(raw)
 rgb=bytearray()
 for i in range(0,len(raw),2):
  v=raw[i]|raw[i+1]<<8;r=(v>>11)&31;g=(v>>5)&63;b=v&31;rgb.extend(((r<<3)|(r>>2),(g<<2)|(g>>4),(b<<3)|(b>>2)))
 (a.output/f'frame-{frame}.ppm').write_bytes(b'P6\n240 135\n255\n'+rgb)
 entry={'frame':frame,'sha256':hashlib.sha256(raw).hexdigest()}
 if a.reference:
  ref=(a.reference/name).read_bytes();entry['exact_reference_match']=raw==ref;entry['different_pixels']=sum(raw[i:i+2]!=ref[i:i+2] for i in range(0,len(raw),2))
 summary['frames'].append(entry)
(a.output/'captures.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps(summary,indent=2))
assert set(rows)=={0,2,4,100,102,104},'expected three candidate and three float captures'
