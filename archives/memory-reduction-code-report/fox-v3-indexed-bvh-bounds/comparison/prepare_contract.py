"""Predeclare compiled node-size transition from retained baseline only; never candidate outputs."""
from report_contract import read,TIMING
from run_fixed40 import B,C,write,base_root

def prepare():
 assert not (C/'REPORT_CONTRACT.json').exists()
 contract={'status':'DRAFT_NOT_RUNNABLE','timing':TIMING,'sidecarExtension':None,'environmentByMode':{'diagnostic':{},'production':{}},'memoryDeclarations':{'status':'AWAIT_COMPILED_REVIEWED_INDEXED_BOUNDS_LEDGER','baselineNodeBytes':64,'candidateNodeBytes':28,'sceneHeaderBytes':96,'xyzBytesPerVertex':24,'triangleBytes':8,'nodeBytesSaved':36},'workDeclarations':{'producerWorkIncludingDepthCap':637599,'allExistingCountersExact':True,'logicalBoundsBitwiseEqual':True,'sameTreeAndSortedTriangleIDs':True,'noQuantization':True},'observerDeclarations':{'diagnosticFullDepthCaptureBytes':129600,'productionFullDepthCaptureBytes':0,'HDRObserverBytes':777600,'HDRRetainedInBothReplayModes':True,'fullDiagnosticActualCases':40,'noFullDepthActualCases':2,'fullNoDepthCaptureActual40Claim':False},'cases':{}}
 for mode in ('diagnostic','production'):
  contract['cases'][mode]={}
  for arm in ('off','on'):
   root=base_root(arm,mode);cases={}
   for f in read(root/'COMPLETED.json')['frames']:
    name=f['name'];r=read(str(root/name)+'.json');old=r['visibilitySceneBytes'];nodes=r['visibilitySceneNodes'];vertices=r['visibilityVertices'];triangles=r['visibilityTriangles']
    assert r['visibilityEnabled'] is True
    assert old==96+24*vertices+8*triangles+64*nodes
    new=96+24*vertices+8*triangles+28*nodes
    cases[name]={'changes':{'.json':[{'path':['visibilitySceneBytes'],'baseline':old,'candidate':new}]},'sidecar':None}
   contract['cases'][mode][arm]=cases
 write(C/'REPORT_CONTRACT.json',contract)
if __name__=='__main__':prepare()
