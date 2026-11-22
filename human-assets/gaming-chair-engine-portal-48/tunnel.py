"""Replace the three physical cards by a back-only, ray-projected shallow-surface portal."""
import bpy,sys
from pathlib import Path
out=Path(sys.argv[-1]).resolve()
chair=bpy.data.collections['Gaming Chair Prop']
far=next(o for o in chair.objects if o.name.startswith('Rear aperture'))
imgs=[next(n.image for n in far.active_material.node_tree.nodes if n.type=='TEX_IMAGE' and n.image.name.startswith(name)) for name in ('engine-wall','engine-mid','engine-front')]
assert len(imgs)==3 and all(i.packed_file for i in imgs)
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
# UV-space ray slopes. The far room is rectangular and physically intersects no chair mesh.
wall,mid,front=[lookup(a,d,s,j) for j,(a,d,s) in enumerate(zip(imgs,(2.85,.52,.065),(.93,.89,1.0)))]
def M(o,x,y,label=''):
    i=len(nt.nodes); return math(o,x,y,(-80+((i-38)%12)*185,-840-((i-38)//12)*210),label)
du=M('DIVIDE',rx,1.24);dv=M('DIVIDE',rz,-1.45)
far_depth=2.85
def boundary(p,dp,low,high):
    pos=M('GREATER_THAN',dp,0)
    target=M('ADD',low,M('MULTIPLY',pos,high-low))
    return M('DIVIDE',M('ABSOLUTE',M('SUBTRACT',target,p),0),M('MAXIMUM',M('ABSOLUTE',dp,0),.001))
du_t=boundary(u,du,-.035,1.035)
dv_t=boundary(v,dv,-.035,1.035)
d=M('MINIMUM',du_t,dv_t,'First intersection with virtual sidewall or floor')
d=M('MINIMUM',d,far_depth)
is_side=M('LESS_THAN',du_t,dv_t)
xhit=M('ADD',u,M('MULTIPLY',d,du))
zhit=M('ADD',v,M('MULTIPLY',d,dv))
decay=M('DIVIDE',1,M('ADD',1,M('MULTIPLY',d,.62)))
def stripe(p,center,width):
    return M('LESS_THAN',M('ABSOLUTE',M('SUBTRACT',p,center),0),width)
ribs=M('LESS_THAN',M('FRACT',M('MULTIPLY',d,2.15),0),.12,'Repeating ribs shrink toward the virtual far wall')
floor_lines=M('MAXIMUM',stripe(xhit,.18,.016),stripe(xhit,.82,.016))
wall_lines=M('MAXIMUM',stripe(zhit,.19,.017),stripe(zhit,.69,.017))
lines=M('ADD',floor_lines,M('MULTIPLY',is_side,M('SUBTRACT',wall_lines,floor_lines)))
rib=color_mix(M('MULTIPLY',ribs,decay),(.020,.025,.028,1),(.15,.17,.178,1),(1000,-1120),'Receding structural ribs')
hall=color_mix(M('MULTIPLY',lines,decay),rib,(.33,.30,.22,1),(1240,-1020),'Floor rails and side ledges')
back=color_mix(wall.outputs['Alpha'],(.018,.020,.022,1),wall.outputs['Color'],(1240,480),'Baked far bulkhead')
start=color_mix(M('GREATER_THAN',d,far_depth-.002),hall,back,(1440,480),'Choose the first tunnel boundary')
body=color_mix(M('MULTIPLY',mid.outputs['Alpha'],M('GREATER_THAN',d,.52)),start,mid.outputs['Color'],(1460,290),'Engine cover and intake')
rgba=color_mix(M('MULTIPLY',front.outputs['Alpha'],M('GREATER_THAN',d,.065)),body,front.outputs['Color'],(1680,140),'Foreground headers')
em=node('ShaderNodeEmission','Baked lighting only',(1900,180));apply(rgba,em.inputs[0]);em.inputs[1].default_value=.88
tr=node('ShaderNodeBsdfTransparent','No portal outside rear view',(1900,-30))
sw=node('ShaderNodeMixShader','Rear rays only',(2110,180));apply(geo.outputs['Backfacing'],sw.inputs[0]);apply(em.outputs[0],sw.inputs[1]);apply(tr.outputs[0],sw.inputs[2])
end=node('ShaderNodeOutputMaterial','Aperture surface',(2320,180));apply(sw.outputs[0],end.inputs['Surface'])
m.surface_render_method='DITHERED'
chair['engine_bay']='Rear-only virtual depth sampled through the existing physical opening (no extra external geometry).'
chair['virtual_depth_bu']=2.85

bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
