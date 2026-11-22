"""Refine the sagittal silhouette without changing rig, mesh connectivity or front outline."""
import bpy, sys, hashlib, math, json
from pathlib import Path
from mathutils import Vector
src, dst = map(Path, sys.argv[-2:])
sha = '8c6721c4695b07ccef689c7fc03ce63e9ca306ab0ee777606d63d902a848afdb'
assert hashlib.sha256(src.read_bytes()).hexdigest() == sha
bpy.ops.wm.open_mainfile(filepath=str(src.resolve()))
scene = bpy.context.scene
scene.frame_set(1)
def bump(z, mid, width):
    t = abs(z-mid)/width
    return 0.0 if t >= 1 else (1-t*t)**2
def ramp(lo, hi, v):
    t = min(1., max(0., (v-lo)/(hi-lo)))
    return t*t*(3-2*t)
changes = {}
for ob in scene.objects:
    if ob.type != 'MESH' or not ob.modifiers.get('Provisional joint continuity'):
        continue
    group = ob.users_collection[0].name
    name = ob.name
    world = ob.matrix_world.copy()
    inverse = world.inverted()
    peak = count = 0
    for v in ob.data.vertices:
        x, y, z = world @ v.co
        d = 0.
        if group == 'Jacket and T-shirt':
            # Thorax bow, rear shoulder blade mass, and a narrower waist above the waistband.
            # Taper across shoulder/arm seam so cuff and joint anchors do not move.
            trunk = 1-ramp(.35,.64,abs(x))
            front, rear = 1-ramp(-.24,.01,y), ramp(.01,.27,y)
            d += trunk*(-.106*front*bump(z,3.57,.44)
                        + .111*rear*bump(z,3.76,.44)
                        - .091*rear*bump(z,3.22,.29)
                        + .059*front*bump(z,3.23,.24))
        elif group == 'Shorts':
            # Pelvis sits behind the lower rib cage; the seat peaks above the shorts hem.
            front, rear = 1-ramp(-.25,.01,y), ramp(.015,.29,y)
            d += (.033*bump(z,2.81,.44)+.078*rear*bump(z,2.73,.48)
                  -.036*front*bump(z,3.02,.22))
            # Shared centerline curve at thigh top/hem. Runs through adjoining skin below.
            d += .028*bump(z,2.40,.39)
        elif name.startswith('Thigh to shin continuous leg'):
            center = .075 if x < 0 else -.055
            anterior, posterior = 1-ramp(-.10,.025,y-center), ramp(.025,.16,y-center)
            d += (.028*bump(z,2.40,.39)  # connect to shorts, not separate clothing scale
                  -.041*bump(z,2.02,.44)
                  -.041*anterior*bump(z,1.46,.25)
                  +.032*posterior*bump(z,1.70,.31)
                  +.070*posterior*bump(z,1.14,.38)
                  -.025*anterior*bump(z,1.10,.36))
        if abs(d) > 1e-6:
            v.co = inverse @ Vector((x,y+d,z))
            peak=max(peak,abs(d)); count+=1
    if count:
        changes[name]={'vertices':int(count),'max_depth_edit':round(peak,6)}
scene['profile_anatomy_pass']='Sagittal forms (thorax, lumbar, pelvis, leg masses) at edited mesh without rig changes. Fixed front/oblique/profile pose checks.'
dst = dst.resolve()
dst.parent.mkdir(parents=True, exist_ok=True)
bpy.ops.wm.save_as_mainfile(filepath=str(dst),compress=True)
(dst.parent/'profile-edit.json').write_text(json.dumps({'source_sha256':sha,'saved_sha256':hashlib.sha256(dst.read_bytes()).hexdigest(),'changes':changes},indent=2)+'\n')
