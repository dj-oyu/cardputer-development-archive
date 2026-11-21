import bpy
from pathlib import Path
P=Path(__file__).resolve().parent;s=bpy.context.scene
with bpy.data.libraries.load(str(P/'source-test-60.blend'),link=False) as (a,b):b.scenes=a.scenes
assert len(b.scenes)==1
b.scenes[0].name='Light transport probe • actual hose shadow, white case receiver'
for d in sorted((P/'tank-reflection-crops').glob('rear_*')):
 for f in d.rglob('delta-*.png'):
  if f.parent!=d:continue
  i=bpy.data.images.load(str(f),check_existing=False)
  i.name=f'v60 white case replaces v59 case / {d.name} / {f.stem}'
  i.use_fake_user=True;i.pack()
s['v60']='Visible white case lift and static hose occluder shadow, fixed-angle color bakes only. The source-test scene is isolated and does not add geometry or emitter to the physical scene. Replace only the v59 case delta, not its clamp/cable effects.'
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=str(P/'human-chair-engine-v8-60.blend'),compress=True)
