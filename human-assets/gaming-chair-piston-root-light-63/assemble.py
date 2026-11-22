import bpy
from pathlib import Path
P=Path(__file__).resolve().parent
s=bpy.context.scene
old=next((v for v in bpy.data.scenes if v.name.startswith('Light transport probe')),None)
if old:bpy.data.scenes.remove(old)
with bpy.data.libraries.load(str(P/'source-test-63.blend'),link=False) as (a,b):b.scenes=a.scenes
assert len(b.scenes)==1
b.scenes[0].name='Wrist-pin light probe • V8 casting/hose/case'
for v in (P/'phase-assets').glob('rear_*'):
 for f in v.rglob('*.png'):
  im=bpy.data.images.load(str(f),check_existing=False);im.use_fake_user=True;im.pack()
  im.name=f'v63 wrist pin / {v.name} / {f.parent.name} / {f.stem}'
s['v63']='Source returned to wheel-nearest piston—rod wrist-pin join on each bank. Isolated projected lighting plates only; do not stack prior v57–62 ignition overlays. Motion tracks independent and unchanged.'
bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(P/'human-chair-engine-v8-63.blend'),compress=True)
