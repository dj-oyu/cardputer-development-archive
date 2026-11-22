"""Compare saved expression file to unmodified idle source, across the 7s loop."""
import bpy,sys,os,json
args=sys.argv[sys.argv.index('--')+1:]
b, v = map(os.path.abspath,args[:2])
def collect(path,names=None):
 bpy.ops.wm.open_mainfile(filepath=path)
 s=bpy.context.scene; rig=bpy.data.objects['Cloud_Rig']
 if names is None:names=sorted(o.name for o in s.objects if o.parent==rig and not o.name.startswith('Brow'))
 all_v={}
 for f in [1,54,74,113,169]:
  s.frame_set(f);dg=bpy.context.evaluated_depsgraph_get()
  for n in names:
   o=bpy.data.objects[n].evaluated_get(dg);m=o.to_mesh()
   all_v[(f,n)]=[o.matrix_world@v.co for v in m.vertices];o.to_mesh_clear()
 ct=bpy.data.objects.get('Cloud face controls')
 if ct:
  for i in range(5):
   ct['cloud_face_preset']=float(i);ct.update_tag();s.frame_set(74);bpy.context.view_layer.update()
   dg=bpy.context.evaluated_depsgraph_get()
   seen=[o.name for o in s.objects if o.name.startswith('Expression') and o.evaluated_get(dg).scale.length>.001]
   assert bool(seen)==(i!=0),(i,seen)
 return names,all_v
names,a=collect(b);_,z=collect(v,names)
assert all(len(a[k])==len(z[k]) for k in a)
delta=max((x-y).length for key in a for x,y in zip(a[key],z[key]))
assert delta<1e-5,delta
result={'source':os.path.basename(b),'tested':os.path.basename(v),'neutral_objects_compared':len(names),'frames':[1,54,74,113,169],'max_vertex_world_error':delta,'scope':'All original rig-parented geometry except authorized eyebrows. Face presets also reopened and switched at a mid-motion frame.'}
print(json.dumps(result),flush=True)
dest=os.path.join(os.path.dirname(v),'expression-preservation.json')
with open(dest,'w') as f:json.dump(result,f,indent=1)
