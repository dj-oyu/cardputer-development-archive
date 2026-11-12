import bpy,json,pathlib
R=pathlib.Path(__file__).resolve().parent;src=R.parent/'latest-fox-source-readonly/fox-bubble-bold.blend';bpy.ops.wm.open_mainfile(filepath=str(src));s=bpy.context.scene;s.frame_set(1);c=bpy.data.objects['Expression Controls'];c.animation_data_clear();default={k:c[k] for k in c.keys() if k!='_RNA_UI'}
states={'neutral':{},'smile':{'Smile':1,'Brow Raise':.7},'worried':{'Brow Style':1},'stern':{'Brow Style':2,'Brow Furrow':.6}}
out={}
for name,vals in states.items():
 for k,v in default.items():c[k]=v
 for k,v in vals.items():c[k]=v
 c.update_tag();bpy.context.view_layer.update();dep=bpy.context.evaluated_depsgraph_get();groups={'brow':[],'mouth':[]}
 for o in s.objects:
  group='brow' if o.name.startswith('Brow •') else 'mouth' if o.name.startswith(('Smile ','Philtrum')) else None
  if not group:continue
  e=o.evaluated_get(dep);m=e.to_mesh();m.calc_loop_triangles();groups[group].extend([[[float(v) for v in o.matrix_world@m.vertices[i].co] for i in t.vertices] for t in m.loop_triangles]);e.to_mesh_clear()
 out[name]={'controls':vals,**groups}
(R/'source-projected-strokes.json').write_text(json.dumps(out,separators=(',',':')));print('STROKES',[(n,len(v['brow']),len(v['mouth'])) for n,v in out.items()])
