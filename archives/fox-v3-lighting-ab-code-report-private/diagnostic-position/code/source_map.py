import bpy,json,pathlib,sys,hashlib,numpy as np
from mathutils import Vector
R=pathlib.Path(sys.argv[sys.argv.index('--')+1]).resolve();cfg=json.loads((R.parent/'fox-reference-uncertainty-v3/input/config.json').read_text());bpy.ops.wm.open_mainfile(filepath=cfg['source']);sc=bpy.context.scene
bpy.data.objects['Studio ground'].hide_render=True;bpy.data.objects['Studio ground'].hide_set(True)
objects=sorted(o.name for o in sc.objects if o.type in ('MESH','CURVE') and not o.hide_render);ids={name:i for i,name in enumerate(objects)}
sc.render.resolution_x=240;sc.render.resolution_y=135;sc.render.resolution_percentage=100;cam=sc.camera;cam.data.ortho_scale=4.8*240/135
for view in cfg['cameras']:
 cam.location=view['blenderLocation'];cam.rotation_euler=(Vector(view['blenderTarget'])-cam.location).to_track_quat('-Z','Y').to_euler();bpy.context.view_layer.update();deps=bpy.context.evaluated_depsgraph_get();M=cam.matrix_world;right=M.to_3x3()@Vector((1,0,0));up=M.to_3x3()@Vector((0,1,0));forward=M.to_3x3()@Vector((0,0,-1))
 oid=np.full((135,240),-1,np.int32);pos=np.full((135,240,3),np.nan);ng=pos.copy()
 for y in range(135):
  for x in range(240):
   origin=cam.location+right*((x+.5-120)/240*cam.data.ortho_scale)+up*((67.5-y-.5)/135*4.8)
   hit,p,n,face,obj,mat=sc.ray_cast(deps,origin,forward,distance=100)
   if hit and obj.name in ids:oid[y,x]=ids[obj.name];pos[y,x]=p;ng[y,x]=n
 np.savez_compressed(R/(view['name']+'-source-map.npz'),object=oid,position=pos,normalGeometric=ng)
(R/'source-object-map.json').write_text(json.dumps({'objects':objects,'sourceSHA256':hashlib.sha256(pathlib.Path(cfg['source']).read_bytes()).hexdigest(),'contract':'Diagnostic pixel-center primary ray, source evaluated geometry; no AA; source object attribution only, does not replace fixed foreground or reference. Ground excluded. Pixel centers i+.5.'},indent=2))
