#!/usr/bin/env python3
"""Finite lossless independently indexed LUT block study. Stdlib only; private input.
No decoded or encoded LUT data are persisted; report contains aggregates only.
Frozen layouts: cube4/8/16, line64/256. Predictors: min, d1, d2, Lorenzo.
Entropy choices: fixed-width; fixed-width or Rice k=0..16; zlib9 reference.
"""
import argparse, hashlib, json, math, pathlib, re, struct, time, zlib
N=65

def blocks(layout):
 kind,b=layout
 if kind=='line':
  for start in range(0,N**3,b): yield list(range(start,min(start+b,N**3))), (1,1,min(b,N**3-start))
 else:
  for x in range(0,N,b):
   for y in range(0,N,b):
    for z in range(0,N,b):
     sh=(min(b,N-x),min(b,N-y),min(b,N-z))
     yield [(i*N+j)*N+k for i in range(x,x+sh[0]) for j in range(y,y+sh[1]) for k in range(z,z+sh[2])],sh

def pred(v,i,mode,sh):
 if mode==1: return v[i-1] if i else 0
 if mode==2: return (2*v[i-1]-(v[i-2] if i>1 else 0)) if i else 0
 # Causal 3D inclusion-exclusion with zero outside this block.
 a,b,c=sh; x=i//(b*c); y=i//c%b; z=i%c
 p=0
 for dx,dy,dz,sg in ((1,0,0,1),(0,1,0,1),(0,0,1,1),(1,1,0,-1),(1,0,1,-1),(0,1,1,-1),(1,1,1,1)):
  if x>=dx and y>=dy and z>=dz: p+=sg*v[i-dx*b*c-dy*c-dz]
 return p

def residual(v,mode,sh):
 out=[]
 for i,x in enumerate(v):
  d=((x-pred(v,i,mode,sh)+32768)&65535)-32768
  out.append((d<<1)^(d>>15))
 return out

class Writer:
 def __init__(self): self.out=bytearray(); self.acc=0; self.n=0
 def put(self,x,n):
  self.acc|=x<<self.n; self.n+=n
  while self.n>=8:
   self.out.append(self.acc&255); self.acc>>=8; self.n-=8
 def end(self):
  if self.n:self.out.append(self.acc)
  return bytes(self.out)
class Reader:
 def __init__(self,data):self.d=data;self.i=0;self.n=0;self.acc=0
 def get(self,n):
  while self.n<n:
   self.acc|=self.d[self.i]<<self.n;self.i+=1;self.n+=8
  x=self.acc&((1<<n)-1);self.acc>>=n;self.n-=n;return x

def options(v,sh,rice):
 mn=min(v); r=[x-mn for x in v]; opts=[(4+(len(v)*max(r).bit_length()+7)//8,0,max(r).bit_length(),mn,r)]
 for mode in (1,2,3):
  r=residual(v,mode,sh);w=max(r).bit_length()
  opts.append((2+(len(r)*w+7)//8,mode,w,0,r))
  if rice:
   for k in range(17):
    bits=sum(x>>k for x in r)+len(r)*(k+1)
    opts.append((2+(bits+7)//8,mode+4,k,0,r))
 return min(opts,key=lambda o:o[0])

def encode(o):
 size,mode,k,mn,r=o;w=Writer()
 for x in r:
  if mode>=4:
   q=x>>k;w.put(0,q);w.put(1,1);w.put(x&((1<<k)-1),k)
  else:w.put(x,k)
 out=bytes([mode,k])+(struct.pack('<H',mn) if mode==0 else b'')+w.end()
 assert len(out)==size
 return out

def decode(data,count,sh):
 mode,k=data[:2];mn=struct.unpack_from('<H',data,2)[0] if mode==0 else 0
 reader=Reader(data[4 if mode==0 else 2:]);v=[]
 for i in range(count):
  if mode>=4:
   q=0
   while reader.get(1)==0:q+=1
   x=(q<<k)|reader.get(k)
  else:x=reader.get(k)
  if mode==0:v.append(x+mn)
  else:v.append((pred(v,i,mode-4 if mode>=4 else mode,sh)+((x>>1)^-(x&1)))&65535)
 return v

def main():
 ap=argparse.ArgumentParser();ap.add_argument('--input',default='fox-v3-profile-integration-feasibility/build-private/agx_lut.inc');ap.add_argument('--output',default='fox-v3-lossless-profile-lut/research/aggregate_results.json');args=ap.parse_args()
 src=pathlib.Path(args.input).read_bytes();s=src.decode().split('{',1)[1].split('}',1)[0];lut=list(map(int,re.findall(r'\d+',s)));assert len(lut)==N**3*3
 results=[];start=time.perf_counter()
 for layout in [('cube',4),('cube',8),('cube',16),('line',64),('line',256)]:
  totals=[0,0,0];headers=[0,0,0];maxblob=[0,0,0];modes=[{},{}];nb=0;maxcount=0;decode_times=[0,0];checked=[0,0];maxunary=[0,0]
  for ids,sh in blocks(layout):
   nb+=1;maxcount=max(maxcount,len(ids));vs=[[lut[i*3+c] for i in ids] for c in range(3)]
   for family in (0,1):
    blob=0
    for v in vs:
     o=options(v,sh,family==1);data=encode(o);t=time.perf_counter();out=decode(data,len(v),sh);decode_times[family]+=time.perf_counter()-t
     assert out==v;checked[family]+=len(v);blob+=len(data);headers[family]+=4 if o[1]==0 else 2
     modes[family][str(o[1])]=modes[family].get(str(o[1]),0)+1
     if o[1]>=4:maxunary[family]=max(maxunary[family],max(o[4])>>o[2])
    totals[family]+=blob;maxblob[family]=max(maxblob[family],blob)
   raw=struct.pack('<'+'H'*(len(ids)*3),*(x for v in vs for x in v))
   lor=struct.pack('<'+'H'*(len(ids)*3),*(x for v in vs for x in residual(v,3,sh)))
   zr=zlib.compress(raw,9);zl=zlib.compress(lor,9);payload=min(len(zr),len(zl))+1
   assert zlib.decompress(zr)==raw and zlib.decompress(zl)==lor
   totals[2]+=payload;headers[2]+=1;maxblob[2]=max(maxblob[2],payload)
  for family,name in enumerate(('adaptive_bitpack','adaptive_rice_bitpack','zlib9_raw_or_lorenzo')):
   # 32-byte global format header and uint32 offsets, including terminal sentinel.
   index=(nb+1)*4;total=32+index+totals[family]
   row=dict(layout='%s%d'%layout,family=name,blocks=nb,encoded_blocks_bytes=totals[family],block_headers_included_bytes=headers[family],offset_index_bytes=index,global_header_bytes=32,total_ro_bytes=total,ratio=total/(len(lut)*2),illustrative_factory_headroom_after_ro=544048-total,max_block_vertices=maxcount,one_decoded_rgb_block_bytes=maxcount*6,max_encoded_block_bytes=maxblob[family])
   if family<2:row.update(verified_uint16_values=checked[family],mode_counts=modes[family],python_decode_seconds_all_blocks=decode_times[family],max_rice_unary_quotient=maxunary[family])
   results.append(row);print(json.dumps(row),flush=True)
  pathlib.Path(args.output).write_text(json.dumps(dict(input_sha256=hashlib.sha256(src).hexdigest(),raw_lut_bytes=len(lut)*2,results=results,elapsed_seconds=time.perf_counter()-start),indent=2)+'\n')
if __name__=='__main__':main()
