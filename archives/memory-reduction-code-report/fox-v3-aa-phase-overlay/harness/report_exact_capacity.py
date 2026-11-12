"""Read-only aggregation of indexed-storage evidence; never renders."""
from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parents[1];BASE=R.parent/'fox-v3-bvh-node-capacity';O=R/'actual-001';complete=json.loads((O/'COMPLETED.json').read_text());assert complete['status']=='ALL20_EXACT_COMPLETE' and len(complete['frames'])==20
rows=[]
for f in complete['frames']:
 n=f['name'];new=json.loads((O/(n+'.json')).read_text());old=json.loads((BASE/'actual-001'/(n+'.json')).read_text());aa=json.loads((O/(n+'.aa.json')).read_text());r=json.loads((O/(n+'.row.json')).read_text());floor=json.loads((O/(n+'.floor.json')).read_text());bg=json.loads((O/(n+'.background.json')).read_text())
 physical=['shadeUpdates','diskSamples','visibilityRays','visibilityNodeVisits','visibilityTriangleTests','transportRays','transportNodeVisits','transportTriangleTests','primary_ground_hits','primary_ground_reflection_hits','primary_ground_direct_queries'];assert all(new[k]==old[k] for k in physical)
 rows.append({'case':n,'RGB565DepthMaskSnapshotExact':f['exactRGB565DepthMaskSnapshot'],'allRuntimeReportsAndQuotasExactExceptBytesAndTimings':f['allRuntimeCountersAndQuotasExact'],'sceneBytes':f['sceneBytes'],'physicalCounters':{k:new[k] for k in physical},'AAObserved':aa['observedTotal'],'AAReserved':aa['reservedTotal'],'floorWork':floor['usedTotal'],'backgroundWork':bg['resolver']['used'],'displayProducer':sum(r['producerUsed']),'hostHashBytes':r['hostFinishHashBytes']})
memory=json.loads((R/'ADAPTER_MEMORY.json').read_text());memory['actualFrames']=20
x={'status':'ALL20_EXACT_STORAGE_V3_COMPLETE','frames':rows,'visibilityStorageAdmission':'Explicit opt-in v3; shared original vertices, compact index records and build-only temporary bounds; persistent max_bytes semantics documented and old baseline unchanged','runtimeCountChanges':0,'unchangedHardCaps':{'triangles':2048,'nodes':4095,'sceneBytes':524288,'AA':8000000,'display':637599,'hostHash':73728},'memory':memory,'noElapsedSpeedupClaim':True,'noTargetFitClaim':True,'notPR117Integrated':True,'completionSHA256':hashlib.sha256((O/'COMPLETED.json').read_bytes()).hexdigest()}
(R/'ACTUAL_OPERATION_MEMORY_COST.json').write_text(json.dumps(x,indent=2)+'\n');print(x['status'])
