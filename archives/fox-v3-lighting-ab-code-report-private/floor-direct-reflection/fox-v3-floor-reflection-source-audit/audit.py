from pathlib import Path
import json,hashlib
R=Path(__file__).resolve().parent.parent;D=Path(__file__).resolve().parent;sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();p=R/'fox-v3-ground-transport/ground-source-metadata.json';m=json.loads(p.read_text());pins={str(p.relative_to(R)):sha(p)}
for rel in ['fox-reference-sculpt-private/fox-reference-standing-editable.blend','fox-reference-uncertainty-v3/input/config.json','fox-reference-uncertainty-v3/code/render_reference.py']:
 q=R/rel;h=sha(q);assert h==m['pins'][str(q)];pins[rel]=h
assert m['sourceSHA256']==pins['fox-reference-sculpt-private/fox-reference-standing-editable.blend'];assert m['referenceConfigSHA256']==pins['fox-reference-uncertainty-v3/input/config.json'];state=m['materialState'];assert state['links']==[['Principled BSDF','BSDF','Material Output','Surface']];rows=[]
for q in sorted((R/'fox-reference-uncertainty-v3/images').glob('seed-*-albedo.json')):
 z=json.loads(q.read_text());assert z['albedoScale']==.6 and 'Warm studio backdrop' in z['albedoTargetMaterials'];assert z['sourceSHA256']==m['sourceSHA256'] if 'sourceSHA256' in z else z['configSHA256']==m['referenceConfigSHA256'];pins[str(q.relative_to(R))]=sha(q);rows.append({'view':z['view'],'seed':z['seed'],'scale':z['albedoScale'],'groundIncluded':True})
assert len(rows)==16
out={'sourceSHA256':m['sourceSHA256'],'referenceConfigSHA256':m['referenceConfigSHA256'],'sourceGroundMaterialState':state,'sourceGroundVisibility':m['objectFlags'],'linearLe':m['linearLe'],'scenarioMaterialValues':m['scenarios'],'albedoMetadataChecks':rows,'originalSourceAndConfigHashesMatchPreviousAudit':True,'pins':pins,'scope':'Existing stored material/scenario evidence only; no scene rerender/edit. No geometry arrays included. Internal socket Weight is preserved evidence, not interpreted as surface diffuse BSDF strength.'};(D/'summary.json').write_text(json.dumps(out,indent=2));print('PASS',len(rows))
