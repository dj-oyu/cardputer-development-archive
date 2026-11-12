"""Reference-only observed-stability masks, with explicit conditional scoring.
No image generation, implicit foreground, threshold fitting, or NaN imputation.
"""
from __future__ import annotations
import hashlib, json, math
from pathlib import Path
import numpy as np

ROOT=Path(__file__).resolve().parents[1]
PLAN=json.loads((ROOT/'plan.json').read_text())
FREEZE=json.loads((ROOT/'plan-freeze.json').read_text())
for _name,_hash in FREEZE['files'].items():
    if hashlib.sha256((ROOT/_name).read_bytes()).hexdigest()!=_hash:
        raise ValueError('FROZEN_PLAN_HASH_MISMATCH: '+_name)
for _name,_hash in json.loads((ROOT/'numeric-freeze.json').read_text())['files'].items():
    if hashlib.sha256((ROOT/_name).read_bytes()).hexdigest()!=_hash:raise ValueError('NUMERIC_CONTRACT_HASH_MISMATCH')
N=8
T=2.0/255.0
T_CRIT=2.3646242515927844  # Student t, df7, p=.975; fixed before reference samples
LUMA=np.array([.2126,.7152,.0722],dtype=np.float64)
if PLAN['repetitions']!=N or PLAN['threshold']!=T:
    raise ValueError('PLAN_IMPLEMENTATION_MISMATCH')

def _numeric(a, name):
    a=np.asarray(a)
    if not np.issubdtype(a.dtype,np.number) or np.issubdtype(a.dtype,np.complexfloating):
        raise ValueError(name+': expected real numeric values')
    a=a.astype(np.float64)
    if not np.isfinite(a).all(): raise ValueError(name+': nonfinite values')
    return a

def _reference(a,name):
    a=_numeric(a,name)
    if a.ndim!=4 or a.shape[0]!=N or a.shape[-1]!=3 or not all(a.shape[1:3]):
        raise ValueError(name+': required [8,H,W,3]')
    if a.min()<0 or a.max()>1:raise ValueError(name+': expected encoded RGB in [0,1]')
    return a

def _candidate(a,shape,name):
    a=_numeric(a,name)
    if a.shape!=shape:raise ValueError(name+': shape mismatch')
    if a.min()<0 or a.max()>1:raise ValueError(name+': expected encoded RGB in [0,1]')
    return a

def _foreground(a,shape):
    a=np.asarray(a)
    if a.dtype!=np.bool_ or a.shape!=shape:raise ValueError('foreground: explicit bool[H,W] required')
    return a

def mean_interval(samples):
    samples=_numeric(samples,'samples')
    if samples.ndim<1 or samples.shape[0]!=N:raise ValueError('exactly eight repetitions required')
    mean=np.mean(samples,axis=0)
    sd=np.std(samples,axis=0,ddof=1)
    half=T_CRIT*sd/math.sqrt(N)
    return {'mean':mean,'sampleStd':sd,'halfWidth':half,'lower':mean-half,'upper':mean+half}

def classify_deltas(deltas):
    """Values are paired per-seed encoded-Y deltas, not HDR."""
    d=_numeric(deltas,'deltas')
    if d.ndim!=3 or d.shape[0]!=N or not all(d.shape[1:]):raise ValueError('required [8,H,W] deltas')
    if d.min() < -1 or d.max()>1:raise ValueError('delta outside encoded-Y range')
    ci=mean_interval(d)
    bright=np.all(d>T,axis=0)&(ci['lower']>T)
    dark=np.all(d<-T,axis=0)&(ci['upper']<-T)
    inactive=np.all((d>=-T)&(d<=T),axis=0)&(ci['lower']>=-T)&(ci['upper']<=T)
    stable=bright|dark|inactive
    if np.any(bright&dark) or np.any(bright&inactive) or np.any(dark&inactive):raise AssertionError('overlap')
    return {**ci,'bright':bright,'dark':dark,'inactive':inactive,'stable':stable,'uncertain':~stable,
            'brightFrequency':np.mean(d>T,axis=0),'darkFrequency':np.mean(d<-T,axis=0),
            'observedMin':np.min(d,axis=0),'observedMax':np.max(d,axis=0)}

def classify_response(reference0,reference1):
    a=_reference(reference0,'reference0');b=_reference(reference1,'reference1')
    if a.shape!=b.shape:raise ValueError('reference shapes differ')
    delta=(b-a)@LUMA
    return classify_deltas(delta)

def classify_color(reference):
    a=_reference(reference,'reference');ci=mean_interval(a)
    stable=np.all(ci['halfWidth']<=T,axis=-1)
    return {**ci,'stable':stable,'uncertain':~stable}

def _value_status(value):
    return 'N/A_NOT_PASS' if value is None else 'MEETS_60_ON_DECLARED_SUBSET' if value>=60 else 'BELOW_60_ON_DECLARED_SUBSET'

def color_metrics(reference_mean,candidate,mask):
    n=int(mask.sum())
    if not n:return {'status':'NO_EVALUATION_DOMAIN','pixels':0,'rgbAgreementPercent':None}
    diff=(reference_mean-candidate)[mask]
    mae=float(np.mean(abs(diff)));score=100*(1-mae)
    return {'pixels':n,'rgbMAE':mae,'rgbRMSE':float(np.sqrt(np.mean(diff**2))),
            'rgbAgreementPercent':score,'valueStatus':_value_status(score)}

def response_metrics(reference0,reference1,candidate0,candidate1,mask,reference_delta=None,reference_masks=None):
    n=int(mask.sum())
    if not n:return {'status':'NO_EVALUATION_DOMAIN','pixels':0,'metrics':None}
    dr=(reference1-reference0)@LUMA if reference_delta is None else reference_delta;dn=(candidate1-candidate0)@LUMA
    a=dr[mask];b=dn[mask];na=float(np.linalg.norm(a));nb=float(np.linalg.norm(b));sig=(abs(a)>T)|(abs(b)>T)
    magnitude=None if max(na,nb)==0 else 100*min(na,nb)/max(na,nb)
    sign=None if not sig.any() else float(100*np.mean(np.sign(a[sig])==np.sign(b[sig])))
    r={'pixels':n,'significantPixels':int(sig.sum()),'deltaLumaRMSE':float(np.sqrt(np.mean((a-b)**2))),
       'deltaRGBRMSE':float(np.sqrt(np.mean((reference1-reference0-candidate1+candidate0)[mask]**2))),
       'responseMagnitudeAgreementPercent':magnitude,'magnitudeValueStatus':_value_status(magnitude),
       'directionAgreementPercent':sign,'signValueStatus':_value_status(sign),
       'oneSideUnresponsive':bool((na==0)!=(nb==0)),
       'signedCorrelation':None if np.ptp(a)==0 or np.ptp(b)==0 else _finite_correlation(a,b)}
    for name,sgn in [('brightening',1),('darkening',-1)]:
        rm=mask&((sgn*dr>T) if reference_masks is None else reference_masks[name]);nm=mask&(sgn*dn>T);union=rm|nm
        iou=None if not union.any() else float((rm&nm).sum()/union.sum())
        r[name]={'referencePixels':int(rm.sum()),'candidatePixels':int(nm.sum()),
                 'intersection':int((rm&nm).sum()),'union':int(union.sum()),
                 'IoU':iou,'valueStatus':_value_status(None if iou is None else 100*iou),
                 'centroidDistanceDiagonal':None if not rm.any() or not nm.any() else float(np.linalg.norm(np.argwhere(rm).mean(0)-np.argwhere(nm).mean(0))/math.hypot(*mask.shape))}
    return r

def _domain_summary(stability,fg):
    n=int(fg.sum());stable=fg&stability['stable'];uncertain=fg&stability['uncertain']
    counts={name:int((fg&stability[name]).sum()) for name in ['bright','dark','inactive','stable','uncertain'] if name in stability}
    fraction=None if n==0 else int(stable.sum())/n
    return {'foregroundPixels':n,'counts':counts,'stableCoverageFraction':fraction,
            'uncertainCoverageFraction':None if n==0 else int(uncertain.sum())/n,
            'coverageBelow90PercentDescriptiveWarning':None if fraction is None else fraction<.9,
            'coverageWarningIsAcceptanceGate':False,
            'conditionScope':'NO_FOREGROUND' if n==0 else 'UNRESOLVED_UNCERTAIN_REMAINDER' if uncertain.any() else 'OBSERVED_STABLE_FOREGROUND_ONLY',
            'uncertainLocationsYX':np.argwhere(uncertain).tolist()}

def evaluate_response(reference0,reference1,foreground,candidate0=None,candidate1=None):
    a=_reference(reference0,'reference0');b=_reference(reference1,'reference1')
    if a.shape!=b.shape:raise ValueError('reference shapes differ')
    fg=_foreground(foreground,a.shape[1:3]);st=classify_response(a,b);summary=_domain_summary(st,fg)
    summary['qualityScope']='REFERENCE_ONLY_NO_CANDIDATE' if candidate0 is None and candidate1 is None else 'CONDITIONAL_SCORES_NOT_GLOBAL_ACCEPTANCE'
    summary['uncertainSignFrequencyAtLocations']=[{'y':int(y),'x':int(x),'bright':float(st['brightFrequency'][y,x]),'dark':float(st['darkFrequency'][y,x]),'meanDelta':float(st['mean'][y,x]),'lower':float(st['lower'][y,x]),'upper':float(st['upper'][y,x])} for y,x in np.argwhere(fg&st['uncertain'])]
    mean0=a.mean(0);mean1=b.mean(0)
    for name,sgn in [('brightening',1),('darkening',-1)]:
        observed=np.any(sgn*((b-a)@LUMA)>T,axis=0)&fg
        summary[name+'EverObservedCoverage']={'everObservedPixels':int(observed.sum()),'stablePixelsWithinEverObserved':int((observed&st['stable']).sum()),'stableFraction':None if not observed.any() else float((observed&st['stable']).sum()/observed.sum())}
    if candidate0 is None and candidate1 is None:
        summary['candidateScores']=None
        return _remove_descriptive_acceptance(summary),st
    if candidate0 is None or candidate1 is None:raise ValueError('both candidate images required')
    c0=_candidate(candidate0,a.shape[1:],'candidate0');c1=_candidate(candidate1,a.shape[1:],'candidate1')
    summary['candidateScores']={'stableSubset':response_metrics(mean0,mean1,c0,c1,fg&st['stable']),
        'uncertainSubsetDescriptiveNotAcceptance':response_metrics(mean0,mean1,c0,c1,fg&st['uncertain']),
        'pooledFullForegroundDescriptive':response_metrics(mean0,mean1,c0,c1,fg),
        'eachReferenceSeedFullForeground':[response_metrics(a[i],b[i],c0,c1,fg) for i in range(N)]}
    return _remove_descriptive_acceptance(summary),st

def evaluate_color(reference,foreground,candidate=None):
    a=_reference(reference,'reference');fg=_foreground(foreground,a.shape[1:3]);st=classify_color(a);summary=_domain_summary(st,fg)
    if candidate is None:summary.update(qualityScope='REFERENCE_ONLY_NO_CANDIDATE',candidateScores=None);return _remove_descriptive_acceptance(summary),st
    c=_candidate(candidate,a.shape[1:],'candidate');summary['qualityScope']='CONDITIONAL_SCORES_NOT_GLOBAL_ACCEPTANCE'
    summary['candidateScores']={'stableSubset':color_metrics(st['mean'],c,fg&st['stable']),
        'uncertainSubsetDescriptiveNotAcceptance':color_metrics(st['mean'],c,fg&st['uncertain']),
        'pooledFullForegroundDescriptive':color_metrics(st['mean'],c,fg),
        'eachReferenceSeedFullForeground':[color_metrics(a[i],c,fg) for i in range(N)]}
    return _remove_descriptive_acceptance(summary),st

# Authoritative image entry points: uint8 input, exact integer luma numerator.
PNG_WEIGHTS=np.array([2126,7152,722],dtype=np.int64)
PNG_DENOM=2550000
PNG_THRESHOLD=20000

def _png8(a,name):
    a=np.asarray(a)
    if a.dtype!=np.uint8 or a.ndim!=4 or a.shape[0]!=8 or a.shape[-1]!=3 or not all(a.shape[1:3]):
        raise ValueError(name+': explicit uint8 [8,H,W,3] PNG samples required')
    return a

def classify_png8(reference0,reference1):
    a=_png8(reference0,'reference0');b=_png8(reference1,'reference1')
    if a.shape!=b.shape:raise ValueError('reference shapes differ')
    numerator=(b.astype(np.int64)-a.astype(np.int64))@PNG_WEIGHTS
    ci=mean_interval(numerator)
    bright=np.all(numerator>PNG_THRESHOLD,axis=0)&(ci['lower']>PNG_THRESHOLD)
    dark=np.all(numerator<-PNG_THRESHOLD,axis=0)&(ci['upper']<-PNG_THRESHOLD)
    inactive=np.all(abs(numerator)<=PNG_THRESHOLD,axis=0)&(ci['lower']>=-PNG_THRESHOLD)&(ci['upper']<=PNG_THRESHOLD)
    return {**{k:v/PNG_DENOM for k,v in ci.items()},'numerator':numerator,
      'bright':bright,'dark':dark,'inactive':inactive,'stable':bright|dark|inactive,'uncertain':~(bright|dark|inactive),
      'brightFrequency':np.mean(numerator>PNG_THRESHOLD,axis=0),'darkFrequency':np.mean(numerator<-PNG_THRESHOLD,axis=0),
      'observedMin':numerator.min(0)/PNG_DENOM,'observedMax':numerator.max(0)/PNG_DENOM}

def evaluate_response_png8(reference0,reference1,foreground,candidate0=None,candidate1=None):
    aa=_png8(reference0,'reference0');bb=_png8(reference1,'reference1')
    if aa.shape!=bb.shape:raise ValueError('reference shapes differ')
    a=aa.astype(np.float64)/255;b=bb.astype(np.float64)/255
    fg=_foreground(foreground,a.shape[1:3]);st=classify_png8(aa,bb);summary=_domain_summary(st,fg)
    summary['numericContract']='PNG8 integer weighted numerator; candidate unchanged float64 decoded RGB565'
    summary['uncertainSignFrequencyAtLocations']=[{'y':int(y),'x':int(x),'bright':float(st['brightFrequency'][y,x]),'dark':float(st['darkFrequency'][y,x]),'meanDelta':float(st['mean'][y,x]),'lower':float(st['lower'][y,x]),'upper':float(st['upper'][y,x])} for y,x in np.argwhere(fg&st['uncertain'])]
    for name,sgn in [('brightening',1),('darkening',-1)]:
        observed=np.any(sgn*st['numerator']>PNG_THRESHOLD,axis=0)&fg
        summary[name+'EverObservedCoverage']={'everObservedPixels':int(observed.sum()),'stablePixelsWithinEverObserved':int((observed&st['stable']).sum()),'stableFraction':None if not observed.any() else float((observed&st['stable']).sum()/observed.sum())}
    if candidate0 is None and candidate1 is None:
        summary.update(qualityScope='REFERENCE_ONLY_NO_CANDIDATE',candidateScores=None);return _remove_descriptive_acceptance(summary),st
    if candidate0 is None or candidate1 is None:raise ValueError('both candidate images required')
    c0=_candidate(candidate0,a.shape[1:],'candidate0');c1=_candidate(candidate1,a.shape[1:],'candidate1')
    summed=st['numerator'].sum(0)
    pooled={'brightening':summed>N*PNG_THRESHOLD,'darkening':summed<-N*PNG_THRESHOLD}
    stable_masks={'brightening':st['bright'],'darkening':st['dark']}
    def score(mask,masks):return response_metrics(a.mean(0),b.mean(0),c0,c1,mask,st['mean'],masks)
    summary.update(qualityScope='CONDITIONAL_SCORES_NOT_GLOBAL_ACCEPTANCE',candidateScores={
      'stableSubset':score(fg&st['stable'],stable_masks),
      'uncertainSubsetDescriptiveNotAcceptance':score(fg&st['uncertain'],pooled),
      'pooledFullForegroundDescriptive':score(fg,pooled),
      'eachReferenceSeedFullForeground':[response_metrics(a[i],b[i],c0,c1,fg,st['numerator'][i]/PNG_DENOM,{'brightening':st['numerator'][i]>PNG_THRESHOLD,'darkening':st['numerator'][i]<-PNG_THRESHOLD}) for i in range(N)]})
    return _remove_descriptive_acceptance(summary),st

def evaluate_color_png8(reference,foreground,candidate=None):
    return evaluate_color(_png8(reference,'reference').astype(np.float64)/255,foreground,candidate)


def descriptive_only(value):
    if isinstance(value,dict):
        return {k:('DESCRIPTIVE_ONLY_NOT_ACCEPTANCE' if k.lower().endswith('valuestatus') else descriptive_only(v)) for k,v in value.items()}
    if isinstance(value,list):return [descriptive_only(v) for v in value]
    return value

def _remove_descriptive_acceptance(summary):
    scores=summary.get('candidateScores')
    if scores:
        for k in scores:
            if k!='stableSubset':scores[k]=descriptive_only(scores[k])
    return summary

def _finite_correlation(a,b):
    value=float(np.corrcoef(a,b)[0,1])
    return value if np.isfinite(value) else None
