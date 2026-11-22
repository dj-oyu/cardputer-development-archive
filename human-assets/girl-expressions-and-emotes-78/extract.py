import bpy,json,os
from pathlib import Path
p=Path(__file__).resolve().parent
q=p/'assets';q.mkdir(exist_ok=True)
s=bpy.context.scene;o=s.objects['Sculpted cheeks, jaw and cranium'];m=o.data.materials[0]
for key,n in [('neutral','Image Texture'),('blink','Image Texture.001'),('smile','Image Texture.002')]:
 t=m.node_tree.nodes[n].image; (q/(key+'.png')).write_bytes(bytes(t.packed_file.data))
print('SCNE',s.get('face_expression_slots'));print('CONTROL',[(x.name,dict(x.items())) for x in s.objects if any('blink' in k.lower() or 'smile' in k.lower() for k in x.keys())])
for d in m.node_tree.animation_data.drivers:
 print('DRIVER',d.data_path,[(v.name,[(t.id.name,t.data_path) for t in v.targets if t.id]) for v in d.driver.variables])
ns=m.node_tree.nodes
for l in m.node_tree.links:
 if l.from_node.name in ['Image Texture','Mix (Legacy).001'] or l.to_node.name in ['Mix (Legacy).001','Mix','Mix (Legacy).002','Mix.001']:
  print(l.from_node.name,l.from_socket.name,l.to_node.name,l.to_socket.name)
