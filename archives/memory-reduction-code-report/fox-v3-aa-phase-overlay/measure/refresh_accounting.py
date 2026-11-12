from pathlib import Path
import json,hashlib,copy,subprocess
R=Path(__file__).resolve().parents[1];B=R.parent/'fox-v3-segmented-model-arena';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();load=lambda p:json.loads(p.read_text())
x=copy.deepcopy(load(B/'MEMORY_LEDGER.json'));s=load(R/'PRODUCT_NAMED_STACK.json');old=load(B/'PRODUCT_NAMED_STACK.json');assert all(s[k]==old[k] for k in ['mainStack','rendererPeak','backgroundPeak'])
x.update(status='AA_PHASE_OVERLAY_PREACTUAL_NAMED_HOST_LEDGER',actualFrames=0,baseLedgerSHA256=sha(B/'MEMORY_LEDGER.json'),baselineNamedPeak=x['namedPeak'],largestNamedAllocation=72512,priorLargestNamedAllocation=77312)
x['phases']['render']['heap']['aaWorkspace']=72512;x['phases']['render']['sumExcludingRO']-=4800;x['namedPeak']=max(p['sumExcludingRO'] for p in x['phases'].values());x['namedPeakDelta']=x['namedPeak']-x['baselineNamedPeak'];assert x['namedPeakDelta']==-4800
x['aaOverlay']={'baselineBytes':77312,'candidateBytes':72512,'saved':4800,'pendingRowBytes':5760,'centerIDBytes':4800,'centerPhaseBytes':10560,'winnerUnionBytes':13440,'extraAllocations':0,'extraAdmissionPairs':0,'legacyGenericBytes':137312,'allConsumersRecompiled':True}
x['stack']['baselineMain']=old['mainStack'];x['stack']['mainDelta']=0
(R/'MEMORY_LEDGER.json').write_text(json.dumps(x,indent=2)+'\n')
g=load(B/'GUARD_ACCOUNTING.json');g['baselineSHA256']=sha(B/'GUARD_ACCOUNTING.json');g['aaOverlayAddsGuards']=0;g['aaOverlayChangesCaps']=False;(R/'GUARD_ACCOUNTING.json').write_text(json.dumps(g,indent=2)+'\n')
sizes={d:{'sizeOutput':subprocess.check_output(['size',str(R/d/'native-render')],text=True),'baselineSizeOutput':subprocess.check_output(['size',str(B/d/'native-render')],text=True),'binarySHA256':sha(R/d/'native-render')} for d in ['build-product','build-adapter']};(R/'HOST_BINARY_SIZE.json').write_text(json.dumps(sizes,indent=2)+'\n');print(x['namedPeak'])
