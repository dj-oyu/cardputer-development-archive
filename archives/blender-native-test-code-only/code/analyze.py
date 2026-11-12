"""Image-domain scores, independent of native shader outputs. Fixed scale, no alignment."""
import pathlib,sys,json,hashlib
import numpy as np
from PIL import Image
W,H=240,135
LUMA=np.array([.2126,.7152,.0722])
def read(p):
 a=np.asarray(Image.open(p).convert('RGB'),dtype=float)/255
 if a.shape!=(H,W,3) or not np.isfinite(a).all():raise ValueError('IMAGE_FORMAT')
 return a
def coverage(p):
 a=np.asarray(Image.open(p).convert('RGBA'));return a[:,:,3]>127
def rgb565(p):
 a=np.fromfile(p,dtype='<u2')
 if a.size!=W*H:raise ValueError('MISSING_PIXELS')
 a=a.reshape(H,W);return np.stack([(a>>11)/31,((a>>5)&63)/63,(a&31)/31],axis=-1)
def dilate(m):
 p=np.pad(m,1);return np.logical_or.reduce([p[y:y+H,x:x+W] for y in range(3) for x in range(3)])
def erode(m):return ~dilate(~m)
def metrics(a,b,mask):
 n=int(mask.sum())
 if not n:return {'status':'N/A_EMPTY_REFERENCE','pixels':0}
 diff=(a-b)[mask];y=(a@LUMA-b@LUMA)[mask]
 return {'pixels':n,'rgbMAE':float(abs(diff).mean()),'rgbRMSE':float(np.sqrt((diff*diff).mean())),'rgbAgreementPercent':float(100*(1-abs(diff).mean())),'encodedLumaMAE':float(abs(y).mean()),'encodedLumaAmplitudeReference':float(np.std((a@LUMA)[mask])),'encodedLumaAmplitudeCandidate':float(np.std((b@LUMA)[mask]))}
def geometry(a,b):
 am=a.max(2)>0;bm=b.max(2)>0
 union=am|bm
 if not am.any() or not bm.any():return {'pass':False,'reason':'EMPTY_IMAGE'}
 missing=am&~bm;extra=bm&~am
 outside=(missing|extra)&~(dilate(am)&~erode(am))
 return {'pass':not outside.any(),'referencePixels':int(am.sum()),'candidatePixels':int(bm.sum()),'missingPixels':int(missing.sum()),'extraPixels':int(extra.sum()),'outsideFixed1pxReferenceBoundary':int(outside.sum()),'silhouetteIoU':float((am&bm).sum()/union.sum())}
def response(b0,b1,c0,c1,mask):
 db=(b1-b0)@LUMA;dc=(c1-c0)@LUMA
 if not mask.any():return {'status':'N/A_EMPTY'}
 a=db[mask];b=dc[mask];na=float(np.linalg.norm(a));nb=float(np.linalg.norm(b));sig=(abs(a)>2/255)|(abs(b)>2/255)
 result={'referencePixels':int(mask.sum()),'significantPixels':int(sig.sum()),'significantCoveragePercent':float(100*sig.mean()),'deltaLumaRMSE':float(np.sqrt(np.mean((a-b)**2))),'deltaRGBRMSE':float(np.sqrt(np.mean(((b1-b0-c1+c0)[mask])**2))),'responseMagnitudeAgreementPercent':None if max(na,nb)==0 else 100*min(na,nb)/max(na,nb),'oneSideUnresponsive':bool((na==0)!=(nb==0)),'directionAgreementPercent':None if not sig.any() else float(100*np.mean(np.sign(a[sig])==np.sign(b[sig]))),'signedCorrelation':None if np.std(a)==0 or np.std(b)==0 else float(np.corrcoef(a,b)[0,1])}
 for name,sgn in [('brightening',1),('darkening',-1)]:
  ma=mask&(sgn*db>2/255);mb=mask&(sgn*dc>2/255);u=ma|mb
  result[name+'AreaIoU']=None if not u.any() else float((ma&mb).sum()/u.sum())
  result[name+'CentroidDistanceDiagonal']=None if not ma.any() or not mb.any() else float(np.linalg.norm(np.argwhere(ma).mean(0)-np.argwhere(mb).mean(0))/np.hypot(W,H))
 return result
def save(a,p):Image.fromarray(np.uint8(np.clip(a,0,1)*255+.5)).save(p)
def main(out):
 cfg=json.loads((out/'manifest.json').read_text());bm=json.loads((out/'blender-metadata.json').read_text());assert bm['cameras']==cfg['cameras'] and bm['scenarios']==cfg['scenarios'] and bm['sourceSha256']==cfg['sourceSha256'],'BLENDER_PROVENANCE'
 results=[];functional=[];responses=[];rich_results=[];rich_responses=[]
 for c in cfg['cameras']:
  v=c['name'];full=read(out/f'blender-full-{v}-unlit.png');reduced=read(out/f'blender-reduced-{v}-unlit.png');fixed=coverage(out/f'blender-full-{v}-unlit.png');reducedCoverage=coverage(out/f'blender-reduced-{v}-unlit.png');nativeCoverage=np.isfinite(np.fromfile(out/f'native-{v}-unlit.f32le',dtype='<f4').reshape(H,W));fixedUnion=fixed|nativeCoverage
  for s in cfg['scenarios']:
   name=s['name'];prefix=out/f'native-{v}-{name}';native=rgb565(str(prefix)+'.u16le');rev=rgb565(str(prefix)+'-reverse.u16le');save(native,str(prefix)+'.png')
   z=np.fromfile(str(prefix)+'.f32le',dtype='<f4').reshape(H,W);zr=np.fromfile(str(prefix)+'-reverse.f32le',dtype='<f4').reshape(H,W)
   assert not np.isnan(z).any() and not np.isposinf(z).any(),'NONFINITE_DEPTH';assert np.isfinite(z).any(),'EMPTY_DEPTH'
   f=read(out/f'blender-full-{v}-{name}.png');r=read(out/f'blender-reduced-{v}-{name}.png');union=fixedUnion;assert np.array_equal(np.isfinite(z),nativeCoverage),'LIGHTING_CHANGED_GEOMETRY'
   record={'camera':v,'parameter':name,'A_sourceToReduced':metrics(f,r,fixed),'B_reducedToNative':metrics(r,native,union),'C_sourceToNative_totalDiffuseLoss':metrics(f,native,union),'geometry':geometry(np.repeat(reducedCoverage[:,:,None],3,axis=2),np.repeat(nativeCoverage[:,:,None],3,axis=2)),'nativeCoverageMissingFromSource':int((fixed&~nativeCoverage).sum()),'nativeCoverageExtraBeyondSource':int((nativeCoverage&~fixed).sum()),'orderChangedColorPixels':int(np.any(native!=rev,axis=2).sum()),'orderChangedDepthPixels':int((z!=zr).sum())}
   if name=='unlit':
    interior=erode(reducedCoverage);errors=np.max(abs(r-native),axis=2)>10/255
    record['B_interiorBeyondRGB565TolerancePixels']=int((errors&interior).sum());record['partLoss']={}
    culled=read(out/f'blender-reduced-cull-diagnostic-{v}.png');record['diagnosticOnlyTwoSidedMismatch']={'pixelsChangedByBlenderCulling':int(np.any(r!=culled,axis=2).sum()),'interiorColorResidualAfterCulling':int(((np.max(abs(culled-native),axis=2)>10/255)&interior).sum()),'referenceUnchanged':True}
    for part,box in cfg['roi'][v].items():
     x0,y0,x1,y1=box;roi=np.zeros((H,W),bool);roi[y0:y1,x0:x1]=True;roi&=fixed
     record['partLoss'][part]=metrics(f,r,roi)|{'referenceROI':box,'changedPixelsBeyond10of255':int((np.max(abs(f-r),axis=2)[roi]>10/255).sum()),'acceptance':'UNACCEPTED authored detail loss; no aesthetic pass inferred'}
    functional.append({'gate':v+':geometry','pass':record['geometry']['pass']})
    functional.append({'gate':v+':flatColorInterior','pass':not (errors&interior).any(),'note':'fixed 10/255 allows one RGB565 red/blue quantum plus 8-bit rounding; not lighting acceptance'})
   functional.append({'gate':v+':'+name+':order','pass':record['orderChangedColorPixels']==0 and record['orderChangedDepthPixels']==0,'note':'Observation for this asset only, NOT universal order-invariance. Exact coplanar differently colored faces intentionally first-wins; near-tie correctness unresolved.'})
   save(abs(f-native),out/f'diff-total-{v}-{name}.png');save(abs(r-native),out/f'diff-renderer-{v}-{name}.png')
   results.append(record)
  b0=read(out/f'blender-reduced-{v}-baseline.png');c0=rgb565(out/f'native-{v}-baseline.u16le')
  for name in ['direction','intensity','ambient','albedo']:
   b1=read(out/f'blender-reduced-{v}-{name}.png');c1=rgb565(out/f'native-{v}-{name}.u16le');responses.append({'camera':v,'parameter':name,**response(b0,b1,c0,c1,erode(fixed))})
  rich0=read(out/f'blender-rich-{v}-baseline.png')
  for name in ['baseline','direction','intensity','ambient','albedo']:
   richcase=read(out/f'blender-rich-{v}-{name}.png');nativecase=rgb565(out/f'native-{v}-{name}.u16le')
   rich_results.append({'camera':v,'parameter':name,'fullImageTotalLoss':metrics(richcase,nativecase,np.ones((H,W),bool)),'fixedSourceForegroundLoss':metrics(richcase,nativecase,fixed),'coverageAndMeaning':'Rich original retains all fill/rim, area soft shadows, world, PBR and AgX. Native is a fixed single-directional capacity projection; these differences are not removed.'})
   save(abs(richcase-nativecase),out/f'diff-rich-{v}-{name}.png')
   if name!='baseline':rich_responses.append({'camera':v,'parameter':name,'fullImageResponse':response(rich0,richcase,c0,nativecase,np.ones((H,W),bool)),'fixedForegroundResponse':response(rich0,richcase,c0,nativecase,fixed)})
  rich=read(out/f'blender-rich-original-{v}.png');candidate=rgb565(out/f'native-{v}-baseline.u16le');save(abs(rich-candidate),out/f'diff-rich-total-{v}.png')
  results.append({'camera':v,'primaryRichOriginalToNativeFullFrame':metrics(rich,candidate,np.ones((H,W),bool)),'primaryRichOriginalToNativeForeground':metrics(rich,candidate,fixed),'interpretation':'Fixed original Cycles PBR/area lights/world/AgX vs one directional vertex diffuse: capability loss diagnostic, not matched exposure or shader. Full-frame metric includes missing background/cast shadows; foreground separately uses fixed source mask. No unsupported effect is erased from full-frame loss.'})
 report={'metricVersion':'2.0-rich-capacity-fixed','richParameterTotalLoss':rich_results,'richParameterResponses':rich_responses,'richMapping':cfg['richMapping'],'scope':'HOST ONLY; actual product a426 evaluator/compact/depth C; no device or Pocket lifecycle acceptance','negativeFixtureResults':json.loads((out/'negative-fixtures/detector-results.json').read_text()) if (out/'negative-fixtures/detector-results.json').exists() else 'NOT_RUN','functionalGates':functional,'functionalPass':all(x['pass'] for x in functional),'artQuality':'UNACCEPTED: posture/likeness and reduced eye/tail losses unresolved','records':results,'parameterResponses':responses,'maskPolicy':'Source alpha coverage and native unlit finite-depth coverage fixed for every parameter; rich primary full frame includes all extra/background/shadow differences. Separate source missing/extra counts. Black foreground is retained.','capacityMap':{'measured':['shape','base color','directional diffuse direction','RGB light intensity (achromatic sweep)','ambient','material albedo'],'productSupportedNotMeasured':['vertex specular','thin backlighting','colored-light sweep'],'unsupportedByComparedNativePath':['authored two-sided material support','Cycles area-light penumbrae','cast shadows','indirect bounce','PBR roughness response','AgX highlight rolloff'],'commonShaderScoresAre':'diagnostic only, NOT rich-expression quality'},'normalization':'Fixed RGB display-code [0,1], Y=.2126R+.7152G+.0722B, no per-image exposure/minmax/alignment. MAE average over all RGB channels and declared fixed source/union masks. Agreement=100*(1-MAE), not aggregate acceptance. Delta significance fixed 2/255. Empty/zero-response N/A. Boundary allowance fixed 1px of reference silhouette only; interior flat-color tolerance 10/255. Lighting uses Raw continuous-normal Blender diffuse vs RGB565 SNORM vertex Gouraud; quantization/interpolation difference retained.','validationCoverage':{'primary':'silhouette coverage, unlit per-pixel tolerance, per-parameter approximate scores, ownership-after-dispose, hash/provenance, NaN rejection','syntheticSensitivityOnly':'ROI MAE negatives and depth-only comparator CLI are separate sensitivity tests, not Blender depth oracle or identical primary flat-color thresholds','notImplemented':'Blender/reference depth oracle; universal near-tie correctness; Pocket JS lifecycle'},'depthCaveat':'Old auxiliary 12/36 failures at 1e-4 and near-tie uncertainty NOT resolved by this image test.'}
 (out/'report.json').write_text(json.dumps(report,indent=2,allow_nan=False))
 hashes={p.name:hashlib.sha256(p.read_bytes()).hexdigest() for p in out.iterdir() if p.suffix in ['.png','.u16le','.f32le','.json'] and p.name!='output-hashes.json'};(out/'output-hashes.json').write_text(json.dumps(hashes,indent=2))
 print(json.dumps({'functionalPass':report['functionalPass'],'failed':[x for x in functional if not x['pass']],'quality':report['artQuality']}))
if __name__=='__main__':main(pathlib.Path(sys.argv[1]))
