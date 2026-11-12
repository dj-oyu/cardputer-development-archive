from pathlib import Path
import copy,json,hashlib,subprocess
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-visibility-lifetime-reduction';load=lambda p:json.loads(p.read_text());sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
b=load(B/'MEMORY_LEDGER.json');x=copy.deepcopy(b);s=load(R/'PRODUCT_NAMED_STACK.json');o=load(R/'NAMED_STACK.json');frames={}
for p in (R/'build-product').glob('*.su'):
 for line in p.read_text().splitlines():
  loc,amount,kind=line.split('\t');frames[p.stem+':'+loc.rsplit(':',1)[-1]]=int(amount)
cs=load(B/'CONSTRUCTION_NAMED_STACK.json');child=frames['visibility:vis_scene_build']+10*frames['visibility:build_node']+frames['visibility:build_bounds'];cs['visibilityBuild']={'bytes':child,'method':f"{frames['visibility:vis_scene_build']} +10*{frames['visibility:build_node']}+{frames['visibility:build_bounds']}; original build body unchanged; compact conversion inlined into constructor, at a disjoint phase."};cs['compactTransition']={'bytes':frames['visibility:vis_scene_build'],'method':'Conversion inlined into constructor; no recursive conversion or extra helper frame.'};(R/'CONSTRUCTION_NAMED_STACK.json').write_text(json.dumps(cs,indent=2)+'\n')
x.update(status='INDEXED_BVH_BOUNDS_PREACTUAL_NAMED_HOST_LEDGER',actualFrames=0,baseLedgerSHA256=sha(B/'MEMORY_LEDGER.json'),baselineNamedPeak=b['namedPeak'])
x['phases']['render']['heap']['sharedVisibilitySceneOnce']=69276
for name,p in x['phases'].items():
 if 'visibilityScene' in p:p['visibilityScene']=69276
 if name=='visibilityBuildConservative':p['visibilityBuildOnlyTemporary']=74412;p['namedChildStackUpper']=child
 p.pop('sumExcludingRO');p['sumExcludingRO']=sum(p['heap'].values())+p['mainStack']+p['namedChildStack'] if name=='render' else sum(p.values())
p={'visibilitySceneFinal':69276,'oldDoubleTreeDuringConversion':65472,'centroidWork':0,'callerGeometryTemporary':46800,'transportAttributes':35868,'mainStack':s['mainStack'],'namedChildStackUpper':frames['visibility:vis_scene_build']};p['sumExcludingRO']=sum(p.values());x['phases']['visibilityCompactTransition']=p
x['namedPeak']=max(p['sumExcludingRO'] for p in x['phases'].values());x['namedPeakDelta']=x['namedPeak']-x['baselineNamedPeak'];x['namedPeakIncludingNamedRO']=x['namedPeak']+x['profileRO']['newNamedROSum'];x['lifetimeReduction']['allKernelBytesUnchanged']=False
x['indexedBounds']={'nodeBytesBefore':64,'nodeBytesAfter':28,'sceneBytesBefore':106104,'sceneBytesAfter':69276,'savedPersistent':36828,'actualNodes':1023,'constructionRequestedHeap':143688,'transitionRequestedHeap':134748,'buildPeakExtraReported':74412,'oneTrianglePeakExtra':64,'allOldConstructionArithmeticSourceExact':True,'sixAllocationAttempts':True,'replacementPeakIncludingOneRetainedActualScene':212964,'maximumSceneBytes':143428,'maximumReplacementHeap':372836,'temporaryFormula':'nodes*36 + max(triangles*24,nodes*28)','noQueryBoundCache':True,'constructorNamedStackDelta':child-2432}
x['retainedScenes']={'oneRetainedActualScene':69276,'oneRetainedMaximumScene':143428,'note':'Each additionally retained old scene adds its full persistent bytes to all overlapping phases; allocator metadata excluded.'}
x['diagnosticPhases']={}
for mode,cap in [('withDepthCapture',129600),('withoutDepthCapture',0)]:
 ps={}
 for name,p in x['phases'].items():
  q={'productPhase':p['sumExcludingRO'],'mainStackDelta':o['mainStack']-s['mainStack'],'childStackDelta':o['rendererPeak']-s['rendererPeak'] if name=='render' else 0,'HDRGlobalControl':24,'HDRHeap':777600 if name=='render' else 0,'captureHeap':cap if name=='render' else 0};q['sumExcludingRO']=sum(q.values());ps[name]=q
 x['diagnosticPhases'][mode]=ps
x['diagnosticMaximumNamedExcludingRO']={m:max(p['sumExcludingRO'] for p in ps.values()) for m,ps in x['diagnosticPhases'].items()}
(R/'MEMORY_LEDGER.json').write_text(json.dumps(x,indent=2)+'\n');(R/'GUARD_ACCOUNTING.json').write_bytes((B/'GUARD_ACCOUNTING.json').read_bytes())
sizes={d:{'sizeOutput':subprocess.check_output(['size',str(R/d/'native-render')],text=True),'binarySHA256':sha(R/d/'native-render')} for d in ['build-product','build-adapter']};(R/'HOST_BINARY_SIZE.json').write_text(json.dumps(sizes,indent=2)+'\n')
print(json.dumps({'peak':x['namedPeak'],'delta':x['namedPeakDelta'],'constructorStack':child,'phases':{k:v['sumExcludingRO'] for k,v in x['phases'].items()}}))
