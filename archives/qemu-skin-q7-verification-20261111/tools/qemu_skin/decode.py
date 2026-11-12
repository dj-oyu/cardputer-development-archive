from pathlib import Path
import argparse,re,json,hashlib
p=argparse.ArgumentParser();p.add_argument('log',type=Path);p.add_argument('output',type=Path);p.add_argument('--reference',type=Path);a=p.parse_args();a.output.mkdir(parents=True,exist_ok=True)
t=a.log.read_text();runs=[];rows={};hashes={}
for line in t.splitlines():
 m=re.search(r'QSCENE_FRAME index=(\d+).* hash=([0-9a-f]+)',line)
 if m:
  frame=int(m[1])
  if frame==0 and hashes:runs.append((rows,hashes));rows={};hashes={}
  hashes[frame]=m[2]
 m=re.search(r'QSCENE_ROW frame=(\d+) y=(\d+) data=([0-9a-f]+)',line)
 if m:
  frame,y=int(m[1]),int(m[2]);b=bytes.fromhex(m[3]);assert len(b)==480;assert y not in rows.setdefault(frame,{});rows[frame][y]=b
if hashes:runs.append((rows,hashes))
summary={'completed': 'QSKIN_DONE' in t or 'SKIN_JS_PASS' in t or 'SKIN_BATCH_PASS' in t,'runs':[]}
for r,(rows,hashes) in enumerate(runs):
 assert len(hashes)==120 and set(rows)=={0,30,60};out=a.output/str(r);out.mkdir(exist_ok=True);result={'run':r,'forward_frame_hashes':hashes,'captures':[]}
 for f,rr in sorted(rows.items()):
  assert set(rr)==set(range(135));raw=b''.join(rr[y] for y in range(135));name=f'frame-{f}.rgb565';(out/name).write_bytes(raw);rgb=bytearray()
  for i in range(0,len(raw),2):
   v=raw[i]|raw[i+1]<<8;red=v>>11;green=(v>>5)&63;blue=v&31;rgb.extend(((red<<3)|(red>>2),(green<<2)|(green>>4),(blue<<3)|(blue>>2)))
  (out/f'frame-{f}.ppm').write_bytes(b'P6\n240 135\n255\n'+rgb);e={'frame':f,'sha256':hashlib.sha256(raw).hexdigest()}
  if a.reference:
   ref=(a.reference/'0'/name).read_bytes();e['exact_host_bytes']=raw==ref;e['different_pixels']=sum(raw[i:i+2]!=ref[i:i+2] for i in range(0,len(raw),2));assert raw==ref
  result['captures'].append(e)
 if a.reference:
  ref=json.loads((a.reference/'captures.json').read_text())['runs'][0]['forward_frame_hashes'];result['all120_host_hash_match']=all(ref[str(f)]==h for f,h in hashes.items());assert result['all120_host_hash_match']
 summary['runs'].append(result)
(a.output/'captures.json').write_text(json.dumps(summary,indent=2)+'\n');print(json.dumps({k:v for k,v in summary.items() if k!='runs'}), 'runs',len(runs),'captures',3*len(runs),'all comparisons PASS')
