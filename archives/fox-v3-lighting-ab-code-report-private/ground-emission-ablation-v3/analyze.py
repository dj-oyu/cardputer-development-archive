"""Read-only paired ground-emission ablation: two seeds, no fitted energy or acceptance."""
from pathlib import Path
import hashlib, importlib.util, json, sys
import numpy as np
from PIL import Image
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent;W=R.parent
ON=W/'fox-v3-position-diagnostic/pass-decomposition';OFF=R/'run-001'
REF=W/'fox-reference-uncertainty-v3';NATIVE=W/'fox-v3-bounce/bounce-001'
LUMA=np.array([.2126,.7152,.0722]);IW=np.array([2126,7152,722],dtype=np.int64);DEN=2550000;THRESH=20000
COMPONENTS=('Combined','DirectDiffuse','IndirectDiffuse','DirectGloss','IndirectGloss','Emit','Env','RemainingResidual')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,v):p.write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
def module(name,path):
 spec=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m

def erode_chebyshev2(mask):
 p=np.pad(mask,2,constant_values=False);out=np.ones_like(mask)
 for dy in range(5):
  for dx in range(5):out &= p[dy:dy+mask.shape[0],dx:dx+mask.shape[1]]
 return out

def stats(rgb,domain):
 n=int(domain.sum())
 if not n:return {'pixels':0,'status':'NO_DOMAIN','meanSignedY':None,'meanAbsY':None}
 v=rgb[domain];y=v@LUMA
 return {'pixels':n,'meanSignedY':float(y.mean()),'meanAbsY':float(abs(y).mean()),'rmsY':float(np.sqrt(np.mean(y*y))),
         'minY':float(y.min()),'maxY':float(y.max()),'meanSignedRGB':v.mean(0).tolist(),'meanAbsRGB':abs(v).mean(0).tolist(),
         'negativeYPixels':int((y<0).sum()),'positiveYPixels':int((y>0).sum()),'nonzeroYPixels':int((y!=0).sum()),
         'negativeYFraction':float(np.mean(y<0)),'nonzeroYFraction':float(np.mean(y!=0)),
         'anyNegativeChannelPixels':int((v<0).any(1).sum()),'anyChangedChannelPixels':int((v!=0).any(1).sum()),
         'areaDefinition':'exact sign/nonzero of computed float64 differences; no denoising, clipping, threshold fit or energy rescale'}

def spread(a,b):
 if isinstance(a,dict) and isinstance(b,dict):return {k:spread(a[k],b[k]) for k in a if k in b}
 if isinstance(a,list) and isinstance(b,list) and len(a)==len(b):return [spread(x,y) for x,y in zip(a,b)]
 if type(a) in (int,float) and type(b) in (int,float):return {'seed11':a,'seed29':b,'min':min(a,b),'max':max(a,b),'range':abs(a-b),'mean':(a+b)/2}
 return None

def extract(channels):
 def rgb(name):return np.stack([channels['ViewLayer.'+name+'.'+c] for c in 'RGB'],-1).astype(np.float64)
 d={'Combined':rgb('Combined'),'DirectDiffuse':rgb('DiffDir')*rgb('DiffCol'),
    'IndirectDiffuse':rgb('DiffInd')*rgb('DiffCol'),'DirectGloss':rgb('GlossDir')*rgb('GlossCol'),
    'IndirectGloss':rgb('GlossInd')*rgb('GlossCol'),'Emit':rgb('Emit'),'Env':rgb('Env')}
 d['RemainingResidual']=d['Combined']-sum(d[k] for k in COMPONENTS[1:-1])
 d['TransmissionAndVolume']=(rgb('TransDir')+rgb('TransInd'))*rgb('TransCol')+rgb('VolumeDir')+rgb('VolumeInd')
 d['FullRecompositionResidual']=d['RemainingResidual']-d['TransmissionAndVolume']
 assert all(a.shape==(135,240,3) and np.isfinite(a).all() for a in d.values());return d

def png(path,digest):
 assert sha(path)==digest
 b=path.read_bytes();assert b[24:26]==bytes([8,6])
 im=Image.open(path);assert im.mode=='RGBA' and im.size==(240,135)
 return np.array(im)[...,:3]

def direction_masks(on0,on1,off0,off1,domain):
 on=(on1.astype(np.int64)-on0.astype(np.int64))@IW
 off=(off1.astype(np.int64)-off0.astype(np.int64))@IW
 cls=lambda d:np.where(d>THRESH,1,np.where(d < -THRESH,-1,0))
 a,b=cls(on),cls(off);n=int(domain.sum());sig=domain&((a!=0)|(b!=0))
 confusion={f'ON{x}_OFF{y}':int((domain&(a==x)&(b==y)).sum()) for x in (-1,0,1) for y in (-1,0,1)}
 out={'pixels':n,'thresholdNumerator':THRESH,'denominator':DEN,'equalityInactive':True,
      'ONcounts':{str(x):int((domain&(a==x)).sum()) for x in (-1,0,1)},
      'OFFcounts':{str(x):int((domain&(b==x)).sum()) for x in (-1,0,1)},'classTransitionCounts':confusion,
      'changedClassPixels':int((domain&(a!=b)).sum()),'significantPixels':int(sig.sum()),
      'classAgreementAmongEitherActivePercent':100*float(np.mean(a[sig]==b[sig])) if sig.any() else None,
      'directionEffectMeanSignedY':float(((on-off)[domain]/DEN).mean()) if n else None,
      'directionEffectMeanAbsY':float(abs((on-off)[domain]/DEN).mean()) if n else None,
      'directionEffectRMSEY':float(np.sqrt(np.mean(((on-off)[domain]/DEN)**2))) if n else None,
      'status':'PAIRED_TWO_SEED_DESCRIPTIVE_NOT_REFERENCE_STABILITY_OR_ACCEPTANCE'}
 for label,value in [('bright',1),('dark',-1)]:
  aa=domain&(a==value);bb=domain&(b==value);union=int((aa|bb).sum())
  out[label]={'onPixels':int(aa.sum()),'offPixels':int(bb.sum()),'intersection':int((aa&bb).sum()),'union':union,
              'IoU':int((aa&bb).sum())/union if union else None,'lostWhenOff':int((aa&~bb).sum()),'gainedWhenOff':int((bb&~aa).sum())}
 return out,a,b,on-off

def main():
 if len(sys.argv)!=3 or sys.argv[2]!='--off-render-complete':raise SystemExit('Usage: analyze.py FRESH_OUTPUT --off-render-complete')
 completed=json.loads((OFF/'COMPLETED.json').read_text());on_done=json.loads((ON/'COMPLETED.json').read_text())
 # Renderer owns completion/control audit; do not analyze partial images.
 assert len(completed['images'])==8
 assert all(completed.get(k) is True for k in ('onControlPassed','allONControlEXRChannelsBitExact','inputsUnchanged','sourceUnchanged'))
 assert (OFF/'ON_CONTROL_PASS.json').is_file()
 D=Path(sys.argv[1]).resolve();assert D.parent==R and not D.exists();D.mkdir()
 sources={Path(__file__),ON/'exr_io.py',W/'fox-v3-position-diagnostic/rich-oracle/oracle_response.py'}
 for root in (ON,OFF,REF,NATIVE):sources.update(p for p in root.rglob('*') if p.is_file() and '__pycache__' not in p.parts)
 sources.update(p for p in R.iterdir() if p.is_file())
 hashes={str(p):sha(p) for p in sorted(sources)};save(D/'input-hashes-before.json',hashes)
 X=module('frozen_exr_io',ON/'exr_io.py')
 lookups={arm:{(r['seed'],r['view'],r['case']):r for r in done['images']} for arm,done in [('ON',on_done),('OFF',completed)]}
 wanted={(s,v,c) for s in (11,29) for v in ('front','oblique') for c in ('baseline','direction')}
 assert all(set(l)==wanted for l in lookups.values())
 rm=json.loads((REF/'render-manifest.json').read_text());results={};domain_counts={}
 for view in ('front','oblique'):
  f=rm['foreground'][view];assert sha(REF/f['file'])==f['sha256'];fg=np.array(Image.open(REF/f['file']))[...,3]>0
  depths=[np.fromfile(NATIVE/f'native-{view}-{c}.f32le',dtype='<f4').reshape(135,240) for c in ('baseline','direction')]
  assert all(np.all(np.isfinite(d)|np.isneginf(d)) for d in depths)
  assert np.array_equal(np.isfinite(depths[0]),np.isfinite(depths[1])),'native coverage differs by condition'
  common=fg&np.isfinite(depths[0]);domains={'originalV3Foreground':fg,'commonNativeFiniteDepth':common,'chebyshev2InteriorCommon':erode_chebyshev2(common)}
  np.savez_compressed(D/f'{view}-domains.npz',**domains)
  domain_counts[view]={name:int(mask.sum()) for name,mask in domains.items()};results[view]={}
  for seed in (11,29):
   passes={};imgs={};effects={};case_stats={}
   for case in ('baseline','direction'):
    for arm,root in [('ON',ON),('OFF',OFF)]:
     row=lookups[arm][(seed,view,case)]
     if arm=='OFF':assert sha(root/row['audit'])==row['auditSHA256']
     path=root/row['EXR'];assert sha(path)==row['EXRSHA256']
     passes[(arm,case)]=extract(X.read(path));imgs[(arm,case)]=png(root/row['combinedPNG'],row['combinedPNGSHA256'])
    effects[case]={k:passes[('ON',case)][k]-passes[('OFF',case)][k] for k in passes[('ON',case)]}
    case_stats[case]={name:{k:stats(a,mask) for k,a in effects[case].items()} for name,mask in domains.items()}
    case_stats[case]['displayPNG8Effect']={name:stats((imgs[('ON',case)].astype(float)-imgs[('OFF',case)].astype(float))/255,mask) for name,mask in domains.items()}
    np.savez_compressed(D/f'seed-{seed}-{view}-{case}-signed-effects.npz',**effects[case])
   linear_interaction={k:effects['direction'][k]-effects['baseline'][k] for k in effects['baseline']}
   interaction_stats={name:{k:stats(a,mask) for k,a in linear_interaction.items()} for name,mask in domains.items()}
   # Cross-case floor contribution estimate need not be exactly equal under two finite Monte Carlo samples.
   display={};mask_arrays={}
   for name,mask in domains.items():
    out,a,b,d=direction_masks(imgs[('ON','baseline')],imgs[('ON','direction')],imgs[('OFF','baseline')],imgs[('OFF','direction')],mask)
    display[name]=out;mask_arrays.update({name+'-ON':np.where(mask,a,127).astype(np.int8),name+'-OFF':np.where(mask,b,127).astype(np.int8)})
   np.savez_compressed(D/f'seed-{seed}-{view}-direction-masks.npz',**mask_arrays)
   np.savez_compressed(D/f'seed-{seed}-{view}-linear-interaction.npz',**linear_interaction)
   results[view][str(seed)]={'pairedONminusOFF':case_stats,'directionMinusBaselineOfONminusOFF':interaction_stats,'pairedPNG8Direction':display}
 spreads={v:spread(results[v]['11'],results[v]['29']) for v in results}
 assert all(sha(Path(p))==h for p,h in hashes.items()),'INPUT_CHANGED'
 save(D/'input-hashes-after.json',{p:sha(Path(p)) for p in hashes});save(D/'analysis.json',results);save(D/'two-seed-spread.json',spreads)
 save(D/'scope.json',{'seeds':[11,29],'noCI':True,'noAcceptance':True,'noNewStableMask':True,'noEnergyFitOrNegativeClipping':True,
      'domains':domain_counts,'domainDefinition':'Original frozen v3 alpha>0; common=foreground AND unchanged native baseline/direction finite-depth mask; interior is radius2 Chebyshev binary erosion of common (all 25 neighbors required, outside frame false). Fixed across arms/seeds/cases.',
      'remainingResidualDefinition':'Combined minus DirectDiffuse, IndirectDiffuse, DirectGloss, IndirectGloss, Emit and Env. Includes transmission/volume and recomposition error. Those two parts are also reported separately.',
      'linearInteraction':'(ON_direction−OFF_direction)−(ON_baseline−OFF_baseline), kept signed; no display transform or energy rescale.',
      'displayScope':'Original Combined PNG8 ON vs OFF, same seed; exact integer luma +/-20000 with denominator2550000. Each seed separately, no 8-seed stability inference.',
      'interpretation':'Emission source term is fixed. In linear light transport through an unchanged scene, its expected contribution is independent of other light direction. Finite Monte Carlo/adaptive/MIS sampling can create estimated interaction; 2 seeds cannot establish exact invariance or a causal error source. AgX/nonlinear display response can change even when a linear contribution is constant.',
      'ablationNotLightGroupIsolation':'ON−OFF is a paired rerender difference including path/MIS/MC changes; it is not a directly isolated emission light-group value from one render.',
      'foregroundCaveat':'Original foreground may include edge/native-missing pixels where floor emission is directly visible. Emit differences are not automatically illumination of character surfaces; inspect Emit alongside common/interior domains. No part-whole ratio establishes native repair.',
      'richPixelsNeverNativeInputs':True,'inputsUnchanged':True})
 lines=['# Ground emission-only paired ablation','','Two seeds (11, 29), front/oblique × baseline/direction. Signed ON−OFF linear effects are retained without clipping or energy fit. No confidence interval, new stability mask, acceptance, or native input modification.','',
        '| View / seed / case | FG signed mean Y | FG mean abs Y | Common signed mean Y | Interior signed mean Y |','|---|---:|---:|---:|---:|']
 for v in results:
  for seed in ('11','29'):
   for c in ('baseline','direction'):
    q=results[v][seed]['pairedONminusOFF'][c]
    vals=[q['originalV3Foreground']['Combined']['meanSignedY'],q['originalV3Foreground']['Combined']['meanAbsY'],q['commonNativeFiniteDepth']['Combined']['meanSignedY'],q['chebyshev2InteriorCommon']['Combined']['meanSignedY']]
    lines.append('| '+v+'/'+seed+'/'+c+' | '+' | '.join(f'{x:.8f}' for x in vals)+' |')
 lines+=['','## Does estimated floor contribution change with direction?','','| View / seed | FG interaction signed Y | FG interaction abs Y | Interior interaction signed Y | Interior interaction abs Y | PNG direction-effect RMSE Y (FG) |','|---|---:|---:|---:|---:|---:|']
 for v in results:
  for seed in ('11','29'):
   r=results[v][seed];q=r['directionMinusBaselineOfONminusOFF'];vals=[q['originalV3Foreground']['Combined']['meanSignedY'],q['originalV3Foreground']['Combined']['meanAbsY'],q['chebyshev2InteriorCommon']['Combined']['meanSignedY'],q['chebyshev2InteriorCommon']['Combined']['meanAbsY'],r['pairedPNG8Direction']['originalV3Foreground']['directionEffectRMSEY']]
   lines.append('| '+v+'/'+seed+' | '+' | '.join(f'{x:.8f}' for x in vals)+' |')
 lines+=['','ON−OFF is a paired rerender difference including path/MIS/Monte Carlo changes, not a directly isolated emission light-group contribution from a single render. Emission is fixed at the source. Expected linear transport from that source should not depend on another light direction when geometry/materials stay fixed. Observed two-seed difference-of-differences is an estimator diagnostic, not proof of a physical dependence: Monte Carlo, adaptive sampling and MIS changes are not causally separated. Nonlinear AgX display response may change even with constant additive linear radiance.','',
        'analysis.json contains all signed components, positive/negative/nonzero area, RGB/Y moments, cross-case interactions and integer-PNG direction transitions for each fixed domain. two-seed-spread.json gives descriptive min/max/range, never a CI. RemainingResidual includes transmission/volume plus recomposition error; both are separately recorded.','',
        'Original foreground includes boundary/native-missing pixels that can expose the floor directly. Emit differences must not be confused with character illumination; inspect Emit and common/interior domains separately. No component-to-Combined fraction establishes native repair rate.',
        'Native common coverage is only an analysis domain, never a replacement reference or input to native rendering. Radius2 interior removes all common-mask pixels lacking any of 25 Chebyshev neighbors. Display direction masks are per-seed ON/OFF classifications, not reference stable masks.','']
 (D/'REPORT.md').write_text('\n'.join(lines));save(D/'output-hashes.json',{p.name:sha(p) for p in sorted(D.iterdir()) if p.is_file() and p.name not in ('output-hashes.json','COMPLETED.json')})
 save(D/'COMPLETED.json',{'status':'TWO_SEED_PAIRED_ANALYSIS_NO_ACCEPTANCE','inputsUnchanged':True,'nativeInputUnmodified':True});print('\n'.join(lines[:15]))
if __name__=='__main__':main()
