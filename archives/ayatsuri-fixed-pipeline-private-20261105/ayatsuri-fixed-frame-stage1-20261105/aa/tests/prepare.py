from pathlib import Path
import numpy as np,json,collections,struct,hashlib
R=Path(__file__).resolve().parents[1];W=R.parents[1]
a=W/'fox-v3-floor-world-reflection/capture/on/native-front-baseline';b=W/'fox-v3-indexed-bvh-bounds/actual-on-001/native-front-baseline'
rows=[json.loads(l) for l in Path(str(a)+'.samples.jsonl').read_text().splitlines()];groups=collections.defaultdict(dict)
for r in rows:assert r['sample'] not in groups[r['x'],r['y']];groups[r['x'],r['y']][r['sample']]=r
hdr=np.fromfile(str(b)+'.hdr.f64le',dtype='<f8').reshape(135,240,3);rgb=np.fromfile(str(b)+'.u16le',dtype='<u2').reshape(135,240)
keep=[];ex=[];pixels=[]
for (x,y),rs in sorted(groups.items(),key=lambda p:(p[0][1],p[0][0])):
 assert set(rs)==set(range(4));v=np.array([rs[j]['linearRGB'] for j in range(4)]);s=np.zeros(3)
 for j in range(4):s+=v[j]
 if np.array_equal(s/4,hdr[y,x]):keep.append(v);pixels.append((x,y))
 else:ex.append({'x':x,'y':y,'hit_slots':sum(r['hit'] for r in rs.values()),'max_mean_difference':float(np.max(np.abs(s/4-hdr[y,x])))})
assert len(keep)==1746 and all(all(groups[xy][j]['hit'] for j in range(4)) for xy in pixels)
def corpus(name,slots,expected):
 slots=np.asarray(slots,dtype='<f8');n,count,_=slots.shape;assert np.all(np.isfinite(slots)) and slots.min()>=0 and slots.max()<65536
 q=np.rint(slots*16777216).astype('<u8');assert np.all(q<2**40)
 with (R/('private/'+name+'.bin')).open('wb') as f:f.write(struct.pack('<II',n,count));f.write(slots.tobytes());f.write(q.tobytes());f.write(np.asarray(expected,dtype='<u2').tobytes())
corpus('verified_aa',keep,[rgb[y,x] for x,y in pixels]);corpus('final_hdr_only',hdr.reshape(-1,1,3),rgb.reshape(-1))
files=[Path(str(a)+s) for s in ['.samples.jsonl','.snapshot','.targets.u8','.u16le']]+[Path(str(b)+s) for s in ['.hdr.f64le','.u16le','.snapshot','.targets.u8']]
metadata={'quarter_records':len(rows),'quarter_pixels':len(groups),'hits':sum(r['hit'] for r in rows),'misses':sum(not r['hit'] for r in rows),'admitted_aa_pixels':len(keep),'admitted_slots':len(keep)*4,'excluded_pixels':len(ex),'excluded_slots':len(ex)*4,'strict_float_hdr_parity':True,'snapshot_equal':Path(str(a)+'.snapshot').read_bytes()==Path(str(b)+'.snapshot').read_bytes(),'targetmask_equal':Path(str(a)+'.targets.u8').read_bytes()==Path(str(b)+'.targets.u8').read_bytes(),'ancestor_final565_equal':Path(str(a)+'.u16le').read_bytes()==Path(str(b)+'.u16le').read_bytes(),'full_final_hdr_pixels':32400,'missing':'Resolver action and post-resolver selected HDR for slots. Miss event zero is not final background radiance. Hit may also be replaced. Excluded values not inferred.','source_sha256':{str(p.relative_to(W)):hashlib.sha256(p.read_bytes()).hexdigest() for p in files}}
(R/'private/CORPUS.json').write_text(json.dumps(metadata,indent=2));(R/'private/EXCLUDED_PIXELS.json').write_text(json.dumps(ex,indent=2));(R/'private/ADMITTED_PIXELS.json').write_text(json.dumps(pixels));print(json.dumps(metadata,indent=2))
