from pathlib import Path
import json,sys,hashlib
R=Path(sys.argv[1]).resolve();evaluations={a:json.load(open(R/'actual-002'/('off' if a=='A' else 'on')/'score-v3/evaluation.json')) for a in ['A','B']}
higher={'IoU','rgbAgreementPercent','responseMagnitudeAgreementPercent','directionAgreementPercent','signedCorrelation','sourceRecall','candidatePrecision'}
lower={'rgbMAE','rgbRMSE','centroidDistanceDiagonal','deltaLumaRMSE','deltaRGBRMSE','extraPixels','missingPixels','extraFractionOfFrame','missingFractionOfFrame','missingFractionOfSource','extraFractionOfCandidate'}
skip={'candidateMetadata','uncertainLocationsYX','uncertainSignFrequencyAtLocations'}
def flat(x,path=()):
 out={}
 if isinstance(x,dict):
  for k,v in x.items():
   if k not in skip:out.update(flat(v,path+(k,)))
 elif isinstance(x,list):
  for j,v in enumerate(x):out.update(flat(v,path+(str(j),)))
 elif type(x) in [int,float]:out['/'.join(path)]=x
 return out
A=flat({k:evaluations['A'][k] for k in ['conditions','foreground']});B=flat({k:evaluations['B'][k] for k in ['conditions','foreground']});assert A.keys()==B.keys();changes=[];reg=[]
for p,a in A.items():
 b=B[p]
 if b==a:continue
 k=p.split('/')[-1];direction='higher' if k in higher else 'lower' if k in lower else 'descriptive';z={'path':p,'A':a,'B':b,'delta':b-a,'betterDirection':direction};changes.append(z)
 if direction=='higher' and b<a or direction=='lower' and b>a:reg.append(z)
result={'status':'ALL_FORMAL_DOMAINS_COMPARED','scalarCount':len(A),'changedScalarCount':len(changes),'regressingMetricCount':len(reg),'regressions':reg,'changes':changes,'scope':'All domains/seeds retained; no threshold or acceptance gate added; descriptive counters not assigned desirability'}
(R/'comparison/metric-changes.json').write_text(json.dumps(result,indent=2)+'\n');print(len(A),len(changes),len(reg))
