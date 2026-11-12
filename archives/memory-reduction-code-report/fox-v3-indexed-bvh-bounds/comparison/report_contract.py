"""Strict typed equality with predeclared JSON-pointer transitions only."""
import copy,json,math
from pathlib import Path
TIMING={'.json':['transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame'],'.background.json':['backgroundBuildNs'],'.row.json':['backgroundBuildNs']}
REPORTS=['.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json','.cache.json','.depth-stream.json']
RAW=['.u16le','.f32le','.snapshot','.targets.u8','.hdr.f64le']
def exact(a,b):
 if type(a) is not type(b):return False
 if isinstance(a,dict):return a.keys()==b.keys() and all(exact(a[k],b[k]) for k in a)
 if isinstance(a,list):return len(a)==len(b) and all(exact(x,y) for x,y in zip(a,b))
 return a==b

def read(path):
 def pairs(items):
  result={}
  for k,v in items:
   assert k not in result,('duplicate key',k)
   result[k]=v
  return result
 return json.loads(Path(path).read_text(),object_pairs_hook=pairs,parse_constant=lambda v:(_ for _ in ()).throw(AssertionError(v)))

def compare_reports(extension,baseline,candidate,contract_path,arm,name,mode):
 contract=read(contract_path)
 assert set(contract)=={'status','timing','cases','sidecarExtension','memoryDeclarations','workDeclarations','observerDeclarations','environmentByMode'}
 assert contract['status']=='FROZEN_REVIEWED_REPORT_CONTRACT'
 assert exact(contract['timing'],TIMING)
 assert extension in REPORTS and arm in ('off','on') and mode in ('diagnostic','production')
 case=contract['cases'][mode][arm][name];assert set(case)=={'changes','sidecar'}
 assert set(case['changes'])<=set(REPORTS)
 a=copy.deepcopy(baseline);b=copy.deepcopy(candidate);timings={};transitions=[]
 for key in TIMING.get(extension,[]):
  x=a.pop(key);y=b.pop(key)
  assert type(x) in (float,int) and type(y) in (float,int) and math.isfinite(x) and math.isfinite(y) and x>=0 and y>=0
  timings[key]={'baseline':x,'candidate':y}
 assert set(case['changes'])=={'.json'},'Only declared visibility scene bytes may change'
 rules=case['changes']['.json'];assert len(rules)==1
 rule=rules[0];assert set(rule)=={'path','baseline','candidate'} and rule['path']==['visibilitySceneBytes']
 assert type(rule['baseline']) is int and type(rule['candidate']) is int and 0<=rule['candidate']<=rule['baseline']
 if extension=='.json':
  assert rule['baseline']==baseline['visibilitySceneBytes']
  assert rule['candidate']==baseline['visibilitySceneBytes']-36*baseline['visibilitySceneNodes']
  assert exact(a['visibilitySceneBytes'],rule['baseline']) and exact(b['visibilitySceneBytes'],rule['candidate'])
  a['visibilitySceneBytes']=b['visibilitySceneBytes'];transitions.append(rule)
 assert exact(a,b),(extension,'undeclared or mistyped report difference',a,b)
 return {'descriptiveTiming':timings,'declaredNonTiming':transitions}

def compare_sidecar(report,contract_path,arm,name,mode):
 c=read(contract_path);assert c['status']=='FROZEN_REVIEWED_REPORT_CONTRACT'
 assert exact(report,c['cases'][mode][arm][name]['sidecar']),('sidecar mismatch',report)
 return True
