"""PNG8 oracle candidate integer luma, without modifying frozen v3 evaluator."""
import numpy as np,math,evaluator as E
W=np.array([2126,7152,722],np.int64);DEN=2550000;T=20000

def metrics(a,b,c0,c1,mask,rn,rmasks):
 cn=(c1.astype(np.int64)-c0.astype(np.int64))@W;af=rn[mask]/DEN;bf=cn[mask]/DEN;n=int(mask.sum())
 if not n:return {'status':'NO_EVALUATION_DOMAIN','pixels':0,'metrics':None}
 na=float(np.linalg.norm(af));nb=float(np.linalg.norm(bf));sig=(abs(rn[mask])>T)|(abs(cn[mask])>T);magnitude=None if max(na,nb)==0 else 100*min(na,nb)/max(na,nb);sign=None if not sig.any() else float(100*np.mean(np.sign(rn[mask][sig])==np.sign(cn[mask][sig])))
 out={'pixels':n,'significantPixels':int(sig.sum()),'deltaLumaRMSE':float(np.sqrt(np.mean((af-bf)**2))),'deltaRGBRMSE':float(np.sqrt(np.mean((b-a-c1/255+c0/255)[mask]**2))),'responseMagnitudeAgreementPercent':magnitude,'magnitudeValueStatus':'DESCRIPTIVE_ONLY_NOT_ACCEPTANCE','directionAgreementPercent':sign,'signValueStatus':'DESCRIPTIVE_ONLY_NOT_ACCEPTANCE','oneSideUnresponsive':bool((na==0)!=(nb==0)),'signedCorrelation':None if np.ptp(af)==0 or np.ptp(bf)==0 else E._finite_correlation(af,bf)}
 for name,sgn in [('brightening',1),('darkening',-1)]:
  rm=mask&rmasks[name];nm=mask&(sgn*cn>T);u=rm|nm;out[name]={'referencePixels':int(rm.sum()),'candidatePixels':int(nm.sum()),'intersection':int((rm&nm).sum()),'union':int(u.sum()),'IoU':None if not u.any() else float((rm&nm).sum()/u.sum()),'valueStatus':'DESCRIPTIVE_ONLY_NOT_ACCEPTANCE','centroidDistanceDiagonal':None if not rm.any() or not nm.any() else float(np.linalg.norm(np.argwhere(rm).mean(0)-np.argwhere(nm).mean(0))/math.hypot(*mask.shape))}
 return out

def evaluate(a,b,fg,c0,c1):
 assert c0.dtype==c1.dtype==np.uint8 and c0.shape==a.shape[1:] and c1.shape==b.shape[1:]
 summary,st=E.evaluate_response_png8(a,b,fg);rn=st['numerator'].mean(0);refmask={'brightening':st['bright'],'darkening':st['dark']};pooled={'brightening':rn>T,'darkening':rn<-T};af=a.mean(0)/255;bf=b.mean(0)/255
 summary['numericContract']='Reference PNG8 and oracle PNG8 integer weighted numerator; no RGB565 candidate conversion';summary['candidateScores']={'stableSubset':metrics(af,bf,c0,c1,fg&st['stable'],rn,refmask),'uncertainSubsetDescriptiveNotAcceptance':metrics(af,bf,c0,c1,fg&st['uncertain'],rn,pooled),'pooledFullForegroundDescriptive':metrics(af,bf,c0,c1,fg,rn,pooled),'eachReferenceSeedFullForeground':[metrics(a[i]/255,b[i]/255,c0,c1,fg,st['numerator'][i],{'brightening':st['numerator'][i]>T,'darkening':st['numerator'][i]<-T}) for i in range(8)]};summary['qualityScope']='RICH_PNG8_ORACLE_DESCRIPTIVE_NOT_NATIVE_ACCEPTANCE';return summary,st

def tests():
 a=np.full((8,1,2,3),31,np.uint8);b=np.full_like(a,33);fg=np.ones((1,2),bool);s,_=evaluate(a,b,fg,a[0],b[0]);r=s['candidateScores']['stableSubset'];assert r['significantPixels']==0 and r['brightening']['candidatePixels']==0 and r['brightening']['IoU'] is None
 s,_=evaluate(b,a,fg,b[0],a[0]);r=s['candidateScores']['stableSubset'];assert r['significantPixels']==0 and r['darkening']['candidatePixels']==0
 c=np.full_like(a[0],34);s,_=evaluate(a,b,fg,a[0],c);r=s['candidateScores']['stableSubset'];assert r['brightening']['candidatePixels']==2 and r['brightening']['IoU']==0 and r['significantPixels']==2
 z0=np.array([[[246,0,78]]],np.uint8);z1=np.array([[[0,81,0]]],np.uint8);assert int(((z1.astype(np.int64)-z0.astype(np.int64))@W)[0,0])==0
 s,_=evaluate(np.repeat(z0[None],8,axis=0),np.repeat(z1[None],8,axis=0),np.ones((1,1),bool),z0,z1);r=s['candidateScores']['stableSubset'];assert r['deltaLumaRMSE']==0 and r['significantPixels']==0
 return {'integerCandidateThreshold':20000,'denominator':2550000,'positiveNegativeEqualityInactive':True,'inactiveFalsePositiveRetained':True}
