"""Join true sample coordinates; never assume JSONL adjacency is one pixel."""
from pathlib import Path
import json,numpy as np

def load_target_means(prefix,names):
 mask=np.fromfile(str(prefix)+'.targets.u8',np.uint8).reshape(135,240);assert np.isin(mask,[0,1]).all();expected={(int(y),int(x)) for y,x in np.argwhere(mask)};pixels={};seen=set()
 for line in open(str(prefix)+'.samples.jsonl'):
  s=json.loads(line);x,y,j=s['x'],s['y'],s['sample'];assert all(type(v)is int for v in [x,y,j]) and 0<=j<4 and (y,x) in expected;key=(y,x,j);assert key not in seen;seen.add(key)
  if (y,x) not in pixels:pixels[y,x]={n:[None]*4 for n in names}
  for n in names:
   a=np.asarray(s[n] if s['hit'] else [0.,0.,0.],np.float64);assert a.shape==(3,) and np.isfinite(a).all();pixels[y,x][n][j]=a
 assert seen=={(y,x,j) for y,x in expected for j in range(4)} and set(pixels)==expected
 result={}
 for n in names:
  vals=[]
  for key in sorted(expected):
   total=np.zeros(3,np.float64)
   for j in range(4):total+=pixels[key][n][j]
   vals.append(total/4)
  result[n]=np.asarray(vals)
 return result
