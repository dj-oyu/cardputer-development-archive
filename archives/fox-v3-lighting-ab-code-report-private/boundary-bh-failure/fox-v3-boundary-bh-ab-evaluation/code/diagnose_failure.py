from pathlib import Path
import struct,json,math
R=Path(__file__).resolve().parents[1];D=R/'actual-B';p=D/'on/private-partial/native-front-baseline';b=Path(str(p)+'.snapshot').read_bytes();q=float.fromhex('0x1.272062ae104d0p-2');x,y=123-q,53-q;at=416;winner=None
while at<len(b):
 n,t,mode,res=b[at:at+4];size=struct.unpack_from('<H',b,at+10)[0];stride={4:56,5:50}[mode];vs=[]
 for j in range(n):
  k=at+12+stride*j;vs.append({'xy':struct.unpack_from('<ff',b,k),'depth':struct.unpack_from('<f',b,k+12)[0],'colors':struct.unpack_from('<HH',b,k+16),'world':struct.unpack_from('<ddd',b,k+20),'nf':struct.unpack_from('<hhh',b,k+44)})
 ix=at+12+stride*n
 for f in range(t):
  v=[vs[k] for k in b[ix+3*f:ix+3*f+3]];xy=[z['xy'] for z in v];area=(xy[1][0]-xy[0][0])*(xy[2][1]-xy[0][1])-(xy[1][1]-xy[0][1])*(xy[2][0]-xy[0][0])
  def E(a,b):return (a[1]-b[1])*x+(b[0]-a[0])*y+a[0]*b[1]-b[0]*a[1]
  w=[E(xy[1],xy[2])/area,E(xy[2],xy[0])/area,E(xy[0],xy[1])/area]
  if min(w)<0:continue
  depth=struct.unpack('<f',struct.pack('<f',sum(w[j]*v[j]['depth'] for j in range(3))))[0]
  if winner is None or depth>winner['depth']:winner={'offset':at-416,'node':struct.unpack_from('<H',b,at+4)[0],'face':f,'depth':depth,'bary':w,'barySum':sum(w),'colors':[z['colors'] for z in v],'world':[sum(w[j]*v[j]['world'][k] for j in range(3)) for k in range(3)],'normal':[sum(w[j]*v[j]['nf'][k]/32767 for j in range(3)) for k in range(3)]}
 at+=size
print(json.dumps(winner,indent=2));(R/'failure-geometric-diagnostic-private.json').write_text(json.dumps(winner,indent=2)+'\n')
