import pathlib,json,numpy as np
from PIL import Image
R=pathlib.Path(__file__).resolve().parents[1];P=R.parent;D=R/'visibility';out={};parts={};names=json.loads((R/'source-object-map.json').read_text())['objects'];seeds=json.loads((P/'fox-reference-uncertainty-v3/plan.json').read_text())['seeds']
def rgb(p):
 u=np.fromfile(p,'<u2').reshape(135,240);return np.stack([(u>>11)/31,((u>>5)&63)/63,(u&31)/31],-1)
for view in ['front','oblique']:
 sm=np.load(P/f'fox-v3-lighting-ab/score-four-both-002/{view}-direction-masks.npz');dom=sm['sourceForeground']&sm['responseStable'];rb=sm['responseBright'];rd=sm['responseDark'];oid=np.load(R/f'{view}-source-map.npz')['object'];states={}
 for name,base,prefix in [('vertex',P/'fox-v3-lighting-ab/four-both-002','native-'),('off',R,'pixel-'),('on',D,'visible-')]:
  images={case:rgb(base/f'{prefix}{view}-{case}.u16le') for case in ['baseline','direction']};delta=(images['direction']-images['baseline'])@np.array([.2126,.7152,.0722]);nb=delta>2/255;nd=delta<-2/255;fp=dom&~rb&nb;fn=dom&rb&~nb
  record={'brightTP':int((dom&rb&nb).sum()),'brightFP':int(fp.sum()),'brightFN':int(fn.sum()),'brightIoU':float((dom&rb&nb).sum()/(dom&(rb|nb)).sum()),'darkIoU':float((dom&rd&nd).sum()/(dom&(rd|nd)).sum()),'referenceDarkNativeBright':int((dom&rd&nb).sum()),'referenceBrightNativeDark':int((dom&rb&nd).sum())}
  for case in images:
   refs=np.stack([np.array(Image.open(P/f'fox-reference-uncertainty-v3/images/seed-{seed}-{view}-{case}.png'))[...,:3]/255 for seed in seeds]);cs=np.load(P/f'fox-v3-lighting-ab/score-four-both-002/{view}-{case}-masks.npz');mask=cs['sourceForeground']&cs['colorStable'];record[case+'StableRGB']=float(100*(1-np.abs(refs.mean(0)-images[case])[mask].mean()))
  states[name]=record
  parts[view+'-'+name]=[{'object':nm,'stablePixels':int((dom&(oid==i)).sum()),'brightFP':int((fp&(oid==i)).sum()),'brightFN':int((fn&(oid==i)).sum()),'referenceDarkNativeBright':int((dom&rd&nb&(oid==i)).sum()),'referenceBrightNativeDark':int((dom&rb&nd&(oid==i)).sum())} for i,nm in [(-1,'UNASSIGNED_CENTER_RAY')]+list(enumerate(names)) if (dom&(oid==i)).any()]
 out[view]=states
(D/'results.json').write_text(json.dumps(out,indent=2));(D/'object-sign-errors.json').write_text(json.dumps(parts,indent=2));print(json.dumps(out,indent=2))
