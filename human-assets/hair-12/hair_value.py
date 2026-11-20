"""V12: preserve PVC base volumes; exchange two temple pieces for tapered ahoge-derived shapes."""
import bpy,sys,hashlib,json,math
from array import array
from mathutils import Vector
from pathlib import Path
src,dst=map(lambda p:Path(p).resolve(),sys.argv[-2:])
assert hashlib.sha256(src.read_bytes()).hexdigest()=='4fce580da8b9cf7801c0107a6d7f80fb035ce1939cb7d569c2eaa378da65b9c8'
bpy.ops.wm.open_mainfile(filepath=str(src));scene=bpy.context.scene;scene.frame_set(1)
col=bpy.data.collections['Hair – sculpted locks']; front=Vector((0,-1,0))
objs=list(col.objects)
tuft=bpy.data.objects['Little lifted crown tuft']
def centerline(o,k=10):
 return [sum((v.co for v in o.data.vertices[i:i+k]),Vector())/k for i in range(0,len(o.data.vertices),k)]
def basis(c,j):
 t=(c[min(j+1,len(c)-1)]-c[max(j-1,0)]).normalized()
 u=t.cross(front).normalized()
 return t,u,u.cross(t).normalized()
ref=centerline(tuft)
def replace(oldname,path,scale):
 old=bpy.data.objects[oldname];new=tuft.copy();new.data=tuft.data.copy();col.objects.link(new)
 new.name=oldname+'.ahoge';tar=list(map(Vector,path));matrix=new.matrix_world
 for v,d in zip(new.data.vertices,tuft.data.vertices):
    i=v.index//10
    st,su,sv=basis(ref,i);tt,tu,tv=basis(tar,i);q=d.co-ref[i]
    v.co=tar[i]+scale[i]*(tt*q.dot(st)+tu*q.dot(su)+tv*q.dot(sv))
 bpy.data.objects.remove(old,do_unlink=True)
 new.name=oldname
 return new
replace('Left swept temple curl',[(-.465,-.127,5.035),(-.541,-.155,4.860),(-.612,-.212,4.671),(-.549,-.255,4.504),(-.420,-.269,4.442)],[1.30,1.34,1.65,1.45,1.05])
replace('Right framing curl',[(.535,-.113,5.041),(.612,-.143,4.854),(.654,-.196,4.656),(.586,-.263,4.508),(.475,-.278,4.431)],[1.35,1.28,1.63,1.48,.95])
objs=list(col.objects)
def uv_map(o,k):
 m=o.data
 uv=m.uv_layers.get('MoldedHair_PaintedFlow')
 if uv is None: uv=m.uv_layers.new(name='MoldedHair_PaintedFlow')
 n=len(m.vertices)//k
 for p in m.polygons:
    ids=[m.loops[i].vertex_index for i in p.loop_indices]
    cs=[j%k for j in ids];cap=len(ids)==k;seam=0 in cs and k-1 in cs and not cap
    for i,j in zip(p.loop_indices,ids):
      uv.data[i].uv=((.5 if cap else (k if seam and j%k==0 else j%k)/k),(j//k)/(n-1))
 return uv.name
def smooth(a,b,x):
 t=max(0,min(1,(x-a)/(b-a)));return t*t*(3-2*t)
def mix(a,b,k):
 return tuple(x*(1-k)+y*k for x,y in zip(a,b))
def dist(a,b):return abs((a-b+.5)%1-.5)
root=dst.parent;texdir=root/'value_textures';texdir.mkdir(exist_ok=True,parents=True)
for idx,o in enumerate(objs):
 cap=o.name.startswith('Bob')
 k=16 if cap else 10
 n=len(o.data.vertices)//k
 name=uv_map(o,k)
 ring=list(o.data.vertices[k*(n//2):k*(n//2+1)])
 ctr=sum((v.co for v in ring),Vector())/k
 f=min(range(k),key=lambda j:ring[j].co.y)/k
 # Existing warm read, enhanced with separated broad designerly value masses:
 # dark underside, mid body, one coherent light patch. One wide rear patch arcs from crown to side.
 colors=((45,25,19),(72,44,32),(101,60,42)) if cap else ((49,27,20),(77,43,31),(112,66,46))
 m=o.data.materials[0].copy();m.name='Chestnut values · '+o.name;o.data.materials[0]=m
 p=next(n for n in m.node_tree.nodes if n.type=='BSDF_PRINCIPLED')
 p.inputs['Roughness'].default_value=.72;p.inputs['Specular IOR Level'].default_value=.23
 nodes=m.node_tree.nodes
 for no in list(nodes):
    if no.type in {'TEX_IMAGE','UVMAP'}:nodes.remove(no)
 im=bpy.data.images.new('Chestnut values · '+o.name,128,128,alpha=False,float_buffer=False)
 px=array('f')
 for y in range(128):
    v=(y+.5)/128
    if cap:
       hc=.340-.142*v+.026*math.sin(2*v*math.pi)
       dc=.034+.096*v+.020*math.sin(2*v*math.pi)
       width=.032+.029*math.sin(v*math.pi)
       vfade=smooth(.075,.22,v)*(1-smooth(.82,.98,v))
    else:
       side=-1 if 'Left' in o.name else 1
       hc=f+side*(.125-.145*v*v)
       dc=f+.42-.12*v
       width=.076+.057*math.sin(v*math.pi)
       vfade=smooth(.018,.19,v)*(1-smooth(.79,.98,v))
    for x in range(128):
       u=(x+.5)/128
       a=(1-smooth(width-.012,width+.006,dist(u,hc)))*vfade
       d=(1-smooth(.158,.192,dist(u,dc)))*(.78+.20*(1-v))
       colr=mix(mix(colors[1],colors[0],d),colors[2],a)
       px.extend([c/255 for c in colr]+[1.])
 im.pixels.foreach_set(px);im.update();im.file_format='PNG'
 fn=f'hair-value-{idx:02d}.png'
 im.filepath_raw=str(texdir/fn);im.save();im.pack();im.filepath='//value_textures/'+fn
 tex=nodes.new('ShaderNodeTexImage');tex.image=im;tex.extension='REPEAT';tex.label='Three large warm-brown value regions'
 uv=nodes.new('ShaderNodeUVMap');uv.uv_map=name
 m.node_tree.links.new(uv.outputs['UV'],tex.inputs['Vector']);m.node_tree.links.new(tex.outputs['Color'],p.inputs['Base Color'])
# Retired hair paint is not a production dependency.
for mat in list(bpy.data.materials):
 if mat.name.startswith('Painted chestnut · '):
  assert not any(mat in list(o.data.materials) for o in scene.objects if o.type=='MESH' and o not in objs)
  bpy.data.materials.remove(mat,do_unlink=True)
for im in list(bpy.data.images):
 if im.name.startswith('Flow · '): bpy.data.images.remove(im,do_unlink=True)
bpy.ops.wm.save_as_mainfile(filepath=str(dst),compress=True)
