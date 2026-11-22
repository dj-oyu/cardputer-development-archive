"""Remove the secondary crown tuft: exactly six logical hair pieces."""
import bpy,sys,hashlib,json
from pathlib import Path
s,d=map(lambda p:Path(p).resolve(),sys.argv[-2:])
assert hashlib.sha256(s.read_bytes()).hexdigest()=='b728291f155a68f421c297df54c904e0300e11cf75d251f93459b9fd6f10be33'
bpy.ops.wm.open_mainfile(filepath=str(s),use_scripts=False)
h=bpy.data.collections['Hair – sculpted locks']
def tris(o):
 o.data.calc_loop_triangles();return len(o.data.loop_triangles)
before={o.name:tris(o) for o in h.objects}
extra=bpy.data.objects['Outer light airy tuft'];m=extra.data
bpy.data.objects.remove(extra,do_unlink=True)
if not m.users:bpy.data.meshes.remove(m)
after={o.name:tris(o) for o in h.objects}
assert len(after)==6 and sum(after.values())==812
bpy.ops.wm.save_as_mainfile(filepath=str(d),compress=True)
(d.parent/'hair-parts.json').write_text(json.dumps({'base_sha256':hashlib.sha256(s.read_bytes()).hexdigest(),'out_sha256':hashlib.sha256(d.read_bytes()).hexdigest(),'counts_before':before,'counts_after':after,'before':sum(before.values()),'after':sum(after.values())},ensure_ascii=False,indent=2)+'\n')
