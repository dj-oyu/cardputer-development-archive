"""Frozen all-ten-case current-lid8 2x2 filter/profile diagnostic. No rendering, fitting or LUT generation."""
from pathlib import Path
import ctypes, hashlib, importlib.util, json, shlex, subprocess, sys, time
import numpy as np
from PIL import Image
sys.dont_write_bytecode=True
R=Path(__file__).resolve().parent; W=R.parent
P=W/'fox-v3-agx-profile/profile'; REF=W/'fox-reference-uncertainty-v3'
AA=W/'fox-v3-position-diagnostic/weighted-aa/aa_math.py'
BASE=W/'fox-v3-lid-evaluation/actual-lid8-v2'; RAW=R/'run-001'
CASES=('baseline','direction','intensity','ambient','albedo')
RESPONSES=CASES[1:]
def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()
def save(p,v): p.write_text(json.dumps(v,indent=2,allow_nan=False)+'\n')
def module(name,path):
 spec=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m
def diff(a,b):
 if isinstance(a,dict) and isinstance(b,dict):return {k:diff(a[k],b[k]) for k in a if k in b}
 if isinstance(a,list) and isinstance(b,list) and len(a)==len(b):return [diff(x,y) for x,y in zip(a,b)]
 if type(a) in (int,float) and type(b) in (int,float):return a-b
 return None
def shape(fg,coverage):
 inter=int((fg&coverage).sum());union=int((fg|coverage).sum())
 return {'sourcePixels':int(fg.sum()),'supportPixels':int(coverage.sum()),'intersection':inter,'union':union,
         'missingPixels':int((fg&~coverage).sum()),'extraPixels':int((coverage&~fg).sum()),'IoU':inter/union if union else None,
         'status':'DESCRIPTIVE_SUPPORT_NOT_GEOMETRY_IMPROVEMENT'}
def decode(u):return np.stack([(u>>11)/31,((u>>5)&63)/63,(u&31)/31],-1)
def filter3(raw,coverage,offsets,weights):
 acc=np.zeros_like(raw);support=np.zeros_like(coverage)
 for gy,oy in enumerate(offsets):
  for gx,ox in enumerate(offsets):
   dx,dy=int(ox),int(oy);assert ox==dx and oy==dy
   sample=np.zeros_like(raw);covered=np.zeros_like(coverage)
   # Destination (y,x) samples source (y+dy,x+dx); out-of-frame black retains weight.
   y0,y1=max(0,-dy),min(135,135-dy);x0,x1=max(0,-dx),min(240,240-dx)
   sample[y0:y1,x0:x1]=raw[y0+dy:y1+dy,x0+dx:x1+dx]
   covered[y0:y1,x0:x1]=coverage[y0+dy:y1+dy,x0+dx:x1+dx]
   weight=float(weights[gy]*weights[gx]);acc+=weight*sample;support|=covered
 return acc,support

def fmt(value):return 'UNKNOWN' if value is None else f'{value:.6f}'
def response_confusion(scores):
 """Derive counts only; preserve the frozen evaluator output without modification."""
 if isinstance(scores,list):return [response_confusion(s) for s in scores]
 if not isinstance(scores,dict):return None
 if 'brightening' in scores and 'darkening' in scores:
  return {name:{'falsePositives':scores[name]['candidatePixels']-scores[name]['intersection'],
                'falseNegatives':scores[name]['referencePixels']-scores[name]['intersection'],
                'truePositives':scores[name]['intersection']} for name in ('brightening','darkening')}
 if scores.get('status')=='NO_EVALUATION_DOMAIN':return {'status':'NO_EVALUATION_DOMAIN','metrics':None}
 return {key:response_confusion(value) for key,value in scores.items()}

def main():
 if len(sys.argv)!=3 or sys.argv[2]!='--observer-control-passed':raise SystemExit('Usage: postprocess.py FRESH_OUTPUT --observer-control-passed')
 completed=json.loads((RAW/'COMPLETED.json').read_text())
 assert completed['rgbDepthAllExactBaseline'] is True and completed['inputsUnchanged'] is True
 assert completed['finiteNonnegativeHDR'] is True and completed['zeroBackground'] is True and len(completed['frames'])==10
 D=Path(sys.argv[1]).resolve();assert D.parent==R and not D.exists();D.mkdir()
 paths={Path(__file__),R/'test_filter.py',R/'PLAN.md',AA,W/'fox-v3-position-diagnostic/weighted-aa/run.py',W/'fox-v3-agx-profile/code/profile_buffer.c'}
 for root in [RAW,REF,BASE,R/'product',R/'code',R/'physical',R/'visibility',R/'transport',P]:
  paths.update(p for p in root.rglob('*') if p.is_file() and '__pycache__' not in p.parts)
 manifest=json.loads((P/'sha256-manifest.json').read_text())
 for name,digest in manifest.items():assert sha(P/name)==digest,'PROFILE_MANIFEST_MISMATCH '+name
 provenance=json.loads((P/'provenance.json').read_text());deps=provenance['all_dependency_sha256'];assert len(deps)==20
 installed=Path(provenance['installed_config']).parent
 for name,digest in deps.items():
  for path in [installed/name,P/'official-colormanagement'/name]:assert sha(path)==digest;paths.add(path)
 assert sha(REF/'input/source-settings.json')==provenance['source_settings_sha256']
 assert sha(installed/'config.ocio')==provenance['config_sha256']
 before={str(p):sha(p) for p in sorted(paths)};save(D/'input-hashes-before.json',before)
 # Independently recheck all twenty old output controls and raw capture hashes.
 frame_lookup={}
 for frame in completed['frames']:
  key=frame['view']+'-'+frame['case'];assert key not in frame_lookup;frame_lookup[key]=frame
  for name,digest in frame['files'].items():assert sha(RAW/name)==digest
  for suffix in ('.u16le','.f32le'):
   assert (RAW/f'native-{key}{suffix}').read_bytes()==(BASE/f'native-{key}{suffix}').read_bytes()
 assert set(frame_lookup)=={v+'-'+c for v in ('front','oblique') for c in CASES}
 cmd=['cc','-std=c11','-O2','-shared','-fPIC','-ffp-contract=off','-fexcess-precision=standard',
      '-I',str(P),'-I',str(R/'product/main'),str(W/'fox-v3-agx-profile/code/profile_buffer.c'),
      str(P/'agx_profile.c'),'-lm','-o',str(D/'profile-buffer.so')]
 save(D/'build-command.json',cmd);(D/'build-command.txt').write_text(shlex.join(cmd)+'\n')
 with (D/'build.log').open('w') as log:subprocess.run(cmd,stdout=log,stderr=subprocess.STDOUT,check=True)
 binary=D/'profile-buffer.so';binary_hash=sha(binary)
 lib=ctypes.CDLL(str(binary));lib.profile_buffer.argtypes=[ctypes.c_void_p,ctypes.c_void_p,ctypes.c_size_t,ctypes.c_uint,ctypes.POINTER(ctypes.c_ulong)];lib.profile_buffer.restype=ctypes.c_int
 E=module('frozen_evaluator',REF/'code/evaluator.py');A=module('fixed_aa_math',AA)
 offsets,weights=A.filter_grid(3);assert np.array_equal(offsets,[-1,0,1]);assert abs(float(weights.sum())-1)<1e-15
 save(D/'filter.json',{'offsets':offsets.tolist(),'weights1D':weights.tolist(),'weights2D':np.outer(weights,weights).tolist(),
      'summation':'gy outer, gx inner; acc += float(weights[gy]*weights[gx]) * zero-padded sample',
      'blackOutsideRetainsDenominator':True,'coveredOnlyRenormalization':False,'support':'union of shifted finite-depth masks, not RGB positivity'})
 cfg=json.loads((REF/'input/config.json').read_text());assert tuple(x['name'] for x in cfg['scenarios'])==CASES
 for name,digest in cfg['frozenCode'].items():assert sha(REF/name)==digest,'FROZEN_CODE_CHANGED '+name
 render=json.loads((REF/'render-manifest.json').read_text())
 lookup={(x['seed'],x['view'],x['case']):x for x in render['images']}
 result={};cost=[];support_result={}
 arms=['point-off','point-on','filter3-off','filter3-on']
 for view in ('front','oblique'):
  fgrow=render['foreground'][view];fgpath=REF/fgrow['file'];assert sha(fgpath)==fgrow['sha256'];fg=np.array(Image.open(fgpath))[...,3]>0
  refs={};images={arm:{} for arm in arms};support_result[view]={}
  for case in CASES:
   key=view+'-'+case;raw=np.fromfile(RAW/f'native-{key}-combined.f64le',dtype='<f8').reshape(135,240,3)
   depth=np.fromfile(RAW/f'native-{key}.f32le',dtype='<f4').reshape(135,240)
   assert np.all(np.isfinite(depth)|np.isneginf(depth));coverage=np.isfinite(depth)
   assert np.isfinite(raw).all() and (raw>=0).all() and (raw[~coverage]==0).all()
   filter_times=[]
   for _ in range(11):
    ft=time.perf_counter_ns();filtered,support=filter3(raw,coverage,offsets,weights);filter_times.append(time.perf_counter_ns()-ft)
   filter_timing={'repetitions':11,'minNs':min(filter_times),'medianNs':float(np.median(filter_times)),'maxNs':max(filter_times)}
   assert (filtered[~support]==0).all()
   np.savez_compressed(D/f'{key}-support.npz',original=coverage,filtered=support)
   support_result[view][case]={'original':shape(fg,coverage),'filtered':shape(fg,support),'expandedSupportPixels':int((support&~coverage).sum())}
   refs[case]=[]
   for seed in cfg['seeds']:
    row=lookup[(seed,view,case)];path=REF/row['file'];assert sha(path)==row['sha256'];refs[case].append(np.array(Image.open(path))[...,:3])
   refs[case]=np.stack(refs[case]);assert refs[case].shape==(8,135,240,3)
   for arm in arms:
    source=raw if arm.startswith('point') else filtered;mask=coverage if arm.startswith('point') else support
    source=np.ascontiguousarray(source,dtype=np.float64);enabled=int(arm.endswith('-on'))
    u=np.zeros((135,240),dtype=np.uint16);clamped=ctypes.c_ulong();display_times=[]
    first=None
    for _ in range(11):
     t=time.perf_counter_ns();assert lib.profile_buffer(source.ctypes.data,u.ctypes.data,32400,enabled,ctypes.byref(clamped))==1
     display_times.append(time.perf_counter_ns()-t)
     if first is None:first=u.copy()
     else:assert np.array_equal(first,u),'DISPLAY_REPEAT_NOT_EXACT'
    # Auxiliary clamp attribution is outside all reported timing repetitions.
    # Pad each subset with black and subtract the independently measured black flag.
    black=np.zeros_like(source);scratch=np.zeros_like(u);black_count=ctypes.c_ulong()
    assert lib.profile_buffer(black.ctypes.data,scratch.ctypes.data,32400,enabled,ctypes.byref(black_count))==1
    assert black_count.value in (0,32400);black_flag=black_count.value//32400
    clamp_groups={}
    for group,domain in [('nativeCovered',coverage),('nativeBackground',~coverage),('displaySupport',mask),('outsideDisplaySupport',~mask)]:
     subset=np.where(domain[...,None],source,0.0);count=ctypes.c_ulong()
     assert lib.profile_buffer(subset.ctypes.data,scratch.ctypes.data,32400,enabled,ctypes.byref(count))==1
     clamp_groups[group]={'pixels':int(domain.sum()),'clampedPixels':int(count.value-(32400-int(domain.sum()))*black_flag)}
    assert clamp_groups['nativeCovered']['clampedPixels']+clamp_groups['nativeBackground']['clampedPixels']==clamped.value
    assert clamp_groups['displaySupport']['clampedPixels']+clamp_groups['outsideDisplaySupport']['clampedPixels']==clamped.value
    u[~mask]=0
    if arm=='point-off':assert u.astype('<u2').tobytes()==(BASE/f'native-{key}.u16le').read_bytes(),'POINT_OFF_CONTROL_FAILED'
    u.astype('<u2').tofile(D/f'{arm}-{key}.u16le');images[arm][case]=decode(u)
    cost.append({'view':view,'case':case,'arm':arm,'clampedPixels':clamped.value,'clampAttributionUntimed':clamp_groups,'blackInputClampFlag':black_flag,'displayRepeatTimingHostOnly':{'repetitions':11,'minNs':min(display_times),'medianNs':float(np.median(display_times)),'maxNs':max(display_times)},
                 'filterRepeatTimingHostOnly':filter_timing if arm.startswith('filter3') else None,
                 'rawHDRBytes':raw.nbytes,'filteredHDRBytes':filtered.nbytes,'output565Bytes':u.nbytes,
                 'filterTemporarySampleHDRBytes':raw.nbytes,'nativeDepthBytes':depth.nbytes,'nativeCoverageBytes':coverage.nbytes,
                 'filterUnionSupportBytes':support.nbytes,'filterTemporaryCoveredMaskBytes':coverage.nbytes,'displayRepeatControlBytes':u.nbytes,'observerStaticHDRBytesSeparate':777600,
                 'profileReadOnlyTableBytes':3295500,'productFitEstablished':False})
  result[view]={}
  for arm in arms:
   result[view][arm]={'color':{case:E.evaluate_color_png8(refs[case],fg,images[arm][case])[0] for case in CASES},'response':{},'inactiveFalsePositives':{},'responseConfusion':{}}
   for case in RESPONSES:
    response,masks=E.evaluate_response_png8(refs['baseline'],refs[case],fg,images[arm]['baseline'],images[arm][case])
    dy=(images[arm][case]-images[arm]['baseline'])@np.array([.2126,.7152,.0722]);inactive=fg&masks['inactive']
    ib=int((inactive&(dy>2/255)).sum());idd=int((inactive&(dy < -2/255)).sum())
    result[view][arm]['response'][case]=response
    result[view][arm]['inactiveFalsePositives'][case]={'inactivePixels':int(inactive.sum()),'bright':ib,'dark':idd,'total':ib+idd}
    result[view][arm]['responseConfusion'][case]=response_confusion(response['candidateScores'])
 interaction={view:diff(diff(result[view]['filter3-on'],result[view]['filter3-off']),diff(result[view]['point-on'],result[view]['point-off'])) for view in result}
 contrasts={view:{'profileAtPoint':diff(result[view]['point-on'],result[view]['point-off']),
                  'profileAtFilter3':diff(result[view]['filter3-on'],result[view]['filter3-off']),
                  'filterAtProfileOff':diff(result[view]['filter3-off'],result[view]['point-off']),
                  'filterAtProfileOn':diff(result[view]['filter3-on'],result[view]['point-on'])} for view in result}
 after={str(p):sha(Path(p)) for p in before};assert before==after;assert sha(binary)==binary_hash
 save(D/'input-hashes-after.json',after);save(D/'evaluation.json',result);save(D/'interaction.json',interaction);save(D/'contrasts.json',contrasts);save(D/'support.json',support_result);save(D/'cost.json',cost);save(D/'clamps.json',[{k:row[k] for k in ('view','case','arm','clampedPixels','clampAttributionUntimed','blackInputClampFlag')} for row in cost])
 save(D/'scope.json',{'allTenColorCases':True,'allEightResponses':True,'globalAcceptance':'NOT_ESTABLISHED',
      'sixtyPercentGoal':'NOT_ESTABLISHED_CONDITIONAL_METRICS_ONLY','selectionMade':False,'pointOffExactActualLid8V2':True,
      'referenceUnchanged':True,'rawAndSourcesUnchanged':True,'profileDescription':'Official OCIO-derived LUT approximation, not processor-exact equivalence','profileLocalManifestVerified':True,'installedDependenciesVerified':20,
      'pngDither1Implemented':False,'continuousProfileNoPNGOutputDither':True,'filterBeforeDisplay':True,'librarySHA256':binary_hash,'noGroundOrAdditionalFeatures':True,
      'interactionDefinition':'(filter3-on − filter3-off) − (point-on − point-off), metric-specific; not additive quality gains'})
 lines=['# Fixed 2×2 current-lid8 display/filter diagnostic','','Ten color cases and eight baseline-relative responses per arm. No acceptance, selection, convergence, or product-fit conclusion. Profile is applied after the fixed HDR filter. Point/OFF reproduces actual-lid8-v2 bytes exactly.','',
        '| View/case | Point OFF RGB % | Point ON | Filter3 OFF | Filter3 ON | Interaction pp |','|---|---:|---:|---:|---:|---:|']
 for view in result:
  for case in CASES:
   vals=[result[view][a]['color'][case]['candidateScores']['stableSubset'].get('rgbAgreementPercent') for a in arms]
   inter=interaction[view]['color'][case]['candidateScores']['stableSubset'].get('rgbAgreementPercent')
   lines.append('| '+view+'/'+case+' | '+' | '.join(fmt(x) for x in vals+[inter])+' |')
 lines+=['','| View / response / arm | Sign % | Luma RMSE | RGB RMSE | Magnitude % | Bright IoU | Dark IoU | Inactive FP |','|---|---:|---:|---:|---:|---:|---:|---:|']
 for view in result:
  for case in RESPONSES:
   for arm in arms:
    r=result[view][arm]['response'][case]['candidateScores']['stableSubset'];vals=[r.get('directionAgreementPercent'),r.get('deltaLumaRMSE'),r.get('deltaRGBRMSE'),r.get('responseMagnitudeAgreementPercent'),r.get('brightening',{}).get('IoU'),r.get('darkening',{}).get('IoU'),result[view][arm]['inactiveFalsePositives'][case]['total']]
    lines.append('| '+view+'/'+case+'/'+arm+' | '+' | '.join(fmt(v) for v in vals)+' |')
 lines+=['','| View / case / arm | Total clamps | Native covered | Native background | Display support | Outside display support |','|---|---:|---:|---:|---:|---:|']
 for row in cost:
  g=row['clampAttributionUntimed'];vals=[row['clampedPixels']]+[g[k]['clampedPixels'] for k in ('nativeCovered','nativeBackground','displaySupport','outsideDisplaySupport')]
  lines.append('| '+row['view']+'/'+row['case']+'/'+row['arm']+' | '+' | '.join(str(v) for v in vals)+' |')
 lines+=['','Official OCIO-derived LUT approximation, not exact equality to the OCIO processor. Clamp totals and native-covered/native-background partitions are shown for every case and arm; auxiliary calls are outside timed measurements. Filter-expanded support can contain signal outside native coverage, so display-support/outside-support partitions are also shown.','']
 lines+=['','All numeric metric contrasts, including signed correlations, uncertain/pooled/per-seed metrics and interaction, are retained in JSON. Reference-only stable masks include inactive pixels; scoring retains full source foreground, including native missing silhouette. No null is treated as zero/pass.','',
         'Support expansion is reported separately in support.json. Filter support comes from depth-mask union, not RGB positivity, and is not geometry improvement. Fixed weights retain outside/no-hit black samples with no covered-only renormalization.','',
         'Host costs: 3,295,500-byte read-only LUT; each full HDR array 777,600 bytes; RGB565 output 64,800 bytes; native observer HDR allocation separate. Python temporary arrays and library/code overhead are additional, not an established peak-RAM budget. Filter/display timing uses 11 identical-input repetitions, with min/median/max reported as host-only timings, not device benchmarks or a native-render-plus-transform performance estimate. Continuous profile conversion does not implement PNG dither=1.','',
         'No LUT regeneration or source-image fit. Local frozen profile manifest, installed 20 dependencies, all raw/reference/foreground/source inputs and fresh library binary are hash-checked. All five conditions are evaluated without selecting a winner or claiming global acceptance. False-positive/false-negative counts for each response domain are derived from the unchanged evaluator intersections and retained separately in responseConfusion.','']
 (D/'REPORT.md').write_text('\n'.join(lines))
 save(D/'output-hashes.json',{p.name:sha(p) for p in sorted(D.iterdir()) if p.is_file() and p.name not in ('output-hashes.json','COMPLETED.json')})
 save(D/'COMPLETED.json',{'status':'DIAGNOSTIC_COMPLETE_NOT_ACCEPTANCE','pointOffExact':True,'inputsUnchanged':True,'arms':4,'colorCasesPerArm':10,'responseCasesPerArm':8})
 print('\n'.join(lines[:12]))
if __name__=='__main__':main()
