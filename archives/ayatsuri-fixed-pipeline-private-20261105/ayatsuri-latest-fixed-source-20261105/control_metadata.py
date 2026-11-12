import bpy,json,pathlib,sys
out=pathlib.Path(sys.argv[sys.argv.index('--')+1]);o=bpy.data.objects.get('Expression Controls');meta={}
for k in o.keys():
 if k=='_RNA_UI':continue
 try:u=o.id_properties_ui(k).as_dict()
 except TypeError:u={}
 meta[k]={'raw_value':o[k],'ui':u}
a=bpy.data.actions.get('Expression ControlsAction');curves=[]
if a:
 for f in a.fcurves:
  curves.append({'data_path':f.data_path,'array_index':f.array_index,'extrapolation':f.extrapolation,'keyframes':[{'co':list(k.co),'interpolation':k.interpolation,'easing':k.easing,'handle_left':list(k.handle_left),'handle_right':list(k.handle_right),'handle_left_type':k.handle_left_type,'handle_right_type':k.handle_right_type} for k in f.keyframe_points],'modifiers':[{'type':m.type,**{p:getattr(m,p) for p in ['mode_before','mode_after','cycles_before','cycles_after','use_restricted_range','frame_start','frame_end','mute','influence'] if hasattr(m,p)}} for m in f.modifiers]})
bounds=[]
for x in bpy.data.objects:
 if x.type=='MESH' and x.data.vertices:
  bounds.append({'object':x.name,'base_local_bounds':[[min(v.co[k] for v in x.data.vertices),max(v.co[k] for v in x.data.vertices)] for k in range(3)],'parent':x.parent.name if x.parent else None})
with out.open('x') as f:json.dump({'controls':meta,'action':{'name':a.name if a else None,'fcurves':curves},'base_local_bounds':bounds,'note':'UI limits are metadata, not input clamps. Raw base local bounds are not evaluated shader/sample coordinates.'},f,indent=2,allow_nan=False)
