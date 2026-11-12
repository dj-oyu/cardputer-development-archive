import pathlib,json
R=pathlib.Path(__file__).resolve().parent;W=R.parent
base=json.loads((W/'fox-v3-normal-pair-evaluation/score-on-v2/evaluation.json').read_text())
def metrics(x):
 c=x['colorMeanPrecision'];r={'rgbAgreementPercent':c['candidateScores']['stableSubset']['rgbAgreementPercent'],'rgbMAE':c['candidateScores']['stableSubset']['rgbMAE'],'foregroundRGBDescriptive':c['candidateScores']['pooledFullForegroundDescriptive']['rgbAgreementPercent'],'IoU':x['shapeFullFrame']['IoU'],'missingPixels':x['shapeFullFrame']['missingPixels'],'extraPixels':x['shapeFullFrame']['extraPixels']}
 if 'response' in x:
  q=x['response']['candidateScores']['stableSubset'];r.update({k:q[k] for k in ['responseMagnitudeAgreementPercent','directionAgreementPercent','signedCorrelation','deltaLumaRMSE','deltaRGBRMSE']});r['brightIoU']=q['brightening']['IoU'];r['darkIoU']=q['darkening']['IoU']
 return r
out={'baseline':'frozen eyeB plus codec ON actual groundLe + one-bounce16','scope':'Frozen-v3 conditional metrics; inherited muzzle geometry preservation FAIL remains independent; eye geometry audit reported separately; no formal adoption or 60% global claim','baselineMetrics':{k:metrics(x) for k,x in base['conditions'].items()},'candidates':{}}
for stage in ['lid8','lid9']:
 p=R/f'score-{stage}/evaluation.json'
 if not p.exists():continue
 e=json.loads(p.read_text());rows={}
 for key,x in e['conditions'].items():
  a=metrics(x);b=out['baselineMetrics'][key];rows[key]={'metrics':a,'deltaVsEyeB':{k:a[k]-b[k] if a[k] is not None and b[k] is not None else None for k in a}}
 accounting=json.loads((R/f'actual-{stage}-v2/accounting.json').read_text());mx={k:max(a[k] for a in accounting) for k in ['snapshotBytes','work','visibilityRays','visibilityNodeVisits','visibilityTriangleTests','transportRays','transportNodeVisits','transportTriangleTests']}
 ds=[x['deltaVsEyeB']['rgbAgreementPercent'] for x in rows.values()];out['candidates'][stage]={'conditions':rows,'maxActualCounters':mx,'rgbImprovedConditions':sum(d>0 for d in ds),'rgbRegressedConditions':sum(d<0 for d in ds),'rgbDeltaRangePP':[min(ds),max(ds)],'sixtyPercentGoal':e['sixtyPercentGoal'],'globalAcceptance':e['globalAcceptance']}
(R/'actual-comparison.json').write_text(json.dumps(out,indent=2));print(json.dumps({k:{i:v for i,v in x.items() if i!='conditions'} for k,x in out['candidates'].items()},indent=2))
