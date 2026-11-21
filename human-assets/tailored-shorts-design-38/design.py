"""Procedural flush interior details, based on the approved tailored shorts illustration."""
import bpy,sys,hashlib,numpy as np
from pathlib import Path
a,b=map(Path,sys.argv[-2:])
assert hashlib.sha256(a.read_bytes()).hexdigest()=='4d223a8e65bdc8a81088e3d15a4d8c04b268e1f67ae007ce8de864155e89a0d4'
bpy.ops.wm.open_mainfile(filepath=str(a.resolve()),use_scripts=False)
m=bpy.data.objects['Waist and seat'].data
prev=bpy.data.images['Tailored shorts | stitch and slit mask'];W,H=prev.size
im=bpy.data.images.new('Tailored shorts | flush tailoring v38',width=W,height=H,alpha=True)
im.colorspace_settings.name='Non-Color'
Y,X=np.mgrid[0:H,0:W].astype('float32');I=np.ones((H,W),dtype='float32')
def pt(x,z,back):
 return(W*((.5 if back else 0)+.040+.42*(x+.6)/1.2),H*(.03+.94*(z-2.32)/.92))
def line(path,back,w,depth):
 for a,b in zip(path,path[1:]):
  x0,y0=pt(*a,back);x1,y1=pt(*b,back)
  t=np.clip(((X-x0)*(x1-x0)+(Y-y0)*(y1-y0))/((x1-x0)**2+(y1-y0)**2),0,1)
  d=((X-x0-t*(x1-x0))**2+(Y-y0-t*(y1-y0))**2)
  I[:]=np.minimum(I,1-depth*np.exp(-d/(2*w*w)))
def attach(mesh, allow_original):
 uv=mesh.uv_layers.get('Tailored seams | front and back') or mesh.uv_layers.new(name='Tailored seams | front and back')
 if not allow_original:
  for p in mesh.polygons:
   back=sum(mesh.vertices[j].co.y for j in p.vertices)/len(p.vertices)>.045
   for l in p.loop_indices:
    x,y,z=mesh.vertices[mesh.loops[l].vertex_index].co
    u,v=pt(x,z,back);uv.data[l].uv=u/W,v/H
 for i,old in enumerate(list(mesh.materials)):
  mat=old.copy();mat.name=old.name+' | V38 close tailoring';mesh.materials[i]=mat
  nodes=mat.node_tree.nodes
  tex=next((n for n in nodes if n.type=='TEX_IMAGE' and n.image==prev),None)
  if tex is not None:tex.image=im;continue
  links=mat.node_tree.links;bs=next(n for n in nodes if n.type=='BSDF_PRINCIPLED');sock=bs.inputs['Base Color']
  tex=nodes.new('ShaderNodeTexImage');tex.image=im;tex.extension='EXTEND'
  uvn=nodes.new('ShaderNodeUVMap');uvn.uv_map=uv.name;links.new(uvn.outputs['UV'],tex.inputs['Vector'])
  mix=nodes.new('ShaderNodeMixRGB');mix.blend_type='MULTIPLY';mix.inputs[0].default_value=1
  mix.inputs[1].default_value=tuple(sock.default_value)
  if sock.is_linked:links.new(sock.links[0].from_socket,mix.inputs[1])
  links.new(tex.outputs['Color'],mix.inputs[2]);links.new(mix.outputs[0],sock)
for s in (-1,1):
 # Folded belt-loop edges retain a quiet slightly narrower inner track.
 line([(s*.158,3.192),(s*.161,3.126),(s*.170,3.059),(s*.191,3.052),(s*.184,3.122),(s*.181,3.192)],False,1.24,.48)
 # The neutral slit is one strong edge and its quieter parallel stitch.
 line([(s*.162,3.081),(s*.210,2.990),(s*.297,2.876),(s*.415,2.749)],False,2.05,.65)
 line([(s*.184,3.074),(s*.231,2.985),(s*.318,2.873),(s*.429,2.751)],False,.9,.36)
 # Back darts fade over their final stitch.
 for i,(start,end) in enumerate(zip((3.080,3.02,2.96),(3.02,2.96,2.897))):
  x0=s*(.143+.052*(3.08-start)/.183);x1=s*(.143+.052*(3.08-end)/.183)
  line([(x0,start),(x1,end)],True,(1.3,1.15,.9)[i],(.56,.44,.29)[i])
 # Slightly arced top stitch tracks each hem edge.
 for back in (False,True):
  line([(s*.045,2.446),(s*.147,2.444),(s*.255,2.447),(s*.381,2.458),(s*.505,2.475)],back,1.1,.43)
 # Four tight bartack end dots hint at craftsmanship, but do not dominate native view.
 for x in (s*.416,s*.423):
  line([(x,2.748),(x,2.755)],False,.85,.44)
line([(0,3.085),(0,2.920),(0,2.685),(0,2.620)],False,1.23,.51)
line([(.086,3.075),(.086,2.865),(.083,2.817),(.066,2.784),(.036,2.764),(.008,2.761)],False,1.21,.47)
line([(0,3.085),(0,2.905),(0,2.739),(0,2.615)],True,1.36,.53)
for back in (False,True):
 line([(-.357,3.079),(0,3.073),(.357,3.079)],back,1.0,.37)
rgba=np.ones((H,W,4),dtype='float32');rgba[:,:,:3]=I[:,:,None]
im.pixels.foreach_set(rgba.ravel());im.update();im.pack()
attach(m,True)
attach(bpy.data.objects['Topstitched waistband'].data,False)
bpy.ops.wm.save_as_mainfile(filepath=str(b.resolve()),compress=True)
