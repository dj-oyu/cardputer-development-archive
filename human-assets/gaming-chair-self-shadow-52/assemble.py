"""Add isolated true-depth tube scene without linking any tube object into the chair scene."""
import bpy,sys
from pathlib import Path
out=Path(sys.argv[-1]).resolve()
from pathlib import Path
virtual=Path(__file__).resolve().parent/'virtual-tube-52.blend'
physical=bpy.context.scene;physical.name='Cardputer seated chair • physical aperture only'
c=bpy.data.collections['Gaming Chair Prop']
portal=next(o for o in c.objects if o.name.startswith('Rear aperture'))
tree=portal.active_material.node_tree
for node in tree.nodes:
 if node.type=='MIX_RGB' and node.label.startswith(('06 /','08 /')):
    for link in list(node.inputs[0].links):tree.links.remove(link)
    node.inputs[0].default_value=0
with bpy.data.libraries.load(str(virtual),link=False) as (fr,to):
    to.scenes=fr.scenes
assert len(to.scenes)==1
scene=to.scenes[0];scene.name='Virtual engine volume • relit swept tube and solid sockets'
assert physical.objects.get('Intake • one round continuous path through real depth') is None
assert scene.objects.get('Intake • one round continuous path through real depth') is not None
for folder in sorted((virtual.parent/'assets').glob('rear_*')):
    for file in ("mask.png","layer_08.png","full.png"):
        img=bpy.data.images.load(str(folder/file),check_existing=False)
        img.name=f"v52 proof {folder.name} / {file}";img.use_fake_user=True;img.pack()
physical['rear_v52']='Tube is from separate true depth scene; per-angle mask bake composes the optic, never link virtual solids into the physical scene.'
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
