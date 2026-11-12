import bpy,json,pathlib
from mathutils import Vector,Matrix
R=pathlib.Path(__file__).resolve().parent;P=R.parent/'fox-cardputer-latest-private/fox-cardputer-2k-v2.blend';spec=json.load(open(R/'mask-spec.json'))
views=[('neutral','front',(0,-8,2.7)),('neutral','oblique',(-4,-8,2.8)),('neutral','profile',(-7,-4,2.8)),('smile','front',(0,-8,2.7)),('worried','front',(0,-8,2.7)),('stern','front',(0,-8,2.7))]
allinfo=[]
for mode in ['3d-lines','2d-ink']:
 bpy.ops.wm.open_mainfile(filepath=str(P));s=bpy.context.scene;s.frame_set(1);c=bpy.data.objects['Expression Controls'];c.animation_data_clear();defaults={k:c[k] for k in c.keys() if k!='_RNA_UI'};texnodes={}
 if mode=='2d-ink':
  for o in list(s.objects):
   if o.name.startswith(('Brow •','Smile ','Philtrum')):bpy.data.objects.remove(o,do_unlink=True)
  proj=bpy.data.objects.new('Face Ink Projection (head attached)',None);s.collection.objects.link(proj);proj.parent=bpy.data.objects['Head Pivot • driven'];proj.matrix_parent_inverse=proj.parent.matrix_world.inverted();proj.matrix_basis=Matrix.Identity(4)
  inkcolors={}
  for g,matname in [('brow','Deep cocoa • socks and ear rims'),('mouth','Deep cocoa • socks and ear rims')]:
   mat=bpy.data.materials.get(matname);p=next((n for n in mat.node_tree.nodes if n.type=='BSDF_PRINCIPLED'),None) if mat else None;inkcolors[g]=tuple(p.inputs['Base Color'].default_value) if p else (.025,.009,.004,1)
  for o in s.objects:
   group='brow' if o.name.startswith('Anatomy') else 'mouth' if o.name.startswith(('Muzzle pad','Muzzle • ivory chin','Muzzle • projecting')) else None
   if not group:continue
   texnodes.setdefault(group,[])
   for mi,original in enumerate(list(o.data.materials)):
    if original is None:continue
    mat=original.copy();mat.name='2D ink receiver '+o.name+' '+str(mi);o.data.materials[mi]=mat;nt=mat.node_tree;n=nt.nodes;l=nt.links;bsdf=next((x for x in n if x.type=='BSDF_PRINCIPLED'),None)
    if not bsdf:continue
    coord=n.new('ShaderNodeTexCoord');coord.object=proj;xyz=n.new('ShaderNodeSeparateXYZ');l.new(coord.outputs['Object'],xyz.inputs[0])
    def op(operation,a,b):
     x=n.new('ShaderNodeMath');x.operation=operation
     if hasattr(a,'is_output'):l.new(a,x.inputs[0])
     else:x.inputs[0].default_value=a
     if hasattr(b,'is_output'):l.new(b,x.inputs[1])
     else:x.inputs[1].default_value=b
     return x.outputs[0]
    x0,x1,z0,z1=spec['regions'][group];u=op('MULTIPLY',op('SUBTRACT',xyz.outputs['X'],x0),1/(x1-x0));v=op('MULTIPLY',op('SUBTRACT',xyz.outputs['Z'],z0),1/(z1-z0));comb=n.new('ShaderNodeCombineXYZ');l.new(u,comb.inputs[0]);l.new(v,comb.inputs[1]);tex=n.new('ShaderNodeTexImage');tex.extension='CLIP';tex.interpolation='Linear';l.new(comb.outputs[0],tex.inputs['Vector']);texnodes[group].append(tex)
    gate=op('LESS_THAN',xyz.outputs['Y'],-.45 if group=='brow' else -.85);mask=op('MULTIPLY',tex.outputs['Color'],gate)
    mix=n.new('ShaderNodeMixRGB');mix.blend_type='MIX';l.new(mask,mix.inputs[0]);mix.inputs[2].default_value=inkcolors[group]
    if bsdf.inputs['Base Color'].is_linked:l.new(bsdf.inputs['Base Color'].links[0].from_socket,mix.inputs[1])
    else:mix.inputs[1].default_value=bsdf.inputs['Base Color'].default_value[:]
    l.new(mix.outputs[0],bsdf.inputs['Base Color'])
  s['Face Ink Prototype']='Four selected expression masks from latest source. Head-attached receiver-local projection. Not all continuous control combinations implemented; not device runtime.'
 for state,view,loc in views:
  for k,v in defaults.items():c[k]=v
  for k,v in spec['states'][state].items():c[k]=v
  c.update_tag();bpy.context.view_layer.update()
  if mode=='2d-ink':
   for g,nodes in texnodes.items():
    image=bpy.data.images.load(str(R/f'{g}-{state}-mask.png'),check_existing=True);image.colorspace_settings.name='Non-Color'
    for n in nodes:n.image=image
  cam=s.camera;cam.location=loc;cam.rotation_euler=(Vector((0,-.38,2.56))-cam.location).to_track_quat('-Z','Y').to_euler();cam.data.type='ORTHO';cam.data.ortho_scale=2
  s.render.engine='CYCLES';s.cycles.samples=32;s.cycles.use_denoising=False;s.render.resolution_x=480;s.render.resolution_y=400;s.render.resolution_percentage=100;s.render.film_transparent=True;s.render.image_settings.color_mode='RGBA';bpy.data.objects['Studio ground'].hide_render=True
  s.render.filepath=str(R/f'{mode}-{state}-{view}.png');bpy.ops.render.render(write_still=True);print('RENDERED',mode,state,view,flush=True)
  if mode=='2d-ink' and state=='neutral' and view=='front':
   for i in bpy.data.images:
    if i.source=='FILE':i.pack()
   bpy.ops.wm.save_as_mainfile(filepath=str(R/'fox-2d-brows-mouth-prototype.blend'),compress=True)
 allinfo.append({'mode':mode,'objects':[o.name for o in s.objects if o.type=='MESH' and not o.hide_render]})
(R/'prototype-settings.json').write_text(json.dumps({'input':str(P),'states':spec['states'],'views':views,'modes':allinfo,'scope':'Visual prototype only. 3D muzzle pads and their Smile deformation remain. No source mutation, public sharing or device action.'},ensure_ascii=False,indent=2))
