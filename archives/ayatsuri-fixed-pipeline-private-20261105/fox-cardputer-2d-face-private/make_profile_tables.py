from PIL import Image
import numpy as np,pathlib,json,hashlib
P=pathlib.Path(__file__).resolve().parent;blob=bytearray();rows=[]
for f in sorted(P.glob('*-mask.png')):
 a=np.asarray(Image.open(f))>=128;recon=np.zeros_like(a);raw=bytearray()
 for x,col in enumerate(a.T):
  ys=np.where(col)[0]
  lo,hi=(int(ys[0]),int(ys[-1])) if len(ys) else (255,0)
  raw.extend([lo,hi])
  if lo!=255:recon[lo:hi+1,x]=True
 rows.append({'file':f.name,'offset':len(blob),'bytes':len(raw),'binary_threshold_pixels_equal':bool(np.array_equal(a,recon)),'sha256':hashlib.sha256(raw).hexdigest()});blob.extend(raw)
(P/'prototype-profile-tables.bin').write_bytes(blob);(P/'prototype-profile-tables.json').write_text(json.dumps({'layout':'128 columns of [min_row_u8,max_row_u8]. Empty=(255,0). Top-origin. Source mask threshold >=128.','bytes':len(blob),'all_binary_masks_reproduced_exactly':all(r['binary_threshold_pixels_equal'] for r in rows),'limitation':'Feasibility only; loses original antialias coverage; does not prove arbitrary interpolated expressions or runtime rendering. Not used to produce the images.','tables':rows},indent=2));print('PROFILE_BYTES',len(blob),'binary_equal',all(r['binary_threshold_pixels_equal'] for r in rows))
