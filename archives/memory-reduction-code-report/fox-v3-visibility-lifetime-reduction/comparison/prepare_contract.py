"""Baseline-only preparation. Lifetime expectations require source/ledger review before freeze."""
from report_contract import read,TIMING
from run_fixed40 import B,C,write,base_root

def prepare():
 assert not (C/'REPORT_CONTRACT.json').exists(),'Never overwrite a declared contract'
 contract={'status':'DRAFT_NOT_RUNNABLE','timing':TIMING,'sidecarExtension':None,'environmentByMode':{'diagnostic':{},'production':{}},'memoryDeclarations':{'status':'AWAIT_AUTHOR_COMPILED_NAMED_LIFETIME_LEDGER','noInheritedStreamedDepthReductionClaim':True},'workDeclarations':{'producerWorkIncludingDepthCap':637599,'allExistingCountersExact':True,'noKernelChange':True},'observerDeclarations':{'diagnosticFullDepthCaptureBytes':129600,'productionFullDepthCaptureBytes':0,'HDRObserverBytes':777600,'HDRRetainedInBothReplayModes':True,'fullDiagnosticActualCases':40,'noFullDepthActualCases':2,'fullNoDepthCaptureActual40Claim':False},'cases':{}}
 for mode in ('diagnostic','production'):
  contract['cases'][mode]={}
  for arm in ('off','on'):
   frames=read(base_root(arm,mode)/'COMPLETED.json')['frames']
   contract['cases'][mode][arm]={f['name']:{'changes':{},'sidecar':None} for f in frames}
 write(C/'REPORT_CONTRACT.json',contract)
if __name__=='__main__':prepare()
