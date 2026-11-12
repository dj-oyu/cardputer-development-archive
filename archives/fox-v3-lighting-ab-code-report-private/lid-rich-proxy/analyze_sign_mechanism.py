"""No new rendering/fitting: signed linear component and leave-one-out diagnostics."""
from pathlib import Path
import json,sys,hashlib,numpy as np
R=Path(__file__).resolve().parent;P=R/'reverse-join-002/private-point-join.json';D=Path(sys.argv[1]).resolve();assert D.parent==R and not D.exists();D.mkdir()
Y=np.array([.2126,.7152,.0722]);rows=json.loads(P.read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();pins={str(p):sha(p) for p in [Path(__file__),P,R/'reverse-join-002/summary.json']}
def cls(v,t):return 1 if v>t else -1 if v< -t else 0
out={}
for view in ['front','oblique']:
 selected=[r for r in rows if r['view']==view and r['displayClasses']['proxyOriginalAgXBH']==r['reference']]
 out[view]={}
 for cohort in ['allProxyCorrect','sameObject','differentObject']:
  group=[r for r in selected if cohort=='allProxyCorrect' or r['correspondence']==cohort];out[view][cohort]={'n':len(group),'thresholds':{}}
  for label,t in [('rawSignNoThreshold',0.0),('existing2over255NumericScale',2/255)]:
   n=len(group);result={'n':n,'nativeDirectVersusProxyDirect':{'sameNonzeroSign':0,'oppositeSign':0,'eitherZeroOrSmall':0},'proxyDirectVersusCombined':{'sameNonzeroSign':0,'oppositeSign':0,'eitherZeroOrSmall':0},'components':{},'leaveOneOut':{}}
   for r in group:
    p={k:float(np.array(v)@Y) for k,v in r['proxyFilteredDelta'].items()};nd=float(np.array(r['nativeDelta']['direct'])@Y);pd=p['DirectDiffuse'];comb=p['Combined'];ref=1 if r['reference']=='bright' else -1
    for key,a,b in [('nativeDirectVersusProxyDirect',nd,pd),('proxyDirectVersusCombined',pd,comb)]:
     ca,cb=cls(a,t),cls(b,t);result[key]['eitherZeroOrSmall' if ca==0 or cb==0 else 'sameNonzeroSign' if ca==cb else 'oppositeSign']+=1
    for k,v in p.items():
     z=result['components'].setdefault(k,{'sourceDirectionSign':0,'oppositeSourceDirection':0,'zeroOrSmall':0,'positive':0,'negative':0,'zero':0,'sumY':0.,'sumAbsY':0.});c=cls(v,t);z['sourceDirectionSign' if c==ref else 'zeroOrSmall' if c==0 else 'oppositeSourceDirection']+=1;z['positive' if c>0 else 'negative' if c<0 else 'zero']+=1;z['sumY']+=v;z['sumAbsY']+=abs(v)
     if k=='Combined':continue
     lo=cls(comb-v,t);cc=cls(comb,t);z=result['leaveOneOut'].setdefault(k,{'combinedClassChanged':0,'nonzeroSignReversed':0,'becomesZeroOrSmall':0,'sourceDirectionSignWithout':0,'oppositeSourceDirectionWithout':0,'zeroOrSmallWithout':0});z['combinedClassChanged']+=lo!=cc;z['nonzeroSignReversed']+=lo*cc==-1;z['becomesZeroOrSmall']+=lo==0 and cc!=0;z['sourceDirectionSignWithout' if lo==ref else 'zeroOrSmallWithout' if lo==0 else 'oppositeSourceDirectionWithout']+=1
   out[view][cohort]['thresholds'][label]=result
assert all(sha(Path(p))==h for p,h in pins.items())
def save(p,v):p.write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
save(D/'summary.json',{'views':out,'scope':['Cohort fixed by legacy opposite-sign and proxy ordinary PNG corrected sign; not selected by component magnitude.','Raw sign and the pre-existing 2/255 numeric scale are separate columns. Applying display threshold magnitude to linear radiance is diagnostic only, not a formal display classification.','Individual component and Combined-minus-one-component tests are computed without sequential summation order attribution.','Leave-one-out linear radiance is not a rerender: no re-evaluation of adaptive sampling, GI, nonlinear display or visibility.','DirectDiffuse is not total direct light; glossy direct is a distinct retained component.','Filtered proxy and native center point differ; neither direct divergence nor leave-one-out proves a unique physical cause.','No ground-origin attribution.']});save(D/'input-hashes.json',pins)
for v in out:
 for k,g in out[v].items():
  print(v,k,g['n'],[(a,b['nativeDirectVersusProxyDirect'],b['proxyDirectVersusCombined']) for a,b in g['thresholds'].items()])
