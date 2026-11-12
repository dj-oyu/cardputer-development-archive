from PIL import Image
import sys,numpy as np,json
assert len(sys.argv)==4
for p in sys.argv[1:3]:
 with open(p,'rb') as f:header=f.read(26)
 assert header[:8]==b'\x89PNG\r\n\x1a\n' and header[24:26]==bytes([8,6])
a=Image.open(sys.argv[1]);b=Image.open(sys.argv[2]);assert a.mode==b.mode=='RGBA' and a.size==b.size==(240,135);x=np.array(a);y=np.array(b);d=abs(x.astype(int)-y.astype(int));result={'pixelsDifferent':int(np.any(d,axis=-1).sum()),'maxByteDifference':int(d.max()),'RGBA8Exact':np.array_equal(x,y)};open(sys.argv[3],'w').write(json.dumps(result,indent=2));assert result['RGBA8Exact'],result
