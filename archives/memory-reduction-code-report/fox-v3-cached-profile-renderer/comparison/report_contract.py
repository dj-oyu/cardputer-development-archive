"""Fail-closed comparison of predeclared top-level timing and exact-value changes."""
import copy,json,math
TIMING={'.json':['transportBuildNs','visibilityBuildNs','appendNs','evaluateNs','hostRenderNsFirstFrame'],'.background.json':['backgroundBuildNs'],'.row.json':['backgroundBuildNs']}
REPORTS=['.json','.aa.json','.floor.json','.background.json','.row.json','.floor-world.json','.hdr-observer.json']
def compare_reports(extension,baseline,candidate,contract_path,arm):
 contract=json.loads(contract_path.read_text())
 assert contract['status']=='FROZEN_REVIEWED_REPORT_CONTRACT'
 assert contract['timing']==TIMING
 assert extension in REPORTS and arm in ('off','on')
 assert set(contract)=={'status','timing','exactChanges','rowAdmission'}
 assert set(contract['exactChanges'])<=set(REPORTS)
 old=copy.deepcopy(baseline);new=copy.deepcopy(candidate);deltas={}
 for key in TIMING.get(extension,[]):
  a=old.pop(key);b=new.pop(key)
  assert type(a) in (int,float) and type(b) in (int,float)
  assert math.isfinite(a) and math.isfinite(b) and a>=0 and b>=0
  deltas[key]={'baseline':a,'candidate':b}
 for key,rule in contract['exactChanges'].get(extension,{}).items():
  assert key not in TIMING.get(extension,[])
  assert set(rule)=={'baseline','candidate'}
  assert old[key]==rule['baseline'] and new[key]==rule['candidate'],(extension,key,old[key],new[key])
  deltas[key]={'baseline':old.pop(key),'candidate':new.pop(key)}
 if extension=='.row.json':
  rule=contract['rowAdmission'][arm]
  assert contract['rowAdmission']=={'off':{'adapterSpanPairs':[378,406],'producerAdmissionDelta':28,'producerAdmissionCap':1024},'on':{'adapterSpanPairs':[406,435],'producerAdmissionDelta':29,'producerAdmissionCap':1024}}
  assert [old['adapterSpanPairs'],new['adapterSpanPairs']]==rule['adapterSpanPairs']
  deltas['adapterSpanPairs']={'baseline':old.pop('adapterSpanPairs'),'candidate':new.pop('adapterSpanPairs')}
  a=old['producerUsed'];b=new['producerUsed']
  assert type(a) is list and type(b) is list and len(a)==len(b) and len(a)>10
  assert type(a[10]) is int and type(b[10]) is int and 0<=a[10]<=b[10]<=1024
  assert b[10]==a[10]+rule['producerAdmissionDelta']
  deltas['producerUsed[10]']={'baseline':a[10],'candidate':b[10]}
  a[10]=b[10]
 assert old==new,(extension,{k:(old.get(k),new.get(k)) for k in old.keys()|new.keys() if old.get(k)!=new.get(k)})
 return deltas

def validate_cache(report):
 """Exact cache sidecar schema; measured hits/misses are the only variable fields."""
 fixed={'complete':True,'cacheBytes':3224,'blobBytes':445248,'profileCalls':32400,'invalidations':0,'bindIndexEntries':4914,'bindValidatedRecords':4913,'coldPerFrame':True,'selectedVertexLookups':129600,'retainedSnapshotBytesUpper':1584}
 assert set(report)==set(fixed)|{'hits','misses'}
 for key,value in fixed.items():assert type(report[key]) is type(value) and report[key]==value,(key,report[key],value)
 assert type(report['hits']) is int and type(report['misses']) is int and report['hits']>=0 and report['misses']>=0
 assert report['hits']+report['misses']==129600
 return True
