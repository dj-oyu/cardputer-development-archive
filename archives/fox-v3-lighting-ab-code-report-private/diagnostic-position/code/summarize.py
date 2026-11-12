import numpy as np,json,pathlib
R=pathlib.Path(__file__).resolve().parents[1];S=R.parent/'fox-v3-lighting-ab';out={};coverage={}
def rgb(p):
 u=np.fromfile(p,'<u2').reshape(135,240);return np.stack([(u>>11)/31,((u>>5)&63)/63,(u&31)/31],-1)
for view in ['front','oblique']:
 s=np.load(S/f'score-four-both-002/{view}-direction-masks.npz');dom=s['sourceForeground']&s['responseStable'];rb=s['responseBright'];rd=s['responseDark'];row={}
 for name,root,prefix in [('old',S/'four-both-002','native-'),('pixel',R,'pixel-')]:
  d=(rgb(root/f'{prefix}{view}-direction.u16le')-rgb(root/f'{prefix}{view}-baseline.u16le'))@np.array([.2126,.7152,.0722]);nb=d>2/255;nd=d<-2/255
  row[name]={'brightTP':int((dom&rb&nb).sum()),'brightFP':int((dom&~rb&nb).sum()),'brightFN':int((dom&rb&~nb).sum()),'brightIoU':float((dom&rb&nb).sum()/(dom&(rb|nb)).sum()),'darkIoU':float((dom&rd&nd).sum()/(dom&(rd|nd)).sum()),'sourceDarkNativeBright':int((dom&rd&nb).sum()),'sourceBrightNativeDark':int((dom&rb&nd).sum())}
  if name=='old':
   tp=row[name]['brightTP'];fp=row[name]['brightFP'];fn=row[name]['brightFN'];missing=int((dom&rb&~nb&~s['candidateForeground']).sum());interior=dom&~s['sourcePartialAlphaBoundary']
   coverage[view]={'TP':tp,'FP':fp,'FN':fn,'brightFNMissingCoverage':missing,'brightFNCovered':fn-missing,'brightFPFullAlpha':int((interior&~rb&nb).sum()),'brightFNFullAlpha':int((interior&rb&~nb).sum()),'coverageOnlyOracleUpperBound':(tp+missing)/(tp+fp+fn),'interiorDescriptiveIoU':float((rb&nb&interior).sum()/((rb|nb)&interior).sum()),'interiorPixels':int(interior.sum())}
 out[view]=row
for name,value in [('pixel-results.json',out),('coverage-error-budget.json',coverage)]:
 p=R/name
 if p.exists():assert json.loads(p.read_text())==value,'previous result mismatch'
 p.write_text(json.dumps(value,indent=2))
print(json.dumps(out))
