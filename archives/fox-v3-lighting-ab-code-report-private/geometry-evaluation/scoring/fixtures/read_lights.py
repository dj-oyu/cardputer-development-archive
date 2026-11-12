import bpy,json,pathlib,sys,hashlib
from mathutils import Vector
R=pathlib.Path(__file__).resolve().parents[1];W=R.parent;cfg=json.loads((W/'fox-reference-uncertainty-v3/input/config.json').read_text());src=pathlib.Path(cfg['source']);assert hashlib.sha256(src.read_bytes()).hexdigest()==cfg['sourceSHA256'];bpy.ops.wm.open_mainfile(filepath=str(src));sc=bpy.context.scene;key=bpy.data.objects[cfg['keyLightName']];loc=key.location.copy();rot=key.rotation_euler.copy();energy=key.data.energy;target=Vector(cfg['keyTarget']);dist=(loc-target).length;bg=sc.world.node_tree.nodes['Background'];ws=bg.inputs[1].default_value
result={'sourceSHA256':cfg['sourceSHA256'],'refConfigSHA256':hashlib.sha256((W/'fox-reference-uncertainty-v3/input/config.json').read_bytes()).hexdigest(),'coordinates':'Blender world metres-like source units, no scale38 in physical function','cases':[]}
for case in cfg['scenarios']:
 key.location=loc;key.rotation_euler=rot;key.data.energy=energy*case.get('richEnergyScale',1)
 if case['name']=='direction':key.location=target+Vector(case['blenderLight']).normalized()*dist;key.rotation_euler=(target-key.location).to_track_quat('-Z','Y').to_euler()
 bpy.context.view_layer.update();lights=[]
 for obj in sc.objects:
  if obj.type!='LIGHT':continue
  assert obj.data.type=='AREA' and obj.data.shape=='DISK';assert obj.rotation_mode=='XYZ';assert obj.parent is None and all(abs(x-1)<1e-7 for x in obj.scale);assert abs(obj.data.spread-3.141592653589793)<1e-6;lights.append({'name':obj.name,'position':list(obj.location),'eulerXYZ':list(obj.rotation_euler),'diameter':obj.data.size,'power':obj.data.energy,'color':list(obj.data.color),'shape':obj.data.shape,'spread':obj.data.spread,'normalize':getattr(obj.data,'normalize',None),'rotationMode':obj.rotation_mode,'identityScale':list(obj.scale),'noParent':obj.parent is None,'normal':list(obj.matrix_world.to_3x3()@Vector((0,0,-1))),'tangentU':list(obj.matrix_world.to_3x3()@Vector((1,0,0))),'tangentV':list(obj.matrix_world.to_3x3()@Vector((0,1,0)))})
 assert len(lights)==3
 result['cases'].append({'name':case['name'],'lights':lights,'worldRGB':list(bg.inputs[0].default_value)[:3],'worldStrength':ws*case.get('richWorldScale',1)})
(R/'inputs/physical-source.json').write_text(json.dumps(result,indent=2));assert hashlib.sha256(src.read_bytes()).hexdigest()==cfg['sourceSHA256']
