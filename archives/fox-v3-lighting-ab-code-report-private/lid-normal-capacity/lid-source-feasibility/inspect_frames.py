import bpy,pathlib,json,hashlib
R=pathlib.Path('/workspace/scratch/6d8dcdbcdc54');S=R/'fox-reference-sculpt-private/fox-reference-standing-editable.blend';before=hashlib.sha256(S.read_bytes()).hexdigest();bpy.ops.wm.open_mainfile(filepath=str(S));out=[]
for side in [-1,1]:
 o=bpy.data.objects[f'Upper eyelid {side}'];d=o.data;props=['twist_mode','twist_smooth','bevel_mode','bevel_depth','bevel_resolution','use_fill_caps','resolution_u','render_resolution_u','resolution_v','fill_mode','offset','extrude','taper_radius_mode','bevel_factor_start','bevel_factor_end','bevel_factor_mapping_start','bevel_factor_mapping_end'];r={k:getattr(d,k,None) for k in props};r.update(name=o.name,bevelObject=d.bevel_object.name if d.bevel_object else None,taperObject=d.taper_object.name if d.taper_object else None);out.append(r)
assert hashlib.sha256(S.read_bytes()).hexdigest()==before;(R/'fox-v3-lid-design/source-frames.json').write_text(json.dumps(out,indent=2));print(json.dumps(out,indent=2))
