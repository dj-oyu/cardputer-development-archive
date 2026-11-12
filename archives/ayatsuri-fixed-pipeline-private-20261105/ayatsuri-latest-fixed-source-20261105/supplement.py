import bpy,json,pathlib,sys,hashlib,struct
out=pathlib.Path(sys.argv[sys.argv.index('--')+1]);result={'curves':[],'node_specific':[],'color_attributes':[],'shrinkwrap':[]}
for o in bpy.data.objects:
 if o.type=='CURVE':
  d=o.data;result['curves'].append({'name':o.name,'dimensions':d.dimensions,'resolution_u':d.resolution_u,'render_resolution_u':d.render_resolution_u,'bevel_depth':d.bevel_depth,'bevel_resolution':d.bevel_resolution,'extrude':d.extrude,'fill_mode':d.fill_mode,'materials':[m.name if m else None for m in d.materials],'splines':[{'type':s.type,'bezier_points':len(s.bezier_points),'points':len(s.points),'cyclic':s.use_cyclic_u} for s in d.splines]})
 if o.type=='MESH':
  for a in o.data.color_attributes:
   colors=[list(v.color) for v in a.data];result['color_attributes'].append({'object':o.name,'name':a.name,'domain':a.domain,'type':a.data_type,'count':len(colors),'min_linear':[min(c[k] for c in colors) for k in range(4)],'max_linear':[max(c[k] for c in colors) for k in range(4)],'float32_rgba_sha256':hashlib.sha256(b''.join(struct.pack('<4f',*c) for c in colors)).hexdigest()})
 for m in o.modifiers:
  if m.type=='SHRINKWRAP':result['shrinkwrap'].append({'object':o.name,'target':m.target.name if m.target else None,'wrap_method':m.wrap_method,'wrap_mode':m.wrap_mode,'offset':m.offset})
for m in bpy.data.materials:
 if not m.node_tree:continue
 for n in m.node_tree.nodes:
  if n.type=='VERTEX_COLOR':result['node_specific'].append({'material':m.name,'node':n.name,'type':n.bl_idname,'layer_name':n.layer_name})
  if n.type=='VALTORGB':result['node_specific'].append({'material':m.name,'node':n.name,'type':n.bl_idname,'color_mode':n.color_ramp.color_mode,'interpolation':n.color_ramp.interpolation,'hue_interpolation':n.color_ramp.hue_interpolation,'elements':[{'position':e.position,'color':list(e.color)} for e in n.color_ramp.elements]})
with out.open('x') as f:json.dump(result,f,indent=2,allow_nan=False)
print('SUPPLEMENT_COMPLETE')
