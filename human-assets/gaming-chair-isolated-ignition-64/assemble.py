import bpy
from pathlib import Path
P=Path(__file__).resolve().parent
s=bpy.context.scene
with bpy.data.libraries.load(str(P.parent/'chair-engine-v8-63'/'source-test-63.blend'),link=False) as (a,b):b.scenes=a.scenes
assert len(b.scenes)==1
b.scenes[0].name='Wrist pin source registration • offline diagnostic only'
for v in (P/'spark-crops').glob('rear_*'):
 for f in v.glob('*.png'):
  im=bpy.data.images.load(str(f),check_existing=False);im.use_fake_user=True;im.pack()
  im.name=f'v64 localized engine only / {v.name} / {f.stem}'
s['v64']='Only the tiny existing contact-light cue on slot 04 at the near wrist pin. Existing geometry, original animated crank/slosh/bottle tracks unchanged. No remote animated light.'
bpy.context.preferences.filepaths.save_version=0;bpy.ops.wm.save_as_mainfile(filepath=str(P/'human-chair-engine-v8-64.blend'),compress=True)
