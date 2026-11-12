import bpy,json,pathlib,collections
P=pathlib.Path('/workspace/scratch/6d8dcdbcdc54/fox-v3-contact-protected');S=P.parent/'fox-reference-sculpt-private/fox-reference-standing-editable.blend';bpy.ops.wm.open_mainfile(filepath=str(S));rows=[]
for name in ['Muzzle pad -1','Muzzle pad 1','Smile -1','Smile 1']:
 o=bpy.data.objects[name];d=o.data;r={'name':name,'type':o.type,'dataName':d.name,'modifiers':[{'name':m.name,'type':m.type} for m in o.modifiers],'worldMatrix':[list(row) for row in o.matrix_world]}
 if o.type=='MESH':
  r.update(vertices=len(d.vertices),edges=len(d.edges),polygons=len(d.polygons),polygonSizes=dict(collections.Counter(len(p.vertices) for p in d.polygons)),smoothPolygons=sum(p.use_smooth for p in d.polygons),hasCustomNormals=d.has_custom_normals);degrees=collections.Counter()
  for e in d.edges:
   for v in e.vertices:degrees[int(v)]+=1
  r['vertexValences']=dict(collections.Counter(degrees.values()));r['coordinateLevelCounts']={axis:len({round(v.co[i],7) for v in d.vertices}) for i,axis in enumerate(['x','y','z'])};r['zLevelPopulation']=dict(collections.Counter(round(v.co.z,7) for v in d.vertices))
 elif o.type=='CURVE':
  r.update(dimensions=d.dimensions,resolutionU=d.resolution_u,renderResolutionU=d.render_resolution_u,bevelDepth=d.bevel_depth,bevelResolution=d.bevel_resolution,fillMode=d.fill_mode,useFillCaps=d.use_fill_caps,splines=[])
  for s in d.splines:
   rr={'type':s.type,'cyclicU':s.use_cyclic_u,'resolutionU':s.resolution_u}
   if s.type=='BEZIER':rr['points']=[{'co':list(p.co),'handleLeft':list(p.handle_left),'handleRight':list(p.handle_right),'handleLeftType':p.handle_left_type,'handleRightType':p.handle_right_type,'radius':p.radius,'tilt':p.tilt} for p in s.bezier_points]
   else:rr['points']=[{'co':list(p.co),'radius':p.radius,'tilt':p.tilt} for p in s.points]
   r['splines'].append(rr)
 rows.append(r)
(P/'source-topology.json').write_text(json.dumps(rows,indent=2));print(json.dumps(rows,indent=2))
