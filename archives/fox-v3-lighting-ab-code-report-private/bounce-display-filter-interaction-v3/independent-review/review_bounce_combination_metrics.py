import pathlib,json,hashlib,math,sys
import numpy as np
from PIL import Image
ROOT=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');R=ROOT/'fox-v3-bounce-combination';REF=ROOT/'fox-reference-uncertainty-v3';D=pathlib.Path(sys.argv[1]) if len(sys.argv)>1 else R/'postprocess-002'
S=[11,29,47,71,101,131,173,211];V=['front','oblique'];C=['baseline','direction'];ARMS=['point-off','point-on','filter3-off','filter3-on'];WI=np.array([2126,7152,722]);W=np.array([.2126,.7152,.0722]);T=2/255;TC=2.3646242515927844
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();numeric=0;counts=0;checked_contrast=0;regressions=[];summary={};filehashes={}
def load(p): return json.loads(p.read_text())
def ck(got,exp,label):
 global numeric
 if exp is None:assert got is None,(label,got,exp)
 elif isinstance(exp,(bool,str)):assert got==exp,(label,got,exp)
 else:assert math.isclose(got,exp,rel_tol=3e-13,abs_tol=3e-13),(label,got,exp)
 numeric+=1

def rgb(p):
 assert p.stat().st_size==64800;u=np.fromfile(p,'<u2').astype(np.uint32).reshape(135,240);filehashes[str(p)]=sha(p)
 return np.stack([(u//2048)%32/31,(u//32)%64/63,u%32/31],-1)

def color_score(got,mask,ref,native,label):
 ck(got['pixels'],int(mask.sum()),label+'pixels');delta=(ref-native)[mask]
 if not mask.any():
  for k in ['rgbMAE','rgbRMSE','rgbAgreementPercent']:ck(got[k],None,label+k)
 else:
  mae=float(np.sum(abs(delta))/delta.size);ck(got['rgbMAE'],mae,label+'mae');ck(got['rgbRMSE'],float(np.sqrt(np.sum(delta*delta)/delta.size)),label+'rmse');ck(got['rgbAgreementPercent'],100*(1-mae),label+'agreement')

def response_score(got,mask,dr,drgb,dn,dnrgb,refbright,refdark,label):
 ck(got['pixels'],int(mask.sum()),label+'pixels');a=dr[mask];b=dn[mask];na=math.sqrt(float(np.sum(a*a)));nb=math.sqrt(float(np.sum(b*b)));sig=(abs(a)>T)|(abs(b)>T)
 ck(got['significantPixels'],int(sig.sum()),label+'significant');ck(got['deltaLumaRMSE'],math.sqrt(float(np.mean((a-b)**2))) if len(a) else None,label+'YRMSE');ck(got['deltaRGBRMSE'],math.sqrt(float(np.mean(((drgb-dnrgb)[mask])**2))) if len(a) else None,label+'RGBRMSE')
 ck(got['responseMagnitudeAgreementPercent'],None if max(na,nb)==0 else 100*min(na,nb)/max(na,nb),label+'amplitude');ck(got['directionAgreementPercent'],None if not sig.any() else 100*np.count_nonzero(np.sign(a[sig])==np.sign(b[sig]))/np.count_nonzero(sig),label+'sign')
 corr=None if not len(a) or np.ptp(a)==0 or np.ptp(b)==0 else float(np.sum((a-a.mean())*(b-b.mean()))/np.sqrt(np.sum((a-a.mean())**2)*np.sum((b-b.mean())**2)))
 ck(got['signedCorrelation'],corr,label+'correlation');ck(got['oneSideUnresponsive'],bool((na==0)!=(nb==0)),label+'oneSide')
 for name,rb,sgn in [('brightening',refbright,1),('darkening',refdark,-1)]:
  refm=mask&rb;natm=mask&(sgn*dn>T);tp=int((refm&natm).sum());union=int((refm|natm).sum());g=got[name]
  for k,e in [('intersection',tp),('union',union),('referencePixels',int(refm.sum())),('candidatePixels',int(natm.sum()))]:ck(g[k],e,label+name+k)
  ck(g['IoU'],None if union==0 else tp/union,label+name+'IoU');cent=None if not refm.any() or not natm.any() else float(np.linalg.norm(np.argwhere(refm).mean(0)-np.argwhere(natm).mean(0))/math.hypot(*mask.shape));ck(g['centroidDistanceDiagonal'],cent,label+name+'centroid')

def status(got,accept,label):
 if isinstance(got,dict):
  for k,v in got.items():
   if 'Status' in k and isinstance(v,str):
    if not accept:assert 'MEETS_60' not in v and 'PASS' not in v,(label,k,v)
   status(v,accept,label+'.'+k)
 elif isinstance(got,list):
  for x in got:status(x,accept,label)

complete=load(D/'COMPLETED.json');assert complete['status']=='DIAGNOSTIC_COMPLETE_NOT_ACCEPTANCE' and complete['pointOffExact'] and complete['inputsUnchanged'] and complete['arms']==4 and complete['colorCasesPerArm']==4 and complete['responseCasesPerArm']==2
outputhashes=load(D/'output-hashes.json');assert all(sha(D/n)==h for n,h in outputhashes.items());before=load(D/'input-hashes-before.json');after=load(D/'input-hashes-after.json');assert before==after;assert sha(R/'postprocess.py')==before[str(R/'postprocess.py')]
# All three fixed reference roots and the original 8-seed config remain pinned.
pins=load(ROOT/'fox-v3-bounce/scoring/reference-pins.json');assert all(sha(REF/n)==h for n,h in pins['files'].items())
assert sha(REF/'input/config.json')=='4a9d836a4dae2fc570f5f0fb99690ab0f13fbe394589f785b56e891e0573dc40';assert sha(REF/'execution-freeze.json')=='345e096db5211ec3943b052ce243c3dab2cc1a32879a3b3aec799c62db2641f4'
e=load(D/'evaluation.json');contrasts=load(D/'contrasts.json');interaction=load(D/'interaction.json');support=load(D/'support.json');scope=load(D/'scope.json');cost=load(D/'cost.json');assert set(e)==set(V) and len(cost)==16;assert scope['globalAcceptance']=='NOT_ESTABLISHED' and scope['sixtyPercentGoal']=='NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY' and scope['selectionMade'] is False and scope['pngDither1Implemented'] is False and scope['filterBeforeDisplay'] and scope['fourCasesOnly'] and scope['twoDirectionResponsesOnly']
manifest=load(REF/'render-manifest.json');rl={(row['seed'],row['view'],row['case']):row for row in manifest['images']};ref={};fg={};nat={};summaries={};mask_counts={}
for v in V:
 row=manifest['foreground'][v];assert sha(REF/row['file'])==row['sha256'];fg[v]=np.asarray(Image.open(REF/row['file']))[...,3]>0;assert set(e[v])==set(ARMS);summaries[v]={};mask_counts[v]={}
 for c in C:
  rows=[rl[(s,v,c)] for s in S];assert all(sha(REF/x['file'])==x['sha256'] for x in rows);ref[(v,c)]=np.stack([np.asarray(Image.open(REF/x['file']))[...,:3] for x in rows]).astype(np.int64)
  depth=np.fromfile(R/'run-001'/f'native-{v}-{c}.f32le','<f4').reshape(135,240);cov=np.isfinite(depth);assert not np.isnan(depth).any() and not np.isposinf(depth).any()
  expanded=np.lib.stride_tricks.sliding_window_view(np.pad(cov,1), (3,3)).any((-1,-2));z=np.load(D/f'{v}-{c}-support.npz');assert np.array_equal(z['original'],cov) and np.array_equal(z['filtered'],expanded)
  for name,mask in [('original',cov),('filtered',expanded)]:
   inter=int((fg[v]&mask).sum());union=int((fg[v]|mask).sum());expected={'sourcePixels':int(fg[v].sum()),'supportPixels':int(mask.sum()),'intersection':inter,'union':union,'missingPixels':int((fg[v]&~mask).sum()),'extraPixels':int((mask&~fg[v]).sum()),'IoU':inter/union if union else None,'status':'DESCRIPTIVE_SUPPORT_NOT_GEOMETRY_IMPROVEMENT'}
   assert support[v][c][name]==expected
  ck(support[v][c]['expandedSupportPixels'],int((expanded&~cov).sum()),v+c+'expanded')
  for a in ARMS:
   p=D/f'{a}-{v}-{c}.u16le';nat[(v,a,c)]=rgb(p);mask=cov if a.startswith('point') else expanded;assert np.all(nat[(v,a,c)][~mask]==0)
   if a=='point-off':assert p.read_bytes()==(ROOT/'fox-v3-bounce/bounce-001'/f'native-{v}-{c}.u16le').read_bytes()
  a8=ref[(v,c)];su=a8.sum(0);hw=TC*np.sqrt((8*(a8*a8).sum(0)-su*su)/448)/255;st=fg[v]&(hw<=T).all(-1);un=fg[v]&~st;fixed=np.load(REF/f'evaluation-masks/{v}-{c}-color.npz');assert np.array_equal(st,fg[v]&fixed['stable']);mask_counts[v][c+'Color']={'stable':int(st.sum()),'uncertain':int(un.sum())}
  for a in ARMS:
   col=e[v][a]['color'][c];assert col['counts']==mask_counts[v][c+'Color'];assert col['uncertainLocationsYX']==np.argwhere(un).tolist();ck(col['foregroundPixels'],int(fg[v].sum()),v+a+c+'fg');ck(col['stableCoverageFraction'],st.sum()/fg[v].sum(),v+a+c+'stableCoverage');ck(col['uncertainCoverageFraction'],un.sum()/fg[v].sum(),v+a+c+'unknownCoverage');assert col['coverageWarningIsAcceptanceGate'] is False and col['qualityScope']=='CONDITIONAL_SCORES_NOT_GLOBAL_ACCEPTANCE'
   for name,mask in [('stableSubset',st),('uncertainSubsetDescriptiveNotAcceptance',un),('pooledFullForegroundDescriptive',fg[v])]:color_score(col['candidateScores'][name],mask,su/8/255,nat[(v,a,c)],v+a+c+name);status(col['candidateScores'][name],name=='stableSubset',v+a+c+name)
   for i,s in enumerate(S):color_score(col['candidateScores']['eachReferenceSeedFullForeground'][i],fg[v],a8[i]/255,nat[(v,a,c)],v+a+c+str(s));status(col['candidateScores']['eachReferenceSeedFullForeground'][i],False,v+a+c+str(s))
 # Reference classification computed using integer sums, not candidate-based support.
 drgb=ref[(v,'direction')]-ref[(v,'baseline')];num=drgb@WI;su=num.sum(0);mu=su/8;half=TC*np.sqrt((8*(num*num).sum(0)-su*su)/448);b=(num>20000).all(0)&(mu-half>20000);d=(num< -20000).all(0)&(mu+half < -20000);i=(abs(num)<=20000).all(0)&(mu-half>=-20000)&(mu+half<=20000);st=b|d|i;un=~st;ct={k:int((fg[v]&m).sum()) for k,m in [('bright',b),('dark',d),('inactive',i),('stable',st),('uncertain',un)]};mask_counts[v]['response']=ct
 for a in ARMS:
  res=e[v][a]['response'];assert res['counts']==ct and res['uncertainLocationsYX']==np.argwhere(fg[v]&un).tolist();assert res['coverageWarningIsAcceptanceGate'] is False and res['qualityScope']=='CONDITIONAL_SCORES_NOT_GLOBAL_ACCEPTANCE';ck(res['foregroundPixels'],int(fg[v].sum()),v+a+'fg');ck(res['stableCoverageFraction'],ct['stable']/fg[v].sum(),v+a+'stableCov');ck(res['uncertainCoverageFraction'],ct['uncertain']/fg[v].sum(),v+a+'unknownCov')
  for name,active in [('brightening',num>20000),('darkening',num< -20000)]:
   ever=fg[v]&active.any(0);got=res[name+'EverObservedCoverage'];ck(got['everObservedPixels'],int(ever.sum()),v+a+name+'ever');ck(got['stablePixelsWithinEverObserved'],int((ever&(b if name=='brightening' else d)).sum()),v+a+name+'within');ck(got['stableFraction'],int((ever&(b if name=='brightening' else d)).sum())/ever.sum() if ever.any() else None,v+a+name+'fraction')
  # Exact sign frequency locations are reference-only and should be invariant across arms.
  assert res['uncertainSignFrequencyAtLocations']==e[v]['point-off']['response']['uncertainSignFrequencyAtLocations']
  for g,(y,x) in zip(res['uncertainSignFrequencyAtLocations'],np.argwhere(fg[v]&un)):
   ex={'y':int(y),'x':int(x),'bright':float((num[:,y,x]>20000).mean()),'dark':float((num[:,y,x]<-20000).mean()),'meanDelta':float(mu[y,x]/2550000),'lower':float((mu[y,x]-half[y,x])/2550000),'upper':float((mu[y,x]+half[y,x])/2550000)}
   assert set(g)==set(ex) and all(math.isclose(g[k],val,rel_tol=3e-13,abs_tol=3e-13) for k,val in ex.items()),(v,a,g,ex)
  delta=nat[(v,a,'direction')]-nat[(v,a,'baseline')];dn=delta@W;meany=su/8/2550000;meanrgb=drgb.sum(0)/8/255
  for name,mask in [('stableSubset',fg[v]&st),('uncertainSubsetDescriptiveNotAcceptance',fg[v]&un),('pooledFullForegroundDescriptive',fg[v])]:response_score(res['candidateScores'][name],mask,meany,meanrgb,dn,delta,b if name=='stableSubset' else su>160000,d if name=='stableSubset' else su< -160000,v+a+name);status(res['candidateScores'][name],name=='stableSubset',v+a+name)
  for idx,s in enumerate(S):response_score(res['candidateScores']['eachReferenceSeedFullForeground'][idx],fg[v],num[idx]/2550000,drgb[idx]/255,dn,delta,num[idx]>20000,num[idx]< -20000,v+a+str(s));status(res['candidateScores']['eachReferenceSeedFullForeground'][idx],False,v+a+str(s))
  ib=int((fg[v]&i&(dn>T)).sum());idd=int((fg[v]&i&(dn< -T)).sum());assert e[v][a]['inactiveFalsePositives']=={'inactivePixels':ct['inactive'],'bright':ib,'dark':idd,'total':ib+idd}
  r=res['candidateScores']['stableSubset'];summaries[v][a]={'rgbStable':{c:e[v][a]['color'][c]['candidateScores']['stableSubset']['rgbAgreementPercent'] for c in C},'rgbFullForeground':{c:e[v][a]['color'][c]['candidateScores']['pooledFullForegroundDescriptive']['rgbAgreementPercent'] for c in C},'brightIoU':r['brightening']['IoU'],'darkIoU':r['darkening']['IoU'],'signPercent':r['directionAgreementPercent'],'lumaRMSE':r['deltaLumaRMSE'],'rgbRMSE':r['deltaRGBRMSE'],'magnitudePercent':r['responseMagnitudeAgreementPercent'],'inactiveFalsePositives':ib+idd}
# Verify arithmetic at every corresponding JSON leaf, not just selected stable metrics.
def compare_tree(got,terms,path):
 global checked_contrast
 first=terms[0][1]
 if isinstance(first,dict):
  assert isinstance(got,dict) and set(got)==set(first),path
  for k in first:compare_tree(got[k],[(s,x[k]) for s,x in terms],path+'/'+k)
 elif isinstance(first,list):
  assert isinstance(got,list) and len(got)==len(first),path
  for k in range(len(first)):compare_tree(got[k],[(s,x[k]) for s,x in terms],path+f'/{k}')
 elif all(type(x) in (int,float) for _,x in terms):
  exp=math.fsum(s*x for s,x in terms);ck(got,exp,path);checked_contrast+=1
 else:assert got is None,(path,got)
pairs={'profileAtPoint':('point-on','point-off'),'profileAtFilter3':('filter3-on','filter3-off'),'filterAtProfileOff':('filter3-off','point-off'),'filterAtProfileOn':('filter3-on','point-on')}
for v in V:
 for label,(to,fr) in pairs.items():compare_tree(contrasts[v][label],[(1,e[v][to]),(-1,e[v][fr])],v+'/'+label)
 compare_tree(interaction[v],[(1,e[v]['filter3-on']),(-1,e[v]['filter3-off']),(-1,e[v]['point-on']),(1,e[v]['point-off'])],v+'/interaction')
 for label,(to,fr) in pairs.items():
  for c in C:
   for domain in ['stableSubset','uncertainSubsetDescriptiveNotAcceptance','pooledFullForegroundDescriptive']:
    x=e[v][fr]['color'][c]['candidateScores'][domain]['rgbAgreementPercent'];y=e[v][to]['color'][c]['candidateScores'][domain]['rgbAgreementPercent']
    if y<x:regressions.append({'view':v,'contrast':label,'case':c,'domain':domain,'metric':'rgbAgreementPercent','from':x,'to':y,'change':y-x})
  for domain in ['stableSubset','uncertainSubsetDescriptiveNotAcceptance','pooledFullForegroundDescriptive']:
   for metric,low in [('deltaLumaRMSE',True),('deltaRGBRMSE',True),('responseMagnitudeAgreementPercent',False),('directionAgreementPercent',False),('signedCorrelation',False)]:
    x=e[v][fr]['response']['candidateScores'][domain][metric];y=e[v][to]['response']['candidateScores'][domain][metric]
    if x is not None and y is not None and ((y>x) if low else (y<x)):regressions.append({'view':v,'contrast':label,'case':'direction','domain':domain,'metric':metric,'from':x,'to':y,'change':y-x})
   for cls in ['brightening','darkening']:
    x=e[v][fr]['response']['candidateScores'][domain][cls]['IoU'];y=e[v][to]['response']['candidateScores'][domain][cls]['IoU']
    if x is not None and y is not None and y<x:regressions.append({'view':v,'contrast':label,'case':'direction','domain':domain,'metric':cls+'IoU','from':x,'to':y,'change':y-x})
  x=e[v][fr]['inactiveFalsePositives']['total'];y=e[v][to]['inactiveFalsePositives']['total']
  if y>x:regressions.append({'view':v,'contrast':label,'case':'direction','domain':'stableInactive','metric':'falsePositives','from':x,'to':y,'change':y-x})

allmetricregressions=[]
higher={'rgbAgreementPercent','responseMagnitudeAgreementPercent','directionAgreementPercent','signedCorrelation','IoU'};lower={'rgbMAE','rgbRMSE','deltaLumaRMSE','deltaRGBRMSE','centroidDistanceDiagonal'}
def walk_metrics(before,after,path):
 if isinstance(before,dict):
  for k in before:walk_metrics(before[k],after[k],path+'/'+k)
 elif isinstance(before,list):
  for k in range(len(before)):walk_metrics(before[k],after[k],path+'/'+str(k))
 elif type(before) in (int,float) and type(after) in (int,float):
  name=path.rsplit('/',1)[-1]
  if (name in higher and after<before) or (name in lower and after>before):allmetricregressions.append({'path':path,'from':before,'to':after,'change':after-before})
for v in V:
 for label,(to,fr) in pairs.items():walk_metrics(e[v][fr],e[v][to],v+'/'+label)
for name in ['evaluation.json','interaction.json','contrasts.json','support.json','filter.json']+[f'{a}-{v}-{c}.u16le' for a in ARMS for v in V for c in C]:assert (D/name).read_bytes()==(R/'postprocess-001'/name).read_bytes()

assert all(sha(D/n)==h for n,h in outputhashes.items()),'Output changed during audit'
report={'output':str(D),'codeSHA256':sha(R/'postprocess.py'),'evaluationSHA256':sha(D/'evaluation.json'),'numericChecks':numeric,'contrastAndInteractionScalarChecks':checked_contrast,'metricsOnlyChecks':numeric-checked_contrast,'all16RawRGB565DirectDecode':True,'fixedReferenceMasksRecomputed':True,'depthUnionSupportAndBlackOutsideSupportChecked':True,'pointOff4ExactBounce001':True,'uncertainNotAcceptance':True,'globalAcceptance':'NOT_ESTABLISHED','limitedScope':'Four colors/two direction responses only. No full-five-condition goal, causal share, interaction significance, device-fit, or subpixel/convergence inference.','maskCounts':mask_counts,'results':summaries,'support':support,'regressions':regressions,'allMetricRegressionsIncludingEachSeed':allmetricregressions,'output001and002AllNumericAnd16ImageBytesExact':True,'declaredInputHashSnapshotsEqual':True,'pinnedReferenceAndAllOutputHashesVerified':True,'rawOutputHashes':filehashes}
p=pathlib.Path('/tmp/bounce-combination-independent-review.json');p.write_text(json.dumps(report,indent=2));print('BOUNCE_COMBINATION_INDEPENDENT_PASS',numeric,'METRICS',numeric-checked_contrast,'CONTRASTS',checked_contrast);print(json.dumps(summaries,indent=2));print('REGRESSIONS',json.dumps(regressions,indent=2));print('OUTPUT',p)
