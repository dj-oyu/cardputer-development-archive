from pathlib import Path
import json,hashlib,gzip,math,numpy as np
from PIL import Image
W=Path('/workspace/scratch/6d8dcdbcdc54');R=W/'fox-v3-floor-world-reflection';REF=W/'fox-reference-uncertainty-v3';A=R/'analysis-code/analysis-001'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest();read=lambda p:json.loads(Path(p).read_text());readgz=lambda p:json.loads(gzip.decompress(Path(p).read_bytes()))
referencepins=W/'fox-v3-lid-evaluation/actual-lid8-v2/scoring/reference-pins.json';assert sha(referencepins)=='f6eb532400cab10bdfcd72b48d53df8f7fd468896ad8acb7a3b358c7d736d2bf';pins=read(referencepins)['files'];assert all(sha(REF/p)==h for p,h in pins.items());artifact=read(REF/'artifact-manifest.json')['files'];assert all(sha(REF/p)==h['sha256'] for p,h in artifact.items());done=read(A/'COMPLETED.json');assert done['status']=='WORLD_REFLECTION_METRICS_COMPLETE_NOT_GLOBAL_ACCEPTANCE';assert all(sha(A/p)==h['sha256'] for p,h in done['files'].items());manifest=read(REF/'render-manifest.json');plan=read(REF/'plan.json');assert plan['repetitions']==8 and plan['threshold']==2/255
images={}
for f in manifest['images']:
 assert sha(REF/f['file'])==f['sha256'];images[f['view'],f['case'],f['seed']]=np.array(Image.open(REF/f['file']))[:,:,:3]
formal={arm:readgz(A/f'FORMAL_{arm.upper()}.json.gz') for arm in ['off','on']};desc={arm:readgz(A/f'DESCRIPTIVE_{arm.upper()}.json.gz') for arm in ['off','on']}
rows=[];responses=[];max_delta=0
for view in plan['views']:
 fgrow=manifest['foreground'][view];assert sha(REF/fgrow['file'])==fgrow['sha256'];fg=np.array(Image.open(REF/fgrow['file']))[:,:,3]>0
 refs={case:np.stack([images[view,case,s] for s in plan['seeds']]) for case in plan['cases']}
 candidates={};codes={}
 for arm in ['off','on']:
  for case in plan['cases']:
   key=view+'-'+case;packed=np.fromfile(R/f'composed-{arm}'/f'agx-{key}.u16le','<u2').reshape(135,240);q=np.stack([packed>>11,(packed>>5)&63,packed&31],-1).astype(np.int64);codes[arm,case]=q;candidates[arm,case]=q/np.array([31.,63.,31.])
   # Alternative reduction: sum integer PNG samples first, then one normalization;
   # scalar math.fsum over all pixel-channel errors rather than scorer numpy.mean.
   refmean=refs[case].sum(0,dtype=np.int64)/(8*255.);error=(candidates[arm,case]-refmean)[fg].ravel();mae=math.fsum(abs(float(e)) for e in error)/len(error);rmse=math.sqrt(math.fsum(float(e)*float(e) for e in error)/len(error));expected=formal[arm]['conditions'][key]['colorMeanPrecision']['candidateScores']['pooledFullForegroundDescriptive'];assert expected['pixels']==int(fg.sum());delta=max(abs(mae-expected['rgbMAE']),abs(rmse-expected['rgbRMSE']));max_delta=max(max_delta,delta);assert delta<2e-15;rows.append({'arm':arm,'condition':key,'pixels':int(fg.sum()),'rgbMAE':mae,'rgbRMSE':rmse,'maxAbsoluteDifferenceFromFormal':delta})
 # Independent exact integer PNG luma numerator, algebraic second-moment variance.
 dif=refs['ambient'].astype(np.int64)-refs['baseline'].astype(np.int64);v=dif[:,:,:,0]*2126+dif[:,:,:,1]*7152+dif[:,:,:,2]*722;total=v.sum(0,dtype=np.int64);mean=total.astype(np.longdouble)/8;sq=(v*v).sum(0,dtype=np.int64).astype(np.longdouble);variance=(sq-total.astype(np.longdouble)**2/8)/7;variance=np.maximum(variance,0);half=np.longdouble('2.3646242515927844')*np.sqrt(variance/8);lower=mean-half;upper=mean+half
 bright=(v.min(0)>20000)&(lower>20000);dark=(v.max(0)<-20000)&(upper<-20000);inactive=(np.abs(v).max(0)<=20000)&(lower>=-20000)&(upper<=20000);stable=bright|dark|inactive
 with np.load(REF/f'evaluation-masks/{view}-ambient-response.npz',allow_pickle=False) as z:
  for key,value in [('foreground',fg),('bright',bright),('dark',dark),('inactive',inactive),('stable',stable)]:assert np.array_equal(z[key],value)
 for arm in ['off','on']:
  delta=codes[arm,'ambient']-codes[arm,'baseline'];num=delta[:,:,0]*2126*63+delta[:,:,1]*7152*31+delta[:,:,2]*722*63;den=31*63*10000;candidatebright=num*255>2*den # integer rational equivalent of decoded565 deltaY >2/255
  refpos=fg&bright;testpos=fg&stable&candidatebright;tp=int((refpos&testpos).sum());fn=int((refpos&~candidatebright).sum());fp=int((fg&(dark|inactive)&candidatebright).sum());union=tp+fn+fp;iou=tp/union;expected=formal[arm]['conditions'][view+'-ambient']['response']['candidateScores']['stableSubset']['brightening'];conf=desc[arm]['conditions'][view+'-ambient']['fullForeground']['response']['confusionAndUnknown'];assert tp==expected['intersection'] and union==expected['union'] and iou==expected['IoU'];assert fn==conf['brightFN'] and fp==conf['brightFP'];responses.append({'arm':arm,'view':view,'brightIoU':iou,'brightTP':tp,'brightFN':fn,'brightFP':fp,'brightUnion':union,'referenceUncertainPixels':int((fg&~stable).sum())})
for condition in [v+'-'+c for v in plan['views'] for c in plan['cases']]:
 off=next(x for x in rows if x['condition']==condition and x['arm']=='off');on=next(x for x in rows if x['condition']==condition and x['arm']=='on');assert on['rgbMAE']<off['rgbMAE'] and on['rgbRMSE']<off['rgbRMSE']
assert all(sha(REF/p)==h for p,h in pins.items());assert all(sha(A/p)==h['sha256'] for p,h in done['files'].items())
result={'status':'INDEPENDENT_LIMITED_METRICS_PASS','scope':'All10 full-reference-foreground RGB MAE/RMSE, both arms; two ambient stable bright IoUs and full-foreground stable-label FN/FP, both arms. No other scalar recomputed.','analysisCompletionSHA256':sha(A/'COMPLETED.json'),'referencePinsSHA256':sha(referencepins),'referenceAndThresholdUnchanged':True,'formalScorerExecuted':False,'method':'Reference PNG8 integer sum /2040 then scalar math.fsum errors; response reference integer luma with second-moment Student-t interval and candidate exact rational RGB565 threshold. Independently reconstructed masks equal frozen masks.','maximumColorDifferenceFromSavedFormal':max_delta,'all10FullForegroundMAEAndRMSEImprove':True,'ambient':responses,'colorRows':rows,'limitations':['Metrics are fixed reference-foreground/descriptive and stable-subset conditional scores, not global acceptance.','No rerender, display re-encoding, source adjustment, threshold adjustment or exclusions.','No revalidation of all13 domains, all8 responses or exhaustive scalar audit.','Oblique ambient brightFP rises6 to7; all10 color improvement is not universal response-metric improvement.']}
Path('/tmp/floor-world-metrics-result.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({k:v for k,v in result.items() if k!='colorRows'},indent=2))
