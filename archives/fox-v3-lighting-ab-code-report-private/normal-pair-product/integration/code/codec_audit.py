"""Strict, private snapshot evidence for this externally pinned eye-B experiment."""
import struct,hashlib,json

def sha_bytes(b):return hashlib.sha256(b).hexdigest()
def fnv(b):
 h=14695981039346656037
 for v in b:h=((h^v)*1099511628211)&0xffffffffffffffff
 return format(h,'016x')
def decode_snapshot(data):
 assert len(data)>=416;out=bytearray(data[:416]);at=416;counts={4:0,5:0};vertices=0;triangles=0
 while at<len(data):
  assert len(data)-at>=12;p=data[at:];nv,nt,mode,res=p[:4];assert 3<=nv<=32 and 1<=nt<=64 and mode in counts and res==0;assert struct.unpack_from('<H',p,6)[0]==struct.unpack_from('<H',p,8)[0]==0
  stride=50 if mode==5 else 56;raw=12+stride*nv+3*nt+(nt+7)//8;size=(raw+3)&~3;assert struct.unpack_from('<H',p,10)[0]==size and size<=len(p);p=p[:size];assert not any(p[raw:]);ix=p[12+stride*nv:12+stride*nv+3*nt];assert all(v<nv for v in ix) and all(len(set(ix[j:j+3]))==3 for j in range(0,len(ix),3));assert not (nt%8 and p[raw-1]>>(nt%8))
  q=bytearray(p[:12]);q[2]=4
  for i in range(nv):
   v=p[12+stride*i:12+stride*(i+1)];front=struct.unpack_from('<3h',v,44);assert all(-32767<=x<=32767 for x in front)
   if mode==5:q+=v+struct.pack('<3h',*[-int(x) for x in front])
   else:
    back=struct.unpack_from('<3h',v,50);assert all(-32767<=x<=32767 for x in back);q+=v
  q+=p[12+stride*nv:raw];q+=bytes((-len(q))%4);struct.pack_into('<H',q,10,len(q));out+=q;at+=size;counts[mode]+=1;vertices+=nv;triangles+=nt
 assert at==len(data);return bytes(out),counts,vertices,triangles

def audit(data,contract,mode,view,case,reverse,actual=None):
 key=view+'-'+case+('-reverse' if reverse else '');old,counts,nv,nt=decode_snapshot(data);assert sha_bytes(old)==contract['oldSnapshots'][key]['sha256'],'decoded snapshot differs from frozen eyeB';assert fnv(old)==contract['oldSnapshots'][key]['fnv'];assert nv==1066 and nt==1414
 expected=contract['modes'][str(mode)];assert len(data)==expected['snapshotBytes'];assert counts[4]==expected['mode4Records'] and counts[5]==expected['mode5Records']
 if actual is not None:
  for field in ['normalPairMode4Records','normalPairMode5Records','normalPairSavedBytes']:assert type(actual.get(field)) is int and actual[field]>=0,'codec metadata integer required: '+field
  assert actual['normalPairCodecEnabled'] is bool(mode);assert actual['normalPairMode4Records']==counts[4] and actual['normalPairMode5Records']==counts[5];assert actual['normalPairSavedBytes']==len(old)-len(data);assert actual['visibilitySnapshotFingerprint']==fnv(data)
 return {'snapshotSHA256':sha_bytes(data),'decodedOldSHA256':sha_bytes(old),'mode4Records':counts[4],'mode5Records':counts[5],'savedBytes':len(old)-len(data),'oldBytesExact':True}
