from pathlib import Path
import json,hashlib,subprocess
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-indexed-transport-input';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
load=lambda p:json.loads(p.read_text())
m=load(R/'measure/MODEL_STORAGE.json');stack=load(R/'PRODUCT_NAMED_STACK.json');base=load(B/'MEMORY_LEDGER.json')
owner=32+m['nodes']*m['descriptorBytes'];payload=m['metadataBytes']+m['nodeTotalBytes'];delta=payload+owner-m['legacyBytes'];main_delta=stack['mainStack']-base['stack']['main']
x={'status':'SEGMENTED_MODEL_PREACTUAL_NAMED_HOST_LEDGER','actualFrames':0,'baseLedgerSHA256':sha(B/'MEMORY_LEDGER.json'),'model':dict(m,payloadBytes=payload,payloadDelta=payload-m['legacyBytes'],ownerControlBytes=owner,heapIncludingOwner=payload+owner,heapDeltaIncludingOwner=delta,payloadAllocations=m['nodes']+1,allocationsIncludingOwner=m['nodes']+2,largestModelAllocation=max(owner,m['metadataBytes'],m['maxNodeBytes'])),'stack':{'baselineMain':base['stack']['main'],'main':stack['mainStack'],'mainDelta':main_delta,'rendererPeak':stack['rendererPeak'],'backgroundPeak':stack['backgroundPeak'],'backgroundCap':4096,'backgroundMargin':4096-stack['backgroundPeak']},'phases':{},'noWholeHostOrDeviceFitClaim':True,'target32ABI':'Not measured; no new SDK or device access','allConsumersRecompiled':True,'exclusions':base['exclusions'],'namedROReferenceBytesUnchanged':base['ROReferenceBytes']}
for name,phase in base['phases'].items():
 p=dict(phase);p['mainStack']=stack['mainStack'];p.pop('sumExcludingRO')
 if name=='render':p['namedChildStack']=stack['rendererPeak'];p['sumExcludingRO']=sum(p['heap'].values())+p['mainStack']+p['namedChildStack']
 else:p.pop('modelArenaActual1566');p['modelPayload']=payload;p['modelOwnerControl']=owner;p['sumExcludingRO']=sum(p.values())
 x['phases'][name]=p
x['baselineNamedPeak']=base['newNamedPeakExcludingRO'];x['namedPeak']=max(p['sumExcludingRO'] for p in x['phases'].values());x['namedPeakDelta']=x['namedPeak']-x['baselineNamedPeak'];x['largestNamedAllocation']=77312;x['largestNamedAllocationOwner']='AA workspace';x['priorLargestNamedAllocation']=81356
x['maximumNodeCountBookkeeping']={'nodes':m['nodeLimit'],'metadataBytes':m['metadataBytes']//m['nodes']*m['nodeLimit'],'ownerControlBytes':32+m['nodeLimit']*m['descriptorBytes'],'allocationAttemptsIncludingOwner':m['nodeLimit']+2,'nodeSlotBound':'Derived per immutable opened model;84..1648 is actual fox only, not a universal bound.'}
x['diagnosticStack']=load(R/'NAMED_STACK.json')['mainStack']
x['newStorageWork']={'pointerTableCopyBytes':m['nodes']*m['pointerBytes'],'additionalZeroFillBytes':m['nodes']*m['pointerBytes']+owner,'allocationAttempts':m['nodes']+2,'unchangedInitCopyCounter':'Counts original node parameter copies only, excludes pointer table, zero fill and owner setup. Unchanged physical counters do not imply equal CPU work.'}
x['storageLifetime']='Owner control, copied metadata table, all node slots and cold remain live through final snapshot extraction; dispose clears model access, helper frees independent saved pointers. All model storage gone before render.'
x['accountingLimits']='Requested payload only; 57 malloc headers and fragmentation excluded, never interpreted as RAM saving. Main includes pointer/control locals; separately allocated owner table is charged once on heap. Render phase may change only with measured compiled main/renderer frames.'
(R/'MEMORY_LEDGER.json').write_text(json.dumps(x,indent=2)+'\n')
frames={}
for p in (R/'build-product').glob('*.su'):
 for line in p.read_text().splitlines():
  loc,amount,kind=line.split('\t');frames[p.stem+':'+loc.rsplit(':',1)[-1]]=int(amount)
guard={'actualFrames':0,'actualNodes':m['nodes'],'maximumNodes':m['nodeLimit'],'initIntervalChecks':{str(n):7+5*n+n*(n-1)//2 for n in [m['nodes'],m['nodeLimit']]},'perStorageOverlapMaximumSpanChecks':{str(n):n+1 for n in [m['nodes'],m['nodeLimit']]},'targetFourArraysMaximumSpanChecks':{str(n):4*(n+1) for n in [m['nodes'],m['nodeLimit']]},'complexity':'Interval comparisons O(N^2) init and O(N) each guard. Deriving blend-region slot lengths scans region rows: general time O(N^2*R) init and O(N*R) guard; fox group/mesh avoids region scans. No allocation or node-sized stack in product helper.','rendererBudgetsUnchanged':base['rowAdmission'],'modelFrames':{k:v for k,v in frames.items() if k.startswith('ayatsuri_model:')},'ownerReleaseFrameBytes':frames.get('native_render_row:model_arena_owner_release.constprop',0),'ownerCreateFrame':'inlined into measured main','noSpeedupClaim':True}
(R/'GUARD_ACCOUNTING.json').write_text(json.dumps(guard,indent=2)+'\n')
sizes={}
for d in ['build-product','build-adapter']:
 sizes[d]={'sizeOutput':subprocess.check_output(['size',str(R/d/'native-render')],text=True),'binarySHA256':sha(R/d/'native-render')}
(R/'HOST_BINARY_SIZE.json').write_text(json.dumps(sizes,indent=2)+'\n');print(json.dumps({'model':x['model'],'stack':x['stack'],'peak':x['namedPeak']}))
