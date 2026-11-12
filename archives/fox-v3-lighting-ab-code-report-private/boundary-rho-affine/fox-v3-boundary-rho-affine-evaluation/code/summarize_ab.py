from pathlib import Path
import json,sys,numpy as np,hashlib
D=Path(sys.argv[1]).resolve();O=D/'comparison';assert not O.exists();O.mkdir()
roots={arm:D/f'actual-{arm}2'/'on' for arm in ['A','B']};e={arm:json.load(open(roots[arm]/'score-v3/evaluation.json')) for arm in roots}
def clean(x):
 if isinstance(x,dict):return {k:clean(v) for k,v in x.items() if k not in ['candidateMetadata','uncertainLocationsYX','uncertainSignFrequencyAtLocations']}
 if isinstance(x,list):return [clean(v) for v in x]
 return x
conditions={k:{arm:clean(e[arm]['conditions'][k]) for arm in e} for k in e['A']['conditions']}
def rgb(arm,view,case):
 u=np.fromfile(roots[arm]/'private-partial'/f'native-{view}-{case}.u16le','<u2').reshape(135,240);return np.stack([(u>>11)/31,((u>>5)&63)/63,(u&31)/31],axis=-1)
responses={}
for view in ['front','oblique']:
 for case in ['direction','intensity','ambient','albedo']:
  key=view+'-'+case;z=np.load(roots['B']/'score-v3'/f'{key}-masks.npz');responses[key]={}
  for arm in e:
   delta=(rgb(arm,view,case)-rgb(arm,view,'baseline'))@np.array([.2126,.7152,.0722]);cb=delta>2/255;cd=delta< -2/255;ci=~(cb|cd);refb=z['responseBright'];refd=z['responseDark'];refi=z['responseInactive'];stable=z['responseStable'];unknown=z['responseUncertain'];r={}
   for name,ref,cand in [('bright',refb,cb),('dark',refd,cd)]:
    r[name]={'TP':int((ref&cand).sum()),'FPWithinStable':int((stable&~ref&cand).sum()),'FN':int((ref&~cand).sum())}
   r.update({'inactiveFalseResponse':int((refi&(cb|cd)).sum()),'reverseSignWithinStable':int(((refb&cd)|(refd&cb)).sum()),'unknownNotPass':int(unknown.sum()),'unknownCandidateBright':int((unknown&cb).sum()),'unknownCandidateDark':int((unknown&cd).sum()),'unknownCandidateInactive':int((unknown&ci).sum())});responses[key][arm]=r
runtime={}
for arm in e:
 rows=json.load(open(roots[arm]/'COMPLETED.json'))['frames'];runtime[arm]={}
 for row in rows:
  key=row['view']+'-'+row['case']+('-reverse' if row['reverse'] else '');m=row['metadata'];r={k:v for k,v in m.items() if k.startswith(('visibility','transport')) and any(t in k for t in ['Rays','NodeVisits','TriangleTests','Limit'])};r['legacyCenterWork']=m['work'];r['shades']=m['shadeUpdates']
  if arm in roots:
   a=json.load(open(str(roots[arm]/row['prefix'])+'.aa.json'));r.update({'newStageReserved':a['reservedTotal'],'newStageObserved':a['observedTotal'],'sampleShades':a['sampleShades']})
  runtime[arm][key]=r
result={'scope':'Fixed full formal domains and original masks. Unknown never PASS; support is not geometry improvement. New host API/work/error contract only.','globalAcceptance':e['B']['globalAcceptance'],'conditions':conditions,'responseConfusion':responses,'runtime':runtime,'sampleControls':json.load(open(roots['B']/'SAMPLE_AUDIT.json')),'support':json.load(open(roots['B']/'score-v3/support-diagnostic.json'))}
(O/'summary.json').write_text(json.dumps(result,indent=2)+'\n');print('SUMMARY_COMPLETE')
