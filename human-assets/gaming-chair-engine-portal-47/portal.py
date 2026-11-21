"""Replace the three physical cards by a back-only, ray-projected shallow-surface portal."""
import bpy,sys
from pathlib import Path
out=Path(sys.argv[-1]).resolve()
chair=bpy.data.collections['Gaming Chair Prop']
layers={k:next(o for o in chair.objects if o.name.startswith(k)) for k in ['Parallax • cavity far','Parallax • engine cover','Parallax • foreground headers']}
def get_image(o):
    img=next(n.image for n in o.data.materials[0].node_tree.nodes if n.type=='TEX_IMAGE')
    assert img.packed_file is not None
    return img
imgs=list(map(get_image,layers.values()))
far=next(iter(layers.values()))
for o in list(layers.values())[1:]:
    bpy.data.objects.remove(o,do_unlink=True)
far.name="Rear aperture · virtual engine room"
m=bpy.data.materials.new('Engine bay · rear-only parallax portal');m.use_nodes=True
far.data.materials.clear();far.data.materials.append(m)
nt=m.node_tree;nt.nodes.clear()
def node(typ,label,loc):
    n=nt.nodes.new(typ);n.label=label;n.location=loc
    return n
def apply(x,d):
    if hasattr(x,'node'): nt.links.new(x,d)
    else:d.default_value=x
def math(op,a,b,xy,label=''):
    n=node('ShaderNodeMath',label,xy);n.operation=op;apply(a,n.inputs[0]);apply(b,n.inputs[1]);return n.outputs[0]
def separate(v,xy,label=''):
    n=node('ShaderNodeSeparateXYZ',label,xy);apply(v,n.inputs[0]);return tuple(n.outputs[:3])
geo=node('ShaderNodeNewGeometry','Trace a ray only in shading',(-1200,120))
tex=node('ShaderNodeTexCoord','Physical surface UV',(-1200,420))
ix,iy,iz=separate(geo.outputs['Incoming'],(-1010,100))
u,v,_=separate(tex.outputs['UV'],(-1010,410))
# Rear normal is proportional to (0, 1, -0.285); the reference UV increases along -X,+Z.
# Intersection with plane at y - .285*z reduced by depth d: delta x,z = -d*incoming/(iy-.285*iz).
den=math('MAXIMUM',math('SUBTRACT',iy,math('MULTIPLY',.285,iz,(-830,-180)),(-630,-70)),.24,(-430,-70),'Guard near-grazing division')
rx=math('DIVIDE',ix,den,(-200,140))
rz=math('DIVIDE',iz,den,(-200,-80))
def lookup(img,depth,spread,j):
    y=480-j*360
    def shift(p,r,k,xpos):
        centered=math('SUBTRACT',p,.5,(xpos,y))
        delta=math('MULTIPLY',r,k*depth,(xpos,y-95))
        travel=math('ADD',centered,delta,(xpos+180,y))
        fit=math('MULTIPLY',travel,spread,(xpos+360,y))
        return math('ADD',fit,.5,(xpos+540,y))
    a=shift(u,rx,1/1.24,20)
    b=shift(v,rz,-1/1.45,20)
    comb=node('ShaderNodeCombineXYZ','Ray intersection UV',(750,y))
    apply(a,comb.inputs[0]);apply(b,comb.inputs[1])
    n=node('ShaderNodeTexImage',f'{depth:.2f} BU virtual depth',(950,y));n.image=img;n.extension='CLIP';n.interpolation='Linear'
    nt.links.new(comb.outputs[0],n.inputs[0]);return n
def color_mix(f,a,b,xy,label):
    n=node('ShaderNodeMixRGB',label,xy);apply(f,n.inputs[0]);apply(a,n.inputs[1]);apply(b,n.inputs[2]);return n.outputs[0]
wall,mid,front=[lookup(a,d,s,j) for j,(a,d,s) in enumerate(zip(imgs,(1.20,.38,.045),(.64,1.0,1.0)))]
cavity=(.012,.010,.008,1)
start=color_mix(wall.outputs['Alpha'],cavity,wall.outputs['Color'],(1240,480),'Dark cavity outside rear wall')
body=color_mix(mid.outputs['Alpha'],start,mid.outputs['Color'],(1460,290),'Engine cover and intake')
rgba=color_mix(front.outputs['Alpha'],body,front.outputs['Color'],(1680,140),'Foreground headers')
em=node('ShaderNodeEmission','Baked lighting only',(1900,180));apply(rgba,em.inputs[0]);em.inputs[1].default_value=.88
tr=node('ShaderNodeBsdfTransparent','No portal outside rear view',(1900,-30))
sw=node('ShaderNodeMixShader','Rear rays only',(2110,180));apply(geo.outputs['Backfacing'],sw.inputs[0]);apply(em.outputs[0],sw.inputs[1]);apply(tr.outputs[0],sw.inputs[2])
end=node('ShaderNodeOutputMaterial','Aperture surface',(2320,180));apply(sw.outputs[0],end.inputs['Surface'])
m.surface_render_method='DITHERED'
chair['engine_bay']='Rear-only virtual depth sampled through the existing physical opening (no extra external geometry).'
chair['virtual_depth_bu']=1.20
chair['physical_backrest_thickness_bu']=.365
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
