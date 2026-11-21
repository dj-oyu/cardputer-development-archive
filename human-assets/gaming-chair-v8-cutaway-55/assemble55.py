import bpy,sys
from pathlib import Path
P=Path(__file__).resolve().parent
phys=bpy.context.scene
retired=next(a for a in bpy.data.scenes if 'authored opposed V8' in a.name)
bpy.data.scenes.remove(retired)
with bpy.data.libraries.load(str(P/'virtual-cutaway-v8-55.blend'),link=False) as (a,b):b.scenes=a.scenes
assert len(b.scenes)==1 and not any('common floating crankpin' in o.name for o in phys.objects)
for d in sorted((P/'engine-phase-assets').glob('rear_*')):
 for f in sorted(d.glob('*.png')):
  im=bpy.data.images.load(str(f),check_existing=False);im.name=f'55 V8 slot04 {d.name} phase {f.stem}';im.use_fake_user=True;im.pack()
phys['v55_runtime_contract']='Physical scene unchanged, cutaway is a separate offline virtual scene. Selected camera and independent engine crank, bottle bubble and tank slosh phases are compiled plates. Slot 04 holds the engine; slot 05 unchanged.'
phys['v55_dims']='One shared 90-degree V8 with true slider crank, eight authored cylinders and 120-frame loop. No ignition model.'
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(P/'human-chair-engine-v8-55.blend'),compress=True)
