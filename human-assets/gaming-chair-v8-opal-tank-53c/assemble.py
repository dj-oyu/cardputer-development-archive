"""Bundle exact v52 physical scene + untouched tube + offline editable engine scene."""
import bpy, sys
from pathlib import Path
P=Path(__file__).resolve().parent;out=P/'human-chair-engine-v8-53c.blend'
s=bpy.context.scene;n=next(o for o in s.objects if o.name.startswith('Rear aperture')).active_material.node_tree
for nd in n.nodes:
 if nd.type=='MIX_RGB' and nd.label.startswith(('04 /','05 /')):
  for link in list(nd.inputs[0].links):n.links.remove(link)
  nd.inputs[0].default_value=0
with bpy.data.libraries.load(str(P/'virtual-engine-v8-53c.blend'),link=False) as (a,b):b.scenes=a.scenes
assert len(b.scenes)==1 and not any(o.name.startswith('Central transmission casting') for o in s.objects)
assert b.scenes[0].objects.get('Central transmission casting')
unused=bpy.data.collections.get('05 • Inspection reservoir (bake only)')
for o in list(unused.objects):bpy.data.objects.remove(o,do_unlink=True)
bpy.data.collections.remove(unused)
b.scenes[0].name='Virtual bay • authored opposed V8'
b.scenes[0]['scope']='Opposed V8 source; the original silver case and original blue bottle are editable packed atlases in this file, not modeled fictional glass.'
for name in ('legacy-case','original-reservoir','settled','left','right','bottle'):
 im=bpy.data.images.load(str(P/'textures'/f'{name}.png'),check_existing=False)
 im.name='53c legacy atlas • '+name; im.use_fake_user=True; im.pack()
for d in sorted((P/'assets').glob('rear_*')):
 for fn in ('layer_04.png','layer_05.png','full.png'):
  im=bpy.data.images.load(str(d/fn),check_existing=False);im.name=f'v53 fixed camera proof / {d.name} / {fn}';im.use_fake_user=True;im.pack()
for d in sorted((P/'phase-assets').glob('rear_*')):
 for f in sorted(d.glob('*.png')):
  im=bpy.data.images.load(str(f),check_existing=False);im.name=f'v53 tank crop / {d.name} / {f.stem}';im.use_fake_user=True;im.pack()
s['v53_preview_contract']='Physical scene keeps unmodified chair exterior. Use per-view PNG proof bundles for matching composite. Slot 04 is an offline 3D bake; slot 05 reuses the legacy alpha silhouette and camera-registered map; real-time flipbook is not implemented by this .blend.'
bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(out),compress=True)
