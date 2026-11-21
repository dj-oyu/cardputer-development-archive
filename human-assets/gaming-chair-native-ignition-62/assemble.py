import bpy
from pathlib import Path
P=Path(__file__).resolve().parent;s=bpy.context.scene
for d in sorted((P/'tank-reflection-crops').glob('rear_*')):
 for f in sorted(d.glob('*.png')):
  im=bpy.data.images.load(str(f),check_existing=False);im.use_fake_user=True;im.pack()
  im.name=f'v62 case luminance + shadow / {d.name} / {f.stem}'
s['v62']='Native 240x135 stylized shoulder illumination and wider cast shadow. Signed positive-minus-negative maps replace v60 only; unchanged physical scene, no real device validation.'
bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(P/'human-chair-engine-v8-62.blend'),compress=True)
