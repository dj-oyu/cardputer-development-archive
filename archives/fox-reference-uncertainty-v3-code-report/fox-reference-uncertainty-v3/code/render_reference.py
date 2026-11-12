"""New v3 reference-only render; source is opened but never saved or exported."""
import bpy,sys,json,pathlib,hashlib,time
import numpy as np
from mathutils import Vector
ROOT=pathlib.Path(sys.argv[sys.argv.index('--')+1]).resolve();cfgpath=ROOT/'input/config.json';cfg=json.loads(cfgpath.read_text());ch=hashlib.sha256(cfgpath.read_bytes()).hexdigest()
def capture_settings(sc):
 return {'engine':sc.render.engine,'display':{k:getattr(sc.view_settings,k) for k in ['view_transform','look','exposure','gamma']},'cycles':{k:getattr(sc.cycles,k) for k in ['use_denoising','use_adaptive_sampling','adaptive_threshold','adaptive_min_samples','sample_clamp_direct','sample_clamp_indirect','blur_glossy','pixel_filter_type','filter_width','use_animated_seed']},'frame':sc.frame_current,'dither':sc.render.dither_intensity,'filmTransparent':sc.render.film_transparent,'colorDepth':sc.render.image_settings.color_depth,'colorMode':sc.render.image_settings.color_mode}
def capture_geometry(sc):
 bpy.context.view_layer.update()
 return {'cameraMatrix':[list(r) for r in sc.camera.matrix_world],'clip':[sc.camera.data.clip_start,sc.camera.data.clip_end],'orthoScale':sc.camera.data.ortho_scale,'resolution':[sc.render.resolution_x,sc.render.resolution_y,sc.render.resolution_percentage],'objects':[{'name':o.name,'hideRender':o.hide_render} for o in sc.objects if o.type in ('MESH','CURVE')]}
def sha(p):return hashlib.sha256(pathlib.Path(p).read_bytes()).hexdigest()
if sha(cfg['source'])!=cfg['sourceSHA256']:raise RuntimeError('source hash mismatch')
for name,h in cfg['frozenCode'].items():
 if sha(ROOT/name)!=h:raise RuntimeError('frozen code mismatch: '+name)
bpy.ops.wm.open_mainfile(filepath=cfg['source']);sc=bpy.context.scene
sc.render.resolution_x=240;sc.render.resolution_y=135;sc.render.resolution_percentage=100
sc.render.image_settings.file_format='PNG';sc.render.image_settings.color_mode='RGBA';sc.render.image_settings.color_depth='8'
sc.render.threads_mode='FIXED';sc.render.threads=8
sc.cycles.samples=2048
cam=sc.camera;cam.data.type='ORTHO';cam.data.ortho_scale=4.8*240/135
key=bpy.data.objects[cfg['keyLightName']];keyloc=key.location.copy();keyrot=key.rotation_euler.copy();energy=key.data.energy;target=Vector(cfg['keyTarget']);distance=(keyloc-target).length
background=sc.world.node_tree.nodes.get('Background');worldstrength=background.inputs[1].default_value
materials={m.name:tuple(m.node_tree.nodes.get('Principled BSDF').inputs['Base Color'].default_value) for m in bpy.data.materials if m.use_nodes and m.node_tree.nodes.get('Principled BSDF')}
invariant_settings=capture_settings(sc)
if invariant_settings!=cfg['expectedRenderInvariantSettings']:raise RuntimeError('source render invariant mismatch')
manifest={'renderInvariantSettings':invariant_settings,'version':cfg['version'],'configSHA256':ch,'sourceSHA256':cfg['sourceSHA256'],'images':[],'foreground':{}}
(ROOT/'images').mkdir(exist_ok=True)
for seed in cfg['seeds']:
 sc.cycles.seed=seed
 for case in cfg['scenarios']:
  key.location=keyloc;key.rotation_euler=keyrot;key.data.energy=energy*case.get('richEnergyScale',1);background.inputs[1].default_value=worldstrength*case.get('richWorldScale',1)
  if case['name']=='direction':
   key.location=target+Vector(case['blenderLight']).normalized()*distance;key.rotation_euler=(target-key.location).to_track_quat('-Z','Y').to_euler()
   if abs((key.location-target).length-distance)>1e-6*max(1,distance):raise RuntimeError('direction distance changed')
  for name,color in materials.items():bpy.data.materials[name].node_tree.nodes.get('Principled BSDF').inputs['Base Color'].default_value=tuple(min(1,x*case['albedoScale']) for x in color[:3])+(color[3],)
  for view in cfg['cameras']:
   cam.location=view['blenderLocation'];cam.rotation_euler=(Vector(view['blenderTarget'])-cam.location).to_track_quat('-Z','Y').to_euler()
   stem=f"images/seed-{seed}-{view['name']}-{case['name']}";png=ROOT/(stem+'.png');meta=ROOT/(stem+'.json')
   if capture_settings(sc)!=invariant_settings:raise RuntimeError('render setting drift')
   # Resume only already-complete render with matching config/metadata/PNG hash.
   prior=json.loads(meta.read_text()) if meta.exists() else None
   if not (prior and prior['configSHA256']==ch and png.exists() and prior['pngSHA256']==sha(png)):
    sc.render.filepath=str(png);start=time.monotonic();bpy.ops.render.render(write_still=True)
    prior={'seed':seed,'view':view['name'],'case':case['name'],'samplesMaximum':sc.cycles.samples,'threads':sc.render.threads,'configSHA256':ch,'pngSHA256':sha(png),'seconds':time.monotonic()-start,'keyTarget':list(target),'sourceKeyTargetDistance':distance,'actualKeyTargetDistance':(key.location-target).length,'albedoTargetMaterials':sorted(materials),'keyEnergy':key.data.energy,'keyLocation':list(key.location),'worldStrength':background.inputs[1].default_value,'albedoScale':case['albedoScale'],'blenderVersion':bpy.app.version_string,'geometry':capture_geometry(sc),'filmTransparent':sc.render.film_transparent,'invariantSettings':capture_settings(sc)}
    meta.write_text(json.dumps(prior,indent=2))
   manifest['images'].append({'seed':seed,'view':view['name'],'case':case['name'],'file':stem+'.png','sha256':sha(png),'metadata':stem+'.json','metadataSHA256':sha(meta)})
   (ROOT/'render-manifest.partial.json').write_text(json.dumps(manifest,indent=2))
# Separate fixed source-geometry alpha mask; never replaces the rich image.
# Reset source to avoid parameter-state leakage. No on-disk source modifications.
bpy.ops.wm.open_mainfile(filepath=cfg['source']);sc=bpy.context.scene;cam=sc.camera
sc.render.resolution_x=240;sc.render.resolution_y=135;sc.render.resolution_percentage=100
sc.render.threads_mode='FIXED';sc.render.threads=8;sc.cycles.samples=128;sc.cycles.seed=0;sc.cycles.use_adaptive_sampling=False
sc.render.film_transparent=True;bpy.data.objects['Studio ground'].hide_render=True
sc.render.image_settings.file_format='PNG';sc.render.image_settings.color_mode='RGBA';sc.render.image_settings.color_depth='8'
cam.data.type='ORTHO';cam.data.ortho_scale=4.8*240/135
for view in cfg['cameras']:
 cam.location=view['blenderLocation'];cam.rotation_euler=(Vector(view['blenderTarget'])-cam.location).to_track_quat('-Z','Y').to_euler()
 rel='images/foreground-'+view['name']+'.png';sc.render.filepath=str(ROOT/rel);bpy.ops.render.render(write_still=True)
 manifest['foreground'][view['name']]={'file':rel,'sha256':sha(ROOT/rel),'geometry':capture_geometry(sc),'contract':'source alpha>0; ground hidden; transparent; samples128 seed0 adaptiveOFF; fixed once for all cases/seeds'}
if sha(cfg['source'])!=cfg['sourceSHA256']:raise RuntimeError('source changed')
(ROOT/'render-manifest.json').write_text(json.dumps(manifest,indent=2))
print('REFERENCE_V3_COMPLETE',len(manifest['images']))
