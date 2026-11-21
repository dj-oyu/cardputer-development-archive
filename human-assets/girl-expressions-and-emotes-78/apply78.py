"""Install four packed expression atlases into the existing face node tree."""
import bpy,os,json
from pathlib import Path
P=Path(__file__).resolve().parent
s=bpy.context.scene
r=next(o for o in s.objects if o.type=='ARMATURE')
body=s.objects['Sculpted cheeks, jaw and cranium']
m=body.data.materials[0];T=m.node_tree;ns=T.nodes;ls=T.links
a=ns['Image Texture']
assert a.image.name=='Packed face neutral larger eyes'
assert r.get('Face Blink') is not None and r.get('Face Smile') is not None
assert 'Face Expression' not in r
assert [l.from_node.name for l in ns['Mix (Legacy).001'].inputs[1].links]==['Image Texture']
# Keep the original shape and all legacy blink/smile independent overrides.
r['Face Expression']=0
r.id_properties_ui('Face Expression').update(min=0,max=4,soft_min=0,soft_max=4,
 description='0 Neutral • 1 Worried / 困り • 2 Surprised / びっくり • 3 Comic dots + ε • 4 Sleepy / 眠い. Legacy Blink and Smile are still independent.')
frame=ns.new('NodeFrame');frame.name='Face Expression Atlas Select';frame.label='FACE EXPRESSIONS – 0 Neutral · 1 困り · 2 驚き · 3 ε · 4 眠い'
frame.location=(a.location.x-900,a.location.y-800)
frame.use_custom_color=True;frame.color=(.27,.16,.12)
def node(kind,name,x,y):
 o=ns.new(kind);o.name=name;o.label=name;o.parent=frame;o.location=(x,y);return o
sel=node('ShaderNodeValue','Face Expression Selector',0,0)
fc=sel.outputs[0].driver_add('default_value');dr=fc.driver
dr.type='AVERAGE';v=dr.variables.new();v.name='expression';v.type='SINGLE_PROP';v.targets[0].id=r;v.targets[0].data_path='["Face Expression"]'
prev=a.outputs['Color'];pa=a.outputs['Alpha']
uv=ns['UV Map'].outputs['UV']
for i,name in enumerate(('worried','surprised','gag','sleepy'),1):
 # Explicitly verify and pack source atlas before replacing nodes.
 f=P/'assets'/('face-'+name+'.png');assert f.is_file()
 img=bpy.data.images.load(str(f),check_existing=True);assert img.size[:]==(1024,1024)
 img.name='Packed face expression '+name
 img.pack();img.filepath='//face-'+name+'.png';img.colorspace_settings.name=a.image.colorspace_settings.name
 tx=node('ShaderNodeTexImage','Expression '+str(i)+' '+name,105+430*i,-400)
 tx.image=img;tx.interpolation=a.interpolation;tx.extension=a.extension;tx.projection=a.projection
 ls.new(uv,tx.inputs['Vector'])
 cond=node('ShaderNodeMath','Select '+str(i),100+430*i,0);cond.operation='COMPARE'
 cond.inputs[1].default_value=float(i);cond.inputs[2].default_value=.10
 ls.new(sel.outputs[0],cond.inputs[0])
 mux=node('ShaderNodeMixRGB','Expression RGB '+str(i),310+430*i,0)
 ls.new(cond.outputs[0],mux.inputs[0]);ls.new(prev,mux.inputs[1]);ls.new(tx.outputs['Color'],mux.inputs[2]);prev=mux.outputs[0]
 aa=node('ShaderNodeMix','Expression alpha '+str(i),310+430*i,-200)
 aa.data_type='FLOAT';aa.clamp_factor=True
 ls.new(cond.outputs[0],aa.inputs[0]);ls.new(pa,aa.inputs[2]);ls.new(tx.outputs['Alpha'],aa.inputs[3]);pa=aa.outputs[0]
ls.new(prev,ns['Mix (Legacy).001'].inputs[1]);ls.new(pa,ns['Mix'].inputs[2])
s['v78_face_expression_instructions']='Rig > Custom Properties > Face Expression: 0 Neutral, 1 Worried, 2 Surprised, 3 Comic dot eyes + ε, 4 Sleepy. Face Blink and Face Smile are unmodified independent masks. Packed maps, same face UV. Zero new objects or faces.'
path=os.getenv('FACE_OUTPUT',str(P/'chair-face-expressions-v78.blend'))
bpy.context.view_layer.update();bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=path,compress=True)
