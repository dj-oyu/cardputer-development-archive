"""Set two sewn welt pockets into the jacket's surface and keep one snap row."""
import bpy,sys,hashlib,numpy as np
from pathlib import Path
a,b=map(Path,sys.argv[-2:])
assert hashlib.sha256(a.read_bytes()).hexdigest()=='fda94f8b8e115755eead12a8efb5603bace67331cabc0a30125ee3f2815de8b0'
bpy.ops.wm.open_mainfile(filepath=str(a.resolve()),use_scripts=False)
o=bpy.data.objects
remove=[n for n in o.keys() if n.startswith(('Ivory diagonal varsity pocket welt.','Matte metal snap.L'))]
assert len(remove)==6
for n in remove:bpy.data.objects.remove(o[n],do_unlink=True)
W,H=512,512
Y,X=np.mgrid[0:H,0:W].astype('float32')
X=(X+.5)/W*.60;Z=3.20+(Y+.5)/H*.6
# Pocket opening: subtle fabric lip on each bank, with a dark interior
# and rounded taper at the ends. Everything follows sewn face topology.
x0,z0=.254,3.357;x1,z1=.330,3.583
dx=x1-x0;dz=z1-z0;nn=(dx*dx+dz*dz)**.5
t=((X-x0)*dx+(Z-z0)*dz)/(nn*nn)
p=((X-x0)*dz-(Z-z0)*dx)/nn
end=np.minimum(np.clip(t/.10,0,1),np.clip((1-t)/.10,0,1))
A=np.zeros((H,W,4),dtype='float32')
def band(center,sigma,weight,col):
 global A
 g=(weight*end*np.exp(-.5*((p-center)/sigma)**2)).astype('float32')
 oa=A[:,:,3].copy();ra=g+oa*(1-g)
 A[:,:,:3]=(np.array(col)[None,None,:]*g[:,:,None]+A[:,:,:3]*(oa*(1-g))[:,:,None])/np.maximum(1e-8,ra[:,:,None])
 A[:,:,3]=ra
band(0,.021,.60,(.018,.023,.015))
band(-.012,.0050,.77,(.34,.265,.145))
band(.013,.0046,.47,(.108,.096,.061))
band(0,.0082,.92,(.005,.009,.006))
im=bpy.data.images.new('Forest jacket | inset pocket welts v40',width=W,height=H,alpha=True)
im.colorspace_settings.name='Linear Rec.709';im.pixels.foreach_set(A.ravel());im.update();im.pack()
for name in ('Jacket cut front and back','Jacket cut front and back.001'):
 m=o[name].data
 uv=m.uv_layers.new(name='Sewn pocket face')
 for f in m.polygons:
  mid=sum(m.vertices[i].co.y for i in f.vertices)/len(f.vertices)
  for l in f.loop_indices:
   x,y,z=m.vertices[m.loops[l].vertex_index].co
   uv.data[l].uv=(abs(x)/.60 if mid<-.12 else .005,(z-3.20)/.60)
 mat=m.materials[0].copy();mat.name='Forest green wool | flush welts';m.materials[0]=mat
 nd=mat.node_tree.nodes;ln=mat.node_tree.links
 tx=nd.new('ShaderNodeTexImage');tx.image=im;tx.extension='EXTEND'
 u=nd.new('ShaderNodeUVMap');u.uv_map=uv.name;ln.new(u.outputs['UV'],tx.inputs['Vector'])
 mix=nd.new('ShaderNodeMixRGB');bs=next(n for n in nd if n.type=='BSDF_PRINCIPLED');sock=bs.inputs['Base Color']
 mix.inputs[1].default_value=tuple(sock.default_value)
 if sock.is_linked:ln.new(sock.links[0].from_socket,mix.inputs[1])
 ln.new(tx.outputs['Alpha'],mix.inputs[0]);ln.new(tx.outputs['Color'],mix.inputs[2]);ln.new(mix.outputs[0],sock)
bpy.ops.wm.save_as_mainfile(filepath=str(b.resolve()),compress=True)
