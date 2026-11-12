"""Fixed nine integer-neighbor BH diagnostic; no new rendering or filter fit."""
from pathlib import Path
import sys,json,hashlib,ast,numpy as np
R=Path(__file__).resolve().parent;W=R.parent;D=Path(sys.argv[1]).resolve();assert D.parent==R and not D.exists();D.mkdir();pins={}
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def pin(p):pins[str(p)]=sha(p);return p
def load(p):return json.loads(pin(p).read_text())
P=W/'fox-v3-lid-display-combination/postprocess_v2.py';tree=ast.parse(pin(P).read_text());fn=next(x for x in tree.body if isinstance(x,ast.FunctionDef) and x.name=='filter3');ns={'np':np};exec(compile(ast.Module(body=[fn],type_ignores=[]),str(P),'exec'),ns)
filter_config=load(W/'fox-v3-lid-display-combination/postprocess-002/filter.json');offsets=np.array(filter_config['offsets']);weights=np.array(filter_config['weights1D']);assert np.array_equal(offsets,[-1,0,1]);assert abs(weights.sum()-1)<1e-15
rows=load(R/'reverse-join-002/private-point-join.json');pin(Path(__file__));Y=np.array([.2126,.7152,.0722]);out={}
def cls(v,t):return 1 if v>t else -1 if v< -t else 0
for view in ['front','oblique']:
 filtered={}
 for c in ['baseline','direction']:
  w=load(W/'fox-v3-lid-transport-point-audit/capture-002'/f'native-{view}-{c}-winners.json');raw=np.zeros((135,240,3),np.float64);coverage=np.zeros((135,240),bool)
  for p in w['points']:raw[p['y'],p['x']]=p['direct'];coverage[p['y'],p['x']]=True
  filtered[c],support=ns['filter3'](raw,coverage,offsets,weights);assert (filtered[c][~support]==0).all()
 delta=filtered['direction']-filtered['baseline'];selected=[r for r in rows if r['view']==view and r['displayClasses']['proxyOriginalAgXBH']==r['reference']];out[view]={}
 for cohort in ['allProxyCorrect','sameObject','differentObject']:
  g=[r for r in selected if cohort=='allProxyCorrect' or r['correspondence']==cohort];out[view][cohort]={}
  for label,t in [('rawSignNoThreshold',0.),('existing2over255NumericScale',2/255)]:
   result={'n':len(g),'point':{'sameNonzero':0,'opposite':0,'eitherSmall':0},'filtered':{'sameNonzero':0,'opposite':0,'eitherSmall':0},'pointOppositeToFilteredSame':0,'pointOppositeToFilteredSmall':0,'pointSameToFilteredOpposite':0}
   for r in g:
    x,y=r['x'],r['y'];p=cls(np.array(r['nativeDelta']['direct'])@Y,t);f=cls(delta[y,x]@Y,t);q=cls(np.array(r['proxyFilteredDelta']['DirectDiffuse'])@Y,t)
    for arm,z in [('point',p),('filtered',f)]:result[arm]['eitherSmall' if z==0 or q==0 else 'sameNonzero' if z==q else 'opposite']+=1
    result['pointOppositeToFilteredSame']+=p*q==-1 and f==q;result['pointOppositeToFilteredSmall']+=p*q==-1 and f==0;result['pointSameToFilteredOpposite']+=p==q and p!=0 and f*q==-1
   out[view][cohort][label]=result
assert all(sha(Path(p))==h for p,h in pins.items())
def save(p,v):p.write_text(json.dumps(v,indent=2,allow_nan=False,default=lambda x:x.item())+'\n')
save(D/'summary.json',{'views':out,'filter':filter_config,'scope':'Same corrected-display cohort, native direct at all actual final winners, nohit/outside black, fixed full nine-weight denominator. Per-condition filtering then subtraction, exact prior filter3 AST. Integer-neighbor filter is not Cycles subpixel BH; no fit or new rendering. Linear 2/255 is magnitude diagnostic, not formal display classification.'});save(D/'input-hashes.json',pins);print(json.dumps(out['oblique'],indent=2,default=lambda x:x.item()))
