import pathlib,json,numpy as np
R=pathlib.Path(__file__).resolve().parents[1];P=R.parent;names=json.loads((R/'source-object-map.json').read_text())['objects'];out={}
def rgb(path):
 u=np.fromfile(path,dtype='<u2').reshape(135,240);return np.stack([(u>>11)/31,((u>>5)&63)/63,(u&31)/31],axis=-1)
for view in ['front','oblique']:
 s=np.load(P/f'fox-v3-lighting-ab/score-four-both-002/{view}-direction-masks.npz');fg=s['sourceForeground'];domain=fg&s['responseStable'];oid=np.load(R/f'{view}-source-map.npz')['object'];a=rgb(P/f'fox-v3-lighting-ab/four-both-002/native-{view}-baseline.u16le');b=rgb(P/f'fox-v3-lighting-ab/four-both-002/native-{view}-direction.u16le');delta=(b-a)@np.array([.2126,.7152,.0722]);nb=delta>2/255;nd=delta<-2/255;rb=s['responseBright'];rd=s['responseDark'];rows=[]
 for i,name in [(-1,'UNASSIGNED_CENTER_RAY')]+list(enumerate(names)):
  mask=domain&(oid==i)
  if not mask.any():continue
  row={'object':name,'stablePixels':int(mask.sum()),'brightTP':int((mask&rb&nb).sum()),'brightFP':int((mask&~rb&nb).sum()),'brightFN':int((mask&rb&~nb).sum()),'darkTP':int((mask&rd&nd).sum()),'darkFP':int((mask&~rd&nd).sum()),'darkFN':int((mask&rd&~nd).sum()),'referenceBrightNativeDark':int((mask&rb&nd).sum()),'referenceDarkNativeBright':int((mask&rd&nb).sum()),'shapeMissing':int((mask&~s['candidateForeground']).sum()),'partialAlpha':int((mask&s['sourcePartialAlphaBoundary']).sum())};rows.append(row)
 out[view]={'stablePixels':int(domain.sum()),'sourceForeground':int(fg.sum()),'rows':sorted(rows,key=lambda r:r['brightFP']+r['brightFN'],reverse=True)}
 np.savez_compressed(R/f'{view}-direction-error-masks.npz',domain=domain,brightFP=domain&~rb&nb,brightFN=domain&rb&~nb,darkFP=domain&~rd&nd,darkFN=domain&rd&~nd,nativeDelta=delta,object=oid)
(R/'object-sign-errors.json').write_text(json.dumps(out,indent=2))
for v,x in out.items():
 print(v,'STABLE',x['stablePixels']);print(*x['rows'][:12],sep='\n')
