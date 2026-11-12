"""Generate reviewed-input expectations from retained BASELINE ONLY, never actual candidates.
Leaves DRAFT status. Reviewer must confirm all formulas/declarations before freeze.
"""
from report_contract import read,TIMING
from run_fixed40 import B,C,write

def prepare():
 assert not (C/'REPORT_CONTRACT.json').exists(),'Never overwrite a declared contract'
 contract={'status':'DRAFT_NOT_RUNNABLE','timing':TIMING,'sidecarExtension':'.depth-stream.json','environmentByMode':{'diagnostic':{'HONE_DEPTH_CAPTURE':'on'},'production':{'HONE_DEPTH_CAPTURE':'off'}},'memoryDeclarations':{'centerStripBytes':7680,'pendingDepthBytes':960,'centerDepthScratchBytes':8640,'oldFullDepthBytes':129600,'streamDescriptorBytes':48,'streamReportBytes':24,'diagnosticDepthCaptureBytes':129600,'productionDepthCaptureBytes':0,'RGBBytes':64800,'AAWorkspaceBytes':72512,'profileCacheBytes':3224,'namedLifecycleAndStack':'Await final compiled memory ledger before freeze; these payload counts alone do not establish lifecycle savings'},'workDeclarations':{'pendingCopyFloats':3840,'pendingCopyBytes':15360,'diagnosticCaptureCopyFloats':32400,'diagnosticCaptureCopyBytes':129600,'productionCaptureCopyFloats':0,'producerWorkCapUnchanged':637599,'copyGuardDelta':{'diagnostic':33,'production':16},'coreAdmission':{'diagnostic':189,'production':170},'adapterAdmission':{'diagnostic':{'off':378,'on':406},'production':{'off':351,'on':378}},'noNewShaderProfileCallbacks':True},'observerDeclarations':{'diagnosticFullDepthCaptureBytes':129600,'HDRObserverBytes':777600,'HDRRetainedInBothReplayModes':True,'productionCanaryMeaning':'No full-depth observer. HDR diagnostic observer still charged separately. Not a pure product-memory run.','fullDiagnosticActualCases':40,'noFullDepthActualCases':2,'fullNoDepthCaptureActual40Claim':False},'cases':{}}
 for mode in ('diagnostic','production'):
  contract['cases'][mode]={}
  for arm in ('off','on'):
   contract['cases'][mode][arm]={};root=B/f'actual-{arm}-001';frames=read(root/'COMPLETED.json')['frames'];frames=frames if mode=='diagnostic' else frames[:1]
   for f in frames:
    name=f['name'];row=read(str(root/name)+'.row.json');aa=read(str(root/name)+'.aa.json')
    guards=33 if mode=='diagnostic' else 16;core=189 if mode=='diagnostic' else 170;pairs=contract['workDeclarations']['adapterAdmission'][mode][arm];admission=core+pairs;capture=32400 if mode=='diagnostic' else 0
    changes={'.json':[{'path':['depthScratchBytes'],'baseline':7680,'candidate':8640}],'.row.json':[{'path':['adapterSpanPairs'],'baseline':row['adapterSpanPairs'],'candidate':pairs},{'path':['producerUsed',9],'baseline':row['producerUsed'][9],'candidate':row['producerUsed'][9]+guards},{'path':['producerUsed',10],'baseline':row['producerUsed'][10],'candidate':admission}]}
    if mode=='production':changes['.aa.json']=[{'path':['retainedOutputBytes'],'baseline':aa['retainedOutputBytes'],'candidate':64800}]
    work=sum(row['producerUsed'])+guards+admission-row['producerUsed'][10]+3840+capture;assert work<=637599
    side={'complete':True,'diagnosticCapture':mode=='diagnostic','scratchBytes':8640,'pendingCopyFloats':3840,'pendingCopyBytes':15360,'captureCopyFloats':capture,'captureCopyBytes':capture*4,'captureBufferBytes':capture*4,'reportBytes':24,'descriptorBytes':48,'producerWorkIncludingDepth':work}
    contract['cases'][mode][arm][name]={'changes':changes,'sidecar':side}
 write(C/'REPORT_CONTRACT.json',contract)
if __name__=='__main__':prepare()
