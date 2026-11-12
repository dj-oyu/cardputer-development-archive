"""Code-only prerequisite checkpoint. Does not run physical renderer."""
from pathlib import Path
import json,hashlib,re,subprocess,copy
R=Path(__file__).resolve().parents[1];W=R.parent;B=W/'fox-v3-indexed-floor-world'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def save(name,x):(R/name).write_text(json.dumps(x,indent=2)+'\n')
pins=json.loads((R/'SOURCE_PINS.json').read_text());assert all(sha(W/p)==h for p,h in pins.items())
external=W/'fox-v3-floor-direct-reflection-evaluation/actual-002/code/aa_adapter.h'
save('EXTERNAL_ADAPTER_PIN.json',{'path':str(external.relative_to(W)),'sha256':sha(external),'change':'Local copy changes workspace parameter type only and adds ring header; source not edited.'})
stack=json.loads((R/'PRODUCT_NAMED_STACK.json').read_text());base=json.loads((B/'ADAPTER_MEMORY.json').read_text());ph=copy.deepcopy(base['phases']);ph['render']['heap']['aaWorkspace']=77312;ph['render']['namedChildStack']=stack['rendererPeak'];ph['render']['mainStack']=stack['mainStack'];ph['render']['sumExcludingRO']=sum(ph['render']['heap'].values())+stack['rendererPeak']+stack['mainStack'];assert stack['mainStack']==base['phases']['render']['mainStack']
newpeak=max(x['sumExcludingRO'] for x in ph.values());oldpeak=max(x['sumExcludingRO'] for x in base['phases'].values())
save('MEMORY_LEDGER.json',{'status':'PREREQUISITE_NAMED_HOST_LEDGER','actualFrames':0,'legacyWorkspace':137312,'ringWorkspace':77312,'workspaceSaved':60000,'stack':{'oldRendererPeak':4976,'newRendererPeak':stack['rendererPeak'],'increase':stack['rendererPeak']-4976,'backgroundPeak':stack['backgroundPeak'],'backgroundCap':4096,'rendererCap':8192,'main':stack['mainStack']},'phases':ph,'oldNamedPeakExcludingRO':oldpeak,'newNamedPeakExcludingRO':newpeak,'trueNamedPeakSaved':oldpeak-newpeak,'renderPhaseSaved':base['phases']['render']['sumExcludingRO']-ph['render']['sumExcludingRO'],'ROReferenceBytes':base['namedROSum'],'ROAccounting':'Original named inputs/profile arrays unchanged; code/helper specialization is additional text, not included as RAM. No complete executable/host/device fit claim.','exclusions':base['exclusions'],'constructionProof':'All private-build files unchanged except ksn_mesh_depth.c appended ring include. Native adapter allocation type only; main frame unchanged. Visibility/build objects retain source and emitted stack values.','baselineLedgerSHA256':sha(B/'ADAPTER_MEMORY.json')})
source=[p for d in ['code','harness','private-build'] for p in (R/d).rglob('*') if p.is_file() and p.suffix in ['.c','.h','.inc','.py','.sh'] and '__pycache__' not in p.parts]
save('SOURCE_FREEZE.json',{'status':'PREREQUISITE_CODE_FROZEN_NO_ACTUAL_AUTHORIZATION','actualFrames':0,'files':{str(p.relative_to(R)):sha(p) for p in sorted(source)}})
# Only implementations, synthetic tests, reproducible build/check scripts, aggregates.
allow=['PLAN.md','SOURCE_PINS.json','EXTERNAL_ADAPTER_PIN.json','SOURCE_FREEZE.json','PRODUCT_NAMED_STACK.json','NAMED_STACK.json','MEMORY_LEDGER.json','SEMANTIC_LEDGER.json','PREREQUISITE_REPORT.md']
allow += [str(p.relative_to(R)) for p in (R/'code').glob('*') if p.suffix in ['.h','.inc']]
allow += ['harness/'+n for n in ['derive_ring.py','build_adapter.py','stack_manifest.py','checkpoint.py','fixture.h','test_producer.c','test_ring_negative.c','test_ring_exact.c','run_ring_tests.sh','test_adapter.c','test_prefix.c','run_adapter_tests.py','row_transport_bridge.h','row_transport_bridge.c','native_render_row.c','aa_adapter.h']]
allow += ['private-build/product/main/ui/kasane/ksn_mesh_depth.c']
allow += [str(p.relative_to(R)) for d in ['build-synthetic','build-synthetic-san','build-adapter','build-adapter-sanitized'] for p in (R/d).glob('test*.log')]
save('CODE_ONLY_ALLOWLIST.json',{'status':'NO_ASSETS_NO_RAW_FRAMES','files':{p:sha(R/p) for p in sorted(allow) if (R/p).is_file()},'excluded':['compiled binaries and objects','private source assets and input tables','raw frames/HDR/depth/snapshot/mask','all completed baseline outputs','actual runner until separately authorized']})
print(json.dumps({'actualFrames':0,'renderPhase':ph['render']['sumExcludingRO'],'peak':newpeak,'saved':oldpeak-newpeak}))
