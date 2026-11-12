import bpy,json,pathlib,struct,hashlib,collections
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');P=R/'fox-v3-lid-design';P.mkdir(exist_ok=True);S=R/'fox-reference-sculpt-private/fox-reference-standing-editable.blend';bpy.ops.wm.open_mainfile(filepath=str(S));rows=[]
for o in bpy.context.scene.objects:
 if not any(s in o.name.lower() for s in ['eyelid','eye socket']):continue
 d=o.data;r={'name':o.name,'type':o.type,'location':list(o.location),'matrixWorld':[list(x) for x in o.matrix_world],'modifiers':[{'name':m.name,'type':m.type} for m in o.modifiers],'materials':[m.name for m in d.materials]}
 if o.type=='CURVE':
  r.update(bevelDepth=d.bevel_depth,bevelResolution=d.bevel_resolution,resolutionU=d.resolution_u,useFillCaps=d.use_fill_caps,dimensions=d.dimensions,splines=[])
  for sp in d.splines:
   r['splines'].append({'type':sp.type,'cyclic':sp.use_cyclic_u,'points':[{'co':list(p.co),'left':list(p.handle_left),'right':list(p.handle_right),'leftType':p.handle_left_type,'rightType':p.handle_right_type,'radius':p.radius,'tilt':p.tilt} for p in sp.bezier_points] if sp.type=='BEZIER' else [{'co':list(p.co),'radius':p.radius,'tilt':p.tilt} for p in sp.points]})
 elif o.type=='MESH':r.update(vertices=len(d.vertices),polygons=len(d.polygons),polySizes=dict(collections.Counter(len(p.vertices) for p in d.polygons)),bbox=[list(v) for v in o.bound_box])
 rows.append(r)
b=(R/'fox-v3-eye-local-lod/eye-B.glb').read_bytes();n=struct.unpack_from('<I',b,12)[0];g=json.loads(b[20:20+n]);current=[]
for node in g['nodes']:
 if not any(s in node.get('name','').lower() for s in ['eyelid','eye socket']):continue
 p=g['meshes'][node['mesh']]['primitives'][0];current.append({'name':node['name'],'vertices':g['accessors'][p['attributes']['POSITION']]['count'],'triangles':g['accessors'][p['indices']]['count']//3,'material':g['materials'][p['material']]})
(P/'source-and-current.json').write_text(json.dumps({'sourceSha256':hashlib.sha256(S.read_bytes()).hexdigest(),'objects':rows,'eyeB':current},indent=2));print(json.dumps({'source':rows,'current':current},indent=2))
