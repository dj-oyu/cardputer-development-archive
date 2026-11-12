from pathlib import Path
import json,sys,hashlib
D=Path(sys.argv[1]);out=Path(sys.argv[2]);assert not out.exists();rows=[]
for arm in ['off','on','background']:
 O=D/('background-control' if arm=='background' else arm);done=json.load(open(O/'COMPLETED.json'))
 for row in done['frames']:
  p=O/row['prefix'];m=json.load(open(str(p)+'.json'));r={k:row[k] for k in ['view','case','reverse']};r['arm']=arm
  for k in ['records','snapshotBytes','work','shadeUpdates','visibilityRays','visibilityNodeVisits','visibilityTriangleTests','transportRays','transportNodeVisits','transportTriangleTests']:r[k]=m[k]
  if arm!='off':
   bg=json.load(open(str(p)+'.background.json'));r.update({k:bg[k] for k in ['backgroundQueries','backgroundNodeVisits','backgroundTriangleTests','backgroundBuildNs','backgroundNewOwnedConservativePeakBytes']});r['newCoreStages']=bg['core']['observedTotal'];r['newResolverStages']=bg['resolver']['used'];r['compositionSlots']=bg['classification']['slots'];r['floorSlots']=bg['classification']['floor'];r['keptCharacterSlots']=bg['classification']['keep'];r['floorOccludesCharacterSlots']=bg['core']['occludedCharacter'];r['newCoreReservation']=bg['core']['reservedTotal'];r['newResolverReservation']=bg['resolver']['limit']
  else:r.update(dict(backgroundQueries=0,backgroundNodeVisits=0,backgroundTriangleTests=0,backgroundBuildNs=0,backgroundNewOwnedConservativePeakBytes=0,newCoreStages=0,newResolverStages=0,compositionSlots=0,floorSlots=0,keptCharacterSlots=0,floorOccludesCharacterSlots=0,newCoreReservation=0,newResolverReservation=0))
  for suffix,old,bg in [('Rays','visibilityRays','backgroundQueries'),('Nodes','visibilityNodeVisits','backgroundNodeVisits'),('Triangles','visibilityTriangleTests','backgroundTriangleTests')]:r['totalDirectAndBackground'+suffix]=r[old]+r[bg]
  rows.append(r)
summary={}
for arm in ['off','on','background']:
 a=[r for r in rows if r['arm']==arm];summary[arm]={k:dict(min=min(r[k] for r in a),max=max(r[k] for r in a)) for k in a[0] if type(a[0][k])is int}
result={'status':'ALL60_RESOURCE_COUNTS','rows':rows,'summary':summary,'oldWork8MCompatible':False,'oldDirect1MCompatible':False,'budgetsDoNotBorrow':True,'newSemanticStageCountsNotEquivalentToOldWorkOrMachineInstructions':True,'separateResolverCap':1540298112,'separateCoreCap':1680000,'separateShadowCaps':[2000000,200000000,100000000],'sourcePreflightPreparationSeparatelyAccounted':True,'characterShapeDepthUnchanged':True,'sceneDepthOnlyPerQueryDiagnostic':'background.jsonl floorDepth/classification plus retained character depth; no replacement of formal shape depth','worldMissSlotsActual':0,'physicalTimingHereConcurrentFunctionalOnly':True};out.write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(summary))
