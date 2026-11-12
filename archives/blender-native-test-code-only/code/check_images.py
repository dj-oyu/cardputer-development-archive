"""Targeted comparator CLI: exit 0 pass, 3 named mismatch; no renderer-side data reused."""
import sys,json,pathlib,hashlib
import numpy as np
from analyze import rgb565,geometry,metrics
mode,ref,cand=sys.argv[1:4]
if mode=='hash':
 passed=hashlib.sha256(pathlib.Path(cand).read_bytes()).hexdigest()==ref
elif mode=='depth':
 a=np.fromfile(ref,dtype='<f4');b=np.fromfile(cand,dtype='<f4');passed=a.size==32400 and b.size==32400 and not np.isnan(a).any() and not np.isnan(b).any() and not np.isposinf(a).any() and not np.isposinf(b).any() and np.isfinite(a).any() and np.isfinite(b).any() and np.array_equal(a,b)
else:
 a=rgb565(ref);b=rgb565(cand)
 if mode=='geometry':passed=geometry(a,b)['pass']
 else:
  mask=a.max(2)>0
  if len(sys.argv)>4:
   x,y,w,h=map(int,sys.argv[4:8]);roi=np.zeros(mask.shape,bool);roi[y:y+h,x:x+w]=True;mask&=roi
  passed=metrics(a,b,mask).get('rgbMAE',1)<=.02
print(json.dumps({'gate':mode,'pass':bool(passed)}));sys.exit(0 if passed else 3)
