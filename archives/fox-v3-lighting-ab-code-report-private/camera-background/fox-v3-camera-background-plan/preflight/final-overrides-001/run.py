#!/usr/bin/env python3
"""Geometry/count-only ten-front addendum. No visibility or transport linkage."""
import hashlib,json,os,pathlib,subprocess,time
HERE=pathlib.Path(__file__).resolve().parent
PRE=HERE.parent; ROOT=PRE.parents[1]; CORE=ROOT/'fox-v3-boundary-rho-affine-core-A'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def dump(p,x):p.write_text(json.dumps(x,indent=2,allow_nan=False)+'\n')
assert sha(PRE/'SOURCE_FREEZE.json')=='5f282d4fb21370487a2d991dd8cf7eaaa32e3febe7697122646b70fcea063ab9'
assert sha(PRE/'counts-001/COMPLETED.json')=='82f6c16ed1fc2bc05aedc09292ab153632bd85b991de679f0ecaa83b2411b9aa'
assert sha(PRE/'ORDER_DIAGNOSTIC_FREEZE.json')=='650c4e4d76c404fb6a68d93274a26bc13d89c263ed60235e2037fc3571cd8ba5'
assert sha(PRE/'diagnostic_positions.c')=='e1a8d44c6e7dbb4a83de6f10fa24011e43b0f9848b1457a66fc2c9c208eb9cf2'
manifest=json.loads((PRE/'counts-001/INPUT_FREEZE.json').read_text());old={r['name']:r for r in json.loads((PRE/'counts-001/COMPLETED.json').read_text())['cases']}
for p,h in manifest['inputPins'].items():assert sha(ROOT/p)==h,p
out=HERE/'private-results';out.mkdir()
exe=HERE/'diagnostic-positions'
cmd=['gcc','-std=c11','-O2','-ffp-contract=off','-Wall','-Wextra','-Werror','-Wno-misleading-indentation','-ffunction-sections','-fdata-sections','-I'+str(CORE/'product/main'),'-I'+str(CORE/'physical'),str(PRE/'diagnostic_positions.c'),str(CORE/'product/main/ui/kasane/ksn_mesh_depth.c'),str(CORE/'product/main/ayatsuri/compact_opaque.c'),str(CORE/'physical/fox_disk_lighting.c'),'-Wl,--gc-sections','-lm','-o',str(exe)]
subprocess.run(cmd,check=True);t0=time.perf_counter();rows=[]
for case in manifest['cases']:
 if case['view']!='front':continue
 name=case['name'];argv=case['argv'][:];argv[0]=str(exe);raw=out/(name+'.positions.jsonl');env=dict(os.environ,BACKGROUND_ORDER_DIAGNOSTICS=str(raw));p=subprocess.run(argv,env=env,check=True,text=True,capture_output=True);current=json.loads(p.stdout);dump(out/(name+'.count.json'),current)
 omit={'name','contextBytes','peakRSSKiB','cpuSeconds','wallSeconds'}
 for k,v in old[name].items():
  if k not in omit:assert current[k]==v,(name,k,current[k],v)
 positions=[json.loads(s) for s in raw.read_text().splitlines()];assert len(positions)==3
 retained=[r for r in positions if r['sample']>=0];discarded=[r for r in positions if r['sample']<0];assert len(retained)==2 and len(discarded)==1
 mask=pathlib.Path(argv[7]).read_bytes();c=discarded[0];assert c['x'].is_integer() if isinstance(c['x'],float) else True
 assert mask[int(c['y'])*240+int(c['x'])]==1
 assert all(r['diagnosticKernelEvaluations']==48 for r in positions)
 additional=sum(r['diagnosticPositiveQueries'] for r in retained);assert additional==96
 rows.append({'name':name,'case':case['case'],'reverse':case['reverse'],'allOldGeometryAndCountFieldsExact':True,'orderingFloorWins':3,'retainedQuarterReplacements':2,'discardedTargetCenterWins':1,'additionalFinalKernelEvaluations':96,'additionalFinalPositiveQueries':additional,'combinedEmptyPositiveQueries':current['combinedEmpty']['positiveKernelQueries'],'sceneCompositePositiveQueries':current['combinedEmpty']['positiveKernelQueries']+additional,'originalDirectCombinedRequirement':current['oldDirectRays']+current['combinedEmpty']['positiveKernelQueries']+additional,'originalDirect1MFit':False,'backgroundOnlyPositiveQueriesUnchanged':current['backgroundOnly']['positiveKernelQueries'],'privateDiagnosticSHA256':sha(raw)})
for p,h in manifest['inputPins'].items():assert sha(ROOT/p)==h,p
result={'geometryOnly':True,'shadowVisibilityExecuted':False,'physicalFrameExecuted':False,'oldAll20FreezePreserved':True,'allTenFrontCasesComplete':len(rows)==10,'allRetainedAdditionalQueries96':all(r['additionalFinalPositiveQueries']==96 for r in rows),'frontSceneCompositeQueries':1118928,'obliqueSceneCompositeQueriesUnchanged':1203920,'rows':rows,'diagnosticLoopWallSeconds':time.perf_counter()-t0,'privateResultDirectoryNotForBundle':str(out)};dump(HERE/'SUMMARY.json',result)
files={str(p.relative_to(ROOT)):sha(p) for p in [HERE/'run.py',HERE/'SUMMARY.json',PRE/'diagnostic_positions.c',PRE/'SOURCE_FREEZE.json',PRE/'counts-001/COMPLETED.json',PRE/'counts-001/INPUT_FREEZE.json',PRE/'ORDER_DIAGNOSTIC_FREEZE.json']}
dump(HERE/'SOURCE_FREEZE.json',{'scope':'Separate count-only addendum, ten front cases, old freezes unchanged; no shadow or physical frame','files':files,'privateDiagnosticsExcluded':True,'allOldNonTimingCountsUnchanged':True})
print('TEN_FRONT_COUNTS_COMPLETE',sha(HERE/'SOURCE_FREEZE.json'))
