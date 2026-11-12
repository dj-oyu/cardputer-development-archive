"""Read-only independent barycentric reconstruction of recorded actual sample P/Ns at fixed offsets."""
from pathlib import Path
import sys,json,struct,math,hashlib
D=Path(sys.argv[1]).resolve();q=.25;arm=sys.argv[2];assert arm in ['off','zero','on'];O=D/arm;done=json.load(open(O/'COMPLETED.json'));rows=[];sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
for row in done['frames']:
 p=O/row['prefix'];b=Path(str(p)+'.snapshot').read_bytes();at=416;records={}
 while at<len(b):
  n,t,mode,res=b[at:at+4];size=struct.unpack_from('<H',b,at+10)[0];stride={4:56,5:50}[mode];vs=[]
  for j in range(n):
   k=at+12+stride*j;xy=struct.unpack_from('<ff',b,k);world=struct.unpack_from('<ddd',b,k+20);nf=struct.unpack_from('<hhh',b,k+44);nb=tuple(-x for x in nf) if mode==5 else struct.unpack_from('<hhh',b,k+50);vs.append((xy,world,nf,nb))
  ix=at+12+stride*n;records[at-416]=(vs,[tuple(b[ix+3*j:ix+3*j+3]) for j in range(t)],b[ix+3*t:ix+3*t+8]);at+=size
 hits=0;maxP=maxN=0.
 for line in open(str(p)+'.samples.jsonl'):
  s=json.loads(line)
  if not s['hit']:continue
  hits+=1;vs,tri,bits=records[s['recordOffset']];idx=tri[s['face']];v=[vs[k] for k in idx];xy=[x[0] for x in v];x=s['x']+(q if s['sample']&1 else -q);y=s['y']+(q if s['sample']&2 else -q)
  def edge(a,b):return (a[1]-b[1])*x+(b[0]-a[0])*y+a[0]*b[1]-b[0]*a[1]
  area=(xy[1][0]-xy[0][0])*(xy[2][1]-xy[0][1])-(xy[1][1]-xy[0][1])*(xy[2][0]-xy[0][0]);w=[edge(xy[1],xy[2])/area,edge(xy[2],xy[0])/area,edge(xy[0],xy[1])/area]
  assert min(w)>-1e-10 and abs(sum(w)-1)<1e-9
  back=bool((bits[s['face']//8]>>(s['face']%8))&1);assert back==s['back']
  world=[sum(w[j]*v[j][1][k] for j in range(3)) for k in range(3)];ns=[sum(w[j]*(v[j][3 if back else 2][k]/32767.) for j in range(3)) for k in range(3)];P=[world[0]/38,-world[2]/38,-world[1]/38];N=[ns[0],-ns[2],-ns[1]]
  maxP=max(maxP,max(abs(a-b) for a,b in zip(P,s['P'])));maxN=max(maxN,max(abs(a-b) for a,b in zip(N,s['Ns'])))
 assert maxP<1e-9 and maxN<1e-9,(row['view'],maxP,maxN)
 rows.append({'view':row['view'],'case':row['case'],'reverse':row['reverse'],'hits':hits,'maxPositionError':maxP,'maxNormalError':maxN,'snapshotSHA256':sha(Path(str(p)+'.snapshot')),'samplesSHA256':sha(Path(str(p)+'.samples.jsonl'))})
(Path(sys.argv[3]) if len(sys.argv)>3 else O/'POSITION_AUDIT.json').write_text(json.dumps({'status':'ALL20_FIXED_OFFSET_RECONSTRUCTION_PASS','offset':q,'offsetHex':q.hex(),'scope':'recorded face barycentric reconstruction, not exhaustive independent winner search','frames':rows},indent=2)+'\n');print('POSITION_AUDIT_PASS',D)
