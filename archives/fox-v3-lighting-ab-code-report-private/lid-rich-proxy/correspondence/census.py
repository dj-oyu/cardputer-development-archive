from pathlib import Path
import json,hashlib,numpy as np
from PIL import Image
R=Path(__file__).resolve().parent.parent;D=Path(__file__).resolve().parent
pins={}
def pin(p):
 pins[str(p.relative_to(R))]=hashlib.sha256(p.read_bytes()).hexdigest();return p
def dec(p):
 a=np.fromfile(pin(p),'<u2').reshape(135,240);return np.stack([((a>>11)&31)/31,((a>>5)&63)/63,(a&31)/31],-1)
out={}
for view in ['front','oblique']:
 root=R/'fox-v3-lid-transport-point-audit/verified-winners-v2';ws=[json.loads(pin(root/f'{view}-{c}.json').read_text()) for c in ['baseline','direction']];maps=[{(p['x'],p['y']):p for p in w['points']} for w in ws];assert maps[0].keys()==maps[1].keys()
 names=np.full((135,240),'NO_NATIVE',object)
 for xy,p in maps[0].items():
  q=maps[1][xy];assert all(p[k]==q[k] for k in ['node','face','physicalSide','P','Ns','rho','sourceObjectName','depth']);names[xy[1],xy[0]]=p['sourceObjectName']
 boundary=np.zeros((135,240),bool)
 for (x,y),p in maps[0].items():boundary[y,x]=any(not(0<=x+dx<240 and 0<=y+dy<135) or names[y+dy,x+dx]!=names[y,x] for dx,dy in [(1,0),(-1,0),(0,1),(0,-1)])
 ref=R/'fox-reference-uncertainty-v3';m=np.load(pin(ref/'evaluation-masks'/f'{view}-direction-response.npz'));alpha=np.asarray(Image.open(pin(ref/'images'/f'foreground-{view}.png')))[...,3];fg=alpha>0;assert np.array_equal(fg,m['foreground']);labels=np.full((135,240),'outside',object)
 for k in ['bright','dark','inactive','uncertain']:labels[(alpha>0)&m[k]]=k
 rows={}
 for arm in ['point-off','point-on','filter3-off','filter3-on']:
  pp=R/'fox-v3-lid-display-combination/postprocess-002';b,c=[dec(pp/f'{arm}-{view}-{case}.u16le') for case in ['baseline','direction']];delta=(c-b)@np.array([.2126,.7152,.0722]);cl=np.where(delta>2/255,'bright',np.where(delta< -2/255,'dark','inactive'))
  def counts(mask):return {a:{z:int(np.count_nonzero(mask&(labels==a)&(cl==z))) for z in ['bright','dark','inactive']} for a in ['bright','dark','inactive','uncertain','outside']}
  strata={'all':np.ones(fg.shape,bool),'foreground':fg,'nativeCovered':names!='NO_NATIVE','nativeMissingForeground':fg&(names=='NO_NATIVE'),'nativeExtra':(~fg)&(names!='NO_NATIVE'),'sourcePartialAlpha':(alpha>0)&(alpha<255),'sourceOpaqueAlpha':alpha==255,'nativeObjectBoundary':boundary,'nativeInterior':(names!='NO_NATIVE')&~boundary}
  rows[arm]={'strata':{k:counts(v) for k,v in strata.items()},'byNativeObject':{str(n):counts(names==n) for n in sorted(set(names.flat))}}
 out[view]=rows
(D/'census.json').write_text(json.dumps({'scope':'descriptive fullframe; source IDs belong to native winners, not proven original winners','views':out,'inputHashes':pins},indent=2))
for v,arms in out.items():
 for a,d in arms.items():
  c=d['strata']['foreground'];print(v,a,'reverse',c['bright']['dark'],c['dark']['bright'],'inactive FN',c['bright']['inactive'],c['dark']['inactive'],'inactiveFP',c['inactive']['bright']+c['inactive']['dark'])
