"""Caller-only lifetime ledger with freshly compiled named frames."""
from pathlib import Path
import copy,json,hashlib,subprocess
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-streamed-center-depth';load=lambda p:json.loads(p.read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
b=load(B/'MEMORY_LEDGER.json');s=load(R/'PRODUCT_NAMED_STACK.json');o=load(R/'NAMED_STACK.json');x=copy.deepcopy(b);delta=s['mainStack']-b['stack']['main'];frames={}
for p in (R/'build-product').glob('*.su'):
 for line in p.read_text().splitlines():
  loc,amount,kind=line.split('\t');frames[p.stem+':'+loc.rsplit(':',1)[-1]]=int(amount)
# A conservative sum of every emitted nonrecursive frame in preparation modules,
# not a claimed simultaneous call chain; covers open/init/evaluate/enumerate/append.
mods=['ayatsuri_model','ayatsuri_visibility','fox_disk_lighting','compact_opaque','ksn_procedural']
prep={k:v for k,v in frames.items() if k.split(':')[0] in mods}
for n in ['ksn_mesh_pixel_begin','pixel_scene','pixel_append','ksn_mesh_pixel_append','ksn_mesh_pixel_append_normal_pair','ksn_mesh_append','ksn_mesh_append_sided']:
 k='ksn_mesh_depth:'+n;prep[k]=frames[k]
prep['native_render_row:model_arena_owner_release.constprop']=frames['native_render_row:model_arena_owner_release.constprop']
extract={k:frames[k] for k in ['ayatsuri_model:ayatsuri_model_instance_pixel_mesh_view','ayatsuri_model:storage_overlap','ayatsuri_model:overlaps','ayatsuri_model:work','ayatsuri_model:mesh_double']}
extract_upper=sum(extract.values())
release=max(frames['ayatsuri_model:ayatsuri_model_instance_dispose'],frames['native_render_row:model_arena_owner_release.constprop'])
cs={'status':'COMPILED_CONSERVATIVE_NAMED_CONSTRUCTION_BOUND','actualFrames':0,'preExtractionAndAppend':{'method':'Sum of all emitted frames in nonrecursive preparation modules plus all snapshot append helpers; deliberately overcounts disjoint calls. Inlined frames are in callers.','frames':prep,'bytes':sum(prep.values())},'geometryExtraction':{'method':'Sum pixel-view frame plus all its emitted model helpers; world-view frame1264 is smaller.','frames':extract,'bytes':extract_upper},'disposeAndRelease':{'bytes':release,'method':'Sequential dispose8 and owner-release32, not simultaneous.'},'visibilityBuild':{'bytes':frames['visibility:vis_scene_build']+10*frames['visibility:build_node']+frames['visibility:build_bounds'],'method':'336 + 10*192 +176; balanced split for1566 triangles, leaf<=4, at most10 build_node frames.'},'exclusions':['libc/libm/allocator/stdio and unnamed runtime','not target ABI or whole process fit'],'mainStack':s['mainStack']}
(R/'CONSTRUCTION_NAMED_STACK.json').write_text(json.dumps(cs,indent=2)+'\n')
x.update(status='VISIBILITY_LIFETIME_PREACTUAL_NAMED_HOST_LEDGER',actualFrames=0,baseLedgerSHA256=sha(B/'MEMORY_LEDGER.json'),baselineNamedPeak=b['namedPeak'])
for name,p in x['phases'].items():
 p['mainStack']+=delta;p['sumExcludingRO']+=delta
 if name!='render':
  for k in ['coldModelBytes','modelPayload','modelOwnerControl']:p['sumExcludingRO']-=p[k];p[k]=0
x['phases']['visibilityBuildConservative']['namedChildStackUpper']=cs['visibilityBuild']['bytes']
model={'coldModelBytes':47708,'modelPayload':81796,'modelOwnerControl':912}
for name,child,geometry in [('preExtractionAndAppendConservative',sum(prep.values()),False),('geometryExtractionConservative',extract_upper,True),('earlyDisposeConservative',release,True)]:
 p={**model,'mainStack':s['mainStack'],'namedChildStackUpper':child,'callerGeometryTemporary':46800 if geometry else 0,'transportAttributes':35868 if geometry else 0};p['sumExcludingRO']=sum(p.values());x['phases'][name]=p
x['namedPeak']=max(p['sumExcludingRO'] for p in x['phases'].values());x['namedPeakDelta']=x['namedPeak']-x['baselineNamedPeak'];x['stack'].update(main=s['mainStack'],baselineMain=b['stack']['main'],mainDelta=delta,rendererPeak=s['rendererPeak'],backgroundPeak=s['backgroundPeak'],backgroundMargin=4096-s['backgroundPeak']);x['diagnosticStack']=o['mainStack'];x['namedPeakIncludingNamedRO']=x['namedPeak']+x['profileRO']['newNamedROSum']
x['storageLifetime']='Snapshot serialized before geometry extraction. All model data remains live through final original-order world/pixel copies. Instance disposed, independent owner poisoned/released, cold poisoned/freed before visibility build. Nonvisibility fallback disposes once at original late boundary. Disks/ground remain live to original late poison.'
x['lifetimeReduction']={'removedBuildOverlap':130416,'newStorageBytes':0,'wholeNamedSaving':-x['namedPeakDelta'],'oldPeakPhase':'visibilityBuildConservative','newPeakPhase':'render','allKernelBytesUnchanged':True,'baselineProcessExitFailureCleanupUnchanged':True}
x['diagnosticPhases']={}
for mode,cap in [('withDepthCapture',129600),('withoutDepthCapture',0)]:
 phases={}
 for name,p in x['phases'].items():
  q={'productPhase':p['sumExcludingRO'],'mainStackDelta':o['mainStack']-s['mainStack'],'childStackDelta':o['rendererPeak']-s['rendererPeak'] if name=='render' else 0,'HDRGlobalControl':24,'HDRHeap':777600 if name=='render' else 0,'captureHeap':cap if name=='render' else 0};q['sumExcludingRO']=sum(q.values());phases[name]=q
 x['diagnosticPhases'][mode]=phases
x['diagnosticMaximumNamedExcludingRO']={m:max(p['sumExcludingRO'] for p in ps.values()) for m,ps in x['diagnosticPhases'].items()}
(R/'MEMORY_LEDGER.json').write_text(json.dumps(x,indent=2)+'\n');(R/'GUARD_ACCOUNTING.json').write_bytes((B/'GUARD_ACCOUNTING.json').read_bytes())
sizes={d:{'sizeOutput':subprocess.check_output(['size',str(R/d/'native-render')],text=True),'binarySHA256':sha(R/d/'native-render')} for d in ['build-product','build-adapter']};(R/'HOST_BINARY_SIZE.json').write_text(json.dumps(sizes,indent=2)+'\n')
print(json.dumps({'namedPeak':x['namedPeak'],'delta':x['namedPeakDelta'],'phases':{k:v['sumExcludingRO'] for k,v in x['phases'].items()}}))
