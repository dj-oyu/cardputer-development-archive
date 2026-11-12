"""Restricted OpenEXR2 single-part uncompressed float32 scanlines, no subsampling.
Format: AcademySoftwareFoundation/openexr website/OpenEXRFileLayout.rst.
Reject all unsupported layouts rather than guessing. Arrays use y-increasing file rows.
"""
import struct,pathlib,numpy as np

def read(path):
 b=pathlib.Path(path).read_bytes();assert len(b)>=8;magic,version=struct.unpack_from('<II',b);assert magic==20000630 and version in (2,1026);i=8;attrs={}
 def string(data,at):
  end=data.index(b'\0',at);assert end-at<=255;return data[at:end].decode('utf8'),end+1
 while b[i]:
  name,i=string(b,i);typ,i=string(b,i);n=struct.unpack_from('<I',b,i)[0];i+=4;assert n<=len(b)-i and name not in attrs;attrs[name]=(typ,b[i:i+n]);i+=n
 i+=1;assert attrs['compression']==('compression',b'\0');assert attrs['lineOrder']==('lineOrder',b'\0');assert attrs['dataWindow'][0]=='box2i';box=struct.unpack('<4i',attrs['dataWindow'][1]);x0,y0,x1,y1=box;assert x0==y0==0 and 0<x1+1<=4096 and 0<y1+1<=4096;w=x1+1;h=y1+1;assert attrs['channels'][0]=='chlist';cb=attrs['channels'][1];j=0;channels=[]
 while cb[j]:
  name,j=string(cb,j);kind,linear,reserved,xs,ys=struct.unpack_from('<iB3sii',cb,j);j+=16;assert kind==2 and xs==ys==1 and reserved==b'\0'*3 and name not in channels;channels.append(name)
 assert j+1==len(cb) and channels==sorted(channels) and 0<len(channels)<=256
 assert w*h*len(channels)*4<=16*1024*1024,'decoded buffer exceeds16MiB diagnostic limit';assert i+8*h<=len(b);offsets=struct.unpack_from('<'+'Q'*h,b,i);dataStart=i+8*h;out={c:np.empty((h,w),np.float32) for c in channels};seen=set();ranges=[]
 for offset in offsets:
  assert offset>=dataStart and offset+8<=len(b);y,n=struct.unpack_from('<iI',b,offset);assert y not in seen and 0<=y<h and n==w*4*len(channels) and offset+8+n<=len(b);seen.add(y);ranges.append((offset,offset+8+n));j=offset+8
  for name in channels:out[name][y]=np.frombuffer(b,dtype='<f4',count=w,offset=j);j+=w*4
 assert len(seen)==h and all(a[1]<=c[0] for a,c in zip(sorted(ranges),sorted(ranges)[1:]));assert all(np.isfinite(a).all() for a in out.values());return out

def write(path,channels):
 names=sorted(channels);a=[np.asarray(channels[n],dtype='<f4') for n in names];h,w=a[0].shape;assert all(x.shape==(h,w) and np.isfinite(x).all() for x in a)
 def attr(n,t,v):return n.encode()+b'\0'+t.encode()+b'\0'+struct.pack('<I',len(v))+v
 cl=b''.join(n.encode()+b'\0'+struct.pack('<iB3sii',2,0,b'\0'*3,1,1) for n in names)+b'\0';box=struct.pack('<4i',0,0,w-1,h-1)
 header=struct.pack('<II',20000630,2)+attr('channels','chlist',cl)+attr('compression','compression',b'\0')+attr('dataWindow','box2i',box)+attr('displayWindow','box2i',box)+attr('lineOrder','lineOrder',b'\0')+attr('pixelAspectRatio','float',struct.pack('<f',1))+attr('screenWindowCenter','v2f',struct.pack('<2f',0,0))+attr('screenWindowWidth','float',struct.pack('<f',1))+b'\0'
 rowbytes=8+w*4*len(names);start=len(header)+8*h;chunks=b''.join(struct.pack('<iI',y,rowbytes-8)+b''.join(x[y].tobytes() for x in a) for y in range(h));pathlib.Path(path).write_bytes(header+struct.pack('<'+'Q'*h,*[start+y*rowbytes for y in range(h)])+chunks)
