"""Swap the one existing comic expression atlas in the combined v78."""
from pathlib import Path
import bpy,hashlib,os
P=Path(__file__).resolve().parent
original=Path(bpy.data.filepath)
assert hashlib.sha256(original.read_bytes()).hexdigest()=='61f1f78cd004c922e0f0ad2833bb1a5d08da6dd38156d51dc548863b0283ecb8'
s=bpy.context.scene
mat=s.objects['Sculpted cheeks, jaw and cranium'].data.materials[0]
ns=mat.node_tree.nodes
neutral=bytes(ns['Image Texture'].image.packed_file.data)
assert neutral==(P/'assets'/'neutral.png').read_bytes(),'Atlas source mismatch'
n=ns['Expression 3 gag']
assert n.image.name=='Packed face expression gag'
im=bpy.data.images.load(str(P/'assets'/'face-gekiga.png'), check_existing=True)
im.name='Packed face expression gekiga';im.pack();im.filepath='//face-gekiga.png'
n.image=im
n.label='Expression 3 — Gekiga · dramatic deadpan'
rig=next(o for o in s.objects if o.type=='ARMATURE')
assert rig['Face Expression']==0
rig.id_properties_ui('Face Expression').update(description='0 Neutral • 1 Worried • 2 Surprised • 3 Gekiga dramatic deadpan • 4 Sleepy. Legacy Blink and Smile remain independent.')
if 'Face Expression Atlas Select' in ns:ns['Face Expression Atlas Select'].label='FACE EXPRESSIONS – 0 Neutral · 1 困り · 2 驚き · 3 劇画 · 4 眠い'
s['v79_face_gag_instructions']='The Face Expression=3 atlas alone is replaced by dramatic serious brows/eyes and small warm angular cheek shade. No changes to geometry, other expressions, or comic symbols. Original v78 droplet, spiral, anger controls unchanged.'
# Preserve unassigned historical actions rather than letting Blender drop zero-user donor records.
for action in bpy.data.actions:
 if action.users==0: action.use_fake_user=True
bpy.context.preferences.filepaths.save_version=0
bpy.ops.wm.save_as_mainfile(filepath=os.getenv('GIRL79_OUTPUT',str(P/'girl-expressions-gekiga-v79.blend')),compress=True)
